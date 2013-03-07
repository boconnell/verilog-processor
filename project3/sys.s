#
# kernel save area & handlers
#

# here is an example of how you can use this area statically:

u_r1:	.fill	0
u_r2:	.fill	0
u_r3:	.fill	0
u_r7:	.fill	0

k_r1:	.fill	0
k_r2:	.fill	0
k_r3:	.fill	0
k_r7:	.fill	0

#
# now, we have to eat up enough empty space
# to get to the exception vector table, which
# begins at location 80
#

here1:	.space	80-here1

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
	.fill	tlbumiss
	.fill	tlbkmiss
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


#
# now comes the kernel's page table ...
# (unused for now)
#

	.space	64


#
# now comes the various root page tables
#

asid00:		.fill	0
asid01:		.fill	0
asid02:		.fill	0
asid03:		.fill	0
asid04:		.fill	0
asid05:		.fill	0
asid06:		.fill	0
asid07:		.fill	0
asid08:		.fill	0
asid09:		.fill	0x8002	# put user page table in PFN2
asid0a:		.fill	0
asid0b:		.fill	0
asid0c:		.fill	0
asid0d:		.fill	0
asid0e:		.fill	0
asid0f:		.fill	0

asid10:		.fill	0
asid11:		.fill	0
asid12:		.fill	0
asid13:		.fill	0
asid14:		.fill	0
asid15:		.fill	0
asid16:		.fill	0
asid17:		.fill	0
asid18:		.fill	0
asid19:		.fill	0
asid1a:		.fill	0
asid1b:		.fill	0
asid1c:		.fill	0
asid1d:		.fill	0
asid1e:		.fill	0
asid1f:		.fill	0

asid20:		.fill	0
asid21:		.fill	0
asid22:		.fill	0
asid23:		.fill	0
asid24:		.fill	0
asid25:		.fill	0
asid26:		.fill	0
asid27:		.fill	0
asid28:		.fill	0
asid29:		.fill	0
asid2a:		.fill	0
asid2b:		.fill	0
asid2c:		.fill	0
asid2d:		.fill	0
asid2e:		.fill	0
asid2f:		.fill	0

asid30:		.fill	0
asid31:		.fill	0
asid32:		.fill	0
asid33:		.fill	0
asid34:		.fill	0
asid35:		.fill	0
asid36:		.fill	0
asid37:		.fill	0
asid38:		.fill	0
asid39:		.fill	0
asid3a:		.fill	0
asid3b:		.fill	0
asid3c:		.fill	0
asid3d:		.fill	0
asid3e:		.fill	0
asid3f:		.fill	0

#
# PHYSICAL PAGE 1 begins here ...
#

#
# put the handlers all into physical page #1
#
error:	lli	r1,1
	bne	r0,r1,-1		# jumps to itself in an endless loop
					# this is added just to aid in debugging
		
trap_halt:	sys	MODE_HALT	# kills the machine
					# (in a real system, it would first shut down
					# all user processes gracefully, then sync the
					# file systems, etc. ... lastly, it would 
					# kill the machine)

tlbumiss:	addi	r1, r4, 0	# save PSR (mostly for the ASID)
		addi	r4, r0, 0	# wipe out ASID bits (set to asid=0)
		nop			# wait for it to take effect
		sw r7, r0, u_r7
		sw r3, r0, u_r3
		lw	r2, r3, 0	# get the PTE
		tlbw	r2, r3
		addi	r4, r1, 0	# restore PSR (mostly for the ASID)
		lw r7, r0, u_r7
		rfe	r7

invalid:	sys	MODE_PANIC9

tlbkmiss:	lw	r2, r3, 0	# get the PTE
		tlbw	r2, r3
		lw r3, r0, u_r3
		rfe	r7

#
# the user page table for ASID 9 will go into page 2
# (so skip the rest of page 1)
#

here2:		.space	512-here2

#
# PHYSICAL PAGE 2 begins here ...
#

#
# an example user page table (that works with usr-iii.s):
#

vpn00:		.fill	0x8003	# put VPN0 of the program into PFN3
vpn01:		.fill	0
vpn02:		.fill	0
vpn03:		.fill	0
vpn04:		.fill	0
vpn05:		.fill	0
vpn06:		.fill	0
vpn07:		.fill	0
vpn08:		.fill	0
vpn09:		.fill	0
vpn0a:		.fill	0x8009
vpn0b:		.fill	0x8008
vpn0c:		.fill	0x8007
vpn0d:		.fill	0x8006
vpn0e:		.fill	0x8005
vpn0f:		.fill	0x8004

#
# mark all the rest invalid for now ...

		.space 240
