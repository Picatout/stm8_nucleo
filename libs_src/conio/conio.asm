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
;   console Input/Output module
;   DATE: 2019-12-05
;   NOTE: global routines interface designed 
;         to be callable from C with the
;         prototype given. SDCC for stm8 
;         pass functions arguments on stack
;         pushed from right to left.
;--------------------------------------
    .module CONIO

    .nlist
	.include "../../inc/nucleo_8s208.inc"
	.include "../../inc/stm8s208.inc"
	.include "../../inc/ascii.inc"
    .include "../../inc/conio.inc" 
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

;-----------------------------------------
    .area DATA 
std_dev: .blkb 1  ; standard device identifier
ptr:    .blkw 1 ; pointer used by sprintf and printf 
fmt_buffer:: .ds FMT_BUFFER_SIZE
;------------------------------------------
    .area CODE 
.asciz "CONIO"

;----------------------------
; configure uart and select standard I/O device
; c prototype: void conio_init(uint8_t baud, uint8_t dev_id)
; input:
;   BAUD       uint8_t 
;   DEV_ID     uint8_t 
; output:
;   std_dev
;----------------------------
    ARG_OFS=2
    BAUD=ARG_OFS+1
    DEV_ID=ARG_OFS+2  ; one byte 
_conio_init::
conio_init::
    ld a,(DEV_ID,sp)
    ld std_dev,a
    jp uart_init

;--------------------------------------
; name: set_dev
; desc: select standard device 
; input:
;   DEV_ID      device identifier
; output:
;   none    
;-------------------------------------
    ARG_OFS=2 
    DEV_ID=ARG_OFS+1
set_dev::
    ld a,(DEV_ID,sp)
    ld std_dev,a 
    ret

;--------------------------------------
; name: get_dev
; desc: give standard device id.
; input:
;   none 
; output:
;   A           std_dev
;-------------------------------------
get_dev::
    ld a,std_dev
    ret 

;----------------------------------------
; output a character to standard output
;  C prototype:  int putchar(int char)
; input:
;   CHAR        int, character to output
; output:
;    X          same character  
;----------------------------------------
    VSIZE=2
    ARG_OFS=2+VSIZE
    CHAR=ARG_OFS+1
; local variables 
    UCHAR=1
    UART_ID=2
_putchar::
putchar::
    _vars VSIZE
    ld a,(CHAR+1,sp)
    ld (UCHAR,sp),a 
    ld a,std_dev 
    ld (UART_ID,sp),a 
    call uart_putc
    ldw x,(CHAR,sp) 
_fn_exit 

;------------------------------------------
; wait a character from standard input 
; C prototype: int getchar(void)
; input:
;   none
; output:
;   X       int character received 
;--------------------------------------------
_getchar::
getchar::
    ld a,std_dev
    push a 
    call uart_getc 
    _drop 1 
    ret

;----------------------------------------------
; output a string to standard output
; C prototype: int puts(const char*); 
; input:
;   STR         pointer to string 
; output:
;   X           string length
;------------------------------------------------
        VSIZE=3
        ARG_OFS=2+VSIZE
        STR=ARG_OFS+1 
; uart_puts arguments
        PUTS_STR=1   ; 2 bytes
        PUTS_UART=3  ; 1 byte      
_puts::
puts::
    _vars VSIZE 
    ld a,std_dev 
    ld (PUTS_UART,sp),a 
    ldw x,(STR,sp)
    ldw (PUTS_STR,sp),x 
    call uart_puts
    push #CR
    push #0 
    call putchar
    _drop 2  
_fn_exit 


;------------------------------------------------
; read a string from standard input. 
; buffer size is limited to 80 characters
; C prototype: char *gets(char *buffer)
; input:
;   BUFFER          char* receive buffer 
; output:
;   BUFFER          int line length.
;-------------------------------------------------
        MAX_LEN=79 ; maximum input string length
        VSIZE=2
        ARG_OFS=2+VSIZE
        BUFFER=1
	; local variables
	LEN = 1  ; accepted line length
	RXCHAR = 2 ; last char received
_gets::
gets::
    _vars VSIZE 
	clr (RXCHAR,sp) 
	clr (LEN,sp)
 	ldw y,(BUFFER,sp) ; input buffer
gets_loop:
	call getchar
	ld a,xl 
    ld (RXCHAR,sp),a 
	cp a,#CTRL_C
	jrne 2$
	jp cancel
2$:	cp a,#CTRL_R
	jreq reprint
	cp a,#CR
	jrne 1$
	jp gets_quit
1$:	cp a,#NL
	jreq gets_quit
	cp a,#BSP
	jreq del_back
	cp a,#CTRL_D
	jreq del_line
	cp a,#SPACE
	jrpl accept_char
	jra gets_loop
del_line:
    ld a,std_dev
    push a 
	ld a,(LEN,sp)
    push a 
	call uart_delete
    _drop 2 
	ldw y,(BUFFER,sp)
	clr (LEN,sp)
	jra gets_loop
del_back:
    tnz (LEN,sp)
    jreq gets_loop
    dec (LEN,sp)
    decw y
    clr  (y)
    ld a,std_dev
    push a 
    ld a,#1
    push a 
    call uart_delete
    _drop 2 
    jra gets_loop	
accept_char:
	ld a,#MAX_LEN
	cp a, (LEN,sp)
	jreq gets_loop
	ld a,(RXCHAR,sp)
	ld (y),a
	inc (LEN,sp)
	incw y
	clr (y)
	call putchar 
	jra gets_loop
reprint:
	tnz (LEN,sp)
	jrne gets_loop
	ldw y,(BUFFER,sp)
	pushw y
	call puts 
	popw y
	ld a,xl 
	ld (LEN,sp),a
	ld a,yl
	add a,(LEN,sp)
	ld yl,a
    jrnc 1$
    jp gets_loop
1$: ld a,yh 
    inc a 
    ld yh,a 
	jp gets_loop
cancel:
	ldw x,(BUFFER,sp)
    clr (x)
gets_quit:
	clrw y
    ld a,#CR 
    ld yl,a 
    pushw y  
	call putchar 
    _drop 2 
    ldw x,(BUFFER,sp)
_fn_exit 

;-----------------------------------
; name: is_digit 
; check if character is in range
; '0'..'9'
; input:
;   A       CHAR 
; ouput:
;   A       true|false 
;----------------------------------
    ARG_OFS=2
    CHAR=ARG_OFS+1
_is_digit::
is_digit::
    ld a,(CHAR,sp)
    cp a,#'0
    ccf 
    jrnc 1$ 
    cp a,#'9+1 
1$: push cc 
    pop a 
    ret 

;-----------------------------------
; name: is_hex 
; check if character is in ranges
; '0'..'9','A'..'F'
; input:
;   A       CHAR 
; ouput:
;   A       true|false
;----------------------------------
    ARG_OFS=2
    CHAR=ARG_OFS+1
_is_hex::
is_hex::
    ld a,(CHAR,sp) 
    cp a,#'0
    ccf 
    jrnc 9$
    cp a,#'9+1 
    jrc 9$ 
    sub a,#7 
    and a,#0xdf
    cp a,#'F+1 
9$: push cc 
    pop a 
    ret 


;---------------------------------------------
; name: i24toa 
; convert integer to ASCII string 
; input:
;   BUFF        buffer that receive string.
;   INT         int24_t 
;   BASE        numeric base for conversion 
; output:
;   X           *str  resulting string     
;---------------------------------------------
        VSIZE=5
        ARG_OFS=2+VSIZE
        BUFF=ARG_OFS+1 
        INT=ARG_OFS+3 
        BASE=ARG_OFS+6
; local vars
        U24=1 
        U8=4
        SIGN=5 
_i24toa::
i24toa::
    _vars VSIZE
    ldw y,(BUFF,sp)
    addw y,#9
    clr (y)
    clr (SIGN,sp)
    ldw x,(INT,sp)
    ld a,(INT+2,sp)
    ld (U24+2,sp),a 
    ldw (U24,sp),x 
    cp a,#16
    jreq 1$
    ld a,#0x80 
    bcp a,(U24,sp)
    jreq 1$
    ld a,(U24+2,sp)
    call neg24 
    ldw (U24,sp),x 
    ld (U24+2,sp),a 
    cpl (SIGN,sp)
1$: ld a,(BASE,sp)
    ld (U8,sp),a 
    call div24_8u 
    add a,#'0 
    cp a,#'9'+1
    jrmi 11$ 
    add a,#7 
11$:
    decw y 
    ld (y),a 
    ld a,(U24+2,sp) 
    or a,(U24+1,sp)
    or a,(U24,sp) 
    jrne 1$
    ld a,#16 
    cp a,(BASE,sp)
    jrne 2$
    ld a,#'x 
    decw y 
    ld (y),a 
    ld a,#'0 
    decw y 
    ld (y),a 
    jra 3$
2$: tnz (SIGN,sp)
    jreq 3$
    decw y 
    ld a,#'-
    ld (y), a
3$: ldw x,y 
    _fn_exit 
    
;---------------------------------
; name: fill 
; insert COUNT character in buffer pointed 
; by 'x' 
; input:
;   X            buffer 
;   COUNT        character count
;   A           fill character  
; output:
;   X           pointer after last fill character  
;----------------------------------
    ARG_OFS=2 
    COUNT=ARG_OFS+1
fill:
    tnz (COUNT,sp)
    jreq 9$ 
    ld (x),a 
    incw x
    dec (COUNT,sp)
    jrne fill  
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
    SAVED=2
    ARG_OFS=2+SAVED
    DEST=ARG_OFS+1 
    SRC=ARG_OFS+3
strcpy:
    pushw y 
    ldw x,(DEST,sp)
    ldw y,(SRC,sp)
1$: ld a,(y)
    incw y 
    ld (x),a
    incw x 
    tnz a  
    jrne 1$
9$: ldw x,(DEST,sp)
    popw y
    ret 

;------------------------
; name: move 
; copy n bytes from source
; to dest.
; input:
;   X       source ptr 
;   Y       dest ptr 
;   A       N 
; output:
;   *Y=*X 
;--------------------------
move:
    push a 
0$:
    ld a,(x)
    incw x 
    ld (y),a
    incw y  
    dec (1,sp)
    jrne 0$
    pop a 
    ret 


;--------------------------------
; name: strlen
; return .asciz string length 
; c prototype: int strlen(const char*)
; input:
;   STR         char*
; output:
;   X           length 
;--------------------------------
    SAVED=2
    ARG_OFS=2+SAVED 
    STRPTR=ARG_OFS+1 
_strlen::
strlen::
    pushw y 
    clrw x 
    ldw y,(STRPTR,sp)
1$: ld a,(y)
    jreq 2$
    incw x
    incw y  
    jra 1$
2$:
    popw y 
    ret 

;-------------------------------------------------------------    
; name: sprintf 
; C prototype: int sprintf(char *str, const char *format, ...)
; This is a simplified version of 'C' <sprintf>
; input:
;   *str       buffer that received formated string 
;   format     string format specifier
;   ...        variable count of args to be formated in str.
; output:
;   X          int str length
; Detail:
;   format is a .asciz string with embedded <%char>
;   to indicate parameters positision. First <%char> 
;   from left correspond to first parameter.
;   char is one of these: 
;      'a' print a count of SPACE for alignement purpose     
;      'c' ASCII character
;      'd' 24 bits integer (int24_t) parameter in decimal 
;      's' string (.asciz) argument type char* (16 bits pointer)
;      'x' 24 bits integer in hexadecimal  
;      others values of char are printed as is.
;--------------------------------
    VSIZE=10 ; local variables space 
    ARG_OFS=2+VSIZE
    STRPTR=ARG_OFS+1 
    FMT=ARG_OFS+3
    VARARG=ARG_OFS+5 
;*******  local vars **********
; ** in registers **
;  x vararg pointer 
;  y format pointer
; ** module variable in ram. **
;  'ptr' for string buffer. 
; ** on stack **
; ACC24 for integer conversion 
    BUFFER=1 ; int formatting buffer pointer 
    ACC24=3  ; 24 bits accumulator 
    ACC16=4
    ACC8=5
    BASE=6
    XSAVE=7  ; temporary X storage 
    YSAVE=9  ; temporary y storage 
;    
_sprintf::
sprintf::
    _vars VSIZE
;   ldw x,#fmt_buffer
    ldw (BUFFER,sp),x     
; ptr = str
    ldw x,(STRPTR,sp)
    ldw ptr,x     
; X used as vararg pointer
    ldw x,sp  
    addw x,#VARARG 
; y used as format pointer 
    ldw y,(FMT,sp)
sprintf_loop:
    ld a,(y)
    jrne 1$
    jp sprintf_exit
1$: incw y 
    cp a,#'%
    jreq 2$
    jp store_char
2$:
    ld a,(y)
    jrne 21$
    jp sprintf_exit 
21$:
    incw y
    cp a,#'a' 
    jrne 3$
; *** spaces fill ***     
    ld a,(x)
    incw x
    pushw x
    ldw x,ptr   
    push a
    ld a,#SPACE
    call fill
    _drop 1 
    ldw ptr,x 
    popw x
    clr [ptr]
    jra sprintf_loop 
3$: cp a,#'c 
    jrne 4$
; *** ASCII character **
    ld a,(x)
    incw x
    jp store_char  
4$: cp a,#'d 
    jrne 6$
; *** print int24_t arg in decimal ***
    ldw (YSAVE,sp),y 
    ld a,#10 
5$: ld (BASE,sp),a  
    ldw y,sp 
    addw y,#ACC24
    ld a,#3 
    call move ; arg to ACC24
    ldw (XSAVE,sp),x  
    call i24toa  
    pushw x 
    ldw x,ptr 
    pushw x 
    call strcpy 
    _drop 4 
    ldw x,(STRPTR,sp)
    pushw x 
    call strlen 
    addw x,(STRPTR,sp)
    ldw ptr,x 
    ldw x,(XSAVE,sp) 
    ldw y,(YSAVE,sp)
    jra sprintf_loop
6$: cp a,#'s 
    jrne 8$
; *** string type parameter ***
    ldw (XSAVE,sp),x 
    ldw (YSAVE,sp),y  
    ldw x,(x)
    pushw x  
    ldw x,ptr 
    pushw x 
    call strcpy
    _drop 4 
    ldw x,(STRPTR,sp)
    pushw x 
    call strlen
    _drop 2  
    addw x,(STRPTR,sp)
    ldw ptr,x 
7$: ldw x,(XSAVE,sp) 
    addw x,#2
    ldw y,(YSAVE,sp)
    jp sprintf_loop 
8$: cp a,#'x 
    jrne store_char 
; print_int in hexadecimal     
    ldw (YSAVE,sp),y 
    ld a,#16 
    jra 5$
store_char:
    ld [ptr],a 
    inc ptr+1 
    jrne 2$
    inc ptr 
2$: clr [ptr]
    jp sprintf_loop 
sprintf_exit:
    clr [ptr]
    ldw x,(STRPTR,sp)
    pushw x 
    call strlen 
    _drop VSIZE+2 
    ret 

;----------------------------------
; name: printf
; C prototype: int printf(fmt,...)
; input:
;   FMT     format strint 
;   VARARG  variable length args list 
; output:
;   X       printed string length
;----------------------------------
    VSIZE=11 ; local variables space 
    ARG_OFS=2+VSIZE
    FMT=ARG_OFS+1
    VARARG=ARG_OFS+3 
;*******  local vars **********
; ** in registers **
;  x vararg pointer 
;  y format pointer
; ** on stack **
; ACC24 for integer conversion 
    ACC24=1  ; 24 bits accumulator 
    ACC16=2
    ACC8=3 
    BASE=4
    STRLEN=5 ; string length 
    XSAVE=7  ; temporary X storage 
    YSAVE=9  ; temporary y storage 
;    
_printf::
printf::
    _vars VSIZE
    clrw x 
    ldw (STRLEN,sp),x 
; X used as vararg pointer
    ldw x,sp  
    addw x,#VARARG 
; y used as format pointer 
    ldw y,(FMT,sp)
printf_loop:
    ld a,(y)
    jrne 1$
    jp printf_exit
1$: incw y 
    cp a,#'%
    jreq 2$
    jp print_char
2$:
    ld a,(y)
    jrne 21$
    jp printf_exit 
21$:
    incw y
    cp a,#'a' 
    jrne 3$
; *** spaces ***    
    ldw (XSAVE,sp),x
    ldw (YSAVE,sp),y  
    _vars 2 
    ld a,(x)
    ld (1,sp),a 
    ld a,std_dev 
    ld (2,sp),a   
    call uart_spaces
    _drop 2 
    ldw x,(XSAVE,sp)
    ld a,(x)
    incw x 
    add a,(STRLEN+1,sp)
    ld (STRLEN+1,sp),a 
    clr a
    adc a,(STRLEN,sp)
    ld (STRLEN,sp),a
    ldw y,(YSAVE,sp)   
    jra printf_loop 
3$: cp a,#'c 
    jrne 4$
; *** ASCII character ***
    ld a,(x)
    incw x
    jp print_char  
4$: cp a,#'d 
    jrne 6$
; *** print int24_t arg in decimal ***
    ldw (YSAVE,sp),y 
    ld a,#10 
5$: ld (BASE,sp),a  
    ldw y,sp 
    addw y,#ACC24 
    ld a,#3
    call move 
    ldw (XSAVE,sp),x 
    _vars 2 
    ldw x,#fmt_buffer 
    ldw (1,sp),x  
    call i24toa  
    _vars 1 
    ldw (1,sp),x
    ld a,std_dev 
    ld (3,sp),a  
    call uart_puts 
    _drop 3 
    addw x,(STRLEN,sp)
    ldw (STRLEN,sp),x 
    ldw x,(XSAVE,sp) 
    ldw y,(YSAVE,sp)
    jp printf_loop
6$: cp a,#'s 
    jrne 8$
; *** string type parameter ***
    ldw (XSAVE,sp),x
    ldw (YSAVE,sp),y  
    ld a,std_dev 
    push a 
    ldw x,(x)
    pushw x  
    call uart_puts 
    _drop 3
    addw x,(STRLEN,sp)
    ldw (STRLEN,sp),x 
    ldw x,(XSAVE,sp) 
    addw x,#2
    ldw y,(YSAVE,sp)
    jp printf_loop 
8$: cp a,#'x 
    jrne print_char 
; *** print_int in hexadecimal ***
    ldw (XSAVE,sp),x
    ldw (YSAVE,sp),y 
    ld a,#16 
    jra 5$
print_char:
    ldw (XSAVE,sp),x
    push a
    push 0 
    call putchar 
    _drop 2 
    ldw x,(XSAVE,sp)
    inc (STRLEN+1,sp)
    jrne 2$
    inc (STRLEN,sp)             
2$:
    jp printf_loop 
printf_exit:
    ldw x,(STRLEN,sp)
    _fn_exit 
    


