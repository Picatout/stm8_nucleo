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
    clrw x 
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
