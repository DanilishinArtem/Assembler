section .data
section .text

global main

addTwo:
    ADD eax, ebx
    RET

main:
    MOV eax, 1
    MOV ebx, 2
    CALL addTwo
    ; we can look at the register esp for checking out adress of return out of the addTwo function
    MOV ebx, eax ; at the esp register we have adress of the next instruction that we should use when we'he done with the addTwo function
    MOV eax, 1
    INT 80h