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
cpvtoangle: extern func (v: CpVect) -> CpFloat
cpvforangle: extern func (angle: CpFloat) -> CpVect

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
    newStatic: extern (cpBodyNewStatic) static func -> This

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
    removeBody: extern(cpSpaceRemoveBody) func (constraint: CpBody)

    addShape: extern(cpSpaceAddShape) func (shape: CpShape) -> CpShape
    removeShape: extern(cpSpaceRemoveShape) func (constraint: CpShape)

    addConstraint: extern(cpSpaceAddConstraint) func (constraint: CpConstraint) -> CpConstraint
    removeConstraint: extern(cpSpaceRemoveConstraint) func (constraint: CpConstraint)

    addCollisionHandler: func (type1: CpCollisionType, type2: CpCollisionType, handler: CpCollisionHandler) {
        cpSpaceAddCollisionHandler(
            this, 
            type1,
            type2,
            collisionBeginFuncThunk,
            collisionPreSolveFuncThunk,
            collisionPostSolveFuncThunk,
            collisionSeparateFuncThunk,
            handler
        )
    }
    removeCollisionHandler: extern(cpSpaceRemoveCollisionHandler) func (type1: CpCollisionType, type2: CpCollisionType)

    shapeQuery: extern(cpSpaceShapeQuery) func (shape: CpShape, callback: Pointer, userData: Pointer) -> Bool

    step: extern(cpSpaceStep) func (timeStep: CpFloat)

}

cpSpaceAddCollisionHandler: extern func (CpSpace, CpCollisionType, CpCollisionType, Pointer, Pointer, Pointer, Pointer, Pointer)

CpArbiter: cover from cpArbiter* {

    getShapes: extern(cpArbiterGetShapes) func (CpShape*, CpShape*)
    getBodies: extern(cpArbiterGetBodies) func (CpBody*, CpBody*)

    getElasticity: extern(cpArbiterGetElasticity) func -> CpFloat
    setElasticity: extern(cpArbiterSetElasticity) func (CpFloat)

    getFriction: extern(cpArbiterGetFriction) func -> CpFloat
    setFriction: extern(cpArbiterSetFriction) func (CpFloat)

    getUserData: extern(cpArbiterGetUserData) func -> Pointer
    setUserData: extern(cpArbiterSetUserData) func (Pointer)

}

CpCollisionHandler: class {

    begin: func (arb: CpArbiter, space: CpSpace) -> Bool {
        // overload at will!
        true
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

collisionBeginFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CpCollisionHandler) -> Bool {
    ch begin(arb, space)
}

collisionPreSolveFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CpCollisionHandler) -> Bool {
    ch preSolve(arb, space)
}

collisionPostSolveFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CpCollisionHandler) {
    ch postSolve(arb, space)
}

collisionSeparateFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CpCollisionHandler) {
    ch separate(arb, space)
}

CpBB: cover from cpBB {
    l, b, r, t: extern CpFloat

    new: extern(cpBBNew) static func (l: CpFloat, b: CpFloat, r: CpFloat, t: CpFloat) -> This

}

CpCollisionType: cover from UInt extends UInt {

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

    update: extern(cpShapeUpdate) func (pos: CpVect, rot: CpVect)

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
    new: static extern(cpBoxShapeNew2) func ~fromBB (body: CpBody, box: CpBB) -> This

}

CpConstraint: cover from cpConstraint* {

    newPivot: static extern(cpPivotJointNew) func (a: CpBody, b: CpBody, pivot: CpVect) -> This

    setMaxBias: extern(cpConstraintSetMaxBias) func (value: CpFloat)
    getMaxBias: extern(cpConstraintGetMaxBias) func -> CpFloat

}

CpPinJoint: cover from cpPinJoint* extends CpConstraint {

    new: static extern(cpPinJointNew) func (a: CpBody, b: CpBody, anchr1: CpVect, anchr2: CpVect) -> This

    setDist: extern(cpPinJointSetDist) func (dist: CpFloat)
    getDist: extern(cpPinJointGetDist) func -> CpFloat

}

CpRotaryLimitJoint: cover from cpRotaryLimitJoint* extends CpConstraint {

    new: static extern(cpRotaryLimitJointNew) func (a: CpBody, b: CpBody, min: CpFloat, max: CpFloat) -> This

    setMin: extern(cpRotaryLimitJointSetMin) func (val: CpFloat)
    getMin: extern(cpRotaryLimitJointGetMin) func -> CpFloat

    setMax: extern(cpRotaryLimitJointSetMax) func (val: CpFloat)
    getMax: extern(cpRotaryLimitJointGetMax) func -> CpFloat

}

