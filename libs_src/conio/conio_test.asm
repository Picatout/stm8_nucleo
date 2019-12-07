

    .module CONIO_TEST
    .nlist
    .include "../../inc/nucleo_8s208.inc"
    .include "../../inc/stm8s208.inc"
    .include "../../inc/ascii.inc"
    .list 

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

        .macro _drop n 
        addw sp,#n 
        .endm 

    .area DATA 
    TIB_SIZE=80
    PAD_SIZE=80 
tib:  .ds TIB_SIZE 
pad:  .ds PAD_SIZE
acc24: .blkb 1
acc16: .blkb 1
acc8:  .blkb 1

    .area SSEG (ABS)
    STACK_SIZE=256 
    .org RAM_SIZE-STACK_SIZE
    .ds STACK_SIZE 

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


    .area CODE

NonHandledInterrupt:
    .byte 0x71  ; réinitialize le MCU


;------------------------------------
; gestionnaire pour l'instrcution trap 
;------------------------------------
TrapHandler:
	call print_registers
	iret

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



	;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

init0:
    ldw x,#RAM_SIZE-1
    ldw sp,x 
    call clock_init 
    push #UART3
    push #B115200
    call conio_init
    ldw x,#conio_test 
    pushw x 
    trap 
    call puts
    trap 
    _drop 2 
0$: 
    call getchar 
    pushw x
    call putchar
    _drop 2
    jra 0$

conio_test: .asciz "\nconio test\n" 