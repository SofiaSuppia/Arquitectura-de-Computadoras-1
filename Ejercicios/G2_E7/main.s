	.data
	// Variables definidas en .data
	i: .dword 0
	j: .dword 0
	a: .dword 1,2,3,4,5,6,7,8
	c: .dword 0,0,0,0,0,0,0,0
	.text
	LDR X3, i
	LDR x4, j
	LDR x6, =a
	LDR x7, =c

	sub x8, x3, x4
	lsl x9, x8, #3
	ldr x10, [x6, x9]
	movz x11, #64
	str x10, [x7, x11]
end:
infloop: B infloop
