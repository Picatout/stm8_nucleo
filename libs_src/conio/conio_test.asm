
    .module CONIO_TEST
    .nlist
    .include "../../inc/nucleo_8s208.inc"
    .include "../../inc/stm8s208.inc"
    .include "../../inc/ascii.inc"
    .list 

;--------------------------------------------------------
;      MACROS
;--------------------------------------------------------
        .macro _drop n 
        addw sp,#n 
        .endm 

;--------------------------------------------------------
    .area DATA 


;--------------------------------------------------------
    .area CODE

test_main::
    push #UART3
    push #B115200
    call conio_init
    ldw x,#conio_test 
    pushw x 
    call puts
    _drop 2 
0$: 
    call getchar 
	pushw x
    call putchar
    _drop 2
    jra 0$

conio_test: .asciz "\nconio test" 

