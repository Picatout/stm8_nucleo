#include "../../inc/conio.h"

static char text[MAX_GETS];

void uart_init(uint8_t,uint8_t);
char uart_getc(uint8_t);
void uart_putc(char,uint8_t);

static void clock_init(){
__asm 
    .include "../../inc/stm8s208.inc"
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
__endasm;
}

void main(void){
    char *line;
    clock_init();
    conio_init(B115200,UART3);
    puts("Enter text\n");
    line=gets(text);
    puts(line);
    puts("\ngetc()/putc() test\n");
    putchar('?');
    while(1) putchar(getchar());
}


