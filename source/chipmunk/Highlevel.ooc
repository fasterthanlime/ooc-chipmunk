
use chipmunk
import chipmunk

ShapePair: cover {
    a, b: Shape
}

BodyPair: cover {
    a, b: Body
}

Arbiter: class {

    cpArbiter: CpArbiter

    init: func {}

    contactCount: Int {
        get { cpArbiter getContactPointSet() count }
    }

    getContact: func (index: Int) -> CpContactPoint {
        cpSet := cpArbiter getContactPointSet()
        p: CpContactPoint
        memcpy(p&, cpSet points + index, CpContactPoint size)
        p
    }

    restitution: Double {
        get { cpArbiter getRestitution() }
        set (f) { cpArbiter setRestitution(f) }
    }

    friction: Double {
        get { cpArbiter getFriction() }
        set (f) { cpArbiter setFriction(f) }
    }

    shapes: ShapePair {
        get {
            a, b: CpShape
            cpArbiter getShapes(a&, b&)
            ash := a getUserData() as Shape
            bsh := b getUserData() as Shape
            (ash, bsh) as ShapePair
        }
    }

    bodies: BodyPair {
        get {
            a, b: CpBody
            cpArbiter getBodies(a&, b&)
            abo := a getUserData() as Body
            bbo := b getUserData() as Body
            (abo, bbo) as BodyPair
        }
    }

}

shapeQueryThunk: func (shape: CpShape, points: CpContactPointSet, data: Pointer) {
    closure := (data as Closure*)@
    callback := closure as Func(CpShape, CpContactPointSet)
    callback(shape, points)
}

Space: class {

    cpSpace: CpSpace
    staticBody: Body
    arbiter := Arbiter new()

    userData: Pointer {
        get { cpSpace getUserData() }
        set (p) { cpSpace setUserData(p) }
    }

    iterations: Int {
        get { cpSpace getIterations() }
        set(i) { cpSpace setIterations(i) }
    }

    gravity: CpVect {
        get { cpSpace getGravity() }
        set(g) { cpSpace setGravity(g) }
    }

    collisionBias: CpFloat {
        get { cpSpace getCollisionBias() }
        set(f) { cpSpace setCollisionBias(f) }
    }

    collisionPersistence: CpFloat {
        get { cpSpace getCollisionPersistence() }
        set(f) { cpSpace setCollisionPersistence(f) }
    }

    collisionSlop: CpFloat {
        get { cpSpace getCollisionSlop() }
        set(f) { cpSpace setCollisionSlop(f) }
    }

    currentTimeStep: Double {
        get { cpSpace getCurrentTimeStep() }
    }

    init: func {
        cpSpace = CpSpace new()
        userData = this
        staticBody = Body new(cpSpace getStaticBody())
    }

    free: func {
        cpSpace free()
    }

    step: func (timeStep: Double) {
        cpSpace step(timeStep)
    }

    addBody: func (body: Body) -> Body {
        cpSpace addBody(body cpBody)
        body
    }

    removeBody: func (body: Body) {
        cpSpace removeBody(body cpBody)
    }

    addShape: func (shape: Shape) -> Shape {
        cpSpace addShape(shape cpShape)
        shape
    }

    removeShape: func (shape: Shape) {
        cpSpace removeShape(shape cpShape)
    }

    addCollisionHandler: func (type1: UInt, type2: UInt, handler: CollisionHandler) {
        cpSpace addCollisionHandler(type1, type2, handler)
    }

    shapeQuery: func (shape: Shape, callback: Func (CpShape, CpContactPointSet)) -> Bool {
        data := gc_malloc(Closure size) as Closure*
        memcpy(data, (callback as Closure)&, Closure size)
        cpSpace shapeQuery(shape cpShape, shapeQueryThunk, data)
    }

}

HlCollisionHandler: class extends CpCollisionHandler {

    arbiter := Arbiter new()

    onBegin: Func (Arbiter) -> Bool
    onPreSolve: Func (Arbiter) -> Bool
    onPostSolve: Func (Arbiter)
    onSeparate: Func (Arbiter)

    init: func {}

    begin: func (cpArbiter: CpArbiter, space: CpSpace) -> Bool {
        c := onBegin as Closure
        if (!c thunk) {
            return true
        }

        arbiter cpArbiter = cpArbiter
        onBegin(arbiter)
    }

    preSolve: func (cpArbiter: CpArbiter, space: CpSpace) -> Bool {
        c := onPreSolve as Closure
        if (!c thunk) {
            return true
        }

        arbiter cpArbiter = cpArbiter
        onPreSolve(arbiter)
    }

    postSolve: func (cpArbiter: CpArbiter, space: CpSpace) {
        c := onPostSolve as Closure
        if (!c thunk) {
            return
        }

        arbiter cpArbiter = cpArbiter
        onPostSolve(arbiter)
    }

    separate: func (cpArbiter: CpArbiter, space: CpSpace) {
        c := onSeparate as Closure
        if (!c thunk) {
            return
        }

        arbiter cpArbiter = cpArbiter
        onSeparate(arbiter)
    }

}

Body: class {

    cpBody: CpBody

    userData: Pointer {
        get { cpBody getUserData() }
        set (p) { cpBody setUserData(p) }
    }

    inert: Bool {
        get { cpBody isStatic() }
    }

    pos: CpVect {
        get { cpBody getPosition() }
        set (p) { cpBody setPosition(p) }
    }

    vel: CpVect {
        get { cpBody getVelocity() }
        set (v) { cpBody setVelocity(v) }
    }

    angle: Double {
        get { cpBody getAngle() }
        set (a) { cpBody setAngle(a) }
    }

    applyImpulseAtWorldPoint: func (impulse, offset: CpVect) {
        cpBody applyImpulseAtWorldPoint(impulse, offset)
    }

    applyImpulseAtLocalPoint: func (impulse, offset: CpVect) {
        cpBody applyImpulseAtLocalPoint(impulse, offset)
    }

    init: func (mass, moment: Double) {
        init(CpBody new(mass, moment))
    }

    init: func ~inert {
        init(CpBody newStatic())
    }

    // internals
    init: func ~fromBody (=cpBody) {
        userData = this
    }

}

Shape: abstract class {

    cpShape: CpShape

    init: func (=cpShape) {
        userData = this
    }

    collisionType: UInt {
        get { cpShape getCollisionType() }
        set (t) { cpShape setCollisionType(t) }
    }

    sensor: Bool {
        get { cpShape getSensor() }
        set (s) { cpShape setSensor(s) }
    }

    filter: CpShapeFilter {
        get { cpShape getFilter() }
        set (g) { cpShape setFilter(g) }
    }

    userData: Pointer {
        get { cpShape getUserData() }
        set (p) { cpShape setUserData(p) }
    }

    elasticity: Double {
        get { cpShape getElasticity() }
        set(e) { cpShape setElasticity(e) }
    }

    friction: Double {
        get { cpShape getFriction() }
        set(f) { cpShape setFriction(f) }
    }

    surfaceVelocity: CpVect {
        get { cpShape getSurfaceVelocity() }
        set (v) { cpShape setSurfaceVelocity(v) }
    }

    body: Body {
        get {
            cpBody := cpShape getBody()
            if (cpBody) {
                return cpBody getUserData() as Body
            }
            null
        }
        set(b) { cpShape setBody(b cpBody) }
    }

}

PolyShape: class extends Shape {

    init: func (body: Body, numVerts: Int, verts: CpVect*, transform: CpTransform, radius: CpFloat) {
        super(CpPolyShape new(body cpBody, numVerts, verts, transform, radius))
    }

}

BoxShape: class extends Shape {

    init: func (body: Body, width, height: Double, radius: CpFloat) {
        super(CpBoxShape new(body cpBody, width, height, radius))
    }

}

CircleShape: class extends Shape {

    init: func (body: Body, radius: Double, offset: CpVect) {
        super(CpCircleShape new(body cpBody, radius, offset))
    }

    offset: CpVect {
        get { (cpShape as CpCircleShape) getOffset() }
    }

    radius: Double {
        get { (cpShape as CpCircleShape) getRadius() }
    }

}

SegmentShape: class extends Shape {

    init: func (body: Body, a, b: CpVect, radius: Double) {
        super(CpSegmentShape new(body cpBody, a, b, radius))
    }

    setNeighbors: func (a, b: CpVect) {
        (cpShape as CpSegmentShape) setNeighbors(a, b)
    }

    a: CpVect {
        get { (cpShape as CpSegmentShape) getA() }
    }

    b: CpVect {
        get { (cpShape as CpSegmentShape) getB() }
    }

}

CpUtils: class {

    // vectors

    cpv: static func (x, y: Double) -> CpVect {
        (x, y) as CpVect
    }

    // moments

    momentForBox: static func (mass, width, height: Double) -> Double {
        cpMomentForBox(mass, width, height)
    }

    momentForCircle: static func (mass: Double, innerRadius: Double, outerRadius: Double, offset: CpVect) -> Double {
        cpMomentForCircle(mass, innerRadius, outerRadius, offset)
    }

    momentForSegment: static func (mass: Double, a, b: CpVect, radius: CpFloat) -> Double {
        cpMomentForSegment(mass, a, b, radius)
    }

    momentForPoly: static func (mass: Double, numVerts: Int, verts: CpVect*, offset: CpVect, radius: CpFloat) -> Double {
        cpMomentForPoly(mass, numVerts, verts, offset, radius)
    }

    identity := static cpTransformIdentity

}

