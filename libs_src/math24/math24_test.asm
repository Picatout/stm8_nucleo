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
    TIB_SIZE=80

    .area DATA
acc24: .blkb 1
acc16: .blkb 1
acc8:  .blkb 1
pad:   .ds PAD_SIZE 
in.w:  .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
in:		.blkb 1; parser position in tib
count:  .blkb 1; length of string in tib
tib:	.blkb TIB_SIZE ; transaction input buffer

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

div_fatal: .asciz "errer fatale: division par zero\n"

exception:
    tnz a 
    jrne 1$
    ldw y,#div_fatal
    call puts 
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

;------------------------
; input:
;   X:A     int24
; output:
;   none 
;------------------------
print_int24:
    push a 
    pushw x 
    pushw y 
    ld acc8,a 
    ldw acc24,x 
    ld a,#10
    call itoa 
    call puts
    popw y 
    popw x 
    pop a 
    ret 

    ARG_OFS=2
    ARG1=ARG_OFS+1
    ARG2=ARG_OFS+4 
print_arguments:
    ldW x,(ARG1,sp)
    ld a,(ARG1+2,sp)
    call print_int24 
    ldW x,(ARG2,sp)
    ld a,(ARG2+2,sp)
    call print_int24 
    ld a,#'=
    call putc 
    ret 

new_line:
    push a 
    pushw x 
    ld a,#CR 
    call putc 
    pop a 
    popw x 
    ret 


;------------------------------------
; convert pad content in integer
; input:
;    pad		.asciz to convert
; output:
;    X:A      int24_t
;------------------------------------
	; local variables
	U24=1 ; 3 byte, utilisation temporaire pour la conversion
	BASE=4 ; 1 byte, base numérique utilisée pour la conversion
	SIGN=5 ; 1 byte, signe de l'entier
    LOCAL_SIZE=5 ; taille des variables locales 
atoi::
	pushw y ;save y
	sub sp,#LOCAL_SIZE
	clr (SIGN,sp)
	clr (U24,sp)    
	clr (U24+1,sp)
	clr (U24+2,sp)
	ld a, pad 
	jreq 9$
	ld a,#10
	ld (BASE,sp),a ; default base decimal
	ldw y,#pad ; pointer to string to convert
	ld a,(y)
	jreq 9$  ; completed if 0
	cp a,#'-
	jrne 1$
	cpl (SIGN,sp)
	jra 2$
1$: cp a,#'$
	jrne 3$
	ld a,#16
	ld (BASE,sp),a
; boucle de conversion    
2$:	incw y
	ld a,(y)
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
5$:	ld acc8,a
    call mul24_8u
    ld (U24+2,sp),a 
    ldw (U24,sp),x
    ld a,acc8 
    add a,(U24+2,sp)
    ld (U24+2,sp),a 
    clr a 
    adc a,(U24+1,sp)
    ld (U24+1,sp),a 
    clr a 
    adc a,(U24,sp)
    ld (U24,sp),a 
	jra 2$
9$:	ld a,(U24+2,sp)
    ldw x,(U24,sp)
    tnz (SIGN,sp)
    jreq atoi_exit
    call neg24 
atoi_exit: 
	addw sp,#LOCAL_SIZE
	popw y
	ret

;----------------------------------
; envoie un caractère via UART3 
; input:
;   A       charactère à envoyé.
; output:
;   none 
;----------------------------------
putc:
    sub sp,#2
    ld (1,sp),a 
    ld a,#UART3
    ld (2,sp),a 
    call uart_putc 
    addw sp,#2
    ret
;-----------------------------------
;  attend un caractère du UART3
;  input:
;       none 
;  output:
;    A      character reçu.
;-----------------------------------
getc:
    push #UART3 
    call uart_getc 
    addw sp,#1 
    ret 

    
;----------------------------------
; envoie une chaîne via UART3 
; input:
;   Y       ponteur chaîne
; output:
;   none 
;----------------------------------
puts:
    sub sp,#3
    ld a,#UART3 
    ld (3,sp),a 
    ldw (1,sp),y 
    call uart_puts 
    addw sp,#3
    ret

;------------------------------------
; read a line of text from terminal
; input:
;	none
; output:
;   text in tib  buffer
;   len in count variable
;------------------------------------
	; local variables
	RXCHAR = 1 ; last char received
    LEN = 2  ; accepted line length
    LOCAL_SIZE=2 
readln::
    sub sp,#LOCAL_SIZE 
	clr (RXCHAR,sp)  ; RXCHAR 
    clr (LEN,sp)  ; LEN
 	ldw y,#tib ; input buffer
readln_loop:
	call getc
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
	jrne 3$ 
    jp readln_quit
3$:	cp a,#BSP
	jreq del_back
	cp a,#CTRL_D
	jreq del_line
	cp a,#SPACE
	jrpl accept_char
	jra readln_loop
del_line:
    ld a,#UART3 
    push a 
	ld a,(LEN,sp)
    push a 
	call uart_delete
    addw sp,#2 
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
    ld a,#UART3
    push a 
    ld a,#1
    push a 
    call uart_delete
    addw sp,#2
    jra readln_loop	
accept_char:
	ld a,#TIB_SIZE-1
	cp a, (LEN,sp)
	jreq readln_loop
	ld a,(RXCHAR,sp)
	ld (y),a
	inc (LEN,sp)
	incw y
	clr (y)
	call putc 
	jra readln_loop
reprint:
	tnz (LEN,sp)
	jrne readln_loop
	tnz count
    jrne 4$
	jp readln_loop
4$:	ldw y,#tib
    pushw y
	call puts 
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
	call putc
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
;   X   pointer to tab 
; output:
;	pad   containt string 
;------------------------------------
	PREV = 1
parse_quote:
	clr a
	push a
1$:	ld (PREV,sp),a 
	inc in
	ld a,([in.w],y)
	jreq 4$
	push a
	ld a, (PREV,sp)
	cp a,#'\
	pop a 
	jrne 11$
	clr (PREV,sp)
	callr convert_escape
	ld (x),a 
	incw x 
	jra 1$
11$: 
	cp a,#'\'
	jrne 2$
	ld (PREV,sp),a 
	jra 1$
2$:	ld (x),a 
	incw x 
	cp a,#'"'
	jrne 1$
	inc in 
4$:	clr (x)
	pop a 
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
	cp a,#'"
	jrne 1$
	ld (x),a 
	incw x 
	call parse_quote
	jra 9$
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
    addw sp,#2  
    
    IDX_ERR_SUM=0
    IDX_ERR_SUB=1 
    IDX_ERR_MUL=2
    IDX_ERR_DIV=3
    IDX_ERR_NEG=4

presentation:
    ldw y,#whatisit
    call puts 
    clr in.w
repl:
; move terminal cursor to next line
	ld a,#NL 
	call putc 
; print prompt sign	 
	ld a,#'>
	call putc 
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

; arguments locales 
    N1=1
    N2=4
    OP=7
    LOCAL_SIZE=7  
eval:
    sub sp,#LOCAL_SIZE 
    call next_word 
    ld a,pad 
    ld (OP,sp),a
    call number
    ldw (N1,sp),x 
    ld (N1+2,sp),a 
    call number 
    ldw (N2,sp),x 
    ld (N2+2,sp),a  
    ld a,(OP,sp)
    cp a,#'+
    jrne 1$
    jp test_add
1$: cp a,#'- 
    jrne 2$ 
    jp test_sub 
2$: cp a,#'* 
    jrne 3$ 
    jp test_mul 
3$: cp a,#'/ 
    jrne 4$ 
    jp test_div 
4$:     
eval_exit:
    addw sp,#LOCAL_SIZE 
    ret 

test_add:
    ldw y,#add24_test
    call puts 
    call print_arguments
    call add24 
    call print_int24
    jp eval_exit
test_sub:
    ldw y,#sub24_test
    call puts 
    call print_arguments
    call sub24 
    call print_int24
    jp eval_exit
test_mul:
    ldw y,#mul24s_test
    call puts
    call print_arguments
    call mul24s 
    call print_int24
    jp eval_exit
test_div:
    ldw y,#div24s_test
    call puts
    call print_arguments
    call div24s 
    call print_int24
    ld a,#'R 
    call putc 
    ld a,#'=
    call putc 
    ldw x,(1,sp)
    ld a,(3,sp)
    call print_int24  
    jp eval_exit


print_error:
    ldw y,#msg_erreur
    clr acc16 
    sll a 
    ld acc8,a
    addw y,acc16 
    ldw y,(y)
    call puts
    jra .


msg_erreur: .word erreur_add,erreur_sub,erreur_mul,erreur_div,erreur_neg

erreur_add: .asciz "erreur somme\n"
erreur_sub: .asciz "erreur sub\n"
erreur_mul: .asciz "erreur mult\n"
erreur_div: .asciz "erreur div\n"
erreur_neg: .asciz "erreur neg\n"

test_ok: .asciz "\nall tests ok\n"
whatisit: .asciz "\nTest pour la librairie math24.\n"
add24_test: .asciz "\nadd24: "
sub24_test: .asciz "\nsub24: "
mul24_8u_test: .asciz "\nmul24_8u: " 
mul24s_test: .asciz "\nmul24s: "
div24_8u_test: .asciz "\ndiv24_8u: "
div24s_test: .asciz "\ndiv24s: "
neg24_test: .asciz "\nneg24: "

