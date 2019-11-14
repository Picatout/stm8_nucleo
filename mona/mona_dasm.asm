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
    PRE_CODE = 1 ; opcode prefix 
    OPCODE = 2 ; operating code 
    ADR24 = 3  ; addr24 absolute address
    ADR16 = 4  ; add16 absolute address 
    REL = 6 ; addr8 relative address 
    LOCAL_SIZE=6 ;
decode:
    sub sp,#LOCAL_SIZE 
    clrw x 
    call peek   
    ld a, acc8
    ld (OPCODE,sp),a 
    call print_byte  
    call is_precode
    ld (PRE_CODE,sp),a 
    cp a,#0
    jreq 1$
; get opcode
    call peek 
    ld a,acc8
    ld (OPCODE,sp),a  
    call print_byte
1$:
    ld a,#0xf0 
    and a,(OPCODE,sp)
    cp  a,#0x20 
    jrne 2$
    jp reljump ; this is a relative jump
2$:
    cp a,#0
    jrne 3$
    jp group_0sp
3$:
    cp a,#0x10 
    jrne 4$
    jp group_1sp  
4$:
    ld a,#0xe0
    and a,(OPCODE,sp)
    cp a,#0x80  ; 3 most significants bits are 100
    jrne 5$
    jp misc_0b100
5$:
    ld a,#0xf0 
    and a,(OPCODE,sp)
    cp a,#0x30
    jrne 6$
    jp grp_3x
6$: 
    cp a,#3 
    jrne 7$
    jp grp_3x 
7$:    
    ldw y, #invalid_code
    call print_mnemonic
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


; form: op (off8,sp)
group_0sp:
    ld a,#0x72 
    cp a,(PRE_CODE,sp)
    jreq btjr
    ld a,#1
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
    tnz (PRE_CODE,sp)
    jreq 3$
    inc a
3$: call uart_tx
    jp decode_exit
4$: tnz (PRE_CODE,sp)
    jrne 5$
    call peek
    call print_byte 
    ld a,(OPCODE,sp)
    and a,#0xf
    ld acc24+2,a  
    sll acc24+2
    clr acc24+1
    ldw y, #grp_0sp_op 
    addw y,acc24+1
    ldw y,(y)
    call print_mnemonic 
    ld a,#'( 
    call uart_tx
    decw x 
    call peek
    call print_byte 
    ld a,#', 
    call uart_tx 
    ldw y,#R.SP 
    call uart_print  
    ld a,#')
    call uart_tx 
    jp decode_exit 
5$: 
    
    jp decode_exit

; test bit and jump relative 
; btjt add16,#bit,rel | btjf add16,#bit,rel  
; prefix 0x72
; btjt 0000bbb0
; btjf 0000bbb1
btjr:
    call get_addr16
    ldw y, acc16
    ldw (ADR16,sp),y 
    call peek 
    ld a,acc8 
    ld (REL,sp),a 
    call print_byte 
    ld a, (OPCODE,sp) 
    ldw y, #M.BTJT
    and a,#1
    jreq 1$
    ldw y, #M.BTJF  
1$: call print_mnemonic
    ldw y, (ADR16,sp)
    ldw acc16,y 
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

; pointer table for group_0sp mnemonics 
grp_0sp_op:
    .word M.NEG,M.RRWA,M.RLWA,M.CPL,M.SRL,M.NULL,M.RRC,M.SRA,M.NULL
    .word M.RLC,M.DEC,M.NULL,M.INC,M.TNZ,M.SWAP,M.CLR 


; form: op a,(off8,sp)
group_1sp:
    ld a,(PRE_CODE,sp)
    jreq 1$
    jp grp_1sp_with_prefix
1$: ; no prefix 
    call peek 
    ld a, acc8 
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
    ld a,acc8 
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
    ld acc8,a
    ld a,(REL,sp)
    ld acc16,a  
    call print_word 
    jp decode_exit 
14$:    
    ld a,#0xf 
    and a,(OPCODE,sp)
    sll a 
    ld acc8, a 
    clr acc16 
    ldw y,#grp_1sp_op
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

; form:  op addr16,#bit,rel  
grp_1sp_with_prefix:
    call get_addr16 
    ldw y,acc16  
    ldw (ADR16,sp),y 
    clr acc16 
    clr acc8 
    ld a,#0x72 
    cp a,(PRE_CODE,sp)
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
2$: ldw y, #grp_1sp_prefix_mnemo
    addw y,acc16     
    ldw y,(y) 
    call print_mnemonic
    ldw y, (ADR16,sp)
    ldw acc16,y 
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
grp_1sp_prefix_mnemo:    .word M.BSET,M.BRES,M.BCPL,M.BCCM 


; pointer table for group_1sp mnemonics 
grp_1sp_op:
    .word M.SUB,M.CP,M.SBC,M.CPW,M.AND,M.BCP,M.LDW,M.LDW 
    .word M.XOR,M.ADC,M.OR,M.ADD,M.ADDW,M.SUBW,M.LDW,M.LDW 


;decode relative jump
reljump:
; print relative address byte 
    call peek
    ld a, acc8
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
    cp a,(PRE_CODE,sp)
    jrne 0$
; if precode==0x90  sub 8 to index and change table
    ld a, acc8
    sub a,#8
    ld acc8,a
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


;opcode beginning with 0x3n
grp_3x:
    ld a,#0x72
    cp a,(PRE_CODE,sp)
    jreq grp_3x_72
    ld a,#0x92
    cp a,(PRE_CODE,sp)
    jreq grp_3x_92 
    jp grp_3x_longmem
not_longmem:
    call peek 
    ld a,acc8 
    ld (REL,sp),a 
    call print_byte 
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,(REL,sp)
    ld acc8,a 
    call print_byte    
    jp decode_exit
grp_3x_72:
    call get_addr16
    ldw y,acc16 
    ldw (ADR16,sp),y
    ld a,(OPCODE,sp)
    call print_grp3_mnemo
    ld a,#'[
    call uart_tx 
    ldw y, (ADR16,sp)
    ldw acc16,y 
    call print_word 
    ld a,#'] 
    call uart_tx 
    jp decode_exit
grp_3x_92:
    call peek 
    ld a,acc8 
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
    ld a,acc8 
    ld (REL,sp),a 
    call print_byte 
31$:    
    call get_addr16
    ldw y,acc16
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
    ldw acc16,y 
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

; group with opcode beginning with 0b100
; table indexed by 5 least significant bits
misc_0b100:
    ld a,#0x1f ; 5 bits mask
    and a,(OPCODE,sp)
    cp a,#0x2
    jrne 1$
    jp opcode_int
1$: cp a,#0xd
    jrne 2$
    jp opcode_callf
2$: ; these opcodes have implicit arguments 
    ldw y,#misc100_ptr 
    ld acc24+2,a 
    ld a,#0x72
    cp a,(PRE_CODE,sp)
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
    cp a,(PRE_CODE,sp)
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

misc_0b0001:

    jp decode_exit 


; take 3 bytes address
opcode_int:
    pushw x 
    call peek
    call print_byte
    call peek
    call print_byte
    call peek
    call print_byte
    popw x 
    call peek24 
    ldw y,#M.INT 
    call print_mnemonic
    pushw x 
    ld a,#6
    ld xl,a 
    ld a,#16 
    call print_int  
    popw x  
    jp decode_exit 

; callf instruction 
opcode_callf:
    ld a,#0x92
    cp a,(PRE_CODE,sp)
    jreq 1$
    call get_addr24
    jra 2$
1$: call get_addr16
2$: ldw y,acc24
    ldw (ADR24,sp),y 
    ld a,acc8 
    ld (REL,sp),a  
    ldw y,#M.CALLF 
    call print_mnemonic
    ld a,#0x92 
    cp a,(PRE_CODE,sp)
    jrne 3$
    ld a,#'[ 
    ld (PRE_CODE,sp),a 
    ld a,#'] 
    ld (OPCODE,sp),a
    jra 4$
3$: ld a,#SPACE 
    ld (PRE_CODE,sp),a 
    ld (OPCODE,sp),a 
4$: ld a,(PRE_CODE,sp)
    call uart_tx 
    ldw y, (ADR24,sp)
    ldw acc24,y 
    ld a,(REL,sp)
    ld acc8,a 
    pushw x 
    clrw x 
    ld a,#16
    call print_int
    popw x 
    ld a,(OPCODE,sp)
    call uart_tx  
    jp decode_exit

; read two bytes address in acc16 
;  print bytes 
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   acc16       16 bits address   
;   X           incremented by 2
    ADDR16 = 1
    LOCAL_SIZE = 2
get_addr16:
    sub sp,#LOCAL_SIZE
    call peek 
    call print_byte 
    decw x 
    ldf a,([farptr],x)
    ld (ADDR16,sp),a 
    incw x 
    call peek 
    call print_byte
    decw x  
    ldf a,([farptr],x)
    ld (ADDR16+1,sp),a 
    incw x 
    ldw y, (ADDR16,sp)
    ldw acc16,y
    clr acc24
    addw sp,#LOCAL_SIZE 
    ret 

;  read 3 bytes address in acc24 
;  print bytes 
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   acc24       24 bits address   
;   X           incremented by 3
    ADDR24 = 1 
    LOCAL_SIZE=3
get_addr24:
    sub sp,#LOCAL_SIZE
    call peek 
    call print_byte 
    decw x 
    ldf a,([farptr],x)
    ld (ADDR24,sp),a 
    incw x 
    call peek 
    call print_byte 
    decw x 
    ldf a,([farptr],x)
    ld (ADDR24+1,sp),a 
    incw x 
    call peek 
    call print_byte 
    decw x 
    ldf a,([farptr],x)
    ld (ADDR24+2,sp),a 
    incw x 
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

invalid_code:  .asciz "?"


; opcode prefixes 
prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  


