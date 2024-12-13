section .text
global _start

_start:
    MOV al, 2
    MOV bl, 3
    MUL bl ; only reqire one operand (as it uses accumulator register ax for multiplication)
    ; IMUL - sighned multiplication
    INT 80h