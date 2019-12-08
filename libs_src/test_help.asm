;;
; Copyright Jacques Deschênes 2019 
; This file is part of STM8_NUCLEO 
;
;     STM8_NUCLEO is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     STM8_NUCLEO is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
;   libraries test helper module
;   DATE: 2019-12-07
;   This module is compile as test
;   application main module.
; 
; USAGE:
;   It use 'trap' software interrupt to
;   print registers contents on terminal
;   console. It initiaze UART3 peripheral
;   and use its own i/o routines for 
;   terminal communication as these operations
;   must independant from those in uart.lib and 
;   conio.lib 
;   preferably libraries i/o should use 
;   another UART or suitable device.
; 
;   test application link this library 
;   and insert 'trap' instruction at places 
;   where registers contents must be examined.
;   The trap handler as a simple commande line 
;   that accept only 2 commande 'q' and 'p'.
;   commands p [addr]  can be used to see content 
;   of a specific memory location.
;   ex.  p1 $105   to see 8 bytes from this address.
;   p without address to see next 8.  
;
;   Leave trap handler with 'q' command to resume
;   application under test.
;   
;   This module also export 3 function to control the 
;   on board LED: ledon, ledoff and ledtoggle. 
;
;   The application under test should not overwrite
;   'reset' and 'trap' vector.
;    
;   The 'main' function is part of this module.
;
;   Application under test create 'test_main' function as 
;   a global symbol. this function is called by this 
;   module after initialization is completed. 
;--------------------------------------------------

    .module TEST_HELP

    .nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
    .list 

    .area DATA 
    TIB_SIZE=80
    PAD_SIZE=20 
tib:  .ds TIB_SIZE
pad:  .ds PAD_SIZE
in.w: .blkb 1 
in:   .blkb 1 
count: .blkb 1 
acc24: .blkb 1
acc16: .blkb 1
acc8:  .blkb 1
farptr: .blkb 3

;-----------------------------------
    .area SSEG (ABS)
    STACK_SIZE=256 
    .org RAM_SIZE-STACK_SIZE
    .ds STACK_SIZE 

;--------------------------------------
    .area HOME 
    INT init0
    INT TrapHandler
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

;---------------------------------------
    .area CODE
.asciz "TEST_MAIN"

NonHandledInterrupt:
    .byte 0x71  ; réinitialize le MCU


;------------------------------------
; software interrupt handler  
;------------------------------------
TrapHandler:
	call print_registers
	call cmd_itf
	iret

;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

; initialize UART3, 115200 8N1
; to be used as debug i/o 
uart3_init:
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));
	ret
	
uart3_putc:
	btjf UART3_SR,#UART_SR_TXE,.
	ld UART3_DR,a 
	ret 

uart3_getc:
	btjf UART3_SR,#UART_SR_RXNE,.
	ld a,UART3_DR 
	ret 

uart3_puts:
    ld a,(y)
	jreq 1$
	call uart3_putc 
	incw y 
	jra uart3_puts 
1$:	ret 

uart3_bksp:
	ld a,#BSP 
	call uart3_putc 
	ld a,#SPACE 
	call uart3_putc 
	ld a,#BSP 
	call uart3_putc 
	ret 

uart3_delete:
	push a 
0$:	tnz (1,sp)
	jreq 1$
	call uart3_bksp 
	dec (1,sp)
	jra 0$
1$:	pop a 
	ret


init0:
    ldw x,#RAM_SIZE-1 
    ldw sp,x 
    call clock_init 
    call uart_init 
; configure LED2 pin 
    bset PC_CR1,#LED2_BIT
    bset PC_CR2,#LED2_BIT
    bset PC_DDR,#LED2_BIT
    call main 
_main::
main::
    call test_main 
    jra .

; turn LED on 
_ledon::
ledon::
    bset PC_ODR,#LED2_BIT
    ret 

; turn LED off 
_ledoff::
ledoff::
    bres PC_ODR,#LED2_BIT 
    ret 

; invert LED status 
_ledtoggle::
ledtoggle::
    ld a,#LED2_MASK
    xor a,PC_ODR
    ld PC_ODR,a
    ret 


; affiche les registres sauvegardés
; par l'interruption sur la pile.
print_registers:
	ldw y,#STATES
	call uart3_puts
; print EPC 
	ldw y, #REG_EPC
	call uart3_puts 
	ld a, (11,sp)
	ld acc8,a 
	ld a, (10,sp) 
	ld acc16,a 
	ld a,(9,sp) 
	ld acc24,a
	clrw x  
	ld a,#16
	call print_int  
; print Y 
	ldw y,#REG_Y
	call uart3_puts 
	clr acc24 
	ld a,(8,sp)
	ld acc8,a 
	ld a,(7,sp)
	ld acc16,a 
    clrw x 
	ld a,#16 
	call print_int 
; print X
	ldw y,#REG_X
	call uart3_puts  
	ld a,(6,sp)
	ld acc8,a 
	ld a,(5,sp)
	ld acc16,a 
	ld a,#16 
    clrw x
	call print_int 
; print A 
	ldw y,#REG_A 
	call uart3_puts 
	clr acc16
	ld a, (4,sp) 
	ld acc8,a 
	ld a,#16
    clrw x 
	call print_int 
; print CC 
	ldw y,#REG_CC 
	call uart3_puts 
	ld a, (3,sp) 
	ld acc8,a
	ld a,#16
    clrw x   
	call print_int 
	ld a,#'\n' 
	call uart3_putc  
	ret

USER_ABORT: .asciz "Program aborted by user.\n"
STATES:  .asciz "Registers state at abort point.\n--------------------------\n"
REG_EPC: .asciz "EPC: "
REG_Y:   .asciz "\nY: " 
REG_X:   .asciz "\nX: "
REG_A:   .asciz "\nA: " 
REG_CC:  .asciz "\nCC: "

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
4$: call uart3_puts 
    ld a,#SPACE 
	call uart3_putc 
    addw sp,#LOCAL_SIZE 
	popw y 
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
readln:
	push #0  ; RXCHAR 
	push #0  ; LEN
 	ldw y,#tib ; input buffer
readln_loop:
	call uart3_getc
	ld (RXCHAR,sp),a
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
	call uart3_delete
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
    call uart3_bksp 
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
	call uart3_putc 
	jra readln_loop
readln_quit:
	ld a,(LEN,sp)
	ld count,a
readln_quit2:
	addw sp,#2
	ld a,#NL
	call uart3_putc
	ret

;local variable 
	PSIZE=1
	LOCAL_SIZE=1 
cmd_itf:
	sub sp,#LOCAL_SIZE 
	clr count
	clr farptr 
	clr farptr+1 
	clr farptr+2  
repl:
	ld a,#CR 
	call uart3_putc 
	ld a,#'? 
	call uart3_putc
	clr in.w 
	clr in 
	call readln
	call next_word 
	ldw y,#pad 
	ld a,(y)
	incw y
	cp a,#'q 
	jrne next_test
repl_exit:
	addw sp,#LOCAL_SIZE 	
	ret  
invalid:
	ldw y,#invalid_cmd 
	call uart3_puts 
	jra repl 
next_test:	
    cp a,#'p 
	jrne invalid 
	call number
	ld a, acc24 
	or a,acc16 
	or a,acc8 
	jrne 1$ 
	jra peek_byte  
1$:	ldw x,acc24 
	ldw farptr,x 
	ld a,acc8 
	ld farptr+2,a 
peek_byte:
	call print_farptr 
	ld a,#8 
	ld (PSIZE,sp),a 
	clrw x 
1$:	call peek 
	pushw x 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#16
	call print_int
	popw x 
	dec (PSIZE,sp)
	jrne 1$ 
	ld a,#8 
	add a,farptr+2 
	ld farptr+2,a
	clr a 
	adc a,farptr+1 
	ld farptr+1,a 
	clr a 
	adc a,farptr 
	ld farptr,a 
	jp repl  


invalid_cmd: .asciz "not a command\n" 

print_farptr:
	ld a ,farptr+2 
	ld acc8,a 
	ldw x,farptr 
	ldw acc24,x 
	clrw x 
	ld a,#16 
	call print_int
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
peek:
	ldf a,([farptr],x)
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
	
