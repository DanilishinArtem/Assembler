section .data
    pathname DB "/home/adanilishin/assembler/lesson1/openAndReadFiles/createFile/temp.txt",0
    toWrite DB "Hello world!",0AH,0DH,"$"
section .text
global main

main:
    MOV eax, 5
    MOV ebx, pathname
    MOV ecx, 101o ; octupus format
    MOV edx, 700o ; 00700 user (file owner) has read, write, and execute permission
    INT 80h
    ; part to write to the file
    MOV ebx, eax
    MOV eax, 4
    MOV ecx, toWrite
    MOV edx, 15
    INT 80h
    ; part to exit call
    MOV eax, 1
    MOV ebx, 0
    INT 80h

