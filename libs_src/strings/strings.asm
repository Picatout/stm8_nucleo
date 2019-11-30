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
;   STRINGS module
;   DATE: 2019-11-29
;--------------------------------------
    .module STRINGS

    .nlist
	.include "../../inc/nucleo_8s208.inc"
	.include "../../inc/stm8s208.inc"
	.include "../../inc/ascii.inc"
    .list 

    .area DATA 

    .area CODE 
.asciz "STRINGS"

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
    pushw y 
    ld a,(x)
    ld yh,a 
    incw x
    ld a,(x)
    ld yl,a 
    incw x 
    ld a,(x)
    incw x 
    call print_extd
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
atoi::
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
    negw y
atoi_exit: 
	addw sp,#LOCAL_SIZE
	popw x ; restore x
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

