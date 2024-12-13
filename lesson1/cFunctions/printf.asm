; example of using printf
; printf(format, value)
extern printf
extern exit

section .data
    ; Define Doubleword (4 bytes), ending by zero - standart ending of the string
    msg1 DD "Hello, world!", 0
    msg2 DD "This is test!", 0
    ; Define Byte - series of bytes
    fmt DB "Output is: %s %s", 10, 0
section .text

global main

main:
    PUSH msg2
    PUSH msg1
    PUSH fmt
    CALL printf
    PUSH 1
    CALL exit