	lw	1, 0, data1		# $1 = mem[data1]
	lw	2, 0, data2		# $2 = mem[data2]
	lw	6, 0, data6		# $6 = mem[data6]
	lw	7, 0, data7		# $7 = mem[data7]
	add	2, 1, 0		# $2 = $1 + $0
	add	7, 1, 2		# $7 = $1 + $2
	bne	2, 0, branch1		# taken
	nop	
	nop	
	lw	1, 0, data5		# $1 = mem[data5]
branch1:	lw	1, 0, data6		# $1 = mem[data6]
	halt	
data1:	.fill	12345
data2:	.fill	32767
data3:	.fill	0
data4:	.fill	4581
data5:	.fill	1
data6:	.fill	2893
data7:	.fill	23
data8:	.fill	2
data8a:	.fill	0
data8b:	.fill	20348
