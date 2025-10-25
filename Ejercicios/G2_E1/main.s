	.data
	f: .dword 0
	g: .dword 1
	h: .dword 2
	
	.text
	ldr x0, f
	ldr x1, g
	ldr x2, h
	
	sub x0, x2, #5
	add x0, x1, x0

end:
infloop: B infloop
