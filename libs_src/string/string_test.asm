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
    .list 

    .area DATA 
buffer: .ds 80 
    
    .area CODE 

test_main::
; test atoi24
    ldw x,#number
    pushw x 
    call atoi24
    _drop 2  
    trap
; test strlen  
    _vars 2 
    ldw x,#hello 
    ldw (1,sp),x 
    call strlen 
    _drop 2 
    trap 
; test strcpy
    _vars 4 
    ldw x,#buffer 
    ldw (1,sp),x 
    ldw x,#hello 
    ldw (3,sp),x 
    call strcpy 
    _drop 4 
    trap 
; test memcpy 
    _vars 6
    ldw x,#12 
    ldw (5,sp),x
    ldw x,#buffer
    ldw (3,sp),x 
    addw x,#12  
    ldw (1,sp),x
    call memcpy  
    _drop 6 
    trap 
; test fill
    _vars 4
    ldw x,#buffer 
    ldw (1,sp),x 
    ld a,#SPACE 
    ld (3,sp),a 
    ld a,#24 
    ld (4,sp),a 
    call fill
    _drop 4 
    trap 
; test i24toa
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
    trap 
; test format
    STR=1 ; 2
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
    ldw (STR,sp),x  
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
    trap 
    pushw x 
    call puts 
    trap 

    jra .


fmt: .asciz "ABC%a%c%a%s%a%d%a%x\n"
number: .asciz "123456"
hello: .asciz "Hello world!"
