ORG 0x7c00
BITS 16

main:
    MOV ax, 0
    MOV ds, ax ; data segment
    MOV es, ax ; extra data segment
    MOV ss, ax  ; stack segment

    MOV sp, 0x7c00 ; stack pointer
    MOV si, os_boot_msg
    CALL print
    HLT

halt:
    JMP halt

print:
    PUSH si
    PUSH ax
    PUSH bx

print_loop:
    LODSB ; load a single byte
    OR al, al
    JZ done_print

    MOV ah, 0x0E ; print a character to the screen
    MOV bh, 0 ; page number as an argument
    INT 0x10 ; video interapt

    JMP print_loop

done_print:
    POP bx
    POP ax
    POP si
    RET

os_boot_msg: DB 'Our OS has booted!', 0x0D, 0x0A, 0

TIMES 510-($-$$) DB 0
DW 0AA55h