;  MONA   MONitor written in Assembly
	.module MONA 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
;	.list
	.page

;-------------------------------------------------------
; History:
;	2019-10-28  starting work on version 0.2 to remove
; 				version 0.1 adressing limitation.
;
;-------------------------------------------------------

;-------------------------------------------------------
;     vt100 CTRL_x  values
;-------------------------------------------------------
		CTRL_A = 1
		CTRL_B = 2
		CTRL_C = 3
		CTRL_D = 4
		CTRL_E = 5
		CTRL_F = 6
		CTRL_G = 7
		CTRL_H = 8
		CTRL_I = 9
		CTRL_J = 10
		CTRL_K = 11
		CTRL_L = 12
		CTRL_M = 13
		CTRL_N = 14
		CTRL_O = 15
		CTRL_P = 16
		CTRL_Q = 17
		CTRL_R = 18
		CTRL_S = 19
		CTRL_T = 20
		CTRL_U = 21
		CTRL_V = 22
		CTRL_W = 23
		CTRL_X = 24
		CTRL_Y = 25
		CTRL_Z = 26
		ESC = 27
		NL = CTRL_J
		CR = CTRL_M
		BSP = CTRL_H
		SPACE = 32
		
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
		
		
		.macro  _interrupts ; enable interrupts
		 rim
		.endm
		
		.macro _no_interrupts ; disable interrupts
		sim
		.endm

;--------------------------------------------------------
;        OPTION BYTES
;--------------------------------------------------------
;		.area 	OPTION (ABS)
;		.org 0x4800
;		.byte 0     ; 0x4800 ; OPT0 read out protection 
;		.byte 0,255 ; 0x4801 - 0x4802 OPT1 user boot code
;       .byte 0,255 ; 0x4803 - 0x4804 OPT2 alt. fct remapping 
;       .byte 0,255 ; 0x4805 - 0x4806 OPT3 watchdog options
;       .byte 0,255 ; 0x4807 - 0x4808 OPT4 clock options
;       .byte 0,255 ; 0x4809 - 0x480a OPT5 HSE clock startup
;       .byte 0,255 ; 0x480b - 0x480c OPT6 reserved
;       .byte 0,255 ; 0x480d - 0x480e OPT7 flash wait state
		.area BOOTLOADER (ABS)
		.org 0x487e
;       .byte 0,255 ; 0x487e - 0x487f rom bootloader checkpoint
		
;--------------------------------------------------------
;some sont constants used by this program.
;--------------------------------------------------------
		STACK_SIZE = 256 ; call stack size
		STACK_BASE = RAM_SIZE-STACK_SIZE ; lowest address of stack
		STACK_TOP = RAM_SIZE-1 ; stack top at end of ram
		TIB_SIZE = 80 ; transaction input buffer size
		PAD_SIZE = 80 ; workding pad size
		; vesrion major.minor
		VERS_MAJOR = 0 ; major version number
		VERS_MINOR = 2 ; minor version number

;--------------------------------------------------------
;   application variables 
;---------------------------------------------------------		
        .area DATA
;ticks  .blkw 1 ; system ticks at every millisecond        
;cntdwn:	.blkw 1 ; millisecond count down timer
rx_char: .blkb 1 ; last uart received char
in.w:     .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
in:		.blkb 1; parser position in tib
count:  .blkb 1; length of string in tib
idx_x:  .blkw 1; index for table pointed by x
idx_y:  .blkw 1; index for table pointed by y
tib:	.blkb TIB_SIZE ; transaction input buffer
pad:	.blkb PAD_SIZE ; working pad
acc24:  .blkb 3; 24 bits accumulator
farptr: .blkb 3; 24 bits address
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
	int NonHandledInterrupt ;TRAP  software interrupt
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
	int uart_rx_isr         ;int21 UART3 RX full
	int NonHandledInterrupt ;int22 ADC2 end of conversion
	int NonHandledInterrupt	;int23 TIM4 update/overflow
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used

	.area CODE

	;initialize clock to HSE 16Mhz
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
;	bset CLK_PCKENR1,#CLK_PCKENR1_UART3
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN))
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
;	addw y,#0xf
;	ld a,yl
;	and a,#0xf0
;	ld yl,a
	ldw ram_free_base,y
	; initialize flash_free_base variable
	ldw y,#flash_free
	addw y,#0xff
	clr a
	ld yl,a
	ldw flash_free_base,y

;------------------------
; program main function
;------------------------
main:	
; enable interrupts
	_interrupts 
; print startup message.
	ld a,#0xc
	call uart_tx
	ldw y,#VERSION
	call uart_print
	ldw y,#RAM_FREE_MSG
	call uart_print
	ldw y,ram_free_base
	ld a,#16
	call itoa
	call uart_print
	ldw y,#RAM_LAST_FREE_MSG
	call uart_print
	ldw y,#FLASH_FREE_MSG
	call uart_print
	ld a,#16
	ldw y,flash_free_base
	call itoa
	call uart_print
	ldw y,#EEPROM_MSG
	call uart_print
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
	 
;------------------------------------
;	interrupt NonHandledInterrupt
;   non handled interrupt reset MCU
;------------------------------------
NonHandledInterrupt:
	ld a,#0x80
	ld WWDG_CR,a
	;iret

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
uart_rx_isr:
; local variables
  UART_STATUS = 2
  UART_DATA = 1
; read uart registers and save them in local variables  
  ld a, UART3_SR
  push a  ; local variable UART_STATUS
  ld a,UART3_DR
  push a ; local variable UART_DATA
; test uart status register
; bit RXNE must 1
; bits OR|FE|NF must be 0	
  ld a, (UART_STATUS,sp)
; keep only significant bits
  and a, #((1<<UART_SR_RXNE)|(1<<UART_SR_OR)|(1<<UART_SR_FE)|(1<<UART_SR_NF))
; A value shoudl be == (1<<UART_SR_RNXE)  
  cp a, #(1<<UART_SR_RXNE)
  jrne 1$
; no receive error accept it.  
  ld a,(UART_DATA,sp)
  ld rx_char,a
1$: 
; drop local variables
  popw X	
  iret

;------------------------------------
;  serial port communication routines
;------------------------------------
;------------------------------------
; transmit character in a via UART3
; character to transmit on (3,sp)
;------------------------------------
uart_tx:
	tnz UART3_SR
	jrpl uart_tx
	ld UART3_DR,a
    ret

;------------------------------------
; send string via UART2
; y is pointer to str
;------------------------------------
uart_print:
	ld a,(y)
	jreq 1$
	call uart_tx
	incw y
	jra uart_print
1$: ret

;------------------------------------
; check if char available
;------------------------------------
uart_qchar:
	ld a,#255
	cp a,rx_char
    ret

;------------------------------------
; return char in A to queue
;------------------------------------
ungetchar: 
	_no_interrupts
	ld rx_char,a
    _interrupts
    ret
    
;------------------------------------
; return character from uart3
;------------------------------------
uart_getchar:
	ld a,#255
	cp a,rx_char
	jreq uart_getchar
	_no_interrupts
	ld a, rx_char
	push a
	ld a,#-1
	ld rx_char,a
	_interrupts
	pop a
	ret

;------------------------------------
; delete n character from input line
;------------------------------------
uart_delete:
	push a ; n 
del_loop:
	tnz (1,sp)
	jreq 1$
	ld a,#BSP
	call uart_tx
    ld a,#SPACE
    call uart_tx
    ld a,#BSP
    call uart_tx
    dec (1,sp)
    jra del_loop
1$: pop a
	ret 

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
readln:
	; local variables
	LEN = 1  ; accepted line length
	RXCHAR = 2 ; last char received
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
;    a character to skip
; output:  'in' ajusted to new position
;------------------------------------
skip:
	C = 1 ; local var
	push a
	ldw y,#tib
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
;    a character to skip
;------------------------------------
scan: 
	C = 1 ; local var
	push a
	ldw y,#tib
1$:	ld a,([in.w],y)
	jreq 2$
	cp a,(C,sp)
	jreq 2$
	inc in
	jra 1$
2$: pop a
	ret

;------------------------------------
; scan tib for next word
; move word in 'pad'
;------------------------------------
next_word:	
	FIRST = 1
	XSAVE = 2
	sub sp,#3
	ldw (XSAVE,sp),x ; save x
	ld a,#SPACE
	call skip
	ld a,in
	ld (FIRST,sp),a
	ld a,#SPACE
	call scan
	; copy word in pad
	ldw x,#tib  ; source
	clr idx_x
	ld a,(FIRST,sp)
	ld idx_x+1,a
	ldw y,#pad
	clr idx_y
	clr idx_y+1
	ld a,in
	sub a,(FIRST,sp)
	call strcpyn
	ldw x,(XSAVE,sp)
	addw sp,#3
	ret
	
	
;------------------------------------
; copy n character from (x) to (y)
; input:
;   	x   source pointer
;       idx_x index in (x)
;       y   destination pointer
;       idx_y  index in (y)
;       a   number of character to copy
;------------------------------------
strcpyn:
	N = 1 ; local variable count
	push a
1$: ld a,(N,sp)		
	jreq 2$ 
	ld a,([idx_x],x)
	ld ([idx_y],y),a
	inc idx_x+1
	inc idx_y+1
	dec (N,sp)
	jra 1$
2$: clr ([idx_y],y)
	pop a
	ret

;--------------------------------------
; unsigned multiply uint24_t by uint8_t
; use to convert numerical string to uint24_t
; input:
;	U24		argument on stack
;   U8		in A
; output:
;   product   on stack replace U24 input
;-------------------------------------
; offset  on sp of arguments and locals
	U24U = 8   ; U24 most significant byte
	U24M = 9   ; U24 middle byte
	U24L = 10  ; U24 lowest significant byte
	U8   = 3   ; A pushed on stack
	OVFL = 2  ; multiplicaton overflow low byte
	OVFH = 1  ; multiplication overflow high byte, always 0
mulu24_8:
	pushw x   
	push a     ; U8
	clrw x     ; initialize overflow to 0
	pushw x    ; multiplication overflow
; multiply low byte.
	ld a,(U24L,sp)
	ld xl,a
	ld a,(U8,sp)
	mul x,a
	ld a,xl
	ld (U24L,sp),a
	ld a, xh
	ld (OVFL,sp),a
; multipy second byte
	ld a,(U24M,sp)
	ld xl,a
	ld a, (U8,sp)
	mul x,a
; add overflow to this partial product
	addw x,(OVFH,sp)
	ld a,xh
	adc a,#0
	ld (OVFL,sp),a
	ld a, xl
	ld (U24M,sp),a
; multiply most signficant digit	
	ld a, (U24U,sp)
	ld xl, a
	ld a, (U8,sp)
	mul x,a
	addw x, (OVFH,sp)
	ld a, xl
	ld (U24U,sp),a
    addw sp,#3
	popw x
	ret

;-------------------------------------
; divide uint24_t by uint8_t
; used to convert uint24_t to string
; input:
;	U24		argument on stack  dividend
;   U8		argument on stack  divisor
; output:
;   quotient   	on stack replace U24 input
;   A			remainder
;------------------------------------- 
; offset  on sp of arguments and locals
	U24U = 6   ; U24 most significant byte
	U24M = 7   ; U24 middle byte
	U24L = 8  ; U24 lowest significant byte
	U8   = 5   ; divisor on stack
divu24_8:
	pushw x ; save x
	ldw x, (U24U,sp) ; load dividend in x
	ld a,(U8,sp) ; load divisor in A
	div x,a
	ldw (U24U,sp),x ; put partial quotient in U24U:U24M
	ld xh,a  ; remainder form high byte of next dividend
	ld a,(U24L,sp)
	ld xl,a ; low byte of next dividend
	ld a,(U8,sp) ; divisor
	div x,a
	ld xh,a ; preserve remainder
	ld a,xl
	ld (U24L,sp),a ; save least byte of quotient
	ld a, xh  ; return remainder in A
	popw x
	ret

;------------------------------------
;  two's complement acc24
;  input:
;		acc24 variable
;  output:
;		acc24 variable
;-------------------------------------
cpl2_acc24:
	pushw x
	ldw x,#acc24
	cpl (0,x)
	cpl (1,x)
	cpl  (2,x)
	ld a,#1
	add a,(2,x)
	ld (2,x),a
	clr a
	adc a,(1,x)
	ld (1,x),a
	clr a
	adc a,(0,x)
	ld (0,x),a
	popw x
	ret

;----------------------------------------
; increment far pointer (24 bits pointer)
; input:
;    x		pointer address
; output:
;    none
;----------------------------------------
inc_fptr:
	push a
	inc (2,x)
	clr a
	adc a,(1,x)
	ld (1,x),a
	clr a
	adc a,(0,x)
	ld (0,x),a
	pop a
    ret

;---------------------------------------
;  clear acc24
;  input:
;	none
;  output:
;	none
;----------------------------------------
clr_acc24:
	pushw x
	ldw x,#acc24
	clr (0,x)
	clr (1,x)
	clr (2,x)
	popw x
	ret

;------------------------------------
; compare acc24 et farptr
; input:
;    acc24
;    farptr
; output:
;    Z = 1 if equal
;-------------------------------------
cp24:
	pushw x
	pushw y
	ldw x,#acc24
	ldw y,#farptr
	ld a,(0,x)
	cp a,(0,y)
	jrne 9$
	ld a,(1,x)
	cp a,(1,y)
	jrne 9$
	ld a,(2,x)
	cp a,(2,y)
9$: popw y
    popw x
	ret

;------------------------------------
; convert integer to string
; input:
;   a  base
;	acc24  integer to convert
; output:
;   y  pointer to string
;------------------------------------
itoa:
	BASE=1  ; local variable
;   U24 local variable 	
	U24U=2  ; upper byte
	U24M=3  ; middle byte 
	U24L=4  ; lower byte 
	SIGN=5  ; local variable 
	LOCAL_SIZE=5  ;locals size
	pushw x
	sub sp,#LOCAL_SIZE
	ld (BASE,sp), a  ; base
	clr (SIGN,sp) ; sign
	cp a,#10
	jrne 1$
	btjf acc24,#7,1$
	ld a,0xff
	ld (SIGN,sp),a
	call cpl2_acc24
1$:
;   push acc24 , U24 argument for divu24_8
	ldw x, #acc24
	ld a,(2,x)
	ld (U24L,sp),a
	ld a,(1,x)
	ld (U24M,sp),a
	ld a,(0,x)
	ld (U24L,sp),a	
; initialize string pointer 
	ldw x,#PAD_SIZE-1
	ldw acc24,x
	ldw x,#pad
	addw x,acc24
	clr (x)
	decw x
	ld a,#SPACE
	ld (x),a
	clr acc24
	clr acc24+1
	clr acc24+2
itoa_loop:
	call divu24_8
    add a,#'0
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: decw x
    ld (x),a
; check if done i.i. U24==0	
    ld a, (U24U,sp)
	or a, (U24M,sp)
	or a, (U24L,sp)
    jrne itoa_loop
	; copy string pointer in y
    ldw y,x
	ld a,(BASE,sp)
	cp a,#16
	jrne 9$
    call strlen
    cp a,#3
    jreq 8$
    jrult 7$
	cp a,#5
	jreq 8$
7$: decw y
    ld a,#'0
    ld (y),a
8$:	decw y
	ld a,#'$
	ld (y),a
	jra 10$
9$: ld a,(SIGN,sp)
    jreq 10$
    decw y
    ld a,#'-
    ld (y),a
10$:
	addw sp,#LOCAL_SIZE
	popw x
	ret

;------------------------------------
; check if character in {'0'..'9'}
; input:
;    a  character to test
; output:
;    a  0|1
;------------------------------------
is_digit:
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
is_hex:
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
; convert alpha to uppercase
; input:
;    a  character to convert
; output:
;    a  uppercase character
;------------------------------------
a_upper:
	cp a,#'a
	jrpl 1$
0$:	ret
1$: cp a,#'z	
	jrugt 0$
	sub a,#32
	ret
	
;------------------------------------
; convert pad content in integer
; input:
;    pad
; output:
;    acc24
;------------------------------------
atoi:
	; local variables
	BASE=1 ; 1 byte, numeric base used in conversion
	U24U=2 ; U24 upper byte
	U24M=3 ; U24 middle byte
	U24L=4 ; U24 lower byte
	SIGN=5 ; 1 byte, 
	TEMP=6 ; 1 byte, temporary storage
	LOCAL_SIZE=6 ; 6 bytes reserved for local storage
	pushw x ;save x
	sub sp,#LOCAL_SIZE
	clr (SIGN,sp)
	ld a,#10
	ld (BASE,sp),a ; default base decimal
	ldw x,#pad ; pointer to string to convert
	clrw y    ; convertion result
	; set result to 0
	clr (U24U,sp)
	clr (U24M,sp)
	clr (U24L,sp)
	ld a,(x)
	jreq 9$ ; done
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
5$: ld (TEMP,sp),a
	call mulu24_8
	ld a,(TEMP,sp)
	add a,(U24L,sp)
	ld (U24L,sp),a
	clr a
	adc a,(U24M,sp)
	ld (U24M,sp),a
	clr a
	adc a,(U24U,sp)
	ld (U24U,sp),a
	jra 2$
9$:	; transfert result in acc24
	ldw x,#acc24
	ld a, (U24U,sp)
	ld (0,x),a
	ld a, (U24M,sp)
	ld (1,x),a
	ld a,(U24L,sp)
	ld (2,x),a
	tnz (SIGN,sp)
    jreq 11$
    call cpl2_acc24
11$: addw sp,#LOCAL_SIZE
	popw x ; restore x
	ret

;------------------------------------
;strlen  return ASCIIZ string length
; input:
;	y  pointer to string
; output:
;	a   length  < 256
;------------------------------------
strlen:
	LEN=1
    pushw y
    push #0
0$: ld a,(y)
    jreq 1$
    inc (LEN,sp)
    incw y
    jra 0$
1$: pop a
    popw y
    ret
	
;------------------------------------
; peek addr, print byte at this address 
; input:
;	 [addr]   short pointer to address to peek 
;    a   numeric base for convertion
; output:
;    print byte value at this address
;------------------------------------
peek:
	pushw y
    push a
	call clr_acc24
    ldf a,[farptr]
    ldw y,#acc24
	ld (2,y),a
    pop a
    call itoa
    call uart_print
    popw y
    ret	
	
;------------------------------------
; get a number from command line next argument
;  input:
;	  none
;  output:
;    y   uint16_t 
;------------------------------------
number:
	call next_word
	call atoi
	ret
	
;--------------------------
; write a byte in memory
; input:
;    a  	byte to write
;    farptr  address 
; output:
;    none
;--------------------------
write_byte:
	ldw y,#FLASH_BASE
    clr acc24
	ldw acc24+1,y
	call cp24
	jrpl write_flash
    ldw y,#EEPROM_BASE
	ldw acc24+1,y
	call cp24
	jrmi 1$
	ldw y,#OPTION_END+1
	ldw acc24+1,y  
    jrmi write_eeprom
1$: ldw y,ram_free_base
    ldw acc24+1,y
	call cp24
	jrpl 2$
    ret
2$: ldw y,#STACK_TOP+1
    ldw acc24+1,y
	call cp24
	jrmi 3$
    jp write_sfr    
3$: ldf [farptr],a
	ret
	; write SFR
write_sfr:
	ldw y,#SFR_BASE
	ldw acc24+1,y
	call cp24
	jrmi 2$
	ldw y,#SFR_END+1
	ldw acc24+1,y
	call cp24
	jrpl 2$
	ldf [farptr] ,a
2$:	ret
	; write program memory
write_flash:
	ldw y,flash_free_base
	ldw acc24+1,y
	call cp24
	jrpl 0$
	ret
0$:	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
1$:	_no_interrupts
	ldf [farptr],a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
    _interrupts
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
    ret
    ; write eeprom and option
write_eeprom:
	OPT=2
	BYTE=1
	LOCAL_SIZE=2
	push #0
	push a
	; check for data eeprom or option eeprom
	ldw y,#OPTION_BASE
	ldw acc24+1,y
	call cp24
	jrmi 1$
	ldw y,#OPTION_END+1
	ldw acc24+1,y
	call cp24
	jrpl 1$
	cpl (OPT,sp)
1$: mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
    ld a,(OPT,sp)
    jreq 2$
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
2$: btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
    ld a,(BYTE,sp)
    ldf [farptr],a
    pushw x
	ldw x,#farptr
	call inc_fptr
	popw x
    ld a,(OPT,sp)
    jreq 3$
    ld a,(BYTE,sp)
    cpl a
    ldf [farptr],a
3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	addw sp,#LOCAL_SIZE
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
	jrne 3$
	jp clear_bits
3$:	cp a,#'h
	jrne 4$
	jp hexdump
4$:	cp a,#'m
	jrne 5$
	jp move_memory
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
	ldw y,#BAD_CMD
	call uart_print
	ret
	
;------------------------------------
; fetch a byte and display it,  @  addr
;------------------------------------
fetch:
	call number 
	pushw y
	ldw y,#pad
	call uart_print
	ld a,#'=
	call uart_tx	
	popw y
	ld a,pad
	cp a,#'$
	jreq 1$
	ld a,#10
	jra 2$
1$: ld a,#16	
2$:	call peek
	ret
	
;------------------------------------
; store bytes,   !  addr byte [byte ]*
;------------------------------------
store:
	MADDR=1
	call number
	pushw y
1$:	call number
	ld a,yl
	ldw y,(MADDR,sp)
	call write_byte
	ld a,in
	cp a,count
	jreq 2$
	ldw y,(MADDR,sp)
	incw y
	ldw (MADDR,sp),y
	jra 1$
2$:	popw y
	ret

;------------------------------------
; ? , display command information
;------------------------------------
help:
	ldw y, #HELP
	call uart_print
	ret
	; convert from one numeric base to the other
	;  b n|$n
base_convert:
    call number
    ld a,pad
    cp a,#'$
    jrne 1$
    ld a,#10
    jra 2$
1$: ld a,#16
2$: call itoa
    call uart_print
    ret
        	
;------------------------------------
; clear bitmask, c addr mask
;------------------------------------
clear_bits:
	call number
	pushw y
	call number
	ld a,yl
	cpl a
	popw y
	and a,(y)
	ld (y),a
    ret
    
;------------------------------------
; hexadecimal dump memory, h addr
; stop after each row, SPACE continue, other stop
;------------------------------------
hexdump: 
	MADDR = 1
	CNTR = 3 ; loop counter
	LOCAL_SIZE=3
	sub sp,#LOCAL_SIZE
	call number
    ldw (MADDR,sp),y ; save address
row_init:
	ldw x,#pad
	ld a,#16
	call itoa
	call uart_print
	ld a,#SPACE
	call uart_tx
    ld a,#8
    ld (CNTR,sp),a
row:
	ld a,#16
	ldw y,(MADDR,sp)
	call peek
	ld a,(y)
	cp a,#SPACE
	jrpl 1$
	ld a,#SPACE
1$:	cp a,#128
    jrmi 2$
    ld a,#SPACE
2$: ld (x),a
	incw x
	incw y
	ldw (MADDR,sp),y
	dec (CNTR,sp)
	jrne row
	ld a,#SPACE
	call uart_tx
	clr a
	ld (x),a
	pushw y
	ldw y,#pad
	call uart_print
	popw y
	ld a,#NL
	call uart_tx
	call uart_getchar
	cp a,#SPACE
	jreq row_init
    addw sp,#LOCAL_SIZE
    ret
    
;------------------------------------
; move memory block, m src dest count
;------------------------------------
move_memory:
    SRC=3
    DEST=1
    LOCAL_SIZE=4    
    call number
    pushw y  ; source
    call number
    pushw y  ; destination
    call number 
    ldw acc24,y ; counter
    ldw x,(SRC,sp)  ; source
move_loop:
    ldw y,(DEST,sp)  ; destination
    ld a,(x)
    call write_byte
    incw x
    incw y
    ldw (DEST,sp),y
    ldw y,acc24
    decw y
    ldw acc24,y
    jrne move_loop
    addw sp,#LOCAL_SIZE
    ret
    
;------------------------------------
; clear bitmask,  c addr mask
;------------------------------------
set_bits:
	call number
	pushw y
	call number
	ld a,yl
	popw y
	or a,(y)
	ld (y),a
    ret
    
;------------------------------------
; toggle bitmask,  t addr mask
;------------------------------------
toggle_bits:
	call number
    pushw y
    call number
    ld a,yl
    popw y
    xor a,(y)
    ld (y),a
    ret
    
;------------------------------------
; execute binary code,   x addr
;------------------------------------
execute:
	call number
	jp (y)
	
;------------------------
;  run time CONSTANTS
;------------------------
; messages strings
;------------------------	
VERSION:	.asciz "MONA VERSION 0.1\nstm8s208rb     memory map\n---------------------------\n"
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
	  .ascii "! addr byte [byte ]*, store bytes at addr++\n"
	  .ascii "?, diplay command help\n"
	  .ascii "b n|$n, convert n in the other base\n"
	  .ascii "c addr bitmask, clear bits at address\n"
	  .ascii "h addr, hex dump memory starting at address\n"
	  .ascii "m src dest count, move memory block\n"
	  .ascii "r reset MCU\n"
	  .ascii "s addr bitmask, set bits at address\n"
	  .ascii "t addr bitmask, toggle bits at address\n"
	  .asciz "x addr, execute  code at address\n"

; following flash memory is not used by MONA
flash_free:
	