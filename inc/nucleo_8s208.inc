;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NUCLEO-8S208RB board specific definitions
; Date: 2019/10/29
; author: Jacques Deschênes, copyright 2018,2019
; licence: GPLv3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; mcu on board is stm8s208rbt6

; crystal on board is 8Mhz
FHSE = 8000000

; LED2 is user LED
; connected to PC5 via Q2 -> 2N7002 MOSFET
LED2_PORT = 0x500a ;port C  ODR
LED2_BIT = 5
LED2_MASK = (1<<LED2_BIT) ;bit 5 mask

; B1 on schematic is user button
; connected to PE4
; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
USR_BTN_PORT = 0x5015 ; port E  IDR
USR_BTN_BIT = 4
USR_BTN_MASK = (1<<USR_BTN_BIT) ;bit 4 mask


