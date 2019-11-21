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
    .module DASM 
    .nlist
    .include "../inc/ascii.inc"
	.include "mona.inc"
    .include "mnemonics.inc"
    .list 

    .area CODE
.ascii "DASM"
;-----------------------------------------------
;  addressing mode format string
; 
;       r      register
;       b      bit position 
;       imm8   byte immediate value 
;       imm16  word immediate value 
;       extd   24 bits address 
;       ofs8   short offset
;       ofs16  long offset
;       ptr8   short pointer
;       ptr16  long pointer 
;       adr    direct address value 
;       ind    indirect address in register X|Y|SP 
;       rel    relative address
;-----------------------------------------------
fmt_bad_op: .asciz "invalid operating code"
fmt_r_imm8: .asciz "%s,#%b"  ; i.e. ld a,#$55
fmt_r_imm16:  .asciz "%s,#%w"  ; i.e. ldw x,#$55aa
fmt_r_adr8: .asciz "%s,%b"   ; i.e. ld a,$55
fmt_adr8_r: .asciz "%a,%s"  ; i.e. ld $55,a
fmt_r_adr16: .asciz "%s,%w"    ; i.e. ldw x,$55aa
fmt_adr16_r: .asciz "%w,%s" ; i.e. ldw $55aa,x  
fmt_extd: .asciz "%e"  ; i.e. int $a012, callf $17f00, jpf $26600 
fmt_adr16: .asciz "%w"  ; i.e. call $8426, jp $9027  
fmt_adr16_b_rel: .asciz "%w,#%c,%e" ; i.e. btjt $1000,#1,4$ 
fmt_r_ind: .asciz "%s,(%s)"  ; i.e. ld a,(x)
fmt_r_ofs8_ind: .asciz "%s,(%b,%s)"  ; i.e. ld a,($50,x)
fmt_r_ofs16_ind: .asciz "%s,(%w,%s)"   ; i.e. ld y,($1005,x)
fmt_r_ptr8: .asciz "%s,[%b]"  ; i.e. ld a,[$c0]
fmt_r_ptr16: .asciz "%s,[%w]"    ; i.e. ldw x,[$a040]
fmt_r_ptr8_ind: .asciz "%s,([%b],%s)" ; i.e. ldw x,([$c0],x)
fmt_r_ptr16_ind: .asciz "%s,([%w],%s)"  ; i.e. ld a,([$a000],y)
fmt_r_r: .asciz "%s,%s"  ; i.e. exgw x,y 
fmt_ofs8_ind: .asciz "(%b,%s)"; i.e. inc ($5,sp)
fmt_ofs16_ind:  .asciz "(%w,%s)" ; i.e. cpl ($1000,x)
fmt_adr16_bit: .asciz "%w,#%b" ; i.e. bset $1000,#1
fmt_adr16_bit_rel: .asciz "%w,#%b,%w" ; i.e. btjt $1000,#7,$c0000

; format index values
    IDX.FMT_BAD_OP = 0
    IDX.FMT_OFS8_IND = 1
    IDX.FMT_ADR16_B_REL = 2

; format indexed table 
fmt_index:
    .word fmt_bad_op ; 0 
    .word fmt_ofs8_ind ; 1
    .word fmt_adr16_b_rel ; 2


; decoder functions index values 
    IDX.FN_BAD_OP = 0 
    IDX.FN_OFS8_IND = 1     
    IDX.FN_ADR16_B_REL = 2
; decoder function indexed table
fn_index:
    .word fn_bad_op ; 0 
    .word fn_ofs8_ind ; 1 
    .word fn_adr16_b_rel ; 2 


;-------------------------------------
;  each opcode as a table entry 
;  that give information on how to 
;  decode it.
;  each entry is a structure.
;  each element of structure is an index for other tables 
;       .byte opcode ; operating code
;       .byte mnemo_idx ; instruction mnemonic index
;       .byte  fmt_idx ; format use to print decoded instruction index
;       .byte fn* ;   decoder function index  
;       .byte dest;  destination index 
;       .byte src;   src index        
;  A 0 in mnemonic field mark end of table 
;-------------------------------------
    FIELD_OPCODE = 0;
    FIELD_MNEMO= 1; 
    FIELD_FMT=2;
    FIELD_FN=3;
    FIELD_DEST=4;
    FIELD_SRC=5 
    STRUCT_SIZE=6 ;


; table for opcodes without prefix 
codes:
    .byte 0,IDX.NEG,IDX.FMT_OFS8_IND,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 

    .byte 0,0,0,0,0,0

; table for opcodes with 0x72 prefix 
p72_codes:
    .byte 0,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 1,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 2,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 3,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 4,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 5,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 6,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 7,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 8,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 9,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 10,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 11,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 12,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 13,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 14,IDX.BTJT,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 15,IDX.BTJF,IDX.FMT_ADR16_B_REL,IDX.FN_ADR16_B_REL,0,0  
    .byte 0,0,0,0,0,0

; table for opcodes with 0x90 prefix 
p90_codes:
    .byte 0,IDX.QM,IDX.FMT_BAD_OP,IDX.FN_BAD_OP,0,0,0
    .byte 0,0,0,0,0,0

; table for opcodes with 0x91 prefix 
p91_codes:

    .byte 0,0,0,0,0,0

; table of indexes for opcodes with 0x92 prefix 
p92_codes:
    
    .byte 0,0,0,0,0,0


;---------------------------
; search code in table  
; input:
;   Y       pointer to table
;   A       opcode to verify
; output:
;   Y       pointer to entry 
;   C       carry flag set if found cleared otherwise 
;---------------------------
search_code:
    push a 
    bset flags,#F_FOUND 
1$: ld a,(FIELD_MNEMO,y)
    jreq 8$ 
    ld a,(FIELD_OPCODE,y)
    cp a,(1,sp)
    jreq 9$
    addw y,#STRUCT_SIZE
    jra 1$
8$: bres flags,#F_FOUND 
9$: pop a 
    ret 

;-----------------------------------
; desassembler main function
;-----------------------------------
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
    clr a 
    addw x,farptr+1
    adc a,farptr
    ld farptr,a 
    ldw farptr+1,x 
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
    LOCAL_SIZE=2 ;
decode:
    sub sp,#LOCAL_SIZE 
    clrw x 
    call get_int8    
    ld (OPCODE,sp),a 
    call is_prefix 
    ld (PREFIX,sp),a 
    cp a,#0
    jrne 0$
    ldw y,#codes 
    jra 6$
; get opcode
0$: call get_int8 
    ld (OPCODE,sp),a  
    ld a,(PREFIX,sp)
1$: cp a,#0x72 
    jrne 2$
    ldw y,#p72_codes
    jra 6$
2$: cp a,#0x90
    jrne 3$
    ldw y,#p90_codes
    jra 6$
3$: cp a,#0x91 
    jrne 4$
    ldw y,#p91_codes
    jra 6$ 
4$: ldw y,#p92_codes 
6$: ld a,(OPCODE,sp)
    call search_code
    btjf flags,#F_FOUND,invalid_opcode
    pushw y 
    ld a,(FIELD_FN,y)
    ldw y,#fn_index
    call ld_table_entry
    call (y)
    popw y 
    jra decode_exit 
invalid_opcode: 
    ldw y, #M.QM
    call print_mnemonic
decode_exit:    
    addw sp,#LOCAL_SIZE 
    ret



;-------------------------------
; check if byte is a opcode prefix  
; input:
;   A       value to check
; output:
;   A       prefix or 0.
;-------------------------------
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

;---------------------------
;  opcode invalid 
;---------------------------
fn_bad_op:
    ld a,(FIELD_FMT,y)
    ldw y,#mnemo_index 
    call ld_table_entry
    call uart_print 
    ret 

;----------------------------
;  decode format: op (ofs8,r)
;----------------------------
    LOCAL_SIZE=3
    OFS8=1  ; byte offset value 
    REG=2 ; pointer to register name
    STRUCT_PTR =3+LOCAL_SIZE 
fn_ofs8_ind:
    sub sp,#LOCAL_SIZE 
    call get_int8 
    ld (OFS8,sp),a 
    ldw y,(STRUCT_PTR,sp)
    ld a,(FIELD_MNEMO,Y)
    ldw y,#mnemo_index 
    call ld_table_entry
    call print_mnemonic
    ldw y,(STRUCT_PTR,sp)
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,(STRUCT_PTR,sp)
    ld a,(FIELD_FMT,y)
    ldw y,#fmt_index
    call ld_table_entry
    call format 
    addw sp,#LOCAL_SIZE 
    ret 

;--------------------------------
; decode form: op adr16,#bit,rel 
;--------------------------------
    LOCAL_SIZE=6
    ADR16=1
    BIT=3
    REL=4
    STRUCT=3+LOCAL_SIZE 
fn_adr16_b_rel:
    sub sp,#LOCAL_SIZE 
    call get_int16
    ldw (ADR16,sp),y
    call get_int8
    call abs_addr
    ldw y,acc24
    ld a,acc8 
    ldw (REL,sp),y
    ld (REL+2,sp),a   
    ldw y,(STRUCT,sp)
    ld a,(FIELD_OPCODE,y)
    srl a 
    and a,#7 
    add a,#'0 
    ld (BIT,sp),a
    ld  a,(FIELD_MNEMO,y)
    ldw y,#mnemo_index
    call ld_table_entry
    call print_mnemonic
    ldw y,(STRUCT,sp)  
    ld a,(FIELD_FMT,y)
    ldw y,#fmt_index 
    call ld_table_entry
    call format
    addw sp,#LOCAL_SIZE 
    ret


;---------------------------------
; get_int8 
; read 1 byte from code 
; print byte in hexadecimal
; input:
;   farptr  pointer to code 
;   X       index for farptr 
; output:
;   A       byte read 
;   acc24   A sign extended to 24 bits 
;   X       incremented by 1
;---------------------------------
get_int8:
    call peek
    push a 
    call print_byte 
    pop a 
    ld acc8,a 
    clr acc16
    clr acc24
    btjf acc8,#7,1$
    cpl acc16 
    cpl acc24 
1$:          
    ret

;---------------------------------
; get_int16 
; read two bytes as 16 bits integer 
; form code space  
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
;  from code space 
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
    ld acc8,a 
    clr acc16 
    clr acc24
    btjf acc8,#7,1$
    cpl acc16 
    cpl acc24 
1$: clr a 
    addw x,farptr+1 
    adc a,farptr 
    addw x,acc16 
    adc a,acc24 
    ld acc24,a 
    ldw acc16,x
    popw x 
    ret

;--------------------------------
; y = y[2*A]
; input:
;   Y     address of .word table 
;   A     index in table 
; output:
;   Y     Y=Y[2*A]
;--------------------------------
ld_table_entry:
    sll a 
    ld acc8,a 
    clr acc16 
    addw y,acc16 
    ldw y,(y)
    ret 
    




