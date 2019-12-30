;;
; Copyright Jacques Deschênes 2019 
; This file is part of STM8_NUCLEO 
;
;     STM8_NUCLEO is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     STM8_NUCLEO is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
;;
;--------------------------------------
        TAB_WIDTH=4 ; default tabulation width 
;--------------------------------------
;       token attribute
;--------------------------------------
        ; bits 4:5 identify token group 
        ; 0x0n -> miscelinous 
        ; 0x1n -> +|- operators 
        ; 0x2n -> *|/|% operators
        ; 0x3n -> relational operators 
        TK_NONE=0       ; undefined
        TK_VAR=1        ; variable letters {A..Z}
        TK_ARRAY=2      ; array variable '@' 
        TK_LPAREN=3     ; left parenthesis '('
        TK_RPAREN=4     ; right parenthesis ')'
        TK_QSTR=5       ; quoted string  
        TK_KWORD=6      ; BASIC keyword  
        TK_COLON=7      ; command end marker ':' 
        TK_COMMA=8      ; item separator ',' 
        TK_SHARP=9      ; print colon width '#' 
        TK_INTGR=10     ; integer 
        TK_PLUS=0x10    ; addition operator '+'
        TK_MINUS=0x11   ; subtraction operator '-'
        TK_MULT=0x20    ; multiplication operator '*'
        TK_DIV=0x21     ; division operator '/'
        TK_MOD=0x22     ; modulo operator '%'
        ; don't change these token values 
        ; values chosen to be used as a mask with CC.
        ; bits 4:5 identify group 
        ; bits 0:2 are CC mask 
        TK_GT=0x31      ; relation operator '>'
        TK_EQUAL=0x32   ; assignment or relation operator '='
        TK_GE=0x33      ; relation operator '>='
        TK_LT=0x34      ; relation operator '<'
        TK_NE=0x35      ; relation operator '<>' not equal 
        TK_LE=0x36      ; relation operator '<='
        TK_GRP_MASK=0X30 ; token groups: additive group 0x10, mult. group 0x20, rel_op group 0x30 
        TK_GRP_MISC=0x00 
        TK_GRP_ADD=0x10 
        TK_GRP_MULT=0x20 
        TK_GRP_RELOP=0x30 

;--------------------------------------
;   error codes 
;--------------------------------------
    ERR_NONE=0
    ERR_TXT_FULL=1 
    ERR_SYNTAX=2
    ERR_MATH_OVF=3
    ERR_DIV0=4 
    ERR_NO_LINE=5
    ERR_RUN_ONLY=6
    ERR_CMD_ONLY=7
    
;--------------------------------------
;   assembler flags 
;-------------------------------------
    MATH_OVF=0 ; if 1 the stop on math overflow 

;---------------------------------------
;  data stack macros 
;---------------------------------------
    CELL_SIZE=2 
    ; open space on data stack
    .macro _dp_down n 
    pushw x 
    ldw x, dstkptr 
    subw x,#CELL_SIZE*n 
    ldw dstkptr,x
    popw x 
    .endm 

    ;release space on data stack 
    .macro _dp_up n
    pushw x 
    ldw x,dstkptr 
    addw x,#CELL_SIZE*n  
    ldw dstkptr,x 
    popw x 
    .endm 

    ; return token to pool 
    .macro _unget_tok 
    ld untok,a 
    .endm 

    ; load X register with 
    ; entry point of dictionary
    ; before calling 'search_dict'
    .macro _ldx_dict dict_name
    ldw x,#dict_name+2
    .endm 

;-------------------------------
;  macros used to help debugging
;-------------------------------
    DEBUG=0
    .macro _dbg 
    DEBUG=1
    .endm

    .macro _nodbg
    DEBUG=0
    .endm 

    DBG_CC=6
    DBG_A=5 
    DBG_X=3 
    DBG_Y=1 
    .macro _dbg_save_regs 
    .if DEBUG
    push cc ; (6,sp)
    push a   ; (5,sp)
    pushw x  ; (3,sp)
    pushw y  ; (1,sp)
    .endif 
    .endm 

    .macro _dbg_restore_regs 
    .if DEBUG 
    popw y 
    popw x 
    pop a 
    pop cc 
    .endif 
    .endm 

    .macro _dbg_getc 
    .if DEBUG 
    _dbg_save_regs 
    call getc
    ld (DBG_A,sp),a 
    _dbg_restore_regs  
    .endif
    .endm 

    .macro _dbg_putc 
    .if DEBUG
    _dbg_save_regs  
    call putc 
    _dbg_restore_regs 
    .endif 
    .endm 

    .macro _dbg_puts 
    .if DEBUG 
    _dbg_save_regs
    call puts 
    _dbg_restore_regs
    .endif 
    .endm 

    .macro _dbg_prti24 
    .if DEBUG 
    _dbg_save_regs
    call prti24 
    _dbg_restore_regs
    .endif
    .endm 

    .macro _dbg_prt_regs
    .if DEBUG
    _dbg_save_regs
    call prt_regs 
    _dbg_restore_regs 
    .endif 
    .endm 

    .macro _dbg_peek addr 
    .if DEBUG
    _dbg_save_regs 
    ldw x,addr 
    call peek     
    _dbg_restore_regs
    .endif 
    .endm 

    .macro _dbg_parser_init 
    .if DEBUG 
    _dbg_save_regs
    call parser_init 
    _dbg_restore_regs
    .endif
    .endm

    .macro _dbg_readln
    .if DEBUG 
    _dbg_save_regs
    call readln
    _dbg_restore_regs
    .endif
    .endm

    .macro _dbg_number 	_dbg_prt_regs 

    .if DEBUG 
    _dbg_save_regs
    call number 
    _dbg_restore_regs
    .endif
    .endm  

    .macro _dbg_nextword
    .if DEBUG 
    _dbg_save_regs
    call get_token   
    _dbg_restore_regs
    .endif
    .endm  

    .macro _dbg_dots 
    .if DEBUG 
    _dbg_save_regs
    call dots 
    _dbg_restore_regs
    .endif 
    .endm 

    .macro _dbg_trap
    .if DEBUG 
    .byte 0x72,0x2 
    .word flags 
    .byte 1  
    trap 
    .endif 
    .endm 

    .macro _dbg_mark n  
    .if DEBUG 
    push a 
    ld a,#n 
    call putc 
    pop a 
    .endif 
    .endm 
    
    .macro _dbg_prt_var var 
    .if DEBUG
    _dbg_save_regs 
    ldw x,var 
    ldw acc16,x 
    clr acc24 
    clrw x 
    ld a,#16+128  
    call prti24
    ld a,#CR 
    call putc  
    _dbg_restore_regs 
    .endif 
    .endm 

