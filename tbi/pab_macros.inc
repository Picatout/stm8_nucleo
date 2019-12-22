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
        TK_NONE=0       ; undefined
        TK_VAR=1        ; variable letters {A..Z}
        TK_ARRAY=2      ; array variable '@' 
        TK_LPAREN=3     ; left parenthesis '('
        TK_RPAREN=4     ; right parenthesis ')'
        TK_QSTR=5       ; quoted string  
        TK_KWORD=6      ; BASIC keyword  
        TK_INTGR=7      ; integer 
        TK_PLUS=8       ; addition operator '+'
        TK_MINUS=9      ; subtraction operator '-'
        TK_MULT=10      ; multiplication operator '*'
        TK_DIV=11       ; division operator '/'
        TK_MOD=12       ; modulo operator '%'
        TK_EQUAL=13     ; assignment or relation operator '='
        TK_GT=14        ; relation operator '>'
        TK_GE=15        ; relation operator '>='
        TK_LT=16        ; relation operator '<'
        TK_LE=17        ; relation operator '<='
        TK_NE=18        ; relation operator '<>' not equal 
        TK_COLON=19     ; command end marker ':' 
        TK_COMMA=20     ; item separator ',' 
        TK_SHARP=21     ; print colon width '#' 


;--------------------------------------
;   error codes 
;--------------------------------------
    ERR_NONE=0
    ERR_TXT_FULL=1 
    ERR_SYNTAX=2

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

    .macro _dbg_number 
    .if DEBUG 
    _dbg_save_regs
    call number 
    _dbg_restore_regs
    .endif
    .endm  

    .macro _dbg_nextword
    .if DEBUG 
    _dbg_save_regs
    call next_word  
    _dbg_restore_regs
    .endif
    .endm  

