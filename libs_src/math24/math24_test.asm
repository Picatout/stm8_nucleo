; test pour librairie math24.lib 


    .module MATH24_TEST
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

    PAD_SIZE=80
    .area DATA
acc24: .blkb 1
acc16: .blkb 1
acc8:  .blkb 1
pad:   .ds PAD_SIZE 

    .area SSEG (ABS)
    STACK_SIZE=256 
    .org RAM_SIZE-STACK_SIZE
    .ds STACK_SIZE 

    .area HOME 
    INT init0
    INT exception
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

div_fatal: .asciz "fatal: division par zero\n"

exception:
    tnz a 
    jrne 1$
    ldw x,#div_fatal
    ld a,#UART3 
    push a 
    pushw x 
    call uart_puts 
    addw sp,#3
1$: jra .
    iret 


	;initialize clock to use HSE 8 Mhz crystal
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
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
	ld a,acc8
    ldw x,acc24 
    call neg24
    ld acc8,a 
    ldw acc24,x 
1$: 
; initialize string pointer 
	ldw y,#pad+PAD_SIZE-1
	clr (y)
    decw y 
    ld a,#SPACE 
    ld (y),a  
itoa_loop:  
    ld a,(BASE,sp)
    push a 
    ld a,acc8 
    ldw x,acc24 
    push a 
    pushw x 
    call div24_8u ; acc24/base
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: 
    decw y
    ld (y),a
    popw x
    ldw acc24,x 
    pop a 
    ld acc8,a 
    addw sp,#1
	; if acc24==0 conversion done
	or a,acc24
	or a,acc16 
    jrne itoa_loop
	;conversion done, next add '$' or '-' as required
	ld a,(BASE,sp)
	cp a,#16
	jrne 8$
    ld a,#'$
    decw y 
    ld (y),a 
    jra 10$
8$: ld a,(SIGN,sp)
    jreq 10$
    decw y
    ld a,#'-
    ld (y),a
10$:
	addw sp,#LOCAL_SIZE
	ret

; input:
;   X:A     uint24
print_uint24:
    push a 
    pushw x 
    pushw y 
    ld acc8,a 
    ldw acc24,x 
    ld a,#16 
    call itoa 
    ld a,#UART3 
    push a 
    pushw y
    call uart_puts
    addw sp,#3     
    popw y 
    popw x 
    pop a 
    ret 

new_line:
    push a 
    pushw x 
    ld a,#UART3
    push a 
    ld a,#CR 
    push a 
    call uart_putc 
    addw sp,#2
    pop a 
    popw x 
    ret 

;-----------------
; input:
;   x   string to print 
;----------------------
print_fn_name:
    push a 
    ld a,#UART3
    push a 
    pushw x 
    call uart_puts 
    addw sp,#3
    pop a 
    ret 


init0:
    ldw x,#RAM_SIZE-1
    ldw sp,x 
    call clock_init
; initialize UART3    
    ld a,#UART3 
    push a 
    ld a,#B115200
    push a 
    call uart_init
    SEND_OK=0
    addw sp,#2  
    
    IDX_ERR_SUM=0
    IDX_ERR_SUB=1 
    IDX_ERR_MUL=2
    IDX_ERR_DIV=3
    IDX_ERR_NEG=4

presentation:
    ld a,#UART3
    ldw x,#whatisit
    push a 
    pushw x 
    call uart_puts 
    addw sp,#3
add_test:
    sub sp,#6 ; espace pour les arguments test fonctions 
    ldw x,#add24_test
    call print_fn_name
    ld a,#0x55 
    ldw x,#0x5555
    call print_uint24
    ld (3,sp),a 
    ldw (1,sp),x 
    ld a,#0xaa
    ldw x,#0xaaaa
    call print_uint24 
    ldw (4,sp),x 
    ld (6,sp),a 
    call add24
    ; sum dans X:A
    call print_uint24 
    cp a,#0xff 
    jreq 1$
0$: clr a
    jp print_error
1$: cpw x,#0xffff
    jrne 0$    
sub_test:
    ldw (1,sp),x 
    ld (3,sp),a 
    ldw x,#sub24_test
    call print_fn_name
    ldw x,(1,sp)
    call print_uint24
    ld a,#0xaa
    ldw x,#0xaaaa
    call print_uint24
    ldw (4,sp),x 
    ld (6,sp),a 
    call sub24
    call print_uint24 
    cp a,#0x55
    jreq 1$
0$: ld a,#IDX_ERR_SUB
    jp print_error 
1$: cpw x,#0x5555
    jreq mul_test
    jra 0$    
mul_test: ; mul24_8u -> uint24_t * uint8_t 
    ldw x,#mul24_8u_test
    call print_fn_name    
    ld a,#0x99
    ldw x,#0x1999
    call print_uint24
    ld (3,sp),a
    ldw (1,sp),x 
    ld a,#10
    ld (4,sp),a 
    clrw x
    call print_uint24
    call mul24_8u 
    call print_uint24 
    cp a,#0xfa 
    jreq 1$
0$: ld a,#IDX_ERR_MUL
    jp print_error 
1$: cpw x,#0xffff
    jrne 0$
mul_test2: ; mul24u 
    ldw x,#mul24u_test
    call print_fn_name
    ld a,#0x99
    ldw x,#0x1999
    ldw (1,sp),x 
    ld (3,sp),a 
    call print_uint24
    ld a,#10
    clrw x 
    ldw (4,sp),x 
    ld (6,sp),a 
    call print_uint24
    call mul24u 
    call print_uint24 
    cp a,#0xfa 
    jreq 1$
0$: ld a,#IDX_ERR_MUL
    jra print_error
1$: cpw x,#0xffff
    jrne 0$
div_test: ; div24u 
    pushw x 
    ldw x,#div24u_test
    call print_fn_name 
    popw x 
    call print_uint24
    ldw (1,sp),x 
    ld (3,sp),a 
    ld a,#10
    clrw x  
    call print_uint24
    ld (6,sp),a 
    ldw (4,sp),x 
    call div24u
    call print_uint24
    cp a,0x99
    jreq 1$
0$: ld a,#IDX_ERR_DIV
    jra print_error
1$: cpw x,#0x1999 
    jrne 0$
    ld a,yl
    cp a,#5
    jrne 0$    
neg_test:
    call new_line 
    ld a,0xaa
    ldw x,#0xaaaa
    call print_uint24
    call neg24
    call print_uint24 
    cp a,#0x55
    jreq 1$
0$: ld a,#IDX_ERR_NEG
    jra print_error 
1$: cpw x,#0x5556    
    jrne 0$
; tous les test ont passé avec succès.
    addw sp,#6
    ldw x,#test_ok
    ld a,#UART3
    push a 
    pushw x 
    call uart_puts 
    addw sp,#3 
    jra .

print_error:
    ldw x,#msg_erreur
    clrw y
    sll a 
    ld yl,a
    pushw y 
    addw x,(1,sp)
    popw y  
    ldw x,(x)
    ld a,#UART3
    push a 
    pushw x 
    call uart_puts
    addw sp,#3
    jra .


msg_erreur: .word erreur_add,erreur_sub,erreur_mul,erreur_div,erreur_neg

erreur_add: .asciz "erreur somme\n"
erreur_sub: .asciz "erreur sub\n"
erreur_mul: .asciz "erreur mult\n"
erreur_div: .asciz "erreur div\n"
erreur_neg: .asciz "erreur neg\n"

test_ok: .asciz "tests ok\n"
whatisit: .asciz "\nTest pour la librairie math24.\n"
add24_test: .asciz "\nadd24: "
sub24_test: .asciz "\nsub24: "
mul24_8u_test: .asciz "\nmul24_8u: " 
mul24u_test: .asciz "\nmul24u: "
div24_8u_test: .asciz "\ndiv24_8u: "
div24u_test: .asciz "\ndiv24u: "
neg24_test: .asciz "\nneg24: "

