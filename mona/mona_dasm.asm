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
;----------------------------------------------------------------------------
;   Here how I proceded:
; according to this table: https://en.wikipedia.org/wiki/STM8#Instruction_set
; I tried to group opcode sharing the same common bits field. For exemple
; jrxx instruction all begin with 0010 . Only the least 4 bits changes to
; indicate what condition to test. So I decode them in reljump group. 
;-----------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   MONA desassembler
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .area CODE

    .include "../inc/ascii.inc"
	.include "mona.inc"
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
    ld a,#CR 
    call uart_tx
    ldw x, #farptr
    ldw y, #acc24
    call copy_var24 
    ld a,#6
    ld xl,a 
    ld a,#16
    call print_int 
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
    PREFIX = 1 ; opcode prefix 
    OPCODE = 2 ; operating code 
    ADR24 = 3  ; addr24 absolute address
    ADR16 = 4  ; add16 absolute address 
    REL = 6 ; addr8 relative address 
    LOCAL_SIZE=6 ;
decode:
    sub sp,#LOCAL_SIZE 
    clrw x 
    call peek   
    ld (OPCODE,sp),a 
    call print_byte
    ld a,(OPCODE,sp)  
    call is_prefix 
    ld (PREFIX,sp),a 
    cp a,#0
    jreq 1$
; get opcode
    call peek 
    ld (OPCODE,sp),a  
    call print_byte
1$:
    ldw y,#adr_mode
    ld a,#0xf0 
    and a,(OPCODE,sp)
    swap a 
    sll a 
    ld acc8,a 
    clr acc16
    addw y,acc16     
    ldw y,(y)
    jp (y)
invalid_opcode: 
    ldw y, #M.QM
    call print_mnemonic
decode_exit:    
    addw sp,#LOCAL_SIZE 
    ret

M.QM:  .asciz "?"


; instructions grouped by addressing mode
; hi-nibble specify addressing mode
; lo-nibble specify operation
; there is exceptions in this grouping that
; must be taken care of.
; prefix induce change in addressing mode or operation 
adr_mode:
    .word mode_0x,mode_1x,mode_2x,mode_3x,mode_4x,mode_5x,mode_6x,mode_7x
    .word mode_8x,mode_9x,mode_ax,mode_bx,mode_cx,mode_dx,mode_ex,mode_fx


; check if byte in A is a prefix  
; input:
;   A       code to check
; output:
;   A       A=0 if not precode 
is_prefix:
    push a
    ldw y, #prefixes
1$: ld a,(y)
    jreq 2$
    incw y
    cp a,(1,sp)
    jrne 1$  
2$: addw sp,#1
    ret 

; opcode prefixes 
prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  

;------------------------------
; form: op (off8,sp)
; form with prefix 0x72 decoded seperately
; exceptions: 
;   0x01 -> RRWA X 
;   0x02 -> RLWA X
;   0x90 0x01 -> RRWA Y
;   0x90 0x02 -> RLWA Y
;---------------------------
mode_0x:
    ld a,#0x72 
    cp a,(PREFIX,sp)
    jrne 0$
    jp btjr ; prefix 0x72 
; code 0x01,0x02, 0x90 0x01 and 0x90 0x02 are exceptions     
0$: ld a,#1
    cp a,(OPCODE,sp)
    jrne 1$
    ldw y, #M.RRWA 
    call print_mnemonic 
    jra 2$
1$: ld a,#2
    cp a,(OPCODE,sp)
    jrne 4$
    ldw y, #M.RLWA 
    call print_mnemonic
2$: ld a,#'X 
    tnz (PREFIX,sp)
    jreq 3$
    ld a,#0x90
    cp a,(PREFIX,sp)
    jrne 5$
    ld a,#'Y 
3$: call uart_tx
    jp decode_exit
4$: tnz (PREFIX,sp)
    jrne 5$
    call peek
    ld (REL,sp),a 
    call print_byte 
    ld a,(OPCODE,sp)
    and a,#0xf
    ld acc24+2,a  
    sll acc24+2
    clr acc24+1
    ldw y, #mode_0x_mnemo
    addw y,acc24+1
    ldw y,(y)
    call print_mnemonic 
    ld a,#'( 
    call uart_tx
    ld a,(REL,sp)
    call print_byte 
    ld a,#', 
    call uart_tx 
    ldw y,#R.SP 
    call uart_print  
    ld a,#')
    call uart_tx 
    jp decode_exit 
5$: 
    jp invalid_opcode

; pointer table for mode_0x mnemonics 
mode_0x_mnemo:
    .word M.NEG,M.RRWA,M.RLWA,M.CPL,M.SRL,M.NULL,M.RRC,M.SRA,M.NULL
    .word M.RLC,M.DEC,M.NULL,M.INC,M.TNZ,M.SWAP,M.CLR 

;--------------------------
; test bit and jump relative 
; form: btj[t|f]  addr16,#bit,srel 
; mode_0x with 0x72 prefix
; btjt add16,#bit,rel | btjf add16,#bit,rel  
; btjt 0000bbb0
; btjf 0000bbb1
; where bbb is bit number to test {0...7}
;-----------------------------
btjr:
    call get_int16
    ldw (ADR16,sp),y 
    call peek 
    ld (REL,sp),a 
    call print_byte 
    ld a, (OPCODE,sp) 
    ldw y, #M.BTJT
    and a,#1
    jreq 1$
    ldw y, #M.BTJF  
1$: call print_mnemonic
    ldw y, (ADR16,sp)
    call print_word
    ld a,#',
    call uart_tx
    ld a,#'#
    call uart_tx 
    ld a, (OPCODE,sp)
    srl a 
    and a,#7 
    add a,#'0
    call uart_tx 
    ld a,#',
    call uart_tx 
    ld a,(REL,sp)
    call abs_addr 
    pushw x 
    clrw x 
    ld a,#16
    call print_int
    popw x  
    jp decode_exit 


;----------------------------
; form: op A,(off8,SP)
; form: op X,(off8,SP)
; form: op Y,(off8,SP)
; prefix 0x72 and 0x90 modify operations
;----------------------------
mode_1x:
    ld a,(PREFIX,sp)
    jreq 1$
    jp mode_1x_with_prefix
1$: ; no prefix 
    call peek 
    ld (REL,sp),a
    call print_byte 
    ld a,#0x1c
    cp a,(OPCODE,sp)
    jreq 10$
    ld a,#0x1d 
    cp a,(OPCODE,sp)
    jrne 14$
10$:
    call peek 
    ld (ADR16+1,sp),a
    call print_byte 
    ldw y,#M.ADDW 
    ld a,#0x1D
    cp a,(OPCODE,sp)
    jrne 11$
    ldw y,#M.SUBW
11$:
    call print_mnemonic
    ldw y,#addw_x_imm16 
    call uart_print
    ld a,(ADR16+1,sp)
    ld yl,a
    ld a,(REL,sp)
    ld yh,a  
    call print_word 
    jp decode_exit 
14$:    
    ld a,#0xf 
    and a,(OPCODE,sp)
    sll a 
    ld acc8, a 
    clr acc16 
    ldw y,#mode_1x_mnemo
    addw y, acc16 
    ldw y,(y)
    call print_mnemonic
    ld a,#0x16
    cp a,(OPCODE,sp)
    jrne 3$
;*** ldw y,(ofs8,sp) ***
    ldw y,#op_y_ofs8_sp
    call uart_print 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte
    ldw y,#op_ofs8_sp_close 
    call uart_print 
    jp decode_exit
3$:
    ld a,#0x17 
    cp a,(OPCODE,sp)
    jrne 4$
;*** ldw (ofs8,sp),y ***
    ld a,#'(
    call uart_tx 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte
    ldw y,#op_ofs8_sp_y  
    call uart_print 
    jp decode_exit 
4$: 
    ld a,#0x13
    cp a,(OPCODE,sp)
    jreq 5$
    ld a,#0x1e 
    cp a,(OPCODE,sp)
    jrne 6$
5$:
;*** op x,(ofs8,sp) ***
    ldw y,#op_x_ofs8_sp 
    call uart_print 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte 
    ldw y,#op_ofs8_sp_close
    call uart_print 
    jp decode_exit 
6$:
    ld a,#0x1f
    cp a,(OPCODE,sp)
    jrne 7$
; *** ldw (ofs8,sp),x ***  
    ld a,#'(
    call uart_tx 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte 
    ldw y,#op_ofs8_sp_x
    call uart_print 
    jp decode_exit 
7$:
;*** op a,(ofs8,sp)
    ldw y,#op_a_ofs8_sp        
    call uart_print 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte
    ldw y,#op_ofs8_sp_close
    call uart_print 
    jp decode_exit 

addw_x_imm16: .asciz "X,#"
op_a_ofs8_sp: .asciz "A,("
op_x_ofs8_sp: .asciz "X,("
op_y_ofs8_sp: .asciz "Y,("
op_ofs8_sp_y: .asciz ",SP),Y"
op_ofs8_sp_x: .asciz ",SP),X"
op_ofs8_sp_close: .asciz ",SP)"

; grp_1x with prefrix 0x72,0x90 
; form:  op addr16,#bit,rel  
mode_1x_with_prefix:
    ld a,#0xf0
    and a,(PREFIX,sp)
    cp a,#9
    jrne 0$
    jp invalid_opcode
0$:     
    call get_int16 
    ldw (ADR16,sp),y 
    clr acc16 
    clr acc8 
    ld a,#0x72 
    cp a,(PREFIX,sp)
    jreq 1$ 
    ld a,#4
    add a,acc8 
    ld acc8,a 
1$: ld a,#1
    and a,(OPCODE,sp)
    jreq 2$ 
    ld a,#2
    add a,acc8 
    ld acc8,a 
    clr a 
    adc a,acc16 
    ld acc16,a 
2$: ldw y, #mode_1x_prefix_mnemo
    addw y,acc16     
    ldw y,(y) 
    call print_mnemonic
    ldw y, (ADR16,sp)
    call print_word 
    ld a,#',
    call uart_tx 
    ld a,#'# 
    call uart_tx 
    ld a,(OPCODE,sp)
    srl a 
    and a,#7 
    add a,#'0
    call uart_tx 
    jp decode_exit 

; pointer table to grp_1sp_with_prefix mnemonics
mode_1x_prefix_mnemo:    .word M.BSET,M.BRES,M.BCPL,M.BCCM 

; pointer table for grp_1x mnemonics 
mode_1x_mnemo:
    .word M.SUB,M.CP,M.SBC,M.CPW,M.AND,M.BCP,M.LDW,M.LDW 
    .word M.XOR,M.ADC,M.OR,M.ADD,M.ADDW,M.SUBW,M.LDW,M.LDW 

;----------------------
;decode relative jump
; form:  jrxx srel8 
;----------------------
mode_2x:
    tnz (PREFIX,sp)
    jreq 3$
    ld a,#0x72
    cp a,(PREFIX,sp)
    jrne 1$
    jp invalid_opcode
1$: ld a,#0x91
    cp a,(PREFIX,sp)
    jrne 2$
    jp invalid_opcode
2$: ld a,#0x92
    cp a,(PREFIX,sp)
    jrne 3$
    jp invalid_opcode
3$:    
; print relative address byte 
    call peek
    ld (REL,sp),a 
    call print_byte 
; jrxx condition in lower nibble 
; str= precode!=0x90 ? jrxx[y+(cond_code*2)] : jrxx90[y+(cond_code-8)*2]
    ldw y,#jrxx
    ld a,#0xf 
    and a,(OPCODE,sp)
; acc8=cond_code      
    ld acc8,a 
    ld a,#0x90
    cp a,(PREFIX,sp)
    jrne 0$
; if precode==0x90  sub 8 to index and change table
    ld a, acc8
    sub a,#8
    jruge 4$
    jp invalid_opcode
4$: ld acc8,a
    ldw y,#jrxx90 
0$: clr acc16
    sll acc8
    addw y, acc16
; Y= instruction mnemonnic pointer     
    ldw y,(y)
; print instruction mnnemonic  
    call print_mnemonic
; get relative address byte     
    ld a,(REL,sp)
; compute absolute address
    call abs_addr
; print jrxx target address     
    pushw x 
    clrw x 
    ld a,#16
    call print_int 
    popw x 
    jp decode_exit

jrxx: ; 16 codes
; keep in this order, table indexed by lower nibble of opcode
    .word   M.JRA       ; 0x20
    .word   M.JRF       ; 0x21
    .word   M.JRUGT     ; 0x22
    .word   M.JRULE     ; 0x23
    .word   M.JRNC      ; 0x24    
    .word   M.JRC       ; 0x25
    .word   M.JRNE      ; 0x26
    .word   M.JREQ      ; 0x27
    .word   M.JRNV      ; 0x28
    .word   M.JRV       ; 0x29 
    .word   M.JRPL      ; 0x2a
    .word   M.JRMI      ; 0x2b
    .word   M.JRSGT     ; 0x2c
    .word   M.JRSLE     ; 0x2d
    .word   M.JRSGE     ; 0x2e
    .word   M.JRSLT     ; 0x2f

; relative jump with 0x90 precode
jrxx90: ; 6 codes 
    .word   M.JRNH      ; 0x90 0x28
    .word   M.JRH       ; 0x90 0x29
    .word   M.QM,M.QM   ; 0x2a, 0x2b not used
    .word   M.JRNM      ; 0x90 0x2c
    .word   M.JRM       ; 0x90 0x2d
    .word   M.JRIL      ; 0x90 0x2e
    .word   M.JRIH      ; 0x90 0x2f

;---------------------------
; opcode beginning with 0x3n
;---------------------------
mode_3x:
    ld a,#0x72
    cp a,(PREFIX,sp)
    jreq grp_3x_72
    ld a,#0x90
    cp a,(PREFIX,sp)
    jrne 1$
    jp invalid_opcode
1$: ld a,#0x91
    cp a,(PREFIX,sp)
    jrne 2$
    jp invalid_opcode
2$: ld a,#0x92
    cp a,(PREFIX,sp)
    jreq grp_3x_92 
    jp grp_3x_longmem
not_longmem:
    call peek 
    ld (REL,sp),a 
    call print_byte 
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte    
    jp decode_exit
grp_3x_72:
    call get_int16
    ldw (ADR16,sp),y
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,#'[
    call uart_tx 
    ldw y, (ADR16,sp)
    call print_word 
    ld a,#'] 
    call uart_tx 
    jp decode_exit
grp_3x_92:
    call peek 
    ld (REL,sp),a 
    call print_byte 
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,#'[ 
    call uart_tx 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte 
    ld a,#']
    call uart_tx 
    jp decode_exit 

grp_3x_longmem:
    ldw y,#grp_3x_longmem_bc 
1$: ld a,(y) 
    jreq not_longmem        
    cp a,(OPCODE,sp)
    jreq 3$
    incw y 
    jra 1$
3$: ; form: op longmem [,#byte]  
    ld a,#0x35
    cp a,(OPCODE,sp)
    jrne 31$
    call peek 
    ld (REL,sp),a 
    call print_byte 
31$:    
    call get_int16
    ldw (ADR16,sp),y 
4$: 
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,#0x31 
    cp a,(OPCODE,sp)
    jrne 5$
    ld a,#'A 
    call uart_tx
    ld a,#',
    call uart_tx 
5$:
    ldw y,(ADR16,sp)
    call print_word
    ld a,#0x35
    cp a,(OPCODE,sp)
    jrne 6$
    ld a,#',
    call uart_tx 
    ld a,#'#
    call uart_tx 
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte 
6$: jp decode_exit 

; input: A = OPCODE
print_grp3_mnemo:
    and a,#0xf
    sll a 
    ld acc8,a 
    clr acc16 
    ldw y,#grp_3x_mnemo
    addw y,acc16 
    ldw y,(y)
    call print_mnemonic
    ret 

grp_3x_longmem_bc:
    .byte 0x31,0x32,0x35,0x3b,0

grp_3x_mnemo:
    .word M.NEG,M.EXG,M.POP,M.CPL,M.SRL,M.MOV,M.RRC,M.SRA,M.SLL
    .word M.RLC,M.DEC,M.PUSH,M.INC,M.TNZ,M.SWAP,M.CLR

;--------------------
;  opcode beginning with 4
;  prefixes: 0x72, 0x90
;  exceptions: EXG,MUL,MOV,PUSH 
;--------------------
mode_4x:
    ld a,#0x90
    sub a,(PREFIX,sp)
    jrsle 1$
    jp invalid_opcode
1$: ; exceptions: 0x41,0x42,0x45,0x4b 
    ld a,#0x42 ; MUL
    cp a,(OPCODE,sp)
    jrne 2$
; MUL X,A | MUL Y,A 
    ldw y,#M.MUL 
    call print_mnemonic
    ld a,#'X
    tnz (PREFIX,sp)
    jreq 11$
    inc a 
11$:
    call uart_tx 
    ld a,#',
    call uart_tx 
    ld a,#'A 
    call uart_tx     
    jp decode_exit 
2$: ld a,#0x45 ; MOV 
    cp a,(OPCODE,sp)
    jrne 3$
; MOV adr8,adr8 
    call peek
    ld (ADR16,sp),a
    call print_byte
    call peek
    ld (ADR16+1,sp),a
    call print_byte 
    ldw y,#M.MOV
    call print_mnemonic
    ld a,(ADR16,sp)
    call print_byte 
    ld a,#',
    call uart_tx 
    ld a,(ADR16+1,sp)
    call print_byte 
    jp decode_exit
3$: 
    ld a,#0x4b
    jrne 4$
; PUSH adr16   
    call get_int16 
    ld (ADR16,sp),a 
    call print_byte 
    ldw y,#M.PUSH 
    call print_mnemonic 
    ldw y,(ADR16,sp)
    call print_word  
    jp decode_exit
4$:
    ld a,#0x41 ;  EXG A,XL 
    cp a,(OPCODE,sp)
    jrne 5$
; EXG A,XL
    tnz (PREFIX,sp)
    jreq 41$ 
    jp invalid_opcode
41$:    
    ldw y,#exg_a_xl 
    call print_mnemonic
    jp decode_exit
5$:
    tnz (PREFIX,sp)
    jreq 6$
    call get_int16
    ldw (ADR16,sp),y 
    ld a,(OPCODE,sp)
    call print_grp3_mnemo 
    ld a,#'( 
    call uart_tx 
    ldw y, (ADR16,sp)
    call print_word 
    ld a, #',
    call uart_tx 
    ld a,#'X 
    ld (REL,sp),a 
    ld a,#0x72 
    cp a,(PREFIX,sp)
    jrne 51$ 
    inc (REL,sp)
51$:
    ld a,(REL,sp)
    call uart_tx 
    ld a,#') 
    call uart_tx 
    jp decode_exit     
6$: ; no prefix    
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,#'A 
    call uart_tx 
    jp decode_exit 

exg_a_xl: .asciz "EXG A,XL"    

;-------------------
; form:  opw x
; 0x72 form: op add16 
; 0x90 form: opw y 
; excpetions: 
;   0x52 EXGW X,Y
;   0x55 MOV adr16,adr16
;   0x5b ADDW sp,#byte 
;-------------------
mode_5x:
    ld a,#0x90
    cp a,(PREFIX,sp)
    jrsle 1$
    jp invalid_opcode
1$: ; exceptions 0x52,0x55,0x5b
    ld a,#0x52 ; EXGW X,Y
    cp a,(OPCODE,sp)
    jrne 3$ 
    tnz (PREFIX,sp)
    jrne 2$ 
    jp invalid_opcode
2$: ; EXGW X,Y 
    ldw y, #exgw_x_y
    call print_mnemonic
    jp decode_exit
3$: ld a,#0x55 ; MOV adr16,adr16
    cp a,(OPCODE,sp)
    jrne 4$
    tnz (PREFIX,sp)
    jreq 31$
    jp invalid_opcode
31$:  ; MOV adr16,adr16 
    call get_int16
    ldw (ADR16,sp),y
    call get_int16 
    ld a,yh 
    ld (ADR24,sp),a 
    ld a,yl 
    ld (REL,sp),a 
    ldw y,#M.MOV 
    call print_mnemonic
    ldw y, (ADR16,sp)
    call print_word 
    ld a,#',
    call uart_tx 
    ld a,(ADR24,sp)
    ld yh,a 
    ld a,(REL,sp)
    ld yl,a 
    call print_word 
    jp decode_exit 
4$:
    ld a,#0x5b ; ADDW SP,#byte 
    cp a,(OPCODE,sp)
    jrne 6$
; ADDW sp,#byte     
    call peek 
    ld (REL,sp),a 
    call print_byte 
    ldw y,#addw_sp_byte 
    call print_mnemonic
    ld a,(REL,sp)
    call print_byte 
    jp decode_exit 
6$:
    ld a,#0x72 
    cp a,(PREFIX,sp)
    jrne 8$
; op adr16 
    call get_int16 
    ldw (ADR16,sp),y
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ldw y,(ADR16,sp)
    call print_word 
    jp decode_exit 
8$:
    ldw y,#grp_5x_w
    ld a,(OPCODE,sp)
    and a,#0xf 
    sll a 
    ld acc8,a 
    clr acc16 
    addw y,acc16 
    ldw y,(y)
    call print_mnemonic
9$:
    ld a,#'X 
    ld (REL,sp),a 
    tnz (PREFIX,sp)
    jreq 10$ 
    inc (REL,sp)
10$:
    ld a,(REL,sp)
    call uart_tx 
    jp decode_exit

grp_5x_w: .word M.NEGW,M.EXGW,M.QM,M.CPLW,M.SRLW,M.MOV,M.RRCW,M.SRAW
          .word M.SLLW,M.RLCW,M.DECW,M.ADDW,M.INCW,M.TNZW,M.SWAPW,M.CLRW 

exgw_x_y: .asciz "EXGW X,Y"
addw_sp_byte:  .asciz "ADDW SP,#"

mode_6x:
    ldw y,#to.do
    call uart_print 

    jp decode_exit
mode_7x:
    ldw y,#to.do
    call uart_print 

    jp decode_exit



; group with opcode beginning with 0b100, upper nibble 8|9
; table indexed by 5 least significant bits
mode_8x:
mode_9x:
    ld a,#0x1f ; 5 bits mask
    and a,(OPCODE,sp)
    cp a,#0x2
    jrne 1$
    jp opcode_int
1$: cp a,#0xd
    jrne 2$
    jp opcode_callf
2$: ; these opcodes have implicit arguments 
    ldw y,#grp_8x_9x 
    ld acc24+2,a 
    ld a,#0x72
    cp a,(PREFIX,sp)
    jrne 3$
    ld a,#32
    ld acc24+2,a
3$: clr acc24+1 
    sll acc24+2
    addw y,acc24+1
    ldw y,(y)
    call print_mnemonic 
    ld a,#0x1f 
    and a,(OPCODE,sp)
    ld acc24+2,a
    ldw y,#misc_0b100.r.idx
    addw y,acc24+1
    ld a,(y)
    ld acc24+2,a 
    ld a,#0x90 
    cp a,(PREFIX,sp)
    jrne 4$
    inc acc24+2 
4$: sll acc24+2
    ldw y,#reg_ptr 
    addw y,acc24+1
    ldw y,(y)
    call uart_print   
    jp decode_exit

; registers table 
; association between 5 lower bits of misc_0b100 group and registers table
; for each code from 0..31 this table give reg_ptr table entry 
misc_0b100.r.idx:
    .byte 0,0,0,0,1,7,2,0,1,7,2,0,0,0,0,0,0,0,0,10,12,22,14,20,0,0,0,0,0,0,18,16

; grp_8x and grp_9x names pointers char**
; keep it in opcode order, table indexed by 5 lower bits 
grp_8x_9x: ; 32 codes 
    .word M.IRET  ;0x80  
    .word M.RET   ;0x81
    .word M.INT 
    .word M.TRAP
    .word M.POP     ; 0X84 POP A 
    .word M.POPW    ; 0x85/0x90 0x85  POPW X/Y
    .word M.POP     ; 0x86  POP CC 
    .word M.RETF    
    .word M.PUSH    ; 0x88 PUSH A 
    .word M.PUSHW   ; 0x89/0x90 0x89  PUSHW X/Y 
    .word M.PUSH    ; 0x8A  PUSH CC 
    .word M.BREAK 
    .word M.CCF 
    .word M.CALLF   ; 0x8D/0x92 0x8D  CALLF addr24/CALLF [addr16]
    .word M.HALT 
    .word M.WFI 
    .word M.NULL ; used as prefix 0x90
    .word M.NULL ; used as prefix 0x91
    .word M.NULL ; uase as prefix 0x92 
    .word M.LDW  ; 0x93/0x90 0x93  LDW X,Y/Y,X 
    .word M.LDW  ; 0x94/0x90 0x94  LDW SP,X/Y 
    .word M.LD   ; 0x95/0x90 0x95  LD XH/YH,A 
    .word M.LDW  ; 0x96/0x90 0x96  LDW X/Y,SP 
    .word M.LD   ; 0x97/0x90 0x97  LD XL/YL,A 
    .word M.RCF 
    .word M.SCF 
    .word M.RIM 
    .word M.SIM 
    .word M.RVF 
    .word M.NOP ; 
    .word M.LD  ; 0x9e/0x90 0x9e LD A,XH/YH 
    .word M.LD  ; 0x9f/0x90 0x9f LD A,XL/YL
    .word M.WFE ; 0x72 0x8F 

mode_ax:
mode_bx:
mode_cx:
mode_dx:
mode_ex:
mode_fx:

    ldw y,#to.do
    call uart_print 
    jp decode_exit

to.do: .asciz " to be done..."

; take 3 bytes address
opcode_int:
    call get_int24
    ldW (ADR24,sp),y
    ld (ADR24+2,sp),a 
    ldw y,#M.INT 
    call print_mnemonic
    pushw x 
    ldw y,(ADR24,sp)
    ld a,(ADR24+2,sp)
    ldw acc24,y 
    ld acc8,a 
    ld a,#6
    ld xl,a 
    ld a,#16 
    call print_int  
    popw x  
    jp decode_exit 

; callf instruction 
opcode_callf:
    ld a,#0x92
    cp a,(PREFIX,sp)
    jreq 1$
    call get_int24
    jra 2$
1$: call get_int16
2$: ldw y,acc24 
    ldw (ADR24,sp),y 
    ld a,acc8 
    ld (ADR24+2,sp),a  
    ldw y,#M.CALLF 
    call print_mnemonic
    ld a,#0x92 
    cp a,(PREFIX,sp)
    jrne 3$
    ld a,#'[ 
    ld (PREFIX,sp),a 
    ld a,#'] 
    ld (OPCODE,sp),a
    jra 4$
3$: ld a,#SPACE 
    ld (PREFIX,sp),a 
    ld (OPCODE,sp),a 
4$: ld a,(PREFIX,sp)
    call uart_tx 
    ldw y, (ADR24,sp)
    ldw acc24,y 
    ld a,(ADR24+2,sp)
    ld acc8,a 
    pushw x 
    clrw x 
    ld a,#16
    call print_int
    popw x 
    ld a,(OPCODE,sp)
    call uart_tx  
    jp decode_exit

;---------------------------------
; get_int16 
; read two bytes as 16 bits integer  
; print bytes separately
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   Y           16 bits integer 
;   acc24       Y zero extended    
;   X           incremented by 2
;--------------------------------
    ADDR16 = 1
    LOCAL_SIZE = 2
get_int16:
    sub sp,#LOCAL_SIZE
    call peek 
    ld (ADDR16,sp),a 
    call print_byte 
    call peek 
    ld (ADDR16+1,sp),a 
    call print_byte
    ldw y, (ADDR16,sp)
    ldw acc16,y
    clr acc24 
    addw sp,#LOCAL_SIZE 
    ret 

;--------------------------------
;  get_int24
;  read 3 bytes as a 24 bits integer 
;  print bytes separately
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   Y           bits 23:16 of integer
;   A           bits 7:0  of integer 
;   acc24       24 bits integer   
;   X           incremented by 3
;---------------------------------
    ADDR24 = 1 
    LOCAL_SIZE=3
get_int24:
    sub sp,#LOCAL_SIZE
    call peek
    ld (ADDR24,sp),a 
    call print_byte 
    call peek 
    ld (ADDR24+1,sp),a 
    call print_byte 
    call peek 
    ld (ADDR24+2,sp),a 
    call print_byte 
    ldw y,(ADDR24,sp)
    ldw acc24,y 
    ld a, (ADDR24+2,sp)
    ld acc8,a 
    addw sp,#LOCAL_SIZE
    ret 

;----------------------------
;print instruction mnemonic 
;pad with spaces for contant 
;8 charaters field width
; input:
;   y       pointer to string 
; use:
;   A       for field width 
;----------------------------
print_mnemonic:
    push a
    pushw x 
    ld a,#4
    mul x,a  
    ld a,xl 
    ld acc8,a 
    ld a,#24
    sub a,acc8  
    call spaces 
    popw x 
    ld a,#6
    call print_padded 
    pop a 
    ret 

;---------------------------------
; compute absolute address 
; from relative address 
; input:
;   A       rel8 
;   X       table index, farptr[X]
;   farptr  location pointer 
; output:
;   acc24    absolute address 
;----------------------------------
abs_addr:
    pushw x 
    push a 
    clr a 
    addw x,farptr+1
    adc a,farptr
    ld acc24,a 
    ldw acc16,x
    pop a 
 ; sign extend a in x 
    clrw x 
    cp a,#128 
    jrult 1$
    cplw x 
1$: add a, acc8 
    ld acc8,a 
    ld a,xl 
    adc a,acc16 
    ld acc16,a 
    ld a,xh 
    adc a,acc24 
    ld acc24,a 
    popw x 
    ret





