;;
; Copyright Jacques Deschênes 2019 
; This file is part of MONA 
;
;     MONA is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     MONA is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
;;

;  MONA   MONitor written in Assembly
	.module MONA 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "mona.inc"

;	.list
	.page

;-------------------------------------------------------
; History:
;   2019-11-20  version 0.5
;				Code rework and modules reorganization
;				added 'd' command for disassembler
;		
;   2019-11-10  version 0.4
;				Added 'f' command to search string. 
;
;				parser rework.
;		
;	2019-11-05  version 0.3 
;				Added user button interrupt to exit from
;				infinite loop program and fall back du MONA.
;
;				A user application installed after MONA or in RAM 
;				can use *trap* instruction for debugging in MONA.
;				This fall to MONA shell. The application can be
;				resume with the 'q' command in the shell.
;
;				Added 'q' command for when MONA is entered from 
;				from a *trap* instruction. This will resume application
;               after the trap. Otherwise this instruction as no effect.
;
;				This version does not use *uart rx full* (int21) interrupt.
;				It is not working inside TrapHandler even though *rim*
;				instruction called.
;
;				The *main* function check if there is code at *flash_free_base*
;				and jump to it instead of entering MONA shell. The user button
;				can be used to fallback to MONA shell.
;
;				Change behavior of 'x' command. If no address given and 
;				there is an application installed jump to that application.
;
;   2019-11-04  version 0.2
;				Added 'e'rase command.
;				! command accept .asciz argument 
;
;	2019-10-28  starting work on version 0.2 to remove
; 				version 0.1 adressing range limitation.
;               version 0.1 was adapted from 
;			https://github.com/Picatout/stm8s-discovery/tree/master/mona
;
;-------------------------------------------------------


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
		; vesrion major.minor
		VERS_MAJOR = 0 ; major version number
		VERS_MINOR = 5 ; minor version number

;--------------------------------------------------------
;   application variables 
;---------------------------------------------------------		
        .area DATA
in.w:  .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
in:		.blkb 1; parser position in tib
count:  .blkb 1; length of string in tib
tib:	.blkb TIB_SIZE ; transaction input buffer
trap_sp: .blkw 1; value of sp at trap entry point.
ram_free_base: .blkw 1
flash_free_base: .blkw 1

		.area USER_RAM_BASE
;--------------------------------------------------------
;   the following RAM is not used by MONA
;--------------------------------------------------------
 _user_ram:		

;--------------------------------------------------------
;  stack segment
;--------------------------------------------------------
       .area SSEG  (ABS)
	   .org RAM_SIZE-STACK_SIZE
 __stack_bottom:
	   .ds  256

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int init0 ;RESET vector
	int TrapHandler 		;TRAP  software interrupt
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
	int UserButtonHandler   ;int7 EXTI4 port E external interrupts
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
.ascii "MONA"
	;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

		; initialize TIMER4 ticks counter
;timer4_init:
;	clr ticks
;	clr cntdwn
;	ld a,#TIM4_PSCR_128 
;	ld TIM4_PSCR,a
;	bset TIM4_IER,#TIM4_IER_UIE
;	bres TIM4_SR,#TIM4_SR_UIF
;	ld a,#125
;	ld TIM4_ARR,a ; 1 msec interval
;	ld a,#((1<<TIM4_CR1_CEN)+(1<<TIM4_CR1_ARPE)) 
;	ld TIM4_CR1,a
;	ret

; initialize UART3, 115200 8N1
uart3_init:
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
	ret
	
	; pause in milliseconds
    ; input:  y delay
    ; output: none
;pause:
;	 ldw cntdwn,y
;1$: ldw y,cntdwn
;	 jrne 1$
;    ret

;-------------------------
;  zero all free ram
;-------------------------
clear_all_free_ram:
	ldw x,#0
1$:	
	clr (x)
	incw x
	cpw x,#STACK_TOP-2
	jrule 1$
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  information printed at reset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_mona_info:
	sub sp,#2
	ld a, #VERS_MAJOR
	add a,#'0
	ld (1,sp),a 
	ld a, #VERS_MINOR
	add a,#'0
	ld (2,sp),a 
	ldw y,#VERSION
	call format 
	addw sp,#2 
	ldw y,#CPU_MODEL
	call uart_print
	ldw y,#RAM_FREE_MSG
	call uart_print
	clr acc24
	mov acc24+1,ram_free_base
	mov acc24+2,ram_free_base+1 
	clrw x
	ld a,#16
	call print_int 
	ldw y,#RAM_LAST_FREE_MSG
	call uart_print
	ldw y,#FLASH_FREE_MSG
	call uart_print
	ld a,#16
	mov acc24+1,flash_free_base
	mov acc24+2,flash_free_base+1 
	clrw x 
	call print_int 
	ldw y,#EEPROM_MSG
	call uart_print
	ret

init0:
	; initialize SP
	ldw x,#STACK_TOP
	ldw sp,x
	call clock_init
	call clear_all_free_ram
;	clr ticks
;	clr cntdwn
	ld a,#255
	ld rx_char,a
;	call timer4_init
	call uart3_init
	_ledenable
	_ledoff
	clr in.w ; must always be 0
	; initialize free_ram_base variable
	ldw y,#_user_ram ;#ram_free_base
	; align on 16 bytes boundary
	addw y,#0xf
	ld a,yl
	and a,#0xf0
	ld yl,a
	ldw ram_free_base,y
	; initialize flash_free_base variable
	ldw y,#mona_end
	ldw flash_free_base,y
; active l'interruption sur PE_4 (bouton utilisateur)
    bset PE_CR2,#USR_BTN_BIT

;------------------------
; program main function
;------------------------
main:	
; enable interrupts
	_int_enable 
; check for user application and run it 
; if there is one located at *flash_free_base*
	ld a,[flash_free_base]
	jreq 1$
	ldw y, #APP_MSG
	call uart_print
	jp [flash_free_base]		
; information printed at mcu reset.	
1$:	call print_mona_info
; Read Execute Print Loop
; MONA spend is time in this loop
repl: 
; move terminal cursor to next line
	ld a,#NL 
	call uart_tx
; print prompt sign	 
	ld a,#'>
	call uart_tx
; read command line	
	call readln 
;if empty line -> ignore it, loop.	
	tnz count
	jreq repl
; initialize parser and call eval function	  
	clr in
	call eval
; start over	
	jra repl  ; loop

APP_MSG: .ascii "Application dectected, running it.\n"
		 .asciz "Press USER button to fallback to MONA shell.\n"

;------------------------------------
;	interrupt NonHandledInterrupt
;   non handled interrupt reset MCU
;------------------------------------
NonHandledInterrupt:
	ld a,#0x80
	ld WWDG_CR,a
	;iret
;------------------------------------
; gestionnaire pour l'instrcution trap 
;------------------------------------
TrapHandler:
; save sp for 'q' command resume.
	ldw y, sp 
	ldw trap_sp,y
	ldw y, #SOFT_TRAP 
	call uart_print 
	call print_registers
	bset flags,#F_TRAP 
; enable interrupts 
;	ld a,#(1<<CC_I1)
;	push a 
;	pop cc  
	jp repl
app_resume:	
	iret

SOFT_TRAP: .asciz "Program interrupted by a software trap. 'q' to resume\n"

;------------------------------------
;    user button interrupt handler
;    Cette interruption ne retourne pas
;    Après avoir affiché l'état des 
;    registres au moment de l'interruption
;    le pointeur de pile est réinitialiser
;    et un saut vers repl: est effectué.
;------------------------------------
UserButtonHandler:
	; attend que le bouton soit relâché
0$:	ldw x,0xffff
1$: decw x 
	jrne 1$
	btjt USR_BTN_PORT,#USR_BTN_BIT, 2$
	jra 0$
2$:	ldw y,#USER_ABORT
	call uart_print
    call print_registers 
	_int_enable 
	ldw x, #RAM_SIZE-1
	ldw sp, x
	jp repl


; affiche les registres sauvegardés
; par l'interruption sur la pile.
print_registers:
	ldw y,#STATES
	call uart_print
; print EPC 
	ldw y, #REG_EPC
	call uart_print 
	ld a, (11,sp)
	ld acc24+2,a 
	ld a, (10,sp) 
	ld acc24+1,a 
	ld a,(9,sp) 
	ld acc24,a
	clrw x  
	ld a,#16
	call print_int  
; print Y 
	ldw y,#REG_Y
	call uart_print 
	clr acc24 
	ld a,(8,sp)
	ld acc24+2,a 
	ld a,(7,sp)
	ld acc24+1,a 
	ld a,#16 
	call print_int 
; print X
	ldw y,#REG_X
	call uart_print  
	ld a,(6,sp)
	ld acc24+2,a 
	ld a,(5,sp)
	ld acc24+1,a 
	ld a,#16 
	call print_int 
; print A 
	ldw y,#REG_A 
	call uart_print 
	clr acc24+1
	ld a, (4,sp) 
	ld acc24+2,a 
	ld a,#16
	call print_int 
; print CC 
	ldw y,#REG_CC 
	call uart_print 
	ld a, (3,sp) 
	ld acc24+2,a
	ld a,#16  
	call print_int 
	ld a,#'\n' 
	call uart_tx  
	ret

USER_ABORT: .asciz "Program aborted by user.\n"
STATES:  .asciz "Registers state at abort point.\n--------------------------\n"
REG_EPC: .asciz "EPC: "
REG_Y:   .asciz "\nY: " 
REG_X:   .asciz "\nX: "
REG_A:   .asciz "\nA: " 
REG_CC:  .asciz "\nCC: "

;------------------------------------
; TIMER4 interrupt service routine
;------------------------------------
;timer4_isr:
;	ldw y,ticks
;	incw y
;	ldw ticks,y
;	ldw y,cntdwn
;	jreq 1$
;	decw y
;	ldw cntdwn,y
;1$: bres TIM4_SR,#TIM4_SR_UIF
;	iret

;------------------------------------
; uart3 receive interrupt service
;------------------------------------
;uart_rx_isr:
; local variables
;  UART_STATUS = 2
;  UART_DATA = 1
; read uart registers and save them in local variables  
;  ld a, UART3_SR
;  push a  ; local variable UART_STATUS
;  ld a,UART3_DR
;  push a ; local variable UART_DATA
; test uart status register
; bit RXNE must 1
; bits OR|FE|NF must be 0	
;  ld a, (UART_STATUS,sp)
; keep only significant bits
;  and a, #((1<<UART_SR_RXNE)|(1<<UART_SR_OR)|(1<<UART_SR_FE)|(1<<UART_SR_NF))
; A value shoudl be == (1<<UART_SR_RNXE)  
;  cp a, #(1<<UART_SR_RXNE)
;  jrne 1$
; no receive error accept it.  
;  ld a,(UART_DATA,sp)
;  ld rx_char,a
;1$: 
; drop local variables
;  popw X	
;  iret

;------------------------------------
; read a line of text from terminal
; input:
;	none
; local variable on stack:
;	LEN (1,sp)
;   RXCHAR (2,sp)
; output:
;   text in tib  buffer
;   len in count variable
;------------------------------------
	; local variables
	LEN = 1  ; accepted line length
	RXCHAR = 2 ; last char received
readln::
	push #0  ; RXCHAR 
	push #0  ; LEN
 	ldw y,#tib ; input buffer
readln_loop:
	call uart_getchar
	ld (RXCHAR,sp),a
	cp a,#CTRL_C
	jrne 2$
	jp cancel
2$:	cp a,#CTRL_R
	jreq reprint
	cp a,#CR
	jrne 1$
	jp readln_quit
1$:	cp a,#NL
	jreq readln_quit
	cp a,#BSP
	jreq del_back
	cp a,#CTRL_D
	jreq del_line
	cp a,#SPACE
	jrpl accept_char
	jra readln_loop
del_line:
	ld a,(LEN,sp)
	call uart_delete
	ldw y,#tib
	clr count
	clr (LEN,sp)
	jra readln_loop
del_back:
    tnz (LEN,sp)
    jreq readln_loop
    dec (LEN,sp)
    decw y
    clr  (y)
    ld a,#1
    call uart_delete
    jra readln_loop	
accept_char:
	ld a,#TIB_SIZE-1
	cp a, (1,sp)
	jreq readln_loop
	ld a,(RXCHAR,sp)
	ld (y),a
	inc (LEN,sp)
	incw y
	clr (y)
	call uart_tx
	jra readln_loop
reprint:
	tnz (LEN,sp)
	jrne readln_loop
	tnz count
	jreq readln_loop
	ldw y,#tib
	pushw y
	call uart_print
	popw y
	ld a,count
	ld (LEN,sp),a
	ld a,yl
	add a,count
	ld yl,a
	jp readln_loop
cancel:
	clr tib
	clr count
	jra readln_quit2
readln_quit:
	ld a,(LEN,sp)
	ld count,a
readln_quit2:
	addw sp,#2
	ld a,#NL
	call uart_tx
	ret
	
;------------------------------------
; skip character c in tib starting from 'in'
; input:
;	 y 		point to tib 
;    a 		character to skip
; output:  
;	'in' ajusted to new position
;------------------------------------
	C = 1 ; local var
skip:
	push a
1$:	ld a,([in.w],y)
	jreq 2$
	cp a,(C,sp)
	jrne 2$
	inc in
	jra 1$
2$: pop a
	ret
	
;------------------------------------
; scan tib for charater 'c' starting from 'in'
; input:
;	y  point to tib 
;	a character to skip
; output:
;	in point to chacter 'c'
;------------------------------------
	C = 1 ; local var
scan: 
	push a
1$:	ld a,([in.w],y)
	jreq 2$
	cp a,(C,sp)
	jreq 2$
	inc in
	jra 1$
2$: pop a
	ret

;------------------------------------
; parse quoted string 
; input:
;   Y 	pointer to tib 
;   X   pointer to tab 
; output:
;	pad   containt string 
;------------------------------------
	PREV = 1
parse_quote:
	clr a
	push a
1$:	ld (PREV,sp),a 
	inc in
	ld a,([in.w],y)
	jreq 4$
	push a
	ld a, (PREV,sp)
	cp a,#'\
	pop a 
	jrne 11$
	clr (PREV,sp)
	callr convert_escape
	ld (x),a 
	incw x 
	jra 1$
11$: 
	cp a,#'\'
	jrne 2$
	ld (PREV,sp),a 
	jra 1$
2$:	ld (x),a 
	incw x 
	cp a,#'"'
	jrne 1$
	inc in 
4$:	clr (x)
	pop a 
	ret 

;---------------------------------------
; called by parse_quote
; subtitute escaped character 
; by their ASCII value .
; input:
;   A  character following '\'
; output:
;   A  substitued char or same if not valid.
;---------------------------------------
convert_escape:
	cp a,#'a'
	jrne 1$
	ld a,#7
	ret 
1$: cp a,#'b'
	jrne 2$
	ld a,#8
	ret 
2$: cp a,#'e' 
    jrne 3$
	ld a,#'\'
	ret  
3$: cp a,#'\'
	jrne 4$
	ld a,#'\'
	ret 
4$: cp a,#'f' 
	jrne 5$ 
	ld a,#FF 
	ret  
5$: cp a,#'n' 
    jrne 6$ 
	ld a,#0xa 
	ret  
6$: cp a,#'r' 
	jrne 7$
	ld a,#0xd 
	ret  
7$: cp a,#'t' 
	jrne 8$ 
	ld a,#9 
	ret  
8$: cp a,#'v' 
	jrne 9$  
	ld a,#0xb 
9$:	ret 

;------------------------------------
; Command line tokenizer
; scan tib for next word
; move token in 'pad'
; use:
;	Y   pointer to tib 
;   X	pointer to pad 
;   in.w   index in tib
; output:
;   pad 	token as .asciz  
;------------------------------------
next_word::
	pushw x 
	pushw y 
	ldw x, #pad 
	ldw y, #tib  	
	ld a,#SPACE
	call skip
	ld a,([in.w],y)
	jreq 8$
	cp a,#'"
	jrne 1$
	ld (x),a 
	incw x 
	call parse_quote
	jra 9$
1$: cp a,#SPACE
	jreq 8$
	call to_lower 
	ld (x),a 
	incw x 
	inc in
	ld a,([in.w],y) 
	jrne 1$
8$: clr (x)
9$:	popw y 
	popw x 
	ret

;----------------------------------
; convert to lower case
; input: 
;   A 		character to convert
; output:
;   A		result 
;----------------------------------
to_lower::
	cp a,#'A
	jrult 9$
	cp a,#'Z 
	jrugt 9$
	add a,#32
9$: ret

;------------------------------------
; convert alpha to uppercase
; input:
;    a  character to convert
; output:
;    a  uppercase character
;------------------------------------
to_upper::
	cp a,#'a
	jrpl 1$
0$:	ret
1$: cp a,#'z	
	jrugt 0$
	sub a,#32
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        arithmetic operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------
;	24 bit integers addition
; input:
;	X 		*v1 
;	Y 		*v2 
; output:
;	X 		*v1+=*v2 
;--------------------------------------
add24::
	ld a,(2,x)
	add a,(2,y)
	ld (2,x),a 
	ld a,(1,x)
	adc a,(1,y)
	ld (1,x),a 
	ld a,(x)
	adc a,(y)
	ld (x),a 
	ret 


;--------------------------------------
; unsigned multiply uint24_t by uint8_t
; use to convert numerical string to uint24_t
; input:
;	acc24	uint24_t 
;   A		uint8_t
; output:
;   acc24   A*acc24
;-------------------------------------
; local variables offset  on sp
	U8   = 3   ; A pushed on stack
	OVFL = 2  ; multiplicaton overflow low byte
	OVFH = 1  ; multiplication overflow high byte
	LOCAL_SIZE = 3
mulu24_8::
	pushw x    ; save X
	; local variables
	push a     ; U8
	clrw x     ; initialize overflow to 0
	pushw x    ; multiplication overflow
; multiply low byte.
	ld a,acc24+2
	ld xl,a
	ld a,(U8,sp)
	mul x,a
	ld a,xl
	ld acc24+2,a
	ld a, xh
	ld (OVFL,sp),a
; multipy middle byte
	ld a,acc24+1
	ld xl,a
	ld a, (U8,sp)
	mul x,a
; add overflow to this partial product
	addw x,(OVFH,sp)
	ld a,xl
	ld acc24+1,a
	clr a
	adc a,#0
	ld (OVFH,sp),a
	ld a,xh
	ld (OVFL,sp),a
; multiply most signficant byte	
	ld a, acc24
	ld xl, a
	ld a, (U8,sp)
	mul x,a
	addw x, (OVFH,sp)
	ld a, xl
	ld acc24,a
    addw sp,#LOCAL_SIZE
	popw x
	ret

;-------------------------------------
; divide uint24_t by uint8_t
; used to convert uint24_t to string
; input:
;	acc24	dividend
;   A 		divisor
; output:
;   acc24	quotient
;   A		remainder
;------------------------------------- 
; offset  on sp of arguments and locals
	U8   = 1   ; divisor on stack
	LOCAL_SIZE =1
divu24_8::
	pushw x ; save x
	push a 
	; ld dividend UU:MM bytes in X
	ld a, acc24
	ld xh,a
	ld a,acc24+1
	ld xl,a
	ld a,(U8,SP) ; divisor
	div x,a ; UU:MM/U8
	push a  ;save remainder
	ld a,xh
	ld acc24,a
	ld a,xl
	ld acc24+1,a
	pop a
	ld xh,a
	ld a,acc24+2
	ld xl,a
	ld a,(U8,sp) ; divisor
	div x,a  ; R:LL/U8
	ld (U8,sp),a ; save remainder
	ld a,xl
	ld acc24+2,a
	pop a
	popw x
	ret

;------------------------------------
;  two's complement acc24
;  input:
;		acc24 variable
;  output:
;		acc24 variable
;-------------------------------------
neg_acc24::
	cpl acc24+2
	cpl acc24+1
	cpl acc24
	ld a,#1
	add a,acc24+2
	ld acc24+2,a
	clr a
	adc a,acc24+1
	ld acc24+1,a 
	clr a 
	adc a,acc24 
	ld acc24,a 
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; incremente acc24 
; input:
;   X 		adresse de la variable 
;   A		incrément
; output:
;	aucun 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inc_var24::
	add a, (2,x)
	ld (2,x),a
	clr a
	adc a,(1,x)
	ld (1,x),a 
	clr a 
	adc a,(x)
	ld (x),a
	ret 
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; copy 24 bits variable 
; input:
;	X 		address var source
;   y		address var destination
; output:
;   dest = src
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copy_var24::
	ld a,(0,x)
	ld (0,y),a 
	ld a,(1,x)
	ld (1,y),a 
	ld a,(2,x)
	ld (2,y),a 
	ret

;------------------------------------
; convert integer to string
; input:
;   A	  	base
;	acc24	integer to convert
; output:
;   y  		pointer to string
;   A 		string length 
;------------------------------------
	SIGN=1  ; integer sign 
	BASE=2  ; numeric base 
	LOCAL_SIZE=2  ;locals size
itoa::
	sub sp,#LOCAL_SIZE
	ld (BASE,sp), a  ; base
	clr (SIGN,sp)    ; sign
	cp a,#10
	jrne 1$
	; base 10 string display with negative sign if bit 23==1
	btjf acc24,#7,1$
	cpl (SIGN,sp)
	call neg_acc24
1$:
; initialize string pointer 
	ldw y,#pad+PAD_SIZE-1
	clr (y)
itoa_loop:
    ld a,(BASE,sp)
    call divu24_8 ; acc24/A 
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: decw y
    ld (y),a
	; if acc24==0 conversion done
	ld a,acc24
	or a,acc16
	or a,acc8
    jrne itoa_loop
	;conversion done, next add '$' or '-' as required
	ld a,(BASE,sp)
	cp a,#16
	jreq 10$
    ld a,(SIGN,sp)
    jreq 10$
    decw y
    ld a,#'-
    ld (y),a
10$:
	addw sp,#LOCAL_SIZE
	call strlen
	ret

;------------------------------------
; check if A containt an ASCII letter.
; input:
;    A 		character to test 
; output:
;    A 		same 
;    C      0 not letter, 1 letter 
;------------------------------------
is_alpha::
	push a 
	or a,#32
	cp a,#'a 
	jrult not_alpha
	cp a,#'z 
	jrugt not_alpha 
	scf 
	pop a 
	ret 
not_alpha:
	rcf 
	pop a 
	ret 


;------------------------------------
; check if character in {'0'..'9'}
; input:
;    A  character to test
; output:
;    A  0|1
;------------------------------------
is_digit::
	cp a,#'0
	jrpl 1$
0$:	clr a
	ret
1$: cp a,#'9
    jrugt 0$
    ld a,#1
    ret
	
;------------------------------------
; check if character in {'0'..'9','A'..'F'}
; input:
;   a  character to test
; output:
;   a   0|1 
;------------------------------------
is_hex::
	push a
	call is_digit
	cp a,#1
	jrne 1$
	addw sp,#1
	ret
1$:	pop a
	cp a,#'a
	jrmi 2$
	sub a,#32
2$: cp a,#'A
    jrpl 3$
0$: clr a
    ret
3$: cp a,#'F
    jrugt 0$
    ld a,#1
    ret
            	
;------------------------------------
; convert pad content in integer
; input:
;    pad		.asciz to convert
; output:
;    acc24      int24_t
;------------------------------------
	; local variables
	SIGN=1 ; 1 byte, 
	BASE=2 ; 1 byte, numeric base used in conversion
	TEMP=3 ; 1 byte, temporary storage
	LOCAL_SIZE=3 ; 3 bytes reserved for local storage
atoi::
	pushw x ;save x
	sub sp,#LOCAL_SIZE
	; acc24=0 
	clr acc24    
	clr acc16
	clr acc8 
	ld a, pad 
	jreq atoi_exit
	clr (SIGN,sp)
	ld a,#10
	ld (BASE,sp),a ; default base decimal
	ldw x,#pad ; pointer to string to convert
	ld a,(x)
	jreq 9$  ; completed if 0
	cp a,#'-
	jrne 1$
	cpl (SIGN,sp)
	jra 2$
1$: cp a,#'$
	jrne 3$
	ld a,#16
	ld (BASE,sp),a
2$:	incw x
	ld a,(x)
3$:	
	cp a,#'a
	jrmi 4$
	sub a,#32
4$:	cp a,#'0
	jrmi 9$
	sub a,#'0
	cp a,#10
	jrmi 5$
	sub a,#7
	cp a,(BASE,sp)
	jrpl 9$
5$:	ld (TEMP,sp),a
	ld a,(BASE,sp)
	call mulu24_8
	ld a,(TEMP,sp)
	add a,acc24+2
	ld acc24+2,a
	clr a
	adc a,acc24+1
	ld acc24+1,a
	clr a
	adc a,acc24
	ld acc24,a
	jra 2$
9$:	tnz (SIGN,sp)
    jreq atoi_exit
    negw y
atoi_exit: 
	addw sp,#LOCAL_SIZE
	popw x ; restore x
	ret

;------------------------------------
;strlen  return .asciz string length
; input:
;	y  	pointer to string
; output:
;	a   length  < 256
;------------------------------------
	LEN=1
strlen::
    pushw y
    push #0 ; length 
0$: ld a,(y)
    jreq 1$
    inc (LEN,sp)
    incw y
    jra 0$
1$: pop a
    popw y
    ret

;------------------------------------
; print integer in acc24 
; input:
;	acc24 		integer to print 
;	A 			numerical base for conversion 
;   XL 			field width, 0 -> no fill.
;  output:
;    none 
;------------------------------------
	BASE = 2
	WIDTH = 1
	LOCAL_SIZE = 2
print_int::
	pushw y 
	sub sp,#LOCAL_SIZE 
	ld (BASE,sp),a 
	ld a,xl
	ld (WIDTH,sp),a 
	ld a, (BASE,sp)  
    call itoa  ; conversion entier en  .asciz
	ld acc8,a ; string length 
	ld a,#16
	cp a,(BASE,sp)
	jrne 1$
	decw y 
	ld a,#'$
	ld (y),a
	inc acc8 
1$: ld a,(WIDTH,sp) 
	jreq 4$
	sub a,acc8
	jrule 4$
	ld (WIDTH,sp),a 
	ld  a,#SPACE
3$: tnz (WIDTH,sp)
	jreq 4$
	jrmi 4$
	decw y 
	ld (y),a 
	dec (WIDTH,sp) 
	jra 3$
4$: call uart_print
	ld a,#SPACE 
	call uart_tx 
    addw sp,#LOCAL_SIZE 
	popw y 
    ret	

;----------------------------
; print byte in acc8 
; in hexadecimal format 
; input:
;   A	byte to print 
; use: 
;   XL		field width
;----------------------------
print_byte::
	pushw x
	ld acc8,a  
	clr acc24 
	clr acc16  
	ld a,#3
	ld xl,a
	ld a,#16
	call print_int 
	popw x 
	ret 

;----------------------------
; print word in acc16 
; in hexadecimal format 
; input:
;   Y	word to print 
; use: 
;   A       conversion base 
;   XL		field width
;----------------------------
print_word::
	push A 
	pushw x
	ldw acc16,y  
	clr acc24 
	ld a,#5
	ld xl,a
	ld a,#16
	call print_int 
	popw x 
	pop a 
	ret 

;------------------------------------
; print *farptr
; input:
;    *farptr 
; use:
;	acc24	itoa conversion 
;   A 		conversion base
;   XL		field width 
;------------------------------------
print_addr:
	pushw x
	push a 
	ldw x, farptr 
	ldw acc24,x 
	ld a,farptr+2 
	ld acc8,a 
	ld a,#6  
	ld xl, a  ; field width 
	ld a,#16 ; convert in hexadecimal 
	call print_int 
	pop a 
	popw x 
	ret 

;------------------------------------
;  print padded text with spaces 
;  input:
;	Y 		pointer to text 
;   A 		field width 
;------------------------------------
print_padded::
	push a 
	pushw y 
	call uart_print 
	popw y 
	call strlen 
	ld acc8,a
	pop a 
	sub a,acc8 
	jrule 2$
	call spaces
2$:	ret 

;------------------------------------
; sign extend a byte acc8 in acc24 
; input:
;	acc8 	 
; output:
;   acc24	acc8 sign extended
;-------------------------------------
sex_acc8::
	ld a,#128
	and a,acc8 
	jreq 1$
	cpl a 
1$:	ld acc16,a  
	ld acc24,a 
	ret 

;------------------------------------
; get byte at address 
; farptr[X]
; input:
;	 farptr   address to peek
;    X		  farptr index 	
; output:
;	 A 		  byte from memory  
;    x		  incremented by 1
;------------------------------------
peek::
	ldf a,([farptr],x)
	incw x
	ret

;------------------------------------
; get word at at address 
; farptr[X]
; input:
;	 farptr   address to peek
;    X		  farptr index 	
; output:
;    Y:   	  word from memory 
;	 X:		  incremented by 2 
;------------------------------------
peek16::
	 clr acc24 
	 ldf a,([farptr],x)
	 ld yh,a 
	 incw x 
	 ldf a,([farptr],x)
	 ld yl,a 
	 incw x 
	 ret 


;------------------------------------
; get 24 bits integer at address
; pointed by farptr[x] 
; input:
;	 farptr   address to peek
;    X		  farptr index 	
;    A   	  numeric base for convertion
; output:
;    acc24 	  value
;    x		  incremented by 3 
;------------------------------------
peek24::
	 ldf a,([farptr],x)
	 ld acc24,a 
	 incw x 
	 ldf a,([farptr],x)
	 ld acc16,a 
	 incw x 
	 ldf a,([farptr],x)
	 ld acc8,a 
	 incw x 
	 ret

;------------------------------------
; expect a number from command line next argument
;  input:
;	  none
;  output:
;    acc24   int24_t 
;------------------------------------
number::
	call next_word
	call atoi
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; write a byte in memory
; input:
;    a  		byte to write
;    farptr  	address
;    x          farptr[x]
; output:
;    none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; variables locales
	BTW = 1   ; byte to write offset on stack
	OPT = 2   ; OPTION flag offset on stack
	LOCAL_SIZE = 2
write_byte:
	pushw y
	sub sp,#LOCAL_SIZE  ; réservation d'espace pour variables locales  
	ld (BTW,sp),a ; byte to write 
	clr (OPT,sp)  ; OPTION flag
	; put addr[15:0] in Y, for bounds check.
	ld a, farptr+1
	ld yh,a
	ld a, farptr+2
	ld yl,a  ; Y=addr15:0
	; check addr[23:16], if <> 0 then it is extened flash memory
	tnz farptr 
	jrne write_flash
    cpw y,flash_free_base
    jruge write_flash
    cpw y,#SFR_BASE
	jruge write_ram
	cpw y,#EEPROM_BASE  
    jruge write_eeprom
	cpw y,ram_free_base
    jrult write_exit
    cpw y,#STACK_BASE
    jruge write_exit

;write RAM and SFR 
write_ram:
	ld a,(BTW,sp)
	ldf ([farptr],x),a
	jra write_exit

; write program memory
write_flash:
	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
1$:	_int_disable
	ld a,(BTW,sp)
	ldf ([farptr],x),a ; farptr[x]=A
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
    _int_enable
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
    jra write_exit

; write eeprom and option
write_eeprom:
	; check for data eeprom or option eeprom
	cpw y,#OPTION_BASE
	jrmi 1$
	cpw y,#OPTION_END+1
	jrpl 1$
	cpl (OPT,sp)
1$: mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
    tnz (OPT,sp)
    jreq 2$
	; pour modifier une option il faut modifier ces 2 bits
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
2$: btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
    ld a,(BTW,sp)
    ldf ([farptr],x),a
    tnz (OPT,sp)
    jreq 3$
    incw x
    ld a,(BTW,sp)
    cpl a
    ldf ([farptr],x),a
3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
write_exit:
; ne pas oublier de réajuster sp 
; et de restaurer les register empilés.
	addw sp,#LOCAL_SIZE 
	popw y
    ret
        
		  
;------------------------------------
; evaluate command string in tib
; list of commands
;   @  addr display content at address
;   !  addr byte [byte ]* store bytes at address
;   ?  diplay command help
;   b  n    convert n in the other base
;	c  addr bitmask  clear  bits at address
;   h  addr hex dump memory starting at address
;   m  src dest count,  move memory block
;   r  reset MCU
;   s  addr bitmask  set a bits at address
;   t  addr bitmask  toggle bits at address
;   x  addr execute  code at address  
;------------------------------------
eval:
	ld a, in
	cp a, count
	jrne 0$
	ret ; nothing to evaluate
0$:	call next_word
	ldw y,#pad
    ld a,(y)
	cp a,#'@
	jrne 1$
	jp fetch
1$:	cp a,#'!
	jrne 10$
	jp store
10$:
	cp a,#'?
	jrne 15$
	jp help
15$: 
	cp a,#'b
    jrne 2$
    jp base_convert	
2$:	cp a,#'c
	jrne 21$
	jp clear_bits
21$:
	cp a,#'d
	jrne 23$
	call dasm
	ret 
23$:
	cp a,#'e 
	jrne 25$
	jp erase
25$:
	cp a,#'f
	jrne 3$
	jp find 	 	
3$:	cp a,#'h
	jrne 4$
	jp hexdump
4$:	cp a,#'m
	jrne 45$
	jp move_memory
45$:
    cp a,#'q 
	jrne 5$
	btjf flags,#F_TRAP,455$
	bres flags,#F_TRAP
	ldw y,trap_sp
	ldw sp,y
	jp app_resume
455$:
	ret 
5$: cp a,#'r
    jrne 6$
	call NonHandledInterrupt	
6$:	cp a,#'s
	jrne 7$
	jp set_bits
7$:	cp a,#'t
	jrne 8$
	jp toggle_bits
8$:	cp a,#'x
	jrne 9$
	jp execute
9$:	call uart_print
	call uart_tx
	ld a,#SPACE 
	call uart_tx 
	ldw y,#BAD_CMD
	call uart_print
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      MONA commands 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;------------------------------------
; @ addr, fetch a byte and display it.
;------------------------------------
fetch:
	pushw x
	pushw y
	call number
	ld a,pad
	jreq fetch_miss_arg ; pas d'adresse 
	ldw x,#acc24
	ldw y,#farptr
	call copy_var24
	call print_addr 
	ld a,#'=
	call uart_tx
	ld a,#SPACE 
	call uart_tx 	
	ld a,pad
	cp a,#'$
	jreq 1$
	ld a,#10
	jra 2$
1$: ld a,#16
2$:	
	clrw x  ; pour farptr[0]
	call peek
	call print_byte 
	jra fetch_exit
fetch_miss_arg:
	call error_print	
fetch_exit:	
	popw y
	popw x 
	ret
	
;------------------------------------
; ! addr byte [byte ]*, store byte(s)
;------------------------------------
store:
	pushw x 
	pushw y
	call number
	ld a,pad 
	jreq store_miss_arg ; pas d'arguments
	ldw x,#acc24
	ldw y,#farptr
	call copy_var24  ; farptr=acc24 
	clrw x ; index pour farptr[x]
	call number
	ld a,pad 
	jrne str01 ; missing data
	call error_print
	jp store_exit  
store_loop:
	call number
	ld a, pad
	jreq store_exit ; pas d'octet à écrire.
str01:	
	cp a,#'"'
	jreq store_string	
	ld a,acc24+2 ; octet à écrire.
	call write_byte
	incw x ; x++
	jra store_loop 
store_string:
	ldw y,#pad 
str_loop:	
    incw y 
	ld a, (y)
	jreq store_loop 
	cp a,#'"'
	jreq store_loop
write_char:
	call write_byte 
	incw x 
	jra str_loop 
store_miss_arg:
	call error_print	
store_exit:	
	popw y
	popw x
	ret



;------------------------------------
; ? , display command information
;------------------------------------
help:
	ldw y, #HELP
	call uart_print
	ret

;-------------------------------------------
;  b n|$n
; convert from one numeric base to the other
;-------------------------------------------
base_convert:
    call number
    ld a,pad
	jreq base_miss_arg 
    cp a,#'$
    jrne 1$
    ld a,#10
    jra 2$
1$: ld a,#16
2$: clrw x 
    call print_int 
    ret
base_miss_arg:
	call error_print
	ret
	
;------------------------------------
; c addr mask, clear bitmask 
;------------------------------------
clear_bits:
	pushw x 
	pushw y 
	call number
	ld a, pad 
	jreq 8$ ; pas d'adresse 
	ldw x, #acc24 
	ldw y, #farptr 
	call copy_var24 
	call number
	ld a, pad 
	jreq 8$ ; pas de masque 
	cpl acc24+2 ; inverse masque de bits 
	ldf a,[farptr]
	and a,acc24+2
	clrw x 
	call write_byte
	jra 9$
8$: call error_print	 
9$:	popw y 
	popw x
    ret

;----------------------------------------
; e addr count, efface une plage mémoire
; cible la mémoire RAM,EEPROM ou FLASH
;----------------------------------------
	; variables locales
	CNTR=1  ; nombre d'octets à effacer
	LOCAL_SIZE = 2
erase:
	pushw x 
	pushw y
	sub sp,#LOCAL_SIZE 
	call number
	ld a, pad 
	jreq erase_miss_arg ; pas de paramètres
	ldw x, #acc24 
	ldw y, #farptr
	call copy_var24
	call number 
	ld a, pad 
	jreq erase_miss_arg ; count manquant 
	ld a, acc24+1
	ld yh,a 
	ld a, acc24+2
	ld yl,a   ; Y= count 
	clrw X 
1$:
	clr a 
	call write_byte 
	decw y 
	jreq erase_exit 
	incw x 
	jra 1$
erase_miss_arg:
	call error_print
erase_exit:
	addw sp,#LOCAL_SIZE 
	popw y 
	popw x 
	ret  

;------------------------------------------
; f addr [i] string,  search string in memory
; stop at first occurence or end of memory
;------------------------------------------
	; variable locale 
	CASE_SENSE=1  ; indicateur recherche sensible à casse.
find:
	clr a 
	push a  ; case sensitive
	call number
	ld a,pad
	jrne 0$
	jpf find_miss_arg 
0$:	ldw x, #acc24 
	ldw y, #farptr
	call copy_var24
	call next_word 
	ld a,pad
	cp a,#'i
	jrne 2$
1$:	ld a,#32
	ld (CASE_SENSE,sp),a ; case insensitive
	call next_word 
	ld a,pad 
2$: cp a,#'" 
	jrne find_bad_arg
; remove ["] character at end of string.
; and convert to lower case if option [i]
	ldw x, #pad+1
4$:	ld a,(x)
	jreq 5$
	call is_alpha 
	jrnc 41$
	or a,(CASE_SENSE,sp)
41$:	
	ld (x),a 
	incw x 
	jra 4$
5$: decw x
	clr (x)
; search loop 
20$:
; initialize X at string first char.	
	ldw x, #pad+1
	clrw y ; farptr index 
; string compare 	
21$:
	ld a,(x)
	jreq found 
	ldf a,([farptr],y)
; if letter and [i] convert to lower case 	
	cp a,#'A
	jrult 24$
	cp a,#'Z
	jrugt 24$
	or a,(CASE_SENSE,sp)	 
24$: cp a,(x) 
	jrne 30$
	incw x 
	incw y 
	jra 21$
; increment farptr for next comparison
30$: ld a,#1 
	ldw x,#farptr 
	call inc_var24
; check for memory end 	
	ldw x,#(FLASH_END>>8) 
	cpw x, farptr
	jrne 20$
	ld a,farptr+2 
	cp a,#FLASH_END 
	jreq  find_failed ; not found 
	jra 20$		
found:
	ldw y,#FOUND_AT 
	call uart_print
	call print_addr 
	jra find_exit
find_miss_arg:
	call error_print
	jra find_exit  
find_bad_arg:
	ld a,#1
	call error_print 
	jra find_exit 
find_failed:
	ldw y, #NOT_FOUND
	call uart_print 
find_exit:
	pop a 
	ret 

FOUND_AT:	.asciz "Found at address: "
NOT_FOUND:  .asciz "String not found."

;------------------------------------
; h addr, memory dump in hexadecimal 
; stop after each row, SPACE continue, other stop
;------------------------------------
	ROW_CNT = 8 ; nombre d'octets par ligne 
	IDX=1 ; index pour farptr[x]
	LOCAL_SIZE=2
hexdump: 
	sub sp,#LOCAL_SIZE
	call next_word
	ld a, pad 
	jrne 1$
	jp hdump_missing_arg ; adresse manquante
1$:	
	call atoi ; acc24=addr 
	; farptr = addr 
	ldw x,#acc24
	ldw y,#farptr
	call copy_var24
row_init:
	clrw x 
	ldw (IDX,sp),x
	; affiche l'adresse en début de ligne 
	call print_addr 
	ld a,#TAB 
	call uart_tx
	call uart_tx 
	ldw y, #pad
	ldw x,(IDX,sp)
row:
	pushw x 
	call peek
	call print_byte 
	popw x  
	ldf a,([farptr],x)
	cp a,#SPACE
	jrpl 1$
	ld a,#SPACE
1$:	cp a,#128
    jrmi 2$
    ld a,#SPACE
2$: ld (y),a
	incw y 
	incw x
	cpw x,#ROW_CNT
	jrne row
	ld a,#ROW_CNT 
	ldw x,#farptr
	call inc_var24
	ld a,#SPACE
	call uart_tx
	clr a
	ld (y),a
	ld a,#SPACE 
	call uart_tx  
	ldw y,#pad
	call uart_print
	ld a,#NL
	call uart_tx
	call uart_getchar
	cp a,#SPACE
	jreq row_init
	jra hdump_exit 
hdump_missing_arg:
	call error_print 	
hdump_exit:	
    addw sp,#LOCAL_SIZE
    ret
    
;------------------------------------
; m src dest count, move memory block
;------------------------------------
    COUNT=1
    SOURCE=3
	LOCAL_SIZE=5    
move_memory:
	sub sp,#LOCAL_SIZE
	call number 
	ld a, pad 
	jreq move_missing_arg ; pas d'arguments 
	; save source address on stack
	ld a, acc24+2
	ld (SOURCE+2,sp),a
	ld a, acc24+1
	ld (SOURCE+1,sp),a
	ld a,acc24
	ld (SOURCE,sp),a
	call number
	ld a,pad
	jreq move_missing_arg ; dest count manquant 
	; copy dest address in farptr
	mov farptr+2,acc24+2
	mov farptr+1,acc24+1
	mov farptr,acc24
    call number 
	ld a, pad 
	jreq move_missing_arg ; count manquant 
	ld a, acc24+1 
	ld yh, a
	ld a, acc24+2 
	ld yl,a  ; Y = count
	ldw (COUNT,sp),y
	; put back source in acc24
	ld a,(SOURCE,sp)
	ld acc24,a
	ld a,(SOURCE+1,sp) 
	ld acc24+1,a 
	ld a,(SOURCE+2,sp)
	ld acc24+2,a
	clrw x
move_loop:
    ldf a,([acc24],x)
	call write_byte
    incw x
	ldw y, (COUNT,sp)
	decw y
	jreq move_exit
    ldw (COUNT,sp),y
    jra move_loop
	jra move_exit
move_missing_arg:
	call error_print 	
move_exit:
    addw sp,#LOCAL_SIZE
    ret
    
;------------------------------------
;  s addr mask, set bitmask 
;------------------------------------
set_bits:
	pushw x 
	pushw y 
	call number 
	ld a, pad 
	jreq 8$ ; arguments manquant
	ldw x, #acc24
	ldw y, #farptr 
	call copy_var24 
	call number  
	ld a, pad 
	jreq 8$ ; mask manquant
	ldf a,[farptr]
	or a, acc24+2
	clrw x 
	call write_byte 
	jp 9$
8$: call error_print
9$:
	popw y 
	popw x 
    ret
    
;------------------------------------
; t addr mask, toggle bitmask
;------------------------------------
toggle_bits:
	pushw x 
	pushw y 
	call number
	ld a, pad
	jreq 8$  ; pas d'adresse 
	ldw x,#acc24 
	ldw y,#farptr
	call copy_var24
    call number
	ld a, pad 
	jreq 8$ ; pas de masque 
	ldf a,[farptr]
    xor a,acc24+2
    clrw x 
	call write_byte 
	jp 9$
8$: call error_print
9$:
	popw y
 	popw x 
    ret
    
;------------------------------------
; x addr, execute programme
; addr < $10000 (<65536)
;------------------------------------
execute:
	call number
	ld a, pad 
	jreq no_addr ; addr manquante 
	tnz acc24
	jrne 9$ ; adresse > 0xFFFF ; adresse invalide.
	ld a, acc24+1
	ld yh,a 
	or a, acc24+2 
	jreq 9$ ; pointeur NULL 
	ld a,acc24+2 
	ld yl,a 
	jp (y)
9$: inc a

no_addr:
	ld a,[flash_free_base]
	jreq error_print 
	jp [flash_free_base]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print error messages
; input:
;	A 		error code 
; output:
;	none 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
error_print::
	cp a,#0 ; missing argment
	jrne 1$
	ldw y, #MISS_ARG
	jra 9$
1$: ldw y, #BAD_ARG
9$:	call uart_print 
	ret

;------------------------
;  run time CONSTANTS
;------------------------
; messages strings
;------------------------	
VERSION:	.asciz "\nMONA VERSION %c.%c\n"
CPU_MODEL:  .asciz "stm8s208rb     memory map\n----------------------------\n"
RAM_FREE_MSG: .asciz "ram free: "
RAM_LAST_FREE_MSG: .asciz "- $16FF\n"
FLASH_FREE_MSG: .asciz "free flash: "
EEPROM_MSG: .ascii " - $27FFF\n"
            .ascii "eeprom: $4000 - $47ff\n"
            .ascii "option: $4800 - $487f\n"
            .ascii "SFR: $5000 - $57FF\n"
            .asciz "boot ROM: $6000 - $67FF\n"
BAD_CMD:    .asciz " is not a command\n"	
HELP: .ascii "commands:\n"
	  .ascii "@ addr, display content at address\n"
	  .ascii "! addr byte|string [byte|string ]*, store bytes or string at addr++\n"
	  .ascii "?, diplay command help\n"
	  .ascii "b n|$n, convert n in the other base\n"
	  .ascii "c addr bitmask, clear bits at address\n"
	  .ascii "e addr count, clear memory range\n" 
	  .ascii "f addr [i] string, find string in memory\n"
	  .ascii "h addr, hex dump memory starting at address\n"
	  .ascii "m src dest count, move memory block\n"
	  .ascii "q , quit MONA after a trap entry.\n"
	  .ascii "r reset MCU\n"
	  .ascii "s addr bitmask, set bits at address\n"
	  .ascii "t addr bitmask, toggle bits at address\n"
	  .asciz "x addr, execute  code at address\n"
MISS_ARG: .asciz "Missing arguments\n"
BAD_ARG:  .asciz "bad arguments\n"
