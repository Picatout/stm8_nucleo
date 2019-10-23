;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Tue Oct 22 22:08:05 2019
;--------------------------------------------------------
	.module gpio_test
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ;reset
	int 0x0000 ;trap
	int 0x0000 ;int0
	int 0x0000 ;int1
	int 0x0000 ;int2
	int 0x0000 ;int3
	int 0x0000 ;int4
	int 0x0000 ;int5
	int 0x0000 ;int6
	int 0x0000 ;int7
	int 0x0000 ;int8
	int 0x0000 ;int9
	int 0x0000 ;int10
	int 0x0000 ;int11
	int 0x0000 ;int12
	int 0x0000 ;int13
	int 0x0000 ;int14
	int 0x0000 ;int15
	int 0x0000 ;int16
	int 0x0000 ;int17
	int 0x0000 ;int18
	int 0x0000 ;int19
	int 0x0000 ;int20
	int 0x0000 ;int21
	int 0x0000 ;int22
	int 0x0000 ;int23
	int 0x0000 ;int24
	int 0x0000 ;int25
	int 0x0000 ;int26
	int 0x0000 ;int27
	int 0x0000 ;int28
	int 0x0000 ;int29
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	gpio_test.c: 12: int main(){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #8
;	gpio_test.c: 15: PC_DDR|=LED2;
	ldw	x, #0x500c
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	gpio_test.c: 16: PC_CR1|=LED2;
	ldw	x, #0x500d
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	gpio_test.c: 17: while (1){
00103$:
;	gpio_test.c: 18: PC_ODR^=LED2;
	ldw	x, #0x500a
	ld	a, (x)
	xor	a, #0x20
	ld	(x), a
;	gpio_test.c: 19: for (delay=0;delay<DELAY;delay++);
	ldw	x, #0xffff
	ldw	(0x03, sp), x
	clr	a
	clr	(0x01, sp)
00107$:
	ldw	x, (0x03, sp)
	subw	x, #0x0001
	ldw	(0x07, sp), x
	sbc	a, #0x00
	ld	xl, a
	ld	a, (0x01, sp)
	sbc	a, #0x00
	ld	xh, a
	rlwa	x
	ld	(0x01, sp), a
	rrwa	x
	ldw	y, (0x07, sp)
	ldw	(0x03, sp), y
	ld	a, xl
	ldw	y, (0x07, sp)
	jrne	00107$
	tnzw	x
	jreq	00103$
	jra	00107$
	addw	sp, #8
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
