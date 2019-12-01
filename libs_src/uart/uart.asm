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
;   NOTE: global routines interface designed 
;         to be callable from C with the
;         prototype given. SDCC for stm8 
;         pass functions arguments on stack
;         pushed from right to left.
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

;--------------------------------------
; select uart base register
; private function 
; input:
;   A       UART_ID 
; output:
;   X       uart register base address
;-------------------------------------
    ACC16=1
    LOCAL_SIZE=2
select_uart:
    sub sp,#LOCAL_SIZE
    sll a 
    ld (ACC16+1,sp),a 
    clr (ACC16,sp) 
    ldw x,#uart_regs 
    addw x,(ACC16,sp)
    ldw x,(x)
    addw sp,#LOCAL_SIZE 
    ret

;----------------------------------------------
; initialize UART peripheral
; initilialize config: 8N1 no flow control
; C prototype:  void uart_init(uint8_t baud,uint8_t uart_id)
; input:
;   baud        uint8_t baud
;   uart_id     uin8t_t uart selector {UART1,UART3}
; output:
;   none
;---------------------------------------------
    ARG_OFS=4  
    BAUD=ARG_OFS+1 
    UART=ARG_OFS+2
; local var 
    ACC16=1
    LOCAL_SIZE=2     
uart_init::
    sub sp,#LOCAL_SIZE 
    clr (ACC16,sp)
;configure port
    ld a,(UART,sp)
    jrne uart3
uart1:
	bset PA_DDR,#UART1_TX_PIN ; tx pin
	bset PA_CR1,#UART1_TX_PIN ; push-pull output
	bset PA_CR2,#UART1_TX_PIN ; fast output
    jra config_baud 
uart3:
	bset PD_DDR,#UART3_TX_PIN ; tx pin
	bset PD_CR1,#UART3_TX_PIN ; push-pull output
	bset PD_CR2,#UART3_TX_PIN ; fast output
config_baud:
    call select_uart 
; check whick clock is active    
    ld a,#CLK_SWR_HSE ; HSE clock 8Mhz 
    cp a,CLK_CMSR
    jrne 4$ 
    ldw y,#baud_fcy8
    jra 5$
4$: ldw y,#baud_fcy16 
5$: ld a,(BAUD,sp)
    sll a 
    ld (ACC16+1,sp),a 
    addw y,(ACC16,sp) 
; now Y point to baud rate values for BRR1
; ***** BRR2 must be loaded before BRR1 *****
    ld a,(1,y)
    ld (UART_BRR2,x),a  
    ld a,(y)
    ld (UART_BRR1,x),a 
; enable TX and RX but no interrupts
    ld a,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
    ld (UART_CR2,x),a 
    addw sp,#LOCAL_SIZE 
    ret



;------------------------------------
;  serial port communication routines
;------------------------------------
;------------------------------------
; transmit character in a via UART3
; C prototype: char uart_putc(char c, unit8_t uart)
; input:
;   CHAR        stack argument 
;   UART_ID     stack argument
; output:
;   none 
;------------------------------------
    ARG_OFS=2
    CHAR=ARG_OFS+1
    UART_ID=ARG_OFS+2
uart_putc::
    ld a,(UART_ID,sp)
    call select_uart
1$:	ld a,#(1<<UART_SR_TXE)
    and a,(UART_SR,x)
    jreq 1$
    ld a,(CHAR,sp)
	ld (UART_DR,x),a
    ret

;------------------------------------
; print n spaces 
; C prototype: void uart_spaces(uint8_t n,uint8_t uart_id)
; input: 
;   n  		number of space to print 
;   uart_id   uart selector
; output:
;	none 
;------------------------------------
    ARG_OFS=2
    N=ARG_OFS+1
    UART=ARG_OFS+2
uart_spaces::
	tnz (N,sp)
    jreq 3$
    ld a,(UART,sp)
    push a 
    ld a,#SPACE 
    push a 
    call uart_putc 
    addw sp,#2 
    dec (N,sp)
    jra uart_spaces 
3$: ret

;------------------------------------
; put string to uart channel
; C prototype: void uart_puts(char *str,uint8_t uart)
; input:
;   str         char *string to print
;   uart        uart identifier
; output:
;   none 
;------------------------------------
    ARG_OFS=6
    STR=ARG_OFS+1
    UART=ARG_OFS+3        
uart_puts::
    pushw x 
    pushw y
    ldw y,(STR,sp) 
; check for null pointer  
	cpw y,#0
    jreq 1$ 
    ld a,(UART,sp)
    push a 
0$: ld a,(y)
	jreq 1$
	push a 
    call uart_putc 
    pop a  
	incw y
	jra 0$
1$: pop a 
    popw y 
    popw x 
    ret

;------------------------------------
; check if char available
; return char if available else 0 
; C prototype: char uint8_t uart_query(uint8_t uart_id)
; input:
;   uart_id     uart identifier
; output:
;   A           0 = not char | char 
;------------------------------------
    ARG_OFS=4
    UART=ARG_OFS+1
uart_query::
    pushw x 
    ld a,(UART,sp)
    call select_uart 
1$: ld a,#(1<<UART_SR_RXNE) 
	and a,(UART_SR,x)
    jreq 2$
    ld a,(UART_DR,x)
2$: popw x 
    ret 

;------------------------------------
; wait for character from uart
; C prototype: char uart_getc(uint8_t uart_id)
; input:
;   uart_id     uart_identifier
; output:
;   A           character received 
;------------------------------------
    ARG_OFS=4
    UART=ARG_OFS+1    
uart_getc::
    pushw x
    ld a,(UART,sp)
    call select_uart  
1$:	ld a,#(1<<UART_SR_RXNE) 
    and a,(UART_SR,x)
    jreq 1$
	ld a, (UART_DR,x) 
	popw x 
    ret

;------------------------------------
; delete n character from input line
; C prototype: void uart_delete(uint8_t n,uint8_t uart_id)
; input:
;   n           number of characters to delete 
;   uart_id     uart identifier
; output:
;   none 
;------------------------------------
    ARG_OFS=2
    N=ARG_OFS+1 
    UART=ARG_OFS+2
uart_delete::
del_loop:
	tnz (N,sp)
	jreq 1$
    ld a,(UART,sp)
    push a 
	ld a,#BSP
    push a 
	call uart_putc
    ld a,#SPACE
    ld (1,sp),a 
    call uart_putc
    ld a,#BSP
    ld (1,sp),a 
    call uart_putc 
    addw sp,#2 
    dec (N,sp)
    jra del_loop
1$: ret 

