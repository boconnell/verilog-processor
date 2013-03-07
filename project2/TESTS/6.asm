	lw	1, 0, data1		# $1 = mem[data1]
	lw	2, 0, data2		# $2 = mem[data2]
	nop	
	nop	
	nop	
	add	3, 1, 2		# $3 = $1 + $2
	nop	
	nand	4, 3, 2		# $4 = $3 nand $2  HAZARD
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
