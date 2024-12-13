section .text
global _start

_start:
	MOV eax, 0b1010
	MOV ebx, 0b1100
	AND eax, ebx
        MOV eax, 0b1010
        MOV ebx, 0b1100
	OR eax, ebx
	NOT eax ; operator NOT will not work, because it will flip all bits, so we should do it different

	; we should flip every element in register and then make a mask
	MOV eax, 0b1010 ; example of changing value from 10 (1010) to 5 (0101)
	NOT eax
	AND eax, 0x0000000F

	; example with XOR operator (1010 (10) XOR 1100 (12) => 0110 (6))
	MOV eax, 0b1010
	MOV ebx, 0b1100
	XOR eax, ebx
	INT 80h
