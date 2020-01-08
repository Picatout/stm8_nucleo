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
;   Implementation of Tiny BASIC
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

_dbg 

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
	FSLEEP=3 ; halt produit par la commande SLEEP 

in.w:  .blkb 1 ; parser position in text line
in:    .blkb 1 ; low byte of in.w
count: .blkb 1 ; length of string in text line  
basicptr:  .blkb 2  ; point to text buffer 
lineno: .blkb 2  ; BASIC line number 
base:  .blkb 1 ; nemeric base used to print integer 
acc24: .blkb 1 ; 24 accumulator
acc16: .blkb 1
acc8:  .blkb 1
ticks: .blkw 1 ; milliseconds ticks counter (see Timer4UpdateHandler)
seedx: .blkw 1  ; xorshift 16 seed x 
seedy: .blkw 1  ; xorshift 16 seed y 
untok: .blkb 1  ; last ungotten token attribute 
tokval: .blkw 1 ; last parsed token value  
farptr: .blkb 3 ; far pointer 
ffree: .blkb 3 ; flash free address 
dstkptr: .blkw 1  ; data stack pointer 
txtbgn: .ds 2 ; BASIC text beginning address 
txtend: .ds 2 ; BASIC text end address 
loop_depth: .ds 1 ; FOR loop depth 
array_addr: .ds 2 ; address of @ array 
array_size: .ds 2 ; array size 
flags: .ds 1 ; boolean flags
tab_width: .ds 1 ; print colon width (4)
vars: .ds 2*26 ; BASIC variables A-Z, keep it as but last .
; keep as last variable 
free_ram: ; from here RAM free for BASIC text 

;-----------------------------------
    .area SSEG (ABS)
;-----------------------------------	
    .org RAM_SIZE-STACK_SIZE-TIB_SIZE-PAD_SIZE-DSTACK_SIZE 
tib: .ds TIB_SIZE             ; transaction input buffer
pad: .ds PAD_SIZE             ; working buffer
dstack: .ds DSTACK_SIZE 
dstack_unf: ; dstack underflow 
stack_full: .ds STACK_SIZE   ; control stack 
stack_unf: ; stack underflow  


;--------------------------------------
    .area HOME 
;--------------------------------------
    int cold_start
.if DEBUG
	int TrapHandler 		;TRAP  software interrupt
.else
	int NonHandledInterrupt ;TRAP  software interrupt
.endif
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 gpio A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 gpio B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 gpio C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 gpio D external interrupts
	int UserButtonHandler   ;int7 EXTI4 gpio E external interrupts
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
.if DEBUG
.asciz "TBI_STM8" ; I like to put module name here.
.endif 

NonHandledInterrupt:
    .byte 0x71  ; reinitialize MCU


;------------------------------------
; software interrupt handler  
;------------------------------------
.if DEBUG 
TrapHandler:
	bset flags,#FTRAP 
	call print_registers
	call cmd_itf
	bres flags,#FTRAP 	
	iret
.endif 

Timer4UpdateHandler:
	clr TIM4_SR 
	ldw x,ticks
	incw x
	ldw ticks,x 
	iret 


;------------------------------------
; Triggered by pressing USER UserButton 
; on NUCLEO card.
;------------------------------------
UserButtonHandler:
; wait button release
	clrw x
1$: decw x 
	jrne 1$
	btjf USR_BTN_PORT,#USR_BTN_BIT, 1$
    btjf flags,#FSLEEP,2$
	bres flags,#FSLEEP 
	iret
2$:	btjt flags,#FRUN,4$
	jp 9$ 
4$:	bres flags,#FRUN 
	ldw x,#USER_ABORT
	call puts 
	ldw x,basicptr
	ldw x,(x)
	ldw acc16,x 
	clr acc24 
	clrw x 
	ld a,#5
	ld xl,a 
	ld a,#10 
	call prti24
	ldw x,basicptr 
	addw x,#3  
	call puts 
	ld a,#CR 
	call putc
	clrw x  
	ld a,in 
	add a,#2 ; adjustment for line number display 
	ld xl,a 
	call spaces 
	ld a,#'^
	call putc 
9$:
    ldw x,#STACK_EMPTY 
    ldw sp,x
	rim 
	jp warm_start


USER_ABORT: .asciz "\nProgram aborted by user.\n"


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

;---------------------------------
; TIM4 is configured to generate an 
; interrupt every millisecond 
;----------------------------------
timer4_init:
	mov TIM4_PSCR,#7 ; prescale 128  
	mov TIM4_ARR,#125 ; set for 1msec.
	mov TIM4_CR1,#((1<<TIM4_CR1_CEN)|(1<<TIM4_CR1_URS))
	bset TIM4_IER,#TIM4_IER_UIE 
	ret

;----------------------------------
; unlock EEPROM for writing/erasing
; wait endlessly for FLASH_IAPSR_DUL bit.
; input:
;  none
; output:
;  none 
;----------------------------------
unlock_eeprom:
	mov FLASH_DUKR,#FLASH_DUKR_KEY1
    mov FLASH_DUKR,#FLASH_DUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
	ret

;----------------------------------
; unlock FLASH for writing/erasing
; wait endlessly for FLASH_IAPSR_PUL bit.
; input:
;  none
; output:
;  none
;----------------------------------
unlock_flash:
	mov FLASH_PUKR,#FLASH_PUKR_KEY1
	mov FLASH_PUKR,#FLASH_PUKR_KEY2
	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
	ret

;----------------------------
; erase block code must be 
;executed from RAM
;-----------------------------

; this code is copied to RAM 
erase_start:
	clr a 
    bset FLASH_CR2,#FLASH_CR2_ERASE
    bres FLASH_NCR2,#FLASH_CR2_ERASE
	ldf [farptr],a
    inc farptr+2 
    ldf [farptr],a
    inc farptr+2 
    ldf [farptr],a
    inc farptr+2 
    ldf [farptr],a
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
	ret
erase_end:


move_code_in_ram:
	ldw x,#erase_end 
	subw x,#erase_start
	ldw acc16,x 
	ldw x,#pad 
	ldw y,#erase_start 
	call move 
	ret 

;-----------------------------------
; erase flash or EEPROM block 
; a block is 128 bytes 
; input:
;   farptr  address block begin
; output:
;   none
;--------------------------------------
erase_block:
	ldw x,farptr+1 
	pushw x 
	call move_code_in_ram 
	popw x 
	ldw farptr+1,x 
	tnz farptr
	jrne erase_flash 
	ldw x,#FLASH_BASE 
	cpw x,farptr+1 
	jrpl erase_flash 
; erase eeprom block
	call unlock_eeprom 
	sim 
	call erase_start  
	bres FLASH_IAPSR,#FLASH_IAPSR_DUL
	rim 
	ret 
; erase flash block:
erase_flash:
	call unlock_flash 
	bset FLASH_CR2,#FLASH_CR2_ERASE
	bres FLASH_NCR2,#FLASH_CR2_ERASE
	clr a 
	sim 
	call pad 
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
	rim 
	ret 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; write a byte to FLASH or EEPROM 
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
	VSIZE = 2
write_byte:
	pushw y
	_vars VSIZE
	ld (BTW,sp),a ; byte to write 
	clr (OPT,sp)  ; OPTION flag
; put addr[15:0] in Y, for bounds check.
	ldw y,farptr+1   ; Y=addr15:0
; check addr[23:16], if <> 0 then it is extened flash memory
	tnz farptr 
	jrne write_flash
    cpw y,#user_space
    jruge write_flash
	cpw y,#EEPROM_BASE  
    jrult write_exit
	cpw y,#OPTION_BASE
	jrult write_eeprom
    jra write_exit
; write program memory
write_flash:
	call unlock_flash 
1$:	sim 
	ld a,(BTW,sp)
	ldf ([farptr],x),a ; farptr[x]=A
	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
    rim 
    bres FLASH_IAPSR,#FLASH_IAPSR_PUL
    jra write_exit
; write eeprom and option
write_eeprom:
	call unlock_eeprom
	; check for data eeprom or option eeprom
	cpw y,#OPTION_BASE
	jrmi 1$
	cpw y,#OPTION_END+1
	jrpl 1$
	cpl (OPT,sp)
1$: 
    tnz (OPT,sp)
    jreq 2$
	; pour modifier une option il faut modifier ces 2 bits
    bset FLASH_CR2,#FLASH_CR2_OPT
    bres FLASH_NCR2,#FLASH_CR2_OPT 
2$: 
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
	_drop VSIZE 
	popw y
    ret

;--------------------------------------------
; write a data block to eeprom or flash 
; input:
;   Y        source address   
;   X        array index  destination  farptr[x]
;   BSIZE    block size bytes 
;   farptr   write address , byte* 
; output:
;	X 		after last byte written 
;   Y 		after last byte read 
;  farptr   point after block
;---------------------------------------------
	_argofs 2 
	_arg BSIZE 1  ; block size
	; local var 
	XSAVE=1 
	VSIZE=2 
write_block:
	_vars VSIZE
	ldw (XSAVE,sp),x 
	ldw x,(BSIZE,sp) 
	jreq 9$
1$:	ldw x,(XSAVE,sp)
	ld a,(y)
	call write_byte 
	incw x 
	incw y 
	ldw (XSAVE,sp),x
	ldw x,(BSIZE,sp)
	decw x
	ldw (BSIZE,sp),x 
	jrne 1$
9$:
	ldw x,(XSAVE,sp)
	call incr_farptr
	_drop VSIZE
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

.if DEBUG 
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
.endif 

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

;------------------------------------
; compare 2 strings
; input:
;   X 		char* first string 
;   Y       char* second string 
; output:
;   A 		0|1 
;-------------------------------------
strcmp:
	ld a,(x)
	jreq 5$ 
	cp a,(y) 
	jrne 4$ 
	incw x 
	incw y 
	jra strcmp 
4$: ; not same  
	clr a 
	ret 
5$: ; same 
	ld a,#1 
	ret 


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
;    X 			addr gap start 
;    Y 			gap length 
; output:
;    X 			addr gap start 
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
	call dpop 
	tnzw x 
	jrpl 0$ 
	jp syntax_error ; negative line number 
0$:
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
	ld a,#ERR_MEM_FULL
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
software: .asciz "\n\nTiny BASIC for STM8\nCopyright, Jacques Deschenes 2019,2020\nversion "
cold_start:
;set stack 
	ldw x,#STACK_EMPTY
	ldw sp,x   
; clear all ram 
0$: clr (x)
	decw x 
	jrne 0$
; activate pull up on all inputs 
	ld a,#255 
	ld PA_CR1,a 
	ld PB_CR1,a 
	ld PC_CR1,a 
	ld PD_CR1,a 
	ld PE_CR1,a 
	ld PF_CR1,a 
	ld PG_CR1,a 
	ld PI_CR1,a 
; select internal clock no divisor: 16 Mhz 	
	ld a,#CLK_SWR_HSI 
	clrw x  
    call clock_init 
	call timer4_init
; UART3 at 115200 BAUD
	call uart3_init
; activate PE_4 (user button interrupt)
    bset PE_CR2,#USR_BTN_BIT 
; display system information
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
	call seek_fdrive  
; configure LED2 pin 
    bset PC_CR1,#LED2_BIT
    bset PC_CR2,#LED2_BIT
    bset PC_DDR,#LED2_BIT
	rim 
	ldw x,#tib
	ldw array_addr,x 
	inc seedy+1 
	inc seedx+1 
	call clear_basic
    jp warm_start 

clear_basic:
	clrw x 
	ldw lineno,x
	clr count 
	ldw x,#free_ram 
	ldw txtbgn,x 
	ldw txtend,x 
	call clear_vars 
	ret 

err_msg:
	.word 0,err_mem_full, err_syntax, err_math_ovf, err_div0,err_no_line    
	.word err_run_only,err_cmd_only,err_duplicate,err_not_file,err_bad_value
	.word err_no_access 

err_mem_full: .asciz "\nMemory full\n" 
err_syntax: .asciz "\nsyntax error\n" 
err_math_ovf: .asciz "\nmath operation overflow\n"
err_div0: .asciz "\ndivision by 0\n" 
err_no_line: .asciz "\ninvalid line number.\n"
err_run_only: .asciz "\nrun time only usage.\n" 
err_cmd_only: .asciz "\ncommand line only usage.\n"
err_duplicate: .asciz "\nduplicate name.\n"
err_not_file: .asciz "\nFile not found.\n"
err_bad_value: .asciz "\nbad value.\n"
err_no_access: .asciz "\nFile in extended memory, can't be run from there.\n" 

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
	cp a,#TK_NONE 
	jreq interp
	cp a,#TK_COLON 
	jrne 1$
	call ddrop  
	jra interp 
1$:
	cp a,#TK_VAR
	jrne 2$
	call let02  
	jra interp_loop 
2$:	
	cp a,#TK_ARRAY 
	jrne 3$
	call get_array_element
	call let02 
	jra interp_loop 
3$:
	cp a,#TK_CMD
	jrne 4$
	call execute 
	jra interp_loop 
4$: cp a,TK_FUNC 
	jrne 5$
	call execute 	
	call prt_tos 
	jp interp_loop 
5$:
	cp a,#TK_INTGR
	jreq 6$
.if DEBUG
	jp 9$
.else 
	jp syntax_error
.endif 
6$:	btjt flags,#FRUN,7$ 
	ld a,#5
	cp a,in 
	jrpl 8$
7$:	jp syntax_error
8$:	call insert_line 
	jp interp 
.if DEBUG 
9$:	ld a,#'D  
	cp a,pad 
	jrne 3$ 
	_dbg_trap 
10$:
	jp syntax_error  
.endif 
	.blkb 0x71 ; reset MCU

;----------------------------------------
;   DEBUG support functions
;----------------------------------------
.if DEBUG 
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

STATES:  .asciz "\nRegisters state at abort point.\n--------------------------\n"
REG_EPC: .asciz "EPC: "
REG_Y:   .asciz "\nY: " 
REG_X:   .asciz "\nX: "
REG_A:   .asciz "\nA: " 
REG_CC:  .asciz "\nCC: "
REG_SP:  .asciz "\nSP: "
.endif 

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
;	cp a,#'[
;	jreq ansi_seq
final_test:
	cp a,#SPACE
	jrpl accept_char
	jra readln_loop
ansi_seq:
;	call getc
;	cp a,#'C 
;	jreq rigth_arrow
;	cp a,#'D 
;	jreq left_arrow 
;	jra final_test
right_arrow:
;	ld a,#BSP 
;	call putc 
;	jra realn_loop 
left_arrow:

;	jra readln_loop
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
;   TOS  char* to pad  
;------------------------------------
	PREV = 1
	CURR =2 
	VSIZE=2 
parse_quote: ; { -- addr }
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
	call dpush  
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
;   X 		integer 
;   A 		TK_INTGR
;   TOS     integer 
;-------------------------
	BASE=1
	TCHAR=2 
	VSIZE=2 
parse_integer: ; { -- n }
	push #0 ; TCHAR 
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
	ld (TCHAR,sp),a 
	call is_digit 
	jrc 2$
	ld a,#16 
	cp a,(BASE,sp)
	jrne 3$ 
	ld a,(TCHAR,sp)
	cp a,#'A 
	jrmi 3$ 
	cp a,#'G 
	jrmi 2$ 
3$:	clr (x)
	call atoi
	ldw x,acc16 
	call dpush  
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
;   X 		integer 
;   A 		TK_INTGR
;   TOS     integer 
;-------------------------
	BINARY=1
	VSIZE=2
parse_binary: ; { -- n }
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
	call dpush  
	ld a,#TK_INTGR 	
	_drop VSIZE 
	ret

;---------------------------
;  token begin with a letter,
;  is keyword or variable. 	
; input:
;   X 		point to pad 
;   Y 		point to text
;   A 	    first letter  
; output:
;   X		exec_addr|var_addr 
;   A 		TK_CMD 
;   pad 	keyword|var_name  
;   TOS     exec_addr|var_addr 
;--------------------------  
parse_keyword: ; { -- exec_addr|var_addr}
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
	tnz a
	jrne 3$ 
	jp syntax_error
3$: cpw x,#rem  
	jrne 4$
	mov in,count 
	clr a 
	ret  	
4$: 
	call dpush 
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
;   TOS   token value   
;------------------------------------
	; use to check special character 
	.macro _case c t  
	ld a,#c 
	cp a,(TCHAR,sp) 
	jrne t
	.endm 

	TCHAR=1
	ATTRIB=2 
	VSIZE=2
get_token: ; { -- tokval }
	tnz untok 
	jreq 1$
	ld a,untok
	clr untok 
	ldw x,tokval
	call dpush  
	ret 
1$:	
	ldw y,basicptr   	
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
	clr pad 
	jp token_exit

str_tst: ; check for quoted string  	
	call to_upper 
	ld (TCHAR,sp),a 
	_case '"' nbr_tst
	call parse_quote
	jp token_exit
nbr_tst: ; check for number 
	ld a,#'$'
	cp a,(TCHAR,sp) 
	jreq 1$
	ld a,#'&
	cp a,(TCHAR,sp)
	jrne 0$
	call parse_binary ; expect binary integer 
	jp token_exit 
0$:	ld a,(TCHAR,sp)
	call is_digit
	jrnc 3$
1$:	call parse_integer 
	jp token_exit 
3$: 
	ld (TCHAR,sp),a 
	_case '(' bkslsh_tst 
	ld a,#TK_LPAREN
	jp token_char   	
bkslsh_tst:
	_case '\',rparnt_tst
	ld (x),a 
	incw x 
	inc in 
	ld a,([in.w],y)
	ld (x),a 
	incw x 
	inc in  
	clrw x 
	ld xl,a 
	call dpush 
	ld a,#TK_CHAR 
	jp token_exit 
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
	ld a,#TK_CMD 
	ldw x,#print 
	call dpush 
	inc in 
	jp token_exit
tick_tst: ; ignore comment 
	_case TICK plus_tst 
	mov in,count  
	clr a 
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
	jp token_char 
prcnt_tst:
	_case '%' eql_tst 
	ld a,#TK_MOD
	jp token_char  
; 1 or 2 character tokens 	
eql_tst:
	_case '=' gt_tst 		
	ld a,#TK_EQUAL
	jp token_char 
gt_tst:
	_case '>' lt_tst 
	ld a,#TK_GT 
	ld (ATTRIB,sp),a 
	inc in 
	ld a,([in.w],y)
	cp a,#'=
	jrne 1$
	ld a,(TCHAR,sp)
	ld (x),a
	incw x 
	ld a,#'=
	ld (TCHAR,sp),a 
	ld a,#TK_GE 
	jra token_char  
1$: cp a,#'<
	jrne 2$
	ld a,(TCHAR,sp)
	ld (x),a
	incw x 
	ld a,#'<	
	ld (TCHAR,sp),a 
	ld a,#TK_NE 
	jra token_char 
2$: dec in
	ld a,(ATTRIB,sp)
	jra token_char 
lt_tst:
	_case '<' other
	ld a,#TK_LT 
	ld (ATTRIB,sp),a 
	inc in 
	ld a,([in.w],y)
	cp a,#'=
	jrne 1$
	ld a,(TCHAR,sp)
	ld (x),a 
	ld a,#'=
	ld (TCHAR,sp),a 
	ld a,#TK_LE 
	jra token_char 
1$: cp a,#'>
	jrne 2$
	ld a,(TCHAR,sp)
	ld (x),a 
	incw x 
	ld a,#'>
	ld (TCHAR,sp),a 
	ld a,#TK_NE 
	jra token_char 
2$: dec in 
	ld a,(ATTRIB,sp)
	jra token_char 	
other: ; not a special character 	 
	ld a,(TCHAR,sp)
	call is_alpha 
	jrc 30$ 
	ld a,#ERR_SYNTAX 
	jp tb_error 
30$: 
	call parse_keyword
	jra token_exit 
token_char:
	ld (ATTRIB,sp),a 
	ld a,(TCHAR,sp)
	ld (x),a 
	incw x 
	clr(x)
	inc in 
	ld a,(ATTRIB,sp)
	ldw x,#pad 
	call dpush 
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
; uppercase pad content
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

;******************************

;----------------------	
; push X on data stack 
; input:
;	X 
; output:
;	none 
;----------------------	
dpush:
    _dp_down
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
	_dp_up
	ret 

;-----------------------------
; swap top 2 elements of dstack
;  {n1 n2 -- n2 n1 }
;-----------------------------
dswap:
	ldw x,[dstkptr]
	pushw x 
	ldw x,#2 
	ldw x,([dstkptr],x) 
	ldw [dstkptr],x 
	ldw x,#2
	popw y 
	ldw ([dstkptr],x),y 
	ret

;-----------------------------
; drop TOS 
;-----------------------------
ddrop: ; { n -- }
	_dp_up 
	ret
	
;-----------------------------
; duplicate TOS 
;  dstack: { ix...n -- ix...n n }
;-----------------------------
ddup:
	ldw x,[dstkptr]
	_dp_down
    ldw [dstkptr],x  
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
; store variable 
; dstack: {addr value -- }
;----------------------------
store:
	call dpop 
	ldw y,x   ; y=value 
	call dpop 
	ldw (x),y 
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

;------------------------------
; put A in untok, pop TOS put it in tokval
; dstack { n -- }
; input:
;   A     token_attribute 
;   TOS   token value 
; output:
;   untok    A 
;   tokval   n 
;------------------------------
unget_token:
	ld untok,a 
	ldw x,[dstkptr]
	ldw tokval,x 
	_dp_up 
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
; execute procedure which address
; is at TOS 
; --------------------------------
execute: ; { addr -- ? }
	call dpop
	call (x)
	ret 


;---------------------------------
; input:
;	X 		dictionary entry point 
;  pad		.asciz name to search 
; output:
;  A 		TK_CMD|TK_FUNC|TK_NONE 
;  X		execution address | 0 
;---------------------------------
	NLEN=1 ; cmd length 
	YSAVE=2
	VSIZE=3 
search_dict:
	_vars VSIZE 
	ldw y,x 
search_next:	
	ld a,(y)
	and a,#0x7f 
	ld (NLEN,sp),a  
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
	subw y,#2 ; move Y to link field
	push #TK_NONE 
	ldw y,(y) ; next word link 
	pop a ; TK_NONE 
	jreq search_exit  ; not found  
;try next 
	jra search_next
str_match:
	ldw y,(YSAVE,sp)
	ld a,(y)
	ld (NLEN,sp),a ; needed to test bit 7 
	and a,#0x7f 
; move y to procedure address field 	
	inc a 
	ld acc8,a 
	clr acc16 
	addw y,acc16 
	ldw y,(y) ; routine entry point 
	ld a,(NLEN,sp)
	bcp a,#0x80 
	jreq 1$
	ld a,#TK_FUNC 
	jra search_exit
1$: ld a,#TK_CMD 
search_exit: 
	ldw x,y ; x=routine address 
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
; arg_list::=  rel[','rel]*
; all arguments are of integer type
; input:
;   none
; output:
;   A 			number of arguments pushed on dstack  
;--------------------------------
	ARG_CNT=1 
arg_list:
	push #0  
1$: call relation
	cp a,#TK_NONE 
	jreq 5$
	cp a,#TK_INTGR
	jrne 4$
3$:
    inc (ARG_CNT,sp)
	call get_token 
	cp a,#TK_NONE 
	jreq 5$ 
	cp a,#TK_COMMA 
	jrne 4$
	call ddrop 
	jra 1$ 
4$:	call unget_token 
5$:	pop a 
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

;---------------------
; return array element
; address from @(expr)
; input:
;   A 		TK_ARRAY
; output:
;	X 		TK_INTGR, element address 
;----------------------
get_array_element:
	call ddrop ; {*pad -- }
	ld a,#TK_LPAREN 
	call expect
	call relation 
	cp a,#TK_INTGR 
	jreq 1$
	jp syntax_error
1$: 
	ld a,#TK_RPAREN 
	call expect 
	; check for bounds 
	call dpop  
	cpw x,array_size 
	jrule 3$
; bounds {1..array_size}	
2$: ld a,#ERR_BAD_VALUE 
	jp tb_error 
3$: tnzw  x
	jreq 2$ 
	sllw x 
	pushw x 
	ldw x,array_addr  
	subw x,(1,sp)
	call dpush 
	_drop 2   
	ld a,#TK_INTGR
	ret 

;***********************************
;   expression parse,execute 
;***********************************
;-----------------------------------
; factor ::= ['+'|'-'|e] var | @ |
;			 integer | function |
;			 '('relation')' 
; output:
;   A    token attribute 
;   dstack 	 integer
; ---------------------------------
	NEG=1
	VSIZE=1
factor:
	_vars VSIZE 
	call get_token
	cp a,#TK_NONE 
	jrne 0$
	jp 20$
0$:	ld (NEG,sp),a 
	and a,#TK_GRP_MASK 
	cp a,#TK_GRP_ADD 
	jreq 2$ 
	ld a,(NEG,sp)
	clr (NEG,sp)
	jra 4$
2$:	_dp_up ; {char* pad -- } 
	call get_token 
4$:	cp a,#TK_FUNC 
	jrne 5$ 
	call execute 
	call dpop
	jra 18$ 
5$:
	cp a,#TK_INTGR
	jrne 6$
	call dpop
	jra 18$
6$:
	cp a,#TK_ARRAY
	jrne 10$
	call get_array_element
	call dpop 
	ldw x,(x)
	jra 18$ 
10$:
	cp a,#TK_VAR 
	jrne 12$
	call dpop 
	ldw x,(x)
	jra 18$
12$:			
	cp a,#TK_LPAREN
	jrne 16$
	call relation
	ld a,#TK_RPAREN 
	call expect
	call dpop  
	jra 18$	
16$:
	call unget_token
	clr a 
	jra 20$ 
18$: 
	ld a,#TK_MINUS 
	cp a,(NEG,sp)
	jrne 19$
	negw x
19$:
	call dpush  
	ld a,#TK_INTGR
20$:
	_drop VSIZE
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
term01:	 ; check for  operator 
	call get_token
	cp a,#TK_NONE
	jreq 9$
	cp a,#TK_COLON 
	jrne 0$
	call ddrop
	jra 9$   
0$:	ld (MULOP,sp),a
	and a,#TK_GRP_MASK
	cp a,#TK_GRP_MULT
	jreq 1$
	ld a,(MULOP,sp) 
	call unget_token 
	jra 9$
1$:	; got *|/|%
	call ddrop ; {char* pad -- } 
	call factor
	cp a,#TK_INTGR
	jreq 2$ 
	jp syntax_error
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
9$: ld a,#TK_INTGR 	
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
0$:	call get_token
	cp a,#TK_NONE 
	jreq 9$  
	cp a,#TK_COLON 
	jrne 1$
	call ddrop
	jra 9$   
1$:	ld (OP,sp),a  
	and a,#TK_GRP_MASK
	cp a,#TK_GRP_ADD 
	jreq 2$ 
	ld a,(OP,sp)
	call unget_token
	jra 9$
2$: call ddrop 
	call term
	cp a,#TK_INTGR 
	jreq 3$
	jp syntax_error
3$:	
	ld a,(OP,sp)
	cp a,#TK_PLUS 
	jrne 4$
	call add 
	jra 0$ 
4$:	call substract
	jra 0$
9$: ld a,#TK_INTGR	
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
	cp a,#TK_NONE 
	jreq 9$
	cp a,#TK_COLON 
	jrne 1$
	call ddrop 
	jra 9$ 
1$:	
	ld (RELOP,sp),a 
	and a,#TK_GRP_MASK
	cp a,#0x30 
	jreq 2$
	ld a,(RELOP,sp)
	call unget_token  
	jra 9$
2$:	; expect another expression or error 
	call ddrop 
	call expression
	cp a,#TK_INTGR 
	jreq 3$
	jp syntax_error 
3$:	
	call substract
	jrne 4$
	mov acc8,#2 ; n1==n2
	jra 6$ 
4$: 
	jrsgt 5$  
	mov acc8,#4 ; n1<2 
	jra 6$
5$:
	mov acc8,#1 ; n1>n2 
6$:
	clrw x 
	ld a, acc8  
	and a,(RELOP,sp)
	tnz a 
	jreq 7$
	incw x 
7$:	 
	ldw [dstkptr],x 	
9$:
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
	call dpush 
	ld a,#TK_INTGR
	ret 


;------------------------
; BASIC: UBOUND  
; return array variable size 
; output:
;   A 		TK_INTGR
;   X 	    array size 
;--------------------------
ubound:
	ldw x,#tib
	subw x,txtend 
	srlw x 
	ldw array_size,x
	call dpush   
	ld a,#TK_INTGR
	ret 

let:
	call get_token 
	cp a,#TK_VAR 
	jreq let02
	jp syntax_error
let02:
	call get_token 
	cp a,#TK_EQUAL
	jreq 1$
	jp syntax_error
1$:	call ddrop 
	call relation   
	cp a,#TK_INTGR 
	jreq 2$
	jp syntax_error
2$:	
	call store  
	ld a,#TK_NONE 
	ret 

;----------------------------
; BASIC: LIST [[start][,end]]
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
	ldw x,txtbgn 
	cpw x,txtend 
	jrmi 1$
	jp list_exit ; nothing to list 
1$:	ldw (LN_PTR,sp),x 
	ldw x,(x) 
	ldw (FIRST,sp),x ; list from first line 
	ldw x,#0x7fff ; biggest line number 
	ldw (LAST,sp),x 
	call arg_list
	tnz a
	jreq list_start 
	cp a,#2 
	jreq 4$
	cp a,#1 
	jreq first_line 
	jp syntax_error 
4$:	call dswap
first_line:
	call dpop 
	ldw (FIRST,sp),x 
	cp a,#1 
	jreq lines_skip 	
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
	jrsgt list_exit 
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

;---------------------------------
; BASIC: PRINT|? arg_list 
; print values from argument list
;----------------------------------
	COMMA=1
	VSIZE=1
print:
	push #0 ; local variable COMMA 
reset_comma:
	clr (COMMA,sp)
prt_loop:
	call relation
	cp a,#TK_INTGR 
	jrne 1$ 
	call prt_tos 
	jra reset_comma
1$: 	
	call get_token
	cp a,#TK_COLON 
	jreq print_exit
	cp a,#TK_NONE 
	jreq print_exit 
	cp a,#TK_QSTR
	jrne 2$   
	call dpop  
	call puts 
	jra reset_comma
2$: cp a,#TK_CHAR 
	jrne 3$
	call dpop 
	ld a,xl 
	call putc 
	jra reset_comma 
3$: 	
	cp a,#TK_FUNC 
	jrne 4$ 
	call execute
	call prt_tos 
	jra reset_comma 
4$: cp a,#TK_COMMA 
	jrne 5$
	call ddrop 
	ld a,#1 
	ld (COMMA,sp),a 
	jra prt_loop   
5$: cp a,#TK_SHARP
	jrne 7$
	call ddrop   
	call get_token
	cp a,#TK_INTGR 
	jreq 6$
	jp syntax_error 
6$:	call dpop 
	ld a,xl 
	and a,#15 
	ld tab_width,a 
	jp reset_comma 
7$:	call unget_token
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
	call dpop
	call puts 
	cpl (SKIP,sp)
	call get_token 
1$: cp a,#TK_VAR  
	jreq 2$ 
	jp syntax_error
2$:	
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
	jrne 4$
	jra input_loop 
4$:	call unget_token 
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
	clr a 
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
	call arg_list 
	cp a,#2
	jruge 0$
	jp syntax_error 
0$:	cp a,#3
	jrult 1$
	call dpop 
	ld a,xl
	ld (XMASK,sp),a 
1$: call dpop ; mask 
	ld a,xl 
	ld (MASK,sp),a 
	call dpop ; address 
2$:	ld a,(x)
	and a,(MASK,sp)
	xor a,(XMASK,sp)
	jreq 2$ 
	_drop VSIZE 
	clr a 
	ret 

;---------------------
; BASIC: BSET addr,mask
; set bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask        mask|addr
; output:
;	none 
;--------------------------
bit_set:
	call arg_list 
	cp a,#2	 
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
; BASIC: BRES addr,mask
; reset bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask	    ~mask&*addr  
; output:
;	none 
;--------------------------
bit_reset:
	call arg_list 
	cp a,#2  
	jreq 1$ 
	jp syntax_error
1$: 
	call dpop ; mask 
	ld a,xl 
	cpl a 
	call dpop ; addr  
	and a,(x)
	ld (x),a 
	clr a 
	ret 

;---------------------
; BASIC: BRES addr,mask
; toggle bits at 'addr' corresponding 
; to those of 'mask' that are at 1.
; arguments:
; 	addr 		memory address RAM|PERIPHERAL 
;   mask	    mask^*addr  
; output:
;	none 
;--------------------------
bit_toggle:
	call arg_list 
	cp a,#2 
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
; BASIC: POKE addr,byte
; put a byte at addr 
;--------------------
poke:
	call arg_list 
	cp a,#2
	jreq 1$
	jp syntax_error
1$:	
	call dpop 
    ld a,xl 
	call dpop 
	ld (x),a 
	clr a 
	ret 

;-----------------------
; BASIC: PEEK(addr)
; get the byte at addr 
; input:
;	none 
; output:
;	X 		value 
;-----------------------
peek:
	ld a,#TK_LPAREN 
	call expect 
	call ddrop 
	call arg_list
	cp a,#1 
	jreq 1$
	jp syntax_error
1$:	ld a,#TK_RPAREN 
	call expect 
	call ddrop  
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
	jrne 9$  
;skip to next line
	mov in,count
	clr untok 
9$:	ret 

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
	call let02 
; leave with variable addr on dstack 		
	bset flags,#FFOR 
	call get_token 
	cp a,#TK_CMD 
	jreq 1$
	jp syntax_error
1$:  
	call dpop 
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
	cp a,#TK_CMD
	jrne 3$
	call dpop 
	cpw x,#step 
	jreq step 
3$:	 
	call unget_token 
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
; cstack 2 call deep from interp_loop
; we must copy those 2 return address on
; top of cstack 
store_loop_addr:
	_vars 4 ; reserve 4 bytes 
; move return address on top 	
	ldw x,(5,sp)
	ldw (1,sp),x
	ldw x,(7,sp)
	ldw (3,sp),x  
	ldw x,basicptr  
	ldw (7,sp),x 
	ldw x,in.w 
	ldw (5,sp),x   
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
	IN=5
	BPTR=7
next: ; {var limit step -- [var limit step ] }
	tnz loop_depth 
	jrne 1$ 
	jp syntax_error 
1$: ld a,#TK_VAR 
	call expect
; check for good variable after NEXT 	 
	ldw y,x 
	ldw x,#4  
	cpw y,([dstkptr],x) ; compare variables address 
	jreq 2$  
	jp syntax_error ; not the good one 
2$: ; increment variable 
	ldw x,y
	ldw x,(x)  ; get var value 
	ldw acc16,x 
	ldw x,[dstkptr] ; step
	addw x,acc16 ; var+step 
	ldw (y),x ; save var new value 
; compare with limit 
	ldw y,x 
	ldw x,[dstkptr] ; step in x 
	tnzw x  
	jrpl 4$ ; positive step 
;negative step 
	ldw x,#2
	cpw y,([dstkptr],x)
	jrslt loop_done
	jra loop_back 
4$: ; positive step
	ldw x,#2 
	cpw y,([dstkptr],x)
	jrsgt loop_done
loop_back:
	ldw x,(BPTR,sp)
	ldw basicptr,x 
	btjf flags,#FRUN,1$ 
	ld a,(2,x)
	add a,#2 
	ld count,a
	ldw x,(x)
	ldw lineno,x
1$:	ldw x,(IN,sp)
	ldw in.w,x 
	clr a 
	ret 
loop_done:
	; remove var limit step on dstack 
	ldw x,dstkptr 
	addw x,#3*CELL_SIZE
	ldw dstkptr,x 
	; remove 2 return address on cstack 
	ldw x,(1,sp)
	ldw y,(3,sp)
	_drop 4 
	ldw (1,sp),x
	ldw (3,sp),y 
	dec loop_depth 
	clr a 
	ret 


;------------------------
; BASIC: GOTO lineno 
; jump to lineno 
; here cstack is 2 call deep from interp_loop 
;------------------------
goto:
	btjt flags,#FRUN,0$ 
	ld a,#ERR_RUN_ONLY
	jp tb_error 
	ret 
0$:	_drop 4 ; drop 2 return address 
	jra go_common

;--------------------
; BASIC: GOSUB lineno
; basic subroutine call
; actual lineno and basicptr 
; are saved on cstack
; here cstack is 2 call deep from interp_loop 
;--------------------
gosub:
	btjt flags,#FRUN,0$ 
	ld a,#ERR_RUN_ONLY
	jp tb_error 
	ret 
0$:	ldw x,basicptr
	ld a,(2,x)
	add a,#3 
	ld acc8,a 
	clr acc16 
	addw x,acc16
	_drop 2  ; drop 1 return address  
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
; cstack is 2 level deep from interp_loop 
;------------------------
return:
	btjt flags,#FRUN,0$ 
	ld a,#ERR_RUN_ONLY
	jp tb_error 
0$:	_drop 4 ; drop return address  
	ldw x,(1,sp) 
	ldw basicptr,x 
	ld a,(2,x)
	add a,#3 
	ld count,a 
	mov in,#3 
	clr a 
	jp interp_loop 


;----------------------------------
; BASIC: RUN
; run BASIC program in RAM
;----------------------------------- 
run: 
	btjf flags,#FRUN,0$  
	clr a 
	ret
0$: 
	ldw x,txtbgn
	cpw x,txtend 
	jrmi 1$ 
	clr a 
	ret 
1$: call ubound 
	_drop 2 
	ldw x,txtbgn 
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
	call clear_basic 
	clr a 
	ret 
	 
;--------------------
; input:
;   X     increment 
; output:
;   farptr  incremented 
;---------------------
incr_farptr:
	addw x,farptr+1 
	jrnc 1$
	inc farptr 
1$:	ldw farptr+1,x  
	ret 

;------------------------------
; extended flash memory used as FLASH_DRIVE 
; seek end of used flash drive   
; starting at 0x10000 address.
; 4 consecutives 0 bytes signal free space. 
; input:
;	none
; output:
;   ffree     free_addr| 0 if memory full.
;------------------------------
seek_fdrive:
	ld a,#1
	ld farptr,a 
	clrw x 
	ldw farptr+1,x 
1$:
	clrw x 
	ldf a,([farptr],x) 
	jrne 2$
	incw x 
	ldf a,([farptr],x)
	jrne 2$ 
	incw x 
	ldf a,([farptr],x)
	jrne 2$ 
	incw x 
	ldf a,([farptr],x)
	jreq 4$ 
2$: 
	addw x,#1
	call incr_farptr
	ldw x,#0x27f 
	cpw x,farptr
	jrpl 1$
	clr ffree 
	clr ffree+1 
	clr ffree+2 
	clr acc24 
	clr acc16
	clr acc8 
	jra 5$
4$: ; copy farptr to ffree	 
	ldw x,farptr+1 
	cpw x,#fdrive 
	jreq 41$
	; there is a file, last 0 of that file must be skipped.
	ldw x,#1
	call incr_farptr
41$: 
	ldw x,farptr 
	ld a,farptr+2 
	ldw ffree,x 
	ld ffree+2,a  
	ldw acc24,x 
	ld acc8,a 
5$:	ldw x,ffree_msg 
	call puts 
	clrw x 
	ld a,#16
	call prti24 
	ld a,#CR 
	call putc 
	ret 
ffree_msg: .asciz "\nfree flash begin at: "

;-----------------------
; compare file name 
; with name pointed by Y  
; input:
;   farptr   file name 
;   Y        target name 
; output:
;   farptr 	 at file_name
;   X 		 farptr[x] point at size field  
;   Carry    0|1 no match|match  
;----------------------
cmp_name:
	clrw x
1$:	ldf a,([farptr],x)
	cp a,(y)
	jrne 4$
	tnz a 
	jreq 9$ 
    incw x 
	incw y 
	jra 1$
4$: ;no match 
	tnz a 
	jreq 5$
	incw x 
	ldf a,([farptr],x)
	jra 4$  
5$:	incw x ; farptr[x] point at 'size' field 
	rcf 
	ret
9$: ; match  
	incw x  ; farptr[x] at 'size' field 
	scf 
	ret 

;-----------------------
; search file in 
; flash memory 
; input:
;   Y       file name  
; output:
;   farptr  addr at name|0
;-----------------------
	FSIZE=1
	YSAVE=3
	VSIZE=4 
search_file: 
	_vars VSIZE
	ldw (YSAVE,sp),y  
	clrw x 
	ldw farptr+1,x 
	mov farptr,#1
1$:	
; check if farptr is after any file 
; if  0 then so.
	ldf a,[farptr]
	jreq 6$
2$: clrw x 	
	ldw y,(YSAVE,sp) 
	call cmp_name
	jrc 9$
	ldf a,([farptr],x)
	ld (FSIZE,sp),a 
	incw x 
	ldf a,([farptr],x)
	ld (FSIZE+1,sp),a 
	incw x 
	addw x,(FSIZE,sp) ; count to skip 
	call incr_farptr ; now at next file 'name_field'
	ldw x,#0x280
	cpw x,farptr 
	jrpl 1$
6$: ; file not found 
	clr farptr
	clr farptr+1 
	clr farptr+2 
	_drop VSIZE 
	rcf
	ret
9$: ; file found  farptr[0] at 'name_field',farptr[x] at 'file_size' 
	_drop VSIZE 
	scf 	
	ret

;--------------------------------
; BASIC: SAVE "name" 
; save text program in 
; flash memory used as 
;--------------------------------
save:
	btjf flags,#FRUN,0$ 
	ld a,#ERR_CMD_ONLY 
	jp tb_error
0$:	 
	ldw x,txtend 
	subw x,txtbgn
	jrne 10$
; nothing to save 
	clr a 
	ret 
10$:	
	ld a,ffree 
	or a,ffree+1
	or a,ffree+2 
	jrne 1$
	ld a,#ERR_MEM_FULL
	jp tb_error 
1$: call get_token	
	cp a,#TK_QSTR
	jreq 2$
	jp syntax_error
2$: ; check for existing file of that name 
	ldw y,tokval ; file name pointer 
	call search_file 
	jrnc 3$ 
	ld a,#ERR_DUPLICATE 
	jp tb_error 
3$:	;** write file name to flash **
	ldw x,ffree 
	ld a,ffree+2 
	ldw farptr,x 
	ld farptr+2,a 
	ldw x,tokval 
	call strlen 
	incw  x
	pushw x 
	clrw x   
	ldw y,tokval 
	call write_block  
	_drop 2 ; drop pushed X 
;** write file length after name **
	ldw x,txtend 
	subw x,txtbgn
	pushw x ; file size 
	clrw x 
	ld a,(1,sp)
	call write_byte 
	incw x 
	ld a,(2,sp)
	call write_byte
	incw x  
	call incr_farptr ; move farptr after SIZE field 
;** write BASIC text **
; copy BSIZE, cstack:{... bsize -- ... bsize bsize }	
	ldw x,(1,sp)
	pushw x 
	clrw x 
	ldw y,txtbgn  ; BASIC text to save 
	call write_block 
	_drop 2 ;  drop BSIZE argument
; save farptr in ffree
	ldw x,farptr 
	ld a,farptr+2 
	ldw ffree,x 
	ld ffree+2,a
; write 4 zero bytes as a safe gard 
    clrw x 
	clr a 
	call write_byte 
	incw x 
	clr a 
	call write_byte
	incw x 
	clr a 
	call write_byte
; display saved size  
	popw x ; first copy of BSIZE 
	ld a,#TK_INTGR 
	ret 


;------------------------
; BASIC: LOAD "file" 
; load file to RAM 
; for execution 
;------------------------
load:
	btjf flags,#FRUN,0$ 
	jreq 0$ 
	ld a,#ERR_CMD_ONLY 
	jp tb_error 
0$:	
	call get_token 
	cp a,#TK_QSTR
	jreq 1$
	jp syntax_error 
1$:	
	call dpop 
	ldw y,x 
	call search_file 
	jrc 2$ 
	ld a,#ERR_NOT_FILE
	jp tb_error  
2$:	
	call incr_farptr  
	call clear_basic  
	clrw x
	ldf a,([farptr],x)
	ld yh,a 
	incw x  
	ldf a,([farptr],x)
	incw x 
	ld yl,a 
	addw y,txtbgn
	ldw txtend,y
	ldw y,txtbgn
3$:	; load BASIC text 	
	ldf a,([farptr],x)
	ld (y),a 
	incw x 
	incw y 
	cpw y,txtend 
	jrmi 3$
; return loaded size 	 
	ldw x,txtend 
	subw x,txtbgn
	call dpush 
	call prt_tos 
	clr a  
	ret 

;-----------------------------------
; BASIC: FORGET ["file_name"] 
; erase file_name and all others 
; after it. 
; without argument erase all files 
;-----------------------------------
forget:
	call get_token 
	cp a,#TK_NONE 
	jreq 3$ 
	cp a,#TK_QSTR
	jreq 1$
	jp syntax_error
1$: ldw y,tokval 
	call search_file
	jrc 2$
	ld a,#ERR_NOT_FILE 
	jp tb_error 
2$: 
	ldw x,farptr
	ld a,farptr+2
	jra 4$ 
3$: ; forget all files 
	ldw x,#fdrive
	clr a 
	rrwa x 
	ldw farptr,x 
	ld farptr+2,a 
4$:
	ldw ffree,x 
	ld ffree+2,a 
5$:	clrw x 
	clr a  
	call write_byte 
	ldw x,#1 
	call incr_farptr
	ld a,farptr
	cp a,ffree 
	jrmi 5$ 
	ldw x,farptr+1 
	cpw x,ffree+1
	jrmi 5$
	ret 

;----------------------
; BASIC: DIR 
; list saved files 
;----------------------
	COUNT=1 ; files counter 
	VSIZE=2 
directory:
	_vars VSIZE 
	clrw x 
	ldw (COUNT,sp),x 
	ldw farptr+1,x 
	mov farptr,#1 
dir_loop:
	clrw x 
	ldf a,([farptr],x)
	jreq 8$ 
1$: ;name loop 	
	ldf a,([farptr],x)
	jreq 2$ 
	call putc 
	incw x 
	jra 1$
2$: incw x ; skip ending 0. 
	ld a,#SPACE 
	call putc 
; get file size 	
	ldf a,([farptr],x)
	ld yh,a 
	incw x 
	ldf a,([farptr],x)
	incw x 
	ld yl,a 
	pushw y 
	addw x,(1,sp)
	call incr_farptr 
	popw x ; file size 
	call dpush 
	call prt_tos 
	ld a,#CR 
	call putc
	ldw x,(COUNT,sp)
	incw x
	ldw (COUNT,sp),x  
	jra dir_loop 
8$:
	ldw x,(COUNT,sp)
	call dpush 
	call prt_tos
	ldw x,#file_count 
	call puts  
	_drop VSIZE 
	ret
file_count: .asciz " files\n"

;---------------------
; BASIC: WRITE expr1,expr2 
; write byte to FLASH or EEPROM 
; input:
;   expr1  	is address 
;   expr2   is byte to write
; output:
;   none 
;---------------------
write:
	clr farptr ; expect 16 bits address 
	call arg_list  
	cp a,#2
	jreq 1$
	jp syntax_error
1$:
	call dpop 
	ld a,xl 
	call dpop 
	ldw farptr+1,x 
	clrw x 
	call write_byte 
	ret 


;---------------------
;BASIC: CHAR(expr)
; évaluate expression 
; and take the 7 least 
; bits as ASCII character
;---------------------
char:
	ld a,#TK_LPAREN 
	call expect 
	call relation 
	cp a,#TK_INTGR 
	jreq 1$
	jp syntax_error
1$:	
	ld a,#TK_RPAREN 
	call expect
	call dpop 
	ld a,xl 
	and a,#0x7f 
	ld xl,a
	ldw tokval,x  
	ld a,#TK_CHAR
	ret

;---------------------
; BASIC: ASC(string|char)
; extract first character 
; of string argument 
; return it as TK_INTGR 
;---------------------
ascii:
	ld a,#TK_LPAREN
	call expect 
	call get_token 
	cp a,#TK_QSTR 
	jreq 1$
	cp a,#TK_CHAR 
	jreq 2$ 
	jp syntax_error
1$: ldw x,tokval 
	ld a,(x)
	jra 3$
2$: ldw x,tokval
	ld a,xl 
3$:	clrw x 
	ld xl,a 
	call dpush 
	ld a,#TK_RPAREN 
	call expect 
	call dpop  
	ldw tokval,x 
	ld a,#TK_INTGR 
	ret 

;---------------------
;BASIC: KEY
; wait for a character 
; received from STDIN 
; input:
;	none 
; output:
;	X 		ASCII character 
;---------------------
key:
	call getc 
	clrw x 
	ld xl,a 
	ldw tokval,x 
	ld a,#TK_INTGR
	ret

;----------------------
; BASIC: QKEY
; Return true if there 
; is a character in 
; waiting in STDIN 
; input:
;  none 
; output:
;   X 		0|1 
;-----------------------
qkey: 
	clrw x 
	btjf UART3_SR,#UART_SR_RXNE,9$ 
	incw x 
9$: ld a,#TK_INTGR
	ret 

;---------------------
; BASIC: GPIO(expr,reg)
; return gpio address 
; expr {0..8}
; input:
;   none 
; output:
;   X 		gpio register address
;----------------------------
gpio:
	ld a,#TK_LPAREN 
	call expect 
	call arg_list
	cp a,#2
	jreq 1$
	jp syntax_error  
1$:	
	ld a,#TK_RPAREN 
	call expect 
	call dpop
	pushw x 
	call dpop 
	tnzw x 
	jrmi bad_port
	cpw x,#9
	jrpl bad_port
	ld a,#5
	mul x,a
	addw x,#GPIO_BASE 
	addw x,(1,sp)
	_drop 2 
	ld a,#TK_INTGR
	ret
bad_port:
	ld a,#ERR_BAD_VALUE
	jp tb_error

;----------------------
; BASIC: ODR 
; return offset of gpio
; ODR register: 0
; ---------------------
port_odr:
	clrw x 
	ldw tokval,x 
	ld a,#TK_INTGR
	ret

;----------------------
; BASIC: IDR 
; return offset of gpio
; IDR register: 1
; ---------------------
port_idr:
	ldw x,#1
	ldw tokval,x 
	ld a,#TK_INTGR
	ret

;----------------------
; BASIC: DDR 
; return offset of gpio
; DDR register: 2
; ---------------------
port_ddr:
	ldw x,#2
	ldw tokval,x 
	ld a,#TK_INTGR
	ret

;----------------------
; BASIC: CRL  
; return offset of gpio
; CR1 register: 3
; ---------------------
port_cr1:
	ldw x,#3
	ldw tokval,x 
	ld a,#TK_INTGR
	ret

;----------------------
; BASIC: CRH  
; return offset of gpio
; CR2 register: 4
; ---------------------
port_cr2:
	ldw x,#4
	ldw tokval,x 
	ld a,#TK_INTGR
	ret


;---------------------
;
;---------------------
usr:
	ldw x,#USR 
	call prt_cstr 
	ret 

;------------------------------
; BASIC: BYE 
; halt mcu in its lowest power mode 
; wait for reset or external interrupt
; do a cold start on wakeup.
;------------------------------
bye:
	btjf UART3_SR,#UART_SR_TC,.
	halt
	jp cold_start  

;----------------------------------
; BASIC: SLEEP 
; halt mcu until reset or external
; interrupt.
; Resume progam after SLEEP command
;----------------------------------
sleep:
	btjf UART3_SR,#UART_SR_TC,.
	bset flags,#FSLEEP
	halt 
	ret 

;-------------------------------
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
0$: call dpop 	
1$: tnzw x 
	jreq 2$
	wfi 
	decw x 
	jrne 1$
2$:	clr a 
	ret 

;------------------------------
; BASIC: TICKS
; return msec ticks counter value 
; input:
; 	none 
; output:
;	X 		TK_INTGR
;-------------------------------
get_ticks:
	ldw x,ticks 
	ld a,#TK_INTGR
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
	ld a,#TK_LPAREN
	call expect 
	call arg_list
	cp a,#1 
	jreq 0$ 
	jp syntax_error
0$: ld a,#TK_RPAREN 
	call expect 
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
	ld a,#TK_LPAREN 
	call expect 
	call arg_list 
	cp a,#1
	jreq 1$
	jp syntax_error
1$: ld a,#TK_RPAREN
	call expect 
	call dpop 
	pushw x 
	ld a,xh 
	bcp a,#0x80 
	jreq 2$
	ld a,#ERR_BAD_VALUE
	jp tb_error
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

;*********************************

;------------------------------
;      dictionary 
; format:
;   link   2 bytes 
;   cmd_name 8 byte max 
;   code_address 2 bytes 
;------------------------------
	FFUNC=128 
	.macro _dict_entry len,name,cmd 
	.word LINK 
	LINK=.
name:
	.byte len 	
	.ascii "name"
	.word cmd 
	.endm 

	LINK=0
kword_end:
	_dict_entry,3,BYE,bye 
	_dict_entry,5,SLEEP,sleep 
	_dict_entry,6,FORGET,forget 
	_dict_entry,3,DIR,directory 
	_dict_entry,4,LOAD,load 
	_dict_entry,4,SAVE,save
	_dict_entry,5,WRITE,write  
	_dict_entry,3,NEW,new
	_dict_entry,4,STOP,stop 
    _dict_entry,4,SHOW,dots
	_dict_entry 3,RUN,run
	_dict_entry 4,LIST,list
	_dict_entry,3,USR,usr
	_dict_entry,3+FFUNC,ODR,port_odr
	_dict_entry,3+FFUNC,IDR,port_idr
	_dict_entry,3+FFUNC,DDR,port_ddr 
	_dict_entry,3+FFUNC,CRL,port_cr1 
	_dict_entry,3+FFUNC,CRH,port_cr2
	_dict_entry,4+FFUNC,GPIO,gpio 
	_dict_entry,3+FFUNC,ASC,ascii  
	_dict_entry,4+FFUNC,CHAR,char
	_dict_entry,4+FFUNC,QKEY,qkey  
	_dict_entry,3+FFUNC,KEY,key 
	_dict_entry,4+FFUNC,SIZE,size
	_dict_entry,3,HEX,hex_base
	_dict_entry,3,DEC,dec_base
	_dict_entry,5+FFUNC,TICKS,get_ticks
	_dict_entry,3+FFUNC,ABS,abs
	_dict_entry,3+FFUNC,RND,random 
	_dict_entry,5,PAUSE,pause 
	_dict_entry,4,BSET,bit_set 
	_dict_entry,4,BRES,bit_reset
	_dict_entry,5,BTOGL,bit_toggle
	_dict_entry 4,WAIT,wait 
	_dict_entry 6,REMARK,rem 
	_dict_entry 5,PRINT,print 
	_dict_entry,2,IF,if 
	_dict_entry,5,GOSUB,gosub 
	_dict_entry,4,GOTO,goto 
	_dict_entry,3,FOR,for 
	_dict_entry,2,TO,to
	_dict_entry,4,STEP,step 
	_dict_entry,4,NEXT,next 
	_dict_entry,6+FFUNC,UBOUND,ubound 
	_dict_entry,6,RETURN,return 
	_dict_entry,4+FFUNC,PEEK,peek 
	_dict_entry,4,POKE,poke 
	_dict_entry,5,INPUT,input_var  
kword_dict:
	_dict_entry 3,LET,let 
	

	.bndry 128 ; align on FLASH block.
; free space for user application  
user_space:

	.area FLASH_DRIVE (ABS)
	.org 0x10000
fdrive:
