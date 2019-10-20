/*
*   declare all exported functions in hal
*/

#ifndef NUCLEO_8S208_H
#define NUCLEO_8S208_H
#include "stm8s208.h"

#define TRUE -1
#define FALSE 0

typedef signed char bool;

//macros
#define LED PIN5   // on board green led connected PC5
#define _ledon() _clrbit(PD_ODR,LED)
#define _ledoff() _setbit(PD_ODR,LED)
#define _ledtoggle() _togglebit(PD_ODR,LED)
#define _enable_dev_clock(reg,dev) _setbit(reg,dev)


// exported functions
// system clock initialization to 16Mhz HSE
extern void clock_init(int wait);
// set GPIO pin direction speed, and pullup
extern void set_pin_mode(int port,int pin, int mode);
// UART3 communication
// enable UART3 communication 8N1
extern void enable_uart(baud_t baud);
// set communication speed
extern void set_baudrate(baud_t baud);
// check if character in receiver.
extern bool qchar();
// read a line of text
extern uint8_t ureadln(char *buff, uint8_t size);
// delete n character left of cursor
void delete_left(uint8_t n);
// unget character received from uart
void ungetchar(signed char c);
//in situ uppercase
void upper(char* str);
// string comparison
int8_t strcmp(const char *s1, const char*s2);
// string copy
char *strcpy(char *dest, const char *src);
// string length
int strlen(const char* str);
// fill str with character 'c'
void memset(char *str,char c, int16_t count);

#endif // NUCLEO_8S208_H
