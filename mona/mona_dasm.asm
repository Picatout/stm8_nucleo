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


; form op (off8,sp)
group_0sp:
    ld a,#1
    cp a,(OPCODE,sp)
    jrne 1$
    ld a,#TAB 
    call uart_tx 
    ldw y, #M.RRWA 
    call uart_print 
    jra 2$
1$: ld a,#2
    cp a,(OPCODE,sp)
    jrne 4$
    ld a,#TAB 
    call uart_tx 
    ldw y, #M.RLWA 
    call uart_print 
2$: ld a,#SPACE 
    call uart_tx 
    ld a,#'X 
    tnz (PRE_CODE,sp)
    jreq 3$
    inc a
3$: call uart_tx
    jp decode_exit
4$: tnz (PRE_CODE,sp)
    jrne 5$
    ld a,#16 
    call peek
    ld a,#TAB 
    call uart_tx     
    ld a,(OPCODE,sp)
    and a,#0xf
    ld acc24+2,a  
    sll acc24+2
    clr acc24+1
    ldw y, #grp_0sp_op 
    addw y,acc24+1
    ldw y,(y)
    call uart_print 
    ld a,#SPACE
    call uart_tx 
    ld a,#'( 
    call uart_tx
    ld a,#16
    call peek
    incw x
    ld a,#', 
    call uart_tx 
    ldw y,#R.SP 
    call uart_print  
    ld a,#')
    call uart_tx 
    jp decode_exit 
5$: 
    
    jp decode_exit

; pointer table for group_0sp mnemonics 
grp_0sp_op:
    .word M.NEG,M.RRWA,M.RLWA,M.CPL,M.SRL,M.NULL,M.RRC,M.SRA,M.NULL
    .word M.RLC,M.DEC,M.NULL,M.INC,M.TNZ,M.SWAP,M.CLR 


; form op a,(off8,sp)
group_1sp:


    jp decode_exit
; pointer table for group_1sp mnemonics 
grp_1sp_op:
    .word M.SUB,M.CP,M.SBC,M.CPW,M.AND,M.BCP,M.LDW,M.LDW 
    .word M.XOR,M.ADC,M.OR,M.ADD,M.ADDW,M.SUBW,M.LDW,M.LDW 


;decode relative jump
reljump:
; print relative address byte 
    ld a,#16
    call peek
    ld a,#TAB
    call uart_tx
; jrxx condition in lower nibble 
; str= precode!=0x90 ? jrxx[y+(cond_code*2)] : jrxx90[y+(cond_code-8)*2]
    ldw y,#jrxx
    ld a,#0xf 
    and a,(OPCODE,sp)
; acc24+2=cond_code      
    ld acc24+2,a 
    ld a,#0x90
    cp a,(PRE_CODE,sp)
    jrne 0$
; if precode==0x90  sub 8 to index and change table
    ld a, acc24+2 
    sub a,#8
    ld acc24+2,a
    ldw y,#jrxx90 
0$: clr acc24+1
    sll acc24+2 
    addw y, acc24+1
; Y= instruction mnemonnic pointer     
    ldw y,(y)
; print instruction mnnemonic  
    call uart_print
; get relative address byte     
    ldf a, ([farptr],x)
    incw x
; compute absolute address
; local variable 
    JR = 1    ; jrxx address extended to 24 bits 
    LOCAL_SIZE=3
    pushw x   ; preserve X 
    sub sp,#LOCAL_SIZE ;
    ld (JR+2,sp),a 
; sign extend to 24 bits 
    clr (JR+1,sp)   ; rel jump 15:8 
    clr (JR,sp)     ; rel jump 23:16       
    cp a,#128
    jrult 1$
; A<0 then sign extend negative
    cpl (JR+1,sp)
    cpl (JR,sp)
;  copy X in acc24 , signt extend to 24 bits      
1$: ldw acc24+1,x 
    clr acc24    
; first skip after this instruction bytes     
    ldw x,#acc24 
    ldw y,#farptr
    call add24 
;target address = acc24+(JR,sp) 
    ldw x, #acc24  
    ldw y, sp 
    incw y   ; now Y point to (JR,sp)
    call add24   ; acc24=acc24+(JR,sp)
    addw sp, #LOCAL_SIZE ; drop JR  
    popw x ; restore X initial value  
; print jrxx target address     
    ld a,#SPACE 
    call uart_tx 
    ld a,#16 
    call itoa 
    call uart_print
    jp decode_exit

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
    ld a,#TAB 
    call uart_tx 
    ldw y,(y)
    call uart_print ; print menonic 
    ld a,#SPACE 
    call uart_tx 
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


; take 3 bytes address
opcode_int:
    call get_addr24 
    ldw y,#M.INT 
    call uart_print
    ld a,#SPACE 
    call uart_tx
    ld a,#16 
    call itoa 
    call uart_print 
    jp decode_exit 

opcode_callf:
    ld a,#0x92
    cp a,(PRE_CODE,sp)
    jreq 1$
    call get_addr24 
    jra 2$
1$: call get_addr16 
2$: ldw y,#M.CALLF 
    call uart_print
    ld a,#SPACE 
    call uart_tx
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
    ld a,#16
    call itoa 
    call uart_print
    ld a,(OPCODE,sp)
    call uart_tx  
    jp decode_exit

; read two bytes address in acc24
;  print bytes 
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   acc24       16 bits address   
;   X           incremented by 2
    ADDR16 = 1
    LOCAL_SIZE = 2
get_addr16:
    sub sp,#LOCAL_SIZE
    ld a,#16 
    call peek 
    ldf a,([farptr],x)
    ld (ADDR16,sp),a 
    incw x 
    ld a,#16 
    call peek 
    ldf a,([farptr],x)
    ld (ADDR16+1,sp),a 
    incw x 
    ldw y, (ADDR16,sp)
    ldw acc24+1,y
    clr acc24
    addw sp,#LOCAL_SIZE 
    ld a,#TAB 
    call uart_tx 
    ret 

;  read 3 bytes address in acc24 
;  print bytes 
; input:
;   farptr      pointer to code 
;   X           index for farptr 
; output:
;   acc24       16 bits address   
;   X           incremented by 3
    ADDR24 = 1 
    LOCAL_SIZE=3
get_addr24:
    sub sp,#LOCAL_SIZE
    ld a,#16 
    call peek 
    ldf a,([farptr],x)
    ld (ADDR24,sp),a 
    incw x 
    ld a,#16 
    call peek 
    ldf a,([farptr],x)
    ld (ADDR24+1,sp),a 
    incw x 
    ld a,#16 
    call peek 
    ldf a,([farptr],x)
    ld (ADDR24+2,sp),a 
    incw x 
    ldW y,(ADDR24,sp)
    ldw acc24,y 
    ld a, (ADDR24+2,sp)
    ld acc24+2,a 
    addw sp,#LOCAL_SIZE
    ld a,#TAB 
    call uart_tx 
    ret 

; opcode prefixes 
prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  


