;;
; Copyright Jacques Deschênes 2019 
; This file is part of MONA 
;
;     MONA is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     MONA is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
;   globals sub-routines and variables
;   module 
;--------------------------------------
    .module GLOBALS 

    .nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "mona.inc"
    .list 

    .area DATA 
rx_char:: .blkb 1 ; last uart received char
pad::	.blkb PAD_SIZE ; working pad
acc24:: .blkb 1; acc24:acc16:acc8 form a 24 bits accumulator
acc16:: .blkb 1; acc16:acc8 form a 24 bits accumulator 
acc8::  .blkb 1; acc8 an 8 bit accumulator 
farptr:: .blkb 3; 24 bits pointer
flags::  .blkb 1; boolean flags


    .area CODE 
.ascii "GLOBALS"
;--------------------------------
; <format> is a simplifide version
; of 'C' <printf>
; input:
;   Y       pointer to template string 
;   stack   all others paramaters are on 
;           stack. First argument is at (3,sp)
; output:
;   none
; use:
;   X       used as frame pointer  
; Detail:
;   template is a .asciz string with embedded <%c>
;   to indicate parameters positision. First <%c> 
;   from left correspond to first paramter.
;   'c' is one of these: 
;      'a' print a count of SPACE for alignement purpose     
;      'b' byte parameter  (int8_t)
;      'c' ASCII character
;      'e' 24 bits integer (int24_t) parameter
;      's' string (.asciz) parameter as long pointer (16 bits)
;      'w' word paramter (int16_t) 
;      others values of 'c' are printed as is.
;  These are sufficient for the requirement of
;  mona_dasm
;--------------------------------
    LOCAL_OFS=8 ; offset on stack of arguments frame 
format::
; preserve X
    pushw x 
; preserve farptr
    ld a, farptr+2
    push a 
    ld a, farptr+1 
    push a 
    ld a, farptr
    push a
; X used as frame pointer     
    ldw x,sp 
    addw x,#LOCAL_OFS
format_loop:    
    ld a,(y)
    jrne 1$
    jp format_exit
1$: incw y 
    cp a,#'%
    jreq 2$
    call uart_tx
    jra format_loop  
2$:
    ld a,(y)
    jreq format_exit 
    incw y
    cp a,#'a' 
    jrne 24$
    ld a,(x)
    incw x 
    call spaces 
    jra format_loop 
24$:
    cp a,#'b'
    jrne 3$
; byte type paramter     
    ld a,(x)
    incw x 
    call print_byte
    jra format_loop
3$: cp a,#'c 
    jrne 4$
; ASCII character 
    ld a,(x)
    incw x 
    call uart_tx 
    jra format_loop         
4$: cp a,#'e 
    jrne 6$
; int24_t parameter     
    ld a,(x)
    incw x 
    ld acc24,a 
    ld a,(x)
    incw x 
    ld acc16,a 
    ld a,(x)
    incw x 
    ld acc8,a
    pushw y  
    ld a,#16 
    call itoa
    decw y 
    ld a,#'$
    ld (y),a 
    call uart_print 
    popw y  
    jra format_loop
6$: cp a,#'s 
    jrne 8$
; string type parameter     
    pushw y
    ldw y,x 
    addw x,#2
    ldw y,(y)
    call uart_print 
7$: popw y 
    jra format_loop 
8$: cp a,#'w 
    jrne 9$
; word type paramter     
    pushw y 
    ld a,(x)
    incw x 
    ld yh,a
    ld a,(x)
    incw x 
    ld yl,a 
    call print_word 
    popw y 
    jp format_loop 
9$: call uart_tx         
    jp format_loop 
format_exit:
; restore farptr 
    pop a 
    ld farptr,a 
    pop a 
    ld farptr+1,a 
    pop a 
    ld farptr+2,a 
    popw x 
    ret 

;------------------------------------
; print n spaces 
; input: 
;   A  		number of space to print 
; output:
;	none 
;------------------------------------
spaces::
	push a 
	ld a,#SPACE 
1$:	tnz (1,sp)
	jreq 2$ 
	call uart_tx 
	dec (1,sp)
	jra 1$
2$:	pop a 
	ret


;------------------------------------
;  serial port communication routines
;------------------------------------
;------------------------------------
; transmit character in a via UART3
; character to transmit on (3,sp)
;------------------------------------
uart_tx::
	tnz UART3_SR
	jrpl uart_tx
	ld UART3_DR,a
    ret

;------------------------------------
; send string via UART2
; y is pointer to str
;------------------------------------
uart_print::
; check for null pointer  
	cpw y,#0
    jreq 1$ 
0$: ld a,(y)
	jreq 1$
	call uart_tx
	incw y
	jra 0$
1$: ret

;------------------------------------
; check if char available
;------------------------------------
uart_qchar::
	tnz rx_char
	jreq 1$
    ret
1$: ld a,#UART_SR_RXNE 
	and a,UART3_SR
	ret 

;------------------------------------
; return char in A to queue
;------------------------------------
;ungetchar:: 
	ld rx_char,a
    ret
    
;------------------------------------
; wait for character from uart3
;------------------------------------
uart_getchar::
; if there is a char in rx_char return it.
	ld a,rx_char 
	jreq 1$
	clr rx_char
	ret
1$:	btjf UART3_SR,#UART_SR_RXNE,.
	ld a, UART3_DR 
	ret

;------------------------------------
; delete n character from input line
;------------------------------------
uart_delete::
	push a ; n 
del_loop:
	tnz (1,sp)
	jreq 1$
	ld a,#BSP
	call uart_tx
    ld a,#SPACE
    call uart_tx
    ld a,#BSP
    call uart_tx
    dec (1,sp)
    jra del_loop
1$: pop a
	ret 

;-----------------------------------
; print a string (.asciz) pointed
; by a far pointer 
; input:
;   farptr    pointer to string 
; output:
;   none
;----------------------------------- 
uart_prints::
    pushw y 
    clrw y
1$:
    ldf a,([farptr],y)
    jreq 2$
    call uart_tx 
    incw y 
    jra 1$
2$:
    popw y 
    ret 

