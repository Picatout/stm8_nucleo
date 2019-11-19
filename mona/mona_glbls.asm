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
;--------------------------------------
    .area DATA 


    .area CODE 

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
;      'b' byte parameter  (int8_t)
;      'c' ASCII character
;      'e' 24 bits integer (int24_t) parameter
;      's' string (.asciz) parameter as far pointer (24 bits)
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
    ld a,(x)
    incw x 
    ld farptr,a 
    ld a,(x)
    incw x 
    ld farptr+1,a 
    ld a,(x)
    incw x 
    ld farptr+2,a
    call uart_prints 
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
