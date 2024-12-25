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

    ; 4 segments
    ; reserved segment: 1 sector (bdb_reserved_sectors)
    ; FAT (file allocation table): 9 * 2 (bdb_sectors_per_fat * bdb_fat_count) = 18 sectors
    ; Root directory: 
    ; Data
    MOV ax, [bdb_sectors_per_fat]
    MOV bl, [bdb_fat_count]
    XOR bh, bh
    MUL bx
    ADD ax, [bdb_reserved_sectors] ; LBA of the root directory
    PUSH ax
    MOV ax, [bdb_dir_entries_count]
    SHL ax, 5 ; ax *= 32
    XOR dx, dx
    DIV word [bdb_bytes_per_sector] ; (32 * num_of_entries) / bytes_per_sector
    TEST dx, dx
    JZ rootDirAfter
    INC ax

rootDirAfter:
    MOV cl, al
    POP ax
    MOV dl, [ebr_drive_number]
    MOV bx, buffer
    CALL disk_read
    XOR bx, bx
    MOV di, buffer

searchKernel:
    MOV si, file_kernel_bin
    MOV cx, 11
    PUSH di
    REPE CMPSB ; repeat comparison of bytes between file_kernel_bin and di
    POP di
    JE foundKernel

    ADD di, 32
    INC bx
    CMP bx, [bdb_dir_entries_count]
    JL searchKernel

    JMP kernelNotFound

foundKernel:
    MOV ax, [di+26] ; di - address of the kernel (26 - offset of the first logical cluster field)
    MOV [kernel_cluster], ax
    MOV ax, [bdb_reserved_sectors]
    MOV bx, buffer
    MOV cl, [bdb_sectors_per_fat]
    MOV dl, [ebr_drive_number]
    CALL disk_read

    MOV bx, kernel_load_segment
    MOV es, bx
    MOV bx, kernel_load_offset

loadKernelLoop:
    MOV ax, [kernel_cluster]
    ADD ax, 31
    MOV cl, 1
    MOV dl, [ebr_drive_number]
    CALL disk_read
    ADD bx, [bdb_bytes_per_sector]
    MOV ax, [kernel_cluster] ; (kernel cluster * 3) / 2
    MOV cx, 3
    MUL cx
    MOV cx, 2
    DIV cx
    MOV si, buffer
    ADD si, ax
    MOV ax, [ds:si]
    OR dx, dx
    JZ even

odd:
    SHR ax, 4
    JMP nextClusterAfter
even:
    AND ax, 0x0FFF

nextClusterAfter:
    CMP ax, 0x0FF8
    JAE readFInished

    MOV [kernel_cluster], ax
    JMP loadKernelLoop

readFInished:
    MOV dl, [ebr_drive_number]
    MOV ax, kernel_load_segment
    MOV ds, ax
    MOV es, ax
    JMP kernel_load_segment:kernel_load_offset
    HLT

kernelNotFound:
    MOV si, msg_kernel_not_find
    CALL print
    HLT
    JMP halt

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

    MOV ah, 02h
    MOV di, 3 ; counter

retry:
    STC
    INT 13h
    JNC doneRead
    CALL diskReset
    DEC di
    TEST di, di
    JNZ retry

failDiskRead:
    MOV si, read_failure
    CALL print
    HLT
    JMP halt

diskReset:
    PUSHA
    MOV ah, 0
    STC
    INT 13h
    JC failDiskRead
    POPA
    RET

doneRead:
    POP di
    POP dx
    POP cx
    POP bx
    POP ax
    RET

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

os_boot_msg: DB 'Our bootloader has been booted!', 0x0D, 0x0A, 0
read_failure DB 'Failed to read disk', 0x0D, 0x0A, 0
file_kernel_bin DB 'KERNEL  BIN'
msg_kernel_not_find DB 'KERNEL.BIN not found!'
kernel_cluster DW 0

kernel_load_segment EQU 0x2000
kernel_load_offset EQU 0

TIMES 510-($-$$) DB 0
DW 0AA55h

buffer: 