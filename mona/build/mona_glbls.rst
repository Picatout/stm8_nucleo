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
                                     18 ;--------------------------------------
                                     19 ;   globals sub-routines and variables
                                     20 ;   module 
                                     21 ;--------------------------------------
                                     22     .module GLOBALS 
                                     23 
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
                                 
                                 
                                 
                                     29     .list 
                                     30 
                                     31     .area DATA 
      00005A                         32 rx_char:: .blkb 1 ; last uart received char
      00005B                         33 pad::	.blkb PAD_SIZE ; working pad
      0000AB                         34 acc24:: .blkb 1; acc24:acc16:acc8 form a 24 bits accumulator
      0000AC                         35 acc16:: .blkb 1; acc16:acc8 form a 24 bits accumulator 
      0000AD                         36 acc8::  .blkb 1; acc8 an 8 bit accumulator 
      0000AE                         37 farptr:: .blkb 3; 24 bits pointer
      0000B1                         38 flags::  .blkb 1; boolean flags
                                     39 
                                     40 
                                     41     .area CODE 
      008E79 47 4C 4F 42 41 4C 53    42 .ascii "GLOBALS"
                                     43 ;--------------------------------
                                     44 ; <format> is a simplifide version
                                     45 ; of 'C' <printf>
                                     46 ; input:
                                     47 ;   Y       pointer to template string 
                                     48 ;   stack   all others paramaters are on 
                                     49 ;           stack. First argument is at (3,sp)
                                     50 ; output:
                                     51 ;   none
                                     52 ; use:
                                     53 ;   X       used as frame pointer  
                                     54 ; Detail:
                                     55 ;   template is a .asciz string with embedded <%c>
                                     56 ;   to indicate parameters positision. First <%c> 
                                     57 ;   from left correspond to first paramter.
                                     58 ;   'c' is one of these: 
                                     59 ;      'a' print a count of SPACE for alignement purpose     
                                     60 ;      'b' byte parameter  (int8_t)
                                     61 ;      'c' ASCII character
                                     62 ;      'e' 24 bits integer (int24_t) parameter
                                     63 ;      's' string (.asciz) parameter as long pointer (16 bits)
                                     64 ;      'w' word paramter (int16_t) 
                                     65 ;      others values of 'c' are printed as is.
                                     66 ;  These are sufficient for the requirement of
                                     67 ;  mona_dasm
                                     68 ;--------------------------------
                           000008    69     LOCAL_OFS=8 ; offset on stack of arguments frame 
      008E80                         70 format::
                                     71 ; preserve X
      008E80 89               [ 2]   72     pushw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     73 ; preserve farptr
      008E81 C6 00 B0         [ 1]   74     ld a, farptr+2
      008E84 88               [ 1]   75     push a 
      008E85 C6 00 AF         [ 1]   76     ld a, farptr+1 
      008E88 88               [ 1]   77     push a 
      008E89 C6 00 AE         [ 1]   78     ld a, farptr
      008E8C 88               [ 1]   79     push a
                                     80 ; X used as frame pointer     
      008E8D 96               [ 1]   81     ldw x,sp 
      008E8E 1C 00 08         [ 2]   82     addw x,#LOCAL_OFS
      008E91                         83 format_loop:    
      008E91 90 F6            [ 1]   84     ld a,(y)
      008E93 26 03            [ 1]   85     jrne 1$
      008E95 CC 8F 11         [ 2]   86     jp format_exit
      008E98 90 5C            [ 1]   87 1$: incw y 
      008E9A A1 25            [ 1]   88     cp a,#'%
      008E9C 27 05            [ 1]   89     jreq 2$
      008E9E CD 8F 2F         [ 4]   90     call uart_tx
      008EA1 20 EE            [ 2]   91     jra format_loop  
      008EA3                         92 2$:
      008EA3 90 F6            [ 1]   93     ld a,(y)
      008EA5 27 6A            [ 1]   94     jreq format_exit 
      008EA7 90 5C            [ 1]   95     incw y
      008EA9 A1 61            [ 1]   96     cp a,#'a' 
      008EAB 26 07            [ 1]   97     jrne 24$
      008EAD F6               [ 1]   98     ld a,(x)
      008EAE 5C               [ 1]   99     incw x 
      008EAF CD 8F 1F         [ 4]  100     call spaces 
      008EB2 20 DD            [ 2]  101     jra format_loop 
      008EB4                        102 24$:
      008EB4 A1 62            [ 1]  103     cp a,#'b'
      008EB6 26 07            [ 1]  104     jrne 3$
                                    105 ; byte type paramter     
      008EB8 F6               [ 1]  106     ld a,(x)
      008EB9 5C               [ 1]  107     incw x 
      008EBA CD 8F E6         [ 4]  108     call print_byte
      008EBD 20 D2            [ 2]  109     jra format_loop
      008EBF A1 63            [ 1]  110 3$: cp a,#'c 
      008EC1 26 07            [ 1]  111     jrne 4$
                                    112 ; ASCII character 
      008EC3 F6               [ 1]  113     ld a,(x)
      008EC4 5C               [ 1]  114     incw x 
      008EC5 CD 8F 2F         [ 4]  115     call uart_tx 
      008EC8 20 C7            [ 2]  116     jra format_loop         
      008ECA A1 65            [ 1]  117 4$: cp a,#'e 
      008ECC 26 13            [ 1]  118     jrne 6$
                                    119 ; int24_t parameter     
      008ECE 90 89            [ 2]  120     pushw y 
      008ED0 F6               [ 1]  121     ld a,(x)
      008ED1 90 95            [ 1]  122     ld yh,a 
      008ED3 5C               [ 1]  123     incw x
      008ED4 F6               [ 1]  124     ld a,(x)
      008ED5 90 97            [ 1]  125     ld yl,a 
      008ED7 5C               [ 1]  126     incw x 
      008ED8 F6               [ 1]  127     ld a,(x)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



      008ED9 5C               [ 1]  128     incw x 
      008EDA CD 90 11         [ 4]  129     call print_extd
      008EDD 90 85            [ 2]  130     popw y  
      008EDF 20 B0            [ 2]  131     jra format_loop
      008EE1 A1 73            [ 1]  132 6$: cp a,#'s 
      008EE3 26 10            [ 1]  133     jrne 8$
                                    134 ; string type parameter     
      008EE5 90 89            [ 2]  135     pushw y
      008EE7 90 93            [ 1]  136     ldw y,x 
      008EE9 1C 00 02         [ 2]  137     addw x,#2
      008EEC 90 FE            [ 2]  138     ldw y,(y)
      008EEE CD 8F 39         [ 4]  139     call uart_print 
      008EF1 90 85            [ 2]  140 7$: popw y 
      008EF3 20 9C            [ 2]  141     jra format_loop 
      008EF5 A1 77            [ 1]  142 8$: cp a,#'w 
      008EF7 26 12            [ 1]  143     jrne 9$
                                    144 ; word type paramter     
      008EF9 90 89            [ 2]  145     pushw y 
      008EFB F6               [ 1]  146     ld a,(x)
      008EFC 5C               [ 1]  147     incw x 
      008EFD 90 95            [ 1]  148     ld yh,a
      008EFF F6               [ 1]  149     ld a,(x)
      008F00 5C               [ 1]  150     incw x 
      008F01 90 97            [ 1]  151     ld yl,a 
      008F03 CD 8F FC         [ 4]  152     call print_word 
      008F06 90 85            [ 2]  153     popw y 
      008F08 CC 8E 91         [ 2]  154     jp format_loop 
      008F0B CD 8F 2F         [ 4]  155 9$: call uart_tx         
      008F0E CC 8E 91         [ 2]  156     jp format_loop 
      008F11                        157 format_exit:
                                    158 ; restore farptr 
      008F11 84               [ 1]  159     pop a 
      008F12 C7 00 AE         [ 1]  160     ld farptr,a 
      008F15 84               [ 1]  161     pop a 
      008F16 C7 00 AF         [ 1]  162     ld farptr+1,a 
      008F19 84               [ 1]  163     pop a 
      008F1A C7 00 B0         [ 1]  164     ld farptr+2,a 
      008F1D 85               [ 2]  165     popw x 
      008F1E 81               [ 4]  166     ret 
                                    167 
                                    168 ;------------------------------------
                                    169 ; print n spaces 
                                    170 ; input: 
                                    171 ;   A  		number of space to print 
                                    172 ; output:
                                    173 ;	none 
                                    174 ;------------------------------------
      008F1F                        175 spaces::
      008F1F 88               [ 1]  176 	push a 
      008F20 A6 20            [ 1]  177 	ld a,#SPACE 
      008F22 0D 01            [ 1]  178 1$:	tnz (1,sp)
      008F24 27 07            [ 1]  179 	jreq 2$ 
      008F26 CD 8F 2F         [ 4]  180 	call uart_tx 
      008F29 0A 01            [ 1]  181 	dec (1,sp)
      008F2B 20 F5            [ 2]  182 	jra 1$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



      008F2D 84               [ 1]  183 2$:	pop a 
      008F2E 81               [ 4]  184 	ret
                                    185 
                                    186 
                                    187 ;------------------------------------
                                    188 ;  serial port communication routines
                                    189 ;------------------------------------
                                    190 ;------------------------------------
                                    191 ; transmit character in a via UART3
                                    192 ; character to transmit on (3,sp)
                                    193 ;------------------------------------
      008F2F                        194 uart_tx::
      008F2F 72 5D 52 40      [ 1]  195 	tnz UART3_SR
      008F33 2A FA            [ 1]  196 	jrpl uart_tx
      008F35 C7 52 41         [ 1]  197 	ld UART3_DR,a
      008F38 81               [ 4]  198     ret
                                    199 
                                    200 ;------------------------------------
                                    201 ; send string via UART2
                                    202 ; y is pointer to str
                                    203 ;------------------------------------
      008F39                        204 uart_print::
                                    205 ; check for null pointer  
      008F39 90 A3 00 00      [ 2]  206 	cpw y,#0
      008F3D 27 0B            [ 1]  207     jreq 1$ 
      008F3F 90 F6            [ 1]  208 0$: ld a,(y)
      008F41 27 07            [ 1]  209 	jreq 1$
      008F43 CD 8F 2F         [ 4]  210 	call uart_tx
      008F46 90 5C            [ 1]  211 	incw y
      008F48 20 F5            [ 2]  212 	jra 0$
      008F4A 81               [ 4]  213 1$: ret
                                    214 
                                    215 ;------------------------------------
                                    216 ; check if char available
                                    217 ;------------------------------------
      008F4B                        218 uart_qchar::
      008F4B 72 5D 00 5A      [ 1]  219 	tnz rx_char
      008F4F 27 01            [ 1]  220 	jreq 1$
      008F51 81               [ 4]  221     ret
      008F52 A6 05            [ 1]  222 1$: ld a,#UART_SR_RXNE 
      008F54 C4 52 40         [ 1]  223 	and a,UART3_SR
      008F57 81               [ 4]  224 	ret 
                                    225 
                                    226 ;------------------------------------
                                    227 ; return char in A to queue
                                    228 ;------------------------------------
                                    229 ;ungetchar:: 
      008F58 C7 00 5A         [ 1]  230 	ld rx_char,a
      008F5B 81               [ 4]  231     ret
                                    232     
                                    233 ;------------------------------------
                                    234 ; wait for character from uart3
                                    235 ;------------------------------------
      008F5C                        236 uart_getchar::
                                    237 ; if there is a char in rx_char return it.
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      008F5C C6 00 5A         [ 1]  238 	ld a,rx_char 
      008F5F 27 05            [ 1]  239 	jreq 1$
      008F61 72 5F 00 5A      [ 1]  240 	clr rx_char
      008F65 81               [ 4]  241 	ret
      008F66 72 0B 52 40 FB   [ 2]  242 1$:	btjf UART3_SR,#UART_SR_RXNE,.
      008F6B C6 52 41         [ 1]  243 	ld a, UART3_DR 
      008F6E 81               [ 4]  244 	ret
                                    245 
                                    246 ;------------------------------------
                                    247 ; delete n character from input line
                                    248 ;------------------------------------
      008F6F                        249 uart_delete::
      008F6F 88               [ 1]  250 	push a ; n 
      008F70                        251 del_loop:
      008F70 0D 01            [ 1]  252 	tnz (1,sp)
      008F72 27 13            [ 1]  253 	jreq 1$
      008F74 A6 08            [ 1]  254 	ld a,#BSP
      008F76 CD 8F 2F         [ 4]  255 	call uart_tx
      008F79 A6 20            [ 1]  256     ld a,#SPACE
      008F7B CD 8F 2F         [ 4]  257     call uart_tx
      008F7E A6 08            [ 1]  258     ld a,#BSP
      008F80 CD 8F 2F         [ 4]  259     call uart_tx
      008F83 0A 01            [ 1]  260     dec (1,sp)
      008F85 20 E9            [ 2]  261     jra del_loop
      008F87 84               [ 1]  262 1$: pop a
      008F88 81               [ 4]  263 	ret 
                                    264 
                                    265 ;-----------------------------------
                                    266 ; print a string (.asciz) pointed
                                    267 ; by a far pointer 
                                    268 ; input:
                                    269 ;   farptr    pointer to string 
                                    270 ; output:
                                    271 ;   none
                                    272 ;----------------------------------- 
      008F89                        273 uart_prints::
      008F89 90 89            [ 2]  274     pushw y 
      008F8B 90 5F            [ 1]  275     clrw y
      008F8D                        276 1$:
      008F8D 91 AF 00 AE      [ 1]  277     ldf a,([farptr],y)
      008F91 27 07            [ 1]  278     jreq 2$
      008F93 CD 8F 2F         [ 4]  279     call uart_tx 
      008F96 90 5C            [ 1]  280     incw y 
      008F98 20 F3            [ 2]  281     jra 1$
      008F9A                        282 2$:
      008F9A 90 85            [ 2]  283     popw y 
      008F9C 81               [ 4]  284     ret 
                                    285 
                                    286 ;------------------------------------
                                    287 ; print integer in acc24 
                                    288 ; input:
                                    289 ;	acc24 		integer to print 
                                    290 ;	A 			numerical base for conversion 
                                    291 ;   XL 			field width, 0 -> no fill.
                                    292 ;  output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                                    293 ;    none 
                                    294 ;------------------------------------
                           000002   295 	BASE = 2
                           000001   296 	WIDTH = 1
                           000002   297 	LOCAL_SIZE = 2
      008F9D                        298 print_int::
      008F9D 90 89            [ 2]  299 	pushw y 
      008F9F 52 02            [ 2]  300 	sub sp,#LOCAL_SIZE 
      008FA1 6B 02            [ 1]  301 	ld (BASE,sp),a 
      008FA3 9F               [ 1]  302 	ld a,xl
      008FA4 6B 01            [ 1]  303 	ld (WIDTH,sp),a 
      008FA6 7B 02            [ 1]  304 	ld a, (BASE,sp)  
      008FA8 CD 90 3C         [ 4]  305     call itoa  ; conversion entier en  .asciz
      008FAB C7 00 AD         [ 1]  306 	ld acc8,a ; string length 
      008FAE A6 10            [ 1]  307 	ld a,#16
      008FB0 11 02            [ 1]  308 	cp a,(BASE,sp)
      008FB2 26 0A            [ 1]  309 	jrne 1$
      008FB4 90 5A            [ 2]  310 	decw y 
      008FB6 A6 24            [ 1]  311 	ld a,#'$
      008FB8 90 F7            [ 1]  312 	ld (y),a
      008FBA 72 5C 00 AD      [ 1]  313 	inc acc8 
      008FBE 7B 01            [ 1]  314 1$: ld a,(WIDTH,sp) 
      008FC0 27 17            [ 1]  315 	jreq 4$
      008FC2 C0 00 AD         [ 1]  316 	sub a,acc8
      008FC5 23 12            [ 2]  317 	jrule 4$
      008FC7 6B 01            [ 1]  318 	ld (WIDTH,sp),a 
      008FC9 A6 20            [ 1]  319 	ld  a,#SPACE
      008FCB 0D 01            [ 1]  320 3$: tnz (WIDTH,sp)
      008FCD 27 0A            [ 1]  321 	jreq 4$
      008FCF 2B 08            [ 1]  322 	jrmi 4$
      008FD1 90 5A            [ 2]  323 	decw y 
      008FD3 90 F7            [ 1]  324 	ld (y),a 
      008FD5 0A 01            [ 1]  325 	dec (WIDTH,sp) 
      008FD7 20 F2            [ 2]  326 	jra 3$
      008FD9 CD 8F 39         [ 4]  327 4$: call uart_print
      008FDC A6 20            [ 1]  328 	ld a,#SPACE 
      008FDE CD 8F 2F         [ 4]  329 	call uart_tx 
      008FE1 5B 02            [ 2]  330     addw sp,#LOCAL_SIZE 
      008FE3 90 85            [ 2]  331 	popw y 
      008FE5 81               [ 4]  332     ret	
                                    333 
                                    334 ;----------------------------
                                    335 ; print byte in A 
                                    336 ; in hexadecimal format 
                                    337 ; input:
                                    338 ;   A	byte to print 
                                    339 ; use: 
                                    340 ;   XL		field width
                                    341 ;----------------------------
      008FE6                        342 print_byte::
      008FE6 89               [ 2]  343 	pushw x
      008FE7 C7 00 AD         [ 1]  344 	ld acc8,a  
      008FEA 72 5F 00 AB      [ 1]  345 	clr acc24 
      008FEE 72 5F 00 AC      [ 1]  346 	clr acc16  
      008FF2 A6 03            [ 1]  347 	ld a,#3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      008FF4 97               [ 1]  348 	ld xl,a
      008FF5 A6 10            [ 1]  349 	ld a,#16
      008FF7 CD 8F 9D         [ 4]  350 	call print_int 
      008FFA 85               [ 2]  351 	popw x 
      008FFB 81               [ 4]  352 	ret 
                                    353 
                                    354 ;----------------------------
                                    355 ; print word in Y  
                                    356 ; in hexadecimal format 
                                    357 ; input:
                                    358 ;   Y	word to print 
                                    359 ; use: 
                                    360 ;   A       conversion base 
                                    361 ;   XL		field width
                                    362 ;----------------------------
      008FFC                        363 print_word::
      008FFC 88               [ 1]  364 	push A 
      008FFD 89               [ 2]  365 	pushw x
      008FFE 90 CF 00 AC      [ 2]  366 	ldw acc16,y  
      009002 72 5F 00 AB      [ 1]  367 	clr acc24 
      009006 A6 05            [ 1]  368 	ld a,#5
      009008 97               [ 1]  369 	ld xl,a
      009009 A6 10            [ 1]  370 	ld a,#16
      00900B CD 8F 9D         [ 4]  371 	call print_int 
      00900E 85               [ 2]  372 	popw x 
      00900F 84               [ 1]  373 	pop a 
      009010 81               [ 4]  374 	ret 
                                    375 
                                    376 ;----------------------------
                                    377 ; print 24 bits integer in Y:A 
                                    378 ; in hexadecimal format 
                                    379 ; input:
                                    380 ;   Y	bits 23:16 
                                    381 ;   A   bits 7:0
                                    382 ; use: 
                                    383 ;   A       conversion base 
                                    384 ;   XL		field width
                                    385 ;----------------------------
      009011                        386 print_extd::
      009011 C7 00 AD         [ 1]  387     ld acc8,a 
      009014 90 CF 00 AB      [ 2]  388     ldw acc24,y 
      009018 89               [ 2]  389     pushw x 
      009019 A6 07            [ 1]  390     ld a,#7
      00901B 97               [ 1]  391     ld xl,a 
      00901C A6 10            [ 1]  392     ld a,#16 
      00901E CD 8F 9D         [ 4]  393     call print_int 
      009021 85               [ 2]  394     popw x 
      009022 81               [ 4]  395     ret 
                                    396 
                                    397 ;------------------------------------
                                    398 ; print *farptr
                                    399 ; input:
                                    400 ;    *farptr 
                                    401 ; use:
                                    402 ;	acc24	itoa conversion 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                                    403 ;   A 		conversion base
                                    404 ;   XL		field width 
                                    405 ;------------------------------------
      009023                        406 print_addr::
      009023 89               [ 2]  407 	pushw x
      009024 88               [ 1]  408 	push a 
      009025 CE 00 AE         [ 2]  409 	ldw x, farptr 
      009028 CF 00 AB         [ 2]  410 	ldw acc24,x 
      00902B C6 00 B0         [ 1]  411 	ld a,farptr+2 
      00902E C7 00 AD         [ 1]  412 	ld acc8,a 
      009031 A6 06            [ 1]  413 	ld a,#6  
      009033 97               [ 1]  414 	ld xl, a  ; field width 
      009034 A6 10            [ 1]  415 	ld a,#16 ; convert in hexadecimal 
      009036 CD 8F 9D         [ 4]  416 	call print_int 
      009039 84               [ 1]  417 	pop a 
      00903A 85               [ 2]  418 	popw x 
      00903B 81               [ 4]  419 	ret 
                                    420 
                                    421 ;------------------------------------
                                    422 ; convert integer to string
                                    423 ; input:
                                    424 ;   A	  	base
                                    425 ;	acc24	integer to convert
                                    426 ; output:
                                    427 ;   y  		pointer to string
                                    428 ;   A 		string length 
                                    429 ;------------------------------------
                           000001   430 	SIGN=1  ; integer sign 
                           000002   431 	BASE=2  ; numeric base 
                           000002   432 	LOCAL_SIZE=2  ;locals size
      00903C                        433 itoa::
      00903C 52 02            [ 2]  434 	sub sp,#LOCAL_SIZE
      00903E 6B 02            [ 1]  435 	ld (BASE,sp), a  ; base
      009040 0F 01            [ 1]  436 	clr (SIGN,sp)    ; sign
      009042 A1 0A            [ 1]  437 	cp a,#10
      009044 26 0A            [ 1]  438 	jrne 1$
                                    439 	; base 10 string display with negative sign if bit 23==1
      009046 72 0F 00 AB 05   [ 2]  440 	btjf acc24,#7,1$
      00904B 03 01            [ 1]  441 	cpl (SIGN,sp)
      00904D CD 85 40         [ 4]  442 	call neg_acc24
      009050                        443 1$:
                                    444 ; initialize string pointer 
      009050 90 AE 00 AA      [ 2]  445 	ldw y,#pad+PAD_SIZE-1
      009054 90 7F            [ 1]  446 	clr (y)
      009056                        447 itoa_loop:
      009056 7B 02            [ 1]  448     ld a,(BASE,sp)
      009058 CD 85 18         [ 4]  449     call divu24_8 ; acc24/A 
      00905B AB 30            [ 1]  450     add a,#'0  ; remainder of division
      00905D A1 3A            [ 1]  451     cp a,#'9+1
      00905F 2B 02            [ 1]  452     jrmi 2$
      009061 AB 07            [ 1]  453     add a,#7 
      009063 90 5A            [ 2]  454 2$: decw y
      009065 90 F7            [ 1]  455     ld (y),a
                                    456 	; if acc24==0 conversion done
      009067 C6 00 AB         [ 1]  457 	ld a,acc24
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



      00906A CA 00 AC         [ 1]  458 	or a,acc16
      00906D CA 00 AD         [ 1]  459 	or a,acc8
      009070 26 E4            [ 1]  460     jrne itoa_loop
                                    461 	;conversion done, next add '$' or '-' as required
      009072 7B 02            [ 1]  462 	ld a,(BASE,sp)
      009074 A1 10            [ 1]  463 	cp a,#16
      009076 27 0A            [ 1]  464 	jreq 10$
      009078 7B 01            [ 1]  465     ld a,(SIGN,sp)
      00907A 27 06            [ 1]  466     jreq 10$
      00907C 90 5A            [ 2]  467     decw y
      00907E A6 2D            [ 1]  468     ld a,#'-
      009080 90 F7            [ 1]  469     ld (y),a
      009082                        470 10$:
      009082 5B 02            [ 2]  471 	addw sp,#LOCAL_SIZE
      009084 CD 86 2E         [ 4]  472 	call strlen
      009087 81               [ 4]  473 	ret
                                    474 
