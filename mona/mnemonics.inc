;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    STM8  mnemonics table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    .word   M.JRA
    .word   M.JRC
    .word   M.JREQ
    .word   M.JRF 
    .word   M.JRH 
    .word   M.JRIH
    .word   M.JRIL
    .word   M.JRM 
    .word   M.JRMI
    .word   M.JRNC
    .word   M.JRNE 
    .word   M.JRNH 
    .word   M.JRNM
    .word   M.JRNV 
    .word   M.JRPL 
    .word   M.JRSGE 
    .word   M.JRSGT 
    .word   M.JRSLE 
    .word   M.JRSLT 
    .word   M.JRT 
    .word   M.JRUGE 
    .word   M.JRULE 
    .word   M.JRULT
    .word   M.JRV 
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

; noms des instructions
; utilisés par l'assembleur
mnemo_str:
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
M.JRA:  .asciz "JRA"
M.JRC:  .asciz "JRC"
M.JREQ:  .asciz "JREQ"
M.JRF:   .asciz "JRF"
M.JRH:   .asciz "JRH"
M.JRIH:  .asciz "JRIH"
M.JRIL:  .asciz "JRIL"
M.JRM:   .asciz "JRM"
M.JRMI:  .asciz "JRMI"
M.JRNC:  .asciz "JRNC"
M.JRNE:  .asciz  "JRNE"
M.JRNH:   .asciz "JRNH"
M.JRNM:  .asciz "JRNM"
M.JRNV:   .asciz "JRNV"
M.JRPL:   .asciz "JRPL"
M.JRSGE:   .asciz "JRSGE"
M.JRSGT:   .asciz "JRSGT"
M.JRSLE:   .asciz "JRSLE"
M.JRSLT:   .asciz "JRSLT"
M.JRT:   .asciz "JRT"
M.JRUGE:   .asciz "JRUGE"
M.JRULE:   .asciz "JRULE"
M.JRULT:  .asciz "JRULT"
M.JRV:   .asciz "JRV"
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




