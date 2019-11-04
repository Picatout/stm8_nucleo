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
; 				version 0.1 adressing range limitation.
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
farptr: .blkb 3; 24 bits pointer
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
	int NonHandledInterrupt ;int29  not used

	.area CODE

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  information printed at reset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_mona_info:
	ld a,#CTRL_L
	call uart_tx
	ldw y,#VERSION
	call uart_print
	ld a, #VERS_MAJOR
	add a,#'0
	call uart_tx
	ld a,#'.'
	call uart_tx
	ld a, #VERS_MINOR
	add a,#'0
	call uart_tx
	ldw y,#CPU_MODEL
	call uart_print
	ldw y,#RAM_FREE_MSG
	call uart_print
	clr acc24
	mov acc24+1,ram_free_base
	mov acc24+2,ram_free_base+1 
	ld a,#16
	call itoa
	call uart_print
	ldw y,#RAM_LAST_FREE_MSG
	call uart_print
	ldw y,#FLASH_FREE_MSG
	call uart_print
	ld a,#16
	mov acc24+1,flash_free_base
	mov acc24+2,flash_free_base+1 
	call itoa
	call uart_print
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
	ldw y,#flash_free
	; align on 128 bytes boundary (block size)
	addw y,#0x7f
	ld a,yl
	and a,#0x80
	ld yl,a
	ldw flash_free_base,y

;------------------------
; program main function
;------------------------
main:	
; enable interrupts
	_int_enable 
; information printed at mcu reset.	
	call print_mona_info
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
	_int_disable
	ld rx_char,a
    _int_enable
    ret
    
;------------------------------------
; wait for character from uart3
;------------------------------------
uart_getchar:
	ld a,#255
	cp a,rx_char
	jreq uart_getchar
	_int_disable
	ld a, rx_char
	push a
	ld a,#-1
	ld rx_char,a
	_int_enable
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        arithmetic operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
mulu24_8:
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
divu24_8:
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
neg_acc24:
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
inc_var24:
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
copy_var24:
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
;------------------------------------
	SIGN=1  ; local variable 
	BASE=2  ; local variable
	LOCAL_SIZE=2  ;locals size
itoa:
	pushw x
	sub sp,#LOCAL_SIZE
	ld (BASE,sp), a  ; base
	clr (SIGN,sp)    ; sign
	cp a,#10
	jrne 1$
	; base 10 string display with negative sign if bit 7==1
	btjf acc24,#7,1$
	cpl (SIGN,sp)
	call neg_acc24
1$:
; initialize string pointer 
	ldw y,#pad+PAD_SIZE-1
	clr (y)
	decw y
	ld a,#SPACE
	ld (y),a
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
	or a,acc24+1
	or a,acc24+2
    jrne itoa_loop
	;conversion done, next add '$' or '-' as required
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
;    A  character to test
; output:
;    A  0|1
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
;    pad		.asciz to convert
; output:
;    acc24      int24_t
;------------------------------------
	; local variables
	SIGN=1 ; 1 byte, 
	BASE=2 ; 1 byte, numeric base used in conversion
	TEMP=3 ; 1 byte, temporary storage
	LOCAL_SIZE=3 ; 3 bytes reserved for local storage
atoi:
	pushw x ;save x
	sub sp,#LOCAL_SIZE
	; acc24=0 
	clr acc24    
	clr acc24+1
	clr acc24+2
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
;	 farptr   address to peek
;    X		  farptr index 	
;    A   	  numeric base for convertion
; output:
;    print byte value at this address
;------------------------------------
peek:
	pushw y
    push a   ; base numérique pour la conversion
	; A=farptr[x]
	ldf a,([farptr],x)
    ld acc24+2,a
    clr acc24 
	clr acc24+1 
	pop a ; base numérique pour la conversion 
    call itoa  ; conversion entier en  .asciz
    call uart_print
    popw y
    ret	
	
;------------------------------------
; expect a number from command line next argument
;  input:
;	  none
;  output:
;    acc24   int24_t 
;------------------------------------
number:
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
	ldw y,#pad
	call uart_print
	ld a,#'=
	call uart_tx	
	ld a,pad
	cp a,#'$
	jreq 1$
	ld a,#10
	jra 2$
1$: ld a,#16	
2$:	clrw x  ; pour farptr[0]
	call peek
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
	jreq store_miss_arg ; pas d'argument adresse 
	ldw x,#acc24
	ldw y,#farptr
	call copy_var24  ; farptr=acc24 
	clrw x ; index pour farptr[x]
1$: call number
	ld a, pad
	jreq store_exit ; pas d'octet à écrire.	
	ld a,acc24+2 ; octet à écrire.
	call write_byte
	incw x ; x++
	jra 1$
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
2$: call itoa
    call uart_print
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
	jreq hdump_missing_arg ; adresse manquante
	ld a,#16
	call atoi ; acc24=addr 
	; farptr = addr 
	ldw x,#acc24
	ldw y,#farptr
	call copy_var24
row_init:
	clrw x 
	ldw (IDX,sp),x
	; affiche l'adresse en début de ligne 
	ldw x,#farptr
	ldw y,#acc24
	call copy_var24
	ld a,#16
	call itoa
	call uart_print
	ld a,#SPACE
	call uart_tx
	ldw y, #pad
	ldw x,(IDX,sp)
row:
	ld a,#16
	call peek
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
	jreq error_print ; addr manquante 
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

error_print:
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
VERSION:	.asciz "\nMONA VERSION "
CPU_MODEL:  .asciz "\nstm8s208rb     memory map\n----------------------------\n"
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
MISS_ARG: .asciz "Missing arguments\n"
BAD_ARG:  .asciz "bad arguments\n"

; following flash memory is not used by MONA
flash_free:
	
