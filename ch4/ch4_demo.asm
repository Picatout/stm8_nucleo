;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   tutoriel sdas pour stm8
;   chapitre 4  arguments de fonctions et variables locales
;   Date: 2019-11-28
;   Copyright Jacques Deschêens, 2019
;   licence:  CC-BY-SA version 2 ou ultérieure
;
;   Description: 
;       Utilise la librairie math24.asm 
;       pour démontrer le passage d'arguments sur la pile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    .module CH4_DEMO
    .nlist
    .include "../inc/nucleo_8s208.inc"
    .include "../inc/stm8s208.inc"
    .list 

;--------------------------------------------------------
;some constants used by this program.
;--------------------------------------------------------
		STACK_SIZE = 256 ; call stack size
		STACK_BASE = RAM_SIZE-STACK_SIZE ; lowest address of stack
		STACK_TOP = RAM_SIZE-1 ; stack top at end of ram

;--------------------------------------------------------
;   data segment 
;--------------------------------------------------------

    .area DATA


;--------------------------------------------------------
;  stack segment
;--------------------------------------------------------
       .area SSEG  (ABS)
	   .org RAM_SIZE-STACK_SIZE
 __stack_bottom:
	   .ds  STACK_SIZE 



;--------------------------------------------------------
;  interrupt vector table
;--------------------------------------------------------
    .area HOME 
    .word init0
;--------------------------------------------------------
; code segment 
;--------------------------------------------------------

    .area CODE

init0:

    ld a,0x12
    ldw x,0x3456
    call neg24

    

