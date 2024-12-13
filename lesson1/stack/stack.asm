segment .data
segment .text

global main

addTwo:
    PUSH ebp ; put ebp to the heap of the stack
    MOV ebp, esp ; right down heap of the esp to the register ebp
    MOV eax, [ebp+8] ; getting datas by using register ebp and shifting
    MOV ebx, [ebp+12] ; getting datas by using register ebp and shifting
    ADD eax, ebx
    POP ebp ; return source datas to the ebp from the heap of the stack esp
    RET

main:
    PUSH 4
    PUSH 1
    CALL addTwo
    MOV ebx, eax
    MOV eax, 1
