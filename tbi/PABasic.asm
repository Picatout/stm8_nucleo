;;
; Copyright Jacques Deschênes 2019 
; This file is part of PABasic 
;
;     PABasic is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     PABasic is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with PABasic.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
;   Implementation of Palo Alto BASIC
;   REF: https://en.wikipedia.org/wiki/Li-Chen_Wang#Palo_Alto_Tiny_BASIC
;   Palo Alto BASIC is 4th version of TinyBasic
;   DATE: 2019-12-17
;
; DEPENDENCIES:
;   This is design to avoid dependicies.
; 
; USAGE:
;   X used as dstack pointer 
;   Y,A   working register 
; 
;--------------------------------------------------

    .module PA_BASIC

    .nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "../inc/gen_macros.inc" 
	.include "pab_macros.inc" 
    .list 

;--------------------------------------
    .area DATA 
;--------------------------------------	
	TIB_SIZE=80
    PAD_SIZE=40
	DSTACK_SIZE=64
	CSTACK_SIZE=128
	CSTACK_EMPTY=RAM_SIZE-1  
	FRUN=0 ; flags run code in variable flags 
in.w:  .blkb 1 ; parser position in tib
in:    .blkb 1 ; low byte of in.w
acc24: .blkb 1 ; 24 accumulator
acc16: .blkb 1
acc8:  .blkb 1
farptr: .blkb 3 ; far pointer 
basicptr: .blkb 3 ; BASIC parse pointer 
dstackptr: .ds 2
lineno: .blkb 2  ; BASIC line number 
txtbgn: .ds 2 ; BASIC text beginning address 
txtend: .ds 2 ; BASIC text end address 
arrayptr: .ds 2 ; address of @ array 
arraysize: .ds 2 ; array size 
flags: .ds 1 ; boolean flags
vars: .ds 2*26 ; BASIC variables A-Z, keep it as but last .
; keep as last variable 
free_ram: ; from here RAM free for BASIC text 

;-----------------------------------
    .area SSEG (ABS)
;-----------------------------------	
    .org RAM_SIZE-CSTACK_SIZE-DSTACK_SIZE-TIB_SIZE-PAD_SIZE
dstack_full:  .ds DSTACK_SIZE  ; expression stack
dstack_unf: ;
tib: .ds TIB_SIZE             ; transaction input buffer
pad: .ds PAD_SIZE             ; working buffer
cstack_full: .ds CSTACK_SIZE   ; control stack 
cstack_unf: ; cstack underflow  


;--------------------------------------
    .area HOME 
;--------------------------------------
    int cold_start
    int TrapHandler
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

;---------------------------------------
    .area CODE
;---------------------------------------
.asciz "PA_BASIC" ; I like to put module name here.
;_dbg 
NonHandledInterrupt:
    .byte 0x71  ; reinitialize MCU


;------------------------------------
; software interrupt handler  
;------------------------------------
TrapHandler:
.if DEBUG 
	call print_registers
	call cmd_itf
.endif 	
	iret

;------------------------------------
; Triggered by pressing USER UserButton 
; on NUCLEO card.
;------------------------------------
UserButtonHandler:
	; wait button release
0$:	ldw x,0xffff
1$: decw x 
	jrne 1$
	btjt USR_BTN_PORT,#USR_BTN_BIT, 2$
	jra 0$
2$:	ldw y,#USER_ABORT
	call puts 
    call print_registers 
	rim 
	ldw x, #RAM_SIZE-1
	ldw sp, x
	jp warm_start


;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

;---------------------------------------------
;   UART3 subroutines
;---------------------------------------------

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
	
putc:
	btjf UART3_SR,#UART_SR_TXE,.
	ld UART3_DR,a 
	ret 

getc:
	btjf UART3_SR,#UART_SR_RXNE,.
	ld a,UART3_DR 
	ret 

puts:
    ld a,(y)
	jreq 1$
	call putc 
	incw y 
	jra puts 
1$:	ret 

bksp:
	ld a,#BSP 
	call putc 
	ld a,#SPACE 
	call putc 
	ld a,#BSP 
	call putc 
	ret 

delete:
	push a 
0$:	tnz (1,sp)
	jreq 1$
	call bksp 
	dec (1,sp)
	jra 0$
1$:	pop a 
	ret

.if DEBUG 
;; print actual registers states 
	_argofs 0  
	_arg R_Y 1 
	_arg R_X 3
	_arg R_A 5
	_arg R_CC 6
prt_regs:
	ldw y,#regs_state 
	call puts
; register CC 
	ld a,(R_CC,sp)
	ldw y,#REG_CC 
	call prt_reg8 
; register A 
	ld a,(R_A,sp)
	ldw y,#REG_A 
	call prt_reg8 
; register X 
	ldw x,(R_X,sp)
	ldw y,#REG_X 
	call prt_reg16 
; register Y 
	ldw x,(R_Y,sp)
	ldw y,#REG_Y 
	call prt_reg16 
; register SP 
	ldw x,sp
	addw x,#6+ARG_OFS  
	ldw y,#REG_SP
	call prt_reg16
	ld a,#CR 
	call putc
	call putc   
	ret 

regs_state: .asciz "\nregisters state\n--------------------"
.endif 

;--------------------
; print content at address in hex.
; input:
;   X 	address to peek 
; output:
;	none 
;--------------------	
prt_peek:
	pushw x 
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#16 
	call prti24 
	ld a,#': 
	call putc 
	ld a,#SPACE 
	call putc 
	popw x 
	ld a,(x)
	ld acc8,a 
	clrw x 
	ld a,#16 
	call prti24
	ret 

;-------------------------------------
; retrun string length
;-------------------------------------
strlen: ;	{ addr -- length }
	ldw y,x 
	ldw y,(y)
	clr (x)
	clr (1,x) 
1$:	tnz (y) 
	jreq 9$ 
	inc (1,x)
	jrne 2$
	inc (x)
2$:	incw y 
	jra 1$ 
9$: ret 


;---------------------------------------
; move memory block 
; registers use:
;   X 		destination 
;   Y 	    source 
;   acc16	size 
;--------------------------------------
	INCR=1 ; increament high byte 
	LB=2 ; increament low byte 
	VSIZE=2
move: ; {dest src count -- }
	ldw dstackptr,x 
	clrw y  
	pushw y  ; incr on cstack 
	_dpop  ; { dest src -- }
	ldw acc16,y ; acc16=count   
	_dpop ; y=src 	
	ldw x,(x)
	pushw y 
	cpw x,(1,sp) ; compare DEST to SRC 
	popw y 
	jreq move_exit ; x==y 
	jrmi move_down
move_up: ; start from top address with incr=-1
	addw x,acc16
	addw y,acc16
	cpl (INCR,sp)
	cpl (LB,sp)   ; increment = -1 
	jra move_loop  
move_down: ; start from bottom address with incr=1 
    decw x 
	decw y
	inc (INCR+1,sp) ; incr=1 
move_loop:	
    ld a, acc16 
	or a, acc8
	jreq move_exit 
	addw x,(INCR,sp)
	addw y,(INCR,sp) 
	ld a,(y)
	ld (x),a 
	dec acc8
	jrpl move_loop
	dec acc16
	jra move_loop
move_exit:
	addw sp,#VSIZE ; drop increment 
	ldw x,dstackptr
	_ddrop 3 ; drop move arguments 
	ret 	

;-------------------------------------
; search text area for a line with 
; same number as lineno  
;-------------------------------------
	LL=1 ; line length 
	LB=2 ; line length low byte 
	VSIZE=2 
search_lineno: ; {lineno -- addr|0 }
	ldw y,x 
	ldw y,(y) 
	ldw acc16,y 
	ldw dstackptr,x 
	sub sp,#VSIZE
	clr (LL,sp)
	ldw x,txtend 
	ldw y,txtbgn
search_ln_loop:
	pushw y
	cpw x,(1,sp)
	popw y  
	jrpl 8$ 
	ld a,(1,y) 
	cp a,acc8 
	jrne 2$
	ld a,(y) 
	cp a,acc16 
	jreq 9$
2$:	addw y,#2  
	ld a,(y)
	ld (LB,sp),a
	incw y  
	addw y,(LL,sp)
	jra search_ln_loop 
8$: clrw y 	
9$: 	
	_drop VSIZE
	ldw x,dstackptr
	ldw (x),y   
	ret 

;-------------------------------------
; delete line which is at addr
;-------------------------------------
del_line: ; {addr -- }
	ldw y,x 
	ldw y,(y)
	ld a,(2,y) ; line length
	ld acc8,a 
	clr acc16 
; keek it to adjust txtend after move 
	push a
	push #0  
	addw y,acc16
	addw y,#3  
	_dpush  ; {dest src -- }    
	ldw acc16,y 
	ldw y,txtend 
	subw y,acc16 ; y=count 
	_dpush  ; {dest src count -- }
	call move
	popw y 
	ldw acc16,y 
	ldw y,txtend 
	subw y,acc16 
	ldw txtend,y    
	ret 

;---------------------------------------------
; create a gap in text area 
;--------------------------------------------
create_gap: ; {addr length -- addr }
	_dpop 
	ldw acc16,y 
	ldw y,x 
	ldw y,(y) 
	addw y,acc16 
	_dpush  ; {addr dest -- }
	_over ; {addr dest src -- }
	ldw y,x 
	ldw y,(y)

	ret 

;--------------------------------------------
; insert line in text area 
; input:
;   X 		line number 
;   Y 		address of insert 
; output:
;   none
;---------------------------------------------
insert_line:
	cpw y,txtend
	jrpl 4$ 

4$: ; insert at end. 
	ldw y,txtend 
	ldw (y),x  
	addw y,#2
	ldw x,#tib 
	addw x,in.w
	pushw y  
	call strlen
	ldw acc16,y  
	popw y 
	exgw x,y 
	call move 
	incw x 
	ldw txtend,x 
	ret
	

;-------------------------------------
; check if A is a letter
; input:
;   A 			character to test 
; output:
;   C flag      1 true, 0 false 
;-------------------------------------
is_alpha:
	cp a,#'A 
	ccf 
	jrnc 9$ 
	cp a,#'Z+1 
	jrc 9$ 
	cp a,#'a 
	ccf 
	jrnc 9$
	cp a,#'z+1   
9$: ret 	

;-------------------------------------
;  program initialization entry point 
;-------------------------------------
	MAJOR=1
	MINOR=0
software: .asciz "\n\nPalo Alto BASIC for STM8\nCopyright, Jacques Deschenes 2019,2020\nversion "
cold_start:
    ldw x,#CSTACK_EMPTY 
    ldw sp,x
    call clock_init 
    call uart3_init
; activate PE_4 (user button interrupt)
    bset PE_CR2,#USR_BTN_BIT
	ldw y,#software 
	call puts 
	ld a,#MAJOR 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#10 
	call prti24 
	ld a,#'.
	call putc 
	ld a,#MINOR 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#10 
	call prti24 
	ld a,#CR 
	call putc 
; configure LED2 pin 
    bset PC_CR1,#LED2_BIT
    bset PC_CR2,#LED2_BIT
    bset PC_DDR,#LED2_BIT
    jra warm_start 

err_msg: 
.if CHECK_DSTK
dstk_err_msg:
	.word err_dstk_unf, err_dstk_ovf

err_dstk_unf: .asciz "arguments stack underflow\n" 
err_dstk_ovf: .asciz "arguments stack overflow\n" 
.endif 

tb_error:
	ldw y, #err_msg 
	sll a 
	ld acc8, a 
	clr acc16 
	addw y,acc16 
	ldw y,(y)
	call puts 
    ldw x,#CSTACK_EMPTY 
    ldw sp,x
warm_start:
	ldw x,#dstack_unf  
	ldw dstackptr,x ; save pointer 
	ldw x,#free_ram 
	ldw txtbgn,x 
	ldw txtend,x 
	clrw x 
	ldw lineno,x 
interp:
	clr in.w
	clr in
	ld a,#CR 
	call putc 
	ld a,#'> 
	call putc 
	call readln
; skip white space 	
	ldw y,#tib
	ld a,#SPACE   
	call skip
	tnz ([in.w],y)  
	jreq interp 
	call next_word
; if line start with a number
; save it in text area and loop to interp	
	ld a,pad 
	call is_digit 
	jrne 1$ 
; convert number string to integer 
	call atoi
; check if this line number exist  
; if exist replace with new line 
; or if new line empty delete existing 
; else insert new line 	 
	call search_lineno
; X = lineno if exist otherwise 0.


	ld a,#'d 
	cp a,pad 
	jrne 2$ 
	trap 
	jra interp 
2$:	ld a,pad 
	call is_digit 
	jrnc 1$ 
	call atoi 
	clrw x 
	ld a,#10 
	call prti24 
	jra interp 
1$: 
	call upper
	call search_dict 
	_dpop 
	tnzw y 
	jrne 3$
	tnz pad+1
	call is_alpha 
3$:	call (y)
	jra interp

    trap 
	.blkb 0x71 ; reset MCU

;----------------------------------------
;   exported LED control functions
;----------------------------------------

; turn LED on 
ledon:
    bset PC_ODR,#LED2_BIT
    ret 

; turn LED off 
ledoff:
    bres PC_ODR,#LED2_BIT 
    ret 

; invert LED status 
ledtoggle:
    ld a,#LED2_MASK
    xor a,PC_ODR
    ld PC_ODR,a
    ret 

left_paren:
	ld a,#SPACE 
	call putc
	ld a,#'( 
	call putc 	
	ret 

;------------------------------
; print 8 bit register 
; input:
;   Y  point to register name 
;   A  register value to print 
; output:
;   none
;------------------------------- 
prt_reg8:
	push a 
	call puts 
	ld a,(1,sp) 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#16 
	call prti24 
	call left_paren 
	pop a 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#10 
	call prti24 
	ld a,#') 
	call putc
	ret

;--------------------------------
; print 16 bits register 
; input:
;   Y   point register name 
;   X   register value to print 
; output:
;  none
;--------------------------------
prt_reg16: 
	pushw x 
	call puts 
	ldw x,(1,sp) 
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#16 
	call prti24 
	call left_paren 
	popw x 
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#10 
	call prti24 
	ld a,#') 
	call putc
	ret 


;------------------------------------
; print registers contents saved on
; stack by trap interrupt.
;------------------------------------
print_registers:
	ldw y,#STATES
	call puts
; print EPC 
	ldw y, #REG_EPC
	call puts 
	ld a, (11,sp)
	ld acc8,a 
	ld a, (10,sp) 
	ld acc16,a 
	ld a,(9,sp) 
	ld acc24,a
	clrw x  
	ld a,#16
	call prti24  
; print X
	ldw y,#REG_X
	ldw x,(5,sp)
	call prt_reg16  
; print Y 
	ldw y,#REG_Y
	ldw x, (7,sp)
	call prt_reg16  
; print A 
	ldw y,#REG_A
	ld a, (4,sp) 
	call prt_reg8
; print CC 
	ldw y,#REG_CC 
	ld a, (3,sp) 
	call prt_reg8 
; print SP 
	ldw y,#REG_SP
	ldw x,sp 
	addw x,#12
	call prt_reg16  
	ld a,#'\n' 
	call putc
	ret

USER_ABORT: .asciz "Program aborted by user.\n"
STATES:  .asciz "\nRegisters state at abort point.\n--------------------------\n"
REG_EPC: .asciz "EPC: "
REG_Y:   .asciz "\nY: " 
REG_X:   .asciz "\nX: "
REG_A:   .asciz "\nA: " 
REG_CC:  .asciz "\nCC: "
REG_SP:  .asciz "\nSP: "

;------------------------------------
; print integer in acc24 
; input:
;	acc24 		integer to print 
;	A 			numerical base for conversion 
;               if bit 7 is set add a space at print end.
;   XL 			field width, 0 -> no fill.
;  output:
;    none 
;------------------------------------
	WIDTH = 1
	BASE = 2
	ADD_SPACE=3
	LOCAL_SIZE = 3
prti24:
	pushw y 
	sub sp,#LOCAL_SIZE 
	ld (ADD_SPACE,sp),a 
	and a,#31 
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
4$: call puts 
	ld a,#0x80
	bcp a,(ADD_SPACE,sp)
	jreq 5$
    ld a,#SPACE 
	call putc 
5$: addw sp,#LOCAL_SIZE 
	popw y 
    ret	

;-----------------------------
; intialize parser ready for
; for a new line analysis
; input:
;   none
; output:
;	none 
;------------------------------
parser_init::
	clr in.w 
	clr in
	clr pad  
	ret 

;------------------------------------
; convert integer to string
; input:
;   A	  	base
;	acc24	integer to convert
; output:
;   y  		pointer to string
;------------------------------------
	SIGN=1  ; integer sign 
	BASE=2  ; numeric base 
	LOCAL_SIZE=2  ;locals size
itoa:
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


;------------------------------------
; read a line of text from terminal
; input:
;	none
; local variable on stack:
;	LL (1,sp)
;   RXCHAR (2,sp)
; output:
;   text in tib  buffer
;------------------------------------
	; local variables
	LL = 1  ; accepted line length
	RXCHAR = 2 ; last char received
readln:
	push #0  ; RXCHAR 
	push #0  ; LL
 	ldw y,#tib ; input buffer
readln_loop:
	call getc
	ld (RXCHAR,sp),a
	cp a,#CR
	jrne 1$
	jp readln_quit
1$:	cp a,#NL
	jreq readln_quit
	cp a,#BSP
	jreq del_back
	cp a,#CTRL_D
	jreq del_ln
	cp a,#CTRL_R 
	jreq reprint 
	cp a,#SPACE
	jrpl accept_char
	jra readln_loop
reprint: 
	tnz (LL,sp)
	jrne readln_loop
	ldw y,#tib 
	call puts
	jra readln_loop 
del_ln:
	ld a,(LL,sp)
	call delete
	ldw y,#tib
	clr (LL,sp)
	jra readln_loop
del_back:
    tnz (LL,sp)
    jreq readln_loop
    dec (LL,sp)
    decw y
    clr  (y)
    call bksp 
    jra readln_loop	
accept_char:
	ld a,#TIB_SIZE-1
	cp a, (LL,sp)
	jreq readln_loop
	ld a,(RXCHAR,sp)
	ld (y),a
	inc (LL,sp)
	incw y
	clr (y)
	call putc 
	jra readln_loop
readln_quit:
	addw sp,#2
	ld a,#NL
	call putc
	ret

.if DEBUG 	
;----------------------------
; command interface
; only 2 commands:
;  'q' to resume application
;  'p [addr]' to print memory values 
;  's addr' to print string 
;----------------------------
;local variable 
	PSIZE=1
	LOCAL_SIZE=1 
cmd_itf:
	sub sp,#LOCAL_SIZE 
	clr farptr 
	clr farptr+1 
	clr farptr+2  
repl:
	ld a,#CR 
	call putc 
	ld a,#'? 
	call putc
	clr in.w 
	clr in 
	call readln
	call next_word
	ldw y,#pad 
	ld a,(y)
	incw y
	cp a,#'q 
	jrne test_p
repl_exit:
	addw sp,#LOCAL_SIZE 	
	ret  
invalid:
	ldw y,#invalid_cmd 
	call puts 
	jra repl 
test_p:	
    cp a,#'p 
	jreq mem_peek
    cp a,#'s 
	jrne invalid 
print_string:	
	call number
	ldw y,acc16 
	call puts
	jp repl 	
mem_peek:	 
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
1$:	call fetchc  
	pushw x 
	ld acc8,a 
	clrw x 
	ldw acc24,x 
	ld a,#16+128
	call prti24
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
.endif 

;----------------------------
; display farptr address
;----------------------------
print_farptr:
	ld a ,farptr+2 
	ld acc8,a 
	ldw x,farptr 
	ldw acc24,x 
	clrw x 
	ld a,#16 
	call prti24
	ld a,#SPACE 
	call putc 
	call putc 
	ret

;------------------------------------
; get byte at address farptr[X]
; input:
;	 farptr   address to peek
;    X		  farptr index 	
; output:
;	 A 		  byte from memory  
;    x		  incremented by 1
;------------------------------------
fetchc: ; @C
	ldf a,([farptr],x)
	incw x
	ret


;------------------------------------
; expect a number from command line 
; next argument
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
; input: 
	none: 
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

;------------------------------------
; check if character in {'0'..'9'}
; input:
;    A  character to test
; output:
;    Carry  0 not digit | 1 digit
;------------------------------------
is_digit:
	cp a,#'0
	jrc 1$
    cp a,#'9+1
	ccf 
1$:	ccf 
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
; concert pad contend in uppercase 
; input:
;	pad      .asciz 
; output:
;   pad      uppercase string 
;------------------------------------
upper:
	ldw y,#pad 
upper_loop:	
	ld a,(y)
	jreq 4$
	cp a,#'a 
	jrmi 4$
	cp a,#'z+1 
	jrpl 4$ 
	sub a,#0x20 
	ld (y),a 
	incw y 
	jra upper_loop
4$: ret 

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
    call neg_acc24
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
	
;---------------------------------
; input:
;  pad		.asciz name to search 
; output:
;  dstack	execution address | 0 
;---------------------------------
search_dict:
	pushw x 
	pushw y 
	ldw y,#last+2 
search_loop:
	ldw x,#pad 
	pushw y
	incw y  
cp_loop:
	ld a,(x)
	jreq str_match 
	cp a,#'.
	jreq str_match
	cp a,(y)
	jrne no_match 
	incw y 
	incw x 
	jra cp_loop 
no_match:
	popw y 
	addw y,#-2 
	ldw y,(y)
	jrne search_loop 
;not found 
	_dpush
	jra search_exit 
str_match:
	popw y
	ld a,(y) ; len field 
	add a,#2  
	push a 
	push 0 
	addw y,(1,sp)
	addw sp,#2
	ldw y,(y)
	_dpush
search_exit: 	 
	popw y 
	popw x 
	ret 

; increment T 
oneplus: ; { n -- n+1 }
	inc (1,x)
	jrne 1$ 
	inc (x)
1$: ret 

; decrement T 
oneminus: ; {n -- n-1 }
	dec (1,x)
	jrpl 1$ 
	dec (x)
1$:	ret 

; copy second element 
dover: ; { n1 n2 -- n1 n2 n1 }
    .if CHECK_DSTK
    cpw x,#dstack_full+CELL_SIZE 
    jrpl 1$
    ld a,#ERR_DSTK_OVF
	.endif 
    jp tb_error  
1$: ldw y,x 
	ldw y,(2,y)
	subw x,#CELL_SIZE
	ldw (x),y 
	ret 

; swap top 2 elements 
dswap: ; {n1 n2 -- n2 n1 }
    ldw y,x 
	ldw y,(y)
    pushw y
	ldw y,x  
    ldw y,(2,y)
    ldw (x),y 
    popw y 
    ldw (2,x),y 
	ret

; duplicate top element 
ddup: ; { n -- n n }
    .if CHECK_DSTK
    cpw x,#dstack_full+CELL_SIZE 
    jrpl .+5
    ld a,#ERR_DSTK_OVF
    jp tb_error
    .endif   
    ldw y,x 
    ldw y,(y)
    subw x,#CELL_SIZE
	ldw (x),y  
	ret 




;--------------------------------
;   BASIC commnands 
;--------------------------------
let:
	ldw y,#LET+1 
	call puts
	ret 

list:
	ldw y,#LIST+1 
	call puts
	ret 

print:
	ldw y,#PRINT+1 
	call puts 
	ret 

run: 
	ldw y,#RUN+1 
	call puts 
	ret 

rem: 
	ldw y,#REM+1 
	call puts 
	ret 

input:
	ldw y,#INPUT+1 
	call puts 
	ret 

out:
	ldw y,#OUT+1 
	call puts 
	ret 

wait: 
	ldw y,#WAIT+1 
	call puts 
	ret 

poke:
	ldw y,#POKE+1 
	call puts 
	ret 

peek:
	ldw y,#PEEK+1 
	call puts 
	ret 

if:
	ldw y,#IF+1 
	call puts 
	ret 

for:
	ldw y,#FOR+1 
	call puts 
	ret 

next: 
	ldw y,#NEXT+1 
	call puts 
	ret 


goto:
	ldw y,#GOTO+1 
	call puts 
	ret 

gosub:
	ldw y,#GOSUB+1 
	call puts 
	ret 

return:
	ldw y,#RETURN+1 
	call puts 
	ret 

stop: 
	ldw y,#STOP+1 
	call puts 
	ret 

new: 
	ldw y,#NEW+1 
	call puts 
	ret 

save:
	ldw y,#SAVE+1 
	call puts 
	ret 

load:
	ldw y,#LOAD+1 
	call puts 
	ret 

usr:
	ldw y,#USR+1 
	call puts 
	ret 

on: 
	ldw y,#ON+1 
	call puts 
	ret 

;------------------------------
;      dictionary 
; format:
;   link   2 bytes 
;   cmd_name 8 byte max 
;   code_address 2 bytes 
;------------------------------
	.macro _dict_entry len,name,cmd 
	.word LINK 
	LINK=.
name:
	.byte len 	
	.asciz "name"
	.word cmd 
	.endm 

	LINK=0
dict_end:
	_dict_entry 3,DEC,oneminus 
	_dict_entry 3,INC,oneplus 
	_dict_entry 4,OVER,dover 
	_dict_entry 4,SWAP,dswap
	_dict_entry 3,DUP,ddup 
	_dict_entry 3,LEN,strlen 

	_dict_entry 5,INPUT,input 
	_dict_entry 3,OUT,out 
	_dict_entry 4,WAIT,wait 
	_dict_entry 3,REM,rem 
    _dict_entry 3,RUN,run
	_dict_entry 5,PRINT,print 
	_dict_entry 4,LIST,list
	_dict_entry,2,IF,if 
	_dict_entry,5,GOSUB,gosub 
	_dict_entry,4,GOTO,goto 
	_dict_entry,3,FOR,for 
	_dict_entry,4,NEXT,next 
	_dict_entry,4,STOP,stop 
	_dict_entry,6,RETURN,return 
	_dict_entry,2,ON,on 
	_dict_entry,4,PEEK,peek 
	_dict_entry,4,POKE,poke 
	_dict_entry,4,LOAD,load 
	_dict_entry,4,SAVE,save 
	_dict_entry,3,USR,usr
	_dict_entry,3,NEW,new   
last:
	_dict_entry 3,LET,let 
	
