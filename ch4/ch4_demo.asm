;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   tutoriel sdas pour stm8
;   chapitre 4  arguments de fonctions et variables locales
;   Date: 2019-11-28
;   Copyright Jacques Deschêens, 2019
;   licence:  CC-BY-SA version 2 ou ultérieure
;
;   Description: 
;       Utilise la librairie uart.lib 
;       pour démontrer le passage d'arguments sur la pile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    .module CH4_DEMO
    .nlist
    .include "../inc/nucleo_8s208.inc"
    .include "../inc/stm8s208.inc"
    .include "../inc/ascii.inc"
    .list 

;--------------------------------------------------------
;      MACROS
;--------------------------------------------------------
		.macro _ledenable ; set PC5 as push-pull output fast mode
		bset PC_CR1,#LED2_BIT
		bset PC_CR2,#LED2_BIT
		bset PC_DDR,#LED2_BIT
		.endm
		
		.macro _ledon ; turn on green LED 
		bset PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledoff ; turn off green LED
		bres PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledtoggle ; invert green LED state
		ld a,#LED2_MASK
		xor a,PC_ODR
		ld PC_ODR,a
		.endm
		
		
		.macro  _int_enable ; enable interrupts
		 rim
		.endm
		
		.macro _int_disable ; disable interrupts
		sim
		.endm


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
 _stack_limit:
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
    ldw x,#STACK_TOP
    ldw sp,x 
    call clock_init 
; initialize UART3    
    ld a,#UART3 
    push a 
    ld a,#B115200
    push a 
    call uart_init
    SEND_OK=0
    addw sp,#2  
main:
; test uart_spaces
    ld a,#UART3 
    push a 
    ld a,#10
    push a 
    call uart_spaces
    addw sp,#2 
; test uart_puts 
     ld a,#UART3
     push a 
     ldw x,#hello
     pushw x
     call uart_puts  
     addw sp,#3
; test uart_query,uart_getc/uart_putc
    _ledenable
    _ledon 
    ld a,#UART3 
    push a 
1$: call uart_query 
    jreq 1$
    push a 
    call uart_putc  
    pop a 
    call uart_getc 
    push a 
    call uart_putc
    ld a,#2
    ld (1,sp),a 
    call uart_delete
    addw sp,#2
    _ledoff 
blink:
    ldw x,#0xffff
    _ledtoggle
1$: decw x 
    jrne 1$    
    jra blink

hello: .asciz "hello world!\n"


    

