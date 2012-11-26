use chipmunk

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

CpBodyT: cover from cpBody {
    
}

CpBody: cover from CpBodyT* {

}

CpSpace: cover from cpSpace {

    /// Destroy a cpSpace.
    new: static extern(cpSpaceNew) func -> This

    /// Destroy and free a cpSpace.
    destroy: extern(cpSpaceDestroy) func

    getIterations: extern(cpSpaceGetIterations) func -> Int
    setIterations: extern(cpSpaceSetIterations) func (Int)

    getGravity: extern(cpSpaceGetGravity) func -> CpVect
    setGravity: extern(cpSpaceSetGravity) func (CpVect)

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

}

CpSegmentShape: cover from cpSegmentShape* {

    new: static extern(cpSegmentShapeNew) func -> This

}

