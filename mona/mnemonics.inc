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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    STM8  mnemonics table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .area CODE 

; char **mnemo_table 
; table de pointeurs vers les mnémoniques
mnemo_table:
    .word   M.ADC       
    .word   M.ADD       
    .word   M.ADDW      
    .word   M.AND       
    .word   M.BCCM      
    .word   M.BCP       
    .word   M.BCPL      
    .word   M.BREAK     
    .word   M.BRES      
    .word   M.BSET      
    .word   M.BTJF      
    .word   M.BTJT 
    .word   M.CALL 
    .word   M.CALLF 
    .word   M.CALLR 
    .word   M.CCF 
    .word   M.CLR 
    .word   M.CLRW 
    .word   M.CP 
    .word   M.CPW 
    .word   M.CPL
    .word   M.CPLW 
    .word   M.DEC 
    .word   M.DECW 
    .word   M.DIV 
    .word   M.DIVW
    .word   M.EXG 
    .word   M.EXGW
    .word   M.HALT
    .word   M.INC 
    .word   M.INCW 
    .word   M.INT 
    .word   M.IRET 
    .word   M.JP 
    .word   M.JPF 

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
; equivalent mnemonics for jrxx
    .word   M.JRT       ; 0x20  == JRA
    .word   M.JRUGE     ; 0x24  == JRNC
    .word   M.JRULT     ; 0x25  == JRC 

; relative jump with 0x90 precode
jrxx90: ; 6 codes 
    .word   M.JRNH      ; 0x90 0x28
    .word   M.JRH       ; 0x90 0x29
    .word   0,0         ; 0x2a, 0x2b not used
    .word   M.JRNM      ; 0x90 0x2c
    .word   M.JRM       ; 0x90 0x2d
    .word   M.JRIL      ; 0x90 0x2e
    .word   M.JRIH      ; 0x90 0x2f


    .word   M.LD 
    .word   M.LDF 
    .word   M.LDW 
    .word   M.MOV 
    .word   M.MUL 
    .word   M.NEG 
    .word   M.NEGW 
    .word   M.NOP 
    .word   M.OR 
    .word   M.POP 
    .word   M.POPW 
    .word   M.PUSH 
    .word   M.PUSHW 
    .word   M.RCF 
    .word   M.RET 
    .word   M.RETF 
    .word   M.RIM
    .word   M.RLC 
    .word   M.RLCW 
    .word   M.RLWA 
    .word   M.RRC 
    .word   M.RRCW 
    .word   M.RRWA 
    .word   M.RVF 
    .word   M.SBC 
    .word   M.SCF 
    .word   M.SIM 
    .word   M.SLA
    .word   M.SLL
    .word   M.SLAW 
    .word   M.SLLW
    .word   M.SRA 
    .word   M.SRAW 
    .word   M.SRL 
    .word   M.SRLW 
    .word   M.SUB 
    .word   M.SUBW 
    .word   M.SWAP 
    .word   M.SWAPW
    .word   M.TNZ 
    .word   M.TNZW
    .word   M.TRAP 
    .word   M.WFE 
    .word   M.WFI 
    .word   M.XOR 

;-----------------------------------------------
; Instructions names used by assembler.
; Keep in same order than pointer tables above
; for cross reference between tables.
;-----------------------------------------------
; relative jump names table. 
mnemo_jrxx: 
M.JRA:  .asciz "JRA"
M.JRF:   .asciz "JRF"
M.JRUGT: .asciz "JRUGT"
M.JRULE:   .asciz "JRULE"
M.JRNC:  .asciz "JRNC"
M.JRC:  .asciz "JRC"
M.JRNE:  .asciz  "JRNE"
M.JREQ:  .asciz "JREQ"
M.JRNV:   .asciz "JRNV"
M.JRV:   .asciz "JRV"
M.JRPL:   .asciz "JRPL"
M.JRMI:  .asciz "JRMI"
M.JRSGT:   .asciz "JRSGT"
M.JRSLE:   .asciz "JRSLE"
M.JRSGE:   .asciz "JRSGE"
M.JRSLT:   .asciz "JRSLT"
M.JRUGE:   .asciz "JRUGE"
M.JRT:   .asciz "JRT"
M.JRULT:  .asciz "JRULT"
mnemo_jrxx90:
M.JRNH:   .asciz "JRNH"
M.JRH:   .asciz "JRH"
M.RES01:  .asciz "RES1" ; empty slots in jrxx90 table 
M.RES02:  .asciz "RES2" ; empty slots in jrxx90 table 
M.JRNM:  .asciz "JRNM"
M.JRM:   .asciz "JRM"
M.JRIL:  .asciz "JRIL"
M.JRIH:  .asciz "JRIH"


M.ADC: .asciz "ADC"
M.ADD: .asciz "ADD"
M.ADDW: .asciz "ADDW"
M.AND:  .asciz "AND"
M.BCCM: .asciz "BCCM"
M.BCP:  .asciz "BCP" 
M.BCPL: .asciz "BCPL"
M.BREAK: .asciz "BREAK"
M.BRES: .asciz "BRES"
M.BSET: .asciz "BSET"
M.BTJF: .asciz "BTJF"
M.BTJT: .asciz "BTJT"
M.CALL: .asciz "CALL"
M.CALLF: .asciz "CALLF"
M.CALLR: .asciz "CALLR"
M.CCF:  .asciz "CCF" 
M.CLR:  .asciz "CLR"
M.CLRW: .asciz "CLRW"
M.CP:   .asciz "CP" 
M.CPW:  .asciz "CPW"
M.CPL:  .asciz "CPL"
M.CPLW: .asciz "CPLW"
M.DEC:  .asciz "DEC"
M.DECW: .asciz "DECW"
M.DIV:  .asciz "DIV"
M.DIVW: .asciz "DIVW"
M.EXG:  .asciz "EXG"
M.EXGW: .asciz "EXGW"
M.HALT: .asciz "HALT"
M.INC:  .asciz "INC"
M.INCW: .asciz "INCW"
M.INT:  .asciz "INT"
M.IRET: .asciz "IRET"
M.JP:   .asciz "JP"
M.JPF:  .asciz "JPF"
M.LD:   .asciz "LD"
M.LDF:   .asciz "LDF"
M.LDW:   .asciz "LDW"
M.MOV:   .asciz "MOV"
M.MUL:   .asciz "MUL"
M.NEG:   .asciz "NEG"
M.NEGW:   .asciz "NEGW"
M.NOP:   .asciz "NOP"
M.OR:   .asciz "OR"
M.POP:   .asciz "POP"
M.POPW:   .asciz "POPW"
M.PUSH:   .asciz "PUSH"
M.PUSHW:   .asciz "PUSHW"
M.RCF:   .asciz "RCF"
M.RET:   .asciz "RET"
M.RETF:   .asciz "RETF"
M.RIM:  .asciz "RIM"
M.RLC:   .asciz "RLC"
M.RLCW:   .asciz "RLCW"
M.RLWA:   .asciz "RLWA"
M.RRC:   .asciz "RRC"
M.RRCW:   .asciz "RRCW"
M.RRWA:   .asciz "RRWA"
M.RVF:   .asciz "RVF"
M.SBC:   .asciz "SBC"
M.SCF:   .asciz "SCF"
M.SIM:   .asciz "SIM"
M.SLA:  .asciz "SLA"
M.SLL:  .asciz "SLL"
M.SLAW:   .asciz "SLAW"
M.SLLW:  .asciz "SLLW"
M.SRA:   .asciz "SRA"
M.SRAW:   .asciz "SRAW"
M.SRL:   .asciz "SRL"
M.SRLW:   .asciz "SRLW"
M.SUB:   .asciz "SUB"
M.SUBW:   .asciz "SUBW"
M.SWAP:   .asciz "SWAP"
M.SWAPW:  .asciz "SWAPW"
M.TNZ:   .asciz "TNZ"
M.TNZW:  .asciz "TNZW"
M.TRAP:   .asciz "TRAP"
M.WFE:   .asciz "WFE"
M.WFI:   .asciz "WFI"
M.XOR:   .asciz "XOR"




