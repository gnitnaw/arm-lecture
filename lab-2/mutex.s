	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ INSERT CODE BELOW

	@ DEFINE r1 = 1
	MOV r1, #1
.L0:
	@ Load and monitor the value at the memory pointed by r6 to r2
	LDREX r2, [r6]

	@ Compare the value of r2 and 1
	CMP r2, #1

	@ If r2 != 1
	@ Then lock r2 and put the value = 1
	STREXNE r2, r1, [r6]

	@ Check if r2 is lock
	CMP r2, #1

	@ If r2 is still not 1
	@ Retry
	BNE .L0

	@ Required before accessing protected resource
	DMB

        @ END CODE INSERT
	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	@ INSERT CODE BELOW
	@ Ensure accesses to protected resource have completed
        DMB

	@ Define r1 = 0
	MOV r1, #0

	@ Send the value@r1 to the memory pointed by r6
	STR r1, [r6]

	@ Ensure update of the mutex occurs before other CPUs wake
	DSB

	@ Send event to other cpu
	SEV
 
        @ END CODE INSERT
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
