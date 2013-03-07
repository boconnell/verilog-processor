	lw	1, 0, data1		# $1 = mem[data1]
	lw	2, 0, data2		# $2 = mem[data2]
	nop	
	nop	
	nop	
	add	3, 1, 2		# $3 = $1 + $2
	add	4, 0, 2		# $4 = $2 + $3
	nop	
	nop	
	nop	
	add	4, 3, 4		# $4 = $3 + $4
	nop	
	nop	
	nop	
	sw	4, 0, data3		# mem[data3] = $4
	nand	2, 4, 0		# $2 = nand($4, $0) = 0xffffffff
	nop	
	nop	
	nop	
	nand	4, 4, 4		# $4 = nand($4, $4) = 0x0
	nop	
	nop	
	nop	
	lw	5, 2, data4		# $5 = mem[data4] (we know that $2=0)
	nop	
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
