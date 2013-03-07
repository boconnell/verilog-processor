	lw	1, 0, data1		# $1 = mem[data1]
	lw	2, 0, data2		# $2 = mem[data2]
	nop	
	nop	
	nop	
	add	3, 1, 2		# $3 = $1 + $2
	add	4, 0, 2		# $4 = $2 + $0
	nop	
	nop	
	nop	
	add	4, 3, 4		# $4 = $3 + $4
	nop	
	nop	
	nop	
	sw	4, 0, data3		# mem[data3] = $4
	lw	2, 0, zero		# $2 = 0
	nop	
	nop	
	nop	
branch2:	lw	5, 2, data4		# $5 = mem[data4] (we know that $2=0)
	bne	2, 1, branch1		# branch taken
	nop	
	nop	
	nop	
	nop	
branch1:	lw	6, 0, data5
	bne	5, 5, branch2		# not taken
	nop	
	nop	
	nop	
	halt	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
data1:	.fill	12345
data2:	.fill	32767
data3:	.fill	0
data4:	.fill	4581
data5:	.fill	1
zero:	.fill	0
