#
# first, allocate a big empty region for the bottom 64 words.
# in phase 1, this will be overwritten with user code, so we want to put
# any handlers further up in page 0, close to the vector tables
#

	.space	64

#
# in the next spot, put some of the handlers
#
error:	lli	r1,1
	bne	r0,r1,-1		# jumps to itself in an endless loop
					# this is added just to aid in debugging
		
trap_halt:	sys	MODE_HALT	# kills the machine
					# (in a real system, it would first shut down
					# all user processes gracefully, then sync the
					# file systems, etc. ... lastly, it would 
					# kill the machine)
		
#
# now, we have to eat up enough empty space
# to get to the exception vector table ... this
# should require only 13 spaces ("handlers" took 
# up only 3)
#

	.space	13

#
# now comes the IVT ... three groups of 16 addresses.
# first: the exceptions
# second: the interrupts
# third: the traps
#
# might as well fill them all in with "error" except the
# one that we want to implement, so we can catch it if we
# jump to the wrong place
#

#
# EXCEPTION VECTORS
#
	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error
#
# INTERRUPT VECTORS
#
	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error
#
# TRAP VECTORS
#
	.fill	error
	.fill	trap_halt
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error

	.fill	error
	.fill	error
	.fill	error
	.fill	error
