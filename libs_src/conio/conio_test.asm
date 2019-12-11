
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
line: .ds 80 

;--------------------------------------------------------
    .area CODE

test_main::
    ldw x,#line 
    ld a,#80 
    push a 
clear_loop:    
    clr (x)
    incw x 
    dec a 
    jrne clear_loop
    push #UART3
    push #B115200
    call conio_init
    ldw x,#conio_test 
    pushw x 
    call puts
    ldw x,#test1 
    ldw (1,sp),x 
    call puts 
; send extended ascii 32-255
    ldw x,#SPACE
    ldw (1,sp),x 
1$: call putchar 
    inc (2,sp)
    jrpl 1$    
0$: ldw x,#test2 
    ldw (1,sp),x 
    call puts 
    call getchar
    clr (1,sp)
    ld (2,sp),a 
    call putchar 
;printf test
    ldw x,#test3 
    ldw (1,sp),x 
    call puts 
    _drop 2 
    FMT=1 ; 2 
    SPC1=3 ; 1 
    CHR1=4 ; 1
    SPC2=5 ; 1
    STR=6  ; 2
    SPC3=8 ; 1 
    I1=9   ; 3 
    SPC4=12 ; 1 
    I2 =13  ; 3
    VSIZE=I2+3   
    sub sp,#VSIZE 
    ld a,#4
    ld (SPC1,sp),a 
    ld (SPC2,sp),a 
    ld (SPC3,sp),a 
    ld (SPC4,sp),a 
    ldw x,#fmt 
    ldw (FMT,sp),x 
    ld a,#0xff
    ldw x,#0x27f
    ld (I1+2,sp),a 
    ldw (I1,sp),x 
    ld a,#0x56
    ldw x,#0x1234
    ld (I2+2,sp),a 
    ldw (I2,sp),x 
    ldw x,#hello 
    ldw (STR,sp),x  
    ld a,#'U 
    ld (CHR1,sp),a 
    call printf
    ldw x,#test4 
    pushw x 
    call puts 
    ldw x,#line 
    ldw (1,sp),x 
    call sprintf 
    _drop VSIZE+2 
    ldw x,#line 
    pushw x 
    call puts 
    ldw x,#completed 
    ldw (1,sp),x 
    call puts
    _drop 2 
    jra .  


fmt: .asciz "ABC%a%c%a%s%a%d%a%x\n"
hello: .asciz "hello world!"
conio_test: .asciz "\nconio test" 
test1: .asciz "ASCII character set"
test2: .asciz "\ngetchar test, press a key"
test3: .asciz "\nprintf test"
test4: .asciz "\nsprintf test" 
completed: .asciz "\ntests completed."

