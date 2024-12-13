; https://faculty.nps.edu/cseagle/assembly/sys_call.html - table of system calls
section .data
    pathname DD "/home/adanilishin/assembler/lesson1/openAndReadFiles/myFile.txt"
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
    ; part of reading file
    MOV ebx, eax
    MOV eax, 3
    MOV ecx, buffer
    MOV edx, 1024
    INT 80h
    ; part of exit
    MOV eax, 1
    MOV ebx, 0
    INT 80h