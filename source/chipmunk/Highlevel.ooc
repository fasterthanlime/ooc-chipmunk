
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

}

Body: class {

    cpBody: CpBody

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
        cpBody = CpBody new(mass, moment)
    }

    // internals
    init: func ~fromBody (=cpBody)

}

Shape: abstract class {

    cpShape: CpShape

    init: func (=cpShape)

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

