section .data
    pathname DD "/home/adanilishin/assembler/lesson1/openAndReadFiles/readLine/test.txt"
section .bss
    buffer: resb 1024
section .text
global main

main:
    ; part of openning file
    MOV eax, 5
    MOV ebx, pathname
    MOV ecx, 0
    INT 80h
    ; part of lseek calling | arguments: 1. file descripter, offset, whence
    MOV ebx, eax
    MOV eax, 19
    MOV ecx, 10
    MOV edx, 0
    INT 80h
    ; part of reading file
    MOV eax, 3
    MOV ecx, buffer
    MOV edx, 10
    INT 80h
    ; part of exit
    MOV eax, 1
    MOV ebx, 0
    INT 80h