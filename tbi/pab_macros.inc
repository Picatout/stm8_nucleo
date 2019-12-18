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
;--------------------------------------
; set of macros to use with test_help
;--------------------------------------

    ; drop dstack top element 
    .macro _ddrop
    pushw x 
    ldw x,dstackptr 
    addw x,#2 
    ldw dstackptr,x 
    popw x 
    .endm

    ; _dpush y on dstack 
    .macro _dpush 
    pushw x 
    ldw x,dstackptr 
    addw x,#-2 
    ldw dstackptr,x 
    ldw [dstackptr],y 
    popw x 
    .endm 

    ; _dpop in y 
    .macro _dpop 
    pushw x 
    ldw y,[dstackptr]
    ldw x,dstackptr 
    addw x,#2 
    ldw dstackptr,x 
    popw x 
    .endm 

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

