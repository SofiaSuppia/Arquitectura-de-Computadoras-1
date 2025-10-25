.section .data
numeros: .dword 2, 5, 8, 7, 4

.section .text
LDR X0, =numeros
MOV X1, #0
MOV X2, #0
bucle:
CMP X2, #5
BEQ fin
LDR X3, [X0, X2, LSL #3]
ANDS X4, X3, #1
BNE siguiente
ADD X1, X1, X3
siguiente:
ADD X2, X2, #1
B bucle
fin:
STR X1, [X0, #20]

infloop: B infloop
