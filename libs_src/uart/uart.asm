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
;   UART peripherals module
;   DATE: 2019-11-29
;--------------------------------------
    .module UART

    .nlist
	.include "../../inc/nucleo_8s208.inc"
	.include "../../inc/stm8s208.inc"
	.include "../../inc/ascii.inc"
    .list 

    .area DATA 

    .area CODE 
.asciz "UART"
; contain uarts registers base address
uart_regs: .word UART1_BASE,UART3_BASE 
uart_port: .byte UART1_PORT,UART3_PORT
uart_tx_pin: .byte (1<<UART1_TX_PIN), (1<<UART3_TX_PIN)

; baud rate constants for BRR1 and BRR2 
; Fcy=8Mhz , HSI
baud_fcy8:
    .byte 0xd0,0x05 ; 2400 
    .byte 0x68,0x03 ; 4800
    .byte 0x34,0x01 ; 9600
    .byte 0x1a,0x01 ; 19200
    .byte 0x0d,0x00 ; 38400
    .byte 0x08,0x0b ; 57600
    .byte 0x04,0x05 ; 115200 
    .byte 0x02,0x03 ; 230400
    .byte 0x01,0x01 ; 460800 
; Fcy=16Mhz, HSE maximum frequency
baud_fcy16:
    .byte 0xa0,0x1b ; 2400 
    .byte 0xd0,0x05 ; 4800 
    .byte 0x68,0x03 ; 9600
    .byte 0x34,0x01 ; 19200
    .byte 0x1a,0x01 ; 38400
    .byte 0x0d,0x00 ; 57600
    .byte 0x08,0x0b ; 115200
    .byte 0x04,0x05 ; 230400 
    .byte 0x02,0x03 ; 460800
    .byte 0x01,0x01 ; 921600 

;----------------------------------------------
; initialize UART peripheral
; initilialize config: 8N1 no flow control
; input:
;   baud        uint8_t baud rate constant 
;   uart_nbr    uin8t_t uart selector {UART1,UART3}  
; output:
;   none
;---------------------------------------------
    ARG_OFS=2
    BAUD=ARG_OFS+1 
    UART_ID=ARG_OFS+2
uart_init::
;configure port 
    ldw x,#GPIO_BASE
    ld a,(UART_ID,sp)
    ldw y,#uart_port 
    add a,yl
    jrnc 1$
    inc yh
1$: ld yl,a 
    ld a,(y)
    add a,xl
    jrnc 2$
    inc xh 
2$: ld xl,a 
    ldw y,#uart_tx_pin 
    ld a,(UART_ID,sp)
    add a,yl 
    jrnc 3$
    inc xh 
3$: ld yl,a 
    ld a,(y)
    or a,(GPIO_DDR,x)
    ld (GPIO_DDR,x),a 
    ld a,(y)
    or a,(GPIO_CR1,x)
    ld (GPIO_CR1,x),a 
    ld a,(y)
    or a,(GPIO_CR2,x)
    ld (GPIO_CR2,x),a 
;configure baud rate 
    ldw x,#uart_regs 
    ld a,(UART_ID,sp)
    sll a 
    add a,xl 
    jrnc 4$
    inc xh 
4$: ld xl,a 
    ldw x,(x)
    ld a,#0xB4 ; HSE clock 8Mhz 
    cp a,CLK_SWR
    jrne fcy16 
fcy8:
    ldw y,#baud_fcy8
    jra 5$
fcy16:
    ldw y,#baud_fcy16 
5$: ld a,(BAUD,sp)
    sll a 
    add a,yl 
    jrnc 6$
    inc yh 
6$: ld yl,a 
    ld a,(y)
    ld (UART_BRR1,x),a 
    incw y 
    ld a,(y)
    ld (UART_BBR2,x),a 
    ld a,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
    ld (UART_CR2,x),a 
    ret

; initialize UART3, 115200 8N1
uart3_init::
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
	ret
	


;------------------------------------
; print n spaces 
; input: 
;   A  		number of space to print 
; output:
;	none 
;------------------------------------
spaces::
	push a 
	ld a,#SPACE 
1$:	tnz (1,sp)
	jreq 2$ 
	call uart_tx 
	dec (1,sp)
	jra 1$
2$:	pop a 
	ret


;------------------------------------
;  serial port communication routines
;------------------------------------
;------------------------------------
; transmit character in a via UART3
; character to transmit on (3,sp)
;------------------------------------
uart_tx::
	tnz UART3_SR
	jrpl uart_tx
	ld UART3_DR,a
    ret

;------------------------------------
; send string via UART2
; y is pointer to str
;------------------------------------
uart_print::
; check for null pointer  
	cpw y,#0
    jreq 1$ 
0$: ld a,(y)
	jreq 1$
	call uart_tx
	incw y
	jra 0$
1$: ret

;------------------------------------
; check if char available
;------------------------------------
uart_qchar::
	tnz rx_char
	jreq 1$
    ret
1$: ld a,#UART_SR_RXNE 
	and a,UART3_SR
	ret 

;------------------------------------
; return char in A to queue
;------------------------------------
;ungetchar:: 
	ld rx_char,a
    ret
    
;------------------------------------
; wait for character from uart3
;------------------------------------
uart_getchar::
; if there is a char in rx_char return it.
	ld a,rx_char 
	jreq 1$
	clr rx_char
	ret
1$:	btjf UART3_SR,#UART_SR_RXNE,.
	ld a, UART3_DR 
	ret

;------------------------------------
; delete n character from input line
;------------------------------------
uart_delete::
	push a ; n 
del_loop:
	tnz (1,sp)
	jreq 1$
	ld a,#BSP
	call uart_tx
    ld a,#SPACE
    call uart_tx
    ld a,#BSP
    call uart_tx
    dec (1,sp)
    jra del_loop
1$: pop a
	ret 

