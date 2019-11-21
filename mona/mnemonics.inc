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

; mnemonics index values
    IDX.ADC  = 1
    IDX.ADD  = 2
    IDX.ADDW = 3
    IDX.AND  = 4
    IDX.BCCM = 5 
    IDX.BCP  = 6
    IDX.BCPL  = 7
    IDX.BREAK  = 8
    IDX.BRES  = 9
    IDX.BSET  = 10
    IDX.BTJF  = 11
    IDX.BTJT  = 12
    IDX.CALL  = 13
    IDX.CALLF  = 14
    IDX.CALLR  = 15
    IDX.CCF  = 16
    IDX.CLR  = 17
    IDX.CLRW  = 18
    IDX.CP  = 19
    IDX.CPL  = 20
    IDX.CPLW  = 21
    IDX.CPW  = 22
    IDX.DEC  = 23
    IDX.DECW  = 24
    IDX.DIV  = 25
    IDX.DIVW  = 26
    IDX.EXG  = 27
    IDX.EXGW  = 28
    IDX.HALT  = 29
    IDX.INC  = 30
    IDX.INCW  =31
    IDX.INT  = 32
    IDX.IRET  = 33
    IDX.JP  = 34
    IDX.JPF  = 35
    IDX.JRA  = 36
    IDX.JRC  = 37
    IDX.JREQ  = 38
    IDX.JRF  = 39
    IDX.JRH  = 40
    IDX.JRIH  = 41
    IDX.JRIL  = 42
    IDX.JRM  =  43
    IDX.JRMI  = 44
    IDX.JRNC  = 45
    IDX.JRNE  = 46
    IDX.JRNH  = 47
    IDX.JRNM  = 48
    IDX.JRNV  = 49
    IDX.JRPL  = 50
    IDX.JRSGE  = 51
    IDX.JRSGT  = 52
    IDX.JRSLE  = 53
    IDX.JRSLT  = 54
    IDX.JRT  = 55
    IDX.JRUGE  = 56
    IDX.JRUGT  = 57
    IDX.JRULE  = 58
    IDX.JRULT  = 59
    IDX.JRV  = 60
    IDX.LD  = 61
    IDX.LDF  = 62
    IDX.LDW  = 63
    IDX.MOV  = 64
    IDX.MUL  = 65
    IDX.NEG  = 66
    IDX.NEGW  = 67
    IDX.NOP  = 68
    IDX.OR  =  69
    IDX.POP  = 70
    IDX.POPW  = 71
    IDX.PUSH  = 72
    IDX.PUSHW  = 73
    IDX.RCF  = 74
    IDX.RET  = 75
    IDX.RETF  = 76
    IDX.RIM  = 77
    IDX.RLC  = 78
    IDX.RLCW  = 79
    IDX.RLWA  = 80
    IDX.RRC  = 81
    IDX.RRCW  = 82
    IDX.RRWA  = 83
    IDX.RVF  =  84
    IDX.SBC  = 85
    IDX.SCF  = 86
    IDX.SIM  = 87
    IDX.SLA  = 88
    IDX.SLL  = 89
    IDX.SLAW  = 90
    IDX.SLLW  = 91
    IDX.SRA  = 92
    IDX.SRAW  = 93
    IDX.SRL  = 94
    IDX.SRLW  = 95
    IDX.SUB  = 96
    IDX.SUBW  = 97
    IDX.SWAP  = 98
    IDX.SWAPW = 99
    IDX.TNZ  = 100
    IDX.TNZW  = 101
    IDX.TRAP  = 102
    IDX.WFE  = 103
    IDX.WFI  = 104
    IDX.XOR  = 105
    IDX.QM = 106


; mnemonics indexed table 
mnemo_index:
    .word 0
    .word M.ADC  ; 1
    .word M.ADD  ; 2
    .word M.ADDW ; 3
    .word M.AND  ; 4
    .word M.BCCM ; 5 
    .word M.BCP  ; 6
    .word M.BCPL  ; 7
    .word M.BREAK  ; 8
    .word M.BRES  ; 9
    .word M.BSET  ; 10
    .word M.BTJF  ; 11
    .word M.BTJT  ; 12
    .word M.CALL  ; 13
    .word M.CALLF  ; 14
    .word M.CALLR  ; 15
    .word M.CCF  ; 16
    .word M.CLR  ; 17
    .word M.CLRW  ; 18
    .word M.CP  ; 19
    .word M.CPL  ; 20
    .word M.CPLW  ; 21
    .word M.CPW  ; 22
    .word M.DEC  ; 23
    .word M.DECW  ; 24
    .word M.DIV  ; 25
    .word M.DIVW  ; 26
    .word M.EXG  ; 27
    .word M.EXGW  ; 28
    .word M.HALT  ; 29
    .word M.INC  ; 30
    .word M.INCW  ;31
    .word M.INT  ; 32
    .word M.IRET  ; 33
    .word M.JP  ; 34
    .word M.JPF  ; 35
    .word M.JRA  ; 36
    .word M.JRC  ; 37
    .word M.JREQ  ; 38
    .word M.JRF  ; 39
    .word M.JRH  ; 40
    .word M.JRIH  ; 41
    .word M.JRIL  ; 42
    .word M.JRM  ;  43
    .word M.JRMI  ; 44
    .word M.JRNC  ; 45
    .word M.JRNE  ; 46
    .word M.JRNH  ; 47
    .word M.JRNM  ; 48
    .word M.JRNV  ; 49
    .word M.JRPL  ; 50
    .word M.JRSGE  ; 51
    .word M.JRSGT  ; 52
    .word M.JRSLE  ; 53
    .word M.JRSLT  ; 54
    .word M.JRT  ; 55
    .word M.JRUGE  ; 56
    .word M.JRUGT  ; 57
    .word M.JRULE  ; 58
    .word M.JRULT  ; 59
    .word M.JRV  ; 60
    .word M.LD  ; 61
    .word M.LDF  ; 62
    .word M.LDW  ; 63
    .word M.MOV  ; 64
    .word M.MUL  ; 65
    .word M.NEG  ; 66
    .word M.NEGW  ; 67
    .word M.NOP  ; 68
    .word M.OR  ;  69
    .word M.POP  ; 70
    .word M.POPW  ; 71
    .word M.PUSH  ; 72
    .word M.PUSHW  ; 73
    .word M.RCF  ; 74
    .word M.RET  ; 75
    .word M.RETF  ; 76
    .word M.RIM  ; 77
    .word M.RLC  ; 78
    .word M.RLCW  ; 79
    .word M.RLWA  ; 80
    .word M.RRC  ; 81
    .word M.RRCW  ; 82
    .word M.RRWA  ; 83
    .word M.RVF  ;  84
    .word M.SBC  ; 85
    .word M.SCF  ; 86
    .word M.SIM  ; 87
    .word M.SLA  ; 88
    .word M.SLL  ; 89
    .word M.SLAW  ; 90
    .word M.SLLW  ; 91
    .word M.SRA  ; 92
    .word M.SRAW  ; 93
    .word M.SRL  ; 94
    .word M.SRLW  ; 95
    .word M.SUB  ; 96
    .word M.SUBW  ; 97
    .word M.SWAP  ; 98
    .word M.SWAPW ; 99
    .word M.TNZ  ; 100
    .word M.TNZW  ; 101
    .word M.TRAP  ; 102
    .word M.WFE  ; 103
    .word M.WFI  ; 104
    .word M.XOR  ; 105
    .word M.QM   ; 106 

;-----------------------------------------------
; Instructions names used by assembler.
;-----------------------------------------------
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
M.CPL:  .asciz "CPL"
M.CPLW: .asciz "CPLW"
M.CPW:  .asciz "CPW"
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
M.JRUGT: .asciz "JRUGT"
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
M.QM:  .asciz "?"

;registers index values
    IDX.A   = 1
    IDX.CC  = 2
    IDX.XH  = 3
    IDX.YH  = 4
    IDX.XL  = 5
    IDX.YL  = 6
    IDX.X   = 7
    IDX.Y   = 8
    IDX.SP  = 9
    IDX.PC  = 10
    IDX.PCL = 11
    IDX.PCM = 12
    IDX.PCE = 13

;-------------------------
; registers names
; index table
;-------------------------
reg_index:
    .word 0     ; 0 
    .word R.A   ; 1
    .word R.CC  ; 2
    .word R.XH  ; 3
    .word R.YH  ; 4
    .word R.XL  ; 5
    .word R.YL  ; 6
    .word R.X   ; 7
    .word R.Y   ; 8
    .word R.SP  ; 9
    .word R.PC  ; 10
    .word R.PCL ; 11
    .word R.PCM ; 12
    .word R.PCE ; 13



; registers names 
registers:
R.A: .asciz "A"
R.CC: .asciz "CC" 
R.XH: .asciz "XH"
R.YH: .asciz "YH" 
R.XL: .asciz "XL"
R.YL: .asciz "YL" 
R.X:  .asciz "X" 
R.Y:  .asciz "Y"
R.SP: .asciz "SP"
R.PC: .asciz "PC" 
R.PCL: .asciz "PCL"
R.PCM: .asciz "PCM"
R.PCE: .asciz "PCE"

