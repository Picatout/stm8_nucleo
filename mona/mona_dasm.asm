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

; decoder functions index values 
    IDX.FN_IMPL = 0 
    IDX.FN_OFS8_IDX = 1     
    IDX.FN_ADR16_B_REL = 2
    IDX.FN_ADR16_B = 3
    IDX.FN_R_OFS8_IDX = 4 
    IDX.FN_R_IMM8 = 5
    IDX.FN_R_IMM16 = 6 
    IDX.FN_R_IDX = 7
    IDX.FN_IDX_R = 8 
    IDX.FN_REL8 = 9 
    IDX.FN_R_ADR8 = 10
    IDX.FN_R_ADR16 = 11 
    IDX.FN_IMM8 = 12 
    IDX.FN_ADR16 = 13 
    IDX.FN_ADR24 = 14 
    IDX.FN_ADR8_R = 15
    IDX.FN_ADR16_R = 16 
    IDX.FN_ADR24_R = 17
    IDX.FN_R_ADR24 = 18
    IDX.FN_ADR16_IMM8 = 19 
    IDX.FN_ADR16_ADR16=20
    IDX.FN_ADR8_ADR8=21 
    IDX.FN_ADR8 = 22 
    IDX.FN_R_PTR8 = 23
    IDX.FN_R_PTR16 = 24
    IDX.FN_PTR8_R = 25 
    IDX.FN_PTR16_R = 26 
    IDX.FN_R_PTR8_IDX = 27 
    IDX.FN_R_PTR16_IDX = 28 
    IDX.FN_PTR8_IDX_R = 29 
    IDX.FN_PTR16_IDX_R = 30
    IDX.FN_OFS8_IDX_R = 31 
    IDX.FN_OFS16_IDX = 32
    IDX.FN_R_OFS16_IDX = 33 
    IDX.FN_OFS16_IDX_R= 34 
    IDX.FN_R_OFS24_IDX=35
    IDX.FN_OFS24_IDX_R=36 
    IDX.FN_PTR16 = 37 
    IDX.FN_PTR8 = 38 
    IDX.FN_PTR16_IDX=39
    IDX.FN_PTR8_IDX=40 

; decoder function indexed table
fn_index:
    .word fn_implied ; 0 
    .word fn_ofs8_idx ; 1 
    .word fn_adr16_b_rel ; 2 
    .word fn_adr16_bit ; 3 
    .word fn_r_ofs8_idx ; 4
    .word fn_r_imm8 ; 5
    .word fn_r_imm16 ; 6
    .word fn_r_idx ; 7
    .word fn_idx_r ; 8 
    .word fn_rel8 ; 9 
    .word fn_r_adr8 ; 10
    .word fn_r_adr16 ; 11
    .word fn_imm8 ; 12
    .word fn_adr16 ; 13 
    .word fn_adr24 ; 14 
    .word fn_adr8_r ; 15
    .word fn_adr16_r ; 16
    .word fn_adr24_r ; 17 
    .word fn_r_adr24 ; 18 
    .word fn_adr16_imm8 ; 19 
    .word fn_adr16_adr16 ; 20 
    .word fn_adr8_adr8 ; 21
    .word fn_adr8 ; 22 
    .word fn_r_ptr8 ; 23 
    .word fn_r_ptr16 ; 24
    .word fn_ptr8_r ; 25 
    .word fn_ptr16_r ; 26
    .word fn_r_ptr8_idx ; 27
    .word fn_r_ptr16_idx ; 28 
    .word fn_ptr8_idx_r ; 29 
    .word fn_ptr16_idx_r ; 30 
    .word fn_ofs8_idx_r ; 31 
    .word fn_ofs16_idx  ; 32 
    .word fn_r_ofs16_idx ; 33 
    .word fn_ofs16_idx_r ; 34 
    .word fn_r_ofs24_idx; 35
    .word fn_ofs24_idx_r; 36 
    .word fn_ptr16; 37 
    .word fn_ptr8 ; 38 
    .word fn_ptr16_idx ; 39 
    .word fn_ptr8_idx ; 40 
;-------------------------------------
;  each opcode as a table entry 
;  that give information on how to 
;  decode it.
;  each entry is a structure.
;  each element of structure is an index for other tables 
;       .byte opcode ; operating code
;       .byte mnemo_idx ; instruction mnemonic index
;       .byte fn* ;   decoder function index  
;       .byte dest;  destination index 
;       .byte src;   src index        
;  A 0 in mnemonic field mark end of table 
;-------------------------------------
    FIELD_OPCODE = 0;
    FIELD_MNEMO= 1; 
    FIELD_FN=2;
    FIELD_DEST=3;
    FIELD_SRC=4 
    STRUCT_SIZE=5 ;


; table for opcodes without prefix 
codes:
    ; form op (ofs8,r)  0x0n 0x6n 0xED
    .byte 0x00,IDX.NEG,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x03,IDX.CPL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x04,IDX.SRL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x06,IDX.RRC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x07,IDX.SRA,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x08,IDX.SLL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x09,IDX.RLC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x0a,IDX.DEC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x0c,IDX.INC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x0d,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x0e,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x0f,IDX.CLR,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
    .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.X,IDX.X 
    .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
    ; form op r,(ofs8,r) 0x1n 0x7B 0xEn
    .byte 0x10,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x11,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x12,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x13,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
    .byte 0x14,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x15,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x16,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
    .byte 0x18,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x19,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x1A,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x1B,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0x1E,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
    .byte 0x7B,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
    .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.X
    .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
    .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.X
    ;form op r,(ofs16,r)
    .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    ;form op (ofs16,r),r 
    .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.X,IDX.Y 
    ;form op (ofs8,r),r 
    .byte 0x17,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.Y
    .byte 0x1F,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.X
    .byte 0x6B,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.A 
    .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.X,IDX.A 
    .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.X,IDX.Y 
    ; opcode with implied arguments 0x4n 0x5n 0x8n 0x9n 
    .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.X,0
    .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.X,0
    .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0 
    .byte 0x41,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.XL
    .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.X,IDX.A 
    .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
    .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0 
    .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0 
    .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0 
    .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0 
    .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0 
    .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0 
    .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0 
    .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0 
    .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0 
    .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
    .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.X,0 
    .byte 0x51,IDX.EXGW,IDX.FN_IMPL,IDX.X,IDX.Y
    .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.X,0
    .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.X,0
    .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.X,0
    .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.X,0
    .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.X,0
    .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.X,0 
    .byte 0x61,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.YL
    .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.X,IDX.A
    .byte 0x65,IDX.DIVW,IDX.FN_IMPL,IDX.X,IDX.Y
    .byte 0x80,IDX.IRET,IDX.FN_IMPL,0,0
    .byte 0x81,IDX.RET,IDX.FN_IMPL,0,0
    .byte 0x83,IDX.TRAP,IDX.FN_IMPL,0,0
    .byte 0x84,IDX.POP,IDX.FN_IMPL,IDX.A,0
    .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.X,0
    .byte 0x86,IDX.POP,IDX.FN_IMPL,IDX.CC,0
    .byte 0x87,IDX.RETF,IDX.FN_IMPL,0,0
    .byte 0x88,IDX.PUSH,IDX.FN_IMPL,IDX.A,0
    .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.X,0
    .byte 0x8A,IDX.PUSH,IDX.FN_IMPL,IDX.CC,0
    .byte 0x8B,IDX.BREAK,IDX.FN_IMPL,0,0
    .byte 0x8C,IDX.CCF,IDX.FN_IMPL,0,0
    .byte 0x8E,IDX.HALT,IDX.FN_IMPL,0,0
    .byte 0x8F,IDX.WFI,IDX.FN_IMPL,0,0
    .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.Y 
    .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.X 
    .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.XH,IDX.A 
    .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.SP 
    .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.XL,IDX.A 
    .byte 0x98,IDX.RCF,IDX.FN_IMPL,0,0
    .byte 0x99,IDX.SCF,IDX.FN_IMPL,0,0
    .byte 0x9A,IDX.RIM,IDX.FN_IMPL,0,0
    .byte 0x9B,IDX.SIM,IDX.FN_IMPL,0,0
    .byte 0x9C,IDX.RVF,IDX.FN_IMPL,0,0
    .byte 0x9D,IDX.NOP,IDX.FN_IMPL,0,0
    .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XH
    .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XL
    ; form  op r,(r) | op (r)
    .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.X,0 
    .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.X,0 
    .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.Y,IDX.X 
    .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF5,IDX.BCP,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.X,0 
    .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.X,0 
    .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.X,IDX.X 
    ; form op (r),r 
    .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.X,IDX.A 
    .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.X,IDX.Y 

    ; form op r,#imm8 0xAn 
    .byte 0x52,IDX.SUB,IDX.FN_R_IMM8,IDX.SP,0
    .byte 0x5B,IDX.ADDW,IDX.FN_R_IMM8,IDX.SP,0
    .byte 0xa0,IDX.SUB,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa1,IDX.CP,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa2,IDX.SBC,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa4,IDX.AND,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa5,IDX.BCP,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa6,IDX.LD,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa8,IDX.XOR,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xa9,IDX.ADC,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xaA,IDX.OR,IDX.FN_R_IMM8,IDX.A,0
    .byte 0xaB,IDX.ADD,IDX.FN_R_IMM8,IDX.A,0
    ; form op r,#imm16 
    .byte 0x1C,IDX.ADDW,IDX.FN_R_IMM16,IDX.X,0
    .byte 0x1D,IDX.SUBW,IDX.FN_R_IMM16,IDX.X,0
    .byte 0xa3,IDX.CPW,IDX.FN_R_IMM16,IDX.X,0
    .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.X,0 
    .byte 0xCB,IDX.ADD,IDX.FN_R_IMM16,IDX.A,0 

    ; form op rel8  02n
    .byte 0x20,IDX.JRA,IDX.FN_REL8,0,0
    .byte 0x21,IDX.JRF,IDX.FN_REL8,0,0
    .byte 0x22,IDX.JRUGT,IDX.FN_REL8,0,0
    .byte 0x23,IDX.JRULE,IDX.FN_REL8,0,0
    .byte 0x24,IDX.JRNC,IDX.FN_REL8,0,0
    .byte 0x25,IDX.JRC,IDX.FN_REL8,0,0
    .byte 0x26,IDX.JRNE,IDX.FN_REL8,0,0
    .byte 0x27,IDX.JREQ,IDX.FN_REL8,0,0
    .byte 0x28,IDX.JRNV,IDX.FN_REL8,0,0
    .byte 0x29,IDX.JRV,IDX.FN_REL8,0,0
    .byte 0x2A,IDX.JRPL,IDX.FN_REL8,0,0
    .byte 0x2B,IDX.JRMI,IDX.FN_REL8,0,0
    .byte 0x2C,IDX.JRSGT,IDX.FN_REL8,0,0
    .byte 0x2D,IDX.JRSLE,IDX.FN_REL8,0,0
    .byte 0x2E,IDX.JRSGE,IDX.FN_REL8,0,0
    .byte 0x2F,IDX.JRSLT,IDX.FN_REL8,0,0
    ; form op adr8 
    .byte 0x30,IDX.NEG,IDX.FN_ADR8,0,0
    .byte 0x33,IDX.CPL,IDX.FN_ADR8,0,0
    .byte 0x34,IDX.SRL,IDX.FN_ADR8,0,0
    .byte 0x36,IDX.RRC,IDX.FN_ADR8,0,0
    .byte 0x37,IDX.SRA,IDX.FN_ADR8,0,0
    .byte 0x38,IDX.SLL,IDX.FN_ADR8,0,0
    .byte 0x39,IDX.RLC,IDX.FN_ADR8,0,0
    .byte 0x3A,IDX.DEC,IDX.FN_ADR8,0,0
    .byte 0x3C,IDX.INC,IDX.FN_ADR8,0,0
    .byte 0x3D,IDX.TNZ,IDX.FN_ADR8,0,0
    .byte 0x3E,IDX.SWAP,IDX.FN_ADR8,0,0
    .byte 0x3F,IDX.CLR,IDX.FN_ADR8,0,0
    .byte 0xAD,IDX.CALLR,IDX.FN_ADR8,0,0
    ; form op adr16 
    .byte 0x32,IDX.POP,IDX.FN_ADR16,0,0
    .byte 0x3B,IDX.PUSH,IDX.FN_ADR16,0,0 
    .byte 0xcc,IDX.JP,IDX.FN_ADR16,0,0
    .byte 0xcd,IDX.CALL,IDX.FN_ADR16,0,0
    ;form op r,adr16 
    .byte 0x31,IDX.EXG,IDX.FN_R_ADR16,IDX.A,0
    ;form op adr24 
    .byte 0x82,IDX.INT,IDX.FN_ADR24,0,0
    .byte 0x8D,IDX.CALLF,IDX.FN_ADR24,0,0
    .byte 0xac,IDX.JPF,IDX.FN_ADR24,0,0

    ;form op r,adr8
    .byte 0xB0,IDX.SUB,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB1,IDX.CP,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB2,IDX.SBC,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB3,IDX.CPW,IDX.FN_R_ADR8,IDX.X,0
    .byte 0xB4,IDX.AND,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB5,IDX.BCP,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB6,IDX.LD,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB8,IDX.XOR,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB9,IDX.ADC,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xBA,IDX.OR,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xBB,IDX.ADD,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.X,0
    
    ;form op r,adr16
    .byte 0xC0,IDX.SUB,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC1,IDX.CP,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC2,IDX.SBC,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC3,IDX.CPW,IDX.FN_R_ADR16,IDX.X,0
    .byte 0xC4,IDX.AND,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC5,IDX.BCP,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC6,IDX.LD,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC8,IDX.XOR,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xc9,IDX.ADC,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xCA,IDX.OR,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xCB,IDX.ADD,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.X,0

    ;form op r,adr24 
    .byte 0xBC,IDX.LDF,IDX.FN_R_ADR24,IDX.A,0 

    ; form op #imm8 
    .byte 0x4B,IDX.PUSH,IDX.FN_IMM8,0,0

    ;form op adr8,r 
    .byte 0xB7,IDX.LD,IDX.FN_ADR8_R,0,IDX.A
    .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.X

    ;form op adr16,r 
    .byte 0xC7,IDX.LD,IDX.FN_ADR16_R,0,IDX.A 
    .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.X 
    ;form op adr24,r 
    .byte 0xBD,IDX.LDF,IDX.FN_ADR24_R,0,IDX.A 

    ;form op adr16,#imm8
    .byte 0x35,IDX.MOV,IDX.FN_ADR16_IMM8,0,0 
    ;form op adr8,adr8 
    .byte 0x45,IDX.MOV,IDX.FN_ADR8_ADR8,0,0 
    ;form op adr16,adr16 
    .byte 0x55,IDX.MOV,IDX.FN_ADR16_ADR16,0,0 

    ;form op r,(off16,r)
    .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.X 
    .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
    .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.X 
    ;form op (off16,r),r 
    .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.X,IDX.A 

    ; form op r,(ofs24,r) 
    .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.X 
    ; form op (ofs24,r),r 
    .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.X,IDX.A 
    ;form op (ofs16,r)
    .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,0,IDX.X 
    .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,0,IDX.X 
    ;form op (ofs8,r)
    .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.X,0 
    .byte 0XED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,0  

    .byte 0,0,0,0,0

; table for opcodes with 0x72 prefix 
p72_codes:
    ; form op adr16,#bit,reljmp 
    .byte 0x00,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x01,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x02,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x03,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x04,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x05,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x06,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x07,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x08,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x09,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0A,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0B,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0C,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0D,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0E,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 0x0F,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0 
    ; form op adr16,#bit 
    .byte 0x10,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x11,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x12,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x13,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x14,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x15,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x16,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x17,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x18,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x19,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x1A,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x1B,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x1C,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x1D,IDX.BRES,IDX.FN_ADR16_B,0,0
    .byte 0x1E,IDX.BSET,IDX.FN_ADR16_B,0,0
    .byte 0x1F,IDX.BRES,IDX.FN_ADR16_B,0,0
    ;form op r,[ptr16]
    .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0 
    .byte 0xC9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0 
    .byte 0xCb,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0 
    ;form op r,([ptr16],r)
    .byte 0xd6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xd9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 

    ;from implied
    .byte 0x8F,IDX.WFE,IDX.FN_IMPL,0,0

    ;form op r,[ptr16]
    .byte 0xC0,IDX.SUB,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC1,IDX.CP,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC2,IDX.SBC,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC3,IDX.CPW,IDX.FN_R_PTR16,IDX.X,0
    .byte 0xC4,IDX.AND,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC5,IDX.BCP,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xC8,IDX.XOR,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xc9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xCA,IDX.OR,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xCB,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0
    .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0

    .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0

    ; form op r,([ptr16],r)
    .byte 0xD0,IDX.SUB,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD1,IDX.CP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD2,IDX.SBC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD3,IDX.CPW,IDX.FN_R_PTR16_IDX,IDX.Y,IDX.X 
    .byte 0xD4,IDX.AND,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD5,IDX.BCP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD8,IDX.XOR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xD9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xDA,IDX.OR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
    .byte 0xDE,IDX.LDW,IDX.FN_R_PTR16_IDX,IDX.X,IDX.X 

    ; form op r,(ofs8,r)
    .byte 0xF0,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
    .byte 0xF2,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
    .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
    .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
    ; form op [ptr16],r 
    .byte 0xC7,IDX.LD,IDX.FN_PTR16_R,0,IDX.A 
    .byte 0xCF,IDX.LDW,IDX.FN_PTR16_R,0,IDX.X 

    ; form op ([ptr16],r),r 
    .byte 0xD7,IDX.LD,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
    .byte 0xDF,IDX.LDW,IDX.FN_PTR16_IDX_R,IDX.X,IDX.Y 
    ;form op [ptr16] 0x3n 
    .byte 0x30,IDX.NEG,IDX.FN_PTR16,0,0
    .byte 0x33,IDX.CPL,IDX.FN_PTR16,0,0
    .byte 0x34,IDX.SRL,IDX.FN_PTR16,0,0
    .byte 0x36,IDX.RRC,IDX.FN_PTR16,0,0
    .byte 0x37,IDX.SRA,IDX.FN_PTR16,0,0
    .byte 0x38,IDX.SLL,IDX.FN_PTR16,0,0
    .byte 0x39,IDX.RLC,IDX.FN_PTR16,0,0
    .byte 0x3A,IDX.DEC,IDX.FN_PTR16,0,0
    .byte 0x3C,IDX.INC,IDX.FN_PTR16,0,0
    .byte 0x3D,IDX.TNZ,IDX.FN_PTR16,0,0
    .byte 0x3E,IDX.SWAP,IDX.FN_PTR16,0,0
    .byte 0x3F,IDX.CLR,IDX.FN_PTR16,0,0
    ; form op (ofs16,r) 0x4n
    .byte 0x40,IDX.NEG,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x43,IDX.CPL,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x44,IDX.SRL,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x46,IDX.RRC,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x47,IDX.SRA,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x48,IDX.SLL,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x49,IDX.RLC,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x4A,IDX.DEC,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x4C,IDX.INC,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x4D,IDX.TNZ,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x4E,IDX.SWAP,IDX.FN_OFS16_IDX,IDX.X,0
    .byte 0x4F,IDX.CLR,IDX.FN_OFS16_IDX,IDX.X,0

    ; form op adr16 0x5n
    .byte 0x50,IDX.NEG,IDX.FN_ADR16,0,0
    .byte 0x53,IDX.CPL,IDX.FN_ADR16,0,0
    .byte 0x54,IDX.SRL,IDX.FN_ADR16,0,0
    .byte 0x56,IDX.RRC,IDX.FN_ADR16,0,0
    .byte 0x57,IDX.SRA,IDX.FN_ADR16,0,0
    .byte 0x58,IDX.SLL,IDX.FN_ADR16,0,0
    .byte 0x59,IDX.RLC,IDX.FN_ADR16,0,0
    .byte 0x5A,IDX.DEC,IDX.FN_ADR16,0,0
    .byte 0x5C,IDX.INC,IDX.FN_ADR16,0,0
    .byte 0x5D,IDX.TNZ,IDX.FN_ADR16,0,0
    .byte 0x5E,IDX.SWAP,IDX.FN_ADR16,0,0
    .byte 0x5F,IDX.CLR,IDX.FN_ADR16,0,0

    ; form op ([ptr16],x)  0x6n 
    .byte 0x60,IDX.NEG,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x63,IDX.CPL,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x64,IDX.SRL,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x66,IDX.RRC,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x67,IDX.SRA,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x68,IDX.SLL,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x69,IDX.RLC,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x6A,IDX.DEC,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x6C,IDX.INC,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x6D,IDX.TNZ,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x6E,IDX.SWAP,IDX.FN_PTR16_IDX,IDX.X,0
    .byte 0x6F,IDX.CLR,IDX.FN_PTR16_IDX,IDX.X,0
    ; form op r,#imm16 
    .byte 0xA2,IDX.SUBW,IDX.FN_R_IMM16,IDX.Y,0
    .byte 0xA9,IDX.ADDW,IDX.FN_R_IMM16,IDX.Y,0 
    ; form op r,adr16 
    .byte 0xB0,IDX.SUBW,IDX.FN_R_ADR16,IDX.X,0
    .byte 0xB2,IDX.SUBW,IDX.FN_R_ADR16,IDX.Y,0
    .byte 0xB9,IDX.ADDW,IDX.FN_R_ADR16,IDX.Y,0
    .byte 0xBB,IDX.ADDW,IDX.FN_R_ADR16,IDX.X,0
    ; form op r,(ofs8,r)
    .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP 
    .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP 
    ; form op [ptr16]
    .byte 0xCC,IDX.JP,IDX.FN_PTR16,0,0 

    .byte 0,0,0,0,0

; table for opcodes with 0x90 prefix 
p90_codes:
    ;form op adr16,#bit 
    .byte 0x10,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x11,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x12,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x13,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x14,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x15,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x16,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x17,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x18,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x19,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x1A,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x1B,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x1C,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x1D,IDX.BCCM,IDX.FN_ADR16_B,0,0
    .byte 0x1E,IDX.BCPL,IDX.FN_ADR16_B,0,0
    .byte 0x1F,IDX.BCCM,IDX.FN_ADR16_B,0,0
    ; form op (ofs8,r)
    .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.Y,0 
    .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.Y,0
    .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.Y,0
   ; form op r,(osf8,r)
    .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.Y
    .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.Y
    ;form op r,(ofs16,r)
    .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
    .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
    
    ; opcode with implied arguments 
    .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.Y,0
    .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.Y,0
    .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0
    .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.Y,IDX.A 
    .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
    .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0
    .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0
    .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0
    .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0
    .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0
    .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0
    .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0
    .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0
    .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0
    .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
    .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.Y,0 
    .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
    .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.Y,0  
    .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.Y,IDX.A 
    .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.Y,0
    .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.X 
    .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.Y 
    .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.YH,IDX.A 
    .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.SP 
    .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.YL,IDX.A 
    .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YH
    .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YL
    .byte 0xFB,IDX.ADD,IDX.FN_IMPL,IDX.A,IDX.Y
    ; form  op r,(r) | op (r)
    .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.X,IDX.Y 
    .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.Y 
    .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.Y,IDX.Y 
    
    ; form op (r),r 
    .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.Y,IDX.A 
    .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.Y,IDX.X   

    ;form op rel8 
    .byte 0x28,IDX.JRNH,IDX.FN_REL8,0,0
    .byte 0x29,IDX.JRH,IDX.FN_REL8,0,0
    .byte 0x2C,IDX.JRNM,IDX.FN_REL8,0,0
    .byte 0x2D,IDX.JRM,IDX.FN_REL8,0,0
    .byte 0x2E,IDX.JRIL,IDX.FN_REL8,0,0
    .byte 0x2F,IDX.JRIH,IDX.FN_REL8,0,0
  
    ; form op r,#imm16 
    .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.Y,IDX.Y 
    ; from op r,(ofs8,r)
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
    
    ; form op adr8,r 
    .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.Y 
    ; form op r,adr8 
    .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.Y,0
    ; form op r,adr16 
    .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.Y,0
    ;form op (ofs8,r),r 
    .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.A 
    .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.X 
    ;form op (off16,r),r 
    .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.A 
    .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.X 
    ; form op r,(ofs16,r)
    .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.Y 
    .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
    .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.Y 
    ;form op (ofs16,r)
    .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,IDX.Y,0 
    .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,IDX.Y,0 

    ; form op r,(ofs24,r) 
    .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.Y  
    ; form op (ofs24,r),r 
    .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.Y,IDX.A 
    ;form op adr16,r 
    .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.Y 
    .byte 0,0,0,0,0

; table for opcodes with 0x91 prefix 
p91_codes:
    ;form op r,([ptr8],r)
    .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.X,IDX.Y 
    .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y  
    .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y
    .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
    .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.Y 
    ;form op ([ptr8,r]),r
    .byte 0xd7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.A 
    ; form op r,([ptr16],r) 
    .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.Y 
    ; form op ([ptr16],r),r 
    .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.Y,IDX.A 
    ;form op r,[ptr8]
    .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.Y,0 
    ;form op [ptr8],r 
    .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.Y 
    ;form op ([ptr8,r]),r 
    .byte 0XDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.X 
    ;form op ([ptr8],r)
    .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.Y,0 
    .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.Y,0
    .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.Y,0

    .byte 0,0,0,0,0

; table of indexes for opcodes with 0x92 prefix 
p92_codes:
    ;form op r,[ptr8]
    .byte 0xC0,IDX.SUB,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC1,IDX.CP,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC2,IDX.SBC,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC3,IDX.CPW,IDX.FN_R_PTR8,IDX.X,0
    .byte 0xC4,IDX.AND,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC5,IDX.BCP,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC6,IDX.LD,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xC8,IDX.XOR,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xc9,IDX.ADC,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xCA,IDX.OR,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xCB,IDX.ADD,IDX.FN_R_PTR8,IDX.A,0
    .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.A,0

    ;form op r,([ptr8,],r)
    .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.X 
    .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
    .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 

    ;form op [ptr8],r 
    .byte 0xC7,IDX.LD,IDX.FN_PTR8_R,0,IDX.A 
    .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.X 
    ;form op ([ptr8],r),r 
    .byte 0xD7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.X,IDX.A 
    .byte 0xDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.X,IDX.Y 
    ; form op r,([ptr16],r) 
    .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X  
    ; form op ([ptr16],r),r 
    .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
    ; form op r,[ptr16]
    .byte 0xBC,IDX.LDF,IDX.FN_R_PTR16,IDX.A,0
    ; form op [ptr16],r 
    .byte 0xBD,IDX.LDF,IDX.FN_PTR16_R,0,IDX.A  
    ; form op [ptr16] 
    .byte 0x8D,IDX.CALLF,IDX.FN_PTR16,0,0
    .byte 0xAC,IDX.JPF,IDX.FN_PTR16,0,0 
    ; form op [ptr8] 0x3n 
    .byte 0x30,IDX.NEG,IDX.FN_PTR8,0,0
    .byte 0x33,IDX.CPL,IDX.FN_PTR8,0,0
    .byte 0x34,IDX.SRL,IDX.FN_PTR8,0,0
    .byte 0x36,IDX.RRC,IDX.FN_PTR8,0,0
    .byte 0x37,IDX.SRA,IDX.FN_PTR8,0,0
    .byte 0x38,IDX.SLL,IDX.FN_PTR8,0,0
    .byte 0x39,IDX.RLC,IDX.FN_PTR8,0,0
    .byte 0x3A,IDX.DEC,IDX.FN_PTR8,0,0
    .byte 0x3C,IDX.INC,IDX.FN_PTR8,0,0
    .byte 0x3D,IDX.TNZ,IDX.FN_PTR8,0,0
    .byte 0x3E,IDX.SWAP,IDX.FN_PTR8,0,0
    .byte 0x3F,IDX.CLR,IDX.FN_PTR8,0,0
    ; form op ([ptr8],r) 0x6n 0xDC 0xDD
    .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.X,0 
    .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0xED,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.X,0
    .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0

    .byte 0,0,0,0,0



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
    callr search_code
    btjf flags,#F_FOUND,invalid_opcode
    pushw y 
    ld a,(FIELD_FN,y)
    ldw y,#fn_index
    call ld_table_entry
    call (y)
    popw y 
    jra decode_exit 
invalid_opcode: 
    ldw y, #bad_opcode 
    pushw y 
    call fn_implied  
    popw y 
decode_exit:    
    addw sp,#LOCAL_SIZE 
    ret

bad_opcode:  .byte 0,IDX.QM,IDX.FN_IMPL,0,0  

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


;*******************************

;----------------------------
;  helper macros 
;----------------------------
; lsize is local variables size in bytes 
; nomae is routine name 
    .macro _fn_entry lsize name
    LOCAL_SIZE = lsize
    STRUCT=3+LOCAL_SIZE
name:
    sub sp,#LOCAL_SIZE
    .endm

    .macro _fn_exit 
    addw sp,#LOCAL_SIZE 
    ret
    .endm

;******************************

;---------------------------
;  forms without arguments bytes 
;  1 or 2 bytes opcodes 
;---------------------------
fmt_impl_no_arg: .asciz "%a%s" 
fmt_impl_1_r: .asciz "%a%s\t%s"
fmt_impl_2_r: .asciz "%a%s\t%s,%s" 
fmt_select: .word fmt_impl_no_arg,fmt_impl_1_r,fmt_impl_2_r 

    SPC=1
    MNEMO=2 
    DEST=4
    SRC=6
    FMT=8
_fn_entry 8 fn_implied
    clrw y 
    ldw (DEST,sp),y
    ldw (SRC,sp),y 
    clr (FMT,sp)
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    jreq 1$
    inc (FMT,sp)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
1$: ld a, (FIELD_SRC,y)
    jreq 2$
    inc (FMT,sp)
    ldw y,#reg_index
    call ld_table_entry
    ldw (SRC,sp),y 
2$: ldw y,#fmt_select 
    ld a,(FMT,sp)
    call ld_table_entry 
    call format     
_fn_exit 

;---------------------------
; form: op #imm8 
;---------------------------
fmt_op_imm8: .asciz "%a%s\t#%b"
    SPC=1
    MNEMO=2
    IMM8=4
_fn_entry 4 fn_imm8 
    call get_int8
    ld (IMM8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_imm8 
    call format 
_fn_exit

;----------------------------
; form op rel8 
; jpr or callr 
;----------------------------
fmt_op_rel8: .asciz "%a%s\t%e"
    SPC=1 
    MNEMO=2
    ADR24 = 4
_fn_entry 6 fn_rel8
    call get_int8 
    call abs_addr
    ldw y,acc24 
    ld a,acc8 
    ldw (ADR24,sp),y 
    ld (ADR24+2,sp),a 
    ldw y,(STRUCT,sp) 
    call ld_mnemonic
    ldw y,#fmt_op_rel8
    call format  
_fn_exit 

;----------------------------
; form op adr8 
; exemple: clr 0xC0 
;----------------------------
fmt_op_adr8: .asciz "%a%s\t%b"
    SPC=1
    MNEMO=2
    ADR8=4
_fn_entry 4 fn_adr8 
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp) 
    call ld_mnemonic
    ldw y,#fmt_op_adr8 
    call format 
_fn_exit 

;----------------------------
; form op adr16 
; jp or call 
;----------------------------
fmt_op_adr16: .asciz "%a%s\t%w" 
    SPC=1
    MNEMO=2
    ADR16=4
_fn_entry 5 fn_adr16 
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_adr16 
    call format 
_fn_exit 

;----------------------------
; form op adr24 
; jpf or callf 
;----------------------------
fmt_op_adr24: .asciz "%a%s\t%e"
    SPC=1
    MNEMO=2
    ADR24=4 
_fn_entry 6 fn_adr24 
    call get_int24
    ldw (ADR24,sp),y 
    ld (ADR24+2,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_adr24 
    call format 
_fn_exit 

;----------------------------
;  form op adr8,r 
;----------------------------
fmt_op_adr8_r: .asciz "%a%s\t%b,%s"
    SPC=1
    MNEMO=2
    ADR8=4
    REG=5 
_fn_entry 6 fn_adr8_r 
    call get_int8 
    ld (ADR8,sp),a
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (REG,sp),y
    ldw y,#fmt_op_adr8_r 
    call format 
_fn_exit 

;----------------------------
; form op adr16,r 
;----------------------------
fmt_op_adr16_r: .asciz "%a%s\t%w,%s" 
    SPC=1 
    MNEMO=2
    ADR16=4
    REG=6 
_fn_entry 7  fn_adr16_r
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_adr16_r 
    call format 
_fn_exit

;----------------------------
; form op adr24,r  
;----------------------------
fmt_op_adr24_r: .asciz "%a%s\t%e,%s" 
    SPC=1
    MNEMO=2
    ADR24=4
    REG=7
_fn_entry 8 fn_adr24_r 
    call get_int24 
    ldw (ADR24,sp),y 
    ld (ADR24+2,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_adr24_r 
    call format 
_fn_exit 

;----------------------------
; form op r,adr8 
; exemple:  ldw x,$50
;----------------------------
fmt_op_r_adr8: .asciz "%a%s\t%s,%b"
    SPC=1
    MNEMO=2
    REG=4
    ADR8 = 6
_fn_entry 6 fn_r_adr8
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp) 
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_r_adr8 
    call format 
_fn_exit 

;----------------------------
; form op r,adr16 
; exemple:  ldw x,$5000 
;----------------------------
fmt_op_r_adr16: .asciz "%a%s\t%s,%w" 
    SPC=1
    MNEMO=2
    REG=4
    ADR16 = 6
_fn_entry 7 fn_r_adr16
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp) 
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_r_adr16 
    call format 
_fn_exit 

;----------------------------
; form op r,adr24 
; exemple:  ldf a,$12000  
;----------------------------
fmt_op_r_adr24: .asciz "%a%s\t%s,%e" 
    SPC=1
    MNEMO=2
    REG=4    
    ADR24 = 6
_fn_entry 8 fn_r_adr24 
    call get_int24 
    ldw (ADR24,sp),y
    ld (ADR24+2,sp),a  
    ldw y,(STRUCT,sp) 
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_r_adr24 
    call format 
_fn_exit 

;----------------------------
; register indexed without offset 
; form: op r,(r)
; form: op (r)
;----------------------------
fmt_op_idx: .asciz "%a%s\t(%s)"
fmt_op_r_idx: .asciz "%a%s\t%s,(%s)"
fmt_sel2: .word fmt_op_idx,fmt_op_r_idx 
    SPC=1
    MNEMO=2
    DEST=4
    SRC=6
    FMT=8 
_fn_entry 8 fn_r_idx
    clr (FMT,sp)
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (DEST,sp),y
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    jreq 1$
    inc (FMT,sp)
1$: ldw y,#reg_index
    call ld_table_entry
    ldw (SRC,sp),y 
    ld a,(FMT,sp)
    ldw y,#fmt_sel2
    call ld_table_entry 
    call format 
_fn_exit 

;----------------------------
; register indexed without offset 
; form: op (r),r
;----------------------------
fmt_op_idx_r: .asciz "%a%s\t(%s),%s"
    SPC=1
    MNEMO=2
    DEST=4
    SRC=6
_fn_entry 7 fn_idx_r 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_idx_r 
    call format 
_fn_exit 

;----------------------------
;  decode format: op (ofs8,r)
;----------------------------
fmt_op_ofs8_idx: .asciz "%a%s\t(%b,%s)"
    SPC=1
    MNEMO=2
    OFS8=4  ; byte offset value 
    REG=5 ;   pointer to register name
_fn_entry 6 fn_ofs8_idx 
    call get_int8 
    ld (OFS8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_ofs8_idx
    call format 
    _fn_exit

;--------------------------------
; decode form: op adr16,#bit,rel 
;--------------------------------
fmt_op_adr16_bit_rel: .asciz "%a%s\t%w,#%c,%e" ; i.e. btjt $1000,#7,$c0000
    SPC=1
    MNEMO=2
    ADR16=4
    BIT=6
    REL=7
_fn_entry 9 fn_adr16_b_rel 
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
    call ld_mnemonic
    ldw y,#fmt_op_adr16_bit_rel
    call format
_fn_exit

;--------------------------------------
; decode form:  op adr16,#bit 
;--------------------------------------
fmt_adr16_bit: .asciz "%a%s\t%w,#%c" ;
    SPC=1
    MNEMO=2
    ADR16=4
    BIT=6 
_fn_entry 6 fn_adr16_bit 
    call get_int16
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_OPCODE,Y)
    srl a 
    and a,#7 
    add a,#'0
    ld (BIT,sp),a
    call ld_mnemonic
    ldw y,#fmt_adr16_bit 
    call format 
_fn_exit

;---------------------------------
; decode form  op r,(ofs8,r)
;---------------------------------
fmt_r_ofs8_idx: .asciz "%a%s\t%s,(%b,%s)"
    SPC=1
    MNEMO=2
    DEST=4
    OFS8=6
    SRC=7 
_fn_entry 8 fn_r_ofs8_idx 
    call get_int8
    ld (OFS8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (DEST,sp),y
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (SRC,sp),y
    ldw y,#fmt_r_ofs8_idx 
    call format 
_fn_exit

;---------------------------------
; form  op (ofs8,r),r
;---------------------------------
fmt_op_ofs8_idx_r: .asciz "%a%s\t(%b,%s),%s"
    SPC=1
    MNEMO=2
    OFS8=4
    DEST=5
    SRC=7 
_fn_entry 8 fn_ofs8_idx_r 
    call get_int8 
    ld (OFS8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ofs8_idx_r
    call format 
_fn_exit 

;---------------------------------
;  decode form   op r,#imm8 
;---------------------------------
fmt_r_imm8: .asciz "%a%s\t%s,#%b" 
    SPC=1
    MNEMO=2
    REG=4
    IMM8=6
_fn_entry 6  fn_r_imm8 
    call get_int8
    ld (IMM8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic 
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_r_imm8
    call format 
_fn_exit

;---------------------------------
;  decode form   op r,#imm16 
;---------------------------------
fmt_r_imm16: .asciz "%a%s\t%s,#%w" 
    SPC=1
    MNEMO=2
    DEST=4
    IMM16=6
_fn_entry 7 fn_r_imm16
    call get_int16
    ldw (IMM16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic 
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,#fmt_r_imm16
    call format 
_fn_exit


;---------------------------------
;  form  op adr16,#imm8 
;---------------------------------
fmt_op_adr16_imm8: .asciz "%a%s\t%w,#%b"
    SPC=1
    MNEMO=2
    ADR16=4
    IMM8=6
_fn_entry 6 fn_adr16_imm8
    call get_int8 
    ld (IMM8,sp),a 
    call get_int16 
    ldw (ADR16,sp),y 
    ldw Y,(STRUCT,sp)
    call ld_mnemonic 
    ldw y,#fmt_op_adr16_imm8 
    call format 
_fn_exit 

;---------------------------------
;  form  op adr16,adr16 
;---------------------------------
fmt_op_adr16_adr16: .asciz "%a%s\t%w,%w"
    SPC=1
    MNEMO=2 
    DEST16=4
    SRC16=6
_fn_entry 7 fn_adr16_adr16
    call get_int16 
    ldw (SRC16,sp),y
    call get_int16 
    ldw (DEST16,sp),y 
    ldw Y,(STRUCT,sp)
    call ld_mnemonic 
    ldw y,#fmt_op_adr16_adr16 
    call format 
_fn_exit 

;---------------------------------
;  form  op adr8,adr8  
;---------------------------------
fmt_op_adr8_adr8: .asciz "%a%s\t%b,%b"
    SPC=1
    MNEMO=2
    DEST8=4
    SRC8=5
_fn_entry 5 fn_adr8_adr8
    call get_int8 
    ld (SRC8,sp),a 
    call get_int8 
    ld (DEST8,sp),a 
    ldw Y,(STRUCT,sp)
    call ld_mnemonic 
    ldw y,#fmt_op_adr8_adr8 
    call format 
_fn_exit 

;---------------------------------
;   form op r,[ptr8]
;---------------------------------
fmt_op_r_ptr8: .asciz "%a%s\t%s,[%b]"
    SPC=1
    MNEMO=2
    REG=4
    PTR8=6
_fn_entry 6 fn_r_ptr8
    call get_int8 
    ld (PTR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_r_ptr8 
    call format 
_fn_exit 


;---------------------------------
;   form op r,[ptr16]
;---------------------------------
fmt_op_r_ptr16: .asciz "%a%s\t%s,[%w]"
    SPC=1
    MNEMO=2
    REG=4
    PTR16=6
_fn_entry 7 fn_r_ptr16
    call get_int16 
    ldw (PTR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_r_ptr16 
    call format 
_fn_exit 

;---------------------------------
;   form op [ptr8],r
;---------------------------------
fmt_op_ptr8_r: .asciz "%a%s\t[%b],%s"
    SPC=1
    MNEMO=2
    PTR8=4
    SRC=5
_fn_entry 6 fn_ptr8_r
    call get_int8 
    ld (PTR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ptr8_r 
    call format 
_fn_exit 


;---------------------------------
;   form op [ptr16],r
;---------------------------------
fmt_op_ptr16_r: .asciz "%a%s\t[%w],%s"
    SPC=1
    MNEMO=2
    PTR16=4
    REG=6
_fn_entry 7 fn_ptr16_r
    call get_int16 
    ldw (PTR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_op_ptr16_r 
    call format 
_fn_exit 

;---------------------------------
;   form op r,([ptr8],r)
;---------------------------------
fmt_op_r_ptr8_idx: .asciz "%a%s\t%s,([%b],%s)"
    SPC=1
    MNEMO=2
    DEST=4
    PTR8=6
    SRC=7
_fn_entry 8 fn_r_ptr8_idx  
    call get_int8 
    ld (PTR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_r_ptr8_idx  
    call format 
_fn_exit 

;---------------------------------
;   form op r,([ptr16],r)
;---------------------------------
fmt_op_r_ptr16_idx: .asciz "%a%s\t%s,([%w],%s)"
    SPC=1
    MNEMO=2
    DEST=4
    PTR16=6
    SRC=8
_fn_entry 9 fn_r_ptr16_idx 
    call get_int16 
    ldw (PTR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (DEST,sp),y
    ldw y,(STRUCT,sp) 
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_r_ptr16_idx  
    call format 
_fn_exit 

;---------------------------------
;   form op ([ptr8],r),r
;---------------------------------
fmt_op_ptr8_idx_r: .asciz "%a%s\t([%b],%s),%s"
    SPC=1
    MNEMO=2
    PTR8=4
    DEST=5
    SRC=7
_fn_entry 8 fn_ptr8_idx_r
    call get_int8 
    ld (PTR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ptr8_idx_r 
    call format 
_fn_exit 

;---------------------------------
;   form op ([ptr16],r),r
;---------------------------------
fmt_op_ptr16_idx_r: .asciz "%a%s\t([%w],%s),%s"
    SPC=1
    MNEMO=2
    PTR16=4
    DEST=6
    SRC=8
_fn_entry 9 fn_ptr16_idx_r 
    call get_int16
    ldw (PTR16,sp),y
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ptr16_idx_r 
    call format 
_fn_exit 

;---------------------------------
;   form op (ofs16,r)
;---------------------------------
fmt_op_ofs16_idx: .asciz "%a%s\t(%w,%s)"
    SPC=1
    MNEMO=2
    OFS16=4
    SRC=6
_fn_entry 7 fn_ofs16_idx 
    call get_int16  
    ldw (OFS16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ofs16_idx 
    call format 
_fn_exit 


;---------------------------------
; form op r,(ofs16,r)
;---------------------------------
fmt_op_r_ofs16_idx: .asciz "%a%s\t%s,(%w,%s)"
    SPC=1
    MNEMO=2
    DEST=4
    OFS16=6 
    SRC=8
_fn_entry 9 fn_r_ofs16_idx
    call get_int16 
    ldw (OFS16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_r_ofs16_idx
    call format 
_fn_exit 

;---------------------------------
;  form op (ofs16,r),r 
;---------------------------------
fmt_op_ofs16_idx_r: .asciz "%a%s\t(%w,%s),%s"
    SPC=1
    MNEMO=2
    OFS16=4
    DEST=6
    SRC=8
_fn_entry 9 fn_ofs16_idx_r
    call get_int16 
    ldw (OFS16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y 
    ldw y,#fmt_op_ofs16_idx_r 
    call format 
_fn_exit 

;---------------------------------
;  op r,(ofs24,r)
;---------------------------------
fmt_op_r_ofs24_idx: .asciz "%a%s\t%s,(%e,%s)" 
    SPC=1
    MNEMO=2
    DEST=4
    OFS24=6
    SRC=9
_fn_entry 10 fn_r_ofs24_idx 
    call get_int24 
    ldw (OFS24,sp),y 
    ld (OFS24+2,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y
    ldw y,#fmt_op_r_ofs24_idx
    call format 
_fn_exit 

;---------------------------------
; op (ofs24,r),r 
;---------------------------------
fmt_ofs24_idx_r: .asciz "%a%s\t(%e,%s),%s"
    SPC=1
    MNEMO=2
    OFS24=4
    DEST=7
    SRC=9
_fn_entry 10 fn_ofs24_idx_r 
    call get_int24 
    ldw (OFS24,sp),y
    ld (OFS24+2,sp),a
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (SRC,sp),y
    ldw y,#fmt_ofs24_idx_r 
    call format 
_fn_exit 

;---------------------------------
; form op [adr16]
;---------------------------------
fmt_op_ptr8: .asciz "%a%s\t%[%b]"
    SPC=1
    MNEMO=2
    ADR8=4
_fn_entry 4 fn_ptr8 
    call get_int8
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_ptr8 
    call format 
_fn_exit 

;---------------------------------
; form op [adr16]
;---------------------------------
fmt_op_ptr16: .asciz "%a%s\t%[%w]"
    SPC=1
    MNEMO=2
    ADR16=4
_fn_entry 5 fn_ptr16 
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_ptr16 
    call format 
_fn_exit 

;---------------------------------
; form op ([ptr8],r) 
;---------------------------------
fmt_op_ptr8_idx: .asciz "%a%s\t([%b],%s)"
    SPC=1
    MNEMO=2
    ADR8=4
    DEST=5
_fn_entry 6 fn_ptr8_idx 
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,#fmt_op_ptr8_idx
    call format 
_fn_exit 

;---------------------------------
; form op ([ptr16],r) 
;---------------------------------
fmt_op_ptr16_idx: .asciz "%a%s\t([%w],%s)"
    SPC=1
    MNEMO=2
    ADR16=4
    DEST=6
_fn_entry 7 fn_ptr16_idx 
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (DEST,sp),y 
    ldw y,#fmt_op_ptr16_idx
    call format 
_fn_exit 


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
    clr acc16
    sll a 
    rlc acc16
    ld acc8,a 
    addw y,acc16 
    ldw y,(y)
    ret 
    
;---------------------------------
; prepare SPC and MNEMO arguments
; for format sub-routine.
; This is the same for all fn_* subs.
; input:
;   Y       pointer to opcode structure 
; output:
;   none 
;-------------------------------------
    SPC=5
    MNEMO=6 
ld_mnemonic:
;compute alignment spaces 
    pushw y
    ld a,xl 
    sll a 
    sll a 
    ld acc8,a 
    ld a,#24
    sub a,acc8
    ld (SPC,sp),a 
    ld a,(FIELD_MNEMO,y)
    clr acc16 
    sll a 
    rlc acc16 
    ld acc8,a
    ldw y,#mnemo_index  
    addw y,acc16
    ldw y,(y)
    ldw (MNEMO,sp),y 
    popw y 
    ret 



