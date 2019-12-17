/*
*   USART functions
*   RX on PD5
*   TX on PD6
*/

#include <stdio.h>
#include "../inc/discovery.h"
#include "../inc/ascii.h"

#define  _no_rx_interrupt() {UART2_CR2&=~UART_CR2_RIEN;}
#define  _rx_interrupt() {UART2_CR2|=UART_CR2_RIEN;}

void enable_uart(baud_t baud){
		set_pin_mode(PD,PIN5,OUTPUT_PP_FAST);
		set_pin_mode(PD,PIN0,OUTPUT_OD_SLOW);
		set_baudrate(baud);
		UART2_CR2=UART_CR2_TEN|UART_CR2_REN|UART_CR2_RIEN;
}

// brr divisor values for Fmaster=16Mhz
static const uint16_t brr_div[]={
		0x1a0b, // 2400
		0xd05,  // 4800
		0x693, // 9600
		0x341, // 19200
		0x1a1, // 38400
		0x116, // 57600
		0x8b, // 115200
		0x45, // 230400
		0x23, // 460800
		0x11, // 921600
};

void set_baudrate(baud_t baud){
	uint16_t br;
	br=brr_div[baud];
	UART2_BRR2=(br&0xf)+((br>>12)&0xf0);
	UART2_BRR1=(br>>4)&0xff;
}

static volatile char rxchar=-1;

// return unwanted character
void ungetchar(signed char c){
	_no_rx_interrupt();
	if (rxchar==-1)rxchar=c;
	_rx_interrupt();
}

// check if character available from UART2
bool qchar(){
	return (rxchar>-1)?TRUE:FALSE;
}

// get a character from UART2
char getchar(){
	char c;
	while (rxchar==-1);
	_no_rx_interrupt();
	c=rxchar;
	rxchar=-1;
	_rx_interrupt();
	return c;
}

// send a character via uart2
void putchar(char c){
	while (!(UART2_SR&UART_SR_TXE));
	UART2_DR=c;
}

void delete_left(uint8_t count){
	while(count){
		putchar(CTRL_H);
		putchar(' ');
		putchar(CTRL_H);
		count--;
	}
}

// read a line of text from UART2
// return line length
uint8_t ureadln(char *buf, uint8_t size){
	signed char c;
	uint8_t eol=0,len=0;
	
	while (!eol){
		c=getchar();
		switch(c){
		case '\n':
		case '\r':
			putchar('\n');
			buf[len]=0;
			eol=1;
			break;
		case CTRL_C:
			*buf=0;
			return 0;
		case CTRL_H:
			if (len){
				putchar(CTRL_H);
				len--;
				putchar(' ');
				putchar(CTRL_H);
			}
			break;
		case CTRL_R:
			if (!len){
			 while (len<size && buf[len])len++;
			 printf(buf);
			}
			break;
		case CTRL_X:
			delete_left(len);
			len=0;
			break;
		default:
			if ((c>=' ') && (len<size)){
				putchar(c);
				buf[len++]=c;
			}
		}//switch
	}//while
	return len;
}


// uart interrupt service routine
// used to received character
void uart2_rx_isr(void) __interrupt(INT_UART2_RX_FULL){
		uint8_t status,dr;
		
		status=UART2_SR;
		dr=UART2_DR;
		if (status && UART_SR_RXNE){
			rxchar=dr;
		}
}

