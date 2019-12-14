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
;   STRINGS module
;   DATE: 2019-11-29
;   DEPENDENCIES: math24 
;--------------------------------------
    .module STRING_TEST

    .nlist
	.include "../../inc/nucleo_8s208.inc"
	.include "../../inc/stm8s208.inc"
	.include "../../inc/ascii.inc"
    .include "../../inc/gen_macros.inc"
    .include "../test_macros.inc" 
    .list 

    .area DATA 
buffer:: .ds 80 
    
    .area CODE 
_dbg 
test_main::
; clear_buffer
    ldw x,#buffer 
    ld a,#80 
1$: clr (x)
    incw x 
    dec a 
    jrne 1$
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_atoi24
    _dbg_puts 
    ldw y,#number 
    _dbg_puts 
    ldw x,#number
    pushw x 
    call atoi24
    _drop 2  
    _dbg_prt_regs 
;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_strlen  
    _dbg_puts
    ldw y,#hello 
    _dbg_puts  
    _vars 2 
    ldw x,#hello 
    ldw (1,sp),x 
    call strlen 
    _drop 2
    ldw acc16,x 
    clr acc24 
    ld a,#10 
    clrw x 
    _dbg_prti24
    ld a,#CR 
;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_strcpy
    _dbg_puts 
    _vars 4 
    ldw x,#buffer 
    ldw (1,sp),x 
    ldw x,#hello 
    ldw (3,sp),x 
    call strcpy 
    _drop 4 
    ldw y,#buffer 
    _dbg_puts 
;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_memcpy
    _dbg_puts  
    _vars 6
    ldw x,#12 
    ldw (5,sp),x
    ldw x,#buffer
    ldw (3,sp),x 
    addw x,#12  
    ldw (1,sp),x
    call memcpy  
    _drop 6 
    ldw y,#buffer 
    _dbg_puts 
;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_fill
    _dbg_puts 
    _vars 4
    ldw x,#buffer 
    ldw (1,sp),x 
    ld a,#'@ 
    ld (3,sp),a 
    ld a,#24 
    ld (4,sp),a 
    call fill
    _drop 4 
    clr (x) 
    ldw y,#buffer 
    _dbg_puts 
;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_i24toa
    _dbg_puts 
    _vars 6
    ldw x,#0x1e2
    ld a,#0x40 
    ldw (1,sp),x 
    ld (3,sp),a 
    ld a,#16
    ld (4,sp),a  
    ldw x,#buffer 
    ldw (5,sp),x 
    call i24toa 
    _drop 6 
    ldw y,x 
    _dbg_puts
    ld a,#CR 
    _dbg_putc  
    _vars 6 
    ldw x,#0x1234
    ld a,#0x56 
    ldw (1,sp),x 
    ld (3,sp),a 
    ldw x,#buffer 
    ldw (5,sp),x 
    ld a,#10 
    ld (4,sp),a 
    call i24toa 
    _drop 6 
    ldw y,x 
    _dbg_puts 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ldw y,#test_format
    _dbg_puts 
    BUFF=1 ; 2
    FMT=3 ; 2 
    SPC1=5 ; 1 
    CHR1=6 ; 1
    SPC2=7 ; 1
    STR=8  ; 2
    SPC3=10 ; 1 
    I1=11  ; 3 
    SPC4=14 ; 1 
    I2 =15  ; 3
    VSIZE=I2+3   
    sub sp,#VSIZE 
    ld a,#4
    ld (SPC1,sp),a 
    ld (SPC2,sp),a 
    ld (SPC3,sp),a 
    ld (SPC4,sp),a
    ldw x,#buffer 
    ldw (BUFF,sp),x  
    ldw x,#fmt 
    ldw (FMT,sp),x 
    ld a,#0xff
    ldw x,#0x27f
    ld (I1+2,sp),a 
    ldw (I1,sp),x 
    ld a,#0x56
    ldw x,#0x1234
    ld (I2+2,sp),a 
    ldw (I2,sp),x 
    ldw x,#hello 
    ldw (STR,sp),x  
    ld a,#'U 
    ld (CHR1,sp),a 
    call format 
    _drop VSIZE 
    ldw y,#buffer
    _dbg_puts  
    trap 
    jra .

test_i24toa: .asciz "\ntest i24toa\n"
test_atoi24: .asciz "\ntest atoi24\n"
test_strlen: .asciz "\ntest strlen\n"
test_fill: .asciz "\ntest fill\n"
test_memcpy: .asciz "\ntest memcpy\n" 
test_format: .asciz "\ntest format\n"
test_strcpy: .asciz "\ntest strcpy\n"

fmt: .asciz "ABC%a%c%a%s%a%d%a%x\n"
number: .asciz "123456"
hello: .asciz "Hello world!"
