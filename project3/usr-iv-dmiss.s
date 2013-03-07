# this is the beginning of physical page 03

	lui     r7, 0x0f00
	lw	r1, r7, 0
	lui     r7, 0x0e00
	lw	r2, r7, 0
	lui     r7, 0x0d00
	lw	r3, r7, 0
	lui     r7, 0x0c00
	lw	r4, r7, 0
	lui     r7, 0x0b00
	lw	r5, r7, 0
	lui     r7, 0x0a00
	lw	r6, r7, 0
	halt

here04:   .space  256-here04
# this is the beginning of physical page 04

        .fill 1

here05:   .space  512-here05
# this is the beginning of physical page 05

	.fill 2

here06:   .space  768-here06
# this is the beginning of physical page 06

	.fill 3

here07:   .space  1024-here07
# this is the beginning of physical page 07

	.fill 4

here08:   .space  1280-here08
# this is the beginning of physical page 08

	.fill 0x0c00

here09:   .space  1536-here09
# this is the beginning of physical page 09

	.fill 0x0b00
