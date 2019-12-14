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
;   DEPENDENCIES: math24 
;--------------------------------------
    .module STRING

    .nlist
	.include "../../inc/nucleo_8s208.inc"
	.include "../../inc/stm8s208.inc"
	.include "../../inc/ascii.inc"
    .include "../../inc/gen_macros.inc"
    .include "../test_macros.inc" 
    .list 

_dbg 

    .area DATA 
.if DEBUG 
nearptr:: .blkw 1
.else     
nearptr: .blkw 1  ; used by format 
.endif 

    .area CODE 
.asciz "STRING"

;--------------------------------
; name: format
; A simplified version of 'C' <sprintf>
; input:
;   STR     *string buffer in which format is done
;   FMT     *string template
;   VARARG  variable length list of arguments 
; output:
;   X       char* to formatted string 
;
; Detail:
;   template is a .asciz string with embedded <%c>
;   to indicate parameters positision. First <%c> 
;   from left correspond to first paramter.
;   'c' is one of these: 
;      'a' print a count of SPACE for alignement purpose     
;      'c' ASCII character
;      'd' 24 bits integer (int24_t) displayed in decimal
;      's' string (.asciz) parameter as pointer (16 bits)
;      'x' 24 bits integer (int24_t) displayed in hexadecimal 
;      others values of 'c' are printed as is.
;--------------------------------
    VSIZE=26 ; local variables size 
    _argofs VSIZE 
    _arg STR 1  ; size word
    _arg FMT 3  ; size word
    _arg VARARGS 5 ; size variable 
; local variables
    DEST=1 ; 2 bytes overlay ACC24 
    SRC=3  ; 2 bytes  overlay ACC24 and BASE 
    ACC24=1 ; size 3 bytes
    BASE=4  ; size 1 
    BUFFER=5  ; size 2
    XSAVE=7  ; size 2 
    YSAVE=9  ; size 2 
    I24BUF=11 ; size 16 
_format::
format::
    _vars VSIZE 
; variable nearptr use as char* string 
    ldw x,(STR,sp)
    ldw nearptr,x
; X used as varargs pointer     
    ldw x,sp 
    addw x,#VARARGS 
; Y used as FMT pointer
    ldw y,(FMT,sp)
format_loop:
    ld a,(y)
    jrne 1$
    jp format_exit
1$: incw y 
    cp a,#'%
    jreq percent 
store_char:     
    ld [nearptr],a 
    inc nearptr+1 
    jrne format_loop 
    inc nearptr 
    jra format_loop  
percent:
    ld a,(y)
    jrne 1$
    jp format_exit 
1$: incw y
    cp a,#'a' 
    jrne 2$
; *** space fill ***
    ld a,(x)
    incw x 
    ldw (XSAVE,sp),x 
    push a 
    push #SPACE 
    ldw x,nearptr 
    pushw x 
    call fill
    ldw nearptr,x 
    _drop 4  
    ldw x,(XSAVE,sp) 
    jra format_loop 
2$:
    cp a,#'c'
    jrne 4$
; **** ASCII character ***
    ld a,(x)
    incw x 
    jra store_char          
4$: cp a,#'d 
    jrne 6$
; *** int24_t in decimal *** 
    ld a,#10 
5$: ld (BASE,sp),a
    ld a,(x)
    incw x 
    ld (ACC24,sp),a
    ld a,(x)
    incw x 
    ld (ACC24+1,sp),a 
    ld a,(x)
    incw x 
    ld (ACC24+2,sp),a   
    ldw (XSAVE,sp),x 
    ldw (YSAVE,sp),y 
    ldw x,sp 
    addw x,#I24BUF 
    ldw (BUFFER,sp),x 
    call i24toa
    ldw (SRC,sp),x 
    ldw x,nearptr 
    ldw (DEST,sp),x 
    call strcpy 
    ldw x,(STR,sp)
    ldw (DEST,sp),x 
    call strlen 
    addw x,(STR,sp)
    ldw nearptr,x  
    ldw x,(XSAVE,sp)
    ldw y,(YSAVE,sp)
    jp format_loop
6$: cp a,#'x
    jrne 7$ 
; *** int24_t in hexadecimal     
    ld a,#16
    jra 5$
7$: cp a,#'s 
    jreq 8$
    jp store_char
; *** string type parameter *** 
8$: ldw (YSAVE,sp),y 
    ldw y,x 
    addw x,#2 
    ldw (XSAVE,sp),x 
    ldw y,(y)
    ldw (SRC,sp),y 
    ldw x,nearptr 
    ldw (DEST,sp),x 
    call strcpy
    ldw x,(STR,sp)
    ldw (DEST,sp),x 
    call strlen 
    addw x,(STR,sp)
    ldw nearptr,x 
    ldw x,(XSAVE,sp)
    ldw y,(YSAVE,sp)
    jp format_loop 
format_exit:
    ldw x,(STR,sp)
    _drop VSIZE 
    ret 

;------------------------------------
; name: i24toa 
; convert integer to string

; input:
;   ACC24   integer to convert
;   BASE    numerical base 
;	BUFFER	char* buffer to receive string.
; output:
;   X  		char* numerical string 
;------------------------------------
	VSIZE=7
    _argofs VSIZE  
    _arg ACC24 1 
    _arg BASE 4 
    _arg BUFFER 5
; variables locales
    DIVIDEND=1; 3 bytes
    DIVISOR=4 ; 1      
    SIGN=5  ; 1
    XSAVE=6 ; 2 
_i24toa::
i24toa::
	_vars VSIZE 
	clr (SIGN,sp)    ; sign
	ld a,#10
    cp a,(BASE,sp)
	jrne 1$
	; base 10 string display with negative sign if bit 23==1
	ld a,#0x80
    bcp a,(ACC24,sp)
    jreq 1$ 
	cpl (SIGN,sp)
	cpl (ACC24,sp)
    cpl (ACC24+1,sp)
    cpl (ACC24+2,sp)
    inc (ACC24+2,sp)
    jrne 1$ 
    inc (ACC24+1,sp)
    jrne 1$ 
    inc (ACC24,sp)
1$:
    ldw x,(ACC24,sp)
    ld a,(ACC24+2,sp)
    ldw (DIVIDEND,sp),x 
    ld (DIVIDEND+2,sp),a 
; initialize string pointer 
	ldw x,(BUFFER,sp)
    addw x,#12
	clr (x)
itoa_loop:
    ldw (XSAVE,sp),x 
    ld a,(BASE,sp)
    ld (DIVISOR,sp),a 
    call div24_8u
    add a,#'0  ; remainder of division
    cp a,#'9+1
    jrmi 2$
    add a,#7 
2$: ldw x,(XSAVE,sp)
    decw x
    ld (x),a
	ld a,(DIVIDEND,sp)
	or a,(DIVIDEND+1,sp)
	or a,(DIVIDEND+2,sp)
    jrne itoa_loop
	;conversion done, next add "0x" or '-' as required
	ld a,(BASE,sp)
	cp a,#16
	jrne 10$
    ld a,#'x 
    decw x 
    ld (x),a 
    ld a,#'0 
    decw x 
    ld (x),a 
    jra 11$ 
10$:    
    ld a,(SIGN,sp)
    jreq 11$
    decw x
    ld a,#'-
    ld (x),a
11$:
	_drop VSIZE
    ret 


;------------------------------------
; name: atoi24
; convert string in 24 bits integer
; input:
;    BUFFER		string to convert 
; output:
;    X:A      int24_t
;------------------------------------
    VSIZE=9
    _argofs VSIZE
    _arg BUFFER 1  
; local variables
    ACC24=1 ; 3 bytes 
    MULT=4 ; 1 byte 
	SIGN=5 ; 1 byte, 
	BASE=6 ; 1 byte, numeric base used in conversion
    TEMP=7 ; 1 byte 
    XSAVE=8 ; 2 bytes  
_atoi24::
atoi24::
	_vars VSIZE 
    clrw x 
    ldw (ACC24,sp),x
    clr (ACC24+2,sp)
    ldw x,(BUFFER,sp)
	clr (SIGN,sp)
    ld a,(x)
	jreq atoi_exit
	ld a,#10
	ld (BASE,sp),a ; default base decimal
	ld a,(x)
	cp a,#'-
	jrne 1$
	cpl (SIGN,sp)
	jra 2$
1$: cp a,#'0
	jrne 3$
    ld a,(1,x)
    cp a,#'x
    jrne 3$ 
    cp a,#'X 
    jrne 3$  
	ld a,#16
	ld (BASE,sp),a
    incw x 
2$:	incw x  
3$:	ld a,(x)
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
    ld (MULT,sp),a 
    ldw (XSAVE,sp),x 
	call mul24_8u
    ld (ACC24+2,sp),a 
    ldw (ACC24,sp),x 
    ld a,(TEMP,sp)
	add a,(ACC24+2,sp)
	ld (ACC24+2,sp),a
	clr a
	adc a,(ACC24+1,sp)
	ld (ACC24+1,sp),a
	clr a
	adc a,(ACC24,sp)
	ld (ACC24,sp),a
    ldw x,(XSAVE,sp)
	jra 2$
9$:	tnz (SIGN,sp)
    jreq atoi_exit
    cpl (ACC24,sp) 
    cpl (ACC24+1,sp)
    cpl (ACC24+2,sp) 
    inc (ACC24+2,sp)
    jrne atoi_exit 
    inc (ACC24+1,sp)
    jrne atoi_exit 
    inc (ACC24,sp) 
atoi_exit: 
    ldw x,(ACC24,sp)
    ld a,(ACC24+2,sp)
    _drop VSIZE 
    ret 

;------------------------------------
;name: strlen
;  return .asciz string length
; input:
;	STR  	pointer to string
; output:
;	X     length
;------------------------------------
    VSIZE=0
    _argofs VSIZE 
    _arg STR 1 
_strlen::
strlen::
    ldw x,(STR,sp) 
0$: ld a,(x)
    jreq 2$
    incw x
    jra 0$
2$:
    subw x,(STR,sp)
    ret

;---------------------------------
; name: fill 
; insert COUNT character in buffer pointed 
; by 'x' 
; input:
;   BUFFER      char* buffer to fill.
;   CHAR        char fill character  
;   COUNT       byte character count
; output:
;   X           pointer after last fill character  
;----------------------------------
    VSIZE=0
    _argofs VSIZE  
    _arg BUFFER 1 ; word
    _arg CHAR  3 ;  byte
    _arg  COUNT 4 ; byte  
_fill::
fill::
    ldw x,(BUFFER,sp)
    ld a,(CHAR,sp)
1$: tnz (COUNT,sp) 
    jreq 9$ 
    ld (x),a 
    incw x
    dec (COUNT,sp)
    jrne 1$  
9$: ret 

;-------------------------
; name: strcpy 
; copy SRC to DEST 
; input:
;    DEST      destination buffer 
;    SRC       source buffer 
;  output:
;    X          DEST 
;----------------------------------
    VSIZE=2 
    _argofs VSIZE 
    _arg DEST 1
    _arg SRC 3
; local variables 
    YSAVE=1 ;    
_strcpy::
strcpy::
    _vars VSIZE 
    ldw (YSAVE,sp),y  
    ldw x,(DEST,sp)
    ldw y,(SRC,sp)
1$: ld a,(y)
    incw y 
    ld (x),a
    incw x 
    tnz a  
    jrne 1$
9$: ldw x,(DEST,sp)
    ldw y,(YSAVE,sp)
    _drop VSIZE 
    ret 

;------------------------
; name: memcpy 
; copy n bytes from source
; to dest.
; input:
;   DEST      destination ptr 
;   SRC       source ptr 
;   SIZE      in bytes 
; output:
;   none 
;--------------------------
    VSIZE=0
    _argofs VSIZE 
    _arg DEST 1  ; 1 word
    _arg SRC 3  ; 1 word
    _arg SIZE 5 ; 1 word  
_memcpy::
memcpy::
    ldw x,(DEST,sp)
    ldw y,(SRC,sp)
    cpw x,(SRC,sp)
    jrpl move_up_init 
move_down:
    ld a,(SIZE+1,sp)
    or a,(SIZE,sp)
    jreq memcpy_exit
    ld a,(y)
    incw y 
    ld (x),a 
    incw x 
    ld a,(SIZE+1,sp)
    sub a,#1 
    ld (SIZE+1,sp),a
    jrnc move_down
    dec (SIZE,sp)
    jra move_down 
move_up_init:
    addw x,(SIZE,sp)
    addw y,(SIZE,sp)
move_up:
    ld a,(SIZE+1,sp)
    or a,(SIZE,sp)
    jreq memcpy_exit
    decw y 
    ld a,(y)
    decw x 
    ld (x),a 
    ld a,(SIZE+1,sp)
    sub a,#1 
    ld (SIZE+1,sp),a
    jrnc move_up
    dec (SIZE,sp)
    jra move_up 
memcpy_exit:    
    ldw x,(DEST,sp)
    ret 

