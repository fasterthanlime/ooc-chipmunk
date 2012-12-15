use chipmunk, math

include chipmunk/chipmunk

CpFloat: cover from Double extends Double

CpVect: cover from cpVect {
    x, y: extern CpFloat
}

CpMat2x2: cover from cpMat2x2 {
    // Row major [[a, b][c d]]
    a, b, c, d: extern CpFloat
}

CpTimestamp: cover from cpTimestamp extends UInt

cpv: extern func (x, y: CpFloat) -> CpVect
cpvzero: extern CpVect

cpMomentForCircle: extern func (mass: CpFloat, radius1: CpFloat, radius2: CpFloat, offset: CpVect) -> CpFloat 

cpAreaForCircle: extern func (radius1: CpFloat, radius2: CpFloat) -> CpFloat 

cpMomentForSegment: extern func (mass: CpFloat, a: CpVect, b: CpVect) -> CpFloat

cpAreaForSegment: extern func (a: CpVect, b: CpVect, radius: CpFloat) -> CpFloat

cpMomentForPoly: extern func (mass: CpFloat, numVerts: Int, verts: CpVect*, offset: CpVect) -> CpFloat

cpAreaForPoly: extern func (numVerts: Int, verts: CpVect*) -> CpFloat

cpCentroidForPoly: extern func (numVerts: Int, verts: CpVect*) -> CpVect

cpRecenterPoly: extern func (numVerts: Int, verts: CpVect*)

cpMomentForBox: extern func (mass: CpFloat, width: CpFloat, height: CpFloat) -> CpFloat

cpMomentForBox2: extern func (mass: CpFloat, box: CpBB) -> CpFloat

cpConvexHull: extern func (count: Int, verts: CpVect*, result: CpVect*, first: Int*, tolerance: CpFloat) -> Int

CpBody: cover from cpBody* {

    new: extern(cpBodyNew) static func (mass: CpFloat, momentum: CpFloat) -> This

    free: extern(cpBodyFree) func

    getMass: extern(cpBodyGetMass) func -> CpFloat
    setMass: extern(cpBodySetMass) func (CpFloat)

    getMoment: extern(cpBodyGetMoment) func -> CpFloat
    setMoment: extern(cpBodySetMoment) func (CpFloat)

    getPos: extern(cpBodyGetPos) func -> CpVect
    setPos: extern(cpBodySetPos) func (CpVect)

    getVel: extern(cpBodyGetVel) func -> CpVect
    setVel: extern(cpBodySetVel) func (CpVect)

    getForce: extern(cpBodyGetForce) func -> CpVect
    setForce: extern(cpBodySetForce) func (CpVect)

    getAngle: extern(cpBodyGetAngle) func -> CpFloat
    setAngle: extern(cpBodySetAngle) func (CpFloat)

    getAngVel: extern(cpBodyGetAngVel) func -> CpFloat
    setAngVel: extern(cpBodySetAngVel) func (CpFloat)

    getTorque: extern(cpBodyGetTorque) func -> CpFloat
    setTorque: extern(cpBodySetTorque) func (CpFloat)

    getRot: extern(cpBodyGetRot) func -> CpVect

    getVelLimit: extern(cpBodyGetVelLimit) func -> CpFloat
    setVelLimit: extern(cpBodySetVelLimit) func (CpFloat)

    getAngVelLimit: extern(cpBodyGetAngVelLimit) func -> CpFloat
    setAngVelLimit: extern(cpBodySetAngVelLimit) func (CpFloat)

    getUserData: extern(cpBodyGetUserData) func -> Pointer
    setUserData: extern(cpBodySetUserData) func (Pointer)

}

CpSpace: cover from cpSpace* {

    new: static extern(cpSpaceNew) func -> This

    free: extern(cpSpaceFree) func

    getIterations: extern(cpSpaceGetIterations) func -> Int
    setIterations: extern(cpSpaceSetIterations) func (Int)

    getGravity: extern(cpSpaceGetGravity) func -> CpVect
    setGravity: extern(cpSpaceSetGravity) func (CpVect)

    getDamping: extern(cpSpaceGetDamping) func -> CpFloat
    setDamping: extern(cpSpaceSetDamping) func (CpFloat)

    getIdleSpeedThreshold: extern(cpSpaceGetIdleSpeedThreshold) func -> CpFloat
    setIdleSpeedThreshold: extern(cpSpaceSetIdleSpeedThreshold) func (CpFloat)

    getSleepTimeThreshold: extern(cpSpaceGetSleepTimeThreshold) func -> CpFloat
    setSleepTimeThreshold: extern(cpSpaceSetSleepTimeThreshold) func (CpFloat)

    getCollisionSlop: extern(cpSpaceGetCollisionSlop) func -> CpFloat
    setCollisionSlop: extern(cpSpaceSetCollisionSlop) func (CpFloat)

    getCollisionBias: extern(cpSpaceGetCollisionBias) func -> CpFloat
    setCollisionBias: extern(cpSpaceSetCollisionBias) func (CpFloat)

    getCollisionPersistence: extern(cpSpaceGetCollisionPersistence) func -> CpFloat
    setCollisionPersistence: extern(cpSpaceSetCollisionPersistence) func (CpFloat)

    getEnableContactGraph: extern(cpSpaceGetEnableContactGraph) func -> Bool
    setEnableContactGraph: extern(cpSpaceSetEnableContactGraph) func (Bool)

    getData: extern(cpSpaceGetData) func -> Pointer
    setData: extern(cpSpaceSetData) func (Pointer)

    getStaticBody: extern(cpSpaceGetStaticBody) func -> CpBody

    getCurrentTimeStep: extern(cpSpaceGetCurrentTimeStep) func -> CpFloat

    addBody: extern(cpSpaceAddBody) func (body: CpBody) -> CpBody

    addShape: extern(cpSpaceAddShape) func (shape: CpShape) -> CpShape

    addConstraint: extern(cpSpaceAddConstraint) func (constraint: CpConstraint) -> CpConstraint

    step: extern(cpSpaceStep) func (timeStep: CpFloat)

}

CpBB: cover from cpBB {

}

CpCollisionType: cover from cpCollisionType {

}

CpGroup: cover from UInt extends UInt {

}

CpLayers: cover from UInt extends UInt {

}

CpShape: cover from cpShape* {

    free: extern(cpShapeFree) func

    getBB: extern(cpShapeGetBB) func -> CpBB

    getSensor: extern(cpShapeGetSensor) func -> Bool
    setSensor: extern(cpShapeSetSensor) func(Bool)

    getElasticity: extern(cpShapeGetElasticity) func -> CpFloat
    setElasticity: extern(cpShapeSetElasticity) func(CpFloat)

    getFriction: extern(cpShapeGetFriction) func -> CpFloat
    setFriction: extern(cpShapeSetFriction) func(CpFloat)

    getSurfaceVelocity: extern(cpShapeGetSurfaceVelocity) func -> CpVect
    setSurfaceVelocity: extern(cpShapeSetSurfaceVelocity) func(CpVect)

    getUserData: extern(cpShapeGetUserData) func -> Pointer
    setUserData: extern(cpShapeSetUserData) func(Pointer)

    getCollisionType: extern(cpShapeGetCollisionType) func -> CpCollisionType
    setCollisionType: extern(cpShapeSetCollisionType) func(CpCollisionType)

    getGroup: extern(cpShapeGetGroup) func -> CpGroup
    setGroup: extern(cpShapeSetGroup) func(CpGroup)

    getLayers: extern(cpShapeGetLayers) func -> CpLayers
    setLayers: extern(cpShapeSetLayers) func(CpLayers)

}

CpSegmentShape: cover from cpSegmentShape* extends CpShape {

    new: static extern(cpSegmentShapeNew) func (body: CpBody, a: CpVect, b: CpVect, radius: CpFloat) -> This

}

CpCircleShape: cover from cpCircleShape* extends CpShape {

    new: static extern(cpCircleShapeNew) func (body: CpBody, radius: CpFloat, offset: CpVect) -> This

    getOffset: extern(cpCircleShapeGetOffset) func -> CpVect

    getRadius: extern(cpCircleShapeGetRadius) func -> CpFloat

}

CpBoxShape: cover from cpPolyShape* extends CpShape {

    new: static extern(cpBoxShapeNew) func (body: CpBody, width: CpFloat, height: CpFloat) -> This

}

CpConstraint: cover from cpConstraint* {

    newPin: static extern(cpPinJointNew) func (a: CpBody, b: CpBody, anchr1: CpVect, anchr2: CpVect) -> This
    newRotaryLimit: static extern(cpRotaryLimitJointNew) func (a: CpBody, b: CpBody, min: CpFloat, max: CpFloat) -> This

}

