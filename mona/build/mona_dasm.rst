ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of MONA 
                                      4 ;
                                      5 ;     MONA is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     MONA is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;----------------------------------------------------------------------------
                                     19 ;   Here how I proceded:
                                     20 ; according to this table: https://en.wikipedia.org/wiki/STM8#Instruction_set
                                     21 ; I tried to group opcode sharing the same common bits field. For exemple
                                     22 ; jrxx instruction all begin with 0010 . Only the least 4 bits changes to
                                     23 ; indicate what condition to test. So I decode them in reljump group. 
                                     24 ;-----------------------------------------------------------------------------
                                     25 
                                     26 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     27 ;   MONA desassembler
                                     28 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     29     .module DASM 
                                            .include "../inc/ascii.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        
                                        ;-------------------------------------------------------
                                        ;     ASCII control  values
                                        ;     CTRL_x   are VT100 keyboard values  
                                        ;-------------------------------------------------------
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        	.include "mona.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        
                                        ;  MONA   MONitor written in Assembly
                                        	.module MONA 
                                            .optsdcc -mstm8
                                        ;	.nlist
                                        	.include "../inc/nucleo_8s208.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ; NUCLEO-8S208RB board specific definitions
                                        ; Date: 2019/10/29
                                        ; author: Jacques Deschênes, copyright 2018,2019
                                        ; licence: GPLv3
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        
                                        ; mcu on board is stm8s208rbt6
                                        
                                        ; crystal on board is 8Mhz
                                 
                                        
                                        ; LED2 is user LED
                                        ; connected to PC5 via Q2 -> 2N7002 MOSFET
                                 
                                 
                                 
                                        
                                        ; B1 on schematic is user button
                                        ; connected to PE4
                                        ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                                 
                                 
                                 
                                        
                                        
                                        	.include "../inc/stm8s208.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ; 2019/10/18
                                        ; STM8S208RB µC registers map
                                        ; sdas source file
                                        ; author: Jacques Deschênes, copyright 2018,2019
                                        ; licence: GPLv3
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        	.module stm8s208rb
                                        
                                        ;;;;;;;;;;;;
                                        ; bits
                                        ;;;;;;;;;;;;
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                         	
                                        ;;;;;;;;;;;;
                                        ; bits masks
                                        ;;;;;;;;;;;;
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; HSI oscillator frequency 16Mhz
                                 
                                        ; LSI oscillator frequency 128Khz
                                 
                                        
                                        ; controller memory regions
                                 
                                 
                                        ; STM8S208RB have 128K flash
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; options bytes
                                        ; this one can be programmed only from SWIM  (ICP)
                                 
                                        ; these can be programmed at runtime (IAP)
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; option registers usage
                                        ; read out protection, value 0xAA enable ROP
                                 
                                        ; user boot code, {0..0x3e} 512 bytes row
                                 
                                 
                                        ; alternate function register
                                 
                                 
                                        ; miscelinous options
                                 
                                 
                                        ; clock options
                                 
                                 
                                        ; HSE clock startup delay
                                 
                                 
                                        ; flash wait state
                                 
                                 
                                        
                                        ; watchdog options bits
                                 
                                 
                                 
                                 
                                        ; NWDGOPT bits
                                 
                                 
                                 
                                 
                                        
                                        ; CLKOPT bits
                                 
                                 
                                 
                                 
                                        
                                        ; AFR option, remapable functions
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; device ID = (read only)
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        
                                 
                                 
                                        ; PORTS SFR OFFSET
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; GPIO
                                        ; gpio register offset to base
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; port A
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port B
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port C
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port D
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port E
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port F
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port G
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port H not present on LQFP48/LQFP64 package
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; input modes CR1
                                 
                                 
                                        ; output mode CR1
                                 
                                 
                                        ; input modes CR2
                                 
                                 
                                        ; output speed CR2
                                 
                                 
                                        
                                        
                                        ; Flash memory
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; data memory unlock keys
                                 
                                 
                                        ; flash memory unlock keys
                                 
                                 
                                        ; FLASH_CR1 bits
                                 
                                 
                                 
                                 
                                        ; FLASH_CR2 bits
                                 
                                 
                                 
                                 
                                 
                                        ; FLASH_FPR bits
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; FLASH_NFPR bits
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; FLASH_IAPSR bits
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Interrupt control
                                 
                                 
                                        
                                        ; Reset Status
                                 
                                        
                                        ; Clock Registers
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Peripherals clock gating
                                        ; CLK_PCKENR1 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        ; CLK_PCKENR2
                                 
                                 
                                 
                                        
                                        ; Clock bits
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        ; clock source
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Watchdog
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Beeper
                                        ; beeper output is alternate function AFR7 on PD4
                                        ; connected to CN9-6
                                 
                                 
                                 
                                 
                                        
                                        ; SPI
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; I2C
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                        
                                        ; Precalculated values, all in KHz
                                 
                                 
                                        ;
                                        ; Fast I2C mode max rise time = 300ns
                                        ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                        ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                        
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                        ;
                                        ; Standard I2C mode max rise time = 1000ns
                                        ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                        ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                        
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                        ; baudrate constant for brr_value table access
                                        ; to be used by uart_init 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; UART registers offset from
                                        ; base address 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; uart identifier
                                        ; to be used by uart_init
                                 
                                 
                                 
                                        
                                        ; pins used by uart 
                                 
                                 
                                 
                                 
                                        ; uart port base address 
                                 
                                 
                                        
                                        ; UART1 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; UART3
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; UART Status Register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Uart Control Register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        ; LIN mode config register
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; TIMERS
                                        ; Timer 1 - 16-bit timer with complementary PWM outputs
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer Control Register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer Slave Mode Control bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer External Trigger Enable bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer Interrupt Enable bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer Status Register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                        
                                        ; Timer Event Generation Register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Capture/Compare Mode Register 1 - channel configured in output
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Capture/Compare Mode Register 1 - channel configured in input
                                 
                                 
                                 
                                 
                                 
                                 
                                        ;  TIM1_CCMR1_CC1S1 = (1)
                                 
                                        
                                        ; Capture/Compare Mode Register 2 - channel configured in output
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Capture/Compare Mode Register 2 - channel configured in input
                                 
                                 
                                 
                                 
                                 
                                 
                                        ;  TIM1_CCMR2_CC2S1 = (1)
                                 
                                        
                                        ; Capture/Compare Mode Register 3 - channel configured in output
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Capture/Compare Mode Register 3 - channel configured in input
                                 
                                 
                                 
                                 
                                 
                                 
                                        ;  TIM1_CCMR3_CC3S1 = (1)
                                 
                                        
                                        ; Capture/Compare Mode Register 4 - channel configured in output
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Capture/Compare Mode Register 4 - channel configured in input
                                 
                                 
                                 
                                 
                                 
                                 
                                        ;  TIM1_CCMR4_CC4S1 = (1)
                                 
                                        
                                        ; Timer 2 - 16-bit timer
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer 3
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; TIM3_CR1  fields
                                 
                                 
                                 
                                 
                                 
                                        ; TIM3_CCR2  fields
                                 
                                 
                                 
                                        ; TIM3_CCER1 fields
                                 
                                 
                                 
                                 
                                        ; TIM3_CCER2 fields
                                 
                                 
                                        
                                        ; Timer 4
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Timer 4 bitmasks
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                        
                                 
                                        
                                 
                                        
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; ADC2
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                         
                                        ; ADC bitmasks
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                        ; beCAN
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        
                                        ; CPU
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; global configuration register
                                 
                                 
                                 
                                        
                                        ; interrupt control registers
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; SWIM, control and status register
                                 
                                        ; debug registers
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Interrupt Numbers
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Interrupt Vectors
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ; Condition code register bits
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        	.include "../inc/ascii.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        
                                        ;-------------------------------------------------------
                                        ;     ASCII control  values
                                        ;     CTRL_x   are VT100 keyboard values  
                                        ;-------------------------------------------------------
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        ;	.list
                                        
                                        	.macro idx_tbl name value ptr  
                                        
                                        ;-------------------------------------
                                        ;   MONA global assembler constants 
                                        ;-------------------------------------
                                        
                                 
                                 
                                        
                                        ;------------------------------------------
                                        ;    boolean flags in variable 'flags'
                                        ;------------------------------------------
                                 
                                 
                                 
                                            .include "mnemonics.inc"
                                        ;;
                                        ; Copyright Jacques Deschênes 2019 
                                        ; This file is part of MONA 
                                        ;
                                        ;     MONA is free software: you can redistribute it and/or modify
                                        ;     it under the terms of the GNU General Public License as published by
                                        ;     the Free Software Foundation, either version 3 of the License, or
                                        ;     (at your option) any later version.
                                        ;
                                        ;     MONA is distributed in the hope that it will be useful,
                                        ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                        ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                        ;     GNU General Public License for more details.
                                        ;
                                        ;     You should have received a copy of the GNU General Public License
                                        ;     along with MONA.  If not, see <http://www.gnu.org/licenses/>.
                                        ;;
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;    STM8  mnemonics table
                                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        
                                            .area CODE 
                                        
                                        ; mnemonics index values
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        
                                        ; mnemonics indexed table 
                                        mnemo_index:
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
                                        
                                        ;-----------------------------------------------
                                        ; Instructions names used by assembler.
                                        ;-----------------------------------------------
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
                                        
                                        ;registers index values
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                        ;-------------------------
                                        ; registers names
                                        ; index table
                                        ;-------------------------
                                        reg_index:
            
            
            
            
            
            
            
            
            
            
            
            
            
            
                                        
                                        
                                        
                                        ; registers names 
                                        registers:
            
            
            
            
            
            
            
            
            
            
            
            
            
                                        
                                     34     .list 
                                     35 
                                     36     .area CODE
      009086 44 41 53 4D             37 .ascii "DASM"
                                     38 ;-----------------------------------------------
                                     39 ;  addressing mode format string
                                     40 ; 
                                     41 ;       r      register
                                     42 ;       b      bit position 
                                     43 ;       imm8   byte immediate value 
                                     44 ;       imm16  word immediate value 
                                     45 ;       extd   24 bits address 
                                     46 ;       ofs8   short offset
                                     47 ;       ofs16  long offset
                                     48 ;       ptr8   short pointer
                                     49 ;       ptr16  long pointer 
                                     50 ;       adr    direct address value 
                                     51 ;       ind    indirect address in register X|Y|SP 
                                     52 ;       rel    relative address
                                     53 ;-----------------------------------------------
                                     54 
                                     55 ; decoder functions index values 
                           000000    56     IDX.FN_IMPL = 0 
                           000001    57     IDX.FN_OFS8_IDX = 1     
                           000002    58     IDX.FN_ADR16_B = 2
                           000003    59     IDX.FN_R_OFS8_IDX = 3 
                           000004    60     IDX.FN_R_IMM8 = 4
                           000005    61     IDX.FN_R_IMM16 = 5 
                           000006    62     IDX.FN_R_IDX = 6
                           000007    63     IDX.FN_IDX_R = 7 
                           000008    64     IDX.FN_R_ADR8 = 8
                           000009    65     IDX.FN_R_ADR16 = 9 
                           00000A    66     IDX.FN_IMM8 = 10
                           00000B    67     IDX.FN_ADR16 = 11 
                           00000C    68     IDX.FN_ADR24 = 12 
                           00000D    69     IDX.FN_ADR8_R = 13
                           00000E    70     IDX.FN_ADR16_R = 14 
                           00000F    71     IDX.FN_ADR24_R = 15
                           000010    72     IDX.FN_R_ADR24 = 16
                           000011    73     IDX.FN_ADR16_IMM8 = 17 
                           000012    74     IDX.FN_ADR16_ADR16=18
                           000013    75     IDX.FN_ADR8_ADR8=19 
                           000014    76     IDX.FN_ADR8 = 20 
                           000015    77     IDX.FN_R_PTR8 = 21
                           000016    78     IDX.FN_R_PTR16 = 22
                           000017    79     IDX.FN_PTR8_R = 23
                           000018    80     IDX.FN_PTR16_R = 24 
                           000019    81     IDX.FN_R_PTR8_IDX = 25 
                           00001A    82     IDX.FN_R_PTR16_IDX = 26 
                           00001B    83     IDX.FN_PTR8_IDX_R = 27
                           00001C    84     IDX.FN_PTR16_IDX_R = 28
                           00001D    85     IDX.FN_OFS8_IDX_R = 29
                           00001E    86     IDX.FN_OFS16_IDX = 30
                           00001F    87     IDX.FN_R_OFS16_IDX = 31 
                           000020    88     IDX.FN_OFS16_IDX_R= 32 
                           000021    89     IDX.FN_R_OFS24_IDX=33
                           000022    90     IDX.FN_OFS24_IDX_R=34 
                           000023    91     IDX.FN_PTR16 = 35 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                           000024    92     IDX.FN_PTR8 = 36
                           000025    93     IDX.FN_PTR16_IDX=37
                           000026    94     IDX.FN_PTR8_IDX=38 
                                     95 
                                     96 ; decoder function indexed table
      000303                         97 fn_index:
      009086 00 00                   98     .word fn_implied ; 0 
      009088 91 5C                   99     .word fn_ofs8_idx ; 1 
      00908A 91 60                  100     .word fn_adr16_bit ; 2 
      00908C 91 64                  101     .word fn_r_ofs8_idx ; 3
      00908E 91 69                  102     .word fn_r_imm8 ; 4
      009090 91 6D                  103     .word fn_r_imm16 ; 5
      009092 91 72                  104     .word fn_r_idx ; 6
      009094 91 76                  105     .word fn_idx_r ; 7 
      009096 91 7B                  106     .word fn_r_adr8 ; 8
      009098 91 81                  107     .word fn_r_adr16 ; 9
      00909A 91 86                  108     .word fn_imm8 ; 10
      00909C 91 8B                  109     .word fn_adr16 ; 11 
      00909E 91 90                  110     .word fn_adr24 ; 12 
      0090A0 91 95                  111     .word fn_adr8_r ; 13
      0090A2 91 9A                  112     .word fn_adr16_r ; 14
      0090A4 91 A0                  113     .word fn_adr24_r ; 15 
      0090A6 91 A6                  114     .word fn_r_adr24 ; 16 
      0090A8 91 AA                  115     .word fn_adr16_imm8 ; 17 
      0090AA 91 AE                  116     .word fn_adr16_adr16 ; 18 
      0090AC 91 B3                  117     .word fn_adr8_adr8 ; 19
      0090AE 91 B6                  118     .word fn_adr8 ; 20
      0090B0 91 BA                  119     .word fn_r_ptr8 ; 21 
      0090B2 91 BF                  120     .word fn_r_ptr16 ; 22
      0090B4 91 C3                  121     .word fn_ptr8_r ; 23 
      0090B6 91 C7                  122     .word fn_ptr16_r ; 24
      0090B8 91 CC                  123     .word fn_r_ptr8_idx ; 25
      0090BA 91 D0                  124     .word fn_r_ptr16_idx ; 26 
      0090BC 91 D5                  125     .word fn_ptr8_idx_r ; 27 
      0090BE 91 D9                  126     .word fn_ptr16_idx_r ; 28 
      0090C0 91 DE                  127     .word fn_ofs8_idx_r ; 29 
      0090C2 91 E3                  128     .word fn_ofs16_idx  ; 30 
      0090C4 91 E7                  129     .word fn_r_ofs16_idx ; 31 
      0090C6 91 EC                  130     .word fn_ofs16_idx_r ; 32 
      0090C8 91 F0                  131     .word fn_r_ofs24_idx; 33
      0090CA 91 F5                  132     .word fn_ofs24_idx_r; 34 
      0090CC 91 F8                  133     .word fn_ptr16; 35 
      0090CE 91 FC                  134     .word fn_ptr8 ; 36 
      0090D0 92 00                  135     .word fn_ptr16_idx ; 37 
      0090D2 92 04                  136     .word fn_ptr8_idx ; 38
                                    137 
                                    138 ;-------------------------------------
                                    139 ;  each opcode as a table entry 
                                    140 ;  that give information on how to 
                                    141 ;  decode it.
                                    142 ;  each entry is a structure.
                                    143 ;  each element of structure is an index for other tables 
                                    144 ;       .byte opcode ; operating code
                                    145 ;       .byte mnemo_idx ; instruction mnemonic index
                                    146 ;       .byte fn* ;   decoder function index  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                    147 ;       .byte dest;  destination index 
                                    148 ;       .byte src;   src index        
                                    149 ;  A 0 in mnemonic field mark end of table 
                                    150 ;-------------------------------------
                           000000   151     FIELD_OPCODE = 0;
                           000001   152     FIELD_MNEMO= 1; 
                           000002   153     FIELD_FN=2;
                           000003   154     FIELD_DEST=3;
                           000004   155     FIELD_SRC=4 
                           000005   156     STRUCT_SIZE=5 ;
                                    157 
                                    158 
                                    159 ; table for opcodes without prefix 
      000351                        160 codes:
                                    161     ; form op (ofs8,r)  0x0n 0x6n 0xED
      0090D4 92 09 92 0D 92         162     .byte 0x00,IDX.NEG,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090D9 11 92 16 92 1B         163     .byte 0x03,IDX.CPL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090DE 92 1F 92 24 92         164     .byte 0x04,IDX.SRL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090E3 29 92 2E 92 33         165     .byte 0x06,IDX.RRC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090E8 92 38 92 3D 92         166     .byte 0x07,IDX.SRA,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090ED 42 92 48 92 4E         167     .byte 0x08,IDX.SLL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090F2 92 54 92 5A 92         168     .byte 0x09,IDX.RLC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090F7 5E 92 64 92 6A         169     .byte 0x0a,IDX.DEC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090FC 92 70 92 76 92         170     .byte 0x0c,IDX.INC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009101 7A 92 7D 92 81         171     .byte 0x0d,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009106 92 85 92 89 92         172     .byte 0x0e,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      00910B 8D 92 91 92 96         173     .byte 0x0f,IDX.CLR,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009110 92 9A 92 9D 92         174     .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.X,IDX.X 
      009115 A1 92 A6 92 AB         175     .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00911A 92 B1 92 B5 92         176     .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00911F B9 92 BE 92 C2         177     .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009124 92 C6 92 CB 92         178     .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009129 D0 92 D4 92 D9         179     .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00912E 92 DE 92 E2 92         180     .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009133 E6 92 EA 92 EE         181     .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009138 92 F2 92 F6 92         182     .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00913D FB 93 00 93 04         183     .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009142 93 09 93 0D 93         184     .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009147 12 93 16 93 1B         185     .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00914C 93 20 93 26 93         186     .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
                                    187     ; form op r,(ofs8,r) 0x1n 0x7B 0xEn
      009151 2A 93 2F 93 34         188     .byte 0x10,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009156 93 38 93 3C 93         189     .byte 0x11,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00915B 40 41 44 43 00         190     .byte 0x12,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009160 41 44 44 00 41         191     .byte 0x13,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      009165 44 44 57 00 41         192     .byte 0x14,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00916A 4E 44 00 42 43         193     .byte 0x15,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00916F 43 4D 00 42 43         194     .byte 0x16,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009174 50 00 42 43 50         195     .byte 0x18,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009179 4C 00 42 52 45         196     .byte 0x19,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00917E 41 4B 00 42 52         197     .byte 0x1A,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009183 45 53 00 42 53         198     .byte 0x1B,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009188 45 54 00 42 54         199     .byte 0x1E,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      00918D 4A 46 00 42 54         200     .byte 0x7B,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009192 4A 54 00 43 41         201     .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



      009197 4C 4C 00 43 41         202     .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      00919C 4C 4C 46 00 43         203     .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091A1 41 4C 4C 52 00         204     .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.X
      0091A6 43 43 46 00 43         205     .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091AB 4C 52 00 43 4C         206     .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091B0 52 57 00 43 50         207     .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091B5 00 43 50 4C 00         208     .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091BA 43 50 4C 57 00         209     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091BF 43 50 57 00 44         210     .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091C4 45 43 00 44 45         211     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091C9 43 57 00 44 49         212     .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.X
                                    213     ;form op r,(ofs16,r)
      0091CE 56 00 44 49 56         214     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      0091D3 57 00 45 58 47         215     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
                                    216     ;form op (ofs16,r),r 
      0091D8 00 45 58 47 57         217     .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.X,IDX.Y 
                                    218     ;form op (ofs8,r),r 
      0091DD 00 48 41 4C 54         219     .byte 0x17,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.Y
      0091E2 00 49 4E 43 00         220     .byte 0x1F,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.X
      0091E7 49 4E 43 57 00         221     .byte 0x6B,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.A 
      0091EC 49 4E 54 00 49         222     .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.X,IDX.A 
      0091F1 52 45 54 00 4A         223     .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.X,IDX.Y 
                                    224     ; opcode with implied arguments 0x4n 0x5n 0x8n 0x9n 
      0091F6 50 00 4A 50 46         225     .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.X,0
      0091FB 00 4A 52 41 00         226     .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.X,0
      009200 4A 52 43 00 4A         227     .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0 
      009205 52 45 51 00 4A         228     .byte 0x41,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.XL
      00920A 52 46 00 4A 52         229     .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.X,IDX.A 
      00920F 48 00 4A 52 49         230     .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
      009214 48 00 4A 52 49         231     .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0 
      009219 4C 00 4A 52 4D         232     .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0 
      00921E 00 4A 52 4D 49         233     .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0 
      009223 00 4A 52 4E 43         234     .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0 
      009228 00 4A 52 4E 45         235     .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0 
      00922D 00 4A 52 4E 48         236     .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0 
      009232 00 4A 52 4E 4D         237     .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0 
      009237 00 4A 52 4E 56         238     .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0 
      00923C 00 4A 52 50 4C         239     .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0 
      009241 00 4A 52 53 47         240     .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
      009246 45 00 4A 52 53         241     .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.X,0 
      00924B 47 54 00 4A 52         242     .byte 0x51,IDX.EXGW,IDX.FN_IMPL,IDX.X,IDX.Y
      009250 53 4C 45 00 4A         243     .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.X,0
      009255 52 53 4C 54 00         244     .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.X,0
      00925A 4A 52 54 00 4A         245     .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.X,0
      00925F 52 55 47 45 00         246     .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.X,0
      009264 4A 52 55 47 54         247     .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.X,0
      009269 00 4A 52 55 4C         248     .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.X,0
      00926E 45 00 4A 52 55         249     .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.X,0
      009273 4C 54 00 4A 52         250     .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.X,0
      009278 56 00 4C 44 00         251     .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
      00927D 4C 44 46 00 4C         252     .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.X,0
      009282 44 57 00 4D 4F         253     .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.X,0 
      009287 56 00 4D 55 4C         254     .byte 0x61,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.YL
      00928C 00 4E 45 47 00         255     .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.X,IDX.A
      009291 4E 45 47 57 00         256     .byte 0x65,IDX.DIVW,IDX.FN_IMPL,IDX.X,IDX.Y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      009296 4E 4F 50 00 4F         257     .byte 0x80,IDX.IRET,IDX.FN_IMPL,0,0
      00929B 52 00 50 4F 50         258     .byte 0x81,IDX.RET,IDX.FN_IMPL,0,0
      0092A0 00 50 4F 50 57         259     .byte 0x83,IDX.TRAP,IDX.FN_IMPL,0,0
      0092A5 00 50 55 53 48         260     .byte 0x84,IDX.POP,IDX.FN_IMPL,IDX.A,0
      0092AA 00 50 55 53 48         261     .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.X,0
      0092AF 57 00 52 43 46         262     .byte 0x86,IDX.POP,IDX.FN_IMPL,IDX.CC,0
      0092B4 00 52 45 54 00         263     .byte 0x87,IDX.RETF,IDX.FN_IMPL,0,0
      0092B9 52 45 54 46 00         264     .byte 0x88,IDX.PUSH,IDX.FN_IMPL,IDX.A,0
      0092BE 52 49 4D 00 52         265     .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.X,0
      0092C3 4C 43 00 52 4C         266     .byte 0x8A,IDX.PUSH,IDX.FN_IMPL,IDX.CC,0
      0092C8 43 57 00 52 4C         267     .byte 0x8B,IDX.BREAK,IDX.FN_IMPL,0,0
      0092CD 57 41 00 52 52         268     .byte 0x8C,IDX.CCF,IDX.FN_IMPL,0,0
      0092D2 43 00 52 52 43         269     .byte 0x8E,IDX.HALT,IDX.FN_IMPL,0,0
      0092D7 57 00 52 52 57         270     .byte 0x8F,IDX.WFI,IDX.FN_IMPL,0,0
      0092DC 41 00 52 56 46         271     .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.Y 
      0092E1 00 53 42 43 00         272     .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.X 
      0092E6 53 43 46 00 53         273     .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.XH,IDX.A 
      0092EB 49 4D 00 53 4C         274     .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.SP 
      0092F0 41 00 53 4C 4C         275     .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.XL,IDX.A 
      0092F5 00 53 4C 41 57         276     .byte 0x98,IDX.RCF,IDX.FN_IMPL,0,0
      0092FA 00 53 4C 4C 57         277     .byte 0x99,IDX.SCF,IDX.FN_IMPL,0,0
      0092FF 00 53 52 41 00         278     .byte 0x9A,IDX.RIM,IDX.FN_IMPL,0,0
      009304 53 52 41 57 00         279     .byte 0x9B,IDX.SIM,IDX.FN_IMPL,0,0
      009309 53 52 4C 00 53         280     .byte 0x9C,IDX.RVF,IDX.FN_IMPL,0,0
      00930E 52 4C 57 00 53         281     .byte 0x9D,IDX.NOP,IDX.FN_IMPL,0,0
      009313 55 42 00 53 55         282     .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XH
      009318 42 57 00 53 57         283     .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XL
                                    284     ; form  op r,(r) | op (r)
      00931D 41 50 00 53 57         285     .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.X,0 
      009322 41 50 57 00 54         286     .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.X,0 
      009327 4E 5A 00 54 4E         287     .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.X,0 
      00932C 5A 57 00 54 52         288     .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.X,0 
      009331 41 50 00 57 46         289     .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.X,0 
      009336 45 00 57 46 49         290     .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.X,0 
      00933B 00 58 4F 52 00         291     .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.X,0 
      009340 3F 00 06 07 00         292     .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.X,0 
      009342 7C 1E 06 07 00         293     .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.X,0 
      009342 00 00 93 5E 93         294     .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.X,0 
      009347 60 93 63 93 66         295     .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.X,0 
      00934C 93 69 93 6C 93         296     .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.X,0 
      009351 6F 93 71 93 73         297     .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.X 
      009356 93 76 93 79 93         298     .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.X 
      00935B 7D 93 81 01 07         299     .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.X 
      00935E F3 16 06 08 07         300     .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.Y,IDX.X 
      00935E 41 00 43 43 00         301     .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.X 
      009363 58 48 00 59 48         302     .byte 0xF5,IDX.BCP,IDX.FN_R_IDX,IDX.A,IDX.X 
      009368 00 58 4C 00 59         303     .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.X 
      00936D 4C 00 58 00 59         304     .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.X 
      009372 00 53 50 00 50         305     .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.X 
      009377 43 00 50 43 4C         306     .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.X 
      00937C 00 50 43 4D 00         307     .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.X 
      009381 50 43 45 00 44         308     .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.X,0 
      009386 41 53 4D 07 00         309     .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.X,0 
      009389 FE 3F 06 07 07         310     .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.X,IDX.X 
                                    311     ; form op (r),r 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      009389 A0 03 A3 11 A3         312     .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.X,IDX.A 
      00938E 99 A3 E5 A4 61         313     .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.X,IDX.Y 
                                    314 
                                    315     ; form op r,#imm8 0xAn 
      009393 A4 8F A2 96 A2         316     .byte 0x52,IDX.SUB,IDX.FN_R_IMM8,IDX.SP,0
      009398 D9 A1 FD A2 2A         317     .byte 0x5B,IDX.ADDW,IDX.FN_R_IMM8,IDX.SP,0
      00939D A0 4C A1 33 A1         318     .byte 0xa0,IDX.SUB,IDX.FN_R_IMM8,IDX.A,0
      0093A2 51 A1 74 A1 A1         319     .byte 0xa1,IDX.CP,IDX.FN_R_IMM8,IDX.A,0
      0093A7 A1 CE A2 57 A4         320     .byte 0xa2,IDX.SBC,IDX.FN_R_IMM8,IDX.A,0
      0093AC BD A4 E3 A5 09         321     .byte 0xa4,IDX.AND,IDX.FN_R_IMM8,IDX.A,0
      0093B1 A0 F8 A5 31 A5         322     .byte 0xa5,IDX.BCP,IDX.FN_R_IMM8,IDX.A,0
      0093B6 60 A5 8F A5 BE         323     .byte 0xa6,IDX.LD,IDX.FN_R_IMM8,IDX.A,0
      0093BB A5 F2 A6 34 A6         324     .byte 0xa8,IDX.XOR,IDX.FN_R_IMM8,IDX.A,0
      0093C0 76 A6 B8 A4 25         325     .byte 0xa9,IDX.ADC,IDX.FN_R_IMM8,IDX.A,0
      0093C5 A6 F5 A7 27 A7         326     .byte 0xaA,IDX.OR,IDX.FN_R_IMM8,IDX.A,0
      0093CA 67 A7 A7 A7 E9         327     .byte 0xaB,IDX.ADD,IDX.FN_R_IMM8,IDX.A,0
                                    328     ; form op r,#imm16 
      0093CF A8 47 A8 26 A8         329     .byte 0x1C,IDX.ADDW,IDX.FN_R_IMM16,IDX.X,0
      0093D4 9D A8 6C 07 00         330     .byte 0x1D,IDX.SUBW,IDX.FN_R_IMM16,IDX.X,0
      0093D7 A3 16 05 07 00         331     .byte 0xa3,IDX.CPW,IDX.FN_R_IMM16,IDX.X,0
      0093D7 00 42 01 09 09         332     .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.X,0 
      0093DC 03 14 01 09 09         333     .byte 0xCB,IDX.ADD,IDX.FN_R_IMM16,IDX.A,0 
                                    334 
                                    335     ; form op adr8 
      0093E1 04 5E 01 09 09         336     .byte 0x30,IDX.NEG,IDX.FN_ADR8,0,0
      0093E6 06 51 01 09 09         337     .byte 0x33,IDX.CPL,IDX.FN_ADR8,0,0
      0093EB 07 5C 01 09 09         338     .byte 0x34,IDX.SRL,IDX.FN_ADR8,0,0
      0093F0 08 59 01 09 09         339     .byte 0x36,IDX.RRC,IDX.FN_ADR8,0,0
      0093F5 09 4E 01 09 09         340     .byte 0x37,IDX.SRA,IDX.FN_ADR8,0,0
      0093FA 0A 17 01 09 09         341     .byte 0x38,IDX.SLL,IDX.FN_ADR8,0,0
      0093FF 0C 1E 01 09 09         342     .byte 0x39,IDX.RLC,IDX.FN_ADR8,0,0
      009404 0D 64 01 09 09         343     .byte 0x3A,IDX.DEC,IDX.FN_ADR8,0,0
      009409 0E 62 01 09 09         344     .byte 0x3C,IDX.INC,IDX.FN_ADR8,0,0
      00940E 0F 11 01 09 09         345     .byte 0x3D,IDX.TNZ,IDX.FN_ADR8,0,0
      009413 60 42 01 07 07         346     .byte 0x3E,IDX.SWAP,IDX.FN_ADR8,0,0
      009418 63 14 01 07 07         347     .byte 0x3F,IDX.CLR,IDX.FN_ADR8,0,0
      00941D 64 5E 01 07 07         348     .byte 0xAD,IDX.CALLR,IDX.FN_ADR8,0,0
                                    349     ; form op adr16 
      009422 66 51 01 07 07         350     .byte 0x32,IDX.POP,IDX.FN_ADR16,0,0
      009427 67 5C 01 07 07         351     .byte 0x3B,IDX.PUSH,IDX.FN_ADR16,0,0 
      00942C 68 59 01 07 07         352     .byte 0xcc,IDX.JP,IDX.FN_ADR16,0,0
      009431 69 4E 01 07 07         353     .byte 0xcd,IDX.CALL,IDX.FN_ADR16,0,0
                                    354     ;form op r,adr16 
      009436 6A 17 01 07 07         355     .byte 0x31,IDX.EXG,IDX.FN_R_ADR16,IDX.A,0
                                    356     ;form op adr24 
      00943B 6C 1E 01 07 07         357     .byte 0x82,IDX.INT,IDX.FN_ADR24,0,0
      009440 6D 64 01 07 07         358     .byte 0x8D,IDX.CALLF,IDX.FN_ADR24,0,0
      009445 6E 62 01 07 07         359     .byte 0xac,IDX.JPF,IDX.FN_ADR24,0,0
                                    360 
                                    361     ;form op r,adr8
      00944A 6F 11 01 07 07         362     .byte 0xB0,IDX.SUB,IDX.FN_R_ADR8,IDX.A,0
      00944F ED 0D 01 07 07         363     .byte 0xB1,IDX.CP,IDX.FN_R_ADR8,IDX.A,0
      009454 10 60 03 01 09         364     .byte 0xB2,IDX.SBC,IDX.FN_R_ADR8,IDX.A,0
      009459 11 13 03 01 09         365     .byte 0xB3,IDX.CPW,IDX.FN_R_ADR8,IDX.X,0
      00945E 12 55 03 01 09         366     .byte 0xB4,IDX.AND,IDX.FN_R_ADR8,IDX.A,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      009463 13 16 03 07 09         367     .byte 0xB5,IDX.BCP,IDX.FN_R_ADR8,IDX.A,0
      009468 14 04 03 01 09         368     .byte 0xB6,IDX.LD,IDX.FN_R_ADR8,IDX.A,0
      00946D 15 06 03 01 09         369     .byte 0xB8,IDX.XOR,IDX.FN_R_ADR8,IDX.A,0
      009472 16 3F 03 08 09         370     .byte 0xB9,IDX.ADC,IDX.FN_R_ADR8,IDX.A,0
      009477 18 69 03 01 09         371     .byte 0xBA,IDX.OR,IDX.FN_R_ADR8,IDX.A,0
      00947C 19 01 03 01 09         372     .byte 0xBB,IDX.ADD,IDX.FN_R_ADR8,IDX.A,0
      009481 1A 45 03 01 09         373     .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.X,0
                                    374     
                                    375     ;form op r,adr16
      009486 1B 02 03 01 09         376     .byte 0xC0,IDX.SUB,IDX.FN_R_ADR16,IDX.A,0
      00948B 1E 3F 03 07 09         377     .byte 0xC1,IDX.CP,IDX.FN_R_ADR16,IDX.A,0
      009490 7B 3D 03 01 09         378     .byte 0xC2,IDX.SBC,IDX.FN_R_ADR16,IDX.A,0
      009495 E0 60 03 01 07         379     .byte 0xC3,IDX.CPW,IDX.FN_R_ADR16,IDX.X,0
      00949A E1 13 03 01 07         380     .byte 0xC4,IDX.AND,IDX.FN_R_ADR16,IDX.A,0
      00949F E2 55 03 01 07         381     .byte 0xC5,IDX.BCP,IDX.FN_R_ADR16,IDX.A,0
      0094A4 E3 16 03 08 07         382     .byte 0xC6,IDX.LD,IDX.FN_R_ADR16,IDX.A,0
      0094A9 E4 04 03 01 07         383     .byte 0xC8,IDX.XOR,IDX.FN_R_ADR16,IDX.A,0
      0094AE E5 06 03 01 07         384     .byte 0xc9,IDX.ADC,IDX.FN_R_ADR16,IDX.A,0
      0094B3 E6 3D 03 01 07         385     .byte 0xCA,IDX.OR,IDX.FN_R_ADR16,IDX.A,0
      0094B8 E8 69 03 01 07         386     .byte 0xCB,IDX.ADD,IDX.FN_R_ADR16,IDX.A,0
      0094BD E9 01 03 01 07         387     .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.X,0
                                    388 
                                    389     ;form op r,adr24 
      0094C2 EA 45 03 01 07         390     .byte 0xBC,IDX.LDF,IDX.FN_R_ADR24,IDX.A,0 
                                    391 
                                    392     ; form op #imm8 
      0094C7 EB 02 03 01 07         393     .byte 0x4B,IDX.PUSH,IDX.FN_IMM8,0,0
                                    394 
                                    395     ;form op adr8,r 
      0094CC EE 3F 03 07 07         396     .byte 0xB7,IDX.LD,IDX.FN_ADR8_R,0,IDX.A
      0094D1 D6 3D 1F 01 07         397     .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.X
                                    398 
                                    399     ;form op adr16,r 
      0094D6 DB 02 1F 01 07         400     .byte 0xC7,IDX.LD,IDX.FN_ADR16_R,0,IDX.A 
      0094DB DF 3F 20 07 08         401     .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.X 
                                    402     ;form op adr24,r 
      0094E0 17 3F 1D 09 08         403     .byte 0xBD,IDX.LDF,IDX.FN_ADR24_R,0,IDX.A 
                                    404 
                                    405     ;form op adr16,#imm8
      0094E5 1F 3F 1D 09 07         406     .byte 0x35,IDX.MOV,IDX.FN_ADR16_IMM8,0,0 
                                    407     ;form op adr8,adr8 
      0094EA 6B 3D 1D 09 01         408     .byte 0x45,IDX.MOV,IDX.FN_ADR8_ADR8,0,0 
                                    409     ;form op adr16,adr16 
      0094EF E7 3D 1D 07 01         410     .byte 0x55,IDX.MOV,IDX.FN_ADR16_ADR16,0,0 
                                    411 
                                    412     ;form op r,(off16,r)
      0094F4 EF 3F 1D 07 08         413     .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      0094F9 01 53 00 07 00         414     .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      0094FE 02 50 00 07 00         415     .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009503 40 42 00 01 00         416     .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.X 
      009508 41 1B 00 01 05         417     .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00950D 42 41 00 07 01         418     .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009512 43 14 00 01 00         419     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009517 44 5E 00 01 00         420     .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00951C 46 51 00 01 00         421     .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



      009521 47 5C 00 01 00         422     .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009526 48 59 00 01 00         423     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00952B 49 4E 00 01 00         424     .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.X 
                                    425     ;form op (off16,r),r 
      009530 4A 17 00 01 00         426     .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.X,IDX.A 
                                    427 
                                    428     ; form op r,(ofs24,r) 
      009535 4C 1E 00 01 00         429     .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.X 
                                    430     ; form op (ofs24,r),r 
      00953A 4D 64 00 01 00         431     .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.X,IDX.A 
                                    432     ;form op (ofs16,r)
      00953F 4E 62 00 01 00         433     .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,0,IDX.X 
      009544 4F 11 00 01 00         434     .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,0,IDX.X 
                                    435     ;form op (ofs8,r)
      009549 50 43 00 07 00         436     .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.X,0 
      00954E 51 1C 00 07 08         437     .byte 0XED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,0  
                                    438 
      009553 53 15 00 07 00         439     .byte 0,0,0,0,0
                                    440 
                                    441 ; table for opcodes with 0x72 prefix 
      0007F2                        442 p72_codes:
                                    443     ;form op r,[ptr16]
      009558 54 5F 00 07 00         444     .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0 
      00955D 56 52 00 07 00         445     .byte 0xC9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0 
      009562 57 5D 00 07 00         446     .byte 0xCb,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0 
                                    447     ;form op r,([ptr16],r)
      009567 58 5B 00 07 00         448     .byte 0xd6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      00956C 59 4F 00 07 00         449     .byte 0xd9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      009571 5A 18 00 07 00         450     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
                                    451 
                                    452     ;from implied
      009576 5C 1F 00 07 00         453     .byte 0x8F,IDX.WFE,IDX.FN_IMPL,0,0
                                    454 
                                    455     ;form op r,[ptr16]
      00957B 5D 65 00 07 00         456     .byte 0xC0,IDX.SUB,IDX.FN_R_PTR16,IDX.A,0
      009580 5E 63 00 07 00         457     .byte 0xC1,IDX.CP,IDX.FN_R_PTR16,IDX.A,0
      009585 5F 12 00 07 00         458     .byte 0xC2,IDX.SBC,IDX.FN_R_PTR16,IDX.A,0
      00958A 61 1B 00 01 06         459     .byte 0xC3,IDX.CPW,IDX.FN_R_PTR16,IDX.X,0
      00958F 62 19 00 07 01         460     .byte 0xC4,IDX.AND,IDX.FN_R_PTR16,IDX.A,0
      009594 65 1A 00 07 08         461     .byte 0xC5,IDX.BCP,IDX.FN_R_PTR16,IDX.A,0
      009599 80 21 00 00 00         462     .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0
      00959E 81 4B 00 00 00         463     .byte 0xC8,IDX.XOR,IDX.FN_R_PTR16,IDX.A,0
      0095A3 83 66 00 00 00         464     .byte 0xc9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0
      0095A8 84 46 00 01 00         465     .byte 0xCA,IDX.OR,IDX.FN_R_PTR16,IDX.A,0
      0095AD 85 47 00 07 00         466     .byte 0xCB,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0
      0095B2 86 46 00 02 00         467     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0
                                    468 
      0095B7 87 4C 00 00 00         469     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0
                                    470 
                                    471     ; form op r,([ptr16],r)
      0095BC 88 48 00 01 00         472     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095C1 89 49 00 07 00         473     .byte 0xD1,IDX.CP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095C6 8A 48 00 02 00         474     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095CB 8B 08 00 00 00         475     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR16_IDX,IDX.Y,IDX.X 
      0095D0 8C 10 00 00 00         476     .byte 0xD4,IDX.AND,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



      0095D5 8E 1D 00 00 00         477     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095DA 8F 68 00 00 00         478     .byte 0xD6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095DF 93 3F 00 07 08         479     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095E4 94 3F 00 09 07         480     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095E9 95 3D 00 03 01         481     .byte 0xDA,IDX.OR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095EE 96 3F 00 07 09         482     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095F3 97 3D 00 05 01         483     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR16_IDX,IDX.X,IDX.X 
                                    484 
                                    485     ; form op r,(ofs8,r)
      0095F8 98 4A 00 00 00         486     .byte 0xF0,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      0095FD 99 56 00 00 00         487     .byte 0xF2,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009602 9A 4D 00 00 00         488     .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009607 9B 57 00 00 00         489     .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
                                    490     ; form op [ptr16],r 
      00960C 9C 54 00 00 00         491     .byte 0xC7,IDX.LD,IDX.FN_PTR16_R,0,IDX.A 
      009611 9D 44 00 00 00         492     .byte 0xCF,IDX.LDW,IDX.FN_PTR16_R,0,IDX.X 
                                    493 
                                    494     ; form op ([ptr16],r),r 
      009616 9E 3D 00 01 03         495     .byte 0xD7,IDX.LD,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
      00961B 9F 3D 00 01 05         496     .byte 0xDF,IDX.LDW,IDX.FN_PTR16_IDX_R,IDX.X,IDX.Y 
                                    497     ;form op [ptr16] 0x3n 
      009620 70 42 06 07 00         498     .byte 0x30,IDX.NEG,IDX.FN_PTR16,0,0
      009625 73 14 06 07 00         499     .byte 0x33,IDX.CPL,IDX.FN_PTR16,0,0
      00962A 74 5E 06 07 00         500     .byte 0x34,IDX.SRL,IDX.FN_PTR16,0,0
      00962F 76 51 06 07 00         501     .byte 0x36,IDX.RRC,IDX.FN_PTR16,0,0
      009634 77 5C 06 07 00         502     .byte 0x37,IDX.SRA,IDX.FN_PTR16,0,0
      009639 78 59 06 07 00         503     .byte 0x38,IDX.SLL,IDX.FN_PTR16,0,0
      00963E 79 4E 06 07 00         504     .byte 0x39,IDX.RLC,IDX.FN_PTR16,0,0
      009643 7A 17 06 07 00         505     .byte 0x3A,IDX.DEC,IDX.FN_PTR16,0,0
      009648 7C 1E 06 07 00         506     .byte 0x3C,IDX.INC,IDX.FN_PTR16,0,0
      00964D 7D 64 06 07 00         507     .byte 0x3D,IDX.TNZ,IDX.FN_PTR16,0,0
      009652 7E 62 06 07 00         508     .byte 0x3E,IDX.SWAP,IDX.FN_PTR16,0,0
      009657 7F 11 06 07 00         509     .byte 0x3F,IDX.CLR,IDX.FN_PTR16,0,0
                                    510     ; form op (ofs16,r) 0x4n
      00965C F0 60 06 01 07         511     .byte 0x40,IDX.NEG,IDX.FN_OFS16_IDX,IDX.X,0
      009661 F1 13 06 01 07         512     .byte 0x43,IDX.CPL,IDX.FN_OFS16_IDX,IDX.X,0
      009666 F2 55 06 01 07         513     .byte 0x44,IDX.SRL,IDX.FN_OFS16_IDX,IDX.X,0
      00966B F3 16 06 08 07         514     .byte 0x46,IDX.RRC,IDX.FN_OFS16_IDX,IDX.X,0
      009670 F4 04 06 01 07         515     .byte 0x47,IDX.SRA,IDX.FN_OFS16_IDX,IDX.X,0
      009675 F5 06 06 01 07         516     .byte 0x48,IDX.SLL,IDX.FN_OFS16_IDX,IDX.X,0
      00967A F6 3D 06 01 07         517     .byte 0x49,IDX.RLC,IDX.FN_OFS16_IDX,IDX.X,0
      00967F F8 69 06 01 07         518     .byte 0x4A,IDX.DEC,IDX.FN_OFS16_IDX,IDX.X,0
      009684 F9 01 06 01 07         519     .byte 0x4C,IDX.INC,IDX.FN_OFS16_IDX,IDX.X,0
      009689 FA 45 06 01 07         520     .byte 0x4D,IDX.TNZ,IDX.FN_OFS16_IDX,IDX.X,0
      00968E FB 02 06 01 07         521     .byte 0x4E,IDX.SWAP,IDX.FN_OFS16_IDX,IDX.X,0
      009693 FC 22 06 07 00         522     .byte 0x4F,IDX.CLR,IDX.FN_OFS16_IDX,IDX.X,0
                                    523 
                                    524     ; form op adr16 0x5n
      009698 FD 0D 06 07 00         525     .byte 0x50,IDX.NEG,IDX.FN_ADR16,0,0
      00969D FE 3F 06 07 07         526     .byte 0x53,IDX.CPL,IDX.FN_ADR16,0,0
      0096A2 F7 3D 07 07 01         527     .byte 0x54,IDX.SRL,IDX.FN_ADR16,0,0
      0096A7 FF 3F 07 07 08         528     .byte 0x56,IDX.RRC,IDX.FN_ADR16,0,0
      0096AC 52 60 04 09 00         529     .byte 0x57,IDX.SRA,IDX.FN_ADR16,0,0
      0096B1 5B 03 04 09 00         530     .byte 0x58,IDX.SLL,IDX.FN_ADR16,0,0
      0096B6 A0 60 04 01 00         531     .byte 0x59,IDX.RLC,IDX.FN_ADR16,0,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



      0096BB A1 13 04 01 00         532     .byte 0x5A,IDX.DEC,IDX.FN_ADR16,0,0
      0096C0 A2 55 04 01 00         533     .byte 0x5C,IDX.INC,IDX.FN_ADR16,0,0
      0096C5 A4 04 04 01 00         534     .byte 0x5D,IDX.TNZ,IDX.FN_ADR16,0,0
      0096CA A5 06 04 01 00         535     .byte 0x5E,IDX.SWAP,IDX.FN_ADR16,0,0
      0096CF A6 3D 04 01 00         536     .byte 0x5F,IDX.CLR,IDX.FN_ADR16,0,0
                                    537 
                                    538     ; form op ([ptr16],x)  0x6n 
      0096D4 A8 69 04 01 00         539     .byte 0x60,IDX.NEG,IDX.FN_PTR16_IDX,IDX.X,0
      0096D9 A9 01 04 01 00         540     .byte 0x63,IDX.CPL,IDX.FN_PTR16_IDX,IDX.X,0
      0096DE AA 45 04 01 00         541     .byte 0x64,IDX.SRL,IDX.FN_PTR16_IDX,IDX.X,0
      0096E3 AB 02 04 01 00         542     .byte 0x66,IDX.RRC,IDX.FN_PTR16_IDX,IDX.X,0
      0096E8 1C 03 05 07 00         543     .byte 0x67,IDX.SRA,IDX.FN_PTR16_IDX,IDX.X,0
      0096ED 1D 61 05 07 00         544     .byte 0x68,IDX.SLL,IDX.FN_PTR16_IDX,IDX.X,0
      0096F2 A3 16 05 07 00         545     .byte 0x69,IDX.RLC,IDX.FN_PTR16_IDX,IDX.X,0
      0096F7 AE 3F 05 07 00         546     .byte 0x6A,IDX.DEC,IDX.FN_PTR16_IDX,IDX.X,0
      0096FC CB 02 05 01 00         547     .byte 0x6C,IDX.INC,IDX.FN_PTR16_IDX,IDX.X,0
      009701 30 42 14 00 00         548     .byte 0x6D,IDX.TNZ,IDX.FN_PTR16_IDX,IDX.X,0
      009706 33 14 14 00 00         549     .byte 0x6E,IDX.SWAP,IDX.FN_PTR16_IDX,IDX.X,0
      00970B 34 5E 14 00 00         550     .byte 0x6F,IDX.CLR,IDX.FN_PTR16_IDX,IDX.X,0
                                    551     ; form op r,#imm16 
      009710 36 51 14 00 00         552     .byte 0xA2,IDX.SUBW,IDX.FN_R_IMM16,IDX.Y,0
      009715 37 5C 14 00 00         553     .byte 0xA9,IDX.ADDW,IDX.FN_R_IMM16,IDX.Y,0 
                                    554     ; form op r,adr16 
      00971A 38 59 14 00 00         555     .byte 0xB0,IDX.SUBW,IDX.FN_R_ADR16,IDX.X,0
      00971F 39 4E 14 00 00         556     .byte 0xB2,IDX.SUBW,IDX.FN_R_ADR16,IDX.Y,0
      009724 3A 17 14 00 00         557     .byte 0xB9,IDX.ADDW,IDX.FN_R_ADR16,IDX.Y,0
      009729 3C 1E 14 00 00         558     .byte 0xBB,IDX.ADDW,IDX.FN_R_ADR16,IDX.X,0
                                    559     ; form op r,(ofs8,r)
      00972E 3D 64 14 00 00         560     .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP 
      009733 3E 62 14 00 00         561     .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP 
                                    562     ; form op [ptr16]
      009738 3F 11 14 00 00         563     .byte 0xCC,IDX.JP,IDX.FN_PTR16,0,0 
                                    564 
      00973D AD 0F 14 00 00         565     .byte 0,0,0,0,0
                                    566 
                                    567 ; table for opcodes with 0x90 prefix 
      0009DC                        568 p90_codes:
                                    569     ; form op (ofs8,r)
      009742 32 46 0B 00 00         570     .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.Y,0 
      009747 3B 48 0B 00 00         571     .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.Y,0
      00974C CC 22 0B 00 00         572     .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.Y,0
      009751 CD 0D 0B 00 00         573     .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.Y,0
      009756 31 1B 09 01 00         574     .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.Y,0
      00975B 82 20 0C 00 00         575     .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.Y,0
      009760 8D 0E 0C 00 00         576     .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.Y,0
      009765 AC 23 0C 00 00         577     .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.Y,0
      00976A B0 60 08 01 00         578     .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.Y,0
      00976F B1 13 08 01 00         579     .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.Y,0
      009774 B2 55 08 01 00         580     .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.Y,0
      009779 B3 16 08 07 00         581     .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.Y,0
      00977E B4 04 08 01 00         582     .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.Y,0
      009783 B5 06 08 01 00         583     .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.Y,0
                                    584    ; form op r,(osf8,r)
      009788 B6 3D 08 01 00         585     .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      00978D B8 69 08 01 00         586     .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



      009792 B9 01 08 01 00         587     .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      009797 BA 45 08 01 00         588     .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.Y
      00979C BB 02 08 01 00         589     .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097A1 BE 3F 08 07 00         590     .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097A6 C0 60 09 01 00         591     .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097AB C1 13 09 01 00         592     .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097B0 C2 55 09 01 00         593     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097B5 C3 16 09 07 00         594     .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097BA C4 04 09 01 00         595     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097BF C5 06 09 01 00         596     .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.Y
                                    597     ;form op r,(ofs16,r)
      0097C4 C6 3D 09 01 00         598     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
      0097C9 C8 69 09 01 00         599     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
                                    600     
                                    601     ; opcode with implied arguments 
      0097CE C9 01 09 01 00         602     .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.Y,0
      0097D3 CA 45 09 01 00         603     .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.Y,0
      0097D8 CB 02 09 01 00         604     .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0
      0097DD CE 3F 09 07 00         605     .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.Y,IDX.A 
      0097E2 BC 3E 10 01 00         606     .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
      0097E7 4B 48 0A 00 00         607     .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0
      0097EC B7 3D 0D 00 01         608     .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0
      0097F1 BF 3F 0D 00 07         609     .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0
      0097F6 C7 3D 0E 00 01         610     .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0
      0097FB CF 3F 0E 00 07         611     .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0
      009800 BD 3E 0F 00 01         612     .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0
      009805 35 40 11 00 00         613     .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0
      00980A 45 40 13 00 00         614     .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0
      00980F 55 40 12 00 00         615     .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0
      009814 D0 60 1F 01 07         616     .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
      009819 D1 13 1F 01 07         617     .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.Y,0 
      00981E D2 55 1F 01 07         618     .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.Y,0
      009823 D3 16 1F 08 07         619     .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.Y,0
      009828 D4 04 1F 01 07         620     .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.Y,0
      00982D D5 06 1F 01 07         621     .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.Y,0
      009832 D6 3D 1F 01 07         622     .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.Y,0
      009837 D8 69 1F 01 07         623     .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.Y,0
      00983C D9 01 1F 01 07         624     .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.Y,0
      009841 DA 45 1F 01 07         625     .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.Y,0
      009846 DB 02 1F 01 07         626     .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
      00984B DE 3F 1F 07 07         627     .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.Y,0
      009850 D7 3D 20 07 01         628     .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.Y,0  
      009855 AF 3E 21 01 07         629     .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.Y,IDX.A 
      00985A A7 3E 22 07 01         630     .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.Y,0
      00985F DC 22 1E 00 07         631     .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.Y,0
      009864 DD 0D 1E 00 07         632     .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.X 
      009869 EC 22 01 07 00         633     .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.Y 
      00986E ED 0D 01 07 00         634     .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.YH,IDX.A 
      009873 00 00 00 00 00         635     .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.SP 
      009878 97 3D 00 06 01         636     .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.YL,IDX.A 
      009878 C6 3D 16 01 00         637     .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YH
      00987D C9 01 16 01 00         638     .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YL
      009882 CB 02 16 01 00         639     .byte 0xFB,IDX.ADD,IDX.FN_IMPL,IDX.A,IDX.Y
                                    640     ; form  op r,(r) | op (r)
      009887 D6 3D 1A 01 07         641     .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.Y,0 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



      00988C D9 01 1A 01 07         642     .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.Y,0 
      009891 DB 02 1A 01 07         643     .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.Y,0 
      009896 8F 67 00 00 00         644     .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.Y,0 
      00989B C0 60 16 01 00         645     .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.Y,0 
      0098A0 C1 13 16 01 00         646     .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.Y,0 
      0098A5 C2 55 16 01 00         647     .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.Y,0 
      0098AA C3 16 16 07 00         648     .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.Y,0 
      0098AF C4 04 16 01 00         649     .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.Y,0 
      0098B4 C5 06 16 01 00         650     .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.Y,0 
      0098B9 C6 3D 16 01 00         651     .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.Y,0 
      0098BE C8 69 16 01 00         652     .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.Y,0 
      0098C3 C9 01 16 01 00         653     .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098C8 CA 45 16 01 00         654     .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098CD CB 02 16 01 00         655     .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098D2 CE 3F 16 07 00         656     .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.X,IDX.Y 
      0098D7 CE 3F 16 07 00         657     .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098DC D0 60 1A 01 07         658     .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098E1 D1 13 1A 01 07         659     .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098E6 D2 55 1A 01 07         660     .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098EB D3 16 1A 08 07         661     .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098F0 D4 04 1A 01 07         662     .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098F5 D5 06 1A 01 07         663     .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.Y,0 
      0098FA D6 3D 1A 01 07         664     .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.Y,0 
      0098FF D8 69 1A 01 07         665     .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.Y,IDX.Y 
                                    666     
                                    667     ; form op (r),r 
      009904 D9 01 1A 01 07         668     .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.Y,IDX.A 
      009909 DA 45 1A 01 07         669     .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.Y,IDX.X   
                                    670 
                                    671     ; form op r,#imm16 
      00990E DB 02 1A 01 07         672     .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.Y,IDX.Y 
                                    673     ; from op r,(ofs8,r)
      009913 DE 3F 1A 07 07         674     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      009918 F0 61 03 07 09         675     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
                                    676     
                                    677     ; form op adr8,r 
      00991D F2 61 03 08 09         678     .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.Y 
                                    679     ; form op r,adr8 
      009922 F9 03 03 08 09         680     .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.Y,0
                                    681     ; form op r,adr16 
      009927 FB 03 03 07 09         682     .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.Y,0
                                    683     ;form op (ofs8,r),r 
      00992C C7 3D 18 00 01         684     .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.A 
      009931 CF 3F 18 00 07         685     .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.X 
                                    686     ;form op (off16,r),r 
      009936 D7 3D 1C 07 01         687     .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.A 
      00993B DF 3F 1C 07 08         688     .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.X 
                                    689     ; form op r,(ofs16,r)
      009940 30 42 23 00 00         690     .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009945 33 14 23 00 00         691     .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00994A 34 5E 23 00 00         692     .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00994F 36 51 23 00 00         693     .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.Y 
      009954 37 5C 23 00 00         694     .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009959 38 59 23 00 00         695     .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00995E 39 4E 23 00 00         696     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



      009963 3A 17 23 00 00         697     .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009968 3C 1E 23 00 00         698     .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00996D 3D 64 23 00 00         699     .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009972 3E 62 23 00 00         700     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009977 3F 11 23 00 00         701     .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.Y 
                                    702     ;form op (ofs16,r)
      00997C 40 42 1E 07 00         703     .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,IDX.Y,0 
      009981 43 14 1E 07 00         704     .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,IDX.Y,0 
                                    705 
                                    706     ; form op r,(ofs24,r) 
      009986 44 5E 1E 07 00         707     .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.Y  
                                    708     ; form op (ofs24,r),r 
      00998B 46 51 1E 07 00         709     .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.Y,IDX.A 
                                    710     ;form op adr16,r 
      009990 47 5C 1E 07 00         711     .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.Y 
      009995 48 59 1E 07 00         712     .byte 0,0,0,0,0
                                    713 
                                    714 ; table for opcodes with 0x91 prefix 
      000C39                        715 p91_codes:
                                    716     ;form op r,([ptr8],r)
      00999A 49 4E 1E 07 00         717     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      00999F 4A 17 1E 07 00         718     .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099A4 4C 1E 1E 07 00         719     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099A9 4D 64 1E 07 00         720     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.X,IDX.Y 
      0099AE 4E 62 1E 07 00         721     .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099B3 4F 11 1E 07 00         722     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099B8 50 42 0B 00 00         723     .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y  
      0099BD 53 14 0B 00 00         724     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099C2 54 5E 0B 00 00         725     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y
      0099C7 56 51 0B 00 00         726     .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099CC 57 5C 0B 00 00         727     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099D1 58 59 0B 00 00         728     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.Y 
                                    729     ;form op ([ptr8,r]),r
      0099D6 59 4E 0B 00 00         730     .byte 0xd7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.A 
                                    731     ; form op r,([ptr16],r) 
      0099DB 5A 17 0B 00 00         732     .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.Y 
                                    733     ; form op ([ptr16],r),r 
      0099E0 5C 1E 0B 00 00         734     .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.Y,IDX.A 
                                    735     ;form op r,[ptr8]
      0099E5 5D 64 0B 00 00         736     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.Y,0 
                                    737     ;form op [ptr8],r 
      0099EA 5E 62 0B 00 00         738     .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.Y 
                                    739     ;form op ([ptr8,r]),r 
      0099EF 5F 11 0B 00 00         740     .byte 0XDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.X 
                                    741     ;form op ([ptr8],r)
      0099F4 60 42 25 07 00         742     .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.Y,0 
      0099F9 63 14 25 07 00         743     .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.Y,0
      0099FE 64 5E 25 07 00         744     .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.Y,0
      009A03 66 51 25 07 00         745     .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A08 67 5C 25 07 00         746     .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.Y,0
      009A0D 68 59 25 07 00         747     .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.Y,0
      009A12 69 4E 25 07 00         748     .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A17 6A 17 25 07 00         749     .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A1C 6C 1E 25 07 00         750     .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A21 6D 64 25 07 00         751     .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.Y,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



      009A26 6E 62 25 07 00         752     .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.Y,0
      009A2B 6F 11 25 07 00         753     .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.Y,0
      009A30 A2 61 05 08 00         754     .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.Y,0
      009A35 A9 03 05 08 00         755     .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.Y,0
                                    756 
      009A3A B0 61 09 07 00         757     .byte 0,0,0,0,0
                                    758 
                                    759 ; table of indexes for opcodes with 0x92 prefix 
      000CDE                        760 p92_codes:
                                    761     ;form op r,[ptr8]
      009A3F B2 61 09 08 00         762     .byte 0xC0,IDX.SUB,IDX.FN_R_PTR8,IDX.A,0
      009A44 B9 03 09 08 00         763     .byte 0xC1,IDX.CP,IDX.FN_R_PTR8,IDX.A,0
      009A49 BB 03 09 07 00         764     .byte 0xC2,IDX.SBC,IDX.FN_R_PTR8,IDX.A,0
      009A4E F9 03 03 08 09         765     .byte 0xC3,IDX.CPW,IDX.FN_R_PTR8,IDX.X,0
      009A53 FB 03 03 07 09         766     .byte 0xC4,IDX.AND,IDX.FN_R_PTR8,IDX.A,0
      009A58 CC 22 23 00 00         767     .byte 0xC5,IDX.BCP,IDX.FN_R_PTR8,IDX.A,0
      009A5D 00 00 00 00 00         768     .byte 0xC6,IDX.LD,IDX.FN_R_PTR8,IDX.A,0
      009A62 C8 69 15 01 00         769     .byte 0xC8,IDX.XOR,IDX.FN_R_PTR8,IDX.A,0
      009A62 60 42 01 08 00         770     .byte 0xc9,IDX.ADC,IDX.FN_R_PTR8,IDX.A,0
      009A67 63 14 01 08 00         771     .byte 0xCA,IDX.OR,IDX.FN_R_PTR8,IDX.A,0
      009A6C 64 5E 01 08 00         772     .byte 0xCB,IDX.ADD,IDX.FN_R_PTR8,IDX.A,0
      009A71 66 51 01 08 00         773     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.A,0
                                    774 
                                    775     ;form op r,([ptr8,],r)
      009A76 67 5C 01 08 00         776     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A7B 68 59 01 08 00         777     .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A80 69 4E 01 08 00         778     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A85 6A 17 01 08 00         779     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.X 
      009A8A 6C 1E 01 08 00         780     .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A8F 6D 64 01 08 00         781     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A94 6E 62 01 08 00         782     .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A99 6F 11 01 08 00         783     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A9E EC 22 01 08 00         784     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AA3 ED 0D 01 08 00         785     .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AA8 E0 60 03 01 08         786     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AAD E1 13 03 01 08         787     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
                                    788 
                                    789     ;form op [ptr8],r 
      009AB2 E2 55 03 01 08         790     .byte 0xC7,IDX.LD,IDX.FN_PTR8_R,0,IDX.A 
      009AB7 E3 16 03 07 08         791     .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.X 
                                    792     ;form op ([ptr8],r),r 
      009ABC E4 04 03 01 08         793     .byte 0xD7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.X,IDX.A 
      009AC1 E5 06 03 01 08         794     .byte 0xDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.X,IDX.Y 
                                    795     ; form op r,([ptr16],r) 
      009AC6 E6 3D 03 01 08         796     .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X  
                                    797     ; form op ([ptr16],r),r 
      009ACB E8 69 03 01 08         798     .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
                                    799     ; form op r,[ptr16]
      009AD0 E9 01 03 01 08         800     .byte 0xBC,IDX.LDF,IDX.FN_R_PTR16,IDX.A,0
                                    801     ; form op [ptr16],r 
      009AD5 EA 45 03 01 08         802     .byte 0xBD,IDX.LDF,IDX.FN_PTR16_R,0,IDX.A  
                                    803     ; form op [ptr16] 
      009ADA EB 02 03 01 08         804     .byte 0x8D,IDX.CALLF,IDX.FN_PTR16,0,0
      009ADF EE 3F 03 08 08         805     .byte 0xAC,IDX.JPF,IDX.FN_PTR16,0,0 
                                    806     ; form op [ptr8] 0x3n 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



      009AE4 D6 3D 1F 01 08         807     .byte 0x30,IDX.NEG,IDX.FN_PTR8,0,0
      009AE9 DB 02 1F 01 08         808     .byte 0x33,IDX.CPL,IDX.FN_PTR8,0,0
      009AEE 01 53 00 08 00         809     .byte 0x34,IDX.SRL,IDX.FN_PTR8,0,0
      009AF3 02 50 00 08 00         810     .byte 0x36,IDX.RRC,IDX.FN_PTR8,0,0
      009AF8 40 42 00 01 00         811     .byte 0x37,IDX.SRA,IDX.FN_PTR8,0,0
      009AFD 42 41 00 08 01         812     .byte 0x38,IDX.SLL,IDX.FN_PTR8,0,0
      009B02 43 14 00 01 00         813     .byte 0x39,IDX.RLC,IDX.FN_PTR8,0,0
      009B07 44 5E 00 01 00         814     .byte 0x3A,IDX.DEC,IDX.FN_PTR8,0,0
      009B0C 46 51 00 01 00         815     .byte 0x3C,IDX.INC,IDX.FN_PTR8,0,0
      009B11 47 5C 00 01 00         816     .byte 0x3D,IDX.TNZ,IDX.FN_PTR8,0,0
      009B16 48 59 00 01 00         817     .byte 0x3E,IDX.SWAP,IDX.FN_PTR8,0,0
      009B1B 49 4E 00 01 00         818     .byte 0x3F,IDX.CLR,IDX.FN_PTR8,0,0
                                    819     ; form op ([ptr8],r) 0x6n 0xDC 0xDD
      009B20 4A 17 00 01 00         820     .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.X,0 
      009B25 4C 1E 00 01 00         821     .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.X,0
      009B2A 4D 64 00 01 00         822     .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.X,0
      009B2F 4E 62 00 01 00         823     .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.X,0
      009B34 4F 11 00 01 00         824     .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.X,0
      009B39 50 43 00 08 00         825     .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.X,0
      009B3E 53 15 00 08 00         826     .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.X,0
      009B43 54 5F 00 08 00         827     .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.X,0
      009B48 56 52 00 08 00         828     .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.X,0
      009B4D 57 5D 00 08 00         829     .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.X,0
      009B52 58 5B 00 08 00         830     .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.X,0
      009B57 59 4F 00 08 00         831     .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.X,0
      009B5C 5A 18 00 08 00         832     .byte 0xED,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0
      009B61 5C 1F 00 08 00         833     .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.X,0
      009B66 5D 65 00 07 00         834     .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0
                                    835 
      009B6B 5E 63 00 08 00         836     .byte 0,0,0,0,0
                                    837 
                                    838 ;*****************************************************
                                    839 
                                    840 ;-----------------------------------
                                    841 ; desassembler main function
                                    842 ;-----------------------------------
                                    843 ;local constants
                           000018   844     PAGE_CNT = 24 ; instructions per page  
                                    845 ;local variables 
                           000001   846     INST_CNTR= 1 ;
                           000001   847     LOCAL_SIZE = 1
                                    848 
      000E14                        849 dasm::
      009B70 5F               [ 2]  850     pushw X
      009B71 12 00            [ 2]  851     pushw y 
      009B73 08 00            [ 2]  852     sub sp,#LOCAL_SIZE 
      009B75 62 19 00         [ 4]  853     call number 
      009B78 08 01 85         [ 1]  854     ld a,pad
      009B7B 47 00            [ 1]  855     jreq dasm_miss_arg
      009B7D 08 00 89         [ 2]  856     ldw x, #acc24
      009B80 49 00 08 00      [ 2]  857     ldw y, #farptr
      009B84 93 3F 00         [ 4]  858     call copy_var24
      000E2B                        859 page_loop:
      009B87 08 07            [ 1]  860     ld a,#PAGE_CNT 
      009B89 94 3F            [ 1]  861     ld (INST_CNTR,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



      000E2F                        862 instr_loop:
                                    863 ; print address
      009B8B 00 09            [ 1]  864     ld a,#CR 
      009B8D 08 95 3D         [ 4]  865     call uart_tx
      009B90 00 04 01         [ 2]  866     ldw x, #farptr
      009B93 96 3F 00 08      [ 2]  867     ldw y, #acc24
      009B97 09 97 3D         [ 4]  868     call copy_var24 
      009B9A 00 06            [ 1]  869     ld a,#6
      009B9C 01               [ 1]  870     ld xl,a 
      009B9D 9E 3D            [ 1]  871     ld a,#16
      009B9F 00 01 04         [ 4]  872     call print_int 
      009BA2 9F 3D            [ 1]  873     ld a,#TAB 
      009BA4 00 01 06         [ 4]  874     call uart_tx 
      009BA7 FB 02 00         [ 4]  875     call decode
                                    876 ; here XL = decoded byte count
      009BAA 01               [ 1]  877     clr a 
      009BAB 08 70 42 06      [ 2]  878     addw x,farptr+1
      009BAF 08 00 73         [ 1]  879     adc a,farptr
      009BB2 14 06 08         [ 1]  880     ld farptr,a 
      009BB5 00 74 5E         [ 2]  881     ldw farptr+1,x 
      009BB8 06 08            [ 1]  882     dec (INST_CNTR,sp)
      009BBA 00 76            [ 1]  883     jrne instr_loop
                                    884 ; pause wait spacebar for next page or other to leave
      009BBC 51 06 08         [ 4]  885     call uart_getchar
      009BBF 00 77            [ 1]  886     cp a,#SPACE 
      009BC1 5C 06            [ 1]  887     jreq page_loop
      009BC3 08 00            [ 2]  888     jra dasm_exit        
      000E69                        889  dasm_miss_arg:
      009BC5 78 59 06         [ 4]  890     call error_print    
      000E6C                        891 dasm_exit: 
      009BC8 08 00            [ 2]  892     popw y 
      009BCA 79               [ 2]  893     popw x 
      009BCB 4E 06            [ 2]  894     addw sp,#LOCAL_SIZE 
      009BCD 08               [ 4]  895     ret 
                                    896 
                                    897 ;------------------------------------------
                                    898 ;instruction decoder
                                    899 ; print instruction mnemonic and arguments
                                    900 ; input:
                                    901 ;   farptr  address next instruction
                                    902 ; output:
                                    903 ;   X       decoded byte count 
                                    904 ;--------------------------------------------  
                                    905 ; local variables      
                           000001   906     PREFIX = 1 ; opcode prefix 
                           000002   907     OPCODE = 2 ; operating code 
                           000002   908     LOCAL_SIZE=2 ;
      000E72                        909 decode:
      009BCE 00 7A            [ 2]  910     sub sp,#LOCAL_SIZE 
      009BD0 17               [ 1]  911     clrw x 
      009BD1 06 08 00         [ 4]  912     call get_int8    
      009BD4 7C 1E            [ 1]  913     ld (OPCODE,sp),a 
      009BD6 06 08 00         [ 4]  914     call is_prefix 
      009BD9 7D 64            [ 1]  915     ld (PREFIX,sp),a 
      009BDB 06 08            [ 1]  916     cp a,#0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



      009BDD 00 7E            [ 1]  917     jrne 0$
                                    918 ; no prefix     
      009BDF 62 06            [ 1]  919     ld a,#0xf0 
      009BE1 08 00            [ 1]  920     and a,(OPCODE,sp)
      009BE3 7F 11            [ 1]  921     cp a,#0x20
      009BE5 06 08            [ 1]  922     jrne 10$
      009BE7 00 F0            [ 1]  923     ld a,(OPCODE,sp)
      009BE9 60 06            [ 1]  924     and a,#0xf 
      009BEB 01 08 F1         [ 4]  925     call fn_rel8 
      009BEE 13 06 01         [ 2]  926     jp decode_exit 
      000E95                        927 10$:
      009BF1 08 F2 55 06      [ 2]  928     ldw y,#codes 
      009BF5 01 08            [ 2]  929     jra 6$
                                    930 ; get opcode
      009BF7 F3 16 06         [ 4]  931 0$: call get_int8 
      009BFA 07 08            [ 1]  932     ld (OPCODE,sp),a  
      009BFC F4 04            [ 1]  933     ld a,(PREFIX,sp)
      009BFE 06 01            [ 1]  934 1$: cp a,#0x72 
      009C00 08 F6            [ 1]  935     jrne 2$
      009C02 3D 06            [ 1]  936     ld a,(OPCODE,sp)
      009C04 01 08            [ 1]  937     and a,#0xf0 
      009C06 F8 69            [ 1]  938     jrne 11$
      009C08 06 01            [ 1]  939     ld a,(OPCODE,sp)
      009C0A 08 F9            [ 1]  940     and a,#0xf 
      009C0C 01 06 01         [ 4]  941     call fn_adr16_b_rel
      009C0F 08 FA 45         [ 2]  942     jp decode_exit 
      000EB6                        943 11$:
      009C12 06 01            [ 1]  944     cp a,#0x10  
      009C14 08 FB            [ 1]  945     jrne 12$
      009C16 02 06            [ 1]  946     ld a,(OPCODE,sp)
      009C18 01 08            [ 1]  947     and a,#0xf 
      009C1A FC 22 06         [ 4]  948     call fn_adr16_bit
      009C1D 08 00 FD         [ 2]  949     jp decode_exit 
      000EC4                        950 12$:    
      009C20 0D 06 08 00      [ 2]  951     ldw y,#p72_codes
      009C24 FE 3F            [ 2]  952     jra 6$
      009C26 06 08            [ 1]  953 2$: cp a,#0x90
      009C28 08 F7            [ 1]  954     jrne 3$
      009C2A 3D 07            [ 1]  955     ld a,(OPCODE,sp)
      009C2C 08 01            [ 1]  956     and a,#0xf0 
      009C2E FF 3F            [ 1]  957     cp a,#0x10 
      009C30 07 08            [ 1]  958     jrne 21$
      009C32 07 AE            [ 1]  959     ld a,(OPCODE,sp) 
      009C34 3F 05 08         [ 4]  960     call fn_adr16_bit 
      009C37 08 E9 01         [ 2]  961     jp decode_exit 
      000EDE                        962 21$: 
      009C3A 03 01            [ 1]  963     cp a,#0x20 
      009C3C 08 EB            [ 1]  964     jrne 22$
      009C3E 02 03            [ 1]  965     ld a,(OPCODE,sp)
      009C40 01 08 BF         [ 4]  966     call fn_rel8 
      009C43 3F 0D            [ 2]  967     jra decode_exit 
      000EE9                        968 22$:
      009C45 00 08 BE 3F      [ 2]  969     ldw y,#p90_codes
      009C49 08 08            [ 2]  970     jra 6$
      009C4B 00 CE            [ 1]  971 3$: cp a,#0x91 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



      009C4D 3F 09            [ 1]  972     jrne 4$
      009C4F 08 00 E7 3D      [ 2]  973     ldw y,#p91_codes
      009C53 1D 08            [ 2]  974     jra 6$ 
      009C55 01 EF 3F 1D      [ 2]  975 4$: ldw y,#p92_codes 
      009C59 08 07            [ 1]  976 6$: ld a,(OPCODE,sp)
      009C5B D7 3D            [ 4]  977     callr search_code
      009C5D 20 08 01 DF 3F   [ 2]  978     btjf flags,#F_FOUND,invalid_opcode
      009C62 20 08            [ 2]  979     pushw y 
      009C64 07 D0 60         [ 1]  980     ld a,(FIELD_FN,y)
      009C67 1F 01 08 D1      [ 2]  981     ldw y,#fn_index
      009C6B 13 1F 01         [ 4]  982     call ld_table_entry
      009C6E 08 D2            [ 4]  983     call (y)
      009C70 55 1F            [ 2]  984     popw y 
      009C72 01 08            [ 2]  985     jra decode_exit 
      000F18                        986 invalid_opcode: 
      009C74 D3 16 1F 07      [ 2]  987     ldw y, #bad_opcode 
      009C78 08 D4            [ 2]  988     pushw y 
      009C7A 04 1F 01         [ 4]  989     call fn_implied  
      009C7D 08 D5            [ 2]  990     popw y 
      000F23                        991 decode_exit:    
      009C7F 06 1F            [ 2]  992     addw sp,#LOCAL_SIZE 
      009C81 01               [ 4]  993     ret
                                    994 
      009C82 08 D6 3D 1F 01         995 bad_opcode:  .byte 0,IDX.QM,IDX.FN_IMPL,0,0  
                                    996 
                                    997 ;---------------------------
                                    998 ; search code in table  
                                    999 ; input:
                                   1000 ;   Y       pointer to table
                                   1001 ;   A       opcode to verify
                                   1002 ; output:
                                   1003 ;   Y       pointer to entry 
                                   1004 ;   C       carry flag set if found cleared otherwise 
                                   1005 ;---------------------------
      000F2B                       1006 search_code:
      009C87 08               [ 1] 1007     push a 
      009C88 D8 69 1F 01      [ 1] 1008     bset flags,#F_FOUND 
      009C8C 08 D9 01         [ 1] 1009 1$: ld a,(FIELD_MNEMO,y)
      009C8F 1F 01            [ 1] 1010     jreq 8$ 
      009C91 08 DA 45         [ 1] 1011     ld a,(FIELD_OPCODE,y)
      009C94 1F 01            [ 1] 1012     cp a,(1,sp)
      009C96 08 DB            [ 1] 1013     jreq 9$
      009C98 02 1F 01 08      [ 2] 1014     addw y,#STRUCT_SIZE
      009C9C DE 3F            [ 2] 1015     jra 1$
      009C9E 1F 08 08 DC      [ 1] 1016 8$: bres flags,#F_FOUND 
      009CA2 22               [ 1] 1017 9$: pop a 
      009CA3 1E               [ 4] 1018     ret 
                                   1019 
                                   1020 ;-------------------------------
                                   1021 ; check if byte is a opcode prefix  
                                   1022 ; input:
                                   1023 ;   A       value to check
                                   1024 ; output:
                                   1025 ;   A       prefix or 0.
                                   1026 ;-------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                                   1027 ; input:
                                   1028 ;   A       code to check
                                   1029 ; output:
                                   1030 ;   A       A=0 if not precode 
      000F48                       1031 is_prefix:
      009CA4 08               [ 1] 1032     push a
      009CA5 00 DD 0D 1E      [ 2] 1033     ldw y, #prefixes
      009CA9 08 00            [ 1] 1034 1$: ld a,(y)
      009CAB AF 3E            [ 1] 1035     jreq 2$
      009CAD 21 01            [ 1] 1036     incw y
      009CAF 08 A7            [ 1] 1037     cp a,(1,sp)
      009CB1 3E 22            [ 1] 1038     jrne 1$  
      009CB3 08 01            [ 2] 1039 2$: addw sp,#1
      009CB5 CF               [ 4] 1040     ret 
                                   1041 
                                   1042 ; opcode prefixes 
      009CB6 3F 0E 00 08 00        1043 prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  
                                   1044 
                                   1045 
                                   1046 ;*******************************
                                   1047 
                                   1048 ;----------------------------
                                   1049 ;  helper macros 
                                   1050 ;----------------------------
                                   1051 ; lsize is local variables size in bytes 
                                   1052 ; nomae is routine name 
                                   1053     .macro _fn_entry lsize name
                                   1054     LOCAL_SIZE = lsize
                                   1055     STRUCT=3+LOCAL_SIZE
                                   1056 name:
                                   1057     sub sp,#LOCAL_SIZE
                                   1058     .endm
                                   1059 
                                   1060     .macro _fn_exit 
                                   1061     addw sp,#LOCAL_SIZE 
                                   1062     ret
                                   1063     .endm
                                   1064 
                                   1065 ;******************************
                                   1066 
                                   1067 ;---------------------------
                                   1068 ;  forms without arguments bytes 
                                   1069 ;  1 or 2 bytes opcodes 
                                   1070 ;---------------------------
      009CBB 00 00 00 00 00        1071 fmt_impl_no_arg: .asciz "%a%s" 
      009CBF 25 61 25 73 09 25 73  1072 fmt_impl_1_r: .asciz "%a%s\t%s"
             00
      009CBF D0 60 19 01 08 D1 13  1073 fmt_impl_2_r: .asciz "%a%s\t%s,%s" 
             19 01 08 D2
      009CCA 55 19 01 08 D3 16     1074 fmt_select: .word fmt_impl_no_arg,fmt_impl_1_r,fmt_impl_2_r 
                                   1075 
                           000001  1076     SPC=1
                           000002  1077     MNEMO=2 
                           000004  1078     DEST=4
                           000006  1079     SRC=6
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                           000008  1080     FMT=8
      000F7D                       1081 _fn_entry 8 fn_implied
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      000F7D                          3 fn_implied:
      009CD0 19 07            [ 2]    4     sub sp,#LOCAL_SIZE
      009CD2 08 D4            [ 1] 1082     clrw y 
      009CD4 04 19            [ 2] 1083     ldw (DEST,sp),y
      009CD6 01 08            [ 2] 1084     ldw (SRC,sp),y 
      009CD8 D5 06            [ 1] 1085     clr (FMT,sp)
      009CDA 19 01            [ 2] 1086     ldw y,(STRUCT,sp)
      009CDC 08 D6 3D         [ 4] 1087     call ld_mnemonic
      009CDF 19 01 08         [ 1] 1088     ld a,(FIELD_DEST,y)
      009CE2 D8 69            [ 1] 1089     jreq 1$
      009CE4 19 01            [ 1] 1090     inc (FMT,sp)
      009CE6 08 D9 01 19      [ 2] 1091     ldw y,#reg_index 
      009CEA 01 08 DA         [ 4] 1092     call ld_table_entry
      009CED 45 19            [ 2] 1093     ldw (DEST,sp),y 
      009CEF 01 08            [ 2] 1094     ldw y,(STRUCT,sp)
      009CF1 DB 02 19         [ 1] 1095 1$: ld a, (FIELD_SRC,y)
      009CF4 01 08            [ 1] 1096     jreq 2$
      009CF6 DE 3F            [ 1] 1097     inc (FMT,sp)
      009CF8 19 08 08 D7      [ 2] 1098     ldw y,#reg_index
      009CFC 3D 1B 08         [ 4] 1099     call ld_table_entry
      009CFF 01 AF            [ 2] 1100     ldw (SRC,sp),y 
      009D01 3E 1A 01 08      [ 2] 1101 2$: ldw y,#fmt_select 
      009D05 A7 3E            [ 1] 1102     ld a,(FMT,sp)
      009D07 1C 08 01         [ 4] 1103     call ld_table_entry 
      009D0A CE 3F 15         [ 4] 1104     call format     
      000FBA                       1105 _fn_exit 
      009D0D 08 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      009D0F CF               [ 4]    2     ret
                                   1106 
                                   1107 ;---------------------------
                                   1108 ; form: op #imm8 
                                   1109 ;---------------------------
      009D10 3F 17 00 08 DF 3F 1B  1110 fmt_op_imm8: .asciz "%a%s\t#%b"
             08 07
                           000001  1111     SPC=1
                           000002  1112     MNEMO=2
                           000004  1113     IMM8=4
      000FC6                       1114 _fn_entry 4 fn_imm8 
                           000004     1     LOCAL_SIZE = 4
                           000007     2     STRUCT=3+LOCAL_SIZE
      000FC6                          3 fn_imm8:
      009D19 60 42            [ 2]    4     sub sp,#LOCAL_SIZE
      009D1B 26 08 00         [ 4] 1115     call get_int8
      009D1E 63 14            [ 1] 1116     ld (IMM8,sp),a 
      009D20 26 08            [ 2] 1117     ldw y,(STRUCT,sp)
      009D22 00 64 5E         [ 4] 1118     call ld_mnemonic
      009D25 26 08 00 66      [ 2] 1119     ldw y,#fmt_op_imm8 
      009D29 51 26 08         [ 4] 1120     call format 
      000FD9                       1121 _fn_exit
      009D2C 00 67            [ 2]    1     addw sp,#LOCAL_SIZE 
      009D2E 5C               [ 4]    2     ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                                   1122 
                                   1123 ;----------------------------
                                   1124 ; form op rel8 
                                   1125 ; jpr or callr 
                                   1126 ;----------------------------
      000FDC                       1127 jrxx_opcode: 
      009D2F 26 08 00 68 59 26 08  1128     .word M.JRA,M.JRF,M.JRUGT,M.JRULE,M.JRNC,M.JRC,M.JRNE,M.JREQ
             00 69 4E 26 08 00 6A
             17 26
      009D3F 08 00 6C 1E 26 08 00  1129     .word M.JRNV,M.JRV,M.JRPL,M.JRMI,M.JRSGT,M.JRSLE,M.JRSGE,M.JRSLT
             6D 64 26 08 00 6E 62
             26 08
      000FFC                       1130 jrxx_90_opcode:  
      009D4F 00 6F 11 26 08 00 DC  1131     .word M.JRNH,M.JRH,0,0,M.JRNM,M.JRM,M.JRIL,M.JRIH    
             22 26 08 00 DD 0D 26
             08 00
      009D5F 00 00 00 00 00 25 65  1132 fmt_op_rel8: .asciz "%a%s\t%e"
             00
                           000001  1133     SPC=1 
                           000002  1134     MNEMO=2
                           000004  1135     ADR24 = 4
                           000007  1136     CODE=7
      009D64                       1137 _fn_entry 7 fn_rel8
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001014                          3 fn_rel8:
      009D64 C0 60            [ 2]    4     sub sp,#LOCAL_SIZE
      009D66 15 01            [ 1] 1138     ld (CODE,sp),a
      009D68 00               [ 1] 1139     swap a 
      009D69 C1 13            [ 1] 1140     and a,#0xf 
      009D6B 15 01            [ 1] 1141     jreq 0$
      009D6D 00 C2            [ 1] 1142     ld a,#12
      009D6F 55 15            [ 2] 1143     jra 3$
      009D71 01 00            [ 1] 1144 0$: ld a,#16
      009D73 C3 16            [ 1] 1145 3$: ld (SPC,sp),a 
      009D75 15 07 00         [ 4] 1146     call get_int8 
      009D78 C4 04 15         [ 4] 1147     call abs_addr
      009D7B 01 00 C5 06      [ 2] 1148     ldw y,acc24 
      009D7F 15 01 00         [ 1] 1149     ld a,acc8 
      009D82 C6 3D            [ 2] 1150     ldw (ADR24,sp),y 
      009D84 15 01            [ 1] 1151     ld (ADR24+2,sp),a
      009D86 00 C8 69 15      [ 2] 1152     ldw y,#jrxx_opcode 
      009D8A 01 00            [ 1] 1153     ld a,(CODE,sp)
      009D8C C9 01            [ 1] 1154     and a,#0xf0 
      009D8E 15 01            [ 1] 1155     jreq 1$
      009D90 00 CA 45 15      [ 2] 1156     ldw y,#jrxx_90_opcode
      009D94 01 00            [ 1] 1157 1$: ld a,(CODE,sp)
      009D96 CB 02            [ 1] 1158     and a,#0xf
      009D98 15 01 00 CE      [ 2] 1159     cpw y,#jrxx_opcode 
      009D9C 3F 15            [ 1] 1160     jreq 2$
      009D9E 01 00            [ 1] 1161     sub a,#8
      009DA0 D0               [ 1] 1162 2$: sll a 
      009DA1 60 19 01         [ 1] 1163     ld acc8,a 
      009DA4 07 D1 13 19      [ 1] 1164     clr acc16 
      009DA8 01 07 D2 55      [ 2] 1165     addw y,acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



      009DAC 19 01            [ 2] 1166     ldw y,(y)
      009DAE 07 D3            [ 2] 1167     ldw (MNEMO,sp),y 
      009DB0 16 19 08 07      [ 2] 1168     ldw y,#fmt_op_rel8
      009DB4 D4 04 19         [ 4] 1169     call format  
      001067                       1170 _fn_exit 
      009DB7 01 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      009DB9 D5               [ 4]    2     ret
                                   1171 
                                   1172 ;----------------------------
                                   1173 ; form op adr8 
                                   1174 ; exemple: clr 0xC0 
                                   1175 ;----------------------------
      009DBA 06 19 01 07 D6 3D 19  1176 fmt_op_adr8: .asciz "%a%s\t%e"
             01
                           000001  1177     SPC=1
                           000002  1178     MNEMO=2
                           000004  1179     ADR8=4
      001072                       1180 _fn_entry 6 fn_adr8 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001072                          3 fn_adr8:
      009DC2 07 D8            [ 2]    4     sub sp,#LOCAL_SIZE
      009DC4 69 19 01         [ 4] 1181     call get_int8 
      009DC7 07 D9            [ 1] 1182     ld (ADR8+2,sp),a
      009DC9 01 19            [ 1] 1183     clrw y 
      009DCB 01 07            [ 2] 1184     ldw (ADR8,sp),y  
      009DCD DA 45            [ 2] 1185     ldw y,(STRUCT,sp)
      009DCF 19 01 07         [ 1] 1186     ld a,(FIELD_MNEMO,y)
      009DD2 DB 02            [ 1] 1187     cp a,#IDX.CALLR 
      009DD4 19 01            [ 1] 1188     jrne 1$
      009DD6 07 DE            [ 1] 1189     ld a,(ADR8+2,sp)
      009DD8 3F 19 01         [ 4] 1190     call abs_addr
      009DDB 07 C7 3D 17      [ 2] 1191     ldw y,acc24  
      009DDF 00 01            [ 2] 1192     ldw (ADR8,sp),y 
      009DE1 CF 3F 17         [ 1] 1193     ld a,acc24+2 
      009DE4 00 07            [ 1] 1194     ld (ADR8+2,sp),a 
      009DE6 D7 3D            [ 2] 1195     ldw y,(STRUCT,sp)
      001098                       1196 1$:     
      009DE8 1B 07 01         [ 4] 1197     call ld_mnemonic
      009DEB DF 3F 1B 07      [ 2] 1198     ldw y,#fmt_op_adr8 
      009DEF 08 AF 3E         [ 4] 1199     call format 
      0010A2                       1200 _fn_exit 
      009DF2 1A 01            [ 2]    1     addw sp,#LOCAL_SIZE 
      009DF4 07               [ 4]    2     ret
                                   1201 
                                   1202 ;----------------------------
                                   1203 ; form op adr16 
                                   1204 ; jp or call 
                                   1205 ;----------------------------
      009DF5 A7 3E 1C 07 01 BC 3E  1206 fmt_op_adr16: .asciz "%a%s\t%w" 
             16
                           000001  1207     SPC=1
                           000002  1208     MNEMO=2
                           000004  1209     ADR16=4
      0010AD                       1210 _fn_entry 5 fn_adr16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



                           000005     1     LOCAL_SIZE = 5
                           000008     2     STRUCT=3+LOCAL_SIZE
      0010AD                          3 fn_adr16:
      009DFD 01 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009DFF BD 3E 18         [ 4] 1211     call get_int16 
      009E02 00 01            [ 2] 1212     ldw (ADR16,sp),y 
      009E04 8D 0E            [ 2] 1213     ldw y,(STRUCT,sp)
      009E06 23 00 00         [ 4] 1214     call ld_mnemonic
      009E09 AC 23 23 00      [ 2] 1215     ldw y,#fmt_op_adr16 
      009E0D 00 30 42         [ 4] 1216     call format 
      0010C0                       1217 _fn_exit 
      009E10 24 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E12 00               [ 4]    2     ret
                                   1218 
                                   1219 ;----------------------------
                                   1220 ; form op adr24 
                                   1221 ; jpf or callf 
                                   1222 ;----------------------------
      009E13 33 14 24 00 00 34 5E  1223 fmt_op_adr24: .asciz "%a%s\t%e"
             24
                           000001  1224     SPC=1
                           000002  1225     MNEMO=2
                           000004  1226     ADR24=4 
      0010CB                       1227 _fn_entry 6 fn_adr24 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0010CB                          3 fn_adr24:
      009E1B 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E1D 36 51 24         [ 4] 1228     call get_int24
      009E20 00 00            [ 2] 1229     ldw (ADR24,sp),y 
      009E22 37 5C            [ 1] 1230     ld (ADR24+2,sp),a 
      009E24 24 00            [ 2] 1231     ldw y,(STRUCT,sp)
      009E26 00 38 59         [ 4] 1232     call ld_mnemonic
      009E29 24 00 00 39      [ 2] 1233     ldw y,#fmt_op_adr24 
      009E2D 4E 24 00         [ 4] 1234     call format 
      0010E0                       1235 _fn_exit 
      009E30 00 3A            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E32 17               [ 4]    2     ret
                                   1236 
                                   1237 ;----------------------------
                                   1238 ;  form op adr8,r 
                                   1239 ;----------------------------
      009E33 24 00 00 3C 1E 24 00  1240 fmt_op_adr8_r: .asciz "%a%s\t%b,%s"
             00 3D 64 24
                           000001  1241     SPC=1
                           000002  1242     MNEMO=2
                           000004  1243     ADR8=4
                           000005  1244     REG=5 
      0010EE                       1245 _fn_entry 6 fn_adr8_r 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0010EE                          3 fn_adr8_r:
      009E3E 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E40 3E 62 24         [ 4] 1246     call get_int8 
      009E43 00 00            [ 1] 1247     ld (ADR8,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



      009E45 3F 11            [ 2] 1248     ldw y,(STRUCT,sp)
      009E47 24 00 00         [ 4] 1249     call ld_mnemonic
      009E4A 60 42 26         [ 1] 1250     ld a,(FIELD_SRC,y)
      009E4D 07 00 63 14      [ 2] 1251     ldw y,#reg_index
      009E51 26 07 00         [ 4] 1252     call ld_table_entry
      009E54 64 5E            [ 2] 1253     ldw (REG,sp),y
      009E56 26 07 00 66      [ 2] 1254     ldw y,#fmt_op_adr8_r 
      009E5A 51 26 07         [ 4] 1255     call format 
      00110D                       1256 _fn_exit 
      009E5D 00 67            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E5F 5C               [ 4]    2     ret
                                   1257 
                                   1258 ;----------------------------
                                   1259 ; form op adr16,r 
                                   1260 ;----------------------------
      009E60 26 07 00 68 59 26 07  1261 fmt_op_adr16_r: .asciz "%a%s\t%w,%s" 
             00 69 4E 26
                           000001  1262     SPC=1 
                           000002  1263     MNEMO=2
                           000004  1264     ADR16=4
                           000006  1265     REG=6 
      00111B                       1266 _fn_entry 7  fn_adr16_r
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00111B                          3 fn_adr16_r:
      009E6B 07 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E6D 6A 17 26         [ 4] 1267     call get_int16 
      009E70 07 00            [ 2] 1268     ldw (ADR16,sp),y 
      009E72 6C 1E            [ 2] 1269     ldw y,(STRUCT,sp)
      009E74 26 07 00         [ 4] 1270     call ld_mnemonic
      009E77 6D 64 26         [ 1] 1271     ld a,(FIELD_SRC,y)
      009E7A 07 00 6E 62      [ 2] 1272     ldw y,#reg_index 
      009E7E 26 07 00         [ 4] 1273     call ld_table_entry
      009E81 6F 11            [ 2] 1274     ldw (REG,sp),y 
      009E83 26 07 00 ED      [ 2] 1275     ldw y,#fmt_op_adr16_r 
      009E87 0D 26 07         [ 4] 1276     call format 
      00113A                       1277 _fn_exit
      009E8A 00 DC            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E8C 22               [ 4]    2     ret
                                   1278 
                                   1279 ;----------------------------
                                   1280 ; form op adr24,r  
                                   1281 ;----------------------------
      009E8D 26 07 00 DD 0D 26 07  1282 fmt_op_adr24_r: .asciz "%a%s\t%e,%s" 
             00 00 00 00
                           000001  1283     SPC=1
                           000002  1284     MNEMO=2
                           000004  1285     ADR24=4
                           000007  1286     REG=7
      001148                       1287 _fn_entry 8 fn_adr24_r 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      001148                          3 fn_adr24_r:
      009E98 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E9A CD 18 79         [ 4] 1288     call get_int24 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



      009E9A 89 90            [ 2] 1289     ldw (ADR24,sp),y 
      009E9C 89 52            [ 1] 1290     ld (ADR24+2,sp),a 
      009E9E 01 CD            [ 2] 1291     ldw y,(STRUCT,sp)
      009EA0 86 97 C6         [ 4] 1292     call ld_mnemonic
      009EA3 00 5B 27         [ 1] 1293     ld a,(FIELD_SRC,y)
      009EA6 48 AE 00 AB      [ 2] 1294     ldw y,#reg_index 
      009EAA 90 AE 00         [ 4] 1295     call ld_table_entry
      009EAD AE CD            [ 2] 1296     ldw (REG,sp),y 
      009EAF 85 6E 11 3D      [ 2] 1297     ldw y,#fmt_op_adr24_r 
      009EB1 CD 00 00         [ 4] 1298     call format 
      001169                       1299 _fn_exit 
      009EB1 A6 18            [ 2]    1     addw sp,#LOCAL_SIZE 
      009EB3 6B               [ 4]    2     ret
                                   1300 
                                   1301 ;----------------------------
                                   1302 ; form op r,adr8 
                                   1303 ; exemple:  ldw x,$50
                                   1304 ;----------------------------
      009EB4 01 61 25 73 09 25 73  1305 fmt_op_r_adr8: .asciz "%a%s\t%s,%b"
             2C 25 62 00
                           000001  1306     SPC=1
                           000002  1307     MNEMO=2
                           000004  1308     REG=4
                           000006  1309     ADR8 = 6
      009EB5                       1310 _fn_entry 6 fn_r_adr8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001177                          3 fn_r_adr8:
      009EB5 A6 0D            [ 2]    4     sub sp,#LOCAL_SIZE
      009EB7 CD 8F 2D         [ 4] 1311     call get_int8 
      009EBA AE 00            [ 1] 1312     ld (ADR8,sp),a 
      009EBC AE 90            [ 2] 1313     ldw y,(STRUCT,sp) 
      009EBE AE 00 AB         [ 4] 1314     call ld_mnemonic
      009EC1 CD 85 6E         [ 1] 1315     ld a,(FIELD_DEST,y)
      009EC4 A6 06 97 A6      [ 2] 1316     ldw y,#reg_index 
      009EC8 10 CD 8F         [ 4] 1317     call ld_table_entry
      009ECB 9B A6            [ 2] 1318     ldw (REG,sp),y 
      009ECD 09 CD 8F 2D      [ 2] 1319     ldw y,#fmt_op_r_adr8 
      009ED1 CD 9E F8         [ 4] 1320     call format 
      001196                       1321 _fn_exit 
      009ED4 4F 72            [ 2]    1     addw sp,#LOCAL_SIZE 
      009ED6 BB               [ 4]    2     ret
                                   1322 
                                   1323 ;----------------------------
                                   1324 ; form op r,adr16 
                                   1325 ; exemple:  ldw x,$5000 
                                   1326 ;----------------------------
      009ED7 00 AF C9 00 AE C7 00  1327 fmt_op_r_adr16: .asciz "%a%s\t%s,%w" 
             AE CF 00 AF
                           000001  1328     SPC=1
                           000002  1329     MNEMO=2
                           000004  1330     REG=4
                           000006  1331     ADR16 = 6
      0011A4                       1332 _fn_entry 7 fn_r_adr16
                           000007     1     LOCAL_SIZE = 7
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                           00000A     2     STRUCT=3+LOCAL_SIZE
      0011A4                          3 fn_r_adr16:
      009EE2 0A 01            [ 2]    4     sub sp,#LOCAL_SIZE
      009EE4 26 CF CD         [ 4] 1333     call get_int16 
      009EE7 8F 5A            [ 2] 1334     ldw (ADR16,sp),y 
      009EE9 A1 20            [ 2] 1335     ldw y,(STRUCT,sp) 
      009EEB 27 C4 20         [ 4] 1336     call ld_mnemonic
      009EEE 03 E6 03         [ 1] 1337     ld a,(FIELD_DEST,y)
      009EEF 90 AE 02 BC      [ 2] 1338     ldw y,#reg_index 
      009EEF CD 8B 45         [ 4] 1339     call ld_table_entry
      009EF2 17 04            [ 2] 1340     ldw (REG,sp),y 
      009EF2 90 85 85 5B      [ 2] 1341     ldw y,#fmt_op_r_adr16 
      009EF6 01 81 00         [ 4] 1342     call format 
      009EF8                       1343 _fn_exit 
      009EF8 52 02            [ 2]    1     addw sp,#LOCAL_SIZE 
      009EFA 5F               [ 4]    2     ret
                                   1344 
                                   1345 ;----------------------------
                                   1346 ; form op r,adr24 
                                   1347 ; exemple:  ldf a,$12000  
                                   1348 ;----------------------------
      009EFB CD A8 BF 6B 02 CD 9F  1349 fmt_op_r_adr24: .asciz "%a%s\t%s,%e" 
             CE 6B 01 A1
                           000001  1350     SPC=1
                           000002  1351     MNEMO=2
                           000004  1352     REG=4    
                           000006  1353     ADR24 = 6
      0011D1                       1354 _fn_entry 8 fn_r_adr24 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      0011D1                          3 fn_r_adr24:
      009F06 00 26            [ 2]    4     sub sp,#LOCAL_SIZE
      009F08 18 A6 F0         [ 4] 1355     call get_int24 
      009F0B 14 02            [ 2] 1356     ldw (ADR24,sp),y
      009F0D A1 20            [ 1] 1357     ld (ADR24+2,sp),a  
      009F0F 26 0A            [ 2] 1358     ldw y,(STRUCT,sp) 
      009F11 7B 02 A4         [ 4] 1359     call ld_mnemonic
      009F14 0F CD A0         [ 1] 1360     ld a,(FIELD_DEST,y)
      009F17 9A CC 9F A9      [ 2] 1361     ldw y,#reg_index
      009F1B CD 18 D1         [ 4] 1362     call ld_table_entry
      009F1B 90 AE            [ 2] 1363     ldw (REG,sp),y 
      009F1D 93 D7 20 62      [ 2] 1364     ldw y,#fmt_op_r_adr24 
      009F21 CD A8 BF         [ 4] 1365     call format 
      0011F2                       1366 _fn_exit 
      009F24 6B 02            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F26 7B               [ 4]    2     ret
                                   1367 
                                   1368 ;----------------------------
                                   1369 ; register indexed without offset 
                                   1370 ; form: op r,(r)
                                   1371 ; form: op (r)
                                   1372 ;----------------------------
      009F27 01 A1 72 26 24 7B 02  1373 fmt_op_idx: .asciz "%a%s\t(%s)"
             A4 F0 26
      009F31 0A 7B 02 A4 0F CD A3  1374 fmt_op_r_idx: .asciz "%a%s\t%s,(%s)"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal  42-Bits]



             2C 28 25 73 29 00
      009F39 CC 9F A9 FF           1375 fmt_sel2: .word fmt_op_idx,fmt_op_r_idx 
                           000001  1376     SPC=1
                           000002  1377     MNEMO=2
                           000004  1378     DEST=4
                           000006  1379     SRC=6
                           000008  1380     FMT=8 
      009F3C                       1381 _fn_entry 8 fn_r_idx
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      001210                          3 fn_r_idx:
      009F3C A1 10            [ 2]    4     sub sp,#LOCAL_SIZE
      009F3E 26 0A            [ 1] 1382     clr (FMT,sp)
      009F40 7B 02            [ 2] 1383     ldw y,(STRUCT,sp)
      009F42 A4 0F CD         [ 4] 1384     call ld_mnemonic
      009F45 A3 99 CC         [ 1] 1385     ld a,(FIELD_DEST,y)
      009F48 9F A9 02 BC      [ 2] 1386     ldw y,#reg_index
      009F4A CD 18 D1         [ 4] 1387     call ld_table_entry
      009F4A 90 AE            [ 2] 1388     ldw (DEST,sp),y
      009F4C 98 78            [ 2] 1389     ldw y,(STRUCT,sp)
      009F4E 20 33 A1         [ 1] 1390     ld a,(FIELD_SRC,y)
      009F51 90 26            [ 1] 1391     jreq 1$
      009F53 21 7B            [ 1] 1392     inc (FMT,sp)
      009F55 02 A4 F0 A1      [ 2] 1393 1$: ldw y,#reg_index
      009F59 10 26 08         [ 4] 1394     call ld_table_entry
      009F5C 7B 02            [ 2] 1395     ldw (SRC,sp),y 
      009F5E CD A3            [ 1] 1396     ld a,(FMT,sp)
      009F60 99 CC 9F A9      [ 2] 1397     ldw y,#fmt_sel2
      009F64 CD 18 D1         [ 4] 1398     call ld_table_entry 
      009F64 A1 20 26         [ 4] 1399     call format 
      001243                       1400 _fn_exit 
      009F67 07 7B            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F69 02               [ 4]    2     ret
                                   1401 
                                   1402 ;----------------------------
                                   1403 ; register indexed without offset 
                                   1404 ; form: op (r),r
                                   1405 ;----------------------------
      009F6A CD A0 9A 20 3A 28 25  1406 fmt_op_idx_r: .asciz "%a%s\t(%s),%s"
             73 29 2C 25 73 00
                           000001  1407     SPC=1
                           000002  1408     MNEMO=2
                           000004  1409     DEST=4
                           000006  1410     SRC=6
      009F6F                       1411 _fn_entry 7 fn_idx_r 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001253                          3 fn_idx_r:
      009F6F 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      009F71 9A 62            [ 2] 1412     ldw y,(STRUCT,sp)
      009F73 20 0E A1         [ 4] 1413     call ld_mnemonic
      009F76 91 26 06         [ 1] 1414     ld a,(FIELD_DEST,y)
      009F79 90 AE 9C BF      [ 2] 1415     ldw y,#reg_index 
      009F7D 20 04 90         [ 4] 1416     call ld_table_entry
      009F80 AE 9D            [ 2] 1417     ldw (DEST,sp),y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
Hexadecimal [24-Bits]



      009F82 64 7B            [ 2] 1418     ldw y,(STRUCT,sp)
      009F84 02 AD 2A         [ 1] 1419     ld a,(FIELD_SRC,y)
      009F87 72 05 00 B1      [ 2] 1420     ldw y,#reg_index 
      009F8B 12 90 89         [ 4] 1421     call ld_table_entry
      009F8E 90 E6            [ 2] 1422     ldw (SRC,sp),y 
      009F90 02 90 AE 93      [ 2] 1423     ldw y,#fmt_op_idx_r 
      009F94 89 CD A9         [ 4] 1424     call format 
      00127B                       1425 _fn_exit 
      009F97 57 90            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F99 FD               [ 4]    2     ret
                                   1426 
                                   1427 ;----------------------------
                                   1428 ;  decode format: op (ofs8,r)
                                   1429 ;----------------------------
      009F9A 90 85 20 0B 09 28 25  1430 fmt_op_ofs8_idx: .asciz "%a%s\t(%b,%s)"
             62 2C 25 73 29 00
                           000001  1431     SPC=1
                           000002  1432     MNEMO=2
                           000004  1433     OFS8=4  ; byte offset value 
                           000005  1434     REG=5 ;   pointer to register name
      009F9E                       1435 _fn_entry 6 fn_ofs8_idx 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      00128B                          3 fn_ofs8_idx:
      009F9E 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      009FA0 9F AC 90         [ 4] 1436     call get_int8 
      009FA3 89 CD            [ 1] 1437     ld (OFS8,sp),a 
      009FA5 A0 03            [ 2] 1438     ldw y,(STRUCT,sp)
      009FA7 90 85 E4         [ 4] 1439     call ld_mnemonic
      009FA9 90 E6 03         [ 1] 1440     ld a,(FIELD_DEST,y)
      009FA9 5B 02 81 00      [ 2] 1441     ldw y,#reg_index 
      009FAD 6A 00 00         [ 4] 1442     call ld_table_entry
      009FB0 00 05            [ 2] 1443     ldw (REG,sp),y 
      009FB1 90 AE 12 7E      [ 2] 1444     ldw y,#fmt_op_ofs8_idx
      009FB1 88 72 14         [ 4] 1445     call format 
      0012AA                       1446     _fn_exit
      009FB4 00 B1            [ 2]    1     addw sp,#LOCAL_SIZE 
      009FB6 90               [ 4]    2     ret
                                   1447 
                                   1448 ;--------------------------------
                                   1449 ; decode form: op adr16,#bit,rel 
                                   1450 ;--------------------------------
      009FB7 E6 01 27 0D 90 E6 00  1451 fmt_op_adr16_bit_rel: .asciz "%a%s\t%w,#%c,%e" 
             11 01 27 0A 72 A9 00
             05
                           000001  1452     SPC=1
                           000002  1453     MNEMO=2
                           000004  1454     ADR16=4
                           000006  1455     BIT=6
                           000007  1456     REL=7
      0012BC                       1457 _fn_entry 9 fn_adr16_b_rel 
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      0012BC                          3 fn_adr16_b_rel:
      009FC6 20 EE            [ 2]    4     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]



      009FC8 72 15            [ 1] 1458     ld (BIT,sp),a 
      009FCA 00 B1 84         [ 4] 1459     call get_int16
      009FCD 81 04            [ 2] 1460     ldw (ADR16,sp),y
      009FCE CD 18 39         [ 4] 1461     call get_int8
      009FCE 88 90 AE         [ 4] 1462     call abs_addr
      009FD1 9F E0 90 F6      [ 2] 1463     ldw y,acc24
      009FD5 27 06 90         [ 1] 1464     ld a,acc8 
      009FD8 5C 11            [ 2] 1465     ldw (REL,sp),y
      009FDA 01 26            [ 1] 1466     ld (REL+2,sp),a
      009FDC F6 5B            [ 1] 1467     ld a,#4
      009FDE 01 81            [ 1] 1468     ld (SPC,sp),a 
      009FE0 72 90            [ 1] 1469     ld a,(BIT,sp)
      009FE2 91 92            [ 1] 1470     and a,#1
      009FE4 00 25            [ 1] 1471     jreq 2$
      009FE6 61 25 73 00      [ 2] 1472     ldw y,#M.BTJF 
      009FEA 25 61            [ 2] 1473     jra 3$
      009FEC 25 73 09 25      [ 2] 1474 2$: ldw y,#M.BTJT    
      009FF0 73 00            [ 2] 1475 3$: ldw (MNEMO,sp),y   
      009FF2 25 61            [ 1] 1476     ld a,(BIT,sp)
      009FF4 25               [ 1] 1477     srl a 
      009FF5 73 09            [ 1] 1478     and a,#7 
      009FF7 25 73            [ 1] 1479     add a,#'0 
      009FF9 2C 25            [ 1] 1480     ld (BIT,sp),a
      009FFB 73 00 9F E5      [ 2] 1481     ldw y,#fmt_op_adr16_bit_rel
      009FFF 9F EA 9F         [ 4] 1482     call format
      0012FC                       1483 _fn_exit
      00A002 F2 09            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A003 81               [ 4]    2     ret
                                   1484 
                                   1485 ;--------------------------------------
                                   1486 ; decode form:  op adr16,#bit 
                                   1487 ;--------------------------------------
      00A003 52 08 90 5F 17 04 17  1488 bitop: .word M.BSET,M.BRES,M.BCPL,M.BCCM 
             06
      00A00B 0F 08 16 0B CD A9 6A  1489 fmt_adr16_bit: .asciz "%a%s\t%w,#%c" ;
             90 E6 03 27 0D
                           000001  1490     SPC=1
                           000002  1491     MNEMO=2
                           000004  1492     ADR16=4
                           000006  1493     BIT=6 
      001313                       1494 _fn_entry 6 fn_adr16_bit 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001313                          3 fn_adr16_bit:
      00A017 0C 08            [ 2]    4     sub sp,#LOCAL_SIZE
      00A019 90 AE            [ 1] 1495     ld (BIT,sp),a
      00A01B 93 42            [ 1] 1496     ld a,#8
      00A01D CD A9            [ 1] 1497     ld (SPC,sp),a  
      00A01F 57 17 04         [ 4] 1498     call get_int16
      00A022 16 0B            [ 2] 1499     ldw (ADR16,sp),y 
      00A024 90 E6 04 27      [ 2] 1500     ldw y,#bitop 
      00A028 0B 0C            [ 1] 1501     ld a,(BIT,sp)
      00A02A 08 90            [ 1] 1502     and a,#1 
      00A02C AE 93            [ 1] 1503     jreq 1$
      00A02E 42 CD A9 57      [ 2] 1504     addw y,#2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]



      00A032 17 06            [ 1] 1505 1$: ld a,(BIT,sp)
      00A034 90 AE            [ 1] 1506     and a,#0xf0 
      00A036 9F FD            [ 1] 1507     jreq 2$
      00A038 7B 08 CD A9      [ 2] 1508     addw y,#4
      00A03C 57 CD            [ 2] 1509 2$: ldw y,(y)
      00A03E 8E 7E            [ 2] 1510     ldw (MNEMO,sp),y 
      00A040 5B 08            [ 1] 1511     ld a,(BIT,sp)  
      00A042 81               [ 1] 1512     srl a 
      00A043 25 61            [ 1] 1513     and a,#7 
      00A045 25 73            [ 1] 1514     add a,#'0
      00A047 09 23            [ 1] 1515     ld (BIT,sp),a
      00A049 25 62 00 07      [ 2] 1516     ldw y,#fmt_adr16_bit 
      00A04C CD 00 00         [ 4] 1517     call format 
      00134C                       1518 _fn_exit
      00A04C 52 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A04E CD               [ 4]    2     ret
                                   1519 
                                   1520 ;---------------------------------
                                   1521 ; decode form  op r,(ofs8,r)
                                   1522 ;---------------------------------
      00A04F A8 BF 6B 04 16 07 CD  1523 fmt_r_ofs8_idx: .asciz "%a%s\t%s,(%b,%s)"
             A9 6A 90 AE A0 43 CD
             8E 7E
                           000001  1524     SPC=1
                           000002  1525     MNEMO=2
                           000004  1526     DEST=4
                           000006  1527     OFS8=6
                           000007  1528     SRC=7 
      00135F                       1529 _fn_entry 8 fn_r_ofs8_idx 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      00135F                          3 fn_r_ofs8_idx:
      00A05F 5B 04            [ 2]    4     sub sp,#LOCAL_SIZE
      00A061 81 18 39         [ 4] 1530     call get_int8
      00A062 6B 06            [ 1] 1531     ld (OFS8,sp),a 
      00A062 91 FC            [ 2] 1532     ldw y,(STRUCT,sp)
      00A064 92 09 92         [ 4] 1533     call ld_mnemonic
      00A067 64 92 6A         [ 1] 1534     ld a,(FIELD_DEST,y)
      00A06A 92 24 92 00      [ 2] 1535     ldw y,#reg_index
      00A06E 92 29 92         [ 4] 1536     call ld_table_entry
      00A071 04 92            [ 2] 1537     ldw (DEST,sp),y
      00A073 38 92            [ 2] 1538     ldw y,(STRUCT,sp)
      00A075 76 92 3D         [ 1] 1539     ld a,(FIELD_SRC,y)
      00A078 92 1F 92 48      [ 2] 1540     ldw y,#reg_index
      00A07C 92 4E 92         [ 4] 1541     call ld_table_entry
      00A07F 42 92            [ 2] 1542     ldw (SRC,sp),y
      00A081 54 AE 13 4F      [ 2] 1543     ldw y,#fmt_r_ofs8_idx 
      00A082 CD 00 00         [ 4] 1544     call format 
      00138C                       1545 _fn_exit
      00A082 92 2E            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A084 92               [ 4]    2     ret
                                   1546 
                                   1547 ;---------------------------------
                                   1548 ; form  op (ofs8,r),r
                                   1549 ;---------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]



      00A085 0D 00 00 00 00 92 33  1550 fmt_op_ofs8_idx_r: .asciz "%a%s\t(%b,%s),%s"
             92 1B 92 16 92 11 25
             61 25
                           000001  1551     SPC=1
                           000002  1552     MNEMO=2
                           000004  1553     OFS8=4
                           000005  1554     DEST=5
                           000007  1555     SRC=7 
      00139F                       1556 _fn_entry 8 fn_ofs8_idx_r 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      00139F                          3 fn_ofs8_idx_r:
      00A095 73 09            [ 2]    4     sub sp,#LOCAL_SIZE
      00A097 25 65 00         [ 4] 1557     call get_int8 
      00A09A 6B 04            [ 1] 1558     ld (OFS8,sp),a 
      00A09A 52 07            [ 2] 1559     ldw y,(STRUCT,sp)
      00A09C 6B 07 4E         [ 4] 1560     call ld_mnemonic
      00A09F A4 0F 27         [ 1] 1561     ld a,(FIELD_DEST,y)
      00A0A2 04 A6 0C 20      [ 2] 1562     ldw y,#reg_index 
      00A0A6 02 A6 10         [ 4] 1563     call ld_table_entry
      00A0A9 6B 01            [ 2] 1564     ldw (DEST,sp),y 
      00A0AB CD A8            [ 2] 1565     ldw y,(STRUCT,sp)
      00A0AD BF CD A9         [ 1] 1566     ld a,(FIELD_SRC,y)
      00A0B0 27 90 CE 00      [ 2] 1567     ldw y,#reg_index 
      00A0B4 AB C6 00         [ 4] 1568     call ld_table_entry
      00A0B7 AD 17            [ 2] 1569     ldw (SRC,sp),y 
      00A0B9 04 6B 06 90      [ 2] 1570     ldw y,#fmt_op_ofs8_idx_r
      00A0BD AE A0 62         [ 4] 1571     call format 
      0013CC                       1572 _fn_exit 
      00A0C0 7B 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A0C2 A4               [ 4]    2     ret
                                   1573 
                                   1574 ;---------------------------------
                                   1575 ;  decode form   op r,#imm8 
                                   1576 ;---------------------------------
      00A0C3 F0 27 04 90 AE A0 82  1577 fmt_r_imm8: .asciz "%a%s\t%s,#%b" 
             7B 07 A4 0F 90
                           000001  1578     SPC=1
                           000002  1579     MNEMO=2
                           000004  1580     REG=4
                           000006  1581     IMM8=6
      0013DB                       1582 _fn_entry 6  fn_r_imm8 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0013DB                          3 fn_r_imm8:
      00A0CF A3 A0            [ 2]    4     sub sp,#LOCAL_SIZE
      00A0D1 62 27 02         [ 4] 1583     call get_int8
      00A0D4 A0 08            [ 1] 1584     ld (IMM8,sp),a 
      00A0D6 48 C7            [ 2] 1585     ldw y,(STRUCT,sp)
      00A0D8 00 AD 72         [ 4] 1586     call ld_mnemonic 
      00A0DB 5F 00 AC         [ 1] 1587     ld a,(FIELD_DEST,y)
      00A0DE 72 B9 00 AC      [ 2] 1588     ldw y,#reg_index 
      00A0E2 90 FE 17         [ 4] 1589     call ld_table_entry
      00A0E5 02 90            [ 2] 1590     ldw (REG,sp),y 
      00A0E7 AE A0 92 CD      [ 2] 1591     ldw y,#fmt_r_imm8
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



      00A0EB 8E 7E 5B         [ 4] 1592     call format 
      0013FA                       1593 _fn_exit
      00A0EE 07 81            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A0F0 25               [ 4]    2     ret
                                   1594 
                                   1595 ;---------------------------------
                                   1596 ;  decode form   op r,#imm16 
                                   1597 ;---------------------------------
      00A0F1 61 25 73 09 25 65 00  1598 fmt_r_imm16: .asciz "%a%s\t%s,#%w" 
             2C 23 25 77 00
                           000001  1599     SPC=1
                           000002  1600     MNEMO=2
                           000004  1601     DEST=4
                           000006  1602     IMM16=6
      00A0F8                       1603 _fn_entry 7 fn_r_imm16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001409                          3 fn_r_imm16:
      00A0F8 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A0FA CD A8 BF         [ 4] 1604     call get_int16
      00A0FD 6B 06            [ 2] 1605     ldw (IMM16,sp),y 
      00A0FF 90 5F            [ 2] 1606     ldw y,(STRUCT,sp)
      00A101 17 04 16         [ 4] 1607     call ld_mnemonic 
      00A104 09 90 E6         [ 1] 1608     ld a,(FIELD_DEST,y)
      00A107 01 A1 0F 26      [ 2] 1609     ldw y,#reg_index 
      00A10B 12 7B 06         [ 4] 1610     call ld_table_entry
      00A10E CD A9            [ 2] 1611     ldw (DEST,sp),y 
      00A110 27 90 CE 00      [ 2] 1612     ldw y,#fmt_r_imm16
      00A114 AB 17 04         [ 4] 1613     call format 
      001428                       1614 _fn_exit
      00A117 C6 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A119 AD               [ 4]    2     ret
                                   1615 
                                   1616 
                                   1617 ;---------------------------------
                                   1618 ;  form  op adr16,#imm8 
                                   1619 ;---------------------------------
      00A11A 6B 06 16 09 09 25 77  1620 fmt_op_adr16_imm8: .asciz "%a%s\t%w,#%b"
             2C 23 25 62 00
                           000001  1621     SPC=1
                           000002  1622     MNEMO=2
                           000004  1623     ADR16=4
                           000006  1624     IMM8=6
      00A11E                       1625 _fn_entry 6 fn_adr16_imm8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001437                          3 fn_adr16_imm8:
      00A11E CD A9            [ 2]    4     sub sp,#LOCAL_SIZE
      00A120 6A 90 AE         [ 4] 1626     call get_int8 
      00A123 A0 F0            [ 1] 1627     ld (IMM8,sp),a 
      00A125 CD 8E 7E         [ 4] 1628     call get_int16 
      00A128 5B 06            [ 2] 1629     ldw (ADR16,sp),y 
      00A12A 81 25            [ 2] 1630     ldw Y,(STRUCT,sp)
      00A12C 61 25 73         [ 4] 1631     call ld_mnemonic 
      00A12F 09 25 77 00      [ 2] 1632     ldw y,#fmt_op_adr16_imm8 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



      00A133 CD 00 00         [ 4] 1633     call format 
      00144F                       1634 _fn_exit 
      00A133 52 05            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A135 CD               [ 4]    2     ret
                                   1635 
                                   1636 ;---------------------------------
                                   1637 ;  form  op adr16,adr16 
                                   1638 ;---------------------------------
      00A136 A8 E0 17 04 16 08 CD  1639 fmt_op_adr16_adr16: .asciz "%a%s\t%w,%w"
             A9 6A 90 AE
                           000001  1640     SPC=1
                           000002  1641     MNEMO=2 
                           000004  1642     DEST16=4
                           000006  1643     SRC16=6
      00145D                       1644 _fn_entry 7 fn_adr16_adr16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00145D                          3 fn_adr16_adr16:
      00A141 A1 2B            [ 2]    4     sub sp,#LOCAL_SIZE
      00A143 CD 8E 7E         [ 4] 1645     call get_int16 
      00A146 5B 05            [ 2] 1646     ldw (SRC16,sp),y
      00A148 81 25 61         [ 4] 1647     call get_int16 
      00A14B 25 73            [ 2] 1648     ldw (DEST16,sp),y 
      00A14D 09 25            [ 2] 1649     ldw Y,(STRUCT,sp)
      00A14F 65 00 E4         [ 4] 1650     call ld_mnemonic 
      00A151 90 AE 14 52      [ 2] 1651     ldw y,#fmt_op_adr16_adr16 
      00A151 52 06 CD         [ 4] 1652     call format 
      001475                       1653 _fn_exit 
      00A154 A8 FF            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A156 17               [ 4]    2     ret
                                   1654 
                                   1655 ;---------------------------------
                                   1656 ;  form  op adr8,adr8  
                                   1657 ;---------------------------------
      00A157 04 6B 06 16 09 CD A9  1658 fmt_op_adr8_adr8: .asciz "%a%s\t%b,%b"
             6A 90 AE A1
                           000001  1659     SPC=1
                           000002  1660     MNEMO=2
                           000004  1661     DEST8=4
                           000005  1662     SRC8=5
      001483                       1663 _fn_entry 5 fn_adr8_adr8
                           000005     1     LOCAL_SIZE = 5
                           000008     2     STRUCT=3+LOCAL_SIZE
      001483                          3 fn_adr8_adr8:
      00A162 49 CD            [ 2]    4     sub sp,#LOCAL_SIZE
      00A164 8E 7E 5B         [ 4] 1664     call get_int8 
      00A167 06 81            [ 1] 1665     ld (SRC8,sp),a 
      00A169 25 61 25         [ 4] 1666     call get_int8 
      00A16C 73 09            [ 1] 1667     ld (DEST8,sp),a 
      00A16E 25 62            [ 2] 1668     ldw Y,(STRUCT,sp)
      00A170 2C 25 73         [ 4] 1669     call ld_mnemonic 
      00A173 00 AE 14 78      [ 2] 1670     ldw y,#fmt_op_adr8_adr8 
      00A174 CD 00 00         [ 4] 1671     call format 
      00149B                       1672 _fn_exit 
      00A174 52 06            [ 2]    1     addw sp,#LOCAL_SIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



      00A176 CD               [ 4]    2     ret
                                   1673 
                                   1674 ;---------------------------------
                                   1675 ;   form op r,[ptr8]
                                   1676 ;---------------------------------
      00A177 A8 BF 6B 04 16 09 CD  1677 fmt_op_r_ptr8: .asciz "%a%s\t%s,[%b]"
             A9 6A 90 E6 04 90
                           000001  1678     SPC=1
                           000002  1679     MNEMO=2
                           000004  1680     REG=4
                           000006  1681     PTR8=6
      0014AB                       1682 _fn_entry 6 fn_r_ptr8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0014AB                          3 fn_r_ptr8:
      00A184 AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A186 42 CD A9         [ 4] 1683     call get_int8 
      00A189 57 17            [ 1] 1684     ld (PTR8,sp),a 
      00A18B 05 90            [ 2] 1685     ldw y,(STRUCT,sp)
      00A18D AE A1 69         [ 4] 1686     call ld_mnemonic
      00A190 CD 8E 7E         [ 1] 1687     ld a,(FIELD_DEST,y)
      00A193 5B 06 81 25      [ 2] 1688     ldw y,#reg_index 
      00A197 61 25 73         [ 4] 1689     call ld_table_entry
      00A19A 09 25            [ 2] 1690     ldw (REG,sp),y 
      00A19C 77 2C 25 73      [ 2] 1691     ldw y,#fmt_op_r_ptr8 
      00A1A0 00 00 00         [ 4] 1692     call format 
      00A1A1                       1693 _fn_exit 
      00A1A1 52 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A1A3 CD               [ 4]    2     ret
                                   1694 
                                   1695 
                                   1696 ;---------------------------------
                                   1697 ;   form op r,[ptr16]
                                   1698 ;---------------------------------
      00A1A4 A8 E0 17 04 16 0A CD  1699 fmt_op_r_ptr16: .asciz "%a%s\t%s,[%w]"
             A9 6A 90 E6 04 90
                           000001  1700     SPC=1
                           000002  1701     MNEMO=2
                           000004  1702     REG=4
                           000006  1703     PTR16=6
      0014DA                       1704 _fn_entry 7 fn_r_ptr16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      0014DA                          3 fn_r_ptr16:
      00A1B1 AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A1B3 42 CD A9         [ 4] 1705     call get_int16 
      00A1B6 57 17            [ 2] 1706     ldw (PTR16,sp),y 
      00A1B8 06 90            [ 2] 1707     ldw y,(STRUCT,sp)
      00A1BA AE A1 96         [ 4] 1708     call ld_mnemonic
      00A1BD CD 8E 7E         [ 1] 1709     ld a,(FIELD_DEST,y)
      00A1C0 5B 07 81 25      [ 2] 1710     ldw y,#reg_index
      00A1C4 61 25 73         [ 4] 1711     call ld_table_entry
      00A1C7 09 25            [ 2] 1712     ldw (REG,sp),y 
      00A1C9 65 2C 25 73      [ 2] 1713     ldw y,#fmt_op_r_ptr16 
      00A1CD 00 00 00         [ 4] 1714     call format 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



      00A1CE                       1715 _fn_exit 
      00A1CE 52 08            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A1D0 CD               [ 4]    2     ret
                                   1716 
                                   1717 ;---------------------------------
                                   1718 ;   form op [ptr8],r
                                   1719 ;---------------------------------
      00A1D1 A8 FF 17 04 6B 06 16  1720 fmt_op_ptr8_r: .asciz "%a%s\t[%b],%s"
             0B CD A9 6A 90 E6
                           000001  1721     SPC=1
                           000002  1722     MNEMO=2
                           000004  1723     PTR8=4
                           000005  1724     SRC=5
      001509                       1725 _fn_entry 6 fn_ptr8_r
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001509                          3 fn_ptr8_r:
      00A1DE 04 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A1E0 AE 93 42         [ 4] 1726     call get_int8 
      00A1E3 CD A9            [ 1] 1727     ld (PTR8,sp),a 
      00A1E5 57 17            [ 2] 1728     ldw y,(STRUCT,sp)
      00A1E7 07 90 AE         [ 4] 1729     call ld_mnemonic
      00A1EA A1 C3 CD         [ 1] 1730     ld a,(FIELD_SRC,y)
      00A1ED 8E 7E 5B 08      [ 2] 1731     ldw y,#reg_index 
      00A1F1 81 25 61         [ 4] 1732     call ld_table_entry
      00A1F4 25 73            [ 2] 1733     ldw (SRC,sp),y 
      00A1F6 09 25 73 2C      [ 2] 1734     ldw y,#fmt_op_ptr8_r 
      00A1FA 25 62 00         [ 4] 1735     call format 
      00A1FD                       1736 _fn_exit 
      00A1FD 52 06            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A1FF CD               [ 4]    2     ret
                                   1737 
                                   1738 
                                   1739 ;---------------------------------
                                   1740 ;   form op [ptr16],r
                                   1741 ;---------------------------------
      00A200 A8 BF 6B 06 16 09 CD  1742 fmt_op_ptr16_r: .asciz "%a%s\t[%w],%s"
             A9 6A 90 E6 03 90
                           000001  1743     SPC=1
                           000002  1744     MNEMO=2
                           000004  1745     PTR16=4
                           000006  1746     REG=6
      001538                       1747 _fn_entry 7 fn_ptr16_r
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001538                          3 fn_ptr16_r:
      00A20D AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A20F 42 CD A9         [ 4] 1748     call get_int16 
      00A212 57 17            [ 2] 1749     ldw (PTR16,sp),y 
      00A214 04 90            [ 2] 1750     ldw y,(STRUCT,sp)
      00A216 AE A1 F2         [ 4] 1751     call ld_mnemonic
      00A219 CD 8E 7E         [ 1] 1752     ld a,(FIELD_SRC,y)
      00A21C 5B 06 81 25      [ 2] 1753     ldw y,#reg_index
      00A220 61 25 73         [ 4] 1754     call ld_table_entry
      00A223 09 25            [ 2] 1755     ldw (REG,sp),y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



      00A225 73 2C 25 77      [ 2] 1756     ldw y,#fmt_op_ptr16_r 
      00A229 00 00 00         [ 4] 1757     call format 
      00A22A                       1758 _fn_exit 
      00A22A 52 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A22C CD               [ 4]    2     ret
                                   1759 
                                   1760 ;---------------------------------
                                   1761 ;   form op r,([ptr8],r)
                                   1762 ;---------------------------------
      00A22D A8 E0 17 06 16 0A CD  1763 fmt_op_r_ptr8_idx: .asciz "%a%s\t%s,([%b],%s)"
             A9 6A 90 E6 03 90 AE
             93 42 CD A9
                           000001  1764     SPC=1
                           000002  1765     MNEMO=2
                           000004  1766     DEST=4
                           000006  1767     PTR8=6
                           000007  1768     SRC=7
      00156C                       1769 _fn_entry 8 fn_r_ptr8_idx  
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      00156C                          3 fn_r_ptr8_idx:
      00A23F 57 17            [ 2]    4     sub sp,#LOCAL_SIZE
      00A241 04 90 AE         [ 4] 1770     call get_int8 
      00A244 A2 1F            [ 1] 1771     ld (PTR8,sp),a 
      00A246 CD 8E            [ 2] 1772     ldw y,(STRUCT,sp)
      00A248 7E 5B 07         [ 4] 1773     call ld_mnemonic
      00A24B 81 25 61         [ 1] 1774     ld a,(FIELD_DEST,y)
      00A24E 25 73 09 25      [ 2] 1775     ldw y,#reg_index 
      00A252 73 2C 25         [ 4] 1776     call ld_table_entry
      00A255 65 00            [ 2] 1777     ldw (DEST,sp),y 
      00A257 16 0B            [ 2] 1778     ldw y,(STRUCT,sp)
      00A257 52 08 CD         [ 1] 1779     ld a,(FIELD_SRC,y)
      00A25A A8 FF 17 06      [ 2] 1780     ldw y,#reg_index 
      00A25E 6B 08 16         [ 4] 1781     call ld_table_entry
      00A261 0B CD            [ 2] 1782     ldw (SRC,sp),y 
      00A263 A9 6A 90 E6      [ 2] 1783     ldw y,#fmt_op_r_ptr8_idx  
      00A267 03 90 AE         [ 4] 1784     call format 
      001599                       1785 _fn_exit 
      00A26A 93 42            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A26C CD               [ 4]    2     ret
                                   1786 
                                   1787 ;---------------------------------
                                   1788 ;   form op r,([ptr16],r)
                                   1789 ;---------------------------------
      00A26D A9 57 17 04 90 AE A2  1790 fmt_op_r_ptr16_idx: .asciz "%a%s\t%s,([%w],%s)"
             4C CD 8E 7E 5B 08 81
             25 61 25 73
                           000001  1791     SPC=1
                           000002  1792     MNEMO=2
                           000004  1793     DEST=4
                           000006  1794     PTR16=6
                           000008  1795     SRC=8
      0015AE                       1796 _fn_entry 9 fn_r_ptr16_idx 
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 37.
Hexadecimal [24-Bits]



      0015AE                          3 fn_r_ptr16_idx:
      00A27F 09 28            [ 2]    4     sub sp,#LOCAL_SIZE
      00A281 25 73 29         [ 4] 1797     call get_int16 
      00A284 00 25            [ 2] 1798     ldw (PTR16,sp),y 
      00A286 61 25            [ 2] 1799     ldw y,(STRUCT,sp)
      00A288 73 09 25         [ 4] 1800     call ld_mnemonic
      00A28B 73 2C 28         [ 1] 1801     ld a,(FIELD_DEST,y)
      00A28E 25 73 29 00      [ 2] 1802     ldw y,#reg_index
      00A292 A2 7B A2         [ 4] 1803     call ld_table_entry
      00A295 85 04            [ 2] 1804     ldw (DEST,sp),y
      00A296 16 0C            [ 2] 1805     ldw y,(STRUCT,sp) 
      00A296 52 08 0F         [ 1] 1806     ld a,(FIELD_SRC,y)
      00A299 08 16 0B CD      [ 2] 1807     ldw y,#reg_index
      00A29D A9 6A 90         [ 4] 1808     call ld_table_entry
      00A2A0 E6 03            [ 2] 1809     ldw (SRC,sp),y 
      00A2A2 90 AE 93 42      [ 2] 1810     ldw y,#fmt_op_r_ptr16_idx  
      00A2A6 CD A9 57         [ 4] 1811     call format 
      0015DB                       1812 _fn_exit 
      00A2A9 17 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A2AB 16               [ 4]    2     ret
                                   1813 
                                   1814 ;---------------------------------
                                   1815 ;   form op ([ptr8],r),r
                                   1816 ;---------------------------------
      00A2AC 0B 90 E6 04 27 02 0C  1817 fmt_op_ptr8_idx_r: .asciz "%a%s\t([%b],%s),%s"
             08 90 AE 93 42 CD A9
             57 17 06 7B
                           000001  1818     SPC=1
                           000002  1819     MNEMO=2
                           000004  1820     PTR8=4
                           000005  1821     DEST=5
                           000007  1822     SRC=7
      0015F0                       1823 _fn_entry 8 fn_ptr8_idx_r
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      0015F0                          3 fn_ptr8_idx_r:
      00A2BE 08 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A2C0 AE A2 92         [ 4] 1824     call get_int8 
      00A2C3 CD A9            [ 1] 1825     ld (PTR8,sp),a 
      00A2C5 57 CD            [ 2] 1826     ldw y,(STRUCT,sp)
      00A2C7 8E 7E 5B         [ 4] 1827     call ld_mnemonic
      00A2CA 08 81 25         [ 1] 1828     ld a,(FIELD_DEST,y)
      00A2CD 61 25 73 09      [ 2] 1829     ldw y,#reg_index 
      00A2D1 28 25 73         [ 4] 1830     call ld_table_entry
      00A2D4 29 2C            [ 2] 1831     ldw (DEST,sp),y 
      00A2D6 25 73            [ 2] 1832     ldw y,(STRUCT,sp)
      00A2D8 00 E6 04         [ 1] 1833     ld a,(FIELD_SRC,y)
      00A2D9 90 AE 02 BC      [ 2] 1834     ldw y,#reg_index 
      00A2D9 52 07 16         [ 4] 1835     call ld_table_entry
      00A2DC 0A CD            [ 2] 1836     ldw (SRC,sp),y 
      00A2DE A9 6A 90 E6      [ 2] 1837     ldw y,#fmt_op_ptr8_idx_r 
      00A2E2 03 90 AE         [ 4] 1838     call format 
      00161D                       1839 _fn_exit 
      00A2E5 93 42            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A2E7 CD               [ 4]    2     ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



                                   1840 
                                   1841 ;---------------------------------
                                   1842 ;   form op ([ptr16],r),r
                                   1843 ;---------------------------------
      00A2E8 A9 57 17 04 16 0A 90  1844 fmt_op_ptr16_idx_r: .asciz "%a%s\t([%w],%s),%s"
             E6 04 90 AE 93 42 CD
             A9 57 17 06
                           000001  1845     SPC=1
                           000002  1846     MNEMO=2
                           000004  1847     PTR16=4
                           000006  1848     DEST=6
                           000008  1849     SRC=8
      001632                       1850 _fn_entry 9 fn_ptr16_idx_r 
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      001632                          3 fn_ptr16_idx_r:
      00A2FA 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      00A2FC A2 CC CD         [ 4] 1851     call get_int16
      00A2FF 8E 7E            [ 2] 1852     ldw (PTR16,sp),y
      00A301 5B 07            [ 2] 1853     ldw y,(STRUCT,sp)
      00A303 81 25 61         [ 4] 1854     call ld_mnemonic
      00A306 25 73 09         [ 1] 1855     ld a,(FIELD_DEST,y)
      00A309 28 25 62 2C      [ 2] 1856     ldw y,#reg_index 
      00A30D 25 73 29         [ 4] 1857     call ld_table_entry
      00A310 00 06            [ 2] 1858     ldw (DEST,sp),y 
      00A311 16 0C            [ 2] 1859     ldw y,(STRUCT,sp)
      00A311 52 06 CD         [ 1] 1860     ld a,(FIELD_SRC,y)
      00A314 A8 BF 6B 04      [ 2] 1861     ldw y,#reg_index 
      00A318 16 09 CD         [ 4] 1862     call ld_table_entry
      00A31B A9 6A            [ 2] 1863     ldw (SRC,sp),y 
      00A31D 90 E6 03 90      [ 2] 1864     ldw y,#fmt_op_ptr16_idx_r 
      00A321 AE 93 42         [ 4] 1865     call format 
      00165F                       1866 _fn_exit 
      00A324 CD A9            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A326 57               [ 4]    2     ret
                                   1867 
                                   1868 ;---------------------------------
                                   1869 ;   form op (ofs16,r)
                                   1870 ;---------------------------------
      00A327 17 05 90 AE A3 04 CD  1871 fmt_op_ofs16_idx: .asciz "%a%s\t(%w,%s)"
             8E 7E 5B 06 81 25
                           000001  1872     SPC=1
                           000002  1873     MNEMO=2
                           000004  1874     OFS16=4
                           000006  1875     SRC=6
      00166F                       1876 _fn_entry 7 fn_ofs16_idx 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00166F                          3 fn_ofs16_idx:
      00A334 61 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A336 73 09 25         [ 4] 1877     call get_int16  
      00A339 77 2C            [ 2] 1878     ldw (OFS16,sp),y 
      00A33B 23 25            [ 2] 1879     ldw y,(STRUCT,sp)
      00A33D 63 2C 25         [ 4] 1880     call ld_mnemonic
      00A340 65 00 04         [ 1] 1881     ld a,(FIELD_SRC,y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



      00A342 90 AE 02 BC      [ 2] 1882     ldw y,#reg_index 
      00A342 52 09 6B         [ 4] 1883     call ld_table_entry
      00A345 06 CD            [ 2] 1884     ldw (SRC,sp),y 
      00A347 A8 E0 17 04      [ 2] 1885     ldw y,#fmt_op_ofs16_idx 
      00A34B CD A8 BF         [ 4] 1886     call format 
      00168E                       1887 _fn_exit 
      00A34E CD A9            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A350 27               [ 4]    2     ret
                                   1888 
                                   1889 
                                   1890 ;---------------------------------
                                   1891 ; form op r,(ofs16,r)
                                   1892 ;---------------------------------
      00A351 90 CE 00 AB C6 00 AD  1893 fmt_op_r_ofs16_idx: .asciz "%a%s\t%s,(%w,%s)"
             17 07 6B 09 A6 04 6B
             01 7B
                           000001  1894     SPC=1
                           000002  1895     MNEMO=2
                           000004  1896     DEST=4
                           000006  1897     OFS16=6 
                           000008  1898     SRC=8
      0016A1                       1899 _fn_entry 9 fn_r_ofs16_idx
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      0016A1                          3 fn_r_ofs16_idx:
      00A361 06 A4            [ 2]    4     sub sp,#LOCAL_SIZE
      00A363 01 27 06         [ 4] 1900     call get_int16 
      00A366 90 AE            [ 2] 1901     ldw (OFS16,sp),y 
      00A368 91 8B            [ 2] 1902     ldw y,(STRUCT,sp)
      00A36A 20 04 90         [ 4] 1903     call ld_mnemonic
      00A36D AE 91 90         [ 1] 1904     ld a,(FIELD_DEST,y)
      00A370 17 02 7B 06      [ 2] 1905     ldw y,#reg_index
      00A374 44 A4 07         [ 4] 1906     call ld_table_entry
      00A377 AB 30            [ 2] 1907     ldw (DEST,sp),y 
      00A379 6B 06            [ 2] 1908     ldw y,(STRUCT,sp)
      00A37B 90 AE A3         [ 1] 1909     ld a,(FIELD_SRC,y)
      00A37E 33 CD 8E 7E      [ 2] 1910     ldw y,#reg_index 
      00A382 5B 09 81         [ 4] 1911     call ld_table_entry
      00A385 91 86            [ 2] 1912     ldw (SRC,sp),y 
      00A387 91 81 91 76      [ 2] 1913     ldw y,#fmt_op_r_ofs16_idx
      00A38B 91 6D 25         [ 4] 1914     call format 
      0016CE                       1915 _fn_exit 
      00A38E 61 25            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A390 73               [ 4]    2     ret
                                   1916 
                                   1917 ;---------------------------------
                                   1918 ;  form op (ofs16,r),r 
                                   1919 ;---------------------------------
      00A391 09 25 77 2C 23 25 63  1920 fmt_op_ofs16_idx_r: .asciz "%a%s\t(%w,%s),%s"
             00 2C 25 73 29 2C 25
             73 00
                           000001  1921     SPC=1
                           000002  1922     MNEMO=2
                           000004  1923     OFS16=4
                           000006  1924     DEST=6
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                           000008  1925     SRC=8
      00A399                       1926 _fn_entry 9 fn_ofs16_idx_r
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      0016E1                          3 fn_ofs16_idx_r:
      00A399 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A39B 6B 06 A6         [ 4] 1927     call get_int16 
      00A39E 08 6B            [ 2] 1928     ldw (OFS16,sp),y 
      00A3A0 01 CD            [ 2] 1929     ldw y,(STRUCT,sp)
      00A3A2 A8 E0 17         [ 4] 1930     call ld_mnemonic
      00A3A5 04 90 AE         [ 1] 1931     ld a,(FIELD_DEST,y)
      00A3A8 A3 85 7B 06      [ 2] 1932     ldw y,#reg_index 
      00A3AC A4 01 27         [ 4] 1933     call ld_table_entry
      00A3AF 04 72            [ 2] 1934     ldw (DEST,sp),y 
      00A3B1 A9 00            [ 2] 1935     ldw y,(STRUCT,sp)
      00A3B3 02 7B 06         [ 1] 1936     ld a,(FIELD_SRC,y)
      00A3B6 A4 F0 27 04      [ 2] 1937     ldw y,#reg_index 
      00A3BA 72 A9 00         [ 4] 1938     call ld_table_entry
      00A3BD 04 90            [ 2] 1939     ldw (SRC,sp),y 
      00A3BF FE 17 02 7B      [ 2] 1940     ldw y,#fmt_op_ofs16_idx_r 
      00A3C3 06 44 A4         [ 4] 1941     call format 
      00170E                       1942 _fn_exit 
      00A3C6 07 AB            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A3C8 30               [ 4]    2     ret
                                   1943 
                                   1944 ;---------------------------------
                                   1945 ;  op r,(ofs24,r)
                                   1946 ;---------------------------------
      00A3C9 6B 06 90 AE A3 8D CD  1947 fmt_op_r_ofs24_idx: .asciz "%a%s\t%s,(%e,%s)" 
             8E 7E 5B 06 81 25 61
             25 73
                           000001  1948     SPC=1
                           000002  1949     MNEMO=2
                           000004  1950     DEST=4
                           000006  1951     OFS24=6
                           000009  1952     SRC=9
      001721                       1953 _fn_entry 10 fn_r_ofs24_idx 
                           00000A     1     LOCAL_SIZE = 10
                           00000D     2     STRUCT=3+LOCAL_SIZE
      001721                          3 fn_r_ofs24_idx:
      00A3D9 09 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A3DB 73 2C 28         [ 4] 1954     call get_int24 
      00A3DE 25 62            [ 2] 1955     ldw (OFS24,sp),y 
      00A3E0 2C 25            [ 1] 1956     ld (OFS24+2,sp),a 
      00A3E2 73 29            [ 2] 1957     ldw y,(STRUCT,sp)
      00A3E4 00 18 E4         [ 4] 1958     call ld_mnemonic
      00A3E5 90 E6 03         [ 1] 1959     ld a,(FIELD_DEST,y)
      00A3E5 52 08 CD A8      [ 2] 1960     ldw y,#reg_index 
      00A3E9 BF 6B 06         [ 4] 1961     call ld_table_entry
      00A3EC 16 0B            [ 2] 1962     ldw (DEST,sp),y 
      00A3EE CD A9            [ 2] 1963     ldw y,(STRUCT,sp)
      00A3F0 6A 90 E6         [ 1] 1964     ld a,(FIELD_SRC,y)
      00A3F3 03 90 AE 93      [ 2] 1965     ldw y,#reg_index 
      00A3F7 42 CD A9         [ 4] 1966     call ld_table_entry
      00A3FA 57 17            [ 2] 1967     ldw (SRC,sp),y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



      00A3FC 04 16 0B 90      [ 2] 1968     ldw y,#fmt_op_r_ofs24_idx
      00A400 E6 04 90         [ 4] 1969     call format 
      001750                       1970 _fn_exit 
      00A403 AE 93            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A405 42               [ 4]    2     ret
                                   1971 
                                   1972 ;---------------------------------
                                   1973 ; op (ofs24,r),r 
                                   1974 ;---------------------------------
      00A406 CD A9 57 17 07 90 AE  1975 fmt_ofs24_idx_r: .asciz "%a%s\t(%e,%s),%s"
             A3 D5 CD 8E 7E 5B 08
             81 25
                           000001  1976     SPC=1
                           000002  1977     MNEMO=2
                           000004  1978     OFS24=4
                           000007  1979     DEST=7
                           000009  1980     SRC=9
      001763                       1981 _fn_entry 10 fn_ofs24_idx_r 
                           00000A     1     LOCAL_SIZE = 10
                           00000D     2     STRUCT=3+LOCAL_SIZE
      001763                          3 fn_ofs24_idx_r:
      00A416 61 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A418 73 09 28         [ 4] 1982     call get_int24 
      00A41B 25 62            [ 2] 1983     ldw (OFS24,sp),y
      00A41D 2C 25            [ 1] 1984     ld (OFS24+2,sp),a
      00A41F 73 29            [ 2] 1985     ldw y,(STRUCT,sp)
      00A421 2C 25 73         [ 4] 1986     call ld_mnemonic
      00A424 00 E6 03         [ 1] 1987     ld a,(FIELD_DEST,y)
      00A425 90 AE 02 BC      [ 2] 1988     ldw y,#reg_index 
      00A425 52 08 CD         [ 4] 1989     call ld_table_entry
      00A428 A8 BF            [ 2] 1990     ldw (DEST,sp),y 
      00A42A 6B 04            [ 2] 1991     ldw y,(STRUCT,sp)
      00A42C 16 0B CD         [ 1] 1992     ld a,(FIELD_SRC,y)
      00A42F A9 6A 90 E6      [ 2] 1993     ldw y,#reg_index 
      00A433 03 90 AE         [ 4] 1994     call ld_table_entry
      00A436 93 42            [ 2] 1995     ldw (SRC,sp),y
      00A438 CD A9 57 17      [ 2] 1996     ldw y,#fmt_ofs24_idx_r 
      00A43C 05 16 0B         [ 4] 1997     call format 
      001792                       1998 _fn_exit 
      00A43F 90 E6            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A441 04               [ 4]    2     ret
                                   1999 
                                   2000 ;---------------------------------
                                   2001 ; form op [adr16]
                                   2002 ;---------------------------------
      00A442 90 AE 93 42 CD A9 57  2003 fmt_op_ptr8: .asciz "%a%s\t%[%b]"
             17 07 90 AE
                           000001  2004     SPC=1
                           000002  2005     MNEMO=2
                           000004  2006     ADR8=4
      0017A0                       2007 _fn_entry 4 fn_ptr8 
                           000004     1     LOCAL_SIZE = 4
                           000007     2     STRUCT=3+LOCAL_SIZE
      0017A0                          3 fn_ptr8:
      00A44D A4 15            [ 2]    4     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      00A44F CD 8E 7E         [ 4] 2008     call get_int8
      00A452 5B 08            [ 1] 2009     ld (ADR8,sp),a 
      00A454 81 25            [ 2] 2010     ldw y,(STRUCT,sp)
      00A456 61 25 73         [ 4] 2011     call ld_mnemonic
      00A459 09 25 73 2C      [ 2] 2012     ldw y,#fmt_op_ptr8 
      00A45D 23 25 62         [ 4] 2013     call format 
      0017B3                       2014 _fn_exit 
      00A460 00 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A461 81               [ 4]    2     ret
                                   2015 
                                   2016 ;---------------------------------
                                   2017 ; form op [adr16]
                                   2018 ;---------------------------------
      00A461 52 06 CD A8 BF 6B 06  2019 fmt_op_ptr16: .asciz "%a%s\t%[%w]"
             16 09 CD A9
                           000001  2020     SPC=1
                           000002  2021     MNEMO=2
                           000004  2022     ADR16=4
      0017C1                       2023 _fn_entry 5 fn_ptr16 
                           000005     1     LOCAL_SIZE = 5
                           000008     2     STRUCT=3+LOCAL_SIZE
      0017C1                          3 fn_ptr16:
      00A46C 6A 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A46E E6 03 90         [ 4] 2024     call get_int16 
      00A471 AE 93            [ 2] 2025     ldw (ADR16,sp),y 
      00A473 42 CD            [ 2] 2026     ldw y,(STRUCT,sp)
      00A475 A9 57 17         [ 4] 2027     call ld_mnemonic
      00A478 04 90 AE A4      [ 2] 2028     ldw y,#fmt_op_ptr16 
      00A47C 55 CD 8E         [ 4] 2029     call format 
      0017D4                       2030 _fn_exit 
      00A47F 7E 5B            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A481 06               [ 4]    2     ret
                                   2031 
                                   2032 ;---------------------------------
                                   2033 ; form op ([ptr8],r) 
                                   2034 ;---------------------------------
      00A482 81 25 61 25 73 09 25  2035 fmt_op_ptr8_idx: .asciz "%a%s\t([%b],%s)"
             73 2C 23 25 77 00 29
             00
                           000001  2036     SPC=1
                           000002  2037     MNEMO=2
                           000004  2038     ADR8=4
                           000005  2039     DEST=5
      00A48F                       2040 _fn_entry 6 fn_ptr8_idx 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0017E6                          3 fn_ptr8_idx:
      00A48F 52 07            [ 2]    4     sub sp,#LOCAL_SIZE
      00A491 CD A8 E0         [ 4] 2041     call get_int8 
      00A494 17 06            [ 1] 2042     ld (ADR8,sp),a 
      00A496 16 0A            [ 2] 2043     ldw y,(STRUCT,sp)
      00A498 CD A9 6A         [ 4] 2044     call ld_mnemonic
      00A49B 90 E6 03         [ 1] 2045     ld a,(FIELD_DEST,y)
      00A49E 90 AE 93 42      [ 2] 2046     ldw y,#reg_index 
      00A4A2 CD A9 57         [ 4] 2047     call ld_table_entry
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      00A4A5 17 04            [ 2] 2048     ldw (DEST,sp),y 
      00A4A7 90 AE A4 83      [ 2] 2049     ldw y,#fmt_op_ptr8_idx
      00A4AB CD 8E 7E         [ 4] 2050     call format 
      001805                       2051 _fn_exit 
      00A4AE 5B 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A4B0 81               [ 4]    2     ret
                                   2052 
                                   2053 ;---------------------------------
                                   2054 ; form op ([ptr16],r) 
                                   2055 ;---------------------------------
      00A4B1 25 61 25 73 09 25 77  2056 fmt_op_ptr16_idx: .asciz "%a%s\t([%w],%s)"
             2C 23 25 62 00 73 29
             00
                           000001  2057     SPC=1
                           000002  2058     MNEMO=2
                           000004  2059     ADR16=4
                           000006  2060     DEST=6
      00A4BD                       2061 _fn_entry 7 fn_ptr16_idx 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001817                          3 fn_ptr16_idx:
      00A4BD 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A4BF CD A8 BF         [ 4] 2062     call get_int16 
      00A4C2 6B 06            [ 2] 2063     ldw (ADR16,sp),y 
      00A4C4 CD A8            [ 2] 2064     ldw y,(STRUCT,sp)
      00A4C6 E0 17 04         [ 4] 2065     call ld_mnemonic
      00A4C9 16 09 CD         [ 1] 2066     ld a,(FIELD_DEST,y)
      00A4CC A9 6A 90 AE      [ 2] 2067     ldw y,#reg_index 
      00A4D0 A4 B1 CD         [ 4] 2068     call ld_table_entry
      00A4D3 8E 7E            [ 2] 2069     ldw (DEST,sp),y 
      00A4D5 5B 06 81 25      [ 2] 2070     ldw y,#fmt_op_ptr16_idx
      00A4D9 61 25 73         [ 4] 2071     call format 
      001836                       2072 _fn_exit 
      00A4DC 09 25            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A4DE 77               [ 4]    2     ret
                                   2073 
                                   2074 
                                   2075 ;---------------------------------
                                   2076 ; get_int8 
                                   2077 ; read 1 byte from code 
                                   2078 ; print byte in hexadecimal
                                   2079 ; input:
                                   2080 ;   farptr  pointer to code 
                                   2081 ;   X       index for farptr 
                                   2082 ; output:
                                   2083 ;   A       byte read 
                                   2084 ;   acc24   A sign extended to 24 bits 
                                   2085 ;   X       incremented by 1
                                   2086 ;---------------------------------
      001839                       2087 get_int8:
      00A4DF 2C 25 77         [ 4] 2088     call peek
      00A4E2 00               [ 1] 2089     push a 
      00A4E3 CD 00 00         [ 4] 2090     call print_byte 
      00A4E3 52               [ 1] 2091     pop a 
      00A4E4 07 CD A8         [ 1] 2092     ld acc8,a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



      00A4E7 E0 17 06 CD      [ 1] 2093     clr acc16
      00A4EB A8 E0 17 04      [ 1] 2094     clr acc24
      00A4EF 16 0A CD A9 6A   [ 2] 2095     btjf acc8,#7,1$
      00A4F4 90 AE A4 D8      [ 1] 2096     cpl acc16 
      00A4F8 CD 8E 7E 5B      [ 1] 2097     cpl acc24 
      001859                       2098 1$:          
      00A4FC 07               [ 4] 2099     ret
                                   2100 
                                   2101 ;---------------------------------
                                   2102 ; get_int16 
                                   2103 ; read two bytes as 16 bits integer 
                                   2104 ; form code space  
                                   2105 ; print bytes separately
                                   2106 ; input:
                                   2107 ;   farptr      pointer to code 
                                   2108 ;   X           index for farptr 
                                   2109 ; output:
                                   2110 ;   Y           16 bits integer 
                                   2111 ;   acc24       Y zero extended    
                                   2112 ;   X           incremented by 2
                                   2113 ;--------------------------------
                           000001  2114     ADDR16 = 1
                           000002  2115     LOCAL_SIZE = 2
      00185A                       2116 get_int16:
      00A4FD 81 25            [ 2] 2117     sub sp,#LOCAL_SIZE
      00A4FF 61 25 73         [ 4] 2118     call peek 
      00A502 09 25            [ 1] 2119     ld (ADDR16,sp),a 
      00A504 62 2C 25         [ 4] 2120     call print_byte 
      00A507 62 00 00         [ 4] 2121     call peek 
      00A509 6B 02            [ 1] 2122     ld (ADDR16+1,sp),a 
      00A509 52 05 CD         [ 4] 2123     call print_byte
      00A50C A8 BF            [ 2] 2124     ldw y, (ADDR16,sp)
      00A50E 6B 05 CD A8      [ 2] 2125     ldw acc16,y
      00A512 BF 6B 04 16      [ 1] 2126     clr acc24 
      00A516 08 CD            [ 2] 2127     addw sp,#LOCAL_SIZE 
      00A518 A9               [ 4] 2128     ret 
                                   2129 
                                   2130 ;--------------------------------
                                   2131 ;  get_int24
                                   2132 ;  read 3 bytes as a 24 bits integer 
                                   2133 ;  from code space 
                                   2134 ;  print bytes separately
                                   2135 ; input:
                                   2136 ;   farptr      pointer to code 
                                   2137 ;   X           index for farptr 
                                   2138 ; output:
                                   2139 ;   Y           bits 23:16 of integer
                                   2140 ;   A           bits 7:0  of integer 
                                   2141 ;   acc24       24 bits integer   
                                   2142 ;   X           incremented by 3
                                   2143 ;---------------------------------
                           000001  2144     ADDR24 = 1 
                           000003  2145     LOCAL_SIZE=3
      001879                       2146 get_int24:
      00A519 6A 90            [ 2] 2147     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



      00A51B AE A4 FE         [ 4] 2148     call peek
      00A51E CD 8E            [ 1] 2149     ld (ADDR24,sp),a 
      00A520 7E 5B 05         [ 4] 2150     call print_byte 
      00A523 81 25 61         [ 4] 2151     call peek 
      00A526 25 73            [ 1] 2152     ld (ADDR24+1,sp),a 
      00A528 09 25 73         [ 4] 2153     call print_byte 
      00A52B 2C 5B 25         [ 4] 2154     call peek 
      00A52E 62 5D            [ 1] 2155     ld (ADDR24+2,sp),a 
      00A530 00 00 00         [ 4] 2156     call print_byte 
      00A531 16 01            [ 2] 2157     ldw y,(ADDR24,sp)
      00A531 52 06 CD A8      [ 2] 2158     ldw acc24,y 
      00A535 BF 6B            [ 1] 2159     ld a, (ADDR24+2,sp)
      00A537 06 16 09         [ 1] 2160     ld acc8,a 
      00A53A CD A9            [ 2] 2161     addw sp,#LOCAL_SIZE
      00A53C 6A               [ 4] 2162     ret 
                                   2163 
                                   2164 ;---------------------------------
                                   2165 ; compute absolute address 
                                   2166 ; from relative address 
                                   2167 ; input:
                                   2168 ;   A       rel8 
                                   2169 ;   X       table index, farptr[X]
                                   2170 ;   farptr  location pointer 
                                   2171 ; output:
                                   2172 ;   acc24    absolute address 
                                   2173 ;----------------------------------
      0018A1                       2174 abs_addr:
      00A53D 90               [ 2] 2175     pushw x
      00A53E E6 03 90         [ 1] 2176     ld acc8,a 
      00A541 AE 93 42 CD      [ 1] 2177     clr acc16 
      00A545 A9 57 17 04      [ 1] 2178     clr acc24
      00A549 90 AE A5 24 CD   [ 2] 2179     btjf acc8,#7,1$
      00A54E 8E 7E 5B 06      [ 1] 2180     cpl acc16 
      00A552 81 25 61 25      [ 1] 2181     cpl acc24 
      00A556 73               [ 1] 2182 1$: clr a 
      00A557 09 25 73 2C      [ 2] 2183     addw x,farptr+1 
      00A55B 5B 25 77         [ 1] 2184     adc a,farptr 
      00A55E 5D 00 00 00      [ 2] 2185     addw x,acc16 
      00A560 C9 00 00         [ 1] 2186     adc a,acc24 
      00A560 52 07 CD         [ 1] 2187     ld acc24,a 
      00A563 A8 E0 17         [ 2] 2188     ldw acc16,x
      00A566 06               [ 2] 2189     popw x 
      00A567 16               [ 4] 2190     ret
                                   2191 
                                   2192 ;--------------------------------
                                   2193 ; y = y[2*A]
                                   2194 ; input:
                                   2195 ;   Y     address of .word table 
                                   2196 ;   A     index in table 
                                   2197 ; output:
                                   2198 ;   Y     Y=Y[2*A]
                                   2199 ;--------------------------------
      0018D1                       2200 ld_table_entry:
      00A568 0A CD A9 6A      [ 1] 2201     clr acc16
      00A56C 90               [ 1] 2202     sll a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



      00A56D E6 03 90 AE      [ 1] 2203     rlc acc16
      00A571 93 42 CD         [ 1] 2204     ld acc8,a 
      00A574 A9 57 17 04      [ 2] 2205     addw y,acc16 
      00A578 90 AE            [ 2] 2206     ldw y,(y)
      00A57A A5               [ 4] 2207     ret 
                                   2208     
                                   2209 ;---------------------------------
                                   2210 ; prepare SPC and MNEMO arguments
                                   2211 ; for format sub-routine.
                                   2212 ; This is the same for all fn_* subs.
                                   2213 ; input:
                                   2214 ;   Y       pointer to opcode structure 
                                   2215 ; output:
                                   2216 ;   none 
                                   2217 ;-------------------------------------
                           000005  2218     SPC=5
                           000006  2219     MNEMO=6 
      0018E4                       2220 ld_mnemonic:
                                   2221 ;compute alignment spaces 
      00A57B 53 CD            [ 2] 2222     pushw y
      00A57D 8E               [ 1] 2223     ld a,xl 
      00A57E 7E               [ 1] 2224     sll a 
      00A57F 5B               [ 1] 2225     sll a 
      00A580 07 81 25         [ 1] 2226     ld acc8,a 
      00A583 61 25            [ 1] 2227     ld a,#24
      00A585 73 09 5B         [ 1] 2228     sub a,acc8
      00A588 25 62            [ 1] 2229     ld (SPC,sp),a 
      00A58A 5D 2C 25         [ 1] 2230     ld a,(FIELD_MNEMO,y)
      00A58D 73 00 00 00      [ 1] 2231     clr acc16 
      00A58F 48               [ 1] 2232     sll a 
      00A58F 52 06 CD A8      [ 1] 2233     rlc acc16 
      00A593 BF 6B 04         [ 1] 2234     ld acc8,a
      00A596 16 09 CD A9      [ 2] 2235     ldw y,#mnemo_index  
      00A59A 6A 90 E6 04      [ 2] 2236     addw y,acc16
      00A59E 90 AE            [ 2] 2237     ldw y,(y)
      00A5A0 93 42            [ 2] 2238     ldw (MNEMO,sp),y 
      00A5A2 CD A9            [ 2] 2239     popw y 
      00A5A4 57               [ 4] 2240     ret 
                                   2241 
                                   2242 
                                   2243 
