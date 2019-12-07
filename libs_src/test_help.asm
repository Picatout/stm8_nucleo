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
;   commands P1,P2,P3  can be used to see content 
;   of a specific memory location.
;   ex.  p1 $105   to see byt at this address.
;   p2 is for word 
;   p3 is for 24 bits value
;
;   leave trap handler with 'q' command to resume
;   application under test.
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

;------------------------------------
;       MACROS
;------------------------------------
    ;release local variables space
    ;from stack.
    .macro _drop n 
    addw sp,#n
    .endm

    ; reserve local variables space 
    ; on stack.
    .macro _vars n 
    sub sp,#n 
    .endm

    ; insert function exit code
    .macro _fn_exit 
    _drop VSIZE 
    ret 
    .endm 

    
    .macro  _int_enable ; enable interrupts
        rim
    .endm
    
    .macro _int_disable ; disable interrupts
    sim
    .endm

    .area DATA 
    TIB_SIZE=80
    PAD_SIZE=40 
tib:  .ds TIB_SIZE 
pad:  .ds PAD_SIZE
acc24: .blkb 1
acc16: .blkb 1
acc8:  .blkb 1

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
ledoff:
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
	call trap_puts
; print EPC 
	ldw y, #REG_EPC
	call trap_puts 
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
	call trap_puts 
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
	call trap_puts  
	ld a,(6,sp)
	ld acc8,a 
	ld a,(5,sp)
	ld acc16,a 
	ld a,#16 
    clrw x
	call print_int 
; print A 
	ldw y,#REG_A 
	call trap_puts 
	clr acc16
	ld a, (4,sp) 
	ld acc8,a 
	ld a,#16
    clrw x 
	call print_int 
; print CC 
	ldw y,#REG_CC 
	call trap_puts 
	ld a, (3,sp) 
	ld acc8,a
	ld a,#16
    clrw x   
	call print_int 
	ld a,#'\n' 
	call trap_putc  
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
4$: call trap_puts 
    ld a,#SPACE 
	call trap_putc 
    addw sp,#LOCAL_SIZE 
	popw y 
    ret	

trap_putc:
    push #UART3
    push a 
    call uart_putc 
    _drop 2 
    ret 

trap_puts:
    push #UART3 
    pushw y 
    call uart_puts 
    _drop 3 
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




