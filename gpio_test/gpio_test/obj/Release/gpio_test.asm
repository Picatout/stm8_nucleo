;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
; This file was generated Tue Oct 22 21:47:16 2019
;--------------------------------------------------------
	.module gpio_test
	.optsdcc -mmcs51 --model-small
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
	.area RSEG    (ABS,DATA)
	.org 0x0000
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	.area REG_BANK_0	(REL,OVR,DATA)
	.ds 8
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	.area DSEG    (DATA)
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	.area	OSEG    (OVR,DATA)
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	.area ISEG    (DATA)
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	.area IABS    (ABS,DATA)
	.area IABS    (ABS,DATA)
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	.area BSEG    (BIT)
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	.area PSEG    (PAG,XDATA)
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	.area XSEG    (XDATA)
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area XABS    (ABS,XDATA)
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	.area XISEG   (XDATA)
	.area HOME    (CODE)
	.area GSINIT0 (CODE)
	.area GSINIT1 (CODE)
	.area GSINIT2 (CODE)
	.area GSINIT3 (CODE)
	.area GSINIT4 (CODE)
	.area GSINIT5 (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area CSEG    (CODE)
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME    (CODE)
__interrupt_vect:
	ljmp	__sdcc_gsinit_startup
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME    (CODE)
	.area GSINIT  (CODE)
	.area GSFINAL (CODE)
	.area GSINIT  (CODE)
	.globl __sdcc_gsinit_startup
	.globl __sdcc_program_startup
	.globl __start__stack
	.globl __mcs51_genXINIT
	.globl __mcs51_genXRAMCLEAR
	.globl __mcs51_genRAMCLEAR
	.area GSFINAL (CODE)
	ljmp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME    (CODE)
	.area HOME    (CODE)
__sdcc_program_startup:
	ljmp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CSEG    (CODE)
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;delay                     Allocated to registers r4 r5 r6 r7 
;------------------------------------------------------------
;	gpio_test.c:12: int main(){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	ar7 = 0x07
	ar6 = 0x06
	ar5 = 0x05
	ar4 = 0x04
	ar3 = 0x03
	ar2 = 0x02
	ar1 = 0x01
	ar0 = 0x00
;	gpio_test.c:15: PC_DDR|=LED2;
	mov	dptr,#0x500C
	mov	b,#0x00
	lcall	__gptrget
	mov	r7,a
	orl	ar7,#0x20
	mov	dptr,#0x500C
	mov	b,#0x00
	mov	a,r7
	lcall	__gptrput
;	gpio_test.c:16: PC_CR1|=LED2;
	mov	dptr,#0x500D
	mov	b,#0x00
	lcall	__gptrget
	mov	r7,a
	orl	ar7,#0x20
	mov	dptr,#0x500D
	mov	b,#0x00
	mov	a,r7
	lcall	__gptrput
;	gpio_test.c:17: while (1){
00103$:
;	gpio_test.c:18: PC_ODR^=LED2;
	mov	dptr,#0x500A
	mov	b,#0x00
	lcall	__gptrget
	mov	r7,a
	xrl	ar7,#0x20
	mov	dptr,#0x500A
	mov	b,#0x00
	mov	a,r7
	lcall	__gptrput
;	gpio_test.c:19: for (delay=0;delay<DELAY;delay++);
	mov	r4,#0xFF
	mov	r5,#0xFF
	mov	r6,#0x00
	mov	r7,#0x00
00107$:
	mov	a,r4
	add	a,#0xFF
	mov	r0,a
	mov	a,r5
	addc	a,#0xFF
	mov	r1,a
	mov	a,r6
	addc	a,#0xFF
	mov	r2,a
	mov	a,r7
	addc	a,#0xFF
	mov	r3,a
	mov	ar4,r0
	mov	ar5,r1
	mov	ar6,r2
	mov	ar7,r3
	mov	a,r0
	orl	a,r1
	orl	a,r2
	orl	a,r3
	jnz	00107$
;	gpio_test.c:21: return 0;
	sjmp	00103$
	.area CSEG    (CODE)
	.area CONST   (CODE)
	.area XINIT   (CODE)
	.area CABS    (ABS,CODE)
