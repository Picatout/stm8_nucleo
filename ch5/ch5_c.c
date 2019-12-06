#include <stdint.h>


#define UART3 (1)
#define B115200 (6)
// prototype des fonctions en assembleur 
// fonctions dans uart.lib
void uart_init(uint8_t baud,uint8_t uart_id);
int uart_puts(char *str,uint8_t uart_id);
// fonctions dans ch4_demo.asm
void clock_init(void);
void led_init(void);
void loop(char *msg);

// change l'état de la LED en accord avec
// l'argument state. retourne l'état final
// de la LED
#define LED_OFF 0
#define LED_ON 1
#define LED_TOGGLE 2
#define LED_PORT *((uint8_t*)0x500a)
#define LED_MASK (1<<5)
uint8_t led_switch(uint8_t state){
    switch(state){
        case LED_ON:
        LED_PORT|=LED_MASK;
        break;
        case LED_OFF:
        LED_PORT&=~LED_MASK;
        break;
        case LED_TOGGLE:
        LED_PORT^=LED_MASK;
        break;
    };
    return (LED_PORT&LED_MASK)>>5;
}

void main(void){
    clock_init();
    led_init();
    uart_init(B115200,UART3);
    uart_puts("\n\nAppel de la fonction 'loop' dans ch5_asm.asm ...\n",UART3);
    loop("Maintenant sur la ligne de commande de 'loop'.\n");
    uart_puts("... sortie de la fonction loop.\nDe retour dans main().\n",UART3);
    uart_puts("Pressez le bouton RESET pour recommencer.\n",UART3);
    while(1);
}

