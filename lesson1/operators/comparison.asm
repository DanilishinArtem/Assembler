section .text
global _start

_start:
    MOV eax, 2
    MOV ebx, 3
    CMP eax, ebx
    JL _lesser
    JMP _end

_lesser:
    MOV ecx, 1

_end:
    INT 80h