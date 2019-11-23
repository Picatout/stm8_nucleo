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
    IDX.FN_OFS8_IND = 1     
    IDX.FN_ADR16_B_REL = 2
    IDX.FN_ADR16_B = 3
    IDX.FN_R_OFS8_R = 4 
    IDX.FN_R_IMM8 = 5
    IDX.FN_R_IMM16 = 6 
    IDX.FN_R_IDX = 7
    IDX.FN_IDX_R = 8 
    IDX.FN_ADR8 = 9 
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

; decoder function indexed table
fn_index:
    .word fn_implied ; 0 
    .word fn_ofs8_ind ; 1 
    .word fn_adr16_b_rel ; 2 
    .word fn_adr16_bit ; 3 
    .word fn_r_ofs8_r ; 4
    .word fn_r_imm8 ; 5
    .word fn_r_imm16 ; 6
    .word fn_r_idx ; 7
    .word fn_idx_r ; 8 
    .word fn_adr8 ; 9 
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
    ; form op (ofs8,r)
    .byte 0x00,IDX.NEG,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x03,IDX.CPL,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x04,IDX.SRL,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x06,IDX.RRC,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x07,IDX.SRA,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x08,IDX.SLL,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x09,IDX.RLC,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x0a,IDX.DEC,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x0c,IDX.INC,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x0d,IDX.TNZ,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x0e,IDX.SWAP,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x0f,IDX.CLR,IDX.FN_OFS8_IND,IDX.SP,IDX.SP 
    .byte 0x60,IDX.NEG,IDX.FN_OFS8_IND,IDX.X,IDX.X 
    .byte 0x63,IDX.CPL,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x64,IDX.SRL,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x66,IDX.RRC,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x67,IDX.SRA,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x68,IDX.SLL,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x69,IDX.RLC,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x6C,IDX.INC,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IND,IDX.X,IDX.X
    .byte 0xED,IDX.CALL,IDX.FN_OFS8_IND,IDX.X,IDX.X
    ; form op r,(ofs8,r)
    .byte 0x10,IDX.SUB,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x11,IDX.CP,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x12,IDX.SBC,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x13,IDX.CPW,IDX.FN_R_OFS8_R,IDX.X,IDX.SP
    .byte 0x14,IDX.AND,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x15,IDX.BCP,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x16,IDX.LDW,IDX.FN_R_OFS8_R,IDX.Y,IDX.SP
    .byte 0x18,IDX.XOR,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x19,IDX.ADC,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x1A,IDX.OR,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x1B,IDX.ADD,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0x1E,IDX.LDW,IDX.FN_R_OFS8_R,IDX.X,IDX.SP
    .byte 0x7B,IDX.LD,IDX.FN_R_OFS8_R,IDX.A,IDX.SP
    .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_R,IDX.Y,IDX.X
    .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_R,IDX.A,IDX.X
    .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_R,IDX.X,IDX.X

    ; opcode with implied arguments
    .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.X,0
    .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.X,0
    .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0 
    .byte 0x41,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.XL
    .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.X,IDX.A 
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
    .byte 0x65,IDX.DIV,IDX.FN_IMPL,IDX.X,IDX.Y
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
    .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.X 
    .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.X,0 
    .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.X,IDX.X 
    ; form op (r),r 
    .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.X,IDX.A 
    .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.X,IDX.Y 

    ; form op r,#imm8
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
    .byte 0xa3,IDX.CPW,IDX.FN_R_IMM16,IDX.X,0
    .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.X,0 

    ; form op adr8 
    .byte 0x20,IDX.JRA,IDX.FN_ADR8,0,0
    .byte 0x21,IDX.JRF,IDX.FN_ADR8,0,0
    .byte 0x22,IDX.JRUGT,IDX.FN_ADR8,0,0
    .byte 0x23,IDX.JRULE,IDX.FN_ADR8,0,0
    .byte 0x24,IDX.JRNC,IDX.FN_ADR8,0,0
    .byte 0x25,IDX.JRC,IDX.FN_ADR8,0,0
    .byte 0x26,IDX.JRNE,IDX.FN_ADR8,0,0
    .byte 0x27,IDX.JREQ,IDX.FN_ADR8,0,0
    .byte 0x28,IDX.JRNV,IDX.FN_ADR8,0,0
    .byte 0x29,IDX.JRV,IDX.FN_ADR8,0,0
    .byte 0x2A,IDX.JRPL,IDX.FN_ADR8,0,0
    .byte 0x2B,IDX.JRMI,IDX.FN_ADR8,0,0
    .byte 0x2C,IDX.JRSGT,IDX.FN_ADR8,0,0
    .byte 0x2D,IDX.JRSLE,IDX.FN_ADR8,0,0
    .byte 0x2E,IDX.JRSGE,IDX.FN_ADR8,0,0
    .byte 0x2F,IDX.JRSLT,IDX.FN_ADR8,0,0
    .byte 0x30,IDX.NEG,IDX.FN_ADR8,0,0
    .byte 0x33,IDX.NEG,IDX.FN_ADR8,0,0
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
    .byte 0xcd,IDX.CALL,IDX.FN_ADR16,0,0

    ;form op adr24 
    .byte 0x82,IDX.INT,IDX.FN_ADR24,0,0
    .byte 0x8D,IDX.CALLF,IDX.FN_ADR24,0,0
    .byte 0xac,IDX.JPF,IDX.FN_ADR24,0,0

    ;form op r,adr8
    .byte 0xB1,IDX.CP,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xB6,IDX.LD,IDX.FN_R_ADR8,IDX.A,0
    .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.X,0
    
    ;form op r,adr16
    .byte 0xC1,IDX.CP,IDX.FN_R_ADR16,IDX.A,0
    .byte 0xC6,IDX.LD,IDX.FN_R_ADR16,IDX.A,0
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

    ;form op adr24,r 
    .byte 0xBD,IDX.LDF,IDX.FN_ADR24_R,0,IDX.A 

    ;form op adr16,#imm8
    .byte 0x35,IDX.MOV,IDX.FN_ADR16_IMM8,0,0 
    ;form op adr8,adr8 
    .byte 0x45,IDX.MOV,IDX.FN_ADR8_ADR8,0,0 
    ;form op adr16,adr16 
    .byte 0x55,IDX.MOV,IDX.FN_ADR16_ADR16,0,0 

    .byte 0,0,0,0,0

; table for opcodes with 0x72 prefix 
p72_codes:
    ; form op adr16,#bit,reljmp 
    .byte 0,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 1,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 2,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 3,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 4,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 5,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 6,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 7,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 8,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 9,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 10,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 11,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 12,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 13,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0  
    .byte 14,IDX.BTJT,IDX.FN_ADR16_B_REL,0,0  
    .byte 15,IDX.BTJF,IDX.FN_ADR16_B_REL,0,0 
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

    ;from implied
    .byte 0x8F,IDX.WFE,IDX.FN_IMPL,0,0

    ; form op r,(ofs8,r)
    .byte 0xF0,IDX.SUBW,IDX.FN_R_OFS8_R,IDX.X,IDX.SP
    .byte 0xF2,IDX.SUBW,IDX.FN_R_OFS8_R,IDX.Y,IDX.SP
    .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_R,IDX.Y,IDX.SP
    .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_R,IDX.X,IDX.SP

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
    .byte 0x60,IDX.NEG,IDX.FN_OFS8_IND,IDX.Y,IDX.Y 
    .byte 0x63,IDX.CPL,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x64,IDX.SRL,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x66,IDX.RRC,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x67,IDX.SRA,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x68,IDX.SLL,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x69,IDX.RLC,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x6C,IDX.INC,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
    .byte 0xED,IDX.CALL,IDX.FN_OFS8_IND,IDX.Y,IDX.Y
   ; form op r,(osf8,r)
    .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_R,IDX.X,IDX.Y
    .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_R,IDX.Y,IDX.Y

    ; opcode with implied arguments 
    .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.Y,0
    .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.Y,0
    .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.Y,IDX.A 
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
    .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.XH,IDX.A 
    .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.SP 
    .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.YL,IDX.A 
    .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YH
    .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YL
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
    .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.Y,0 
    .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.Y,IDX.Y 
    
    ; form op (r),r 
    .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.Y,IDX.A 
    .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.Y,IDX.X 

    ;form op adr8 
    .byte 0x28,IDX.JRNH,IDX.FN_ADR8,0,0
    .byte 0x29,IDX.JRH,IDX.FN_ADR8,0,0
    .byte 0x2C,IDX.JRNM,IDX.FN_ADR8,0,0
    .byte 0x2D,IDX.JRM,IDX.FN_ADR8,0,0
    .byte 0x2E,IDX.JRIL,IDX.FN_ADR8,0,0
    .byte 0x2F,IDX.JRIH,IDX.FN_ADR8,0,0
  
    ; form op r,#imm16 
    .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.Y,IDX.Y 
    ; from op r,(ofs8,r)
    .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_R,IDX.A,IDX.Y
    
    ; form op adr8,r 
    .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.Y 

    .byte 0,0,0,0,0

; table for opcodes with 0x91 prefix 
p91_codes:

    .byte 0,0,0,0,0

; table of indexes for opcodes with 0x92 prefix 
p92_codes:
    
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
    call print_mnemonic 
decode_exit:    
    addw sp,#LOCAL_SIZE 
    ret

bad_opcode:  .byte 0,IDX.QM 

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
;  implied arguments opcode 
;---------------------------
    STRUCT=3
fn_implied:
    ldw y,(STRUCT,sp)
    call print_mnemonic 
    ld a,(FIELD_DEST,y)
    jreq 1$
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
    ldw y,(STRUCT,sp)
1$: ld a, (FIELD_SRC,y)
    jreq 2$
    push a 
    ld a,#',
    call uart_tx 
    pop a 
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
2$: ret 

;---------------------------
; form: op #imm8 
;---------------------------
    IMM8=1
_fn_entry 1 fn_imm8 
    call get_int8
    ld (IMM8,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,(IMM8,sp)
    ld a,#'# 
    call uart_tx 
    call print_byte 
_fn_exit

;----------------------------
; form op adr8 
; relative jp or callr 
;----------------------------
    ADR8 = 1
_fn_entry 1 fn_adr8
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp) 
    call print_mnemonic
    ld a,(ADR8,sp)
    call abs_addr
    pushw x
    clrw x
    ld a,#16  
    call print_int 
    popw x 
_fn_exit 

;----------------------------
; form op adr16 
; jp or call 
;----------------------------
    ADR16=1
_fn_entry 2 fn_adr16 
    call get_int16 
    ldw (ADR16,sp),y
    ldw y,(STRUCT,sp)
    call print_mnemonic 
    ldw y,(ADR16,sp)
    call print_word 
_fn_exit 

;----------------------------
; form op adr24 
; jpf or callf 
;----------------------------
    ADR24=1 
_fn_entry 3 fn_adr24 
    call get_int24
    ldw (ADR24,sp),y 
    ld (ADR24+2,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic 
    ldw y,(ADR24,sp)
    ld a,(ADR24+2,sp)
    ldw acc24,y 
    ld acc8,a 
    pushw x 
    clrw x 
    ld a,#16 
    call print_int 
    popw x 
_fn_exit 

;----------------------------
;  form op adr8,r 
;----------------------------
    ADR8=1 
_fn_entry 1 fn_adr8_r 
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,(ADR8,sp)
    call print_byte
    ld a,#',
    call uart_tx 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry 
    call uart_print 
_fn_exit 

;----------------------------
; form op adr16,r 
;----------------------------
    ADR16=1 
_fn_entry 2  fn_adr16_r
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ldw y,(ADR16,sp)
    call print_word 
    ld a,#',
    call uart_tx 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y) 
    ldw y,#reg_index
    call ld_table_entry 
    call uart_print 
_fn_exit

;----------------------------
; form op adr24,r  
;----------------------------
    ADR24=1
_fn_entry 3 fn_adr24_r 
    call get_int24 
    ldw (ADR24,sp),y 
    ld (ADR24+2,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic 
    ldw y,(ADR24,sp)
    ld a,(ADR24+2,sp)
    ldw acc24,y 
    ld acc8,a 
    pushw x 
    clrw x 
    ld a,#16  
    call print_int 
    popw x 
    ld a,#',
    call uart_tx 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry 
    call uart_print 
_fn_exit 

;----------------------------
; form op r,adr8 
; exemple:  ldw x,$50
;----------------------------
    ADR8 = 1
_fn_entry 1 fn_r_adr8
    call get_int8 
    ld (ADR8,sp),a 
    ldw y,(STRUCT,sp) 
    call print_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
    ld a,#', 
    call uart_tx 
    ld a,(ADR8,sp)
    call print_byte 
_fn_exit 

;----------------------------
; form op r,adr16 
; exemple:  ldw x,$5000 
;----------------------------
    ADR16 = 1
_fn_entry 2 fn_r_adr16
    call get_int16 
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp) 
    call print_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
    ld a,#', 
    call uart_tx 
    ldw y,(ADR16,sp)
    call print_word 
_fn_exit 

;----------------------------
; form op r,adr24 
; exemple:  ldf a,$12000  
;----------------------------
    ADR24 = 1
_fn_entry 3 fn_r_adr24 
    call get_int24 
    ldw (ADR24,sp),y
    ld (ADR24+2,sp),a  
    ldw y,(STRUCT,sp) 
    call print_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    call uart_print 
    ld a,#', 
    call uart_tx 
    ldw y,(ADR24,sp)
    ld a,(ADR24+2,sp)
    ldw acc24,y 
    ld acc8,a 
    pushw x 
    clrw x 
    ld a,#16 
    call print_int
    popw x 
_fn_exit 


;----------------------------
; register indexed without offset 
; form: op r,(r)
; form: op (r)
;----------------------------
    STRUCT=3
fn_r_idx:
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,(FIELD_SRC,y)
    jrne 1$
    ld a,#'(
    call uart_tx 
1$: ld a,(FIELD_DEST,y)    
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    jreq 2$
    ld a,#',
    call uart_tx 
    ld a,#'(
    call uart_tx 
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
2$: ld a,#') 
    call uart_tx 
    ret 

;----------------------------
; register indexed without offset 
; form: op (r),r
;----------------------------
    STRUCT=3 
fn_idx_r:
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,#'( 
    call uart_tx 
    ldw y,(STRUCT,sp) 
    ld a,(FIELD_DEST,y)
    ld a,#reg_index 
    call ld_table_entry
    call uart_print 
    ld a,#') 
    call uart_tx 
    ld a,#', 
    call uart_tx 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,sp)
    ldw y,#reg_index 
    call ld_table_entry
    call uart_print 
    ret 



;----------------------------
;  decode format: op (ofs8,r)
;----------------------------
fmt_ofs8_ind: .asciz "(%b,%s)"; i.e. inc ($5,sp)
 
    OFS8=1  ; byte offset value 
    REG=2 ; pointer to register name
_fn_entry 3 fn_ofs8_ind 
    call get_int8 
    ld (OFS8,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_ofs8_ind
    call format 
    _fn_exit

;--------------------------------
; decode form: op adr16,#bit,rel 
;--------------------------------
fmt_adr16_bit_rel: .asciz "%w,#%c,%e" ; i.e. btjt $1000,#7,$c0000

    ADR16=1
    BIT=3
    REL=4
_fn_entry 6 fn_adr16_b_rel 
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
    call print_mnemonic
    ldw y,#fmt_adr16_bit_rel
    call format
    _fn_exit

;--------------------------------------
; decode form:  op adr16,#bit 
;--------------------------------------
fmt_adr16_bit: .asciz "%w,#%c" ; i.e. bset $1000,#1
    LOCAL_SIZE=3
    ADR16=1
    BIT=3 
_fn_entry 3 fn_adr16_bit 
    call get_int16
    ldw (ADR16,sp),y 
    ldw y,(STRUCT,sp)
    ld a,(FIELD_OPCODE,Y)
    srl a 
    and a,#7 
    add a,#'0
    ld (BIT,sp),a
    call print_mnemonic
    ldw y,#fmt_adr16_bit 
    call format 
    _fn_exit

;---------------------------------
; decode form  op r,(ofs8,r)
;---------------------------------
fmt_r_ofs8_r: .asciz "%s,(%b,%s)"
    DEST=1
    OFS8=3
    SRC=4 
_fn_entry 5 fn_r_ofs8_r 
    call get_int8
    ld (OFS8,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (DEST,sp),y
    ldw y,(STRUCT,sp)
    ld a,(FIELD_SRC,y)
    ldw y,#reg_index
    call ld_table_entry
    ldw (SRC,sp),y
    ldw y,#fmt_r_ofs8_r
    call format 
    _fn_exit
    
;---------------------------------
;  decode form   op r,#imm8 
;---------------------------------
fmt_r_imm8: .asciz "%s,#%b" 
    REG=1
    IMM8=3
_fn_entry 3  fn_r_imm8 
    call get_int8
    ld (IMM8,sp),a 
    ldw y,(STRUCT,sp)
    call print_mnemonic 
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
fmt_r_imm16: .asciz "%s,#%w" 
    REG=1
    IMM16=3
_fn_entry 4 fn_r_imm16
    call get_int16
    ldw (IMM16,sp),y 
    ldw y,(STRUCT,sp)
    call print_mnemonic 
    ld a,(FIELD_DEST,y)
    ldw y,#reg_index 
    call ld_table_entry
    ldw (REG,sp),y 
    ldw y,#fmt_r_imm16
    call format 
_fn_exit


;---------------------------------
;  form  op adr16,#imm8 
;---------------------------------
    ADR16=1
    IMM8=3
_fn_entry 3 fn_adr16_imm8
    call get_int8 
    ld (IMM8,sp),a 
    call get_int16 
    ldw (ADR16,sp),y 
    ldw Y,(STRUCT,sp)
    call print_mnemonic 
    ldw y,(ADR16,sp)
    call print_word 
    ld a,#', 
    ld a,(IMM8,sp)
    call print_byte 
_fn_exit 

;---------------------------------
;  form  op adr16,adr16 
;---------------------------------
    DEST16=1
    SRC16=3
_fn_entry 4 fn_adr16_adr16
    call get_int16 
    ldw (SRC16,sp),y
    call get_int16 
    ldw (DEST16,sp),y 
    ldw Y,(STRUCT,sp)
    call print_mnemonic 
    ldw y,(DEST16,sp)
    call print_word 
    ld a,#', 
    ldw y,(SRC16,sp)
    call print_word 
_fn_exit 

;---------------------------------
;  form  op adr8,adr8  
;---------------------------------
    DEST8=1
    SRC8=2
_fn_entry 2 fn_adr8_adr8
    call get_int8 
    ld (SRC8,sp),a 
    call get_int8 
    ld (DEST8,sp),a 
    ldw Y,(STRUCT,sp)
    call print_mnemonic 
    ld a,(DEST8,sp)
    call print_byte  
    ld a,#', 
    ld a,(SRC8,sp)
    call print_byte 
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

;----------------------------
;print instruction mnemonic 
;pad with spaces for contant 
;8 charaters field width
; input:
;   Y       pointer to code structure 
; output:
;   none
;----------------------------
print_mnemonic:
    pushw y
    pushw x
    ld a,(FIELD_MNEMO,y) 
    ldw y,#mnemo_index
    call ld_table_entry
    ld a,#4
    mul x,a  
    ld a,xl 
    ld acc8,a 
    ld a,#24
    sub a,acc8  
    call spaces 
    ld a,#6
    call print_padded 
    popw x 
    popw y 
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
    




