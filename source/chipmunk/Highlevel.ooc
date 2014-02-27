
use chipmunk
import chipmunk

Space: class {

    cpSpace: CpSpace
    staticBody: Body

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

    addStaticShape: func (shape: Shape) -> Shape {
        cpSpace addStaticShape(shape cpShape)
        shape
    }

    removeShape: func (shape: Shape) {
        cpSpace removeShape(shape cpShape)
    }

    addCollisionHandler: func (type1: CpCollisionType, type2: CpCollisionType, handler: CpCollisionHandler) {
        cpSpace addCollisionHandler(type1, type2, handler)
    }

}

HlCollisionHandler: class extends CpCollisionHandler {

    onBegin: Func (Shape, Shape) -> Bool
    onPreSolve: Func (Shape, Shape) -> Bool
    onPostSolve: Func (Shape, Shape)
    onSeparate: Func (Shape, Shape)

    init: func {}

    begin: func (arb: CpArbiter, space: CpSpace) -> Bool {
        c := onBegin as Closure
        if (!c thunk) {
            return true
        }

        cpShape1, cpShape2: CpShape
        arb getShapes(cpShape1&, cpShape2&)
        onBegin(cpShape1 getUserData() as Shape, cpShape2 getUserData() as Shape)
    }

    preSolve: func (arb: CpArbiter, space: CpSpace) -> Bool {
        // overload at will!
        true
    }

    postSolve: func (arb: CpArbiter, space: CpSpace) {
        // overload at will!
    }

    separate: func (arb: CpArbiter, space: CpSpace) {
        // overload at will!
    }

}

Body: class {

    cpBody: CpBody

    userData: Pointer {
        get { cpBody getUserData() }
        set (p) { cpBody setUserData(p) }
    }

    pos: CpVect {
        get { cpBody getPos() }
        set (p) { cpBody setPos(p) }
    }

    vel: CpVect {
        get { cpBody getVel() }
        set (v) { cpBody setVel(v) }
    }

    angle: Double {
        get { cpBody getAngle() }
        set (a) { cpBody setAngle(a) }
    }

    init: func (mass, moment: Double) {
        init(CpBody new(mass, moment))
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

    userData: Pointer {
        get { cpShape getUserData() }
        set (p) { cpShape setUserData(p) }
    }

    friction: Double {
        get { cpShape getFriction() }
        set(f) { cpShape setFriction(f) }
    }

}

PolyShape: class extends Shape {

    init: func (body: Body, numVerts: Int, verts: CpVect*, offset: CpVect) {
        super(CpPolyShape new(body cpBody, numVerts, verts, offset))
    }

}

BoxShape: class extends Shape {

    init: func (body: Body, width, height: Double) {
        super(CpBoxShape new(body cpBody, width, height))
    }

}

SegmentShape: class extends Shape {

    init: func (body: Body, a, b: CpVect, radius: Double) {
        super(CpSegmentShape new(body cpBody, a, b, radius))
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

}

