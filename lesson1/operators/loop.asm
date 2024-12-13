section .data
    list DB 1,2,3,4

section .text
global _start

_start:
    MOV eax, 0
    MOV cl, 0

loop:
    MOV bl, [list + eax]
    MOV cl, bl
    INC eax
    CMP eax,4
    JE _end
    JMP loop

_end:
    MOV eax, 1
    MOV ebx, 1
    INT 80h