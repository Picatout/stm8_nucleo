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
	STACK_SIZE=128
	STACK_EMPTY=RAM_SIZE-1  
	FRUN=0 ; flags run code in variable flags
	FTRAP=1 ; inside trap handler  
in.w:  .blkb 1 ; parser position in tib
in:    .blkb 1 ; low byte of in.w
count: .blkb 1 ; length of string in tib 
acc24: .blkb 1 ; 24 accumulator
acc16: .blkb 1
acc8:  .blkb 1
untok: .blkb 1 
base:  .blkb 1 ; nemeric base used to print integer 
farptr: .blkb 3 ; far pointer 
basicptr: .blkb 3 ; BASIC parse pointer 
dstkptr: .blkw 1  ; data stack pointer 
lineno: .blkb 2  ; BASIC line number 
txtbgn: .ds 2 ; BASIC text beginning address 
txtend: .ds 2 ; BASIC text end address 
array_addr: .ds 2 ; address of @ array 
arraysize: .ds 2 ; array size 
flags: .ds 1 ; boolean flags
tab_width: .ds 1 ; print colon width (4)
vars: .ds 2*26 ; BASIC variables A-Z, keep it as but last .
; keep as last variable 
free_ram: ; from here RAM free for BASIC text 

;-----------------------------------
    .area SSEG (ABS)
;-----------------------------------	
    .org RAM_SIZE-STACK_SIZE-TIB_SIZE-PAD_SIZE-DSTACK_SIZE 
dstack: .ds DSTACK_SIZE 
dstack_unf: 
tib: .ds TIB_SIZE             ; transaction input buffer
pad: .ds PAD_SIZE             ; working buffer
stack_full: .ds STACK_SIZE   ; control stack 
stack_unf: ; stack underflow  


;--------------------------------------
    .area HOME 
;--------------------------------------
    int cold_start
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
_dbg 
NonHandledInterrupt:
    .byte 0x71  ; reinitialize MCU


;------------------------------------
; software interrupt handler  
;------------------------------------
TrapHandler:
.if DEBUG 
	bset flags,#FTRAP 
	call print_registers
	call cmd_itf
	bres flags,#FTRAP 
.endif 	
	iret

;------------------------------------
; Triggered by pressing USER UserButton 
; on NUCLEO card.
;------------------------------------
UserButtonHandler:
call print_registers
; wait button release
	ldw x,0xffff
1$: decw x 
	jrne 1$
	btjf USR_BTN_PORT,#USR_BTN_BIT, 1$
	ldw x,#USER_ABORT
	call puts 
	ldw x, #RAM_SIZE-1
	ldw sp, x
	rim 
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
	
;---------------------------------
; send character to UART3 
; input:
;   A 
; output:
;   none 
;--------------------------------	
putc:
	btjf UART3_SR,#UART_SR_TXE,.
	ld UART3_DR,a 
	ret 

;---------------------------------
; wait character from UART3 
; input:
;   none
; output:
;   A 			char  
;--------------------------------	
getc:
	btjf UART3_SR,#UART_SR_RXNE,.
	ld a,UART3_DR 
	ret 

;-----------------------------
; send an ASCIZ string to UART3 
; input: 
;   x 		char * 
; output:
;   none 
;-------------------------------
puts:
    ld a,(x)
	jreq 1$
	call putc 
	incw x 
	jra puts 
1$:	ret 

;-----------------------------
; send a counted string to UART3 
; first is length {0..255}
; input: 
;   X  		char *
; output:
;   none 
;-------------------------------
prt_cstr:
	clrw y 
	ld a,(x)
	incw x 
	ld yl,a 
1$:	tnzw y 
	jreq 9$ 
	ld a,(x)
	call putc 
	incw x 
	decw y
	jra 1$ 
9$:	ret 


;---------------------------
; delete character at left 
; of cursor on terminal 
; input:
;   none 
; output:
;	none 
;---------------------------
bksp:
	ld a,#BSP 
	call putc 
	ld a,#SPACE 
	call putc 
	ld a,#BSP 
	call putc 
	ret 
;---------------------------
; delete n character left of cursor 
; at terminal.
; input: 
;   A   	number of characters to delete.
; output:
;    none 
;--------------------------	
delete:
	push a 
0$:	tnz (1,sp)
	jreq 1$
	call bksp 
	dec (1,sp)
	jra 0$
1$:	pop a 
	ret

;--------------------------
; print n spaces on terminal
; input:
;  A 		number of spaces 
; output:
;	none 
;---------------------------
spaces:
	push a 
	ld a,#SPACE 
1$:	tnz (1,sp)
	jreq 9$
	call putc 
	dec (1,sp)
	jra 1$
9$: pop a 
	ret 


;---------------------------------
;; print actual registers states 
;; as pushed on stack 
;; {Y,X,CC,A}
;---------------------------------
	_argofs 0  
	_arg R_Y 1 
	_arg R_X 3
	_arg R_A 5
	_arg R_CC 6
prt_regs:
	ldw x,#regs_state 
	call puts
; register PC
	ldw y,(1,sp)
	ldw x,#REG_EPC 
	call prt_reg16 
; register CC 
	ld a,(R_CC,sp)
	ldw x,#REG_CC 
	call prt_reg8 
; register A 
	ld a,(R_A,sp)
	ldw x,#REG_A 
	call prt_reg8 
; register X 
	ldw y,(R_X,sp)
	ldw x,#REG_X 
	call prt_reg16 
; register Y 
	ldw y,(R_Y,sp)
	ldw x,#REG_Y 
	call prt_reg16 
; register SP 
	ldw y,sp
	addw y,#6+ARG_OFS  
	ldw x,#REG_SP
	call prt_reg16
	ld a,#CR 
	call putc
	call putc   
	ret 

regs_state: .asciz "\nregisters state\n--------------------\n"


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
; input:
;   X         .asciz  
; output:
;   X         length 
;-------------------------------------
strlen:
	ldw y,x 
	clrw x 
1$:	tnz (y) 
	jreq 9$ 
	incw x
	incw y 
	jra 1$ 
9$: ret 

;---------------------------------------
;  copy src to dest 
; input:
;   X 		dest 
;   Y 		src 
; output: 
;   X 		dest 
;----------------------------------
strcpy:
	pushw x 
1$: ld a,(y)
	jreq 9$ 
	ld (x),a 
	incw x 
	incw y 
	jra 1$ 
9$:	clr (x)
	popw x 
	ret 

;---------------------------------------
; move memory block 
; input:
;   X 		destination 
;   Y 	    source 
;   acc16	size 
; output:
;   none 
;--------------------------------------
	INCR=1 ; increament high byte 
	LB=2 ; increament low byte 
	VSIZE=2
move:
	_vars VSIZE 
	clr (INCR,sp)
	clr (LB,sp)
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
	inc (LB,sp) ; incr=1 
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
	_drop VSIZE
	ret 	

;-------------------------------------
; search text area for a line with 
; same number as lineno  
; input:
;	X 			lineno 
; output:
;   X 			addr of line | 0 
;   Y           lineno|insert address if not found  
;-------------------------------------
	LL=1 ; line length 
	LB=2 ; line length low byte 
	VSIZE=2 
search_lineno:
	_vars VSIZE
	ldw acc16,x 
	clr (LL,sp)
	ldw y,txtbgn
search_ln_loop:
	cpw y,txtend 
	jrpl 8$
	ldw x,y 
	ldw x,(x) ; x=line number 
	cpw x,acc16 
	jreq 9$ 
	jrpl 8$ ; 
	ld a,(2,y)
	ld (LB,sp),a 
	addw y,#3 
	addw y,(LL,sp)
	jra search_ln_loop 
8$: exgw x,y 
	clrw y 	
9$: _drop VSIZE
	exgw x,y   
	ret 

;-------------------------------------
; delete line which is at addr
; input:
;   X 			addr of line 
;-------------------------------------
del_line: 
	ld a,(2,x) ; line length
	ld acc8,a 
	clr acc16 
; keek it to adjust txtend after move 
	push a
	push #0  
	ldw y,x 
	addw y,acc16
	addw y,#3  
	ldw acc16,y 
	ldw y,txtend 
	subw y,acc16 ; y=count 
	ldw acc16,y 
	call move
	popw y 
	ldw acc16,y 
	ldw y,txtend 
	subw y,acc16 
	ldw txtend,y    
	ret 


;---------------------------------------------
; create a gap in text area 
; input:
;    X 			addr 
;    Y 			length 
; output:
;    X 			addr 
;--------------------------------------------
	SRC=1
	DEST=3
	LEN=5 
	VSIZE=6 
create_gap:
	_vars VSIZE
	cpw x,txtend 
	jrpl 9$ 
	ldw (LEN,sp),y  
	ldw acc16,y 
	ldw (SRC,sp),x 
	addw x,(LEN,sp) 
	ldw y,(SRC,sp)
	call move
	ldw x,txtend 
	addw x,(LEN,sp)
	ldw txtend,x
9$:	_drop VSIZE 
	ret 


;--------------------------------------------
; insert line in tib into text area 
; first search for already existing 
; replace existing 
; if strlen(tib)==0 delete existing 
; input:
;   X 				line number 
;   tib[in.w]  		text to insert  
; output:
;   none
;---------------------------------------------
	DEST=1  ; text area insertion address 
	SRC=3   ; str to insert address 
	LINENO=5 ; line number 
	LLEN=7 ; line length 
	VSIZE=8  
insert_line:
	_vars VSIZE 
	ldw (LINENO,sp),x 
	ldw x,#tib 
	addw x,in.w 
	ldw (SRC,sp),x 
	call strlen 
	ldw (LLEN,sp),x
	ldw x,(LINENO,sp)
	call search_lineno 
	tnzw x 
	jrne 2$
; line doesn't exit 	
	ldw (DEST,sp),y 
	jra 3$
; line exit delete it.	
2$: ldw (DEST,sp),x 
	call del_line
; leave or insert new line if LLEN>0
3$: 
; check for available space 
	call size 
	call dpop 
	subw x,#3 
    subw x,(LLEN,sp)
	jrpl 31$
	ld a,#ERR_TXT_FULL
	jp tb_error 
31$:	
	tnz (LLEN+1,sp)
	jreq insert_ln_exit ; empty line forget it.
	ldw x,(DEST,sp)
	cpw x,txtend 
	jrpl 4$ 
; must create a gap 
	ldw y,(LLEN,sp)
	addw y,#3 ; space for lineno and linelen 
	call create_gap 
	jra 5$ 
4$: ; insert at end. 
	ldw y,txtend
	ldw (DEST,sp),y
	addw y,(LLEN,sp)
	addw y,#3 
	ldw txtend,y  
5$:	
	ldw x,(DEST,sp) ; dest address 
	ldw y,(LINENO,sp) ; line number 
	ldw (x),y 
	addw x,#2
	ld a,(LLEN+1,sp)
	ld (x),a 
	incw x 
	ldw (DEST,sp),x ; dest 
	ldw y,(LLEN,sp) ; src addr  
	ldw acc16,y
	ldw y,(SRC,sp)
	call move  
insert_ln_exit:	
	_drop VSIZE
	ret
	
;------------------------------------
;  set all variables to zero 
; input:
;   none 
; output:
;	none
;------------------------------------
clear_vars:
	ldw x,#vars 
	ldw y,#2*26 
1$:	clr (x)
	incw x 
	decw y 
	jrne 1$
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
	clr flags 
    ldw x,#STACK_EMPTY 
    ldw sp,x
    call clock_init 
    call uart3_init
; activate PE_4 (user button interrupt)
    bset PE_CR2,#USR_BTN_BIT 
	ldw x,#software 
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
	rim 
    jp warm_start 

err_msg:
	.word 0,err_text_full, err_syntax, err_math_ovf, err_div0,err_no_line    

err_text_full: .asciz "\nMemory full\n" 
err_syntax: .asciz "\nsyntax error\n" 
err_math_ovf: .asciz "\nmath operation overflow\n"
err_div0: .asciz "\ndivision by 0\n" 
err_no_line: .asciz "\ninvalid line number.\n"

syntax_error:
	ld a,#ERR_SYNTAX 

tb_error:
	push a 
	ldw x, #err_msg 
	clr acc16 
	sll a
	rlc acc16  
	ld acc8, a 
	addw x,acc16 
	ldw x,(x)
	call puts
	btjf flags,#FRUN,0$ 
	ldw x,basicptr 
	ldw acc16,x 
	clr acc24
	clrw x   
	ld a,#5
	ld xl,a 
	ld a,#10 
	call prti24
	ldw x,basicptr   
	addw x,#2 
	call prt_cstr
	ld a,#CR 
	call puts 
	ldw x,in.w 
	call spaces
	ld a,#'^ 
	call putc 
0$:	pop a 
	cp a,#ERR_SYNTAX
	jrne 1$
	ldw x,#tib
	call puts 
	ld a,#CR 
	call putc 
	ld a,in 
	call spaces 
	ld a,#'^' 
	call putc  
1$: ldw x,#STACK_EMPTY 
    ldw sp,x
warm_start:
	ldw x,#dstack_unf 
	ldw dstkptr,x 
	ldw x,#dstack 
	subw x,#CELL_SIZE  
	ldw array_addr,x 
	mov tab_width,#TAB_WIDTH 
	clr untok
	mov base,#10 
	ldw x,#free_ram 
	ldw txtbgn,x 
	ldw txtend,x 
	clrw x 
	ldw lineno,x
	clr count 
	call clear_vars 
;----------------------------
; tokenizer test
;----------------------------
  TOK_TEST=0 
.if TOK_TEST 
test_tok:
	clr in.w 
	clr in 
	ld a,#CR 
	call putc 
	ld a,#'> 
	call putc 
	call readln
	ldw x,#tib 
1$:	call get_token	
	tnz a 
	jrne 2$
	jra test_tok 
2$:	push a 
	cp a,#TK_INTGR
	jrne 3$
	ld a,#10 
	clrw x
	call itoa
	ldw y,x 
	ldw x,#pad 
	call strcpy    
3$:	ld a,(1,sp) 
	cp a,#20
	jrmi 34$
	ld a,#'2 
	call putc 
	ld a,(1,sp)
	sub a,#20
	ld (1,sp),a
	jra 36$   
34$: 
	cp a,#10
	jrmi 36$ 
	ld a,#'1 
	call putc
	ld a,(1,sp)
	sub a,#10 
	ld (1,sp),a  
36$:
	pop a 
	add a,#'0 
	call putc 
	ld a,#SPACE 
	call putc 
	ldw x,#pad 
	call puts 
	ld a,#CR 
	call putc 
	jra 1$
.endif
;----------------------------
interp:
	clr in.w
	clr in
	ld a,#CR 
	call putc 
	ld a,#'> 
	call putc 
	call readln
interp_loop:
	call get_token
	cp a,#TK_KWORD
	jreq 4$ 
	cp a,#TK_NONE
	jreq interp ; empty line 
	cp a,#TK_INTGR
	jrne 2$ 
; check if this line number exist  
; if exist replace with new line 
; or if new line empty delete existing 
; else insert new line
	call dpop 
	ld a,xh 
	jrpl 1$   
	jp syntax_error
1$:
	call insert_line 
	jra interp 

2$:	ld a,#'D  
	cp a,pad 
	jrne 3$ 
	_dbg_trap 
3$:	jra interp 

4$:	
	call dpop 
	call (x)
	cp a,#TK_NONE 
	jreq interp_loop 
	push a  
	ld a,lineno 
	or a,lineno+1 
	pop a 
	jrne interp_loop  
	cp a,#TK_INTGR
	jrne interp_loop 
	call prt_tos  
	jra interp_loop 	
    _dbg_trap 
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
;   X  point to register name 
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
;   X   point register name 
;   Y   register value to print 
; output:
;  none
;--------------------------------
prt_reg16: 
	pushw y 
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
	btjf acc16,#7,1$
	cpl acc24 
1$:	clrw x 
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
	ldw x,#STATES
	call puts
; print EPC 
	ldw x, #REG_EPC
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
	ldw x,#REG_X
	ldw y,(5,sp)
	call prt_reg16  
; print Y 
	ldw x,#REG_Y
	ldw y, (7,sp)
	call prt_reg16  
; print A 
	ldw x,#REG_A
	ld a, (4,sp) 
	call prt_reg8
; print CC 
	ldw x,#REG_CC 
	ld a, (3,sp) 
	call prt_reg8 
; print SP 
	ldw x,#REG_SP
	ldw y,sp 
	addw y,#12
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
	ADD_SPACE=3 ; add a space after number 
	VSIZE = 3
prti24:
	_vars VSIZE 
	clr (ADD_SPACE,sp)
	bcp a,#0x80 
	jreq 0$ 
	cpl (ADD_SPACE,sp)
0$:	and a,#31 
	ld (BASE,sp),a
	ld a,xl
	ld (WIDTH,sp),a 
	ld a, (BASE,sp)  
    call itoa  ; conversion entier en  .asciz
1$: ld a,(WIDTH,sp)
	jreq 4$
	ld acc8,a 
	pushw x 
	call strlen 
	ld a,xl 
	popw x 
	exg a,acc8 
	sub a,acc8 
	jrmi 4$
	ld (WIDTH,sp),a 
	ld  a,#SPACE
3$: tnz (WIDTH,sp)
	jreq 4$
	decw x 
	ld (x),a 
	dec (WIDTH,sp) 
	jra 3$
4$: 
	call puts 
	tnz (ADD_SPACE,sp)
	jreq 5$
    ld a,#SPACE 
	call putc 
5$: _drop VSIZE 
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
;   X  		pointer to string
;------------------------------------
	SIGN=1  ; integer sign 
	BASE=2  ; numeric base 
	VSIZE=2  ;locals size
itoa:
	sub sp,#VSIZE
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
	ldw x,#pad+PAD_SIZE-1
	clr (x)
itoa_loop:
    ld a,(BASE,sp)
    call divu24_8 ; acc24/A 
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: decw x
    ld (x),a
	; if acc24==0 conversion done
	ld a,acc24
	or a,acc16
	or a,acc8
    jrne itoa_loop
	;conversion done, next add '$' or '-' as required
	ld a,(BASE,sp)
	cp a,#16
	jreq 8$
	ld a,(SIGN,sp)
    jreq 10$
    ld a,#'-
	jra 9$ 
8$: ld a,#'$ 
9$: decw x
    ld (x),a
10$:
	addw sp,#VSIZE
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
	VSIZE =1
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
	LL_HB=1
	RXCHAR = 1 ; last char received
	LL = 2  ; accepted line length
	VSIZE=2 
readln:
	clrw x 
	pushw x 
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
	tnz count 
	jreq readln_loop
	tnz (LL,sp)
	jrne readln_loop
	ldw x,#tib 
	call puts
	ldw y,#tib 
	ld a,count 
	ld (LL,sp),a
	clr count 
	clr (LL_HB,sp)
	addw y,(LL_HB,sp)
	jra readln_loop 
del_ln:
	ld a,(LL,sp)
	call delete
	ldw y,#tib
	clr (y)
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
	clr (y)
	ld a,(LL,sp)
	ld count,a 
	_drop VSIZE 
	ld a,#CR
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
	VSIZE=1 
cmd_itf:
	sub sp,#VSIZE 
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
	call get_token
	ldw y,#pad 
	ld a,(y)
	incw y
	cp a,#'Q 
	jrne test_p
repl_exit:
	_drop #VSIZE 	
	ret  
invalid:
	ldw x,#invalid_cmd 
	call puts 
	jra repl 
test_p:	
    cp a,#'P 
	jreq mem_peek
    cp a,#'S 
	jrne invalid 
print_string:	
	call get_token
	ldw x,acc16 
	call puts
	jp repl 	
mem_peek:	 
	call get_token
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
	call get_token
	call atoi
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
;   X   pointer to pab 
; output:
;	pad   parsed string 
;------------------------------------
	PREV = 1
	CURR =2 
	VSIZE=2 
parse_quote:
	_vars VSIZE 
	clr a
1$:	ld (PREV,sp),a 
2$:	inc in
	ld a,([in.w],y)
	jreq 6$
	ld (CURR,sp),a 
	ld a,#'\
	cp a, (PREV,sp)
	jrne 3$
	clr (PREV,sp)
	ld a,(CURR,sp)
	callr convert_escape
	ld (x),a 
	incw x 
	jra 2$
3$:
	ld a,(CURR,sp)
	cp a,#'\'
	jreq 1$
	cp a,#'"
	jreq 5$ 
	ld (x),a 
	incw x 
	jra 2$
5$:	inc in 
6$: clr (x)
	_drop VSIZE
	ld a,#TK_QSTR  
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

;-------------------------
; integer parser 
; input:
;   X 		point to pad 
;   Y 		point to tib 
;   A 	    first digit 
; output:  
;   pad     number string 
;   dstack  actual integer 
;   A 		TK_INTGR
;-------------------------
	BASE=1
	CHAR=2 
	VSIZE=2 
parse_integer:
	push #0 
	cp a,#'$
	jreq 1$ 
	push #10
	jra 2$ 
1$: push #16 
2$:	ld (x),a 
	incw x 
	inc in 
	ld a,([in.w],y)
	call to_upper 
	ld (CHAR,sp),a 
	call is_digit 
	jrc 2$
	ld a,#16 
	cp a,(BASE,sp)
	jrne 3$ 
	ld a,(CHAR,sp)
	cp a,#'A 
	jrc 3$ 
	cp a,#'F 
	jrc 2$ 
3$:	clr (x)
	pushw x
	pushw y 
	call atoi
	ldw x,acc16 
	call dpush
	popw y 
	popw x  
	ld a,#TK_INTGR
	_drop VSIZE  
	ret 	

;---------------------------
;  token begin with a letter,
;  is keyword or variable. 	
; input:
;   X 		point to pad 
;   Y 		point to tib 
;   A 	    first letter  
; output:
;   dstack	exec_addr|var_addr 
;   A 		token attribute 
;   pad 	keyword|var_name  
;--------------------------  

parse_keyword:
	call to_upper 
	ld (x),a 
	incw x 
	inc in 
	ld a,([in.w],y)
	call is_alpha 
	jrc parse_keyword 
1$: clr (x)
	ldw x,#pad
	call strlen 
	cpw x,#1 
	jrne 2$
; one letter variable name 
	ld a,pad 
	sub a,#'A 
	sll a 
	push a 
	push #0
	ldw x,#vars 
	addw x,(1,sp) ; X=var address 
	_drop 2 
	ld a,#TK_VAR 
	jra 4$ 
2$: ; check for keyword, otherwise syntax error.
	_ldx_dict kword_dict
	call search_dict
	ld a,#TK_KWORD
	tnzw x
	jrne 4$ 
	ld a,#ERR_SYNTAX
	jp tb_error 
4$: 
	call dpush ; push execution address on dstack
	ret 


;---------------------------
;  token begin with one of {'=','<','>'}
;  is relation operator. 	
; input:
;   X 		point to pad 
;   Y 		point to tib 
;   A 	    first character  
; output:
;	A 		token attribute 
;   pad 	relation operator string  
;--------------------------  
parse_relop:
	ld (x),a 
	incw x 
	inc in 
	ld a,([in.w],y)
	cp a,#'=
	jreq 4$
	cp a,#'>
	jreq 4$
	cp a,#'< 
	jrne 6$ 
4$: ld (x),a
	incw x 
	inc in 
6$:	clr(x)
	pushw x
	pushw y  
	_ldx_dict relop_dict	
	call search_dict
	ld a,xl
	popw y  
	popw x 
	ret 

;------------------------------------
; Command line tokenizer
; scan tib for next token
; move token in 'pad'
; input: 
	none: 
; use:
;	Y   pointer to tib 
;   X	pointer to pad 
;   in.w   index in tib
; output:
;   A       token attribute 
;   pad 	token as .asciz  
;------------------------------------
	; use to check special character 
	.macro _case c t  
	ld a,#c 
	cp a,(CHAR,sp) 
	jrne t
	.endm 

	CHAR=1
	ATTRIB=2 
	VSIZE=2
get_token:
	tnz untok 
	jreq 1$
	ld a,untok
	clr untok  
	ret 
1$:	
	ld a,in 
	cp a,count 
	jrmi 11$
	ld a,#TK_NONE 
	ret 
11$:	
	_vars VSIZE
	ldw x, #pad
	ldw y, #tib  	
	ld a,#SPACE
	call skip
	ld a,([in.w],y)
	jrne str_tst
	jp token_exit

str_tst: ; check for quoted string  	
	call to_upper 
	ld (CHAR,sp),a 
	_case '"' nbr_tst
	call parse_quote 
	jp token_exit
nbr_tst: ; check for number 
	ld a,#'$'
	cp a,(CHAR,sp) 
	jreq 1$
	ld a,(CHAR,sp)
	call is_digit
	jrnc 3$
1$:	call parse_integer 
	jp token_exit 
3$: 
	ld (CHAR,sp),a 
	_case '(' rparnt_tst 
	ld a,#TK_LPAREN
	jp token_exit2  	
rparnt_tst:		
	_case ')' colon_tst 
	ld a,#TK_RPAREN 
	jp token_exit2 
colon_tst:
	_case ':' comma_tst 
	ld a,#TK_COLON 
	jp token_exit2
comma_tst:
	_case COMMA sharp_tst 
	ld a,#TK_COMMA 
	jp token_exit2 
sharp_tst:
	_case SHARP dash_tst 
	ld a,#TK_SHARP
	jp token_exit2  	 	 
dash_tst: 	
	_case '-' at_tst 
	ld a,#TK_MINUS  
	jp token_exit2
at_tst:
	_case '@' plus_tst 
	ld a,#TK_ARRAY 
	jp token_exit2  	
plus_tst:
	_case '+' star_tst 
	ld a,#TK_PLUS  
	jp token_exit2 
star_tst:
	_case '*' slash_tst 
	ld a,#TK_MULT 
	jp token_exit2 
slash_tst: 
	_case '/' prcnt_tst 
	ld a,#TK_DIV 
	jra token_exit2 
prcnt_tst:
	_case '%' eql_tst 
	ld a,#TK_MOD
	jra token_exit2 
; 1 or 2 character tokens 	
eql_tst:
	_case '=' gt_tst 		
	jra rel_op 
gt_tst:
	_case '>' lt_tst 
	jra rel_op 	 
lt_tst:
	_case '<' other
rel_op:
	call parse_relop
	jra token_exit3 
other: ; not a special character 	 
	ld a,(CHAR,sp)
	call is_alpha 
	jrc 30$ 
	ld a,#ERR_SYNTAX 
	jp tb_error 
30$: 
	call parse_keyword
	jra token_exit3 
token_exit2:
	ld (ATTRIB,sp),a 
	ld a,(CHAR,sp)
	ld (x),a 
	incw x 
	inc in 
	ld a,(ATTRIB,sp)
token_exit:
	clr (x)
token_exit3:
	_drop VSIZE 
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
	VSIZE=3 ; 3 bytes reserved for local storage
atoi:
	pushw x ;save x
	sub sp,#VSIZE
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
	addw sp,#VSIZE
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
	VSIZE = 3
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
    addw sp,#VSIZE
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
2$: _drop 1 
	ret
	
;----------------------	
; push X on data stack 
; input:
;	X 
; output:
;	none 
;----------------------	
dpush:
    _dp_down 1
    ldw [dstkptr],x 
	ret 


;----------------------	
; pop data stack in X 
; input:
;	none
; output:
;	X   
;----------------------	
dpop: 
    ldw x, [dstkptr]
	_dp_up 1 
	ret 

;--------------------------
; duplicate TOS 
;  dstack: { ix...n -- ix...n n }
ddup:
	ldw x,[dstkptr]
	call dpush 
	ret 


;----------------------------------
; pick value n from dstack 
; put it on TOS
; dstack: {ix,..,p -- ix,...,np }
;-----------------------------------
dpick:
	ldw x,[dstkptr]
	sllw x 
	addw x,dstkptr 
	ldw x,(x)
	ldw [dstkptr],x 
	ret

;---------------------------
;  fetch variable in X 
;  dstack:{ addr -- value }
;---------------------------
fetch:
	ldw x,[dstkptr]
	ldw x,(x)
	ldw [dstkptr],x
	ret 

;----------------------------
; print TOS 
; dstack: {n -- }
;----------------------------
prt_tos:
	call dpop 
	ldw acc16,x
	clr acc24 
	btjf acc16,#7,1$
	cpl acc24 
1$:	ld a,tab_width 
	clrw x 
	ld xl,a 
	ld a,base 
	call prti24
	ret 

.if DEBUG 
ds_msg: .asciz "\ndstack: " 
;----------------------------
; print dstack content 
;---------------------------
	XSAVE=1
	VSIZE=2
dots:
	_vars VSIZE 
	ldw x,#ds_msg 
	call puts
	ldw x,#dstack_unf 
	cpw x,dstkptr
	jreq 4$  
1$:	subw x,#CELL_SIZE  
	ldw (XSAVE,sp),x
	ldw  x,(x)
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#10+128
	call prti24 
	ldw x,(XSAVE,sp)
	cpw x,dstkptr 
	jreq 4$ 
	jra 1$  
4$: ld a,#CR 
	call putc 
	_drop VSIZE
	ret
.endif 

;----------------------------
; store variable 
; dstack: {addr value -- }
;----------------------------
store:
	call dpop 
	ldw y,x   ; y=value 
	call dpop 
	ldw (x),y 
	ret 

;--------------------------------
;  add 2 top integer on dstack 
;  dstack: {n2 n1-- n2+n1}
;--------------------------------
add:
	call dpop
	ldw acc16,x  
	ldw x,[dstkptr]
	addw x,acc16
	ldw [dstkptr],x  
	ret 

;--------------------------------
;  substract 2 top integer on dstack 
;  dstack: {n2 n1 -- n2-n1}
;--------------------------------
substract:
	call dpop 
	ldw acc16,x  
	ldw x,[dstkptr]
	subw x,acc16  
	push cc 
	ldw [dstkptr],x 
	pop cc 
	ret 

;-------------------------------------
; multiply 2 top integers on dstack
; dstack: {n2 n1 -- n2*n1}
; product overflow is ignored unless
; MATH_OVF assembler flag is set to 1
;-------------------------------------
   ; local variables 
	SIGN=1
	PROD=2
	N1_HB=4
	N1_LB=5
	N2_HB=6
	N2_LB=7 
	VSIZE=7
multiply:
	_vars VSIZE 
	clr (SIGN,sp)
	call dpop 
	ldw (N1_HB,sp),x
	ld a,xh 
	bcp a,#0x80 
	jreq 2$
	cpl (SIGN,sp)
	negw x 
	ldw (N1_HB,sp),x 
2$: ldw x,[dstkptr]
	ldw (N2_HB,sp),x 
	ld a,xh  
	bcp a,#0x80 
	jreq 3$
	cpl (SIGN,sp)
	negw x 
	ldw (N2_HB,sp),x 
; N1_LB * N2_LB 	
3$:	ld a,(N1_LB,sp)
	ld xl,a 
	ld a,(N2_LB,sp) 
	mul x,a 
.if MATH_OVF 	
	ld a,xh 
	bcp a,#0x80 
	jreq 4$ 
	ld a,#ERR_MATH_OVF 
	jp tb_error
.endif 	 
4$:	ldw (PROD,sp),x
; N1_LB * N2_HB	 
	ld a,(N1_LB,sp) 
	ld xl,a 
	ld a,(N2_HB,sp)
	mul x,a
	ld a,xl 
	add a,(PROD,sp)
.if MATH_OVF 	
	bcp a,#0x80 
	jreq 5$ 
	ld a,#ERR_MATH_OVF 
	jp tb_error
.endif 	 
5$:	ld (PROD,sp),a 
; N1_HB * N2_LB 
	ld a,(N1_HB,sp)
	ld xl,a 
	ld a,(N2_LB,sp)
	mul x,a 
	ld a,xl 
	add a,(PROD,sp)
.if MATH_OVF 	
	bcp a,#0x80 
	jreq 6$ 
	ld a,#ERR_MATH_OVF 
	jp tb_error
.endif 	 
6$:	ld (PROD,sp),a 
; N1_HB * N2_HB 	
; it is pointless to multiply N1_HB*N2_HB 
; as this product is over 65535 or 0 
;
; sign adjust product
	tnz (SIGN,sp)
	jreq 7$
	ldw x, (PROD,sp)
	negw x
	ldw (PROD,sp),x  
7$: 
	ldw x,(PROD,sp) 
	ldw [dstkptr],x 	
	_drop VSIZE 
	ret

;----------------------------------
;  euclidian divide n2/n1 
; dstack: {n2 n1 -- n2/n1 }
; leave remainder in acc16
;----------------------------------
	; local variables
	SQUOT=1 ; sign quotient
	SDIVD=2 ; sign dividend  
	DIVISR=3 ; divisor 
	VSIZE=4
divide:
	_vars VSIZE 
	clr (SQUOT,sp)
	clr (SDIVD,sp)
; check for 0 divisor
	call dpop 
	tnzw x 
    jrne 0$
	ld a,#ERR_DIV0 
	jp tb_error 
; check divisor sign 	
0$:	ld a,xh 
	bcp a,#0x80 
	jreq 1$
	cpl (SQUOT,sp)
	negw x 
1$:	ldw (DIVISR,sp),x
; check dividend sign 	 
    ldw x,[dstkptr]
	ld a,xh 
	bcp a,#0x80 
	jreq 2$ 
	cpl (SQUOT,sp)
	cpl (SDIVD,sp)
	negw x 
2$:	ldw y,(DIVISR,sp)
	divw x,y
	ldw acc16,y 
; if sign dividend is negative and remainder!=0 inc divisor 	 
	tnz (SDIVD,sp)
	jreq 7$
	tnzw y 
	jreq 7$
	incw x
	ldw y,(DIVISR,sp)
	subw y,acc16
	ldw acc16,y  
7$: tnz (SQUOT,sp)
	jreq 9$ 	 
8$:	negw x 
9$: ldw [dstkptr],x
	_drop VSIZE 
	ret 


;----------------------------------
;  remainder resulting from euclidian 
;  division of n2/n1 
; dstack: {n2 n1 -- n2%n1 }
;----------------------------------
modulo:
	call divide 
	ldw x,acc16 
	ldw [dstkptr],x 
	ret 

;---------------------------------
; drop n elements from data stack 
; input: 
;   X 		n 
; output:
;   none 
;-------------------------------------
ddrop_n: 
	pushw y 
	ldw y,dstkptr 
	sllw x 
	pushw x 
	addw y,(1,sp)
	ldw dstkptr,y 
	popw x 
	popw y 
	ret 


;---------------------------------
; input:
;	X 		dictionary entry point 
;  pad		.asciz name to search 
; output:
;  X		execution address | 0 
;---------------------------------
	NLEN=1 ; cmd length 
	YSAVE=2
	VSIZE=3 
search_dict:
	_vars VSIZE 
	ldw y,x 
search_prep:	
	ld a,(y)
	ld (NLEN,sp),a  
search_loop:
	ldw x,#pad 
	ldw (YSAVE,sp),y
	incw y  
cp_loop:
	ld a,(x)
	jreq str_match 
	tnz (NLEN,sp)
	jreq no_match  
	cp a,(y)
	jrne no_match 
	incw y 
	incw x
	dec (NLEN,sp)
	jra cp_loop 
no_match:
	ldw y,(YSAVE,sp) 
	subw y,#2 
	ldw y,(y) ; next word link 
	jreq search_exit  ; not found  
;try next 
	jra search_prep 
str_match:
	ldw y,(YSAVE,sp)
	ld a,(y)
	inc a 
	ld acc8,a 
	clr acc16 
	addw y,acc16 
	ldw y,(y)
search_exit: 
	ldw x,y 
	_drop VSIZE 	 
	ret 

;---------------------
; check if next token
;  is of expected type 
; input:
;   A 		 expected token attribute
;  ouput:
;   none     if fail call tb_error 
;--------------------
expect:
	push a 
	call get_token 
	cp a,(1,sp)
	jreq 1$
	jp syntax_error
1$: pop a 
	ret 


;-------------------------------
; parse embedded BASIC routines 
; arguments list.
; arg_list::= '(' rel[','rel]*')'
; all arguments are of integer type
; missing argument replace by 0.
; input:
;   A 			number of expected arguments  
; output:
;   A 			should be >=0 
;	arguments pushed on dstack 
;--------------------------------
	ARG_CNT=1 
arg_list:
	push a 
	ld a,#TK_LPAREN 
	call expect 
1$: call relation 
	cp a,#TK_INTGR
	jreq 4$
	call get_token 
	cp a,#TK_RPAREN 
	jreq 9$ ; list end 
2$:	cp a,#TK_COMMA  
	jreq 3$
	jp syntax_error
3$:
; missing args replaced by 0.
	clrw x 
	call dpush
4$: dec (ARG_CNT,sp)
	call get_token 
	cp a,#TK_COMMA 
	jreq 1$ 
	_unget_tok 
	jra 1$ 
9$: pop a 
	bcp a,#0x80 
	jreq 10$
	jp syntax_error ; more arguments than expected 
10$:
	ret 



;--------------------------------
;   BASIC commnands 
;--------------------------------

;--------------------------------
;  arithmetic and relational 
;  routines
;  operators precedence
;  highest to lowest
;  operators on same row have 
;  same precedence and are executed
;  from left to right.
;	'*','/','%'
;   '-','+'
;   '=','>','<','>=','<=','<>','><'
;   '<>' and '><' are equivalent for not equal.
;--------------------------------

;------------------------------
; negate value on dstack
; dstack: {n -- -n}
;------------------------------
negate:	
	ldw x,[dstkptr]
	negw x 
	ldw [dstkptr],x 
	ret 


;-----------------------------------
; factor ::= ['+'|'-'|e] var | integer | function | '('relation')' 
; output:
;   integer pushed on dstack 
; ---------------------------------
	NEG=1
	VSIZE=1
factor:
	_vars VSIZE 
	call get_token
	ld (NEG,sp),a 
	and a,#TK_GRP_MASK 
	cp a,#TK_GRP_ADD 
	jreq 0$ 
	ld a,(NEG,sp)
	clr (NEG,sp)
	jra 1$
0$:	call get_token 
1$:	cp a,#TK_KWORD 
	jrne 11$ 
	clr a 
	call dpop 
	call (x)
	jra 3$
11$:	
	cp a,#TK_LPAREN
	jrne 2$
	call relation 
	ld a,#TK_RPAREN 
	call expect
	jra 5$	
2$:	cp a,#TK_VAR 
	jrne 3$ 
	call fetch  
	jra 5$  
3$: cp a,#TK_INTGR
    jrne 4$
	jra 5$ 
4$: _unget_tok
	ld a,#TK_MINUS 
	cp a,(NEG,sp)
	jrne 42$
	ld a,#ERR_SYNTAX
	jp tb_error 
42$:	
	ld a,#TK_NONE 
	jra 7$
5$:
	ld a,#TK_MINUS 
	cp a,(NEG,sp)
	jrne 6$
	call negate
6$:	ld a,#TK_INTGR
7$:	_drop VSIZE
	ret

;-----------------------------------
; term ::= factor [['*'|'/'|'%'] factor]* 
; output:
;	integer pushed on dstack 
;-----------------------------------
	MULOP=1
	VSIZE=1
term:
	_vars VSIZE
	call factor
	cp a,#TK_NONE 
	jreq term_exit
term01:	 ; get operator 
	call get_token
	ld (MULOP,sp),a
	and a,#TK_GRP_MASK
	cp a,#TK_GRP_MULT
	jreq 1$
	ld a,(MULOP,sp) 
	_unget_tok 
	ld a,#TK_INTGR
	jra term_exit
1$:	call factor
	cp a,#TK_INTGR
	jreq 2$ 
	ld a,#ERR_SYNTAX
	jp tb_error 
2$:	ld a,(MULOP,sp) 
	cp a,#TK_MULT 
	jrne 3$
	call multiply 
	jra term01
3$: cp a,#TK_DIV 
	jrne 4$ 
	call divide 
	jra term01 
4$: call modulo
	jra term01 
term_exit:
	_drop VSIZE 
	ret 

;-------------------------------
;  expr ::= term [['+'|'-'] term]*
;  result range {-32768..32767}
;  output:
;     pushed on dstack 
;-------------------------------
	OP=1 
	VSIZE=1 
expression:
	_vars VSIZE 
	call term
	cp a,#TK_NONE 
	jreq expr_exit 
2$:	call get_token 
	ld (OP,sp),a  
	and a,#TK_GRP_MASK
	cp a,#TK_GRP_ADD 
	jreq 3$ 
	ld a,(OP,sp)
	_unget_tok
	ld a,#TK_INTGR  
	jra expr_exit 
3$: call term
	cp a,#TK_INTGR 
	jreq 31$
	ld a,#ERR_SYNTAX
	jp tb_error 
31$:	
	ld a,(OP,sp)
	cp a,#TK_PLUS 
	jrne 4$
	call add 
	jra 2$ 
4$:	call substract
	jra 2$ 
expr_exit:
	_drop VSIZE 
	ret 

;---------------------------------------------
; rel ::= expr rel_op expr
; rel_op ::=  '=','<','>','>=','<=','<>','><'
;  relation return 1 | 0  for true | false 
;  output:
;	 1|0 pushed on dtsack 
;---------------------------------------------
	RELOP=1 
	VSIZE=1 
relation: 
	_vars VSIZE
	call expression
	cp a,#TK_NONE 
	jreq rel_exit 
	; expect rel_op or leave 
	call get_token 
	ld (RELOP,sp),a 
	and a,#TK_GRP_MASK
	cp a,#0x30 
	jreq 2$
	ld a,(RELOP,sp)
	_unget_tok  
	jra 5$
2$:	; expect another expression ')' or error 
	call expression
	cp a,#TK_INTGR 
	jreq 3$ 
	ld a,#ERR_SYNTAX
	jp tb_error 
3$:	
	call substract
	ccf 
	push cc 
	pop a
	and a,#7  
	and a,(RELOP,sp)
	tnz a 
	jreq 4$
	ld a,#1 
4$:	clrw x
	ld xl,a 
	ldw [dstkptr],x 	
5$:
	ld a,#TK_INTGR
rel_exit: 	 
	_drop VSIZE
	ret 


;--------------------------------------------
;  return text area free space 
; input: 
;   none 
; output:
;   acc24 		free space in byte 
;---------------------------------------------

hex_base:
	mov base,#16 
	ret 

dec_base:
	mov base,#10
	ret 

size:
	ldw x,#tib 
	subw x,txtend 
	call dpush 
	ld a,#TK_INTGR
	ret 

let:
	call get_token 
	cp a,#TK_VAR 
	jrne let_bad_syntax 
	call get_token 
	cp a,#TK_EQUAL
	jrne let_bad_syntax 
	call relation   
	call store  
	ld a,#TK_NONE 
	ret 
let_bad_syntax:
	ld a,#ERR_SYNTAX
	jp tb_error 

;----------------------------
; BASIC: LIST([[start][,end]])
; list program lines 
; form start to end 
; if empty argument list then 
; list all.
;----------------------------
	FIRST=1
	LAST=3 
	LN_PTR=5
	VSIZE=6 
list:
	_vars VSIZE
	clrw x 
	ldw (FIRST,sp),x ; list from start 
	ldw x,0x7fff ; biggest line number 
	ldw (LAST,sp),x 
	call get_token 
	cp a,#TK_NONE 
	jreq lines_skip
	cp a,#TK_INTGR
	jreq first_line 
minus_test:
    cp a,#TK_MINUS
	jreq get_last 
	jp syntax_error
first_line:
	call dpop 
	ldw (FIRST,sp),x 
	call get_token
	cp a,#TK_NONE 
	jreq lines_skip  
	jra minus_test 
get_last:	
	call get_token
	cp a,#TK_NONE 
	jreq lines_skip 
	cp a,#TK_INTGR
	jreq last_line 
	jp syntax_error  
last_line:
	call dpop 
	ldw (LAST,sp),x 
lines_skip:
	ldw x,txtbgn
2$:	ldw (LN_PTR,sp),x 
	cpw x,txtend 
	jrpl list_exit 
	ldw x,(x) ;lineno 
	cpw x,(FIRST,sp)
	jrpl list_start 
	ldw x,(LN_PTR,sp) 
	addw x,#2 
	ld a,(x)
	incw x 
	ld acc8,a 
	clr acc16 
	addw x,acc16
	jra 2$ 
; print loop
list_start:
	ldw x,(LN_PTR,sp)
3$:	
	call prt_basic_line
	ldw x,(LN_PTR,sp)
	addw x,#2 
	ld a,(x)
	incw x 
	ld acc8,a 
	clr acc16 
	addw x,acc16
	cpw x,txtend 
	jrpl list_exit
	ldw (LN_PTR,sp),x
	ldw x,(x)
	cpw x,(LAST,sp)  
	jrpl list_exit 
	ldw x,(LN_PTR,sp)
	jra 3$
list_exit:
	_drop VSIZE 
	clr a 	
	ret

empty: .asciz "Nothing to list\n"

;--------------------------
; input:
;   X 		pointer at line
; output:
;   none 
;--------------------------	
prt_basic_line:
	pushw x 
	ldw x,(x)
	ldw acc16,x 
	clr acc24 
	ldw x,#5 
	ld a,#10 
	call prti24 
	popw x 
	addw x,#2
	call prt_cstr
	ld a,#CR 
	call putc 
	ret 	

	COMMA=1
	VSIZE=1
print:
	push #0 
prt_loop: 	
	call relation 
	cp a,#TK_INTGR 
	jrne 1$ 
	call prt_tos 
	jra prt_loop 
1$: 
	call get_token	
	cp a,#TK_QSTR
	jrne 2$   
	ldw x,#pad 
	call puts 
	jra prt_loop 
2$: cp a,#TK_KWORD 
	jrne 3$ 
	call (x)
	cp a,#TK_INTGR
	jreq 21$
20$:	
	ld a,#ERR_SYNTAX
	jp tb_error 
21$:
	call prt_tos 
	jra prt_loop   
3$: cp a,#TK_COMMA 
	jrne 4$
	ld a,#1 
	ld (COMMA,sp),a 
	jra prt_loop   
4$: cp a,#TK_SHARP
	jrne 6$  
	call get_token
	cp a,#TK_INTGR 
	jreq 5$ 
	jra 20$
5$: 
	call dpop
	ld a,xl 
	and a,#15 
	ld tab_width,a 
	jp prt_loop 
6$: 
	cp a,#TK_NONE 
	jreq print_exit 
7$: cp a,#TK_COLON 
	jreq print_exit 
	jra 20$
print_exit:
	tnz (COMMA,sp)
	jreq 9$
	ld a,#CR 
    call putc 
9$:	_drop VSIZE 
	ld a,#TK_NONE 
	ret 

; run BASIC program 
run: 
	ldw x,#RUN
	call prt_cstr 
	ret 

; BASIC remark 
rem: 
	mov in,count 
	clr untok 
	ret 

input:
	ldw x,#INPUT 
	call prt_cstr 
	ret 

out:
	ldw x,#OUT 
	call prt_cstr 
	ret 

wait: 
	ldw x,#WAIT 
	call prt_cstr 
	ret 

;--------------------
; BASIC: POKE(addr,byte)
; put a byte at addr 
;--------------------
poke:
	ld a,#2 ; expect 2 arguments
	call arg_list 
	call dpop 
    ld a,xl 
	call dpop 
	ld (x),a 
	clr a 
	ret 

;-----------------------
; BASIC: PEEK(addr)
; get the byte at addr 
;-----------------------
peek:
	ld a,#1 ; expect 1 arguments 
	call arg_list
	call dpop 
	ld a,(x)
	clrw x 
	ld xl,a 
	call dpush 
	ld a,#TK_INTGR
	ret 

if:
	ldw x,#IF 
	call prt_cstr 
	ret 

for:
	ldw x,#FOR 
	call prt_cstr 
	ret 

next: 
	ldw x,#NEXT 
	call prt_cstr 
	ret 

;------------------------
; BASIC: GOTO lineno 
; jump to lineno 
;------------------------
goto:
	btjt flags,#FRUN,0$ 
	ret 
0$:	_drop 2 ; don't use return address 
	jra go_common

;--------------------
; BASIC: GOSUB lineno
; basic subroutine call
; actual lineno and basicptr 
; are saved on cstack
;--------------------
gosub:
	btjt flags,#FRUN,0$ 
	ret 
0$:	ldw x,lineno 
	ldw (1,sp),x ; overwrite return addr, will not be used  
	ldw x,basicptr 
	pushw x 
go_common: 
	call relation 
	cp a,#TK_INTGR
	jreq 1$ 
	jp syntax_error
1$: ldw x,[dstkptr] 
	call search_lineno  
	tnzw x 
	jrne 2$ 
	ld a,#ERR_NO_LINE 
	jp tb_error 
2$: addw x,#3 
	ldw basicptr,x 
	call dpop 
	ldw lineno,x 
	jp interp

;------------------------
; BASIC: RETURN 
; exit from a subroutine 
;------------------------
	_argofs 0 
	_arg BASICPTR 1 
	_arg LINENO 3 
return:
	btjt flags,#FRUN,0$
	clr a 
	ret 
0$:	ldw x,(BASICPTR,sp)
	ldw basicptr,x
	ldw x,(LINENO,sp)
	ldw lineno,x 
	ldw x,(1,sp)
	_drop 6 
	jp (x) 

;----------------------
; BASIC: STOP 
; stop running program
;---------------------- 
stop: 
	btjt flags,#FRUN,0$ 
	clr a 
	ret 
; clean dstack and cstack 
0$: bres flags,#FRUN 
	ldw x,RAM_SIZE-1 
	ldw sp,x 
	jp warm_start

;-----------------------
; BASIC: NEW
; from command line only 
; free program memory
; and clear variables 
;------------------------
new: 
	btjf flags,#FRUN,0$
	clr a 
	ret 
0$:	
	call clear_vars 
	_drop 2 
	jp warm_start
	 

save:
	btjf flags,#FRUN,0$
	clr a 
	ret 
0$:	
	ldw x,#SAVE 
	call prt_cstr 
	ret 

load:
	btjf flags,#FRUN,0$
	clr a 
	ret 
0$:	
	ldw x,#LOAD 
	call prt_cstr 
	ret 

usr:
	ldw x,#USR 
	call prt_cstr 
	ret 

on: 
	ldw x,#ON 
	call prt_cstr 
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
	.ascii "name"
	.word cmd 
	.endm 

	LINK=0
kwor_end:

	_dict_entry,3,HEX,hex_base
	_dict_entry,3,DEC,dec_base
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
	_dict_entry,4,SIZE,size    
kword_dict:
	_dict_entry 3,LET,let 
	
	LINK=0 	
rel_end:
	.word LINK 
	LINK=.
	.byte 2
	.ascii "><"
	.word TK_NE 

	.word LINK 
	LINK=.
	.byte 2
	.ascii "<>"
	.word TK_NE 

	.word LINK 
	LINK=.
	.byte 2
	.ascii ">="
	.word TK_GE 

	.word LINK 
	LINK=.
	.byte 2
	.ascii "<="
	.word TK_LE 

	.word LINK 
	LINK=.
	.byte 1
	.ascii ">"
	.word TK_GT 

	.word LINK 
	LINK=.
	.byte 1
	.ascii "<"
	.word TK_LT 
 
relop_dict:
	.word LINK 
	LINK=.
	.byte 1
	.ascii "="
	.word TK_EQUAL

