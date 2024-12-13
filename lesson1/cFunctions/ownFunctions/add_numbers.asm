extern add_numbers
extern exit

section .data
section .text

global main

main:
    PUSH 1
    PUSH 2
    CALL add_numbers
    PUSH eax ; result of function will be returned to the eax registry
    CALL exit