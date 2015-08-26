.global _start
.global main
_start:
	/* max memory = (0x4000 >> 2) * 4 = 16K */
	li sp, 0x10004000
	jal main