	lw	1, 0, data1		# $1=mem[data1]
	lw	2, 0, data2		# $2=mem[data2]
	add	3, 1, 2		# $3=$1+$2
	sw	3, 0, ans1		# mem[ans1]=$3
	nand	4, 1, 2		# $4=nand($1,$2)
	sw	4, 0, ans2		# mem[answ]=$4
	bne	1, 1, nobeq		# should NOT be taken
	sw	1, 0, ans3
nobeq:	nop	
	lw	5, 0, index		# $5=mem[index]
	lw	7, 0, neg1		# $7 = -1
loop:	add	6, 6, 5		# $6=$6+$5
	add	5, 5, 7		# decrement $5
	bne	0, 5, loop		# if $5=0, stop the loop
endlp:	sw	6, 0, ans4
	lw	1, 0, addr1		# $1=mem[addr1]
	lw	4, 1, 17		# $4=mem[data3], tests lw/sw with numeric
	sw	4, 1, 28		# mem[ans5]=$4
	lw	1, 0, addr2		# $1=mem[addr2]
	lw	4, 1, -64		# $4=mem[data4], tests lw/sw with numeric
	sw	4, 1, -56		# mem[ans6]=$4
	bne	0, 4, 2		# tests branch with numeric + offset
	sw	4, 0, ans7		# should not be executed
end:	halt	
skip:	lw	1, 0, data5		# $1=mem[data5]
	sw	1, 0, ans8		# mem[ans8] = $1;
	bne	0, 1, -4		# tests branch with numeric - offset
	sw	4, 0, ans9		# should not be executed
	halt	
data1:	.fill	29395
data2:	.fill	32767
data3:	.fill	10
data4:	.fill	20
data5:	.fill	-5
index:	.fill	3
addr1:	.fill	15
addr2:	.fill	100
neg1:	.fill	-1
ans1:	.fill	0		# should be 2122815
ans2:	.fill	0		# should be -28737
ans3:	.fill	0		# should be 29395
ans4:	.fill	0		# should be 6
ans5:	.fill	0		# should be 10
ans6:	.fill	0		# should be 20
ans7:	.fill	0		# should be 0
ans8:	.fill	0		# should be -5
ans9:	.fill	0		# should be 0
