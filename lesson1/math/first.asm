section .data

section .text
global _start

; _start:
; 	MOV al,0b11111111
; 	MOV bl,0b0001
; 	ADD al,bl
; 	INT 80h
; as a result i'll get for command [info register eflags] ---> [CF, PF, AF, ZF, IF]

_start:
	MOV al,0b11111111
	MOV bl,0b0001
	ADD al,bl
	ADC ah,0 ; Add with the carry register
	INT 80h

; PF - Флаг четности: устанавливается, если младшие 8 битов результата содержат четное число единиц.
; IF - Флаг разрешения прерывания: установка этого бита разрешает аппаратные прерывания.
; CF - Флаг переноса (Carry flag):казывает, был ли при сложении перенос или заимствование при вычитании. Используется в качестве входных данных для инструкций сложения и вычитания.
