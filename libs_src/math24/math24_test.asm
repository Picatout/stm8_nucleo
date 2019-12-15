; test pour librairie math24.lib 


    .module MATH24_TEST
    .nlist
    .include "../../inc/nucleo_8s208.inc"
    .include "../../inc/stm8s208.inc"
    .include "../../inc/ascii.inc"
    .include "../test_macros.inc"
    .list 

    .area CODE
_dbg 

test_main::
    IDX_ERR_SUM=0
    IDX_ERR_SUB=1 
    IDX_ERR_MUL=2
    IDX_ERR_DIV=3
    IDX_ERR_NEG=4

presentation:
    ldw y,#whatisit
    _dbg_puts  
    
repl:
    _dbg_parser_init
; move terminal cursor to next line
	ld a,#NL 
	_dbg_putc 
; print prompt sign	 
	ld a,#'>
	_dbg_putc 
; read command line	
	_dbg_readln 
;if empty line -> ignore it, loop.	
	tnz tib
	jreq repl
; initialize parser and call eval function	  
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
    _dbg_nextword 
    ld a,pad 
    ld (OP,sp),a
    _dbg_number
    ldw x,acc24
    ldw (N1,sp),x
    ld a,acc8  
    ld (N1+2,sp),a 
    _dbg_number
    ldw x,acc24 
    ldw (N2,sp),x
    ld a, acc8  
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
4$: cp a,#'n 
    jrne 5$
    jp test_neg
5$:

eval_exit:
    addw sp,#LOCAL_SIZE 
    ret 

test_add:
    ldw y,#add24_test
    _dbg_puts 
    call print_arguments
    call add24 
    call print_int24
    jp eval_exit
test_sub:
    ldw y,#sub24_test
    _dbg_puts 
    call print_arguments
    call sub24 
    call print_int24
    jp eval_exit
test_mul:
    ldw y,#mul24s_test
    _dbg_puts
    call print_arguments
    call mul24s
    call print_int24
    jp eval_exit
test_div:
    ldw y,#div24s_test
    _dbg_puts
    call print_arguments
    call div24s 
    call print_int24
    ld a,#'R 
    _dbg_putc 
    ld a,#'=
    _dbg_putc 
    ldw x,(1,sp)
    ld a,(3,sp)
    call print_int24  
    jp eval_exit
test_neg:
    ldw y,#neg24_test
    _dbg_puts 
    call print_arguments 
    ld a,(N1+2,sp)
    ldw x,(N1,sp)
    call neg24 
    call print_int24 
    ld a,(N2+2,sp)
    ldw x,(N2,sp)
    call neg24 
    call print_int24 
    jp eval_exit 

print_error:
    ldw y,#msg_erreur
    clr acc16 
    sll a 
    ld acc8,a
    addw y,acc16 
    ldw y,(y)
    _dbg_puts
    jra .

;-------------------------
; name: print_arguments
; input:
;  N1     int24_t 
;  N2     int24_t 
; output:
;  none
;------------------------
    ARG_OFS=2
    N1=ARG_OFS+1 
    N2=ARG_OFS+4
print_arguments:
    ld a,#SPACE 
    _dbg_putc 
    ldw x,(N1,sp)
    ld a,(N1+2,sp)
    call print_int24 
    ld a,#SPACE 
    _dbg_putc 
    ldw x,(N2,sp)
    ld a,(N2+2,sp)
    call print_int24 
    ld a,#'= 
    _dbg_putc 
    ret 

print_int24:
    ldw acc24,x 
    ld acc8,a 
    clrw x 
    ld a,#10
    _dbg_prti24 
    ret 


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

