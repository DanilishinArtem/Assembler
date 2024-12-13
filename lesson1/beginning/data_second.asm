section .data
	num1 DB 1
	num2 DB 2

section .text
global _start

_start:
	; ebx - all 32 bits, bx - 16 bits, bl/bh - 8 bits.
	MOV bl, [num1]
	MOV cl, [num2]
	MOV eax, 1
	INT 80h
