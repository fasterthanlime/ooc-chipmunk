
/*
 * Ported from the Hello Chipmunk example at
 * http://chipmunk-physics.net/release/ChipmunkLatest-Docs/
 */

use chipmunk
import chipmunk

main: func {
    gravity := cpv(0, -100)

    // Create an empty space
    space := CpSpace new()
    space setGravity(gravity)

    // Add a static line segment shape for the ground.
    // We'll make it slightly tilted so the ball will roll off.
    // We attach it to space->staticBody to tell Chipmunk it shouldn't be movable.
    ground := CpSegmentShape new(space getStaticBody(), cpv(-20, 5), cpv(20, -5), 0)
    ground setFriction(1)
    space addShape(ground)

    // Now let's make a ball that falls onto the line and rolls off.
    // First we need to make a cpBody to hold the physical properties of the object.
    // These include the mass, position, velocity, angle, etc. of the object.
    // Then we attach collision shapes to the cpBody to give it a size and shape.
    radius: CpFloat = 5
    mass: CpFloat = 1

    // The moment of inertia is like mass for rotation
    // Use the cpMomentFor*() functions to help you approximate it. 
    moment := cpMomentForCircle(mass, 0, radius, cpvzero)

    // The cpSpaceAdd*() functions return the thing that you are adding.
    // It's convenient to create and add an object in one line.
    ballBody := space addBody(CpBody new(mass, moment))
    ballBody setPos(cpv(0, 15))

    // Now we create the collision shape for the ball.
    // You can create multiple collision shapes that point to the same body.
    // They will all be attached to the body and move around to follow it.
    ballShape := space addShape(CpCircleShape new(ballBody, radius, cpvzero))
    ballShape setFriction(0.7)

    // Now that it's all set up, we simulate all the objects in the space by
    // stepping forward through time in small increments called steps.
    // It is *highly* recommended to use a fixed size time step.
    timeStep: CpFloat = 1.0 / 60.0
    time: CpFloat = 0

    while(time < 2) {
	pos := ballBody getPos()
	vel := ballBody getVel()
	printf("Time is %5.2f. ballBody is at (%5.2f, %5.2f). It's velocity is (%5.2f, %5.2f)\n",
	  time, pos x, pos y, vel x, vel y
	)

	space step(timeStep)
	time += timeStep
    }

    // Clean up our objects and exit!
    ballShape free()
    ballBody free()
    ground free()
    space free()
}


