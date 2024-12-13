section .text
global _start

_start:
    MOV eax, 11
    MOV ecx, 2
    DIV ecx ; result in eax = 5, and 1 will be in edx register
    ; IMUL - sighned multiplication
    INT 80h