; NUCLEO-8S208RB board specific definitions

; mcu on board is stm8s208rbt6

; crystal on board is 8Mhz
FHSE = 8000000

; LED2 is user LED
; connected to PC5 via Q2 -> 2N7002 MOSFET
LED2_PORT = 0x500a ;port C
LED2_BIT = 5
LED2_MASK = (1<<5) ;bit 5 mask

; B1 is user button
; connected to PE4
; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
BTN1_PORT = 0x5014 ; port E
BTN1_BIT = 4
BTN1_MASK = (1<<4) ;bit 4 mask

