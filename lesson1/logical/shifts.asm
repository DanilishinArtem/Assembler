section .text
global _start

_start:
    MOV eax, 2
    SHR eax, 1 ; (0010 -> 0001) - operation of dividing by two
    MOV eax, 12
    SHL eax, 1 ; -> operation of multiplying by two
    INT 80h