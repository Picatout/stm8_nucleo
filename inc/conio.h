/*
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
;   console Input/Output module
;   DATE: 2019-12-05
;   NOTE: global routines interface designed 
;         to be callable from C with the
;         prototype given. SDCC for stm8 
;         pass functions arguments on stack
;         pushed from right to left.
;--------------------------------------
*/

#ifndef CONIO_H
#define CONIO_H

#include <stdint.h>

// baud rate constants
#define B2400 (0)
#define B4800 (1)
#define B9600 (2)
#define B19200 (3)
#define B38400 (4)
#define B57600 (5)
#define B115200 (6)
#define B230400 (7)
#define B460800 (8)
#define B921600 (9)

// available stdio devices
#define UART1 (0)
#define UART3 (1)
#define MAX_GETS (80) // maximum length for gets() buffer

uint8_t conio_init(uint8_t baud, uint8_t dev);
void set_dev(uint8_t dev);
uint8_t get_dev(void);
int getchar(void);
int putchar(int c);
int puts(const char*);
char* gets(char *buffer);
uint8_t is_digit(char c);
uint8_t is_hex(char c);
int printf(const char* fmt,...);


#endif // CONIO_H