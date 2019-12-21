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
      009088 44 41 53 4D             37 .ascii "DASM"
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
      009088 00 00                   98     .word fn_implied ; 0 
      00908A 91 5E                   99     .word fn_ofs8_idx ; 1 
      00908C 91 62                  100     .word fn_adr16_bit ; 2 
      00908E 91 66                  101     .word fn_r_ofs8_idx ; 3
      009090 91 6B                  102     .word fn_r_imm8 ; 4
      009092 91 6F                  103     .word fn_r_imm16 ; 5
      009094 91 74                  104     .word fn_r_idx ; 6
      009096 91 78                  105     .word fn_idx_r ; 7 
      009098 91 7D                  106     .word fn_r_adr8 ; 8
      00909A 91 83                  107     .word fn_r_adr16 ; 9
      00909C 91 88                  108     .word fn_imm8 ; 10
      00909E 91 8D                  109     .word fn_adr16 ; 11 
      0090A0 91 92                  110     .word fn_adr24 ; 12 
      0090A2 91 97                  111     .word fn_adr8_r ; 13
      0090A4 91 9C                  112     .word fn_adr16_r ; 14
      0090A6 91 A2                  113     .word fn_adr24_r ; 15 
      0090A8 91 A8                  114     .word fn_r_adr24 ; 16 
      0090AA 91 AC                  115     .word fn_adr16_imm8 ; 17 
      0090AC 91 B0                  116     .word fn_adr16_adr16 ; 18 
      0090AE 91 B5                  117     .word fn_adr8_adr8 ; 19
      0090B0 91 B8                  118     .word fn_adr8 ; 20
      0090B2 91 BC                  119     .word fn_r_ptr8 ; 21 
      0090B4 91 C1                  120     .word fn_r_ptr16 ; 22
      0090B6 91 C5                  121     .word fn_ptr8_r ; 23 
      0090B8 91 C9                  122     .word fn_ptr16_r ; 24
      0090BA 91 CE                  123     .word fn_r_ptr8_idx ; 25
      0090BC 91 D2                  124     .word fn_r_ptr16_idx ; 26 
      0090BE 91 D7                  125     .word fn_ptr8_idx_r ; 27 
      0090C0 91 DB                  126     .word fn_ptr16_idx_r ; 28 
      0090C2 91 E0                  127     .word fn_ofs8_idx_r ; 29 
      0090C4 91 E5                  128     .word fn_ofs16_idx  ; 30 
      0090C6 91 E9                  129     .word fn_r_ofs16_idx ; 31 
      0090C8 91 EE                  130     .word fn_ofs16_idx_r ; 32 
      0090CA 91 F2                  131     .word fn_r_ofs24_idx; 33
      0090CC 91 F7                  132     .word fn_ofs24_idx_r; 34 
      0090CE 91 FA                  133     .word fn_ptr16; 35 
      0090D0 91 FE                  134     .word fn_ptr8 ; 36 
      0090D2 92 02                  135     .word fn_ptr16_idx ; 37 
      0090D4 92 06                  136     .word fn_ptr8_idx ; 38
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
      0090D6 92 0B 92 0F 92         162     .byte 0x00,IDX.NEG,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090DB 13 92 18 92 1D         163     .byte 0x03,IDX.CPL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090E0 92 21 92 26 92         164     .byte 0x04,IDX.SRL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090E5 2B 92 30 92 35         165     .byte 0x06,IDX.RRC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090EA 92 3A 92 3F 92         166     .byte 0x07,IDX.SRA,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090EF 44 92 4A 92 50         167     .byte 0x08,IDX.SLL,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090F4 92 56 92 5C 92         168     .byte 0x09,IDX.RLC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090F9 60 92 66 92 6C         169     .byte 0x0a,IDX.DEC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      0090FE 92 72 92 78 92         170     .byte 0x0c,IDX.INC,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009103 7C 92 7F 92 83         171     .byte 0x0d,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009108 92 87 92 8B 92         172     .byte 0x0e,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      00910D 8F 92 93 92 98         173     .byte 0x0f,IDX.CLR,IDX.FN_OFS8_IDX,IDX.SP,IDX.SP 
      009112 92 9C 92 9F 92         174     .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.X,IDX.X 
      009117 A3 92 A8 92 AD         175     .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00911C 92 B3 92 B7 92         176     .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009121 BB 92 C0 92 C4         177     .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009126 92 C8 92 CD 92         178     .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00912B D2 92 D6 92 DB         179     .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009130 92 E0 92 E4 92         180     .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009135 E8 92 EC 92 F0         181     .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00913A 92 F4 92 F8 92         182     .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00913F FD 93 02 93 06         183     .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009144 93 0B 93 0F 93         184     .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      009149 14 93 18 93 1D         185     .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.X,IDX.X
      00914E 93 22 93 28 93         186     .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,IDX.X
                                    187     ; form op r,(ofs8,r) 0x1n 0x7B 0xEn
      009153 2C 93 31 93 36         188     .byte 0x10,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009158 93 3A 93 3E 93         189     .byte 0x11,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00915D 42 41 44 43 00         190     .byte 0x12,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009162 41 44 44 00 41         191     .byte 0x13,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      009167 44 44 57 00 41         192     .byte 0x14,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00916C 4E 44 00 42 43         193     .byte 0x15,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009171 43 4D 00 42 43         194     .byte 0x16,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009176 50 00 42 43 50         195     .byte 0x18,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00917B 4C 00 42 52 45         196     .byte 0x19,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009180 41 4B 00 42 52         197     .byte 0x1A,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009185 45 53 00 42 53         198     .byte 0x1B,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      00918A 45 54 00 42 54         199     .byte 0x1E,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      00918F 4A 46 00 42 54         200     .byte 0x7B,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.SP
      009194 4A 54 00 43 41         201     .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



      009199 4C 4C 00 43 41         202     .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      00919E 4C 4C 46 00 43         203     .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091A3 41 4C 4C 52 00         204     .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.X
      0091A8 43 43 46 00 43         205     .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091AD 4C 52 00 43 4C         206     .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091B2 52 57 00 43 50         207     .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091B7 00 43 50 4C 00         208     .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091BC 43 50 4C 57 00         209     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091C1 43 50 57 00 44         210     .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091C6 45 43 00 44 45         211     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.X
      0091CB 43 57 00 44 49         212     .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.X
                                    213     ;form op r,(ofs16,r)
      0091D0 56 00 44 49 56         214     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      0091D5 57 00 45 58 47         215     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
                                    216     ;form op (ofs16,r),r 
      0091DA 00 45 58 47 57         217     .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.X,IDX.Y 
                                    218     ;form op (ofs8,r),r 
      0091DF 00 48 41 4C 54         219     .byte 0x17,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.Y
      0091E4 00 49 4E 43 00         220     .byte 0x1F,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.X
      0091E9 49 4E 43 57 00         221     .byte 0x6B,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.SP,IDX.A 
      0091EE 49 4E 54 00 49         222     .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.X,IDX.A 
      0091F3 52 45 54 00 4A         223     .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.X,IDX.Y 
                                    224     ; opcode with implied arguments 0x4n 0x5n 0x8n 0x9n 
      0091F8 50 00 4A 50 46         225     .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.X,0
      0091FD 00 4A 52 41 00         226     .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.X,0
      009202 4A 52 43 00 4A         227     .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0 
      009207 52 45 51 00 4A         228     .byte 0x41,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.XL
      00920C 52 46 00 4A 52         229     .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.X,IDX.A 
      009211 48 00 4A 52 49         230     .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
      009216 48 00 4A 52 49         231     .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0 
      00921B 4C 00 4A 52 4D         232     .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0 
      009220 00 4A 52 4D 49         233     .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0 
      009225 00 4A 52 4E 43         234     .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0 
      00922A 00 4A 52 4E 45         235     .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0 
      00922F 00 4A 52 4E 48         236     .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0 
      009234 00 4A 52 4E 4D         237     .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0 
      009239 00 4A 52 4E 56         238     .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0 
      00923E 00 4A 52 50 4C         239     .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0 
      009243 00 4A 52 53 47         240     .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
      009248 45 00 4A 52 53         241     .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.X,0 
      00924D 47 54 00 4A 52         242     .byte 0x51,IDX.EXGW,IDX.FN_IMPL,IDX.X,IDX.Y
      009252 53 4C 45 00 4A         243     .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.X,0
      009257 52 53 4C 54 00         244     .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.X,0
      00925C 4A 52 54 00 4A         245     .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.X,0
      009261 52 55 47 45 00         246     .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.X,0
      009266 4A 52 55 47 54         247     .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.X,0
      00926B 00 4A 52 55 4C         248     .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.X,0
      009270 45 00 4A 52 55         249     .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.X,0
      009275 4C 54 00 4A 52         250     .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.X,0
      00927A 56 00 4C 44 00         251     .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
      00927F 4C 44 46 00 4C         252     .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.X,0
      009284 44 57 00 4D 4F         253     .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.X,0 
      009289 56 00 4D 55 4C         254     .byte 0x61,IDX.EXG,IDX.FN_IMPL,IDX.A,IDX.YL
      00928E 00 4E 45 47 00         255     .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.X,IDX.A
      009293 4E 45 47 57 00         256     .byte 0x65,IDX.DIVW,IDX.FN_IMPL,IDX.X,IDX.Y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      009298 4E 4F 50 00 4F         257     .byte 0x80,IDX.IRET,IDX.FN_IMPL,0,0
      00929D 52 00 50 4F 50         258     .byte 0x81,IDX.RET,IDX.FN_IMPL,0,0
      0092A2 00 50 4F 50 57         259     .byte 0x83,IDX.TRAP,IDX.FN_IMPL,0,0
      0092A7 00 50 55 53 48         260     .byte 0x84,IDX.POP,IDX.FN_IMPL,IDX.A,0
      0092AC 00 50 55 53 48         261     .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.X,0
      0092B1 57 00 52 43 46         262     .byte 0x86,IDX.POP,IDX.FN_IMPL,IDX.CC,0
      0092B6 00 52 45 54 00         263     .byte 0x87,IDX.RETF,IDX.FN_IMPL,0,0
      0092BB 52 45 54 46 00         264     .byte 0x88,IDX.PUSH,IDX.FN_IMPL,IDX.A,0
      0092C0 52 49 4D 00 52         265     .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.X,0
      0092C5 4C 43 00 52 4C         266     .byte 0x8A,IDX.PUSH,IDX.FN_IMPL,IDX.CC,0
      0092CA 43 57 00 52 4C         267     .byte 0x8B,IDX.BREAK,IDX.FN_IMPL,0,0
      0092CF 57 41 00 52 52         268     .byte 0x8C,IDX.CCF,IDX.FN_IMPL,0,0
      0092D4 43 00 52 52 43         269     .byte 0x8E,IDX.HALT,IDX.FN_IMPL,0,0
      0092D9 57 00 52 52 57         270     .byte 0x8F,IDX.WFI,IDX.FN_IMPL,0,0
      0092DE 41 00 52 56 46         271     .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.Y 
      0092E3 00 53 42 43 00         272     .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.X 
      0092E8 53 43 46 00 53         273     .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.XH,IDX.A 
      0092ED 49 4D 00 53 4C         274     .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.X,IDX.SP 
      0092F2 41 00 53 4C 4C         275     .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.XL,IDX.A 
      0092F7 00 53 4C 41 57         276     .byte 0x98,IDX.RCF,IDX.FN_IMPL,0,0
      0092FC 00 53 4C 4C 57         277     .byte 0x99,IDX.SCF,IDX.FN_IMPL,0,0
      009301 00 53 52 41 00         278     .byte 0x9A,IDX.RIM,IDX.FN_IMPL,0,0
      009306 53 52 41 57 00         279     .byte 0x9B,IDX.SIM,IDX.FN_IMPL,0,0
      00930B 53 52 4C 00 53         280     .byte 0x9C,IDX.RVF,IDX.FN_IMPL,0,0
      009310 52 4C 57 00 53         281     .byte 0x9D,IDX.NOP,IDX.FN_IMPL,0,0
      009315 55 42 00 53 55         282     .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XH
      00931A 42 57 00 53 57         283     .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.XL
                                    284     ; form  op r,(r) | op (r)
      00931F 41 50 00 53 57         285     .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.X,0 
      009324 41 50 57 00 54         286     .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.X,0 
      009329 4E 5A 00 54 4E         287     .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.X,0 
      00932E 5A 57 00 54 52         288     .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.X,0 
      009333 41 50 00 57 46         289     .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.X,0 
      009338 45 00 57 46 49         290     .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.X,0 
      00933D 00 58 4F 52 00         291     .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.X,0 
      009342 3F 00 06 07 00         292     .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.X,0 
      009344 7C 1E 06 07 00         293     .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.X,0 
      009344 00 00 93 60 93         294     .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.X,0 
      009349 62 93 65 93 68         295     .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.X,0 
      00934E 93 6B 93 6E 93         296     .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.X,0 
      009353 71 93 73 93 75         297     .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.X 
      009358 93 78 93 7B 93         298     .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.X 
      00935D 7F 93 83 01 07         299     .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.X 
      009360 F3 16 06 08 07         300     .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.Y,IDX.X 
      009360 41 00 43 43 00         301     .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.X 
      009365 58 48 00 59 48         302     .byte 0xF5,IDX.BCP,IDX.FN_R_IDX,IDX.A,IDX.X 
      00936A 00 58 4C 00 59         303     .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.X 
      00936F 4C 00 58 00 59         304     .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.X 
      009374 00 53 50 00 50         305     .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.X 
      009379 43 00 50 43 4C         306     .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.X 
      00937E 00 50 43 4D 00         307     .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.X 
      009383 50 43 45 00 44         308     .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.X,0 
      009388 41 53 4D 07 00         309     .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.X,0 
      00938B FE 3F 06 07 07         310     .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.X,IDX.X 
                                    311     ; form op (r),r 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      00938B A0 05 A3 13 A3         312     .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.X,IDX.A 
      009390 9B A3 E7 A4 63         313     .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.X,IDX.Y 
                                    314 
                                    315     ; form op r,#imm8 0xAn 
      009395 A4 91 A2 98 A2         316     .byte 0x52,IDX.SUB,IDX.FN_R_IMM8,IDX.SP,0
      00939A DB A1 FF A2 2C         317     .byte 0x5B,IDX.ADDW,IDX.FN_R_IMM8,IDX.SP,0
      00939F A0 4E A1 35 A1         318     .byte 0xa0,IDX.SUB,IDX.FN_R_IMM8,IDX.A,0
      0093A4 53 A1 76 A1 A3         319     .byte 0xa1,IDX.CP,IDX.FN_R_IMM8,IDX.A,0
      0093A9 A1 D0 A2 59 A4         320     .byte 0xa2,IDX.SBC,IDX.FN_R_IMM8,IDX.A,0
      0093AE BF A4 E5 A5 0B         321     .byte 0xa4,IDX.AND,IDX.FN_R_IMM8,IDX.A,0
      0093B3 A0 FA A5 33 A5         322     .byte 0xa5,IDX.BCP,IDX.FN_R_IMM8,IDX.A,0
      0093B8 62 A5 91 A5 C0         323     .byte 0xa6,IDX.LD,IDX.FN_R_IMM8,IDX.A,0
      0093BD A5 F4 A6 36 A6         324     .byte 0xa8,IDX.XOR,IDX.FN_R_IMM8,IDX.A,0
      0093C2 78 A6 BA A4 27         325     .byte 0xa9,IDX.ADC,IDX.FN_R_IMM8,IDX.A,0
      0093C7 A6 F7 A7 29 A7         326     .byte 0xaA,IDX.OR,IDX.FN_R_IMM8,IDX.A,0
      0093CC 69 A7 A9 A7 EB         327     .byte 0xaB,IDX.ADD,IDX.FN_R_IMM8,IDX.A,0
                                    328     ; form op r,#imm16 
      0093D1 A8 49 A8 28 A8         329     .byte 0x1C,IDX.ADDW,IDX.FN_R_IMM16,IDX.X,0
      0093D6 9F A8 6E 07 00         330     .byte 0x1D,IDX.SUBW,IDX.FN_R_IMM16,IDX.X,0
      0093D9 A3 16 05 07 00         331     .byte 0xa3,IDX.CPW,IDX.FN_R_IMM16,IDX.X,0
      0093D9 00 42 01 09 09         332     .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.X,0 
      0093DE 03 14 01 09 09         333     .byte 0xCB,IDX.ADD,IDX.FN_R_IMM16,IDX.A,0 
                                    334 
                                    335     ; form op adr8 
      0093E3 04 5E 01 09 09         336     .byte 0x30,IDX.NEG,IDX.FN_ADR8,0,0
      0093E8 06 51 01 09 09         337     .byte 0x33,IDX.CPL,IDX.FN_ADR8,0,0
      0093ED 07 5C 01 09 09         338     .byte 0x34,IDX.SRL,IDX.FN_ADR8,0,0
      0093F2 08 59 01 09 09         339     .byte 0x36,IDX.RRC,IDX.FN_ADR8,0,0
      0093F7 09 4E 01 09 09         340     .byte 0x37,IDX.SRA,IDX.FN_ADR8,0,0
      0093FC 0A 17 01 09 09         341     .byte 0x38,IDX.SLL,IDX.FN_ADR8,0,0
      009401 0C 1E 01 09 09         342     .byte 0x39,IDX.RLC,IDX.FN_ADR8,0,0
      009406 0D 64 01 09 09         343     .byte 0x3A,IDX.DEC,IDX.FN_ADR8,0,0
      00940B 0E 62 01 09 09         344     .byte 0x3C,IDX.INC,IDX.FN_ADR8,0,0
      009410 0F 11 01 09 09         345     .byte 0x3D,IDX.TNZ,IDX.FN_ADR8,0,0
      009415 60 42 01 07 07         346     .byte 0x3E,IDX.SWAP,IDX.FN_ADR8,0,0
      00941A 63 14 01 07 07         347     .byte 0x3F,IDX.CLR,IDX.FN_ADR8,0,0
      00941F 64 5E 01 07 07         348     .byte 0xAD,IDX.CALLR,IDX.FN_ADR8,0,0
                                    349     ; form op adr16 
      009424 66 51 01 07 07         350     .byte 0x32,IDX.POP,IDX.FN_ADR16,0,0
      009429 67 5C 01 07 07         351     .byte 0x3B,IDX.PUSH,IDX.FN_ADR16,0,0 
      00942E 68 59 01 07 07         352     .byte 0xcc,IDX.JP,IDX.FN_ADR16,0,0
      009433 69 4E 01 07 07         353     .byte 0xcd,IDX.CALL,IDX.FN_ADR16,0,0
                                    354     ;form op r,adr16 
      009438 6A 17 01 07 07         355     .byte 0x31,IDX.EXG,IDX.FN_R_ADR16,IDX.A,0
                                    356     ;form op adr24 
      00943D 6C 1E 01 07 07         357     .byte 0x82,IDX.INT,IDX.FN_ADR24,0,0
      009442 6D 64 01 07 07         358     .byte 0x8D,IDX.CALLF,IDX.FN_ADR24,0,0
      009447 6E 62 01 07 07         359     .byte 0xac,IDX.JPF,IDX.FN_ADR24,0,0
                                    360 
                                    361     ;form op r,adr8
      00944C 6F 11 01 07 07         362     .byte 0xB0,IDX.SUB,IDX.FN_R_ADR8,IDX.A,0
      009451 ED 0D 01 07 07         363     .byte 0xB1,IDX.CP,IDX.FN_R_ADR8,IDX.A,0
      009456 10 60 03 01 09         364     .byte 0xB2,IDX.SBC,IDX.FN_R_ADR8,IDX.A,0
      00945B 11 13 03 01 09         365     .byte 0xB3,IDX.CPW,IDX.FN_R_ADR8,IDX.X,0
      009460 12 55 03 01 09         366     .byte 0xB4,IDX.AND,IDX.FN_R_ADR8,IDX.A,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      009465 13 16 03 07 09         367     .byte 0xB5,IDX.BCP,IDX.FN_R_ADR8,IDX.A,0
      00946A 14 04 03 01 09         368     .byte 0xB6,IDX.LD,IDX.FN_R_ADR8,IDX.A,0
      00946F 15 06 03 01 09         369     .byte 0xB8,IDX.XOR,IDX.FN_R_ADR8,IDX.A,0
      009474 16 3F 03 08 09         370     .byte 0xB9,IDX.ADC,IDX.FN_R_ADR8,IDX.A,0
      009479 18 69 03 01 09         371     .byte 0xBA,IDX.OR,IDX.FN_R_ADR8,IDX.A,0
      00947E 19 01 03 01 09         372     .byte 0xBB,IDX.ADD,IDX.FN_R_ADR8,IDX.A,0
      009483 1A 45 03 01 09         373     .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.X,0
                                    374     
                                    375     ;form op r,adr16
      009488 1B 02 03 01 09         376     .byte 0xC0,IDX.SUB,IDX.FN_R_ADR16,IDX.A,0
      00948D 1E 3F 03 07 09         377     .byte 0xC1,IDX.CP,IDX.FN_R_ADR16,IDX.A,0
      009492 7B 3D 03 01 09         378     .byte 0xC2,IDX.SBC,IDX.FN_R_ADR16,IDX.A,0
      009497 E0 60 03 01 07         379     .byte 0xC3,IDX.CPW,IDX.FN_R_ADR16,IDX.X,0
      00949C E1 13 03 01 07         380     .byte 0xC4,IDX.AND,IDX.FN_R_ADR16,IDX.A,0
      0094A1 E2 55 03 01 07         381     .byte 0xC5,IDX.BCP,IDX.FN_R_ADR16,IDX.A,0
      0094A6 E3 16 03 08 07         382     .byte 0xC6,IDX.LD,IDX.FN_R_ADR16,IDX.A,0
      0094AB E4 04 03 01 07         383     .byte 0xC8,IDX.XOR,IDX.FN_R_ADR16,IDX.A,0
      0094B0 E5 06 03 01 07         384     .byte 0xc9,IDX.ADC,IDX.FN_R_ADR16,IDX.A,0
      0094B5 E6 3D 03 01 07         385     .byte 0xCA,IDX.OR,IDX.FN_R_ADR16,IDX.A,0
      0094BA E8 69 03 01 07         386     .byte 0xCB,IDX.ADD,IDX.FN_R_ADR16,IDX.A,0
      0094BF E9 01 03 01 07         387     .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.X,0
                                    388 
                                    389     ;form op r,adr24 
      0094C4 EA 45 03 01 07         390     .byte 0xBC,IDX.LDF,IDX.FN_R_ADR24,IDX.A,0 
                                    391 
                                    392     ; form op #imm8 
      0094C9 EB 02 03 01 07         393     .byte 0x4B,IDX.PUSH,IDX.FN_IMM8,0,0
                                    394 
                                    395     ;form op adr8,r 
      0094CE EE 3F 03 07 07         396     .byte 0xB7,IDX.LD,IDX.FN_ADR8_R,0,IDX.A
      0094D3 D6 3D 1F 01 07         397     .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.X
                                    398 
                                    399     ;form op adr16,r 
      0094D8 DB 02 1F 01 07         400     .byte 0xC7,IDX.LD,IDX.FN_ADR16_R,0,IDX.A 
      0094DD DF 3F 20 07 08         401     .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.X 
                                    402     ;form op adr24,r 
      0094E2 17 3F 1D 09 08         403     .byte 0xBD,IDX.LDF,IDX.FN_ADR24_R,0,IDX.A 
                                    404 
                                    405     ;form op adr16,#imm8
      0094E7 1F 3F 1D 09 07         406     .byte 0x35,IDX.MOV,IDX.FN_ADR16_IMM8,0,0 
                                    407     ;form op adr8,adr8 
      0094EC 6B 3D 1D 09 01         408     .byte 0x45,IDX.MOV,IDX.FN_ADR8_ADR8,0,0 
                                    409     ;form op adr16,adr16 
      0094F1 E7 3D 1D 07 01         410     .byte 0x55,IDX.MOV,IDX.FN_ADR16_ADR16,0,0 
                                    411 
                                    412     ;form op r,(off16,r)
      0094F6 EF 3F 1D 07 08         413     .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      0094FB 01 53 00 07 00         414     .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009500 02 50 00 07 00         415     .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009505 40 42 00 01 00         416     .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.X 
      00950A 41 1B 00 01 05         417     .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00950F 42 41 00 07 01         418     .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009514 43 14 00 01 00         419     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009519 44 5E 00 01 00         420     .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00951E 46 51 00 01 00         421     .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



      009523 47 5C 00 01 00         422     .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      009528 48 59 00 01 00         423     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.X 
      00952D 49 4E 00 01 00         424     .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.X 
                                    425     ;form op (off16,r),r 
      009532 4A 17 00 01 00         426     .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.X,IDX.A 
                                    427 
                                    428     ; form op r,(ofs24,r) 
      009537 4C 1E 00 01 00         429     .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.X 
                                    430     ; form op (ofs24,r),r 
      00953C 4D 64 00 01 00         431     .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.X,IDX.A 
                                    432     ;form op (ofs16,r)
      009541 4E 62 00 01 00         433     .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,0,IDX.X 
      009546 4F 11 00 01 00         434     .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,0,IDX.X 
                                    435     ;form op (ofs8,r)
      00954B 50 43 00 07 00         436     .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.X,0 
      009550 51 1C 00 07 08         437     .byte 0XED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.X,0  
                                    438 
      009555 53 15 00 07 00         439     .byte 0,0,0,0,0
                                    440 
                                    441 ; table for opcodes with 0x72 prefix 
      0007F2                        442 p72_codes:
                                    443     ;form op r,[ptr16]
      00955A 54 5F 00 07 00         444     .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0 
      00955F 56 52 00 07 00         445     .byte 0xC9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0 
      009564 57 5D 00 07 00         446     .byte 0xCb,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0 
                                    447     ;form op r,([ptr16],r)
      009569 58 5B 00 07 00         448     .byte 0xd6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      00956E 59 4F 00 07 00         449     .byte 0xd9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      009573 5A 18 00 07 00         450     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
                                    451 
                                    452     ;from implied
      009578 5C 1F 00 07 00         453     .byte 0x8F,IDX.WFE,IDX.FN_IMPL,0,0
                                    454 
                                    455     ;form op r,[ptr16]
      00957D 5D 65 00 07 00         456     .byte 0xC0,IDX.SUB,IDX.FN_R_PTR16,IDX.A,0
      009582 5E 63 00 07 00         457     .byte 0xC1,IDX.CP,IDX.FN_R_PTR16,IDX.A,0
      009587 5F 12 00 07 00         458     .byte 0xC2,IDX.SBC,IDX.FN_R_PTR16,IDX.A,0
      00958C 61 1B 00 01 06         459     .byte 0xC3,IDX.CPW,IDX.FN_R_PTR16,IDX.X,0
      009591 62 19 00 07 01         460     .byte 0xC4,IDX.AND,IDX.FN_R_PTR16,IDX.A,0
      009596 65 1A 00 07 08         461     .byte 0xC5,IDX.BCP,IDX.FN_R_PTR16,IDX.A,0
      00959B 80 21 00 00 00         462     .byte 0xC6,IDX.LD,IDX.FN_R_PTR16,IDX.A,0
      0095A0 81 4B 00 00 00         463     .byte 0xC8,IDX.XOR,IDX.FN_R_PTR16,IDX.A,0
      0095A5 83 66 00 00 00         464     .byte 0xc9,IDX.ADC,IDX.FN_R_PTR16,IDX.A,0
      0095AA 84 46 00 01 00         465     .byte 0xCA,IDX.OR,IDX.FN_R_PTR16,IDX.A,0
      0095AF 85 47 00 07 00         466     .byte 0xCB,IDX.ADD,IDX.FN_R_PTR16,IDX.A,0
      0095B4 86 46 00 02 00         467     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0
                                    468 
      0095B9 87 4C 00 00 00         469     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR16,IDX.X,0
                                    470 
                                    471     ; form op r,([ptr16],r)
      0095BE 88 48 00 01 00         472     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095C3 89 49 00 07 00         473     .byte 0xD1,IDX.CP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095C8 8A 48 00 02 00         474     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095CD 8B 08 00 00 00         475     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR16_IDX,IDX.Y,IDX.X 
      0095D2 8C 10 00 00 00         476     .byte 0xD4,IDX.AND,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



      0095D7 8E 1D 00 00 00         477     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095DC 8F 68 00 00 00         478     .byte 0xD6,IDX.LD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095E1 93 3F 00 07 08         479     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095E6 94 3F 00 09 07         480     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095EB 95 3D 00 03 01         481     .byte 0xDA,IDX.OR,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095F0 96 3F 00 07 09         482     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X 
      0095F5 97 3D 00 05 01         483     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR16_IDX,IDX.X,IDX.X 
                                    484 
                                    485     ; form op r,(ofs8,r)
      0095FA 98 4A 00 00 00         486     .byte 0xF0,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
      0095FF 99 56 00 00 00         487     .byte 0xF2,IDX.SUBW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009604 9A 4D 00 00 00         488     .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP
      009609 9B 57 00 00 00         489     .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP
                                    490     ; form op [ptr16],r 
      00960E 9C 54 00 00 00         491     .byte 0xC7,IDX.LD,IDX.FN_PTR16_R,0,IDX.A 
      009613 9D 44 00 00 00         492     .byte 0xCF,IDX.LDW,IDX.FN_PTR16_R,0,IDX.X 
                                    493 
                                    494     ; form op ([ptr16],r),r 
      009618 9E 3D 00 01 03         495     .byte 0xD7,IDX.LD,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
      00961D 9F 3D 00 01 05         496     .byte 0xDF,IDX.LDW,IDX.FN_PTR16_IDX_R,IDX.X,IDX.Y 
                                    497     ;form op [ptr16] 0x3n 
      009622 70 42 06 07 00         498     .byte 0x30,IDX.NEG,IDX.FN_PTR16,0,0
      009627 73 14 06 07 00         499     .byte 0x33,IDX.CPL,IDX.FN_PTR16,0,0
      00962C 74 5E 06 07 00         500     .byte 0x34,IDX.SRL,IDX.FN_PTR16,0,0
      009631 76 51 06 07 00         501     .byte 0x36,IDX.RRC,IDX.FN_PTR16,0,0
      009636 77 5C 06 07 00         502     .byte 0x37,IDX.SRA,IDX.FN_PTR16,0,0
      00963B 78 59 06 07 00         503     .byte 0x38,IDX.SLL,IDX.FN_PTR16,0,0
      009640 79 4E 06 07 00         504     .byte 0x39,IDX.RLC,IDX.FN_PTR16,0,0
      009645 7A 17 06 07 00         505     .byte 0x3A,IDX.DEC,IDX.FN_PTR16,0,0
      00964A 7C 1E 06 07 00         506     .byte 0x3C,IDX.INC,IDX.FN_PTR16,0,0
      00964F 7D 64 06 07 00         507     .byte 0x3D,IDX.TNZ,IDX.FN_PTR16,0,0
      009654 7E 62 06 07 00         508     .byte 0x3E,IDX.SWAP,IDX.FN_PTR16,0,0
      009659 7F 11 06 07 00         509     .byte 0x3F,IDX.CLR,IDX.FN_PTR16,0,0
                                    510     ; form op (ofs16,r) 0x4n
      00965E F0 60 06 01 07         511     .byte 0x40,IDX.NEG,IDX.FN_OFS16_IDX,IDX.X,0
      009663 F1 13 06 01 07         512     .byte 0x43,IDX.CPL,IDX.FN_OFS16_IDX,IDX.X,0
      009668 F2 55 06 01 07         513     .byte 0x44,IDX.SRL,IDX.FN_OFS16_IDX,IDX.X,0
      00966D F3 16 06 08 07         514     .byte 0x46,IDX.RRC,IDX.FN_OFS16_IDX,IDX.X,0
      009672 F4 04 06 01 07         515     .byte 0x47,IDX.SRA,IDX.FN_OFS16_IDX,IDX.X,0
      009677 F5 06 06 01 07         516     .byte 0x48,IDX.SLL,IDX.FN_OFS16_IDX,IDX.X,0
      00967C F6 3D 06 01 07         517     .byte 0x49,IDX.RLC,IDX.FN_OFS16_IDX,IDX.X,0
      009681 F8 69 06 01 07         518     .byte 0x4A,IDX.DEC,IDX.FN_OFS16_IDX,IDX.X,0
      009686 F9 01 06 01 07         519     .byte 0x4C,IDX.INC,IDX.FN_OFS16_IDX,IDX.X,0
      00968B FA 45 06 01 07         520     .byte 0x4D,IDX.TNZ,IDX.FN_OFS16_IDX,IDX.X,0
      009690 FB 02 06 01 07         521     .byte 0x4E,IDX.SWAP,IDX.FN_OFS16_IDX,IDX.X,0
      009695 FC 22 06 07 00         522     .byte 0x4F,IDX.CLR,IDX.FN_OFS16_IDX,IDX.X,0
                                    523 
                                    524     ; form op adr16 0x5n
      00969A FD 0D 06 07 00         525     .byte 0x50,IDX.NEG,IDX.FN_ADR16,0,0
      00969F FE 3F 06 07 07         526     .byte 0x53,IDX.CPL,IDX.FN_ADR16,0,0
      0096A4 F7 3D 07 07 01         527     .byte 0x54,IDX.SRL,IDX.FN_ADR16,0,0
      0096A9 FF 3F 07 07 08         528     .byte 0x56,IDX.RRC,IDX.FN_ADR16,0,0
      0096AE 52 60 04 09 00         529     .byte 0x57,IDX.SRA,IDX.FN_ADR16,0,0
      0096B3 5B 03 04 09 00         530     .byte 0x58,IDX.SLL,IDX.FN_ADR16,0,0
      0096B8 A0 60 04 01 00         531     .byte 0x59,IDX.RLC,IDX.FN_ADR16,0,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



      0096BD A1 13 04 01 00         532     .byte 0x5A,IDX.DEC,IDX.FN_ADR16,0,0
      0096C2 A2 55 04 01 00         533     .byte 0x5C,IDX.INC,IDX.FN_ADR16,0,0
      0096C7 A4 04 04 01 00         534     .byte 0x5D,IDX.TNZ,IDX.FN_ADR16,0,0
      0096CC A5 06 04 01 00         535     .byte 0x5E,IDX.SWAP,IDX.FN_ADR16,0,0
      0096D1 A6 3D 04 01 00         536     .byte 0x5F,IDX.CLR,IDX.FN_ADR16,0,0
                                    537 
                                    538     ; form op ([ptr16],x)  0x6n 
      0096D6 A8 69 04 01 00         539     .byte 0x60,IDX.NEG,IDX.FN_PTR16_IDX,IDX.X,0
      0096DB A9 01 04 01 00         540     .byte 0x63,IDX.CPL,IDX.FN_PTR16_IDX,IDX.X,0
      0096E0 AA 45 04 01 00         541     .byte 0x64,IDX.SRL,IDX.FN_PTR16_IDX,IDX.X,0
      0096E5 AB 02 04 01 00         542     .byte 0x66,IDX.RRC,IDX.FN_PTR16_IDX,IDX.X,0
      0096EA 1C 03 05 07 00         543     .byte 0x67,IDX.SRA,IDX.FN_PTR16_IDX,IDX.X,0
      0096EF 1D 61 05 07 00         544     .byte 0x68,IDX.SLL,IDX.FN_PTR16_IDX,IDX.X,0
      0096F4 A3 16 05 07 00         545     .byte 0x69,IDX.RLC,IDX.FN_PTR16_IDX,IDX.X,0
      0096F9 AE 3F 05 07 00         546     .byte 0x6A,IDX.DEC,IDX.FN_PTR16_IDX,IDX.X,0
      0096FE CB 02 05 01 00         547     .byte 0x6C,IDX.INC,IDX.FN_PTR16_IDX,IDX.X,0
      009703 30 42 14 00 00         548     .byte 0x6D,IDX.TNZ,IDX.FN_PTR16_IDX,IDX.X,0
      009708 33 14 14 00 00         549     .byte 0x6E,IDX.SWAP,IDX.FN_PTR16_IDX,IDX.X,0
      00970D 34 5E 14 00 00         550     .byte 0x6F,IDX.CLR,IDX.FN_PTR16_IDX,IDX.X,0
                                    551     ; form op r,#imm16 
      009712 36 51 14 00 00         552     .byte 0xA2,IDX.SUBW,IDX.FN_R_IMM16,IDX.Y,0
      009717 37 5C 14 00 00         553     .byte 0xA9,IDX.ADDW,IDX.FN_R_IMM16,IDX.Y,0 
                                    554     ; form op r,adr16 
      00971C 38 59 14 00 00         555     .byte 0xB0,IDX.SUBW,IDX.FN_R_ADR16,IDX.X,0
      009721 39 4E 14 00 00         556     .byte 0xB2,IDX.SUBW,IDX.FN_R_ADR16,IDX.Y,0
      009726 3A 17 14 00 00         557     .byte 0xB9,IDX.ADDW,IDX.FN_R_ADR16,IDX.Y,0
      00972B 3C 1E 14 00 00         558     .byte 0xBB,IDX.ADDW,IDX.FN_R_ADR16,IDX.X,0
                                    559     ; form op r,(ofs8,r)
      009730 3D 64 14 00 00         560     .byte 0xF9,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.SP 
      009735 3E 62 14 00 00         561     .byte 0xFB,IDX.ADDW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.SP 
                                    562     ; form op [ptr16]
      00973A 3F 11 14 00 00         563     .byte 0xCC,IDX.JP,IDX.FN_PTR16,0,0 
                                    564 
      00973F AD 0F 14 00 00         565     .byte 0,0,0,0,0
                                    566 
                                    567 ; table for opcodes with 0x90 prefix 
      0009DC                        568 p90_codes:
                                    569     ; form op (ofs8,r)
      009744 32 46 0B 00 00         570     .byte 0x60,IDX.NEG,IDX.FN_OFS8_IDX,IDX.Y,0 
      009749 3B 48 0B 00 00         571     .byte 0x63,IDX.CPL,IDX.FN_OFS8_IDX,IDX.Y,0
      00974E CC 22 0B 00 00         572     .byte 0x64,IDX.SRL,IDX.FN_OFS8_IDX,IDX.Y,0
      009753 CD 0D 0B 00 00         573     .byte 0x66,IDX.RRC,IDX.FN_OFS8_IDX,IDX.Y,0
      009758 31 1B 09 01 00         574     .byte 0x67,IDX.SRA,IDX.FN_OFS8_IDX,IDX.Y,0
      00975D 82 20 0C 00 00         575     .byte 0x68,IDX.SLL,IDX.FN_OFS8_IDX,IDX.Y,0
      009762 8D 0E 0C 00 00         576     .byte 0x69,IDX.RLC,IDX.FN_OFS8_IDX,IDX.Y,0
      009767 AC 23 0C 00 00         577     .byte 0x6A,IDX.DEC,IDX.FN_OFS8_IDX,IDX.Y,0
      00976C B0 60 08 01 00         578     .byte 0x6C,IDX.INC,IDX.FN_OFS8_IDX,IDX.Y,0
      009771 B1 13 08 01 00         579     .byte 0x6D,IDX.TNZ,IDX.FN_OFS8_IDX,IDX.Y,0
      009776 B2 55 08 01 00         580     .byte 0x6E,IDX.SWAP,IDX.FN_OFS8_IDX,IDX.Y,0
      00977B B3 16 08 07 00         581     .byte 0x6F,IDX.CLR,IDX.FN_OFS8_IDX,IDX.Y,0
      009780 B4 04 08 01 00         582     .byte 0xEC,IDX.JP,IDX.FN_OFS8_IDX,IDX.Y,0
      009785 B5 06 08 01 00         583     .byte 0xED,IDX.CALL,IDX.FN_OFS8_IDX,IDX.Y,0
                                    584    ; form op r,(osf8,r)
      00978A B6 3D 08 01 00         585     .byte 0xE0,IDX.SUB,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      00978F B8 69 08 01 00         586     .byte 0xE1,IDX.CP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



      009794 B9 01 08 01 00         587     .byte 0xE2,IDX.SBC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      009799 BA 45 08 01 00         588     .byte 0xE3,IDX.CPW,IDX.FN_R_OFS8_IDX,IDX.X,IDX.Y
      00979E BB 02 08 01 00         589     .byte 0xE4,IDX.AND,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097A3 BE 3F 08 07 00         590     .byte 0xE5,IDX.BCP,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097A8 C0 60 09 01 00         591     .byte 0xE6,IDX.LD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097AD C1 13 09 01 00         592     .byte 0xE8,IDX.XOR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097B2 C2 55 09 01 00         593     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097B7 C3 16 09 07 00         594     .byte 0xEA,IDX.OR,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097BC C4 04 09 01 00         595     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      0097C1 C5 06 09 01 00         596     .byte 0xEE,IDX.LDW,IDX.FN_R_OFS8_IDX,IDX.Y,IDX.Y
                                    597     ;form op r,(ofs16,r)
      0097C6 C6 3D 09 01 00         598     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
      0097CB C8 69 09 01 00         599     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y  
                                    600     
                                    601     ; opcode with implied arguments 
      0097D0 C9 01 09 01 00         602     .byte 0x01,IDX.RRWA,IDX.FN_IMPL,IDX.Y,0
      0097D5 CA 45 09 01 00         603     .byte 0x02,IDX.RLWA,IDX.FN_IMPL,IDX.Y,0
      0097DA CB 02 09 01 00         604     .byte 0x40,IDX.NEG,IDX.FN_IMPL,IDX.A,0
      0097DF CE 3F 09 07 00         605     .byte 0x42,IDX.MUL,IDX.FN_IMPL,IDX.Y,IDX.A 
      0097E4 BC 3E 10 01 00         606     .byte 0x43,IDX.CPL,IDX.FN_IMPL,IDX.A,0
      0097E9 4B 48 0A 00 00         607     .byte 0x44,IDX.SRL,IDX.FN_IMPL,IDX.A,0
      0097EE B7 3D 0D 00 01         608     .byte 0x46,IDX.RRC,IDX.FN_IMPL,IDX.A,0
      0097F3 BF 3F 0D 00 07         609     .byte 0x47,IDX.SRA,IDX.FN_IMPL,IDX.A,0
      0097F8 C7 3D 0E 00 01         610     .byte 0x48,IDX.SLL,IDX.FN_IMPL,IDX.A,0
      0097FD CF 3F 0E 00 07         611     .byte 0x49,IDX.RLC,IDX.FN_IMPL,IDX.A,0
      009802 BD 3E 0F 00 01         612     .byte 0x4A,IDX.DEC,IDX.FN_IMPL,IDX.A,0
      009807 35 40 11 00 00         613     .byte 0x4C,IDX.INC,IDX.FN_IMPL,IDX.A,0
      00980C 45 40 13 00 00         614     .byte 0x4D,IDX.TNZ,IDX.FN_IMPL,IDX.A,0
      009811 55 40 12 00 00         615     .byte 0x4E,IDX.SWAP,IDX.FN_IMPL,IDX.A,0
      009816 D0 60 1F 01 07         616     .byte 0x4F,IDX.CLR,IDX.FN_IMPL,IDX.A,0
      00981B D1 13 1F 01 07         617     .byte 0x50,IDX.NEGW,IDX.FN_IMPL,IDX.Y,0 
      009820 D2 55 1F 01 07         618     .byte 0x53,IDX.CPLW,IDX.FN_IMPL,IDX.Y,0
      009825 D3 16 1F 08 07         619     .byte 0x54,IDX.SRLW,IDX.FN_IMPL,IDX.Y,0
      00982A D4 04 1F 01 07         620     .byte 0x56,IDX.RRCW,IDX.FN_IMPL,IDX.Y,0
      00982F D5 06 1F 01 07         621     .byte 0x57,IDX.SRAW,IDX.FN_IMPL,IDX.Y,0
      009834 D6 3D 1F 01 07         622     .byte 0x58,IDX.SLLW,IDX.FN_IMPL,IDX.Y,0
      009839 D8 69 1F 01 07         623     .byte 0x59,IDX.RLCW,IDX.FN_IMPL,IDX.Y,0
      00983E D9 01 1F 01 07         624     .byte 0x5A,IDX.DECW,IDX.FN_IMPL,IDX.Y,0
      009843 DA 45 1F 01 07         625     .byte 0x5C,IDX.INCW,IDX.FN_IMPL,IDX.Y,0
      009848 DB 02 1F 01 07         626     .byte 0x5D,IDX.TNZW,IDX.FN_IMPL,IDX.X,0
      00984D DE 3F 1F 07 07         627     .byte 0x5E,IDX.SWAPW,IDX.FN_IMPL,IDX.Y,0
      009852 D7 3D 20 07 01         628     .byte 0x5F,IDX.CLRW,IDX.FN_IMPL,IDX.Y,0  
      009857 AF 3E 21 01 07         629     .byte 0x62,IDX.DIV,IDX.FN_IMPL,IDX.Y,IDX.A 
      00985C A7 3E 22 07 01         630     .byte 0x85,IDX.POPW,IDX.FN_IMPL,IDX.Y,0
      009861 DC 22 1E 00 07         631     .byte 0x89,IDX.PUSHW,IDX.FN_IMPL,IDX.Y,0
      009866 DD 0D 1E 00 07         632     .byte 0x93,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.X 
      00986B EC 22 01 07 00         633     .byte 0x94,IDX.LDW,IDX.FN_IMPL,IDX.SP,IDX.Y 
      009870 ED 0D 01 07 00         634     .byte 0x95,IDX.LD,IDX.FN_IMPL,IDX.YH,IDX.A 
      009875 00 00 00 00 00         635     .byte 0x96,IDX.LDW,IDX.FN_IMPL,IDX.Y,IDX.SP 
      00987A 97 3D 00 06 01         636     .byte 0x97,IDX.LD,IDX.FN_IMPL,IDX.YL,IDX.A 
      00987A C6 3D 16 01 00         637     .byte 0x9E,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YH
      00987F C9 01 16 01 00         638     .byte 0x9F,IDX.LD,IDX.FN_IMPL,IDX.A,IDX.YL
      009884 CB 02 16 01 00         639     .byte 0xFB,IDX.ADD,IDX.FN_IMPL,IDX.A,IDX.Y
                                    640     ; form  op r,(r) | op (r)
      009889 D6 3D 1A 01 07         641     .byte 0x70,IDX.NEG,IDX.FN_R_IDX,IDX.Y,0 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



      00988E D9 01 1A 01 07         642     .byte 0x73,IDX.CPL,IDX.FN_R_IDX,IDX.Y,0 
      009893 DB 02 1A 01 07         643     .byte 0x74,IDX.SRL,IDX.FN_R_IDX,IDX.Y,0 
      009898 8F 67 00 00 00         644     .byte 0x76,IDX.RRC,IDX.FN_R_IDX,IDX.Y,0 
      00989D C0 60 16 01 00         645     .byte 0x77,IDX.SRA,IDX.FN_R_IDX,IDX.Y,0 
      0098A2 C1 13 16 01 00         646     .byte 0x78,IDX.SLL,IDX.FN_R_IDX,IDX.Y,0 
      0098A7 C2 55 16 01 00         647     .byte 0x79,IDX.RLC,IDX.FN_R_IDX,IDX.Y,0 
      0098AC C3 16 16 07 00         648     .byte 0x7A,IDX.DEC,IDX.FN_R_IDX,IDX.Y,0 
      0098B1 C4 04 16 01 00         649     .byte 0x7C,IDX.INC,IDX.FN_R_IDX,IDX.Y,0 
      0098B6 C5 06 16 01 00         650     .byte 0x7D,IDX.TNZ,IDX.FN_R_IDX,IDX.Y,0 
      0098BB C6 3D 16 01 00         651     .byte 0x7E,IDX.SWAP,IDX.FN_R_IDX,IDX.Y,0 
      0098C0 C8 69 16 01 00         652     .byte 0x7F,IDX.CLR,IDX.FN_R_IDX,IDX.Y,0 
      0098C5 C9 01 16 01 00         653     .byte 0xF0,IDX.SUB,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098CA CA 45 16 01 00         654     .byte 0xF1,IDX.CP,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098CF CB 02 16 01 00         655     .byte 0xF2,IDX.SBC,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098D4 CE 3F 16 07 00         656     .byte 0xF3,IDX.CPW,IDX.FN_R_IDX,IDX.X,IDX.Y 
      0098D9 CE 3F 16 07 00         657     .byte 0xF4,IDX.AND,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098DE D0 60 1A 01 07         658     .byte 0xF6,IDX.LD,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098E3 D1 13 1A 01 07         659     .byte 0xF8,IDX.XOR,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098E8 D2 55 1A 01 07         660     .byte 0xF9,IDX.ADC,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098ED D3 16 1A 08 07         661     .byte 0xFA,IDX.OR,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098F2 D4 04 1A 01 07         662     .byte 0xFB,IDX.ADD,IDX.FN_R_IDX,IDX.A,IDX.Y 
      0098F7 D5 06 1A 01 07         663     .byte 0xFC,IDX.JP,IDX.FN_R_IDX,IDX.Y,0 
      0098FC D6 3D 1A 01 07         664     .byte 0xFD,IDX.CALL,IDX.FN_R_IDX,IDX.Y,0 
      009901 D8 69 1A 01 07         665     .byte 0xFE,IDX.LDW,IDX.FN_R_IDX,IDX.Y,IDX.Y 
                                    666     
                                    667     ; form op (r),r 
      009906 D9 01 1A 01 07         668     .byte 0xF7,IDX.LD,IDX.FN_IDX_R,IDX.Y,IDX.A 
      00990B DA 45 1A 01 07         669     .byte 0xFF,IDX.LDW,IDX.FN_IDX_R,IDX.Y,IDX.X   
                                    670 
                                    671     ; form op r,#imm16 
      009910 DB 02 1A 01 07         672     .byte 0xae,IDX.LDW,IDX.FN_R_IMM16,IDX.Y,IDX.Y 
                                    673     ; from op r,(ofs8,r)
      009915 DE 3F 1A 07 07         674     .byte 0xE9,IDX.ADC,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
      00991A F0 61 03 07 09         675     .byte 0xEB,IDX.ADD,IDX.FN_R_OFS8_IDX,IDX.A,IDX.Y
                                    676     
                                    677     ; form op adr8,r 
      00991F F2 61 03 08 09         678     .byte 0xBF,IDX.LDW,IDX.FN_ADR8_R,0,IDX.Y 
                                    679     ; form op r,adr8 
      009924 F9 03 03 08 09         680     .byte 0xBE,IDX.LDW,IDX.FN_R_ADR8,IDX.Y,0
                                    681     ; form op r,adr16 
      009929 FB 03 03 07 09         682     .byte 0xCE,IDX.LDW,IDX.FN_R_ADR16,IDX.Y,0
                                    683     ;form op (ofs8,r),r 
      00992E C7 3D 18 00 01         684     .byte 0xE7,IDX.LD,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.A 
      009933 CF 3F 18 00 07         685     .byte 0xEF,IDX.LDW,IDX.FN_OFS8_IDX_R,IDX.Y,IDX.X 
                                    686     ;form op (off16,r),r 
      009938 D7 3D 1C 07 01         687     .byte 0xD7,IDX.LD,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.A 
      00993D DF 3F 1C 07 08         688     .byte 0xDF,IDX.LDW,IDX.FN_OFS16_IDX_R,IDX.Y,IDX.X 
                                    689     ; form op r,(ofs16,r)
      009942 30 42 23 00 00         690     .byte 0xD0,IDX.SUB,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009947 33 14 23 00 00         691     .byte 0xD1,IDX.CP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00994C 34 5E 23 00 00         692     .byte 0xD2,IDX.SBC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009951 36 51 23 00 00         693     .byte 0xD3,IDX.CPW,IDX.FN_R_OFS16_IDX,IDX.X,IDX.Y 
      009956 37 5C 23 00 00         694     .byte 0xD4,IDX.AND,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00995B 38 59 23 00 00         695     .byte 0xD5,IDX.BCP,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009960 39 4E 23 00 00         696     .byte 0xD6,IDX.LD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



      009965 3A 17 23 00 00         697     .byte 0xD8,IDX.XOR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00996A 3C 1E 23 00 00         698     .byte 0xD9,IDX.ADC,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      00996F 3D 64 23 00 00         699     .byte 0xDA,IDX.OR,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009974 3E 62 23 00 00         700     .byte 0xDB,IDX.ADD,IDX.FN_R_OFS16_IDX,IDX.A,IDX.Y 
      009979 3F 11 23 00 00         701     .byte 0xDE,IDX.LDW,IDX.FN_R_OFS16_IDX,IDX.Y,IDX.Y 
                                    702     ;form op (ofs16,r)
      00997E 40 42 1E 07 00         703     .byte 0xDC,IDX.JP,IDX.FN_OFS16_IDX,IDX.Y,0 
      009983 43 14 1E 07 00         704     .byte 0xDD,IDX.CALL,IDX.FN_OFS16_IDX,IDX.Y,0 
                                    705 
                                    706     ; form op r,(ofs24,r) 
      009988 44 5E 1E 07 00         707     .byte 0xAF,IDX.LDF,IDX.FN_R_OFS24_IDX,IDX.A,IDX.Y  
                                    708     ; form op (ofs24,r),r 
      00998D 46 51 1E 07 00         709     .byte 0xA7,IDX.LDF,IDX.FN_OFS24_IDX_R,IDX.Y,IDX.A 
                                    710     ;form op adr16,r 
      009992 47 5C 1E 07 00         711     .byte 0xCF,IDX.LDW,IDX.FN_ADR16_R,0,IDX.Y 
      009997 48 59 1E 07 00         712     .byte 0,0,0,0,0
                                    713 
                                    714 ; table for opcodes with 0x91 prefix 
      000C39                        715 p91_codes:
                                    716     ;form op r,([ptr8],r)
      00999C 49 4E 1E 07 00         717     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099A1 4A 17 1E 07 00         718     .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099A6 4C 1E 1E 07 00         719     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099AB 4D 64 1E 07 00         720     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.X,IDX.Y 
      0099B0 4E 62 1E 07 00         721     .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099B5 4F 11 1E 07 00         722     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099BA 50 42 0B 00 00         723     .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y  
      0099BF 53 14 0B 00 00         724     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099C4 54 5E 0B 00 00         725     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y
      0099C9 56 51 0B 00 00         726     .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099CE 57 5C 0B 00 00         727     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.Y 
      0099D3 58 59 0B 00 00         728     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.Y 
                                    729     ;form op ([ptr8,r]),r
      0099D8 59 4E 0B 00 00         730     .byte 0xd7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.A 
                                    731     ; form op r,([ptr16],r) 
      0099DD 5A 17 0B 00 00         732     .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.Y 
                                    733     ; form op ([ptr16],r),r 
      0099E2 5C 1E 0B 00 00         734     .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.Y,IDX.A 
                                    735     ;form op r,[ptr8]
      0099E7 5D 64 0B 00 00         736     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.Y,0 
                                    737     ;form op [ptr8],r 
      0099EC 5E 62 0B 00 00         738     .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.Y 
                                    739     ;form op ([ptr8,r]),r 
      0099F1 5F 11 0B 00 00         740     .byte 0XDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.Y,IDX.X 
                                    741     ;form op ([ptr8],r)
      0099F6 60 42 25 07 00         742     .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.Y,0 
      0099FB 63 14 25 07 00         743     .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.Y,0
      009A00 64 5E 25 07 00         744     .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.Y,0
      009A05 66 51 25 07 00         745     .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A0A 67 5C 25 07 00         746     .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.Y,0
      009A0F 68 59 25 07 00         747     .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.Y,0
      009A14 69 4E 25 07 00         748     .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A19 6A 17 25 07 00         749     .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A1E 6C 1E 25 07 00         750     .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.Y,0
      009A23 6D 64 25 07 00         751     .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.Y,0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



      009A28 6E 62 25 07 00         752     .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.Y,0
      009A2D 6F 11 25 07 00         753     .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.Y,0
      009A32 A2 61 05 08 00         754     .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.Y,0
      009A37 A9 03 05 08 00         755     .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.Y,0
                                    756 
      009A3C B0 61 09 07 00         757     .byte 0,0,0,0,0
                                    758 
                                    759 ; table of indexes for opcodes with 0x92 prefix 
      000CDE                        760 p92_codes:
                                    761     ;form op r,[ptr8]
      009A41 B2 61 09 08 00         762     .byte 0xC0,IDX.SUB,IDX.FN_R_PTR8,IDX.A,0
      009A46 B9 03 09 08 00         763     .byte 0xC1,IDX.CP,IDX.FN_R_PTR8,IDX.A,0
      009A4B BB 03 09 07 00         764     .byte 0xC2,IDX.SBC,IDX.FN_R_PTR8,IDX.A,0
      009A50 F9 03 03 08 09         765     .byte 0xC3,IDX.CPW,IDX.FN_R_PTR8,IDX.X,0
      009A55 FB 03 03 07 09         766     .byte 0xC4,IDX.AND,IDX.FN_R_PTR8,IDX.A,0
      009A5A CC 22 23 00 00         767     .byte 0xC5,IDX.BCP,IDX.FN_R_PTR8,IDX.A,0
      009A5F 00 00 00 00 00         768     .byte 0xC6,IDX.LD,IDX.FN_R_PTR8,IDX.A,0
      009A64 C8 69 15 01 00         769     .byte 0xC8,IDX.XOR,IDX.FN_R_PTR8,IDX.A,0
      009A64 60 42 01 08 00         770     .byte 0xc9,IDX.ADC,IDX.FN_R_PTR8,IDX.A,0
      009A69 63 14 01 08 00         771     .byte 0xCA,IDX.OR,IDX.FN_R_PTR8,IDX.A,0
      009A6E 64 5E 01 08 00         772     .byte 0xCB,IDX.ADD,IDX.FN_R_PTR8,IDX.A,0
      009A73 66 51 01 08 00         773     .byte 0xCE,IDX.LDW,IDX.FN_R_PTR8,IDX.A,0
                                    774 
                                    775     ;form op r,([ptr8,],r)
      009A78 67 5C 01 08 00         776     .byte 0xD0,IDX.SUB,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A7D 68 59 01 08 00         777     .byte 0xD1,IDX.CP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A82 69 4E 01 08 00         778     .byte 0xD2,IDX.SBC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A87 6A 17 01 08 00         779     .byte 0xD3,IDX.CPW,IDX.FN_R_PTR8_IDX,IDX.Y,IDX.X 
      009A8C 6C 1E 01 08 00         780     .byte 0xD4,IDX.AND,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A91 6D 64 01 08 00         781     .byte 0xD5,IDX.BCP,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A96 6E 62 01 08 00         782     .byte 0xD6,IDX.LD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009A9B 6F 11 01 08 00         783     .byte 0xD8,IDX.XOR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AA0 EC 22 01 08 00         784     .byte 0xD9,IDX.ADC,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AA5 ED 0D 01 08 00         785     .byte 0xDA,IDX.OR,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AAA E0 60 03 01 08         786     .byte 0xDB,IDX.ADD,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
      009AAF E1 13 03 01 08         787     .byte 0xDE,IDX.LDW,IDX.FN_R_PTR8_IDX,IDX.A,IDX.X 
                                    788 
                                    789     ;form op [ptr8],r 
      009AB4 E2 55 03 01 08         790     .byte 0xC7,IDX.LD,IDX.FN_PTR8_R,0,IDX.A 
      009AB9 E3 16 03 07 08         791     .byte 0xCF,IDX.LDW,IDX.FN_PTR8_R,0,IDX.X 
                                    792     ;form op ([ptr8],r),r 
      009ABE E4 04 03 01 08         793     .byte 0xD7,IDX.LD,IDX.FN_PTR8_IDX_R,IDX.X,IDX.A 
      009AC3 E5 06 03 01 08         794     .byte 0xDF,IDX.LDW,IDX.FN_PTR8_IDX_R,IDX.X,IDX.Y 
                                    795     ; form op r,([ptr16],r) 
      009AC8 E6 3D 03 01 08         796     .byte 0xAF,IDX.LDF,IDX.FN_R_PTR16_IDX,IDX.A,IDX.X  
                                    797     ; form op ([ptr16],r),r 
      009ACD E8 69 03 01 08         798     .byte 0xA7,IDX.LDF,IDX.FN_PTR16_IDX_R,IDX.X,IDX.A 
                                    799     ; form op r,[ptr16]
      009AD2 E9 01 03 01 08         800     .byte 0xBC,IDX.LDF,IDX.FN_R_PTR16,IDX.A,0
                                    801     ; form op [ptr16],r 
      009AD7 EA 45 03 01 08         802     .byte 0xBD,IDX.LDF,IDX.FN_PTR16_R,0,IDX.A  
                                    803     ; form op [ptr16] 
      009ADC EB 02 03 01 08         804     .byte 0x8D,IDX.CALLF,IDX.FN_PTR16,0,0
      009AE1 EE 3F 03 08 08         805     .byte 0xAC,IDX.JPF,IDX.FN_PTR16,0,0 
                                    806     ; form op [ptr8] 0x3n 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



      009AE6 D6 3D 1F 01 08         807     .byte 0x30,IDX.NEG,IDX.FN_PTR8,0,0
      009AEB DB 02 1F 01 08         808     .byte 0x33,IDX.CPL,IDX.FN_PTR8,0,0
      009AF0 01 53 00 08 00         809     .byte 0x34,IDX.SRL,IDX.FN_PTR8,0,0
      009AF5 02 50 00 08 00         810     .byte 0x36,IDX.RRC,IDX.FN_PTR8,0,0
      009AFA 40 42 00 01 00         811     .byte 0x37,IDX.SRA,IDX.FN_PTR8,0,0
      009AFF 42 41 00 08 01         812     .byte 0x38,IDX.SLL,IDX.FN_PTR8,0,0
      009B04 43 14 00 01 00         813     .byte 0x39,IDX.RLC,IDX.FN_PTR8,0,0
      009B09 44 5E 00 01 00         814     .byte 0x3A,IDX.DEC,IDX.FN_PTR8,0,0
      009B0E 46 51 00 01 00         815     .byte 0x3C,IDX.INC,IDX.FN_PTR8,0,0
      009B13 47 5C 00 01 00         816     .byte 0x3D,IDX.TNZ,IDX.FN_PTR8,0,0
      009B18 48 59 00 01 00         817     .byte 0x3E,IDX.SWAP,IDX.FN_PTR8,0,0
      009B1D 49 4E 00 01 00         818     .byte 0x3F,IDX.CLR,IDX.FN_PTR8,0,0
                                    819     ; form op ([ptr8],r) 0x6n 0xDC 0xDD
      009B22 4A 17 00 01 00         820     .byte 0x60,IDX.NEG,IDX.FN_PTR8_IDX,IDX.X,0 
      009B27 4C 1E 00 01 00         821     .byte 0x63,IDX.CPL,IDX.FN_PTR8_IDX,IDX.X,0
      009B2C 4D 64 00 01 00         822     .byte 0x64,IDX.SRL,IDX.FN_PTR8_IDX,IDX.X,0
      009B31 4E 62 00 01 00         823     .byte 0x66,IDX.RRC,IDX.FN_PTR8_IDX,IDX.X,0
      009B36 4F 11 00 01 00         824     .byte 0x67,IDX.SRA,IDX.FN_PTR8_IDX,IDX.X,0
      009B3B 50 43 00 08 00         825     .byte 0x68,IDX.SLL,IDX.FN_PTR8_IDX,IDX.X,0
      009B40 53 15 00 08 00         826     .byte 0x69,IDX.RLC,IDX.FN_PTR8_IDX,IDX.X,0
      009B45 54 5F 00 08 00         827     .byte 0x6A,IDX.DEC,IDX.FN_PTR8_IDX,IDX.X,0
      009B4A 56 52 00 08 00         828     .byte 0x6C,IDX.INC,IDX.FN_PTR8_IDX,IDX.X,0
      009B4F 57 5D 00 08 00         829     .byte 0x6D,IDX.TNZ,IDX.FN_PTR8_IDX,IDX.X,0
      009B54 58 5B 00 08 00         830     .byte 0x6E,IDX.SWAP,IDX.FN_PTR8_IDX,IDX.X,0
      009B59 59 4F 00 08 00         831     .byte 0x6F,IDX.CLR,IDX.FN_PTR8_IDX,IDX.X,0
      009B5E 5A 18 00 08 00         832     .byte 0xED,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0
      009B63 5C 1F 00 08 00         833     .byte 0xDC,IDX.JP,IDX.FN_PTR8_IDX,IDX.X,0
      009B68 5D 65 00 07 00         834     .byte 0xDD,IDX.CALL,IDX.FN_PTR8_IDX,IDX.X,0
                                    835 
      009B6D 5E 63 00 08 00         836     .byte 0,0,0,0,0
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
      009B72 5F               [ 2]  850     pushw X
      009B73 12 00            [ 2]  851     pushw y 
      009B75 08 00            [ 2]  852     sub sp,#LOCAL_SIZE 
      009B77 62 19 00         [ 4]  853     call number 
      009B7A 08 01 85         [ 1]  854     ld a,pad
      009B7D 47 00            [ 1]  855     jreq dasm_miss_arg
      009B7F 08 00 89         [ 2]  856     ldw x, #acc24
      009B82 49 00 08 00      [ 2]  857     ldw y, #farptr
      009B86 93 3F 00         [ 4]  858     call copy_var24
      000E2B                        859 page_loop:
      009B89 08 07            [ 1]  860     ld a,#PAGE_CNT 
      009B8B 94 3F            [ 1]  861     ld (INST_CNTR,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



      000E2F                        862 instr_loop:
                                    863 ; print address
      009B8D 00 09            [ 1]  864     ld a,#CR 
      009B8F 08 95 3D         [ 4]  865     call uart_tx
      009B92 00 04 01         [ 2]  866     ldw x, #farptr
      009B95 96 3F 00 08      [ 2]  867     ldw y, #acc24
      009B99 09 97 3D         [ 4]  868     call copy_var24 
      009B9C 00 06            [ 1]  869     ld a,#6
      009B9E 01               [ 1]  870     ld xl,a 
      009B9F 9E 3D            [ 1]  871     ld a,#16
      009BA1 00 01 04         [ 4]  872     call print_int 
      009BA4 9F 3D            [ 1]  873     ld a,#TAB 
      009BA6 00 01 06         [ 4]  874     call uart_tx 
      009BA9 FB 02 00         [ 4]  875     call decode
                                    876 ; here XL = decoded byte count
      009BAC 01               [ 1]  877     clr a 
      009BAD 08 70 42 06      [ 2]  878     addw x,farptr+1
      009BB1 08 00 73         [ 1]  879     adc a,farptr
      009BB4 14 06 08         [ 1]  880     ld farptr,a 
      009BB7 00 74 5E         [ 2]  881     ldw farptr+1,x 
      009BBA 06 08            [ 1]  882     dec (INST_CNTR,sp)
      009BBC 00 76            [ 1]  883     jrne instr_loop
                                    884 ; pause wait spacebar for next page or other to leave
      009BBE 51 06 08         [ 4]  885     call uart_getchar
      009BC1 00 77            [ 1]  886     cp a,#SPACE 
      009BC3 5C 06            [ 1]  887     jreq page_loop
      009BC5 08 00            [ 2]  888     jra dasm_exit        
      000E69                        889  dasm_miss_arg:
      009BC7 78 59 06         [ 4]  890     call error_print    
      000E6C                        891 dasm_exit: 
      009BCA 08 00            [ 2]  892     popw y 
      009BCC 79               [ 2]  893     popw x 
      009BCD 4E 06            [ 2]  894     addw sp,#LOCAL_SIZE 
      009BCF 08               [ 4]  895     ret 
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
      009BD0 00 7A            [ 2]  910     sub sp,#LOCAL_SIZE 
      009BD2 17               [ 1]  911     clrw x 
      009BD3 06 08 00         [ 4]  912     call get_int8    
      009BD6 7C 1E            [ 1]  913     ld (OPCODE,sp),a 
      009BD8 06 08 00         [ 4]  914     call is_prefix 
      009BDB 7D 64            [ 1]  915     ld (PREFIX,sp),a 
      009BDD 06 08            [ 1]  916     cp a,#0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



      009BDF 00 7E            [ 1]  917     jrne 0$
                                    918 ; no prefix     
      009BE1 62 06            [ 1]  919     ld a,#0xf0 
      009BE3 08 00            [ 1]  920     and a,(OPCODE,sp)
      009BE5 7F 11            [ 1]  921     cp a,#0x20
      009BE7 06 08            [ 1]  922     jrne 10$
      009BE9 00 F0            [ 1]  923     ld a,(OPCODE,sp)
      009BEB 60 06            [ 1]  924     and a,#0xf 
      009BED 01 08 F1         [ 4]  925     call fn_rel8 
      009BF0 13 06 01         [ 2]  926     jp decode_exit 
      000E95                        927 10$:
      009BF3 08 F2 55 06      [ 2]  928     ldw y,#codes 
      009BF7 01 08            [ 2]  929     jra 6$
                                    930 ; get opcode
      009BF9 F3 16 06         [ 4]  931 0$: call get_int8 
      009BFC 07 08            [ 1]  932     ld (OPCODE,sp),a  
      009BFE F4 04            [ 1]  933     ld a,(PREFIX,sp)
      009C00 06 01            [ 1]  934 1$: cp a,#0x72 
      009C02 08 F6            [ 1]  935     jrne 2$
      009C04 3D 06            [ 1]  936     ld a,(OPCODE,sp)
      009C06 01 08            [ 1]  937     and a,#0xf0 
      009C08 F8 69            [ 1]  938     jrne 11$
      009C0A 06 01            [ 1]  939     ld a,(OPCODE,sp)
      009C0C 08 F9            [ 1]  940     and a,#0xf 
      009C0E 01 06 01         [ 4]  941     call fn_adr16_b_rel
      009C11 08 FA 45         [ 2]  942     jp decode_exit 
      000EB6                        943 11$:
      009C14 06 01            [ 1]  944     cp a,#0x10  
      009C16 08 FB            [ 1]  945     jrne 12$
      009C18 02 06            [ 1]  946     ld a,(OPCODE,sp)
      009C1A 01 08            [ 1]  947     and a,#0xf 
      009C1C FC 22 06         [ 4]  948     call fn_adr16_bit
      009C1F 08 00 FD         [ 2]  949     jp decode_exit 
      000EC4                        950 12$:    
      009C22 0D 06 08 00      [ 2]  951     ldw y,#p72_codes
      009C26 FE 3F            [ 2]  952     jra 6$
      009C28 06 08            [ 1]  953 2$: cp a,#0x90
      009C2A 08 F7            [ 1]  954     jrne 3$
      009C2C 3D 07            [ 1]  955     ld a,(OPCODE,sp)
      009C2E 08 01            [ 1]  956     and a,#0xf0 
      009C30 FF 3F            [ 1]  957     cp a,#0x10 
      009C32 07 08            [ 1]  958     jrne 21$
      009C34 07 AE            [ 1]  959     ld a,(OPCODE,sp) 
      009C36 3F 05 08         [ 4]  960     call fn_adr16_bit 
      009C39 08 E9 01         [ 2]  961     jp decode_exit 
      000EDE                        962 21$: 
      009C3C 03 01            [ 1]  963     cp a,#0x20 
      009C3E 08 EB            [ 1]  964     jrne 22$
      009C40 02 03            [ 1]  965     ld a,(OPCODE,sp)
      009C42 01 08 BF         [ 4]  966     call fn_rel8 
      009C45 3F 0D            [ 2]  967     jra decode_exit 
      000EE9                        968 22$:
      009C47 00 08 BE 3F      [ 2]  969     ldw y,#p90_codes
      009C4B 08 08            [ 2]  970     jra 6$
      009C4D 00 CE            [ 1]  971 3$: cp a,#0x91 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



      009C4F 3F 09            [ 1]  972     jrne 4$
      009C51 08 00 E7 3D      [ 2]  973     ldw y,#p91_codes
      009C55 1D 08            [ 2]  974     jra 6$ 
      009C57 01 EF 3F 1D      [ 2]  975 4$: ldw y,#p92_codes 
      009C5B 08 07            [ 1]  976 6$: ld a,(OPCODE,sp)
      009C5D D7 3D            [ 4]  977     callr search_code
      009C5F 20 08 01 DF 3F   [ 2]  978     btjf flags,#F_FOUND,invalid_opcode
      009C64 20 08            [ 2]  979     pushw y 
      009C66 07 D0 60         [ 1]  980     ld a,(FIELD_FN,y)
      009C69 1F 01 08 D1      [ 2]  981     ldw y,#fn_index
      009C6D 13 1F 01         [ 4]  982     call ld_table_entry
      009C70 08 D2            [ 4]  983     call (y)
      009C72 55 1F            [ 2]  984     popw y 
      009C74 01 08            [ 2]  985     jra decode_exit 
      000F18                        986 invalid_opcode: 
      009C76 D3 16 1F 07      [ 2]  987     ldw y, #bad_opcode 
      009C7A 08 D4            [ 2]  988     pushw y 
      009C7C 04 1F 01         [ 4]  989     call fn_implied  
      009C7F 08 D5            [ 2]  990     popw y 
      000F23                        991 decode_exit:    
      009C81 06 1F            [ 2]  992     addw sp,#LOCAL_SIZE 
      009C83 01               [ 4]  993     ret
                                    994 
      009C84 08 D6 3D 1F 01         995 bad_opcode:  .byte 0,IDX.QM,IDX.FN_IMPL,0,0  
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
      009C89 08               [ 1] 1007     push a 
      009C8A D8 69 1F 01      [ 1] 1008     bset flags,#F_FOUND 
      009C8E 08 D9 01         [ 1] 1009 1$: ld a,(FIELD_MNEMO,y)
      009C91 1F 01            [ 1] 1010     jreq 8$ 
      009C93 08 DA 45         [ 1] 1011     ld a,(FIELD_OPCODE,y)
      009C96 1F 01            [ 1] 1012     cp a,(1,sp)
      009C98 08 DB            [ 1] 1013     jreq 9$
      009C9A 02 1F 01 08      [ 2] 1014     addw y,#STRUCT_SIZE
      009C9E DE 3F            [ 2] 1015     jra 1$
      009CA0 1F 08 08 DC      [ 1] 1016 8$: bres flags,#F_FOUND 
      009CA4 22               [ 1] 1017 9$: pop a 
      009CA5 1E               [ 4] 1018     ret 
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
      009CA6 08               [ 1] 1032     push a
      009CA7 00 DD 0D 1E      [ 2] 1033     ldw y, #prefixes
      009CAB 08 00            [ 1] 1034 1$: ld a,(y)
      009CAD AF 3E            [ 1] 1035     jreq 2$
      009CAF 21 01            [ 1] 1036     incw y
      009CB1 08 A7            [ 1] 1037     cp a,(1,sp)
      009CB3 3E 22            [ 1] 1038     jrne 1$  
      009CB5 08 01            [ 2] 1039 2$: addw sp,#1
      009CB7 CF               [ 4] 1040     ret 
                                   1041 
                                   1042 ; opcode prefixes 
      009CB8 3F 0E 00 08 00        1043 prefixes: .byte  0x72, 0x90, 0x91, 0x92, 0  
                                   1044 
                                   1045 
                                   1046 ;*******************************
                                   1047 
                                   1048 ;----------------------------
                                   1049 ;  helper macros 
                                   1050 ;----------------------------
                                   1051 ; lsize is local variables size in bytes 
                                   1052 ; name is routine name 
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
      009CBD 00 00 00 00 00        1071 fmt_impl_no_arg: .asciz "%a%s" 
      009CC1 25 61 25 73 09 25 73  1072 fmt_impl_1_r: .asciz "%a%s\t%s"
             00
      009CC1 D0 60 19 01 08 D1 13  1073 fmt_impl_2_r: .asciz "%a%s\t%s,%s" 
             19 01 08 D2
      009CCC 55 19 01 08 D3 16     1074 fmt_select: .word fmt_impl_no_arg,fmt_impl_1_r,fmt_impl_2_r 
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
      009CD2 19 07            [ 2]    4     sub sp,#LOCAL_SIZE
      009CD4 08 D4            [ 1] 1082     clrw y 
      009CD6 04 19            [ 2] 1083     ldw (DEST,sp),y
      009CD8 01 08            [ 2] 1084     ldw (SRC,sp),y 
      009CDA D5 06            [ 1] 1085     clr (FMT,sp)
      009CDC 19 01            [ 2] 1086     ldw y,(STRUCT,sp)
      009CDE 08 D6 3D         [ 4] 1087     call ld_mnemonic
      009CE1 19 01 08         [ 1] 1088     ld a,(FIELD_DEST,y)
      009CE4 D8 69            [ 1] 1089     jreq 1$
      009CE6 19 01            [ 1] 1090     inc (FMT,sp)
      009CE8 08 D9 01 19      [ 2] 1091     ldw y,#reg_index 
      009CEC 01 08 DA         [ 4] 1092     call ld_table_entry
      009CEF 45 19            [ 2] 1093     ldw (DEST,sp),y 
      009CF1 01 08            [ 2] 1094     ldw y,(STRUCT,sp)
      009CF3 DB 02 19         [ 1] 1095 1$: ld a, (FIELD_SRC,y)
      009CF6 01 08            [ 1] 1096     jreq 2$
      009CF8 DE 3F            [ 1] 1097     inc (FMT,sp)
      009CFA 19 08 08 D7      [ 2] 1098     ldw y,#reg_index
      009CFE 3D 1B 08         [ 4] 1099     call ld_table_entry
      009D01 01 AF            [ 2] 1100     ldw (SRC,sp),y 
      009D03 3E 1A 01 08      [ 2] 1101 2$: ldw y,#fmt_select 
      009D07 A7 3E            [ 1] 1102     ld a,(FMT,sp)
      009D09 1C 08 01         [ 4] 1103     call ld_table_entry 
      009D0C CE 3F 15         [ 4] 1104     call format     
      000FBA                       1105 _fn_exit 
      009D0F 08 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      009D11 CF               [ 4]    2     ret
                                   1106 
                                   1107 ;---------------------------
                                   1108 ; form: op #imm8 
                                   1109 ;---------------------------
      009D12 3F 17 00 08 DF 3F 1B  1110 fmt_op_imm8: .asciz "%a%s\t#%b"
             08 07
                           000001  1111     SPC=1
                           000002  1112     MNEMO=2
                           000004  1113     IMM8=4
      000FC6                       1114 _fn_entry 4 fn_imm8 
                           000004     1     LOCAL_SIZE = 4
                           000007     2     STRUCT=3+LOCAL_SIZE
      000FC6                          3 fn_imm8:
      009D1B 60 42            [ 2]    4     sub sp,#LOCAL_SIZE
      009D1D 26 08 00         [ 4] 1115     call get_int8
      009D20 63 14            [ 1] 1116     ld (IMM8,sp),a 
      009D22 26 08            [ 2] 1117     ldw y,(STRUCT,sp)
      009D24 00 64 5E         [ 4] 1118     call ld_mnemonic
      009D27 26 08 00 66      [ 2] 1119     ldw y,#fmt_op_imm8 
      009D2B 51 26 08         [ 4] 1120     call format 
      000FD9                       1121 _fn_exit
      009D2E 00 67            [ 2]    1     addw sp,#LOCAL_SIZE 
      009D30 5C               [ 4]    2     ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                                   1122 
                                   1123 ;----------------------------
                                   1124 ; form op rel8 
                                   1125 ; jpr or callr 
                                   1126 ;----------------------------
      000FDC                       1127 jrxx_opcode: 
      009D31 26 08 00 68 59 26 08  1128     .word M.JRA,M.JRF,M.JRUGT,M.JRULE,M.JRNC,M.JRC,M.JRNE,M.JREQ
             00 69 4E 26 08 00 6A
             17 26
      009D41 08 00 6C 1E 26 08 00  1129     .word M.JRNV,M.JRV,M.JRPL,M.JRMI,M.JRSGT,M.JRSLE,M.JRSGE,M.JRSLT
             6D 64 26 08 00 6E 62
             26 08
      000FFC                       1130 jrxx_90_opcode:  
      009D51 00 6F 11 26 08 00 DC  1131     .word M.JRNH,M.JRH,0,0,M.JRNM,M.JRM,M.JRIL,M.JRIH    
             22 26 08 00 DD 0D 26
             08 00
      009D61 00 00 00 00 00 25 65  1132 fmt_op_rel8: .asciz "%a%s\t%e"
             00
                           000001  1133     SPC=1 
                           000002  1134     MNEMO=2
                           000004  1135     ADR24 = 4
                           000007  1136     CODE=7
      009D66                       1137 _fn_entry 7 fn_rel8
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001014                          3 fn_rel8:
      009D66 C0 60            [ 2]    4     sub sp,#LOCAL_SIZE
      009D68 15 01            [ 1] 1138     ld (CODE,sp),a
      009D6A 00               [ 1] 1139     swap a 
      009D6B C1 13            [ 1] 1140     and a,#0xf 
      009D6D 15 01            [ 1] 1141     jreq 0$
      009D6F 00 C2            [ 1] 1142     ld a,#12
      009D71 55 15            [ 2] 1143     jra 3$
      009D73 01 00            [ 1] 1144 0$: ld a,#16
      009D75 C3 16            [ 1] 1145 3$: ld (SPC,sp),a 
      009D77 15 07 00         [ 4] 1146     call get_int8 
      009D7A C4 04 15         [ 4] 1147     call abs_addr
      009D7D 01 00 C5 06      [ 2] 1148     ldw y,acc24 
      009D81 15 01 00         [ 1] 1149     ld a,acc8 
      009D84 C6 3D            [ 2] 1150     ldw (ADR24,sp),y 
      009D86 15 01            [ 1] 1151     ld (ADR24+2,sp),a
      009D88 00 C8 69 15      [ 2] 1152     ldw y,#jrxx_opcode 
      009D8C 01 00            [ 1] 1153     ld a,(CODE,sp)
      009D8E C9 01            [ 1] 1154     and a,#0xf0 
      009D90 15 01            [ 1] 1155     jreq 1$
      009D92 00 CA 45 15      [ 2] 1156     ldw y,#jrxx_90_opcode
      009D96 01 00            [ 1] 1157 1$: ld a,(CODE,sp)
      009D98 CB 02            [ 1] 1158     and a,#0xf
      009D9A 15 01 00 CE      [ 2] 1159     cpw y,#jrxx_opcode 
      009D9E 3F 15            [ 1] 1160     jreq 2$
      009DA0 01 00            [ 1] 1161     sub a,#8
      009DA2 D0               [ 1] 1162 2$: sll a 
      009DA3 60 19 01         [ 1] 1163     ld acc8,a 
      009DA6 07 D1 13 19      [ 1] 1164     clr acc16 
      009DAA 01 07 D2 55      [ 2] 1165     addw y,acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



      009DAE 19 01            [ 2] 1166     ldw y,(y)
      009DB0 07 D3            [ 2] 1167     ldw (MNEMO,sp),y 
      009DB2 16 19 08 07      [ 2] 1168     ldw y,#fmt_op_rel8
      009DB6 D4 04 19         [ 4] 1169     call format  
      001067                       1170 _fn_exit 
      009DB9 01 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      009DBB D5               [ 4]    2     ret
                                   1171 
                                   1172 ;----------------------------
                                   1173 ; form op adr8 
                                   1174 ; exemple: clr 0xC0 
                                   1175 ;----------------------------
      009DBC 06 19 01 07 D6 3D 19  1176 fmt_op_adr8: .asciz "%a%s\t%e"
             01
                           000001  1177     SPC=1
                           000002  1178     MNEMO=2
                           000004  1179     ADR8=4
      001072                       1180 _fn_entry 6 fn_adr8 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001072                          3 fn_adr8:
      009DC4 07 D8            [ 2]    4     sub sp,#LOCAL_SIZE
      009DC6 69 19 01         [ 4] 1181     call get_int8 
      009DC9 07 D9            [ 1] 1182     ld (ADR8+2,sp),a
      009DCB 01 19            [ 1] 1183     clrw y 
      009DCD 01 07            [ 2] 1184     ldw (ADR8,sp),y  
      009DCF DA 45            [ 2] 1185     ldw y,(STRUCT,sp)
      009DD1 19 01 07         [ 1] 1186     ld a,(FIELD_MNEMO,y)
      009DD4 DB 02            [ 1] 1187     cp a,#IDX.CALLR 
      009DD6 19 01            [ 1] 1188     jrne 1$
      009DD8 07 DE            [ 1] 1189     ld a,(ADR8+2,sp)
      009DDA 3F 19 01         [ 4] 1190     call abs_addr
      009DDD 07 C7 3D 17      [ 2] 1191     ldw y,acc24  
      009DE1 00 01            [ 2] 1192     ldw (ADR8,sp),y 
      009DE3 CF 3F 17         [ 1] 1193     ld a,acc24+2 
      009DE6 00 07            [ 1] 1194     ld (ADR8+2,sp),a 
      009DE8 D7 3D            [ 2] 1195     ldw y,(STRUCT,sp)
      001098                       1196 1$:     
      009DEA 1B 07 01         [ 4] 1197     call ld_mnemonic
      009DED DF 3F 1B 07      [ 2] 1198     ldw y,#fmt_op_adr8 
      009DF1 08 AF 3E         [ 4] 1199     call format 
      0010A2                       1200 _fn_exit 
      009DF4 1A 01            [ 2]    1     addw sp,#LOCAL_SIZE 
      009DF6 07               [ 4]    2     ret
                                   1201 
                                   1202 ;----------------------------
                                   1203 ; form op adr16 
                                   1204 ; jp or call 
                                   1205 ;----------------------------
      009DF7 A7 3E 1C 07 01 BC 3E  1206 fmt_op_adr16: .asciz "%a%s\t%w" 
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
      009DFF 01 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E01 BD 3E 18         [ 4] 1211     call get_int16 
      009E04 00 01            [ 2] 1212     ldw (ADR16,sp),y 
      009E06 8D 0E            [ 2] 1213     ldw y,(STRUCT,sp)
      009E08 23 00 00         [ 4] 1214     call ld_mnemonic
      009E0B AC 23 23 00      [ 2] 1215     ldw y,#fmt_op_adr16 
      009E0F 00 30 42         [ 4] 1216     call format 
      0010C0                       1217 _fn_exit 
      009E12 24 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E14 00               [ 4]    2     ret
                                   1218 
                                   1219 ;----------------------------
                                   1220 ; form op adr24 
                                   1221 ; jpf or callf 
                                   1222 ;----------------------------
      009E15 33 14 24 00 00 34 5E  1223 fmt_op_adr24: .asciz "%a%s\t%e"
             24
                           000001  1224     SPC=1
                           000002  1225     MNEMO=2
                           000004  1226     ADR24=4 
      0010CB                       1227 _fn_entry 6 fn_adr24 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0010CB                          3 fn_adr24:
      009E1D 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E1F 36 51 24         [ 4] 1228     call get_int24
      009E22 00 00            [ 2] 1229     ldw (ADR24,sp),y 
      009E24 37 5C            [ 1] 1230     ld (ADR24+2,sp),a 
      009E26 24 00            [ 2] 1231     ldw y,(STRUCT,sp)
      009E28 00 38 59         [ 4] 1232     call ld_mnemonic
      009E2B 24 00 00 39      [ 2] 1233     ldw y,#fmt_op_adr24 
      009E2F 4E 24 00         [ 4] 1234     call format 
      0010E0                       1235 _fn_exit 
      009E32 00 3A            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E34 17               [ 4]    2     ret
                                   1236 
                                   1237 ;----------------------------
                                   1238 ;  form op adr8,r 
                                   1239 ;----------------------------
      009E35 24 00 00 3C 1E 24 00  1240 fmt_op_adr8_r: .asciz "%a%s\t%b,%s"
             00 3D 64 24
                           000001  1241     SPC=1
                           000002  1242     MNEMO=2
                           000004  1243     ADR8=4
                           000005  1244     REG=5 
      0010EE                       1245 _fn_entry 6 fn_adr8_r 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0010EE                          3 fn_adr8_r:
      009E40 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E42 3E 62 24         [ 4] 1246     call get_int8 
      009E45 00 00            [ 1] 1247     ld (ADR8,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



      009E47 3F 11            [ 2] 1248     ldw y,(STRUCT,sp)
      009E49 24 00 00         [ 4] 1249     call ld_mnemonic
      009E4C 60 42 26         [ 1] 1250     ld a,(FIELD_SRC,y)
      009E4F 07 00 63 14      [ 2] 1251     ldw y,#reg_index
      009E53 26 07 00         [ 4] 1252     call ld_table_entry
      009E56 64 5E            [ 2] 1253     ldw (REG,sp),y
      009E58 26 07 00 66      [ 2] 1254     ldw y,#fmt_op_adr8_r 
      009E5C 51 26 07         [ 4] 1255     call format 
      00110D                       1256 _fn_exit 
      009E5F 00 67            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E61 5C               [ 4]    2     ret
                                   1257 
                                   1258 ;----------------------------
                                   1259 ; form op adr16,r 
                                   1260 ;----------------------------
      009E62 26 07 00 68 59 26 07  1261 fmt_op_adr16_r: .asciz "%a%s\t%w,%s" 
             00 69 4E 26
                           000001  1262     SPC=1 
                           000002  1263     MNEMO=2
                           000004  1264     ADR16=4
                           000006  1265     REG=6 
      00111B                       1266 _fn_entry 7  fn_adr16_r
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00111B                          3 fn_adr16_r:
      009E6D 07 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E6F 6A 17 26         [ 4] 1267     call get_int16 
      009E72 07 00            [ 2] 1268     ldw (ADR16,sp),y 
      009E74 6C 1E            [ 2] 1269     ldw y,(STRUCT,sp)
      009E76 26 07 00         [ 4] 1270     call ld_mnemonic
      009E79 6D 64 26         [ 1] 1271     ld a,(FIELD_SRC,y)
      009E7C 07 00 6E 62      [ 2] 1272     ldw y,#reg_index 
      009E80 26 07 00         [ 4] 1273     call ld_table_entry
      009E83 6F 11            [ 2] 1274     ldw (REG,sp),y 
      009E85 26 07 00 ED      [ 2] 1275     ldw y,#fmt_op_adr16_r 
      009E89 0D 26 07         [ 4] 1276     call format 
      00113A                       1277 _fn_exit
      009E8C 00 DC            [ 2]    1     addw sp,#LOCAL_SIZE 
      009E8E 22               [ 4]    2     ret
                                   1278 
                                   1279 ;----------------------------
                                   1280 ; form op adr24,r  
                                   1281 ;----------------------------
      009E8F 26 07 00 DD 0D 26 07  1282 fmt_op_adr24_r: .asciz "%a%s\t%e,%s" 
             00 00 00 00
                           000001  1283     SPC=1
                           000002  1284     MNEMO=2
                           000004  1285     ADR24=4
                           000007  1286     REG=7
      001148                       1287 _fn_entry 8 fn_adr24_r 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      001148                          3 fn_adr24_r:
      009E9A 00 00            [ 2]    4     sub sp,#LOCAL_SIZE
      009E9C CD 18 79         [ 4] 1288     call get_int24 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



      009E9C 89 90            [ 2] 1289     ldw (ADR24,sp),y 
      009E9E 89 52            [ 1] 1290     ld (ADR24+2,sp),a 
      009EA0 01 CD            [ 2] 1291     ldw y,(STRUCT,sp)
      009EA2 86 99 C6         [ 4] 1292     call ld_mnemonic
      009EA5 00 5B 27         [ 1] 1293     ld a,(FIELD_SRC,y)
      009EA8 48 AE 00 AB      [ 2] 1294     ldw y,#reg_index 
      009EAC 90 AE 00         [ 4] 1295     call ld_table_entry
      009EAF AE CD            [ 2] 1296     ldw (REG,sp),y 
      009EB1 85 70 11 3D      [ 2] 1297     ldw y,#fmt_op_adr24_r 
      009EB3 CD 00 00         [ 4] 1298     call format 
      001169                       1299 _fn_exit 
      009EB3 A6 18            [ 2]    1     addw sp,#LOCAL_SIZE 
      009EB5 6B               [ 4]    2     ret
                                   1300 
                                   1301 ;----------------------------
                                   1302 ; form op r,adr8 
                                   1303 ; exemple:  ldw x,$50
                                   1304 ;----------------------------
      009EB6 01 61 25 73 09 25 73  1305 fmt_op_r_adr8: .asciz "%a%s\t%s,%b"
             2C 25 62 00
                           000001  1306     SPC=1
                           000002  1307     MNEMO=2
                           000004  1308     REG=4
                           000006  1309     ADR8 = 6
      009EB7                       1310 _fn_entry 6 fn_r_adr8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001177                          3 fn_r_adr8:
      009EB7 A6 0D            [ 2]    4     sub sp,#LOCAL_SIZE
      009EB9 CD 8F 2F         [ 4] 1311     call get_int8 
      009EBC AE 00            [ 1] 1312     ld (ADR8,sp),a 
      009EBE AE 90            [ 2] 1313     ldw y,(STRUCT,sp) 
      009EC0 AE 00 AB         [ 4] 1314     call ld_mnemonic
      009EC3 CD 85 70         [ 1] 1315     ld a,(FIELD_DEST,y)
      009EC6 A6 06 97 A6      [ 2] 1316     ldw y,#reg_index 
      009ECA 10 CD 8F         [ 4] 1317     call ld_table_entry
      009ECD 9D A6            [ 2] 1318     ldw (REG,sp),y 
      009ECF 09 CD 8F 2F      [ 2] 1319     ldw y,#fmt_op_r_adr8 
      009ED3 CD 9E FA         [ 4] 1320     call format 
      001196                       1321 _fn_exit 
      009ED6 4F 72            [ 2]    1     addw sp,#LOCAL_SIZE 
      009ED8 BB               [ 4]    2     ret
                                   1322 
                                   1323 ;----------------------------
                                   1324 ; form op r,adr16 
                                   1325 ; exemple:  ldw x,$5000 
                                   1326 ;----------------------------
      009ED9 00 AF C9 00 AE C7 00  1327 fmt_op_r_adr16: .asciz "%a%s\t%s,%w" 
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
      009EE4 0A 01            [ 2]    4     sub sp,#LOCAL_SIZE
      009EE6 26 CF CD         [ 4] 1333     call get_int16 
      009EE9 8F 5C            [ 2] 1334     ldw (ADR16,sp),y 
      009EEB A1 20            [ 2] 1335     ldw y,(STRUCT,sp) 
      009EED 27 C4 20         [ 4] 1336     call ld_mnemonic
      009EF0 03 E6 03         [ 1] 1337     ld a,(FIELD_DEST,y)
      009EF1 90 AE 02 BC      [ 2] 1338     ldw y,#reg_index 
      009EF1 CD 8B 47         [ 4] 1339     call ld_table_entry
      009EF4 17 04            [ 2] 1340     ldw (REG,sp),y 
      009EF4 90 85 85 5B      [ 2] 1341     ldw y,#fmt_op_r_adr16 
      009EF8 01 81 00         [ 4] 1342     call format 
      009EFA                       1343 _fn_exit 
      009EFA 52 02            [ 2]    1     addw sp,#LOCAL_SIZE 
      009EFC 5F               [ 4]    2     ret
                                   1344 
                                   1345 ;----------------------------
                                   1346 ; form op r,adr24 
                                   1347 ; exemple:  ldf a,$12000  
                                   1348 ;----------------------------
      009EFD CD A8 C1 6B 02 CD 9F  1349 fmt_op_r_adr24: .asciz "%a%s\t%s,%e" 
             D0 6B 01 A1
                           000001  1350     SPC=1
                           000002  1351     MNEMO=2
                           000004  1352     REG=4    
                           000006  1353     ADR24 = 6
      0011D1                       1354 _fn_entry 8 fn_r_adr24 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      0011D1                          3 fn_r_adr24:
      009F08 00 26            [ 2]    4     sub sp,#LOCAL_SIZE
      009F0A 18 A6 F0         [ 4] 1355     call get_int24 
      009F0D 14 02            [ 2] 1356     ldw (ADR24,sp),y
      009F0F A1 20            [ 1] 1357     ld (ADR24+2,sp),a  
      009F11 26 0A            [ 2] 1358     ldw y,(STRUCT,sp) 
      009F13 7B 02 A4         [ 4] 1359     call ld_mnemonic
      009F16 0F CD A0         [ 1] 1360     ld a,(FIELD_DEST,y)
      009F19 9C CC 9F AB      [ 2] 1361     ldw y,#reg_index
      009F1D CD 18 D1         [ 4] 1362     call ld_table_entry
      009F1D 90 AE            [ 2] 1363     ldw (REG,sp),y 
      009F1F 93 D9 20 62      [ 2] 1364     ldw y,#fmt_op_r_adr24 
      009F23 CD A8 C1         [ 4] 1365     call format 
      0011F2                       1366 _fn_exit 
      009F26 6B 02            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F28 7B               [ 4]    2     ret
                                   1367 
                                   1368 ;----------------------------
                                   1369 ; register indexed without offset 
                                   1370 ; form: op r,(r)
                                   1371 ; form: op (r)
                                   1372 ;----------------------------
      009F29 01 A1 72 26 24 7B 02  1373 fmt_op_idx: .asciz "%a%s\t(%s)"
             A4 F0 26
      009F33 0A 7B 02 A4 0F CD A3  1374 fmt_op_r_idx: .asciz "%a%s\t%s,(%s)"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal  44-Bits]



             2C 28 25 73 29 00
      009F3B CC 9F AB FF           1375 fmt_sel2: .word fmt_op_idx,fmt_op_r_idx 
                           000001  1376     SPC=1
                           000002  1377     MNEMO=2
                           000004  1378     DEST=4
                           000006  1379     SRC=6
                           000008  1380     FMT=8 
      009F3E                       1381 _fn_entry 8 fn_r_idx
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      001210                          3 fn_r_idx:
      009F3E A1 10            [ 2]    4     sub sp,#LOCAL_SIZE
      009F40 26 0A            [ 1] 1382     clr (FMT,sp)
      009F42 7B 02            [ 2] 1383     ldw y,(STRUCT,sp)
      009F44 A4 0F CD         [ 4] 1384     call ld_mnemonic
      009F47 A3 9B CC         [ 1] 1385     ld a,(FIELD_DEST,y)
      009F4A 9F AB 02 BC      [ 2] 1386     ldw y,#reg_index
      009F4C CD 18 D1         [ 4] 1387     call ld_table_entry
      009F4C 90 AE            [ 2] 1388     ldw (DEST,sp),y
      009F4E 98 7A            [ 2] 1389     ldw y,(STRUCT,sp)
      009F50 20 33 A1         [ 1] 1390     ld a,(FIELD_SRC,y)
      009F53 90 26            [ 1] 1391     jreq 1$
      009F55 21 7B            [ 1] 1392     inc (FMT,sp)
      009F57 02 A4 F0 A1      [ 2] 1393 1$: ldw y,#reg_index
      009F5B 10 26 08         [ 4] 1394     call ld_table_entry
      009F5E 7B 02            [ 2] 1395     ldw (SRC,sp),y 
      009F60 CD A3            [ 1] 1396     ld a,(FMT,sp)
      009F62 9B CC 9F AB      [ 2] 1397     ldw y,#fmt_sel2
      009F66 CD 18 D1         [ 4] 1398     call ld_table_entry 
      009F66 A1 20 26         [ 4] 1399     call format 
      001243                       1400 _fn_exit 
      009F69 07 7B            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F6B 02               [ 4]    2     ret
                                   1401 
                                   1402 ;----------------------------
                                   1403 ; register indexed without offset 
                                   1404 ; form: op (r),r
                                   1405 ;----------------------------
      009F6C CD A0 9C 20 3A 28 25  1406 fmt_op_idx_r: .asciz "%a%s\t(%s),%s"
             73 29 2C 25 73 00
                           000001  1407     SPC=1
                           000002  1408     MNEMO=2
                           000004  1409     DEST=4
                           000006  1410     SRC=6
      009F71                       1411 _fn_entry 7 fn_idx_r 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001253                          3 fn_idx_r:
      009F71 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      009F73 9A 64            [ 2] 1412     ldw y,(STRUCT,sp)
      009F75 20 0E A1         [ 4] 1413     call ld_mnemonic
      009F78 91 26 06         [ 1] 1414     ld a,(FIELD_DEST,y)
      009F7B 90 AE 9C C1      [ 2] 1415     ldw y,#reg_index 
      009F7F 20 04 90         [ 4] 1416     call ld_table_entry
      009F82 AE 9D            [ 2] 1417     ldw (DEST,sp),y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
Hexadecimal [24-Bits]



      009F84 66 7B            [ 2] 1418     ldw y,(STRUCT,sp)
      009F86 02 AD 2A         [ 1] 1419     ld a,(FIELD_SRC,y)
      009F89 72 05 00 B1      [ 2] 1420     ldw y,#reg_index 
      009F8D 12 90 89         [ 4] 1421     call ld_table_entry
      009F90 90 E6            [ 2] 1422     ldw (SRC,sp),y 
      009F92 02 90 AE 93      [ 2] 1423     ldw y,#fmt_op_idx_r 
      009F96 8B CD A9         [ 4] 1424     call format 
      00127B                       1425 _fn_exit 
      009F99 59 90            [ 2]    1     addw sp,#LOCAL_SIZE 
      009F9B FD               [ 4]    2     ret
                                   1426 
                                   1427 ;----------------------------
                                   1428 ;  decode format: op (ofs8,r)
                                   1429 ;----------------------------
      009F9C 90 85 20 0B 09 28 25  1430 fmt_op_ofs8_idx: .asciz "%a%s\t(%b,%s)"
             62 2C 25 73 29 00
                           000001  1431     SPC=1
                           000002  1432     MNEMO=2
                           000004  1433     OFS8=4  ; byte offset value 
                           000005  1434     REG=5 ;   pointer to register name
      009FA0                       1435 _fn_entry 6 fn_ofs8_idx 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      00128B                          3 fn_ofs8_idx:
      009FA0 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      009FA2 9F AE 90         [ 4] 1436     call get_int8 
      009FA5 89 CD            [ 1] 1437     ld (OFS8,sp),a 
      009FA7 A0 05            [ 2] 1438     ldw y,(STRUCT,sp)
      009FA9 90 85 E4         [ 4] 1439     call ld_mnemonic
      009FAB 90 E6 03         [ 1] 1440     ld a,(FIELD_DEST,y)
      009FAB 5B 02 81 00      [ 2] 1441     ldw y,#reg_index 
      009FAF 6A 00 00         [ 4] 1442     call ld_table_entry
      009FB2 00 05            [ 2] 1443     ldw (REG,sp),y 
      009FB3 90 AE 12 7E      [ 2] 1444     ldw y,#fmt_op_ofs8_idx
      009FB3 88 72 14         [ 4] 1445     call format 
      0012AA                       1446     _fn_exit
      009FB6 00 B1            [ 2]    1     addw sp,#LOCAL_SIZE 
      009FB8 90               [ 4]    2     ret
                                   1447 
                                   1448 ;--------------------------------
                                   1449 ; decode form: op adr16,#bit,rel 
                                   1450 ;--------------------------------
      009FB9 E6 01 27 0D 90 E6 00  1451 fmt_op_adr16_bit_rel: .asciz "%a%s\t%w,#%c,%e" 
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
      009FC8 20 EE            [ 2]    4     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]



      009FCA 72 15            [ 1] 1458     ld (BIT,sp),a 
      009FCC 00 B1 84         [ 4] 1459     call get_int16
      009FCF 81 04            [ 2] 1460     ldw (ADR16,sp),y
      009FD0 CD 18 39         [ 4] 1461     call get_int8
      009FD0 88 90 AE         [ 4] 1462     call abs_addr
      009FD3 9F E2 90 F6      [ 2] 1463     ldw y,acc24
      009FD7 27 06 90         [ 1] 1464     ld a,acc8 
      009FDA 5C 11            [ 2] 1465     ldw (REL,sp),y
      009FDC 01 26            [ 1] 1466     ld (REL+2,sp),a
      009FDE F6 5B            [ 1] 1467     ld a,#4
      009FE0 01 81            [ 1] 1468     ld (SPC,sp),a 
      009FE2 72 90            [ 1] 1469     ld a,(BIT,sp)
      009FE4 91 92            [ 1] 1470     and a,#1
      009FE6 00 25            [ 1] 1471     jreq 2$
      009FE8 61 25 73 00      [ 2] 1472     ldw y,#M.BTJF 
      009FEC 25 61            [ 2] 1473     jra 3$
      009FEE 25 73 09 25      [ 2] 1474 2$: ldw y,#M.BTJT    
      009FF2 73 00            [ 2] 1475 3$: ldw (MNEMO,sp),y   
      009FF4 25 61            [ 1] 1476     ld a,(BIT,sp)
      009FF6 25               [ 1] 1477     srl a 
      009FF7 73 09            [ 1] 1478     and a,#7 
      009FF9 25 73            [ 1] 1479     add a,#'0 
      009FFB 2C 25            [ 1] 1480     ld (BIT,sp),a
      009FFD 73 00 9F E7      [ 2] 1481     ldw y,#fmt_op_adr16_bit_rel
      00A001 9F EC 9F         [ 4] 1482     call format
      0012FC                       1483 _fn_exit
      00A004 F4 09            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A005 81               [ 4]    2     ret
                                   1484 
                                   1485 ;--------------------------------------
                                   1486 ; decode form:  op adr16,#bit 
                                   1487 ;--------------------------------------
      00A005 52 08 90 5F 17 04 17  1488 bitop: .word M.BSET,M.BRES,M.BCPL,M.BCCM 
             06
      00A00D 0F 08 16 0B CD A9 6C  1489 fmt_adr16_bit: .asciz "%a%s\t%w,#%c" ;
             90 E6 03 27 0D
                           000001  1490     SPC=1
                           000002  1491     MNEMO=2
                           000004  1492     ADR16=4
                           000006  1493     BIT=6 
      001313                       1494 _fn_entry 6 fn_adr16_bit 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001313                          3 fn_adr16_bit:
      00A019 0C 08            [ 2]    4     sub sp,#LOCAL_SIZE
      00A01B 90 AE            [ 1] 1495     ld (BIT,sp),a
      00A01D 93 44            [ 1] 1496     ld a,#8
      00A01F CD A9            [ 1] 1497     ld (SPC,sp),a  
      00A021 59 17 04         [ 4] 1498     call get_int16
      00A024 16 0B            [ 2] 1499     ldw (ADR16,sp),y 
      00A026 90 E6 04 27      [ 2] 1500     ldw y,#bitop 
      00A02A 0B 0C            [ 1] 1501     ld a,(BIT,sp)
      00A02C 08 90            [ 1] 1502     and a,#1 
      00A02E AE 93            [ 1] 1503     jreq 1$
      00A030 44 CD A9 59      [ 2] 1504     addw y,#2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]



      00A034 17 06            [ 1] 1505 1$: ld a,(BIT,sp)
      00A036 90 AE            [ 1] 1506     and a,#0xf0 
      00A038 9F FF            [ 1] 1507     jreq 2$
      00A03A 7B 08 CD A9      [ 2] 1508     addw y,#4
      00A03E 59 CD            [ 2] 1509 2$: ldw y,(y)
      00A040 8E 80            [ 2] 1510     ldw (MNEMO,sp),y 
      00A042 5B 08            [ 1] 1511     ld a,(BIT,sp)  
      00A044 81               [ 1] 1512     srl a 
      00A045 25 61            [ 1] 1513     and a,#7 
      00A047 25 73            [ 1] 1514     add a,#'0
      00A049 09 23            [ 1] 1515     ld (BIT,sp),a
      00A04B 25 62 00 07      [ 2] 1516     ldw y,#fmt_adr16_bit 
      00A04E CD 00 00         [ 4] 1517     call format 
      00134C                       1518 _fn_exit
      00A04E 52 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A050 CD               [ 4]    2     ret
                                   1519 
                                   1520 ;---------------------------------
                                   1521 ; decode form  op r,(ofs8,r)
                                   1522 ;---------------------------------
      00A051 A8 C1 6B 04 16 07 CD  1523 fmt_r_ofs8_idx: .asciz "%a%s\t%s,(%b,%s)"
             A9 6C 90 AE A0 45 CD
             8E 80
                           000001  1524     SPC=1
                           000002  1525     MNEMO=2
                           000004  1526     DEST=4
                           000006  1527     OFS8=6
                           000007  1528     SRC=7 
      00135F                       1529 _fn_entry 8 fn_r_ofs8_idx 
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      00135F                          3 fn_r_ofs8_idx:
      00A061 5B 04            [ 2]    4     sub sp,#LOCAL_SIZE
      00A063 81 18 39         [ 4] 1530     call get_int8
      00A064 6B 06            [ 1] 1531     ld (OFS8,sp),a 
      00A064 91 FE            [ 2] 1532     ldw y,(STRUCT,sp)
      00A066 92 0B 92         [ 4] 1533     call ld_mnemonic
      00A069 66 92 6C         [ 1] 1534     ld a,(FIELD_DEST,y)
      00A06C 92 26 92 02      [ 2] 1535     ldw y,#reg_index
      00A070 92 2B 92         [ 4] 1536     call ld_table_entry
      00A073 06 92            [ 2] 1537     ldw (DEST,sp),y
      00A075 3A 92            [ 2] 1538     ldw y,(STRUCT,sp)
      00A077 78 92 3F         [ 1] 1539     ld a,(FIELD_SRC,y)
      00A07A 92 21 92 4A      [ 2] 1540     ldw y,#reg_index
      00A07E 92 50 92         [ 4] 1541     call ld_table_entry
      00A081 44 92            [ 2] 1542     ldw (SRC,sp),y
      00A083 56 AE 13 4F      [ 2] 1543     ldw y,#fmt_r_ofs8_idx 
      00A084 CD 00 00         [ 4] 1544     call format 
      00138C                       1545 _fn_exit
      00A084 92 30            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A086 92               [ 4]    2     ret
                                   1546 
                                   1547 ;---------------------------------
                                   1548 ; form  op (ofs8,r),r
                                   1549 ;---------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]



      00A087 0F 00 00 00 00 92 35  1550 fmt_op_ofs8_idx_r: .asciz "%a%s\t(%b,%s),%s"
             92 1D 92 18 92 13 25
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
      00A097 73 09            [ 2]    4     sub sp,#LOCAL_SIZE
      00A099 25 65 00         [ 4] 1557     call get_int8 
      00A09C 6B 04            [ 1] 1558     ld (OFS8,sp),a 
      00A09C 52 07            [ 2] 1559     ldw y,(STRUCT,sp)
      00A09E 6B 07 4E         [ 4] 1560     call ld_mnemonic
      00A0A1 A4 0F 27         [ 1] 1561     ld a,(FIELD_DEST,y)
      00A0A4 04 A6 0C 20      [ 2] 1562     ldw y,#reg_index 
      00A0A8 02 A6 10         [ 4] 1563     call ld_table_entry
      00A0AB 6B 01            [ 2] 1564     ldw (DEST,sp),y 
      00A0AD CD A8            [ 2] 1565     ldw y,(STRUCT,sp)
      00A0AF C1 CD A9         [ 1] 1566     ld a,(FIELD_SRC,y)
      00A0B2 29 90 CE 00      [ 2] 1567     ldw y,#reg_index 
      00A0B6 AB C6 00         [ 4] 1568     call ld_table_entry
      00A0B9 AD 17            [ 2] 1569     ldw (SRC,sp),y 
      00A0BB 04 6B 06 90      [ 2] 1570     ldw y,#fmt_op_ofs8_idx_r
      00A0BF AE A0 64         [ 4] 1571     call format 
      0013CC                       1572 _fn_exit 
      00A0C2 7B 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A0C4 A4               [ 4]    2     ret
                                   1573 
                                   1574 ;---------------------------------
                                   1575 ;  decode form   op r,#imm8 
                                   1576 ;---------------------------------
      00A0C5 F0 27 04 90 AE A0 84  1577 fmt_r_imm8: .asciz "%a%s\t%s,#%b" 
             7B 07 A4 0F 90
                           000001  1578     SPC=1
                           000002  1579     MNEMO=2
                           000004  1580     REG=4
                           000006  1581     IMM8=6
      0013DB                       1582 _fn_entry 6  fn_r_imm8 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0013DB                          3 fn_r_imm8:
      00A0D1 A3 A0            [ 2]    4     sub sp,#LOCAL_SIZE
      00A0D3 64 27 02         [ 4] 1583     call get_int8
      00A0D6 A0 08            [ 1] 1584     ld (IMM8,sp),a 
      00A0D8 48 C7            [ 2] 1585     ldw y,(STRUCT,sp)
      00A0DA 00 AD 72         [ 4] 1586     call ld_mnemonic 
      00A0DD 5F 00 AC         [ 1] 1587     ld a,(FIELD_DEST,y)
      00A0E0 72 B9 00 AC      [ 2] 1588     ldw y,#reg_index 
      00A0E4 90 FE 17         [ 4] 1589     call ld_table_entry
      00A0E7 02 90            [ 2] 1590     ldw (REG,sp),y 
      00A0E9 AE A0 94 CD      [ 2] 1591     ldw y,#fmt_r_imm8
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



      00A0ED 8E 80 5B         [ 4] 1592     call format 
      0013FA                       1593 _fn_exit
      00A0F0 07 81            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A0F2 25               [ 4]    2     ret
                                   1594 
                                   1595 ;---------------------------------
                                   1596 ;  decode form   op r,#imm16 
                                   1597 ;---------------------------------
      00A0F3 61 25 73 09 25 65 00  1598 fmt_r_imm16: .asciz "%a%s\t%s,#%w" 
             2C 23 25 77 00
                           000001  1599     SPC=1
                           000002  1600     MNEMO=2
                           000004  1601     DEST=4
                           000006  1602     IMM16=6
      00A0FA                       1603 _fn_entry 7 fn_r_imm16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001409                          3 fn_r_imm16:
      00A0FA 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A0FC CD A8 C1         [ 4] 1604     call get_int16
      00A0FF 6B 06            [ 2] 1605     ldw (IMM16,sp),y 
      00A101 90 5F            [ 2] 1606     ldw y,(STRUCT,sp)
      00A103 17 04 16         [ 4] 1607     call ld_mnemonic 
      00A106 09 90 E6         [ 1] 1608     ld a,(FIELD_DEST,y)
      00A109 01 A1 0F 26      [ 2] 1609     ldw y,#reg_index 
      00A10D 12 7B 06         [ 4] 1610     call ld_table_entry
      00A110 CD A9            [ 2] 1611     ldw (DEST,sp),y 
      00A112 29 90 CE 00      [ 2] 1612     ldw y,#fmt_r_imm16
      00A116 AB 17 04         [ 4] 1613     call format 
      001428                       1614 _fn_exit
      00A119 C6 00            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A11B AD               [ 4]    2     ret
                                   1615 
                                   1616 
                                   1617 ;---------------------------------
                                   1618 ;  form  op adr16,#imm8 
                                   1619 ;---------------------------------
      00A11C 6B 06 16 09 09 25 77  1620 fmt_op_adr16_imm8: .asciz "%a%s\t%w,#%b"
             2C 23 25 62 00
                           000001  1621     SPC=1
                           000002  1622     MNEMO=2
                           000004  1623     ADR16=4
                           000006  1624     IMM8=6
      00A120                       1625 _fn_entry 6 fn_adr16_imm8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001437                          3 fn_adr16_imm8:
      00A120 CD A9            [ 2]    4     sub sp,#LOCAL_SIZE
      00A122 6C 90 AE         [ 4] 1626     call get_int8 
      00A125 A0 F2            [ 1] 1627     ld (IMM8,sp),a 
      00A127 CD 8E 80         [ 4] 1628     call get_int16 
      00A12A 5B 06            [ 2] 1629     ldw (ADR16,sp),y 
      00A12C 81 25            [ 2] 1630     ldw Y,(STRUCT,sp)
      00A12E 61 25 73         [ 4] 1631     call ld_mnemonic 
      00A131 09 25 77 00      [ 2] 1632     ldw y,#fmt_op_adr16_imm8 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



      00A135 CD 00 00         [ 4] 1633     call format 
      00144F                       1634 _fn_exit 
      00A135 52 05            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A137 CD               [ 4]    2     ret
                                   1635 
                                   1636 ;---------------------------------
                                   1637 ;  form  op adr16,adr16 
                                   1638 ;---------------------------------
      00A138 A8 E2 17 04 16 08 CD  1639 fmt_op_adr16_adr16: .asciz "%a%s\t%w,%w"
             A9 6C 90 AE
                           000001  1640     SPC=1
                           000002  1641     MNEMO=2 
                           000004  1642     DEST16=4
                           000006  1643     SRC16=6
      00145D                       1644 _fn_entry 7 fn_adr16_adr16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00145D                          3 fn_adr16_adr16:
      00A143 A1 2D            [ 2]    4     sub sp,#LOCAL_SIZE
      00A145 CD 8E 80         [ 4] 1645     call get_int16 
      00A148 5B 05            [ 2] 1646     ldw (SRC16,sp),y
      00A14A 81 25 61         [ 4] 1647     call get_int16 
      00A14D 25 73            [ 2] 1648     ldw (DEST16,sp),y 
      00A14F 09 25            [ 2] 1649     ldw Y,(STRUCT,sp)
      00A151 65 00 E4         [ 4] 1650     call ld_mnemonic 
      00A153 90 AE 14 52      [ 2] 1651     ldw y,#fmt_op_adr16_adr16 
      00A153 52 06 CD         [ 4] 1652     call format 
      001475                       1653 _fn_exit 
      00A156 A9 01            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A158 17               [ 4]    2     ret
                                   1654 
                                   1655 ;---------------------------------
                                   1656 ;  form  op adr8,adr8  
                                   1657 ;---------------------------------
      00A159 04 6B 06 16 09 CD A9  1658 fmt_op_adr8_adr8: .asciz "%a%s\t%b,%b"
             6C 90 AE A1
                           000001  1659     SPC=1
                           000002  1660     MNEMO=2
                           000004  1661     DEST8=4
                           000005  1662     SRC8=5
      001483                       1663 _fn_entry 5 fn_adr8_adr8
                           000005     1     LOCAL_SIZE = 5
                           000008     2     STRUCT=3+LOCAL_SIZE
      001483                          3 fn_adr8_adr8:
      00A164 4B CD            [ 2]    4     sub sp,#LOCAL_SIZE
      00A166 8E 80 5B         [ 4] 1664     call get_int8 
      00A169 06 81            [ 1] 1665     ld (SRC8,sp),a 
      00A16B 25 61 25         [ 4] 1666     call get_int8 
      00A16E 73 09            [ 1] 1667     ld (DEST8,sp),a 
      00A170 25 62            [ 2] 1668     ldw Y,(STRUCT,sp)
      00A172 2C 25 73         [ 4] 1669     call ld_mnemonic 
      00A175 00 AE 14 78      [ 2] 1670     ldw y,#fmt_op_adr8_adr8 
      00A176 CD 00 00         [ 4] 1671     call format 
      00149B                       1672 _fn_exit 
      00A176 52 06            [ 2]    1     addw sp,#LOCAL_SIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



      00A178 CD               [ 4]    2     ret
                                   1673 
                                   1674 ;---------------------------------
                                   1675 ;   form op r,[ptr8]
                                   1676 ;---------------------------------
      00A179 A8 C1 6B 04 16 09 CD  1677 fmt_op_r_ptr8: .asciz "%a%s\t%s,[%b]"
             A9 6C 90 E6 04 90
                           000001  1678     SPC=1
                           000002  1679     MNEMO=2
                           000004  1680     REG=4
                           000006  1681     PTR8=6
      0014AB                       1682 _fn_entry 6 fn_r_ptr8
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0014AB                          3 fn_r_ptr8:
      00A186 AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A188 44 CD A9         [ 4] 1683     call get_int8 
      00A18B 59 17            [ 1] 1684     ld (PTR8,sp),a 
      00A18D 05 90            [ 2] 1685     ldw y,(STRUCT,sp)
      00A18F AE A1 6B         [ 4] 1686     call ld_mnemonic
      00A192 CD 8E 80         [ 1] 1687     ld a,(FIELD_DEST,y)
      00A195 5B 06 81 25      [ 2] 1688     ldw y,#reg_index 
      00A199 61 25 73         [ 4] 1689     call ld_table_entry
      00A19C 09 25            [ 2] 1690     ldw (REG,sp),y 
      00A19E 77 2C 25 73      [ 2] 1691     ldw y,#fmt_op_r_ptr8 
      00A1A2 00 00 00         [ 4] 1692     call format 
      00A1A3                       1693 _fn_exit 
      00A1A3 52 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A1A5 CD               [ 4]    2     ret
                                   1694 
                                   1695 
                                   1696 ;---------------------------------
                                   1697 ;   form op r,[ptr16]
                                   1698 ;---------------------------------
      00A1A6 A8 E2 17 04 16 0A CD  1699 fmt_op_r_ptr16: .asciz "%a%s\t%s,[%w]"
             A9 6C 90 E6 04 90
                           000001  1700     SPC=1
                           000002  1701     MNEMO=2
                           000004  1702     REG=4
                           000006  1703     PTR16=6
      0014DA                       1704 _fn_entry 7 fn_r_ptr16
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      0014DA                          3 fn_r_ptr16:
      00A1B3 AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A1B5 44 CD A9         [ 4] 1705     call get_int16 
      00A1B8 59 17            [ 2] 1706     ldw (PTR16,sp),y 
      00A1BA 06 90            [ 2] 1707     ldw y,(STRUCT,sp)
      00A1BC AE A1 98         [ 4] 1708     call ld_mnemonic
      00A1BF CD 8E 80         [ 1] 1709     ld a,(FIELD_DEST,y)
      00A1C2 5B 07 81 25      [ 2] 1710     ldw y,#reg_index
      00A1C6 61 25 73         [ 4] 1711     call ld_table_entry
      00A1C9 09 25            [ 2] 1712     ldw (REG,sp),y 
      00A1CB 65 2C 25 73      [ 2] 1713     ldw y,#fmt_op_r_ptr16 
      00A1CF 00 00 00         [ 4] 1714     call format 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



      00A1D0                       1715 _fn_exit 
      00A1D0 52 08            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A1D2 CD               [ 4]    2     ret
                                   1716 
                                   1717 ;---------------------------------
                                   1718 ;   form op [ptr8],r
                                   1719 ;---------------------------------
      00A1D3 A9 01 17 04 6B 06 16  1720 fmt_op_ptr8_r: .asciz "%a%s\t[%b],%s"
             0B CD A9 6C 90 E6
                           000001  1721     SPC=1
                           000002  1722     MNEMO=2
                           000004  1723     PTR8=4
                           000005  1724     SRC=5
      001509                       1725 _fn_entry 6 fn_ptr8_r
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      001509                          3 fn_ptr8_r:
      00A1E0 04 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A1E2 AE 93 44         [ 4] 1726     call get_int8 
      00A1E5 CD A9            [ 1] 1727     ld (PTR8,sp),a 
      00A1E7 59 17            [ 2] 1728     ldw y,(STRUCT,sp)
      00A1E9 07 90 AE         [ 4] 1729     call ld_mnemonic
      00A1EC A1 C5 CD         [ 1] 1730     ld a,(FIELD_SRC,y)
      00A1EF 8E 80 5B 08      [ 2] 1731     ldw y,#reg_index 
      00A1F3 81 25 61         [ 4] 1732     call ld_table_entry
      00A1F6 25 73            [ 2] 1733     ldw (SRC,sp),y 
      00A1F8 09 25 73 2C      [ 2] 1734     ldw y,#fmt_op_ptr8_r 
      00A1FC 25 62 00         [ 4] 1735     call format 
      00A1FF                       1736 _fn_exit 
      00A1FF 52 06            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A201 CD               [ 4]    2     ret
                                   1737 
                                   1738 
                                   1739 ;---------------------------------
                                   1740 ;   form op [ptr16],r
                                   1741 ;---------------------------------
      00A202 A8 C1 6B 06 16 09 CD  1742 fmt_op_ptr16_r: .asciz "%a%s\t[%w],%s"
             A9 6C 90 E6 03 90
                           000001  1743     SPC=1
                           000002  1744     MNEMO=2
                           000004  1745     PTR16=4
                           000006  1746     REG=6
      001538                       1747 _fn_entry 7 fn_ptr16_r
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001538                          3 fn_ptr16_r:
      00A20F AE 93            [ 2]    4     sub sp,#LOCAL_SIZE
      00A211 44 CD A9         [ 4] 1748     call get_int16 
      00A214 59 17            [ 2] 1749     ldw (PTR16,sp),y 
      00A216 04 90            [ 2] 1750     ldw y,(STRUCT,sp)
      00A218 AE A1 F4         [ 4] 1751     call ld_mnemonic
      00A21B CD 8E 80         [ 1] 1752     ld a,(FIELD_SRC,y)
      00A21E 5B 06 81 25      [ 2] 1753     ldw y,#reg_index
      00A222 61 25 73         [ 4] 1754     call ld_table_entry
      00A225 09 25            [ 2] 1755     ldw (REG,sp),y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



      00A227 73 2C 25 77      [ 2] 1756     ldw y,#fmt_op_ptr16_r 
      00A22B 00 00 00         [ 4] 1757     call format 
      00A22C                       1758 _fn_exit 
      00A22C 52 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A22E CD               [ 4]    2     ret
                                   1759 
                                   1760 ;---------------------------------
                                   1761 ;   form op r,([ptr8],r)
                                   1762 ;---------------------------------
      00A22F A8 E2 17 06 16 0A CD  1763 fmt_op_r_ptr8_idx: .asciz "%a%s\t%s,([%b],%s)"
             A9 6C 90 E6 03 90 AE
             93 44 CD A9
                           000001  1764     SPC=1
                           000002  1765     MNEMO=2
                           000004  1766     DEST=4
                           000006  1767     PTR8=6
                           000007  1768     SRC=7
      00156C                       1769 _fn_entry 8 fn_r_ptr8_idx  
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      00156C                          3 fn_r_ptr8_idx:
      00A241 59 17            [ 2]    4     sub sp,#LOCAL_SIZE
      00A243 04 90 AE         [ 4] 1770     call get_int8 
      00A246 A2 21            [ 1] 1771     ld (PTR8,sp),a 
      00A248 CD 8E            [ 2] 1772     ldw y,(STRUCT,sp)
      00A24A 80 5B 07         [ 4] 1773     call ld_mnemonic
      00A24D 81 25 61         [ 1] 1774     ld a,(FIELD_DEST,y)
      00A250 25 73 09 25      [ 2] 1775     ldw y,#reg_index 
      00A254 73 2C 25         [ 4] 1776     call ld_table_entry
      00A257 65 00            [ 2] 1777     ldw (DEST,sp),y 
      00A259 16 0B            [ 2] 1778     ldw y,(STRUCT,sp)
      00A259 52 08 CD         [ 1] 1779     ld a,(FIELD_SRC,y)
      00A25C A9 01 17 06      [ 2] 1780     ldw y,#reg_index 
      00A260 6B 08 16         [ 4] 1781     call ld_table_entry
      00A263 0B CD            [ 2] 1782     ldw (SRC,sp),y 
      00A265 A9 6C 90 E6      [ 2] 1783     ldw y,#fmt_op_r_ptr8_idx  
      00A269 03 90 AE         [ 4] 1784     call format 
      001599                       1785 _fn_exit 
      00A26C 93 44            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A26E CD               [ 4]    2     ret
                                   1786 
                                   1787 ;---------------------------------
                                   1788 ;   form op r,([ptr16],r)
                                   1789 ;---------------------------------
      00A26F A9 59 17 04 90 AE A2  1790 fmt_op_r_ptr16_idx: .asciz "%a%s\t%s,([%w],%s)"
             4E CD 8E 80 5B 08 81
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
      00A281 09 28            [ 2]    4     sub sp,#LOCAL_SIZE
      00A283 25 73 29         [ 4] 1797     call get_int16 
      00A286 00 25            [ 2] 1798     ldw (PTR16,sp),y 
      00A288 61 25            [ 2] 1799     ldw y,(STRUCT,sp)
      00A28A 73 09 25         [ 4] 1800     call ld_mnemonic
      00A28D 73 2C 28         [ 1] 1801     ld a,(FIELD_DEST,y)
      00A290 25 73 29 00      [ 2] 1802     ldw y,#reg_index
      00A294 A2 7D A2         [ 4] 1803     call ld_table_entry
      00A297 87 04            [ 2] 1804     ldw (DEST,sp),y
      00A298 16 0C            [ 2] 1805     ldw y,(STRUCT,sp) 
      00A298 52 08 0F         [ 1] 1806     ld a,(FIELD_SRC,y)
      00A29B 08 16 0B CD      [ 2] 1807     ldw y,#reg_index
      00A29F A9 6C 90         [ 4] 1808     call ld_table_entry
      00A2A2 E6 03            [ 2] 1809     ldw (SRC,sp),y 
      00A2A4 90 AE 93 44      [ 2] 1810     ldw y,#fmt_op_r_ptr16_idx  
      00A2A8 CD A9 59         [ 4] 1811     call format 
      0015DB                       1812 _fn_exit 
      00A2AB 17 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A2AD 16               [ 4]    2     ret
                                   1813 
                                   1814 ;---------------------------------
                                   1815 ;   form op ([ptr8],r),r
                                   1816 ;---------------------------------
      00A2AE 0B 90 E6 04 27 02 0C  1817 fmt_op_ptr8_idx_r: .asciz "%a%s\t([%b],%s),%s"
             08 90 AE 93 44 CD A9
             59 17 06 7B
                           000001  1818     SPC=1
                           000002  1819     MNEMO=2
                           000004  1820     PTR8=4
                           000005  1821     DEST=5
                           000007  1822     SRC=7
      0015F0                       1823 _fn_entry 8 fn_ptr8_idx_r
                           000008     1     LOCAL_SIZE = 8
                           00000B     2     STRUCT=3+LOCAL_SIZE
      0015F0                          3 fn_ptr8_idx_r:
      00A2C0 08 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A2C2 AE A2 94         [ 4] 1824     call get_int8 
      00A2C5 CD A9            [ 1] 1825     ld (PTR8,sp),a 
      00A2C7 59 CD            [ 2] 1826     ldw y,(STRUCT,sp)
      00A2C9 8E 80 5B         [ 4] 1827     call ld_mnemonic
      00A2CC 08 81 25         [ 1] 1828     ld a,(FIELD_DEST,y)
      00A2CF 61 25 73 09      [ 2] 1829     ldw y,#reg_index 
      00A2D3 28 25 73         [ 4] 1830     call ld_table_entry
      00A2D6 29 2C            [ 2] 1831     ldw (DEST,sp),y 
      00A2D8 25 73            [ 2] 1832     ldw y,(STRUCT,sp)
      00A2DA 00 E6 04         [ 1] 1833     ld a,(FIELD_SRC,y)
      00A2DB 90 AE 02 BC      [ 2] 1834     ldw y,#reg_index 
      00A2DB 52 07 16         [ 4] 1835     call ld_table_entry
      00A2DE 0A CD            [ 2] 1836     ldw (SRC,sp),y 
      00A2E0 A9 6C 90 E6      [ 2] 1837     ldw y,#fmt_op_ptr8_idx_r 
      00A2E4 03 90 AE         [ 4] 1838     call format 
      00161D                       1839 _fn_exit 
      00A2E7 93 44            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A2E9 CD               [ 4]    2     ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



                                   1840 
                                   1841 ;---------------------------------
                                   1842 ;   form op ([ptr16],r),r
                                   1843 ;---------------------------------
      00A2EA A9 59 17 04 16 0A 90  1844 fmt_op_ptr16_idx_r: .asciz "%a%s\t([%w],%s),%s"
             E6 04 90 AE 93 44 CD
             A9 59 17 06
                           000001  1845     SPC=1
                           000002  1846     MNEMO=2
                           000004  1847     PTR16=4
                           000006  1848     DEST=6
                           000008  1849     SRC=8
      001632                       1850 _fn_entry 9 fn_ptr16_idx_r 
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      001632                          3 fn_ptr16_idx_r:
      00A2FC 90 AE            [ 2]    4     sub sp,#LOCAL_SIZE
      00A2FE A2 CE CD         [ 4] 1851     call get_int16
      00A301 8E 80            [ 2] 1852     ldw (PTR16,sp),y
      00A303 5B 07            [ 2] 1853     ldw y,(STRUCT,sp)
      00A305 81 25 61         [ 4] 1854     call ld_mnemonic
      00A308 25 73 09         [ 1] 1855     ld a,(FIELD_DEST,y)
      00A30B 28 25 62 2C      [ 2] 1856     ldw y,#reg_index 
      00A30F 25 73 29         [ 4] 1857     call ld_table_entry
      00A312 00 06            [ 2] 1858     ldw (DEST,sp),y 
      00A313 16 0C            [ 2] 1859     ldw y,(STRUCT,sp)
      00A313 52 06 CD         [ 1] 1860     ld a,(FIELD_SRC,y)
      00A316 A8 C1 6B 04      [ 2] 1861     ldw y,#reg_index 
      00A31A 16 09 CD         [ 4] 1862     call ld_table_entry
      00A31D A9 6C            [ 2] 1863     ldw (SRC,sp),y 
      00A31F 90 E6 03 90      [ 2] 1864     ldw y,#fmt_op_ptr16_idx_r 
      00A323 AE 93 44         [ 4] 1865     call format 
      00165F                       1866 _fn_exit 
      00A326 CD A9            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A328 59               [ 4]    2     ret
                                   1867 
                                   1868 ;---------------------------------
                                   1869 ;   form op (ofs16,r)
                                   1870 ;---------------------------------
      00A329 17 05 90 AE A3 06 CD  1871 fmt_op_ofs16_idx: .asciz "%a%s\t(%w,%s)"
             8E 80 5B 06 81 25
                           000001  1872     SPC=1
                           000002  1873     MNEMO=2
                           000004  1874     OFS16=4
                           000006  1875     SRC=6
      00166F                       1876 _fn_entry 7 fn_ofs16_idx 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      00166F                          3 fn_ofs16_idx:
      00A336 61 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A338 73 09 25         [ 4] 1877     call get_int16  
      00A33B 77 2C            [ 2] 1878     ldw (OFS16,sp),y 
      00A33D 23 25            [ 2] 1879     ldw y,(STRUCT,sp)
      00A33F 63 2C 25         [ 4] 1880     call ld_mnemonic
      00A342 65 00 04         [ 1] 1881     ld a,(FIELD_SRC,y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



      00A344 90 AE 02 BC      [ 2] 1882     ldw y,#reg_index 
      00A344 52 09 6B         [ 4] 1883     call ld_table_entry
      00A347 06 CD            [ 2] 1884     ldw (SRC,sp),y 
      00A349 A8 E2 17 04      [ 2] 1885     ldw y,#fmt_op_ofs16_idx 
      00A34D CD A8 C1         [ 4] 1886     call format 
      00168E                       1887 _fn_exit 
      00A350 CD A9            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A352 29               [ 4]    2     ret
                                   1888 
                                   1889 
                                   1890 ;---------------------------------
                                   1891 ; form op r,(ofs16,r)
                                   1892 ;---------------------------------
      00A353 90 CE 00 AB C6 00 AD  1893 fmt_op_r_ofs16_idx: .asciz "%a%s\t%s,(%w,%s)"
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
      00A363 06 A4            [ 2]    4     sub sp,#LOCAL_SIZE
      00A365 01 27 06         [ 4] 1900     call get_int16 
      00A368 90 AE            [ 2] 1901     ldw (OFS16,sp),y 
      00A36A 91 8D            [ 2] 1902     ldw y,(STRUCT,sp)
      00A36C 20 04 90         [ 4] 1903     call ld_mnemonic
      00A36F AE 91 92         [ 1] 1904     ld a,(FIELD_DEST,y)
      00A372 17 02 7B 06      [ 2] 1905     ldw y,#reg_index
      00A376 44 A4 07         [ 4] 1906     call ld_table_entry
      00A379 AB 30            [ 2] 1907     ldw (DEST,sp),y 
      00A37B 6B 06            [ 2] 1908     ldw y,(STRUCT,sp)
      00A37D 90 AE A3         [ 1] 1909     ld a,(FIELD_SRC,y)
      00A380 35 CD 8E 80      [ 2] 1910     ldw y,#reg_index 
      00A384 5B 09 81         [ 4] 1911     call ld_table_entry
      00A387 91 88            [ 2] 1912     ldw (SRC,sp),y 
      00A389 91 83 91 78      [ 2] 1913     ldw y,#fmt_op_r_ofs16_idx
      00A38D 91 6F 25         [ 4] 1914     call format 
      0016CE                       1915 _fn_exit 
      00A390 61 25            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A392 73               [ 4]    2     ret
                                   1916 
                                   1917 ;---------------------------------
                                   1918 ;  form op (ofs16,r),r 
                                   1919 ;---------------------------------
      00A393 09 25 77 2C 23 25 63  1920 fmt_op_ofs16_idx_r: .asciz "%a%s\t(%w,%s),%s"
             00 2C 25 73 29 2C 25
             73 00
                           000001  1921     SPC=1
                           000002  1922     MNEMO=2
                           000004  1923     OFS16=4
                           000006  1924     DEST=6
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                           000008  1925     SRC=8
      00A39B                       1926 _fn_entry 9 fn_ofs16_idx_r
                           000009     1     LOCAL_SIZE = 9
                           00000C     2     STRUCT=3+LOCAL_SIZE
      0016E1                          3 fn_ofs16_idx_r:
      00A39B 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A39D 6B 06 A6         [ 4] 1927     call get_int16 
      00A3A0 08 6B            [ 2] 1928     ldw (OFS16,sp),y 
      00A3A2 01 CD            [ 2] 1929     ldw y,(STRUCT,sp)
      00A3A4 A8 E2 17         [ 4] 1930     call ld_mnemonic
      00A3A7 04 90 AE         [ 1] 1931     ld a,(FIELD_DEST,y)
      00A3AA A3 87 7B 06      [ 2] 1932     ldw y,#reg_index 
      00A3AE A4 01 27         [ 4] 1933     call ld_table_entry
      00A3B1 04 72            [ 2] 1934     ldw (DEST,sp),y 
      00A3B3 A9 00            [ 2] 1935     ldw y,(STRUCT,sp)
      00A3B5 02 7B 06         [ 1] 1936     ld a,(FIELD_SRC,y)
      00A3B8 A4 F0 27 04      [ 2] 1937     ldw y,#reg_index 
      00A3BC 72 A9 00         [ 4] 1938     call ld_table_entry
      00A3BF 04 90            [ 2] 1939     ldw (SRC,sp),y 
      00A3C1 FE 17 02 7B      [ 2] 1940     ldw y,#fmt_op_ofs16_idx_r 
      00A3C5 06 44 A4         [ 4] 1941     call format 
      00170E                       1942 _fn_exit 
      00A3C8 07 AB            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A3CA 30               [ 4]    2     ret
                                   1943 
                                   1944 ;---------------------------------
                                   1945 ;  op r,(ofs24,r)
                                   1946 ;---------------------------------
      00A3CB 6B 06 90 AE A3 8F CD  1947 fmt_op_r_ofs24_idx: .asciz "%a%s\t%s,(%e,%s)" 
             8E 80 5B 06 81 25 61
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
      00A3DB 09 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A3DD 73 2C 28         [ 4] 1954     call get_int24 
      00A3E0 25 62            [ 2] 1955     ldw (OFS24,sp),y 
      00A3E2 2C 25            [ 1] 1956     ld (OFS24+2,sp),a 
      00A3E4 73 29            [ 2] 1957     ldw y,(STRUCT,sp)
      00A3E6 00 18 E4         [ 4] 1958     call ld_mnemonic
      00A3E7 90 E6 03         [ 1] 1959     ld a,(FIELD_DEST,y)
      00A3E7 52 08 CD A8      [ 2] 1960     ldw y,#reg_index 
      00A3EB C1 6B 06         [ 4] 1961     call ld_table_entry
      00A3EE 16 0B            [ 2] 1962     ldw (DEST,sp),y 
      00A3F0 CD A9            [ 2] 1963     ldw y,(STRUCT,sp)
      00A3F2 6C 90 E6         [ 1] 1964     ld a,(FIELD_SRC,y)
      00A3F5 03 90 AE 93      [ 2] 1965     ldw y,#reg_index 
      00A3F9 44 CD A9         [ 4] 1966     call ld_table_entry
      00A3FC 59 17            [ 2] 1967     ldw (SRC,sp),y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



      00A3FE 04 16 0B 90      [ 2] 1968     ldw y,#fmt_op_r_ofs24_idx
      00A402 E6 04 90         [ 4] 1969     call format 
      001750                       1970 _fn_exit 
      00A405 AE 93            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A407 44               [ 4]    2     ret
                                   1971 
                                   1972 ;---------------------------------
                                   1973 ; op (ofs24,r),r 
                                   1974 ;---------------------------------
      00A408 CD A9 59 17 07 90 AE  1975 fmt_ofs24_idx_r: .asciz "%a%s\t(%e,%s),%s"
             A3 D7 CD 8E 80 5B 08
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
      00A418 61 25            [ 2]    4     sub sp,#LOCAL_SIZE
      00A41A 73 09 28         [ 4] 1982     call get_int24 
      00A41D 25 62            [ 2] 1983     ldw (OFS24,sp),y
      00A41F 2C 25            [ 1] 1984     ld (OFS24+2,sp),a
      00A421 73 29            [ 2] 1985     ldw y,(STRUCT,sp)
      00A423 2C 25 73         [ 4] 1986     call ld_mnemonic
      00A426 00 E6 03         [ 1] 1987     ld a,(FIELD_DEST,y)
      00A427 90 AE 02 BC      [ 2] 1988     ldw y,#reg_index 
      00A427 52 08 CD         [ 4] 1989     call ld_table_entry
      00A42A A8 C1            [ 2] 1990     ldw (DEST,sp),y 
      00A42C 6B 04            [ 2] 1991     ldw y,(STRUCT,sp)
      00A42E 16 0B CD         [ 1] 1992     ld a,(FIELD_SRC,y)
      00A431 A9 6C 90 E6      [ 2] 1993     ldw y,#reg_index 
      00A435 03 90 AE         [ 4] 1994     call ld_table_entry
      00A438 93 44            [ 2] 1995     ldw (SRC,sp),y
      00A43A CD A9 59 17      [ 2] 1996     ldw y,#fmt_ofs24_idx_r 
      00A43E 05 16 0B         [ 4] 1997     call format 
      001792                       1998 _fn_exit 
      00A441 90 E6            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A443 04               [ 4]    2     ret
                                   1999 
                                   2000 ;---------------------------------
                                   2001 ; form op [adr16]
                                   2002 ;---------------------------------
      00A444 90 AE 93 44 CD A9 59  2003 fmt_op_ptr8: .asciz "%a%s\t%[%b]"
             17 07 90 AE
                           000001  2004     SPC=1
                           000002  2005     MNEMO=2
                           000004  2006     ADR8=4
      0017A0                       2007 _fn_entry 4 fn_ptr8 
                           000004     1     LOCAL_SIZE = 4
                           000007     2     STRUCT=3+LOCAL_SIZE
      0017A0                          3 fn_ptr8:
      00A44F A4 17            [ 2]    4     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      00A451 CD 8E 80         [ 4] 2008     call get_int8
      00A454 5B 08            [ 1] 2009     ld (ADR8,sp),a 
      00A456 81 25            [ 2] 2010     ldw y,(STRUCT,sp)
      00A458 61 25 73         [ 4] 2011     call ld_mnemonic
      00A45B 09 25 73 2C      [ 2] 2012     ldw y,#fmt_op_ptr8 
      00A45F 23 25 62         [ 4] 2013     call format 
      0017B3                       2014 _fn_exit 
      00A462 00 04            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A463 81               [ 4]    2     ret
                                   2015 
                                   2016 ;---------------------------------
                                   2017 ; form op [adr16]
                                   2018 ;---------------------------------
      00A463 52 06 CD A8 C1 6B 06  2019 fmt_op_ptr16: .asciz "%a%s\t%[%w]"
             16 09 CD A9
                           000001  2020     SPC=1
                           000002  2021     MNEMO=2
                           000004  2022     ADR16=4
      0017C1                       2023 _fn_entry 5 fn_ptr16 
                           000005     1     LOCAL_SIZE = 5
                           000008     2     STRUCT=3+LOCAL_SIZE
      0017C1                          3 fn_ptr16:
      00A46E 6C 90            [ 2]    4     sub sp,#LOCAL_SIZE
      00A470 E6 03 90         [ 4] 2024     call get_int16 
      00A473 AE 93            [ 2] 2025     ldw (ADR16,sp),y 
      00A475 44 CD            [ 2] 2026     ldw y,(STRUCT,sp)
      00A477 A9 59 17         [ 4] 2027     call ld_mnemonic
      00A47A 04 90 AE A4      [ 2] 2028     ldw y,#fmt_op_ptr16 
      00A47E 57 CD 8E         [ 4] 2029     call format 
      0017D4                       2030 _fn_exit 
      00A481 80 5B            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A483 06               [ 4]    2     ret
                                   2031 
                                   2032 ;---------------------------------
                                   2033 ; form op ([ptr8],r) 
                                   2034 ;---------------------------------
      00A484 81 25 61 25 73 09 25  2035 fmt_op_ptr8_idx: .asciz "%a%s\t([%b],%s)"
             73 2C 23 25 77 00 29
             00
                           000001  2036     SPC=1
                           000002  2037     MNEMO=2
                           000004  2038     ADR8=4
                           000005  2039     DEST=5
      00A491                       2040 _fn_entry 6 fn_ptr8_idx 
                           000006     1     LOCAL_SIZE = 6
                           000009     2     STRUCT=3+LOCAL_SIZE
      0017E6                          3 fn_ptr8_idx:
      00A491 52 07            [ 2]    4     sub sp,#LOCAL_SIZE
      00A493 CD A8 E2         [ 4] 2041     call get_int8 
      00A496 17 06            [ 1] 2042     ld (ADR8,sp),a 
      00A498 16 0A            [ 2] 2043     ldw y,(STRUCT,sp)
      00A49A CD A9 6C         [ 4] 2044     call ld_mnemonic
      00A49D 90 E6 03         [ 1] 2045     ld a,(FIELD_DEST,y)
      00A4A0 90 AE 93 44      [ 2] 2046     ldw y,#reg_index 
      00A4A4 CD A9 59         [ 4] 2047     call ld_table_entry
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      00A4A7 17 04            [ 2] 2048     ldw (DEST,sp),y 
      00A4A9 90 AE A4 85      [ 2] 2049     ldw y,#fmt_op_ptr8_idx
      00A4AD CD 8E 80         [ 4] 2050     call format 
      001805                       2051 _fn_exit 
      00A4B0 5B 07            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A4B2 81               [ 4]    2     ret
                                   2052 
                                   2053 ;---------------------------------
                                   2054 ; form op ([ptr16],r) 
                                   2055 ;---------------------------------
      00A4B3 25 61 25 73 09 25 77  2056 fmt_op_ptr16_idx: .asciz "%a%s\t([%w],%s)"
             2C 23 25 62 00 73 29
             00
                           000001  2057     SPC=1
                           000002  2058     MNEMO=2
                           000004  2059     ADR16=4
                           000006  2060     DEST=6
      00A4BF                       2061 _fn_entry 7 fn_ptr16_idx 
                           000007     1     LOCAL_SIZE = 7
                           00000A     2     STRUCT=3+LOCAL_SIZE
      001817                          3 fn_ptr16_idx:
      00A4BF 52 06            [ 2]    4     sub sp,#LOCAL_SIZE
      00A4C1 CD A8 C1         [ 4] 2062     call get_int16 
      00A4C4 6B 06            [ 2] 2063     ldw (ADR16,sp),y 
      00A4C6 CD A8            [ 2] 2064     ldw y,(STRUCT,sp)
      00A4C8 E2 17 04         [ 4] 2065     call ld_mnemonic
      00A4CB 16 09 CD         [ 1] 2066     ld a,(FIELD_DEST,y)
      00A4CE A9 6C 90 AE      [ 2] 2067     ldw y,#reg_index 
      00A4D2 A4 B3 CD         [ 4] 2068     call ld_table_entry
      00A4D5 8E 80            [ 2] 2069     ldw (DEST,sp),y 
      00A4D7 5B 06 81 25      [ 2] 2070     ldw y,#fmt_op_ptr16_idx
      00A4DB 61 25 73         [ 4] 2071     call format 
      001836                       2072 _fn_exit 
      00A4DE 09 25            [ 2]    1     addw sp,#LOCAL_SIZE 
      00A4E0 77               [ 4]    2     ret
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
      00A4E1 2C 25 77         [ 4] 2088     call peek
      00A4E4 00               [ 1] 2089     push a 
      00A4E5 CD 00 00         [ 4] 2090     call print_byte 
      00A4E5 52               [ 1] 2091     pop a 
      00A4E6 07 CD A8         [ 1] 2092     ld acc8,a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



      00A4E9 E2 17 06 CD      [ 1] 2093     clr acc16
      00A4ED A8 E2 17 04      [ 1] 2094     clr acc24
      00A4F1 16 0A CD A9 6C   [ 2] 2095     btjf acc8,#7,1$
      00A4F6 90 AE A4 DA      [ 1] 2096     cpl acc16 
      00A4FA CD 8E 80 5B      [ 1] 2097     cpl acc24 
      001859                       2098 1$:          
      00A4FE 07               [ 4] 2099     ret
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
      00A4FF 81 25            [ 2] 2117     sub sp,#LOCAL_SIZE
      00A501 61 25 73         [ 4] 2118     call peek 
      00A504 09 25            [ 1] 2119     ld (ADDR16,sp),a 
      00A506 62 2C 25         [ 4] 2120     call print_byte 
      00A509 62 00 00         [ 4] 2121     call peek 
      00A50B 6B 02            [ 1] 2122     ld (ADDR16+1,sp),a 
      00A50B 52 05 CD         [ 4] 2123     call print_byte
      00A50E A8 C1            [ 2] 2124     ldw y, (ADDR16,sp)
      00A510 6B 05 CD A8      [ 2] 2125     ldw acc16,y
      00A514 C1 6B 04 16      [ 1] 2126     clr acc24 
      00A518 08 CD            [ 2] 2127     addw sp,#LOCAL_SIZE 
      00A51A A9               [ 4] 2128     ret 
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
      00A51B 6C 90            [ 2] 2147     sub sp,#LOCAL_SIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



      00A51D AE A5 00         [ 4] 2148     call peek
      00A520 CD 8E            [ 1] 2149     ld (ADDR24,sp),a 
      00A522 80 5B 05         [ 4] 2150     call print_byte 
      00A525 81 25 61         [ 4] 2151     call peek 
      00A528 25 73            [ 1] 2152     ld (ADDR24+1,sp),a 
      00A52A 09 25 73         [ 4] 2153     call print_byte 
      00A52D 2C 5B 25         [ 4] 2154     call peek 
      00A530 62 5D            [ 1] 2155     ld (ADDR24+2,sp),a 
      00A532 00 00 00         [ 4] 2156     call print_byte 
      00A533 16 01            [ 2] 2157     ldw y,(ADDR24,sp)
      00A533 52 06 CD A8      [ 2] 2158     ldw acc24,y 
      00A537 C1 6B            [ 1] 2159     ld a, (ADDR24+2,sp)
      00A539 06 16 09         [ 1] 2160     ld acc8,a 
      00A53C CD A9            [ 2] 2161     addw sp,#LOCAL_SIZE
      00A53E 6C               [ 4] 2162     ret 
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
      00A53F 90               [ 2] 2175     pushw x
      00A540 E6 03 90         [ 1] 2176     ld acc8,a 
      00A543 AE 93 44 CD      [ 1] 2177     clr acc16 
      00A547 A9 59 17 04      [ 1] 2178     clr acc24
      00A54B 90 AE A5 26 CD   [ 2] 2179     btjf acc8,#7,1$
      00A550 8E 80 5B 06      [ 1] 2180     cpl acc16 
      00A554 81 25 61 25      [ 1] 2181     cpl acc24 
      00A558 73               [ 1] 2182 1$: clr a 
      00A559 09 25 73 2C      [ 2] 2183     addw x,farptr+1 
      00A55D 5B 25 77         [ 1] 2184     adc a,farptr 
      00A560 5D 00 00 00      [ 2] 2185     addw x,acc16 
      00A562 C9 00 00         [ 1] 2186     adc a,acc24 
      00A562 52 07 CD         [ 1] 2187     ld acc24,a 
      00A565 A8 E2 17         [ 2] 2188     ldw acc16,x
      00A568 06               [ 2] 2189     popw x 
      00A569 16               [ 4] 2190     ret
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
      00A56A 0A CD A9 6C      [ 1] 2201     clr acc16
      00A56E 90               [ 1] 2202     sll a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



      00A56F E6 03 90 AE      [ 1] 2203     rlc acc16
      00A573 93 44 CD         [ 1] 2204     ld acc8,a 
      00A576 A9 59 17 04      [ 2] 2205     addw y,acc16 
      00A57A 90 AE            [ 2] 2206     ldw y,(y)
      00A57C A5               [ 4] 2207     ret 
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
      00A57D 55 CD            [ 2] 2222     pushw y
      00A57F 8E               [ 1] 2223     ld a,xl 
      00A580 80               [ 1] 2224     sll a 
      00A581 5B               [ 1] 2225     sll a 
      00A582 07 81 25         [ 1] 2226     ld acc8,a 
      00A585 61 25            [ 1] 2227     ld a,#24
      00A587 73 09 5B         [ 1] 2228     sub a,acc8
      00A58A 25 62            [ 1] 2229     ld (SPC,sp),a 
      00A58C 5D 2C 25         [ 1] 2230     ld a,(FIELD_MNEMO,y)
      00A58F 73 00 00 00      [ 1] 2231     clr acc16 
      00A591 48               [ 1] 2232     sll a 
      00A591 52 06 CD A8      [ 1] 2233     rlc acc16 
      00A595 C1 6B 04         [ 1] 2234     ld acc8,a
      00A598 16 09 CD A9      [ 2] 2235     ldw y,#mnemo_index  
      00A59C 6C 90 E6 04      [ 2] 2236     addw y,acc16
      00A5A0 90 AE            [ 2] 2237     ldw y,(y)
      00A5A2 93 44            [ 2] 2238     ldw (MNEMO,sp),y 
      00A5A4 CD A9            [ 2] 2239     popw y 
      00A5A6 59               [ 4] 2240     ret 
                                   2241 
                                   2242 
                                   2243 
