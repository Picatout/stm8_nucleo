;  MONA   MONitor written in Assembly
	.module MONA 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
;	.list
	.page

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
;		.byte 0,0,255,0,255,0,255,0,255,0,255
		
;--------------------------------------------------------
; ram uninitialized variables
;--------------------------------------------------------
		STACK_BASE = RAM_SIZE-1 ; stack at end of ram
		TIB_SIZE = 80
		PAD_SIZE = 80
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
acc16:  .blkw 1; 16 bits accumulator
ram_free_base: .blkw 1
flash_free_base: .blkw 1
		
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
        .area INITIALIZED
        
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
;	ldw cntdwn,y
;1$:	ldw y,cntdwn
;	jrne 1$
;    ret
    
init0:
	_no_interrupts
	call clock_init
;	clr ticks
;	clr cntdwn
	ld a,#255
	ld rx_char,a
;	call timer4_init
	call uart3_init
	_ledenable
	_ledoff
	clr in.w ; must always be 0
	; clear stack
	ldw x,#STACK_BASE
clear_ram0:
	clr (x)
	incw x
	cpw x,#STACK_BASE-1	
	jrule clear_ram0

	; initialize SP
	ldw x,#0x7FE
	ldw sp,x
	; initialize free_ram_base 
	ldw y,#ram_free_base
	addw y,#0xf
	ld a,yl
	and a,#0xf0
	ld yl,a
	ldw ram_free_base,y
	; initialize flash_free_base
	ldw y,#flash_free
	addw y,#0xff
	clr a
	ld yl,a
	ldw flash_free_base,y
main:
	_interrupts
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
	; read execute print loop
repl:
	ld a,#NL
	call uart_tx
	ld a,#'>
	call uart_tx
	call readln
	tnz count
	jreq repl
	clr in
	call eval
	jra repl
	 

;	interrupt NonHandledInterrupt
NonHandledInterrupt:
	iret

	; TIMER4 interrupt service
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

	; uart3 receive interrupt service
uart_rx_isr:
    push a
    ld a, UART3_SR
    ld (1,sp),a
	ld a, UART3_DR
	tnz (1,sp)
	jreq 1$
    ld rx_char,a
1$: pop a
	iret
	

	; transmit character in a via UART3
	; character to transmit on (3,sp)
uart_tx:
	tnz UART3_SR
	jrpl uart_tx
	ld UART3_DR,a
    ret

	; send string via UART2
	; y is pointer to str
uart_print:
	ld a,(y)
	jreq 1$
	call uart_tx
	incw y
	jra uart_print
1$: ret

	 ; check if char available
uart_qchar:
	ld a,#255
	cp a,rx_char
    ret

ungetchar: ; return char ina A to queue
	_no_interrupts
	ld rx_char,a
    _interrupts
    ret
    
	 ; return character from uart2
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

	; delete n character from input line
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


    ;lecture d'une ligne de texte
    ; dans le tib
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
	
	; skip character c in tib starting from 'in'
	; input: 
	;    a character to skip
	; output:  'in' ajusted to new position
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
	
	; scan tib for charater 'c' starting from 'in'
	; input:
	;    a character to skip
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

	; scan tib for next word
	; move word in 'pad'
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
	
	
	; copy n character from (x) to (y)
	; input:
	;   	x   source pointer
	;       idx_x index in (x)
	;       y   destination pointer
	;       idx_y  index in (y)
	;       a   number of character to copy
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
		
	; convert integer to string
	; input:
	;   a  base
	;	y  integer to convert
	; output:
	;   y  pointer to string
itoa:
	SIGN=1
	BASE=2
	LOCAL_SIZE=2
	pushw x
	push a  ; base
	push #0 ; sign
	cp a,#10
	jrne 1$
	ldw acc16,y
	btjf acc16,#7,1$
	cpl (SIGN,sp)
	negw y
	; initialize string pointer 
1$:	ldw x,#PAD_SIZE-1
	ldw acc16,x
	ldw x,#pad
	addw x,acc16
	clr (x)
	decw x
	ld a,#SPACE
	ld (x),a
	clr acc16
	clr acc16+1
itoa_loop:
    ld a,(BASE,sp)
    div y,a
    add a,#'0
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: decw x
    ld (x),a
    cpw y,acc16
    jrne itoa_loop
	; copy string pointer in y
    ldw acc16,x
    ldw y,acc16
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

	;multiply Y=A*Y	
	; input:
	;    Y uint16_t
	;    A uint8_t
	; output:
	;   Y uint16_t product modulo 65535
mul16x8:
	pushw x ; save x
	ldw x, acc16 ; save it
	pushw x
	ldw x,y
	mul x,a ; a*yl
	ldw acc16,x
	swapw y
	mul y,a ; a*yh
	; y*=256
	swapw y
	clr a
	ld yl,a
	addw y,acc16
	popw x ; restore acc16
	ldw acc16,x
	popw x ; restore x
	ret

	; check if character in {'0'..'9'}
	; input:
	;    a  character to test
	; output:
	;    a  0|1
is_digit:
	cp a,#'0
	jrpl 1$
0$:	clr a
	ret
1$: cp a,#'9
    jrugt 0$
    ld a,#1
    ret
	
	; check if character in {'0'..'9','A'..'F'}
	; input:
	;   a  character to test
	; output:
	;   a   0|1 
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
            	
	; convert alpha to uppercase
	; input:
	;    a  character to convert
	; output:
	;    a  uppercase character
a_upper:
	cp a,#'a
	jrpl 1$
0$:	ret
1$: cp a,#'z	
	jrugt 0$
	sub a,#32
	ret
	
	; convert pad content in integer
	; input:
	;    pad
	; output:
	;    y
atoi:
	; local variables
	SIGN=1 ; 1 byte, 
	BASE=2 ; 1 byte, numeric base used in conversion
	TEMP=3 ; 1 byte, temporary storage
	LOCAL_SIZE=3 ; 3 bytes reserved for local storage
	pushw x ;save x
	sub sp,#LOCAL_SIZE
	clr (SIGN,sp)
	ld a,#10
	ld (BASE,sp),a ; default base decimal
	ldw x,#pad ; pointer to string to convert
	clrw y    ; convertion result
	ld a,(x)
	jreq 9$
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
	call mul16x8
	ld a,(TEMP,sp)
	ld acc16+1,a
	clr acc16
	addw y,acc16
	jra 2$
9$:	tnz (SIGN,sp)
    jreq 11$
    negw y
11$: addw sp,#LOCAL_SIZE
	popw x ; restore x
	ret

	;strlen  return ASCIIZ string length
	; input:
	;	y  pointer to string
	; output:
	;	a   length  < 256
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
	
	; peek addr, print byte at this address 
	; input:
	;	 y   address to peek
	;    a   numeric base for convertion
	; output:
	;    print byte value at this address
peek:
	pushw y
    push a
    ld a,(y)
    ld yl,a
    clr a
    ld yh,a
    pop a
    call itoa
    call uart_print
    popw y
    ret	
	
	; get a number from command line next argument
	;  input:
	;	  none
	;  output:
	;    y   uint16_t 
number:
	call next_word
	call atoi
	ret
	
	; write a byte in memory
	; input:
	;    a  byte to write
	;    y  address 
	; output:
	;    none
write_byte:
    cpw y,#FLASH_BASE
    jrpl write_flash
    cpw y,#EEPROM_BASE
	jrmi 1$
	cpw y,#OPTION_END+1  
    jrmi write_eeprom
1$: cpw y,ram_free_base
    jrpl 2$
    ret
2$: cpw y,#STACK_BASE
    jrmi 3$
    jp write_sfr    
3$: ld (y),a
	ret
	; write SFR
write_sfr:
	cpw y,#SFR_BASE
	jrmi 2$
	cpw y,#SFR_END+1
	jrpl 2$
	ld (y),a
2$:	ret
	; write program memory
write_flash:
	cpw y,flash_free_base
	jrpl 0$
	ret
0$:	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
1$:	_no_interrupts
	ld (y),a
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
	cpw y,#OPTION_BASE
	jrmi 1$
	cpw y,#OPTION_END+1
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
    ld (y),a
    incw y
    ld a,(OPT,sp)
    jreq 3$
    ld a,(BYTE,sp)
    cpl a
    ld (y),a
3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	addw sp,#LOCAL_SIZE
    ret
        
		  
	; evaluate command string in tib
	; list of commands
	;   @  addr display content at address
	;   !  addr byte [byte ]* store bytes at address
	;   ?  diplay command help
	;   b  n    convert n in the other base
	;	c  addr bitmask  clear  bits at address
	;   h  addr hex dump memory starting at address
	;   m  src dest count,  move memory block
	;   s  addr bitmask  set a bits at address
	;   t  addr bitmask  toggle bits at address
	;   x  addr execute  code at address  
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
5$:	cp a,#'s
	jrne 6$
	jp set_bits
6$:	cp a,#'t
	jrne 7$
	jp toggle_bits
7$:	cp a,#'x
	jrne 8$
	jp execute
8$:	call uart_print
	ldw y,#BAD_CMD
	call uart_print
	ret
	
	; fetch a byte and display it,  @  addr
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
	
	; store bytes,   !  addr byte [byte ]*
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
	; ? , display command information
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
        	
	; clear bitmask, c addr mask
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
    
    ; hexadecimal dump memory, h addr
    ; stop after each row, SPACE continue, other stop
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
    
    ; move memory block, m src dest count
move_memory:
    SRC=3
    DEST=1
    LOCAL_SIZE=4    
    call number
    pushw y  ; source
    call number
    pushw y  ; destination
    call number 
    ldw acc16,y ; counter
    ldw x,(SRC,sp)  ; source
move_loop:
    ldw y,(DEST,sp)  ; destination
    ld a,(x)
    call write_byte
    incw x
    incw y
    ldw (DEST,sp),y
    ldw y,acc16
    decw y
    ldw acc16,y
    jrne move_loop
    addw sp,#LOCAL_SIZE
    ret
    
    ; clear bitmask,  c addr mask
set_bits:
	call number
	pushw y
	call number
	ld a,yl
	popw y
	or a,(y)
	ld (y),a
    ret
    
    ; toggle bitmask,  t addr mask
toggle_bits:
	call number
    pushw y
    call number
    ld a,yl
    popw y
    xor a,(y)
    ld (y),a
    ret
    
    ; execute binary code,   x addr
execute:
	call number
	jp (y)
	

	
;------------------------
;  run time CONSTANTS
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
	  .ascii "s addr bitmask, set bits at address\n"
	  .ascii "t addr bitmask, toggle bits at address\n"
	  .asciz "x addr, execute  code at address\n"

flash_free:
	
