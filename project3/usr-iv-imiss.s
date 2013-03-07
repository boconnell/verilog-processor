# this is the beginning of physical page 03

	lui     r7, 0x0f00
	jalr    r7, r7
	lui     r7, 0x0e00
	jalr    r7, r7
	lui     r7, 0x0d00
	jalr    r7, r7
	lui     r7, 0x0c00
	jalr    r7, r7
	lui     r7, 0x0b00
	jalr    r7, r7
	lui     r7, 0x0a00
	jalr    r7, r7
	halt

here04:   .space  256-here04
# this is the beginning of physical page 04

	addi	r2, r2, 2
        jalr    r0, r7

here05:   .space  512-here05
# this is the beginning of physical page 05

	addi	r3, r3, 3
        jalr    r0, r7

here06:   .space  768-here06
# this is the beginning of physical page 06

	addi	r4, r4, 4
        jalr    r0, r7

here07:   .space  1024-here07
# this is the beginning of physical page 07

	addi	r5, r5, 10
        jalr    r0, r7

here08:   .space  1280-here08
# this is the beginning of physical page 08

	addi	r6, r6, 11
        jalr    r0, r7

here09:   .space  1536-here09
# this is the beginning of physical page 09

	addi	r1, r1, 1
        jalr    r0, r7
