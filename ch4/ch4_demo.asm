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
 	int init0 ;RESET vector
	int NonHandledInterrupt	;TRAP  software interrupt
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
	int NonHandledInterrupt ;int7 EXTI4 port E external interrupts
	int NonHandledInterrupt ;int8 beCAN RX interrupt
	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
	int NonHandledInterrupt ;int10 SPI End of transfer
	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
	int NonHandledInterrupt ;int12 TIM1 capture/compare
	int NonHandledInterrupt ;int13 TIM2 update /overflow
	int NonHandledInterrupt ;int14 TIM2 capture/compare
	int NonHandledInterrupt ;int15 TIM3 Update/overflow
	int NonHandledInterrupt ;int16 TIM3 Capture/compare
	int NonHandledInterrupt ;int17 UART1 TX completed
	int NonHandledInterrupt ;int18 UART1 RX full
	int NonHandledInterrupt ;int19 I2C 
	int NonHandledInterrupt ;int20 UART3 TX completed
	int NonHandledInterrupt ;int21 UART3 RX full
	int NonHandledInterrupt ;int22 ADC2 end of conversion
	int NonHandledInterrupt	;int23 TIM4 update/overflow
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used
	int NonHandledInterrupt ;int29  not used

	.area CODE
.asciz  "CH4_DEMO"

;------------------------------------
;	interrupt NonHandledInterrupt
;   non handled interrupt reset MCU
;------------------------------------
NonHandledInterrupt::
	ld a,#0x80
	ld WWDG_CR,a
	;iret


	;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

;--------------------------------------------------------
; code segment 
;--------------------------------------------------------

    .area CODE

init0:
    ldw x,STACK_TOP
    ldw sp,x 
    call clock_init 
    call uart3_init
    ld a,0x12
    ldw x,0x3456
    call neg24

    

;--------------------------------
; <format> is a simplifide version
; of 'C' <printf>
; input:
;   Y       pointer to template string 
;   stack   all others paramaters are on 
;           stack. First argument is at (3,sp)
; output:
;   none
; use:
;   X       used as frame pointer  
; Detail:
;   template is a .asciz string with embedded <%c>
;   to indicate parameters positision. First <%c> 
;   from left correspond to first paramter.
;   'c' is one of these: 
;      'a' print a count of SPACE for alignement purpose     
;      'b' byte parameter  (int8_t)
;      'c' ASCII character
;      'e' 24 bits integer (int24_t) parameter
;      's' string (.asciz) parameter as long pointer (16 bits)
;      'w' word paramter (int16_t) 
;      others values of 'c' are printed as is.
;  These are sufficient for the requirement of
;  mona_dasm
;--------------------------------
    LOCAL_OFS=8 ; offset on stack of arguments frame 
format::
; preserve X
    pushw x 
; preserve farptr
    ld a, farptr+2
    push a 
    ld a, farptr+1 
    push a 
    ld a, farptr
    push a
; X used as frame pointer     
    ldw x,sp 
    addw x,#LOCAL_OFS
format_loop:    
    ld a,(y)
    jrne 1$
    jp format_exit
1$: incw y 
    cp a,#'%
    jreq 2$
    call uart_tx
    jra format_loop  
2$:
    ld a,(y)
    jreq format_exit 
    incw y
    cp a,#'a' 
    jrne 24$
    ld a,(x)
    incw x 
    call spaces 
    jra format_loop 
24$:
    cp a,#'b'
    jrne 3$
; byte type paramter     
    ld a,(x)
    incw x 
    call print_byte
    jra format_loop
3$: cp a,#'c 
    jrne 4$
; ASCII character 
    ld a,(x)
    incw x 
    call uart_tx 
    jra format_loop         
4$: cp a,#'e 
    jrne 6$
; int24_t parameter     
    pushw y 
    ld a,(x)
    ld yh,a 
    incw x
    ld a,(x)
    ld yl,a 
    incw x 
    ld a,(x)
    incw x 
    call print_extd
    popw y  
    jra format_loop
6$: cp a,#'s 
    jrne 8$
; string type parameter     
    pushw y
    ldw y,x 
    addw x,#2
    ldw y,(y)
    call uart_print 
7$: popw y 
    jra format_loop 
8$: cp a,#'w 
    jrne 9$
; word type paramter     
    pushw y 
    ld a,(x)
    incw x 
    ld yh,a
    ld a,(x)
    incw x 
    ld yl,a 
    call print_word 
    popw y 
    jp format_loop 
9$: call uart_tx         
    jp format_loop 
format_exit:
; restore farptr 
    pop a 
    ld farptr,a 
    pop a 
    ld farptr+1,a 
    pop a 
    ld farptr+2,a 
    popw x 
    ret 
