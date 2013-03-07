# this is the beginning of physical page 03

	lui     r7, 0x0f00
	lw	r1, r7, 0
	halt

here04:   .space  256-here04
# this is the beginning of physical page 04

        .fill 0x2112

