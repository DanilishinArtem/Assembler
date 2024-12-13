section .data
    x DD 3.14
    y DD 2.1

section .text
global _start

_start:
    MOVSS xmm0, [x]
    MOVSS xmm1, [y]
    ; comparison
    UCOMISS xmm0, xmm1
    ; JB (jump below), JA (jump above), JBE, JAE
    JA greater
    JMP end

greater:
    MOV ecx, 1

end:
    MOV eax, 1
    MOV ebx, 1
    INT 80h