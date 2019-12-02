/***************************************************************
*   tutoriel sdas pour stm8
*   chapitre 5  interface entre C et assembleur dans les 2 sens.
*   Date: 2019-11-01
*   Copyright Jacques Deschêens, 2019
*   licence:  CC-BY-SA version 2 ou ultérieure
*
*   Description: 
*       Utilise la librairie math.lib 
***************************************************************/

#ifndef MATH24_H
#define MATH24_H
#include <stdint.h>

typedef  struct{
     i8:8;
    int16_t i16:16;
}int24_t;

typedef struct{
    uint32_t u24:24;
}uint24_t;


//typedef  uint8_t[3] uint24_t;

int24_t add24(int24_t n1, int24_t n2);
int24_t sub24(int24_t n1,in24_t n2);
//uint24_t mul24_8u(uint24_t n1, uint8_t n2)


#endif //MATH24_H 