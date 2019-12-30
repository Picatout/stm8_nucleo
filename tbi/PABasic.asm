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

    .module TBI_STM8

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
	FFOR=2 ; FOR loop in preparation 
	
in.w:  .blkb 1 ; parser position in text line
in:    .blkb 1 ; low byte of in.w
count: .blkb 1 ; length of string in text line  
basicptr:  .blkb 2  ; point to text buffer 
lineno: .blkb 2  ; BASIC line number 
base:  .blkb 1 ; nemeric base used to print integer 
acc24: .blkb 1 ; 24 accumulator
acc16: .blkb 1
acc8:  .blkb 1
seedx: .blkw 1  ; xorshift 16 seed x 
seedy: .blkw 1  ; xorshift 16 seed y 
untok: .blkb 1  ; last ungotten token attribute 
tokval: .blkw 1 ; last parsed token value  
farptr: .blkb 3 ; far pointer 
dstkptr: .blkw 1  ; data stack pointer 
txtbgn: .ds 2 ; BASIC text beginning address 
txtend: .ds 2 ; BASIC text end address 
loop_depth: .ds 1 ; FOR loop depth 
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
	int Timer4UpdateHandler	;int23 TIM4 update/overflow
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used
	int NonHandledInterrupt ;int29  not used

;---------------------------------------
    .area CODE
;---------------------------------------
_dbg 
.if DEBUG
.asciz "TBI_STM8" ; I like to put module name here.
.endif 

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

Timer4UpdateHandler:
	clr TIM4_SR 
	ldw x,(3,sp)
	decw x
	ldw (3,sp),x 
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
	jp cmd_itf 
	jp warm_start

;----------------------------------------
; inialize MCU clock 
; input:
;   A 		source  HSI | 1 HSE 
;   XL      CLK_CKDIVR , clock divisor 
; output:
;   none 
;----------------------------------------
clock_init:	
	cp a,CLK_CMSR 
	jreq 2$ ; no switching required 
; select clock source 
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
2$: 	
; HSI and cpu clock divisor 
	ld a,xl 
	ld CLK_CKDIVR,a  
	ret

;---------------------------------------------
;   UART3 subroutines
;---------------------------------------------

;---------------------------------------------
; initialize UART3, 115200 8N1
; input:
;	none
; output:
;   none
;---------------------------------------------
uart3_init:
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
uart3_set_baud: 
; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
; 1) check clock source, HSI at 16Mhz or HSE at 8Mhz  
	ld a,#CLK_SWR_HSI
	cp a,CLK_CMSR 
	jreq hsi_clock 
hse_clock: ; 8 Mhz 	
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	jra uart_enable
hsi_clock: ; 16 Mhz 	
	mov UART3_BRR2,#0x0b ; must be loaded first
	mov UART3_BRR1,#0x08
uart_enable:	
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
;  X 		number of spaces 
; output:
;	none 
;---------------------------
spaces:
	ld a,#SPACE 
1$:	tnzw x
	jreq 9$
	call putc 
	decw x
	jra 1$
9$: 
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
	jrpl 8$ ; from here all lines are > lineno 
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
; delete line at addr
; input:
;   X 		addr of line i.e DEST for move 
;-------------------------------------
	LLEN=1
	SRC=3
	VSIZE=4
del_line: 
	_vars VSIZE 
	ld a,(2,x) ; line length
	add a,#3
	ld (LLEN+1,sp),a 
	clr (LLEN,sp)
	ldw y,x  
	addw y,(LLEN,sp) ;SRC  
	ldw (SRC,sp),y  ;save source 
	ldw y,txtend 
	subw y,(SRC,sp) ; y=count 
	ldw acc16,y 
	ldw y,(SRC,sp)    ; source
	call move
	ldw y,txtend 
	subw y,(LLEN,sp)
	ldw txtend,y  
	_drop VSIZE     
	ret 


;---------------------------------------------
; create a gap in text area 
; input:
;    X 			addr 
;    Y 			gap length 
; output:
;    X 			addr 
;--------------------------------------------
	DEST=1
	SRC=3
	LEN=5
	VSIZE=6 
create_gap:
	_vars VSIZE
	cpw x,txtend 
	jrpl 9$ ; no need for a gap since at end of text.
	ldw (SRC,sp),x 
	ldw (LEN,sp),y 
	ldw acc16,y 
	ldw y,x ; SRC
	addw x,acc16  
	ldw (DEST,sp),x 
;compute size to move 	
	ldw x,txtend 
	subw x,(SRC,sp)
	ldw acc16,x
	ldw x,(DEST,sp) 
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
	tnzw x 
	jreq 1$
	incw x 
1$:	ldw (LLEN,sp),x
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
	ldw y,(SRC,sp) ; src addr  
	call strcpy   
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
; clear all ram 
	ldw x,#STACK_EMPTY
	ldw sp,x   
0$: clr (x)
	decw x 
	jrne 0$
; select internal clock no divisor: 16 Mhz 	
	ld a,#CLK_SWR_HSI 
	clrw x  
    call clock_init 
; UART3 at 115200 BAUD
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
	ldw x,#dstack 
	subw x,#CELL_SIZE  
	ldw array_addr,x 
	inc seedy+1 
	inc seedx+1 
clear_basic:
	clrw x 
	ldw lineno,x
	clr count 
	ldw x,#free_ram 
	ldw txtbgn,x 
	ldw txtend,x 
	call clear_vars 
    jp warm_start 

err_msg:
	.word 0,err_text_full, err_syntax, err_math_ovf, err_div0,err_no_line    
	.word err_run_only,err_cmd_only 

err_text_full: .asciz "\nMemory full\n" 
err_syntax: .asciz "\nsyntax error\n" 
err_math_ovf: .asciz "\nmath operation overflow\n"
err_div0: .asciz "\ndivision by 0\n" 
err_no_line: .asciz "\ninvalid line number.\n"
err_run_only: .asciz "\nrun time only usage.\n" 
err_cmd_only: .asciz "\ncommand line only usage.\n"

syntax_error:
	ld a,#ERR_SYNTAX 

tb_error:
	ldw x, #err_msg 
	clr acc16 
	sll a
	rlc acc16  
	ld acc8, a 
	addw x,acc16 
	ldw x,(x)
	call puts
	ldw x,lineno 
	tnzw x 
	jreq 2$
	ldw acc16,x 
	clr acc24 
	ldw x,#5 
	ld a,#10 
	call prti24
2$:	 
	ldw x,basicptr   
	ld a,lineno 
	or a,lineno+1
	jreq 3$
	addw x,#3 
3$:	call puts 
	ld a,#CR 
	call putc 
	clrw x 
	ld a,lineno 
	or a,lineno+1
	jreq 4$
	ldw x,#5 
4$:	addw x,in.w 
	call spaces
	ld a,#'^ 
	call putc 
1$: ldw x,#STACK_EMPTY 
    ldw sp,x
warm_start:
	clr flags 
	clr untok
	clrw x 
	ldw tokval,x 
	clr loop_depth 
	ldw x,#dstack_unf 
	ldw dstkptr,x 
	mov tab_width,#TAB_WIDTH 
	mov base,#10 
	clrw x 
	ldw lineno,x 
	ldw x,#tib 
	ldw basicptr,x 

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
	btjf flags,#FRUN,4$ 
; running program
; goto next basic line 
	ldw x,basicptr
	ld a,(2,x) ; line length 
	ld acc8,a 
	clr acc16 
	addw x,#3 
	addw x,acc16
	cpw x,txtend 
	jrpl warm_start
	ldw basicptr,x ; start of next line  
	ld a,(2,x)
	add a,#2 ; because 'in' start at 3.
	ld count,a 
	ldw x,(x) ; line no 
	ldw lineno,x 
	mov in,#3 ; skip first 3 bytes of line 
	jra interp_loop 
4$: ; commande line mode 	
	clr in
	ld a,#CR 
	call putc 
	ld a,#'> 
	call putc 
	call readln
interp_loop:
	ld a,in 
	cp a,count 
	jrpl interp 
	call get_token
	cp a,#TK_COLON 
	jreq interp_loop  
	cp a,#TK_VAR
	jrne 0$ 
	_unget_tok 
	call let 
	jra interp_loop 
0$:	cp a,#TK_KWORD
	jreq 4$ 
	cp a,#TK_NONE
	jreq interp_loop ; empty line 
	cp a,#TK_INTGR
	jrne 2$ 
;if line begin with number 
;insert it in text area 
	ld a,xh 
	jrpl 1$   
	jp syntax_error
1$:
	call insert_line 
	jp interp 

2$:	ld a,#'D  
	cp a,pad 
	jrne 3$ 
	_dbg_trap 
3$:	jp interp 

4$:	
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
	call dpush 
	call prt_tos  
	jra interp_loop 	
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
;   tokval  char* to pad  
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
	ldw x,#pad 
	ldw tokval,x 
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
;   A 	    first digit|'$' 
; output:  
;   pad     number string 
;   X 		actual integer 
;   A 		TK_INTGR
;   tokval   actual integer 
;-------------------------
	BASE=1
	CHAR=2 
	VSIZE=2 
parse_integer:
	push #0 ; CHAR 
	cp a,#'$
	jreq 1$ 
	push #10 ; BASE=10 
	jra 2$ 
1$: push #16  ; BASE=16
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
	jrmi 3$ 
	cp a,#'G 
	jrmi 2$ 
3$:	clr (x)
	call atoi
	ldw x,acc16 
	ldw tokval,x 
	ld a,#TK_INTGR
	_drop VSIZE  
	ret 	

;-------------------------
; binary integer parser 
; input:
;   X 		point to pad 
;   Y 		point to tib 
;   A 	    '%' 
; output:  
;   pad     number string 
;   X 		actual integer 
;   A 		TK_INTGR
;   tokval   actual integer 
;-------------------------
	BINARY=1
	VSIZE=2
parse_binary:
	push #0
	push #0
1$: ld (x),a 
	incw x 
	inc in 
	ld a,([in.w],y)
	cp a,#'0 
	jreq 2$
	cp a,#'1 
	jreq 2$ 
	jra bin_exit 
2$: sub a,#'0	
	rrc a 
	rlc (BINARY+1,sp)
	rlc (BINARY,sp)
	jra 1$  
bin_exit:
	clr (x)
	ldw x,(BINARY,sp)
	ldw tokval,x 
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
;   X		exec_addr|var_addr 
;   A 		token attribute 
;   pad 	keyword|var_name  
;   tokval  exec_addr|var_addr 
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
	tnz pad+1 
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
	ldw tokval,x 
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
	_ldx_dict relop_dict	
	call search_dict
	ld a,xl
	ldw x,#pad 
	ldw tokval,x 
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
;   tokval   interger|addr|char|ptr to pad   
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
	ldw x,tokval 
	ret 
1$:	
	ldw y, basicptr   	
	ld a,in 
	cp a,count 
	jrmi 11$
	ld a,#TK_NONE 
	ret 
11$:	
	_vars VSIZE
	clr tokval 
	ldw x, #pad
	ld a,#SPACE
	call skip
	ld a,([in.w],y)
	jrne str_tst
	clrw x 
	ldw tokval,x 
	clr pad 
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
	ld a,#'%
	cp a,(CHAR,sp)
	jrne 0$
	call parse_binary ; expect binary integer 
	jp token_exit 
0$:	ld a,(CHAR,sp)
	call is_digit
	jrnc 3$
1$:	call parse_integer 
	jp token_exit 
3$: 
	ld (CHAR,sp),a 
	_case '(' rparnt_tst 
	ld a,#TK_LPAREN
	jp token_char   	
rparnt_tst:		
	_case ')' colon_tst 
	ld a,#TK_RPAREN 
	jp token_char 
colon_tst:
	_case ':' comma_tst 
	ld a,#TK_COLON 
	jp token_char
comma_tst:
	_case COMMA sharp_tst 
	ld a,#TK_COMMA
	jp token_char
sharp_tst:
	_case SHARP dash_tst 
	ld a,#TK_SHARP
	jp token_char  	 	 
dash_tst: 	
	_case '-' at_tst 
	ld a,#TK_MINUS  
	jp token_char 
at_tst:
	_case '@' qmark_tst 
	ld a,#TK_ARRAY 
	jp token_char
qmark_tst:
	_case '?' tick_tst 
	ld a,#TK_KWORD 
	ldw x,#print 
	ldw tokval,x 
	inc in 
	jp token_exit
tick_tst: ; ignore comment 
	_case TICK plus_tst 
	mov in,count  
	ld a,#TK_NONE 
	jp token_exit 
plus_tst:
	_case '+' star_tst 
	ld a,#TK_PLUS  
	jp token_char 
star_tst:
	_case '*' slash_tst 
	ld a,#TK_MULT 
	jp token_char 
slash_tst: 
	_case '/' prcnt_tst 
	ld a,#TK_DIV 
	jra token_char 
prcnt_tst:
	_case '%' eql_tst 
	ld a,#TK_MOD
	jra token_char  
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
	jra token_exit 
other: ; not a special character 	 
	ld a,(CHAR,sp)
	call is_alpha 
	jrc 30$ 
	ld a,#ERR_SYNTAX 
	jp tb_error 
30$: 
	call parse_keyword
	jra token_exit 
token_char:
	ld (ATTRIB,sp),a 
	ld a,(CHAR,sp)
	ld tokval+1,a 
	ld (x),a 
	incw x 
	clr(x)
	inc in 
	ld a,(ATTRIB,sp)
token_exit:
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
; skip character c in text starting from 'in'
; input:
;	 y 		point to text buffer
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
	ldw x,#dstack_unf-CELL_SIZE 
1$:	cpw x,dstkptr 
	jrult 4$ 
	ldw (XSAVE,sp),x
	ldw  x,(x)
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#10+128
	call prti24 
	ldw x,(XSAVE,sp)
	subw x,#CELL_SIZE 
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
;   A    token attribute 
;   dstack 	 integer
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
	call (x)
	jra 3$
11$:	
	cp a,#TK_LPAREN
	jrne 2$
	call relation
	ld a,#TK_RPAREN 
	call expect
	call dpop  
	jra 5$	
2$:	cp a,#TK_VAR 
	jrne 3$ 
	ldw x,(x)  
	jra 5$  
3$: cp a,#TK_INTGR
    jreq 5$
	 _unget_tok
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
	negw x
6$:	call dpush  
	ld a,#TK_INTGR
7$:	_drop VSIZE
	ret

;-----------------------------------
; term ::= factor [['*'|'/'|'%'] factor]* 
; output:
;   A    	token attribute 
;	dstack	integer
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
;   A    token attribute 
;   integer    pushed on dstack 
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
	jrne 31$
	mov acc8,#2 ; n1==n2
	jra 34$ 
31$: 
	jrsgt 32$  
	mov acc8,#4 ; n1<2 
	jra 34$
32$:
	mov acc8,#1 ; n1>n2 
34$:
	clrw x 
	ld a, acc8  
	and a,(RELOP,sp)
	tnz a 
	jreq 4$
	incw x 
4$:	 
	ldw [dstkptr],x 	
5$:
	ld a,#TK_INTGR
rel_exit: 	 
	_drop VSIZE
	ret 


;--------------------------------------------
; BASIC: HEX 
; select hexadecimal base for integer print
;---------------------------------------------
hex_base:
	mov base,#16 
	ret 

;--------------------------------------------
; BASIC: DEC 
; select decimal base for integer print
;---------------------------------------------
dec_base:
	mov base,#10
	ret 

;------------------------
; BASIC: SIZE 
; return free size in text area
; output:
;   A 		TK_INTGR
;   X 	    size integer
;--------------------------
size:
	ldw x,#tib 
	subw x,txtend 
	ld a,#TK_INTGR
	ret 

let:
	call get_token 
	cp a,#TK_VAR 
	jrne let_bad_syntax 
let02:
	call dpush
	call get_token 
	cp a,#TK_EQUAL
	jrne let_bad_syntax 
	call relation   
	cp a,#TK_INTGR 
	jrne let_bad_syntax 
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
	addw x,#3
	call puts 
	ld a,#CR 
	call putc 
	ret 	

	COMMA=1
	VSIZE=1
print:
	push #0 ; local variable COMMA 
prt_loop: 	
	call relation 
	cp a,#TK_INTGR 
	jrne 1$ 
	call prt_tos 
	jra prt_loop 
1$: 
	call get_token
	cp a,#TK_COLON 
	jreq print_exit
	cp a,#TK_NONE 
	jreq print_exit 
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
	call dpush 
	call prt_tos 
	jra prt_loop   
3$: cp a,#TK_COMMA 
	jrne 4$
	ld a,#1 
	ld (COMMA,sp),a 
	jra prt_loop   
4$: cp a,#TK_SHARP
	jrne 20$  
	call get_token
	cp a,#TK_INTGR 
	jreq 5$ 
	jra 20$
5$: 
	ld a,xl 
	and a,#15 
	ld tab_width,a 
	jp prt_loop 
print_exit:
	tnz (COMMA,sp)
	jrne 9$
	ld a,#CR 
    call putc 
9$:	_drop VSIZE 
	clr a
	ret 

;----------------------
; 'save_context' and
; 'rest_context' must be 
; called at the same 
; call stack depth 
; i.e. SP must have the 
; save value at  
; entry point of both 
; routine. 
;---------------------
;--------------------
; save current BASIC
; interpreter context 
; on cstack 
;--------------------
	_argofs 0 
	_arg BPTR 1
	_arg LNO 3 
	_arg IN 5
	_arg CNT 6
save_context:
	ldw x,basicptr 
	ldw (BPTR,sp),x
	ldw x,lineno 
	ldw (LNO,sp),x 
	ld a,in 
	ld (IN,sp),a
	ld a,count 
	ld (CNT,sp),a  
	ret

;-----------------------
; restore previously saved 
; BASIC interpreter context 
; from cstack 
;-------------------------
rest_context:
	ldw x,(BPTR,sp)
	ldw basicptr,x 
	ldw x,(LNO,sp)
	ldw lineno,x 
	ld a,(IN,sp)
	ld in,a
	ld a,(CNT,sp)
	ld count,a  
	ret

;------------------------------------------
; BASIC: INPUT [string],var[,[string],var]
; input value in variables 
; [string] optionally can be used as prompt 
;-----------------------------------------
	CX_BPTR=1
	CX_LNO=3
	CX_IN=4
	CX_CNT=5
	SKIP=6
	VSIZE=7
input_var:
	btjt flags,#FRUN,1$ 
	ld a,#ERR_RUN_ONLY 
	jp tb_error 
1$:	_vars VSIZE 
input_loop:
	clr (SKIP,sp)
	call get_token 
	cp a,#TK_NONE 
	jreq input_exit 
	cp a,#TK_QSTR 
	jrne 1$ 
	ldw x,tokval 
	call puts 
	cpl (SKIP,sp)
	call get_token 
1$: cp a,#TK_VAR  
	jreq 2$ 
	jp syntax_error
2$:	call dpush
	tnz (SKIP,sp)
	jrne 21$ 
	ld a,#':
	ld pad+1,a 
	clr pad+2
	ldw x,#pad 
	call puts   
21$:
	call save_context 
	ldw x,#tib 
	ldw basicptr,x  
	clr count  
	call readln 
	clr in 
	call relation 
	cp a,#TK_INTGR
	jreq 3$ 
	jp syntax_error
3$: 
	call store 
	call rest_context
	clr untok 
	call get_token 
	cp a,#TK_COMMA 
	jreq input_loop 
	_unget_tok 
input_exit:
	_drop VSIZE 
	clr a 
	ret 


;---------------------
; BASIC: REMARK | ' 
; begin a comment 
; comment are ignored 
; use ' insted of REM 
; it is faster 
;---------------------- 
rem: 
	mov in,count 
	clr untok 
	ret 


;---------------------
; BASIC: WAIT addr,mask[,xor_mask] 
; read in loop 'addr'  
; apply & 'mask' to value 
; loop while result==0.  
; if 'xor_mask' given 
; apply ^ in second  
; loop while result==0 
;---------------------
	XMASK=1 
	MASK=2
	ADDR=3
	VSIZE=4
wait: 
	_vars VSIZE
	clr (XMASK,sp) 
	call expression 
	cp a,#TK_INTGR
	jreq 1$ 
	jp syntax_error
1$: call dpop ; address 
	ldw (ADDR,sp),x 
	ld a,#TK_COMMA 
	call expect 
	call expression 
	cp a,#TK_INTGR
	jreq 2$ 
	jp syntax_error
2$: call dpop ; and mask 
	ld a,xl 
	ld (MASK,sp),a 
	call get_token 
	cp a,#TK_COMMA 
	jreq 3$
	_unget_tok 
	jra 5$
3$: call expression 
	cp a,#TK_INTGR
	jreq 4$
	jp syntax_error 
4$: call dpop ; xor mask 
	ld a,xl 
	ld (XMASK,sp),a 
5$:	ldw x,(ADDR,sp)
6$: ld a,(x)
	and a,(MASK,sp)
	xor a,(XMASK,sp)
	jreq 6$ 
	_drop VSIZE 
	clr a 
	ret 

;---------------------
; BASIC: BSET(addr,mask)
; set bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask        mask|addr
; output:
;	none 
;--------------------------
bit_set:
	ld a,#2 
	call arg_list 
	tnz a 
	jreq 1$ 
	jp syntax_error
1$: call dpop ; mask 
	ld a,xl 
	call dpop ; addr  
	or a,(x)
	ld (x),a 
	clr a
	ret 

;---------------------
; BASIC: BRES(addr,mask)
; reset bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask	    ~mask&*addr  
; output:
;	none 
;--------------------------
bit_reset:
	ld a,#2 
	call arg_list 
	tnz a 
	jreq 1$ 
	jp syntax_error
1$: call dpop ; mask 
	ld a,xl 
	cpl a 
	call dpop ; addr  
	and a,(x)
	ld (x),a 
	clr a 
	ret 

;---------------------
; BASIC: BRES(addr,mask)
; toggle bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask	    mask^*addr  
; output:
;	none 
;--------------------------
bit_toggle:
	ld a,#2 
	call arg_list 
	tnz a 
	jreq 1$ 
	jp syntax_error
1$: call dpop ; mask 
	ld a,xl 
	call dpop ; addr  
	xor a,(x)
	ld (x),a 
	clr a
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
	call relation 
	cp a,#TK_INTGR
	jreq 1$ 
	jp syntax_error
1$:	clr a 
	call dpop 
	tnzw x 
	jreq 9$  
	ret  
;skip to next line
9$:	mov in,count
	ret 

;------------------------
; BASIC: FOR var=expr 
; set variable to expression 
; leave variable address 
; on dstack and set
; FFOR bit in 'flags'
;-----------------
for: ; { -- var_addr }
	ld a,#TK_VAR 
	call expect 
	call dpush 
	call let02 
; leave with variable addr on dstack 		
	bset flags,#FFOR 
	call get_token 
	cp a,#TK_KWORD 
	jreq 1$
	jp syntax_error
1$:  
	cpw x,#to 
	jreq to
	jp syntax_error 

;-----------------------------------
; BASIC: TO expr 
; second part of FOR loop initilization
; leave limit on dstack and set 
; FTO bit in 'flags'
;-----------------------------------
to: ; { var_addr -- var_addr limit step }
	btjt flags,#FFOR,1$
	jp syntax_error
1$: call expression 
	cp a,#TK_INTGR 
	jreq 2$ 
	jp syntax_error
2$: 
	call get_token
	cp a,#TK_KWORD
	jrne 3$
	cpw x,#step 
	jreq step 
3$:	 
	_unget_tok 
	ldw x,#1   ; default step  
	call dpush ; save step on dstack 
	jra store_loop_addr 


;----------------------------------
; BASIC: STEP expr 
; optional third par of FOR loop
; initialization. 	
;------------------------------------
step: ; {var limit -- var limit step}
	btjt flags,#FFOR,1$
	jp syntax_error
1$: call expression 
	cp a,#TK_INTGR
	jreq store_loop_addr  
	jp syntax_error
; leave loop back entry point on cstack 
store_loop_addr:
	_vars 4 ; reserve 4 bytes 
; move return address on top 	
	ldw x,(5,sp)
	ldw (1,sp),x 
	ldw x,basicptr  
	ldw (5,sp),x 
	ldw x,in.w 
	ldw (3,sp),x   
	bres flags,#FFOR 
	inc loop_depth 
	clr a 
	ret 

;--------------------------------
; BASIC: NEXT var 
; FOR loop control 
; increment variable with step 
; and compare with limit 
; loop if threshold not crossed.
; else clean both stacks. 
; and decrement 'loop_depth' 
;--------------------------------
; loop address arguments on cstack 
	IN=3
	BPTR=5
next: ; {var limit step var -- [var limit step ] }
	tnz loop_depth 
	jrne 1$ 
	jp syntax_error 
1$: ld a,#TK_VAR 
	call expect
; chech for good variable after NEXT 	 
	ldw y,x 
	ldw x,#4  
	cpw y,([dstkptr],x) ; compare variables address 
	jreq 2$  
	jp syntax_error ; not the good one 
2$: ; increment variable 
	ldw x,y
	ldw x,(x)  ; get var value 
	ldw acc16,x 
	ldw x,[dstkptr]
	addw x,acc16 
	ldw (y),x ; save var new value 
; compare with limit 
	ldw y,x 
	ld a,[dstkptr] ; step in x 
	ldw x,#2 
	bcp a,#0x80 
	jreq 4$ ; positive step 
;negative step 
	cpw y,([dstkptr],x)
	jrslt loop_done
	jrv loop_done 
	jra loop_back 
4$: ; positive step 
	cpw y,([dstkptr],x)
	jrsgt loop_done
	jrv loop_done 
loop_back:
	ldw x,(BPTR,sp)
	ldw basicptr,x 
	btjf flags,#FRUN,1$ 
	ldw x,(x)
	ldw lineno,x
	ld a,(2,x)
	add a,#2 
	ld count,a
1$:	ldw x,(IN,sp)
	ldw in.w,x 
	clr a 
	ret 
loop_done:
	; remove var limit step on dstack 
	ldw x,dstkptr 
	addw x,#3*CELL_SIZE
	ldw dstkptr,x 
	; remove return address on cstack 
	ldw x,(1,sp)
	_drop 4 
	ldw (1,sp),x 
	dec loop_depth 
	clr a 
	ret 


;------------------------
; BASIC: GOTO lineno 
; jump to lineno 
;------------------------
goto:
	ld a,lineno 
	or a,lineno+1 
	jrne 0$  
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
	ld a,lineno 
	or a,lineno+1 
	jrne 0$  
	ret 
0$:	ldw x,basicptr
	ld a,(2,x)
	add a,#3 
	ld acc8,a 
	clr acc16 
	addw x,acc16 
	ldw (1,sp),x ; overwrite return addr, will not be used  
go_common: 
	call relation 
	cp a,#TK_INTGR
	jreq 1$ 
	jp syntax_error
1$: call dpop 
	call search_lineno  
	tnzw x 
	jrne 2$ 
	ld a,#ERR_NO_LINE 
	jp tb_error 
2$: 
	ldw basicptr,x 
	ld a,(2,x)
	add a,#3 
	ld count,a 
	ldw x,(x)
	ldw lineno,x 
	mov in,#3 
	jp interp_loop 

;------------------------
; BASIC: RETURN 
; exit from a subroutine 
;------------------------
	_argofs 0 
	_arg BASICPTR 1 
	_arg LINENO 3 
return:
	ld a,lineno 
	or a,lineno+1 
	jrne 0$ 
	ret 
0$:	ldw x,(3,sp) 
	ldw basicptr,x 
	ld a,(2,x)
	add a,#3 
	ld count,a 
	mov in,#3 
	_drop 4 
	jp interp_loop 


;----------------------------------
; BASIC: RUN ["program_name"]
; run BASIC program in RAM or flash
;----------------------------------- 
run: 
	btjf flags,#FRUN,0$  
	clr a 
	ret
0$: ldw x,txtbgn
	cpw x,txtend 
	jrmi 1$ 
	clr a 
	ret 
1$: _drop 2 
	ldw basicptr,x 
	ld a,(2,x)
	add a,#2 ; consider that in start at 3  
	ld count,a
	ldw x,(x)
	ldw lineno,x
	mov in,#3	
	bset flags,#FRUN 
	jp interp_loop 


;----------------------
; BASIC: STOP 
; stop running program
;---------------------- 
stop: 
	btjt flags,#FRUN,0$  
	clr a 
	ret 
; clean dstack and cstack 
0$: ldw x,#STACK_EMPTY 
	ldw sp,x 
	bres flags,#FRUN 
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
	_drop 2 
	jp clear_basic
	 

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
	jreq 0$ 
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

;------------------------------
; BASIC: PAUSE expr 
; suspend execution for n msec.
; input:
;	none
; output:
;	none 
;------------------------------
pause:
	call expression
	cp a,#TK_INTGR
	jreq 0$
	jp syntax_error
0$:	call dpop
	mov TIM4_PSCR,#7 ; prescale 128  
	mov TIM4_ARR,#125 ; set for 1msec.
	mov TIM4_CR1,#((1<<TIM4_CR1_CEN)|(1<<TIM4_CR1_URS))
	bset TIM4_IER,#TIM4_IER_UIE 
1$: wfi 
	tnzw x  
	jrpl 1$
	bres TIM4_IER,#TIM4_IER_UIE 
    clr TIM4_CR1 
	clr a 
	ret 

;------------------------------
; BASIC: ABS(expr)
; return absolute value of expr.
; input:
;   none
; output:
;   X     	positive integer
;-------------------------------
abs:
	ld a,#1
	call arg_list
	tnz a
	jreq 0$ 
	jp syntax_error
0$: 
    call dpop 
	ld a,xh 
	bcp a,#0x80 
	jreq 2$ 
	negw x 
2$: ld a,#TK_INTGR 
	ret 

;------------------------------
; BASIC: RND(expr)
; return random number 
; between 1 and expr inclusive
; xorshift16 ref: http://b2d-f9r.blogspot.com/2010/08/16-bit-xorshift-rng-now-with-more.html
; input:
; 	none 
; output:
;	X 		random positive integer 
;------------------------------
random:
	ld a,#1 
	call arg_list 
	tnz a
	jreq 1$
	jp syntax_error
1$: call dpop 
	pushw x 
	ld a,xh 
	jrpl 2$
	jp syntax_error 
2$: 
; acc16=(x<<5)^x 
	ldw x,seedx 
	sllw x 
	sllw x 
	sllw x 
	sllw x 
	sllw x 
	ld a,xh 
	xor a,seedx 
	ld acc16,a 
	ld a,xl 
	xor a,seedx+1 
	ld acc8,a 
; seedx=seedy 
	ldw x,seedy 
	ldw seedx,x  
; seedy=seedy^(seedy>>1)
	srlw y 
	ld a,yh 
	xor a,seedy 
	ld seedy,a  
	ld a,yl 
	xor a,seedy+1 
	ld seedy+1,a 
; acc16>>3 
	ldw x,acc16 
	srlw x 
	srlw x 
	srlw x 
; x=acc16^x 
	ld a,xh 
	xor a,acc16 
	ld xh,a 
	ld a,xl 
	xor a,acc8 
	ld xl,a 
; seedy=x^seedy 
	xor a,seedy+1
	ld xl,a 
	ld a,xh 
	xor a,seedy
	ld xh,a 
	ldw seedy,x 
; return seedy modulo expr + 1 
	popw y 
	divw x,y 
	ldw x,y 
	incw x 
	ld a,#TK_INTGR
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

	_dict_entry,4,LOAD,load 
	_dict_entry,4,SAVE,save 
	_dict_entry,3,HEX,hex_base
	_dict_entry,3,DEC,dec_base
	_dict_entry,3,NEW,new
	_dict_entry,4,STOP,stop 
    _dict_entry 3,RUN,run
	_dict_entry,4,SIZE,size
	_dict_entry,3,ABS,abs
	_dict_entry,3,RND,random 
	_dict_entry,5,PAUSE,pause 
	_dict_entry,4,BSET,bit_set 
	_dict_entry,4,BRES,bit_reset
	_dict_entry,5,BTOGL,bit_toggle
	_dict_entry 4,WAIT,wait 
	_dict_entry 3,REM,rem 
	_dict_entry 5,PRINT,print 
	_dict_entry 4,LIST,list
	_dict_entry,2,IF,if 
	_dict_entry,5,GOSUB,gosub 
	_dict_entry,4,GOTO,goto 
	_dict_entry,3,FOR,for 
	_dict_entry,2,TO,to
	_dict_entry,4,STEP,step 
	_dict_entry,4,NEXT,next 
	_dict_entry,6,RETURN,return 
	_dict_entry,4,PEEK,peek 
	_dict_entry,4,POKE,poke 
	_dict_entry,3,USR,usr
	_dict_entry,5,INPUT,input_var  
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

