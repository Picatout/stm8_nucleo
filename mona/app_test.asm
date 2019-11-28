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

;  MONA   MONitor written in Assembly
	.module APPLICATION_TEST 

	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
	.include "../inc/ascii.inc"
	.include "mona.inc"
	.list
	.page

    .area CODE 


	.ascii "USER_APP"
;	.bndry 128 ; align on FLASH block.
; following flash memory is not used by MONA
mona_end::
	AUTO_APP=0 ; 1 to execute application at reset 
.if AUTO_APP
	nop  
.else
	.byte 0
.endif
blink:
	ldw y,#hello
	call uart_print 
blink_loop:	
	ld a,LED2_PORT
	xor a,#LED2_MASK
	ld LED2_PORT,a 
	ldw y,#8 
1$: ldw x,#0xffff
2$:	decw x 
	jrne 2$
    decw y 
    jrne 1$
	jra blink_loop 

hello: .asciz "Hello from blinky\n"

	TEST=0 ; set to 1 to assemble dams test code.
.if TEST=1 
dasm_test:
	jra . 
	jrf .
	jrugt .
	jrule .
	jrnc .
	jrc .
	jrne .
	jreq .
	jrnv .
	jrv .
	jrpl .
	jrmi .
	jrsgt .
	jrsle .
	jrsge .
	jrslt .
	jruge .
	jrt .
	jrult .
	jrnh .
	jrh .
	jrnm .
	jrm . 
	jril .
	jrih .
	btjt 0x1000,#0,.
	btjf 0x1000,#0,.
	btjt 0x1000,#7,.
	btjf 0x1000,#7,.
	bset 0x2000,#0
	bres 0x2000,#0
	bset 0x2000,#7
	bres 0x2000,#7
	bcpl 0x3000,#0
	bccm 0x3000,#0
	bcpl 0x3000,#7
	bccm 0x3000,#7

	jpf 0x210000
	callf 0x20000
	neg a 
	cpl a 
	srl a 
	rrc a 
	sra a 
	sll a 
	rlc a 
	dec a 
	inc a 
	tnz a 
	swap a 
	clr a 
	jp(y)
	call(y)
	jp ([0xc0],x)
	call ([0xc0],x)

	adc a,0x1000
	bcp a,(x)
	sub a,0x1000
	sbc a,0x2000
	jp (0x1000,x)
	call (0x1000,x)
	jp (0x10,x)
	call (0x10,x)
	subw y,#0x1000
	addw y,#0x2000
	subw x,0x1000
	subw y,0x1000
	addw x,0x1000
	addw y,0x1000
	sub a,([0xc000],x)
	cp a,([0xc000],x)
	sbc a,([0xc000],x)
	cpw y,([0xc000],x)
	sub a,([0xc000],x)
	and a,([0xc000],x)
	bcp a,([0xc000],x)
	ld a,([0xc000],x)
	xor a,([0xc000],x)
	adc a,([0xc000],x)
	or a,([0xc000],x)
	add a,([0xc000],x)
	ldw x,([0xc000],x)

	add a,#0x55
	add a,0x10
	add a,0x1000
	add a,(x)
	add a,(0x10,x)
	add a,(0x1000,x)
	add a,(y)
	add a,(0x10,y)
	add a,(0x1000,y)
	add a,(0x10,sp)
	add a,[0x10]
	add a,[0x2000]
	add a,([0xa0],x)
	add a,([0x1000],x)
	add a,([0x10],y)

	add a,(y)
	addw x,#0x1000
	addw x,0x1000
	addw x,(0x10,sp)
	addw y,#0x2000
	addw y,0x3000
	addw y,(0x20,sp)
	addw sp,#9
	ld a,#0x55
	ld a,0x55
	ld a,0x5000
	ld a,(x)
	ld a,(0x55,x)
	ld a,(0x55aa,x)
	ld a,(y)
	ld a,(0x50,y)
	ld a,(0x5000,y)
	ld a,(0x50,sp)
	ld a,[0x50]
	ld a,[0x5000]
	ld a,([0x50],x)
	ld a,([0x5000],x)
	ld a,([0x50],y)
	ld 0x50,a 
	ld 0x5000,a 
	ld (x),a 
	ld (0x50,x),a 
	ld (0x5000,x),a 
	ld (y),a 
	ld (0x50,y),a 
	ld (0x5000,y),a 
	ld (0x50,sp),a 
	ld [0x50],a 
	ld [0x5000],a 
	ld ([0x50],x),a 
	ld ([0x5000],x),a 
	ld ([0x50],y),a 
	ld xl,a 
	ld a,xl 
	ld yl,a 
	ld a,yl 
	ld xh,a 
	ld a,xh 
	ld yh,a 
	ld a,yh 
	ldf a,0x50000 
	ldf a,(0x50000,x)
	ldf a,(0x50000,y)
	ldf a,([0x5000],x)
	ldf a,([0x5000],y)
	ldf a,[0x5000]
	ldf 0x50000,a 
	ldf (0x50000,x),a 
	ldf (0x50000,y),a 
	ldf ([0x5000],x),a 
	ldf ([0x5000],y),a 
	ldf [0x5000],a
	ldw x,#0x55aa 
	ldw x,0x50 
	ldw x,0x5000
	ldw x,(x)
	ldw x,(0x50,x)
	ldw x,(0x5000,x)
	ldw x,(0x50,sp)
	ldw x,[0x50]
	ldw x,[0x5000]
	ldw x,([0x50],x)
	ldw x,([0x5000],x)
	ldw 0x50,x 
	ldw 0x5000,x 
	ldw (x),y 
	ldw (0x50,x),y 
	ldw (0x5000,x),y 
	ldw (0x50,sp),x 
	ldw [0x50],x 
	ldw [0x5000],x 
	ldw ([0x50],x),y 
	ldw ([0x5000],x),y 
	ldw y,#0x55aa 
	ldw y,0x50 
	ldw y,0x5000 
	ldw y,(y)
	ldw y,(0x50,y)
	ldw y,(0x5000,y)
	ldw y,(0x50,sp)
	ldw y,[0x50]
	ldw y,([0x50],y)
	ldw 0x50,y 
	ldw 0x5000,y 
	ldw (y),x 
	ldw (0x50,y),x 
	ldw (0x5000,y),x 
	ldw (0x50,sp),y 
	ldw [0x50],y 
	ldw ([0x50],y),x 
	ldw y,x 
	ldw x,y 
	ldw x,sp 
	ldw sp,x 
	ldw y,sp 
	ldw sp,y 
	neg (0x10,sp)
	cpl (0x10,sp)
	srl (0x10,sp)
	rrc (0x10,sp)
	sra (0x10,sp)
	sll (0x10,sp)
	rlc (0x10,sp)
	dec (0x10,sp)
	inc (0x10,sp)
	tnz (0x10,sp)
	swap (0x10,sp)
	clr (0x10,sp)
	neg (0x20,x)
	neg (0x30,y)
	ccf 
	clr a 
	exgw x,y 
	neg (x)
	neg (y)
	adc a,(x)
	adc a,(y)
	cpw x,(y)
	cpw y,(x)
	callr . 
	sub a,(0x10,sp)
	cpw x,(0x20,sp)
	bset 0x1000,#1
	bres 0x1000,#7
	bcpl 0x1000,#6
	bccm 0x600,#1
	mov 0x2000,#0x55 
	mov 0xc0,0xf0 
	mov 0x1234,0x5678
	ld a,#64
	cpw y,(0x10,x)
	jpf 0x12345
	callf 0x56789 
	exgw x,y
	exg a,xl 
	cplw X 
	cplw y 
	iret
	ccf
	scf
	sim
	rim
	btjf 0x1000,#0,.
	btjt 0x1000,#0,.  
	btjf 0x1000,#1,.
	btjt 0x1000,#1,.  
	btjf 0x1000,#2,.
	btjt 0x1000,#2,.  
	btjf 0x1000,#3,.
	btjt 0x1000,#3,.  
	btjf 0x1000,#4,.
	btjt 0x1000,#4,.  
	btjf 0x1000,#5,.
	btjt 0x1000,#5,.  
	btjf 0x1000,#6,.
	btjt 0x1000,#6,.  
	btjf 0x1000,#7,.
	btjt 0x1000,#7,.  
	push #0x44
	callf .
	callf [farptr]
	iret 
	ret 
	pop a 
	popw x
	popw y 
	pop cc 
	retf 
	push a 
	pushw x 
	pushw y 
	pop cc 
	break 
	ccf 
	halt 
	wfi 
	wfe 
	rcf 
	scf 
	rim 
	sim 
	rvf 
	nop 
	rrwa x 
	rlwa x 
	rrwa y
	rlwa y 
	neg (0,sp)
	cpl (3,sp) 
	srl (4,sp) 
	rrc (6,sp)
	sra (7,sp)
	rlc (9,sp)
	dec (0xa,sp)
	inc (0xc,sp)
	tnz (0xe,sp)
	clr (15,sp)
	bset 0x6000,#0
	bres 0x6000,#0
	bcpl 0x6000,#7
	bccm 0x6000,#7
	sub a,(0x10,sp)
	cp a,(0x10,sp)
	sbc a,(0x10,sp)
	cpw x,(0x10,sp)
	and a,(0x10,sp)
	bcp a,(0x10,sp)
	xor a,(0x10,sp)
	adc a,(0x10,sp)
	or a,(0x10,sp) 
	add a,(0x10,sp)
	addw x,#0x1000
	subw x,#0x1000
	neg 0xc0 
	exg a,0x8000 
	pop 0x6000
	cpl 0xc0
	srl 0xc0
	mov 0x6000,#32
	rrc 0xc0
	sra 0xc0
	sll 0xc0
	rlc 0xc0
	dec 0xc0
	push 0x6020
	inc 0xc0
	tnz 0xc0
	swap 0xc0
	clr 0xc0
	clr [0x8080]
	clr [0xd0]
	neg [0x8004]
	neg [0xc0] 
	mul x,a
	mul y,a  
	mov 0xc0,0xd0
	mov 0x1000,0x2000 
	push 0xaa55 
	exg a,xl
	neg a 
	cpl a
	srl a 
	rrc a 
	sra a 
	sll a 
	rlc a 
	dec a 
	inc a 
	tnz a 
	swap a 
	clr a 
	negw x
	sraw y 
	sraw x 
	exgw x,y 
	addw sp,#4
	exg a,yl 
	div x,a 
	div x,y 
	neg(0xc0,x)
	neg ([0x1000],x)
	neg (0xd0,y)
	neg ([0xd0],y)
	neg ([0xc0],x)
	clr (0x10,x)
	clr ([0x1001],x)
	clr (0x10,y)
	clr ([0x20],y)
	clr ([0x40],x)
	neg (x)
	neg (y)
	rlc (x)
	rlc (y)
	ld a,(8,sp)
	swap(x)
	swap(y)
	nop 
.endif 
