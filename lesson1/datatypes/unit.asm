; bss (block starting symbol) - this data is not initialized
section .bss
    ; Reserve 3 bytes
    num RESB 3

; part of initialization
section .data
    num2 DB 3 DUP(2)

section .text
global _start

_start:
    MOV bl, 1
    MOV bl, [num2]
    ; move from bl to num (also can be MOV [num + 1], bl or any k MOV [num + k], bl)
    MOV [num], bl
    MOV [num+1], bl
    MOV [num+2], bl
    MOV eax, 1
    INT 80h