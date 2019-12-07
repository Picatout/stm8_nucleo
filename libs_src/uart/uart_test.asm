

    .module UART_TEST
    .nlist
    .include "../../inc/nucleo_8s208.inc"
    .include "../../inc/stm8s208.inc"
    .include "../../inc/ascii.inc"
    .list 

    .macro _drop n 
    addw sp,#n 
    .endm 

    TIB_SIZE=80
    .area DATA 
tib:  .ds TIB_SIZE 

    .area SSEG (ABS)
    STACK_SIZE=256 
    .org RAM_SIZE-STACK_SIZE
    .ds STACK_SIZE 

    .area HOME 
    INT init0
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt
    INT NonHandledInterrupt


    .area CODE


NonHandledInterrupt:
    .byte 0x71  ; réinitialize le MCU

	;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

init0:
    ldw x,#RAM_SIZE-1
    ldw sp,x 
    call clock_init 
    push #UART3
    push #B115200
    call uart_init
    _drop 2
    push #UART3 
    push #'O 
    call uart_putc 
    _drop 2 
    push #UART3 
    push #'K 
    call uart_putc 
    _drop 2 
    push #UART3 
    push #CR 
    call uart_putc 
    _drop 2
0$: push #UART3 
    call uart_getc 
    _drop 1 
    push #UART3 
    push a 
    call uart_putc 
    _drop 2 
    jra 0$
