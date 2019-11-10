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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   MONA desassembler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .area CODE

    .include "../inc/ascii.inc"
	.include "mnemonics.inc"
    
;local constants
    PAGE_CNT = 24 ; instructions per page  
;local variables 
    INST_CNTR= 1 ;
    LOCAL_SIZE = 1

dasm::
    pushw X
    pushw y 
    sub sp,#LOCAL_SIZE 
    call number 
    ld a,pad
    jreq dasm_miss_arg
    ldw x, #acc24
    ldw y, #farptr
    call copy_var24
page_loop:
    ld a,#PAGE_CNT 
    ld (INST_CNTR,sp),a
instr_loop:
; print address
    ld a,#13
    call uart_tx
    ldw x, #farptr
    ldw y, #acc24
    call copy_var24 
    ld a,#16
    call itoa 
    call uart_print
    ld a,#TAB 
    call uart_tx 
    call decode
; here XL = decoded byte count
    ld a,xl
    ldw x,#farptr
    call inc_var24
    dec (INST_CNTR,sp)
    jrne instr_loop
; pause wait spacebar for next page or other to leave
    call uart_getchar
    cp a,#SPACE 
    jreq page_loop
    jra dasm_exit        
 dasm_miss_arg:
    call error_print    
dasm_exit: 
    popw y 
    popw x 
    addw sp,#LOCAL_SIZE 
    ret 

;------------------------------------------
;instruction decoder
; print instruction mnemonic and arguments
; input:
;   farptr  address next instruction
; output:
;   X       decoded byte count 
;--------------------------------------------  
; local variables      
    PRE_CODE = 1 ;
    OPCODE = 2 ;
    LOCAL_SIZE=2 ;
decode:
    sub sp,#LOCAL_SIZE 
    clrw x 
    ld a,#16
    call peek   
    ldf a, ([farptr],x)
    ld (OPCODE,sp),a 
    incw x  
    call is_precode
    ld (PRE_CODE,sp),a 
    cp a,#0
    jreq 1$
; get opcode
    ldf a,([farptr],x)
    ld (OPCODE,sp),a  
    ld a,#16
    call peek 
    incw x 
1$:
    ld a,#0xf0
    and a,(OPCODE,sp)
    cp  a,#0X20
    jrne 2$
    ldw y, (1,sp) ; yh = PRE_CODE, yl=OPCODE 
    jp reljump ; this is a relative jump
    jra decode_exit 
2$:         
decode_exit:    
    addw sp,#LOCAL_SIZE 
    ret

; check if byte in A is a precode 
; input:
;   A       code to check
; output:
;   A       A=0 if not precode 
is_precode:
    push a
    ldw y, #prefixes
1$: ld a,(y)
    jreq 2$
    incw y
    cp a,(1,sp)
    jrne 1$  
2$: addw sp,#1
    ret 


;decode relative jump
reljump:
; print relative address byte 
    ld a,#16
    call peek
    ld a,#TAB
    call uart_tx
; jrxx condition in lower nibble 
; jrxx table index = y+(cond_code*2)    
    ldw y,#jrxx
    ld a,#0xf 
    and a,(OPCODE,sp)
; acc24+2=cond_code      
    ld acc24+2,a 
    ld a,#0x90
    cp a,(PRE_CODE,sp)
    jrne 0$
; if precode==0x90 increment index.    
    ld a, acc24+2 
    sub a,#8
    ld acc24+2,a
    ldw y,#jrxx90 
0$: clr acc24+1
    sll acc24+2 
    addw y, acc24+1
    ldw y,(y)
; print instruction name 
    call uart_print
; get relative address byte     
    ldf a, ([farptr],x)
    incw x
; compute absolute address    
    sub sp,#4
    ; x offset extended to 24 bits 
    ldw (3,sp), x ; offset {15:0}
    clr (2,sp)    ; offset (23:16)
    ld (1,sp),a   ; rel jump distance {-128..127}
    cp a,#128
    jrult 1$
    ld a,#255
    ld (2,sp),a 
; copy farptr to acc24 
1$: ldw x, #farptr 
    ldw y, #acc24 
    call copy_var24
; add instruction bytes count to acc24.     
    ldw x, (3,sp) 
    addw x, acc24+1
    clr a  
    adc a, acc24
    ld acc24,a
    ldw acc24+1, x
    ld a,(1,sp)  ; relative address 
    ld xl,a
    ld a,(2,sp)
    ld xh,a
    addw x, acc24+1 
    adc a, acc24 
    ld acc24,a
    ldw acc24+1,x 
    popw x ; drop rel and bit 23:16 of X offset
    popw x ; restore offset 
; print jrxx target address     
    ld a,#SPACE 
    call uart_tx 
    ld a,#16 
    call itoa 
    call uart_print
    jp decode_exit


;prefix code 72
pre72:

    jp dasm_exit

;prefix code 90
pre90:

    jp dasm_exit 

;prefix code 91
pre91:

    jp dasm_exit 

;prefix code 92
pre92:

    jp dasm_exit

;inherent addressing
inherent:

;immediate addressing
immed:

;indexed addressing
indexed:

;indirect addressing
indirect:

;indirect indexed addressing
indirectx:

;relative addressing
reljmp:


;bit operation
bitop:


; opcode prefixes 
prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  


; opcodes without variable fields 
; table format: opcode, number of extra bytes, Mnemonic pointer, format string where XX,YY,ZZ are replace by extra bytes 
const_ops:
OP_INT: 
    .byte 0x82, 3 
    .word M.INT
    .asciz "INT XXYYZZ"

