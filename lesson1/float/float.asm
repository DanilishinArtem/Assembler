section .data
    x DD 3.14
    y DD 2.1

section .text
global _start

_start:
    ; MOVSS (move scaler single precision), for this format we have spetial registers [xmm0-xmm15]
    MOVSS xmm0, [x]
    MOVSS xmm1, [y]
    ADDSS xmm0, xmm1
    MOV ebx, 1
    INT 80h