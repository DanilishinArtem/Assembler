section .data
	; Define Double (DD)
	num DD 5

section .text
global _start

_start:
	MOV eax, 1
	; MOV ebx, num - i'll put address to the register ebx, MOV ebx, [num] - i'll put value from address num to the register
	MOV ebx, [num]
	INT 80h
