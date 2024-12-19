ORG 0x7c00
BITS 16

JMP SHORT main
NOP

bdb_oem:                     DB  'MSWIN4.1'
bdb_bytes_per_sector:        DW  512
bdb_sectors_per_cluster:     DB  1
bdb_reserved_sectors:        DW  1
bdb_fat_count:               DB  2
bdb_dir_entries_count:       DW  0E0h
bdb_total_sectors:           DW  2880
bdb_media_descriptor_type:   DB  0F0h
bdb_sectors_per_fat:         DW  9
bdb_sectors_per_track:       DW  18
bdb_heads:                   DW  2
bdb_hidden_sectors:          DD  0
bdb_large_sector_count:      DD  0

ebr_drive_number:            DB  0
                             DB  0
ebr_signature:               DB  29h
ebr_volume_id:               DB  12h,34h,56h,78h
ebr_volume_label:            DB  'JAZZ OS    '
ebr_system_id:               DB  'FAT12   '


main:
    MOV ax, 0
    MOV ds, ax ; data segment
    MOV es, ax ; extra data segment
    MOV ss, ax  ; stack segment

    MOV sp, 0x7c00 ; stack pointer

    MOV [ebr_drive_number], dl
    MOV ax, 1
    MOV cl, 1
    MOV bx, 0x7E00
    CALL disk_read

    MOV si, os_boot_msg
    CALL print
    HLT

halt:
    JMP halt

; input: LBA index in ax
; cx [bits 0-5]: sector number
; cx [bits 6-15]: cylinder
; dh: head
lba_to_chs:
    PUSH ax
    PUSH dx
    XOR dx, dx
    DIV word [bdb_sectors_per_track] ; (LBA % sectors per track) + 1 -> sector
    ; остаток от деления лежит в dx
    INC dx
    MOV cx, dx ; Sector
    XOR dx, dx
    ; head: (LBA / sectors_per_track) % number_of_heads
    ; sylinder: (LBA / sectors_per_track) / number_of_heads
    ; at the register i store (LBA / sectors_per_track), so i need to divide ax by number_of_heads
    ; and sylinder will be stored at ax, and head at dx
    DIV word [bdb_heads]
    MOV dh, dl ; head
    MOV ch, al
    SHL ah, 6
    OR cl, ah ; cylinder

    POP ax
    MOV dl, al
    POP ax
    RET

disk_read:
    PUSH ax
    PUSH bx
    PUSH cx
    PUSH dx
    PUSH di

    CALL lba_to_chs

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