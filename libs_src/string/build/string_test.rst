ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019 
                                      3 ; This file is part of STM8_NUCLEO 
                                      4 ;
                                      5 ;     STM8_NUCLEO is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     STM8_NUCLEO is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with STM8_NUCLEO.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;--------------------------------------
                                     19 ;   STRINGS module
                                     20 ;   DATE: 2019-11-29
                                     21 ;   DEPENDENCIES: math24 
                                     22 ;--------------------------------------
                                     23     .module STRING_TEST
                                     24 
                                        	.include "../../inc/nucleo_8s208.inc"
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
                                 
                                 
                                 
                                        
                                        
                                        	.include "../../inc/stm8s208.inc"
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
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                        	.include "../../inc/ascii.inc"
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
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                            .include "../../inc/gen_macros.inc"
                                        ;;
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
                                        ;   DATE: 2019-12-11
                                        ;    
                                        ;   General usage macros.   
                                        ;
                                        ;--------------------------------------
                                        
                                            ; reserve space on stack
                                            ; for local variabls
                                            .macro _vars n 
                                            
                                            ; free space on stack
                                            .macro _drop n 
                                        
                                            ; declare ARG_OFS for arguments 
                                            ; displacement on stack. This 
                                            ; value depend on local variables 
                                            ; size.
                                            .macro _argofs n 
                                        
                                            ; declare a function argument 
                                            ; position relative to stack pointer 
                                            ; _argofs must be called before it.
                                            .macro _arg name ofs 
                                            .include "../test_macros.inc" 
                                        ;;
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
                                        ;--------------------------------------
                                        ; set of macros to use with test_help
                                        ;--------------------------------------
                                        
                                            .macro _dbg 
                                        
                                            .macro _nodbg
                                        
                                 
                                 
                                 
                                 
                                            .macro _dbg_save_regs 
                                        
                                            .macro _dbg_restore_regs 
                                        
                                            .macro _dbg_getc 
                                        
                                            .macro _dbg_putc 
                                        
                                            .macro _dbg_puts 
                                        
                                            .macro _dbg_prti24 
                                        
                                            .macro _dbg_prt_regs
                                        
                                            .macro _dbg_peek addr 
                                        
                                        
                                     31     .list 
                                     32 
                                     33     .area DATA 
      00006D                         34 buffer:: .ds 80 
                                     35     
                                     36     .area CODE 
      0085DF                         37 _dbg 
                           000001     1     DEBUG=1
      000000                         38 test_main::
                                     39 ; clear_buffer
      0085DF AE 00 6D         [ 2]   40     ldw x,#buffer 
      0085E2 A6 50            [ 1]   41     ld a,#80 
      0085E4 7F               [ 1]   42 1$: clr (x)
      0085E5 5C               [ 1]   43     incw x 
      0085E6 4A               [ 1]   44     dec a 
      0085E7 26 FB            [ 1]   45     jrne 1$
                                     46 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



      0085E9 90 AE 87 E3      [ 2]   47     ldw y,#test_atoi24
      00000E                         48     _dbg_puts 
                           000001     1     .if DEBUG 
      00000E                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0085ED 8A               [ 1]    2     push cc ; (6,sp)
      0085EE 88               [ 1]    3     push a   ; (5,sp)
      0085EF 89               [ 2]    4     pushw x  ; (3,sp)
      0085F0 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0085F2 CD 80 CC         [ 4]    3     call uart3_puts 
      000016                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0085F5 90 85            [ 2]    2     popw y 
      0085F7 85               [ 2]    3     popw x 
      0085F8 84               [ 1]    4     pop a 
      0085F9 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0085FA 90 AE 88 4A      [ 2]   49     ldw y,#number 
      00001F                         50     _dbg_puts 
                           000001     1     .if DEBUG 
      00001F                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0085FE 8A               [ 1]    2     push cc ; (6,sp)
      0085FF 88               [ 1]    3     push a   ; (5,sp)
      008600 89               [ 2]    4     pushw x  ; (3,sp)
      008601 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008603 CD 80 CC         [ 4]    3     call uart3_puts 
      000027                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008606 90 85            [ 2]    2     popw y 
      008608 85               [ 2]    3     popw x 
      008609 84               [ 1]    4     pop a 
      00860A 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      00860B AE 88 4A         [ 2]   51     ldw x,#number
      00860E 89               [ 2]   52     pushw x 
      00860F CD 89 9F         [ 4]   53     call atoi24
      000033                         54     _drop 2  
      008612 5B 02            [ 2]    1     addw sp,#2 
      000035                         55     _dbg_prt_regs 
                           000001     1     .if DEBUG
      000035                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008614 8A               [ 1]    2     push cc ; (6,sp)
      008615 88               [ 1]    3     push a   ; (5,sp)
      008616 89               [ 2]    4     pushw x  ; (3,sp)
      008617 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008619 CD 80 F6         [ 4]    3     call uart3_prt_regs 
      00003D                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



      00861C 90 85            [ 2]    2     popw y 
      00861E 85               [ 2]    3     popw x 
      00861F 84               [ 1]    4     pop a 
      008620 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     56 ;;;;;;;;;;;;;;;;;;;;;;;;;    
      008621 90 AE 87 F1      [ 2]   57     ldw y,#test_strlen  
      000046                         58     _dbg_puts
                           000001     1     .if DEBUG 
      000046                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008625 8A               [ 1]    2     push cc ; (6,sp)
      008626 88               [ 1]    3     push a   ; (5,sp)
      008627 89               [ 2]    4     pushw x  ; (3,sp)
      008628 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00862A CD 80 CC         [ 4]    3     call uart3_puts 
      00004E                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      00862D 90 85            [ 2]    2     popw y 
      00862F 85               [ 2]    3     popw x 
      008630 84               [ 1]    4     pop a 
      008631 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      008632 90 AE 88 51      [ 2]   59     ldw y,#hello 
      000057                         60     _dbg_puts  
                           000001     1     .if DEBUG 
      000057                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008636 8A               [ 1]    2     push cc ; (6,sp)
      008637 88               [ 1]    3     push a   ; (5,sp)
      008638 89               [ 2]    4     pushw x  ; (3,sp)
      008639 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00863B CD 80 CC         [ 4]    3     call uart3_puts 
      00005F                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      00863E 90 85            [ 2]    2     popw y 
      008640 85               [ 2]    3     popw x 
      008641 84               [ 1]    4     pop a 
      008642 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      000064                         61     _vars 2 
      008643 52 02            [ 2]    1     sub sp,#2 
      008645 AE 88 51         [ 2]   62     ldw x,#hello 
      008648 1F 01            [ 2]   63     ldw (1,sp),x 
      00864A CD 8A 23         [ 4]   64     call strlen 
      00006E                         65     _drop 2
      00864D 5B 02            [ 2]    1     addw sp,#2 
      00864F CF 00 68         [ 2]   66     ldw acc16,x 
      008652 72 5F 00 67      [ 1]   67     clr acc24 
      008656 A6 0A            [ 1]   68     ld a,#10 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



      008658 5F               [ 1]   69     clrw x 
      00007A                         70     _dbg_prti24
                           000001     1     .if DEBUG 
      00007A                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008659 8A               [ 1]    2     push cc ; (6,sp)
      00865A 88               [ 1]    3     push a   ; (5,sp)
      00865B 89               [ 2]    4     pushw x  ; (3,sp)
      00865C 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00865E CD 82 DD         [ 4]    3     call uart3_prti24 
      000082                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008661 90 85            [ 2]    2     popw y 
      008663 85               [ 2]    3     popw x 
      008664 84               [ 1]    4     pop a 
      008665 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
      008666 A6 0D            [ 1]   71     ld a,#CR 
                                     72 ;;;;;;;;;;;;;;;;;;;;;;;;;    
      008668 90 AE 88 27      [ 2]   73     ldw y,#test_strcpy
      00008D                         74     _dbg_puts 
                           000001     1     .if DEBUG 
      00008D                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00866C 8A               [ 1]    2     push cc ; (6,sp)
      00866D 88               [ 1]    3     push a   ; (5,sp)
      00866E 89               [ 2]    4     pushw x  ; (3,sp)
      00866F 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008671 CD 80 CC         [ 4]    3     call uart3_puts 
      000095                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008674 90 85            [ 2]    2     popw y 
      008676 85               [ 2]    3     popw x 
      008677 84               [ 1]    4     pop a 
      008678 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      00009A                         75     _vars 4 
      008679 52 04            [ 2]    1     sub sp,#4 
      00867B AE 00 6D         [ 2]   76     ldw x,#buffer 
      00867E 1F 01            [ 2]   77     ldw (1,sp),x 
      008680 AE 88 51         [ 2]   78     ldw x,#hello 
      008683 1F 03            [ 2]   79     ldw (3,sp),x 
      008685 CD 8A 3E         [ 4]   80     call strcpy 
      0000A9                         81     _drop 4 
      008688 5B 04            [ 2]    1     addw sp,#4 
      00868A 90 AE 00 6D      [ 2]   82     ldw y,#buffer 
      0000AF                         83     _dbg_puts 
                           000001     1     .if DEBUG 
      0000AF                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00868E 8A               [ 1]    2     push cc ; (6,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      00868F 88               [ 1]    3     push a   ; (5,sp)
      008690 89               [ 2]    4     pushw x  ; (3,sp)
      008691 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008693 CD 80 CC         [ 4]    3     call uart3_puts 
      0000B7                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008696 90 85            [ 2]    2     popw y 
      008698 85               [ 2]    3     popw x 
      008699 84               [ 1]    4     pop a 
      00869A 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     84 ;;;;;;;;;;;;;;;;;;;;;;;;;;    
      00869B 90 AE 88 0B      [ 2]   85     ldw y,#test_memcpy
      0000C0                         86     _dbg_puts  
                           000001     1     .if DEBUG 
      0000C0                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00869F 8A               [ 1]    2     push cc ; (6,sp)
      0086A0 88               [ 1]    3     push a   ; (5,sp)
      0086A1 89               [ 2]    4     pushw x  ; (3,sp)
      0086A2 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086A4 CD 80 CC         [ 4]    3     call uart3_puts 
      0000C8                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086A7 90 85            [ 2]    2     popw y 
      0086A9 85               [ 2]    3     popw x 
      0086AA 84               [ 1]    4     pop a 
      0086AB 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0000CD                         87     _vars 6
      0086AC 52 06            [ 2]    1     sub sp,#6 
      0086AE AE 00 0C         [ 2]   88     ldw x,#12 
      0086B1 1F 05            [ 2]   89     ldw (5,sp),x
      0086B3 AE 00 6D         [ 2]   90     ldw x,#buffer
      0086B6 1F 03            [ 2]   91     ldw (3,sp),x 
      0086B8 1C 00 0C         [ 2]   92     addw x,#12  
      0086BB 1F 01            [ 2]   93     ldw (1,sp),x
      0086BD CD 8A 56         [ 4]   94     call memcpy  
      0000E1                         95     _drop 6 
      0086C0 5B 06            [ 2]    1     addw sp,#6 
      0086C2 90 AE 00 6D      [ 2]   96     ldw y,#buffer 
      0000E7                         97     _dbg_puts 
                           000001     1     .if DEBUG 
      0000E7                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086C6 8A               [ 1]    2     push cc ; (6,sp)
      0086C7 88               [ 1]    3     push a   ; (5,sp)
      0086C8 89               [ 2]    4     pushw x  ; (3,sp)
      0086C9 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086CB CD 80 CC         [ 4]    3     call uart3_puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      0000EF                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086CE 90 85            [ 2]    2     popw y 
      0086D0 85               [ 2]    3     popw x 
      0086D1 84               [ 1]    4     pop a 
      0086D2 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     98 ;;;;;;;;;;;;;;;;;;;;;;;;;;    
      0086D3 90 AE 87 FF      [ 2]   99     ldw y,#test_fill
      0000F8                        100     _dbg_puts 
                           000001     1     .if DEBUG 
      0000F8                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086D7 8A               [ 1]    2     push cc ; (6,sp)
      0086D8 88               [ 1]    3     push a   ; (5,sp)
      0086D9 89               [ 2]    4     pushw x  ; (3,sp)
      0086DA 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086DC CD 80 CC         [ 4]    3     call uart3_puts 
      000100                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086DF 90 85            [ 2]    2     popw y 
      0086E1 85               [ 2]    3     popw x 
      0086E2 84               [ 1]    4     pop a 
      0086E3 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      000105                        101     _vars 4
      0086E4 52 04            [ 2]    1     sub sp,#4 
      0086E6 AE 00 6D         [ 2]  102     ldw x,#buffer 
      0086E9 1F 01            [ 2]  103     ldw (1,sp),x 
      0086EB A6 40            [ 1]  104     ld a,#'@ 
      0086ED 6B 03            [ 1]  105     ld (3,sp),a 
      0086EF A6 18            [ 1]  106     ld a,#24 
      0086F1 6B 04            [ 1]  107     ld (4,sp),a 
      0086F3 CD 8A 2F         [ 4]  108     call fill
      000117                        109     _drop 4 
      0086F6 5B 04            [ 2]    1     addw sp,#4 
      0086F8 7F               [ 1]  110     clr (x) 
      0086F9 90 AE 00 6D      [ 2]  111     ldw y,#buffer 
      00011E                        112     _dbg_puts 
                           000001     1     .if DEBUG 
      00011E                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086FD 8A               [ 1]    2     push cc ; (6,sp)
      0086FE 88               [ 1]    3     push a   ; (5,sp)
      0086FF 89               [ 2]    4     pushw x  ; (3,sp)
      008700 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008702 CD 80 CC         [ 4]    3     call uart3_puts 
      000126                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008705 90 85            [ 2]    2     popw y 
      008707 85               [ 2]    3     popw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      008708 84               [ 1]    4     pop a 
      008709 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                    113 ;;;;;;;;;;;;;;;;;;;;;;;;;;;    
      00870A 90 AE 87 D5      [ 2]  114     ldw y,#test_i24toa
      00012F                        115     _dbg_puts 
                           000001     1     .if DEBUG 
      00012F                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00870E 8A               [ 1]    2     push cc ; (6,sp)
      00870F 88               [ 1]    3     push a   ; (5,sp)
      008710 89               [ 2]    4     pushw x  ; (3,sp)
      008711 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008713 CD 80 CC         [ 4]    3     call uart3_puts 
      000137                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008716 90 85            [ 2]    2     popw y 
      008718 85               [ 2]    3     popw x 
      008719 84               [ 1]    4     pop a 
      00871A 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      00013C                        116     _vars 6
      00871B 52 06            [ 2]    1     sub sp,#6 
      00871D AE 01 E2         [ 2]  117     ldw x,#0x1e2
      008720 A6 40            [ 1]  118     ld a,#0x40 
      008722 1F 01            [ 2]  119     ldw (1,sp),x 
      008724 6B 03            [ 1]  120     ld (3,sp),a 
      008726 A6 10            [ 1]  121     ld a,#16
      008728 6B 04            [ 1]  122     ld (4,sp),a  
      00872A AE 00 6D         [ 2]  123     ldw x,#buffer 
      00872D 1F 05            [ 2]  124     ldw (5,sp),x 
      00872F CD 89 37         [ 4]  125     call i24toa 
      000153                        126     _drop 6 
      008732 5B 06            [ 2]    1     addw sp,#6 
      008734 90 93            [ 1]  127     ldw y,x 
      000157                        128     _dbg_puts
                           000001     1     .if DEBUG 
      000157                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008736 8A               [ 1]    2     push cc ; (6,sp)
      008737 88               [ 1]    3     push a   ; (5,sp)
      008738 89               [ 2]    4     pushw x  ; (3,sp)
      008739 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00873B CD 80 CC         [ 4]    3     call uart3_puts 
      00015F                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      00873E 90 85            [ 2]    2     popw y 
      008740 85               [ 2]    3     popw x 
      008741 84               [ 1]    4     pop a 
      008742 86               [ 1]    5     pop cc 
                                      6     .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                                      5     .endif 
      008743 A6 0D            [ 1]  129     ld a,#CR 
      000166                        130     _dbg_putc  
                           000001     1     .if DEBUG
      000166                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      008745 8A               [ 1]    2     push cc ; (6,sp)
      008746 88               [ 1]    3     push a   ; (5,sp)
      008747 89               [ 2]    4     pushw x  ; (3,sp)
      008748 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00874A CD 80 BA         [ 4]    3     call uart3_putc 
      00016E                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      00874D 90 85            [ 2]    2     popw y 
      00874F 85               [ 2]    3     popw x 
      008750 84               [ 1]    4     pop a 
      008751 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      000173                        131     _vars 6 
      008752 52 06            [ 2]    1     sub sp,#6 
      008754 AE 12 34         [ 2]  132     ldw x,#0x1234
      008757 A6 56            [ 1]  133     ld a,#0x56 
      008759 1F 01            [ 2]  134     ldw (1,sp),x 
      00875B 6B 03            [ 1]  135     ld (3,sp),a 
      00875D AE 00 6D         [ 2]  136     ldw x,#buffer 
      008760 1F 05            [ 2]  137     ldw (5,sp),x 
      008762 A6 0A            [ 1]  138     ld a,#10 
      008764 6B 04            [ 1]  139     ld (4,sp),a 
      008766 CD 89 37         [ 4]  140     call i24toa 
      00018A                        141     _drop 6 
      008769 5B 06            [ 2]    1     addw sp,#6 
      00876B 90 93            [ 1]  142     ldw y,x 
      00018E                        143     _dbg_puts 
                           000001     1     .if DEBUG 
      00018E                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00876D 8A               [ 1]    2     push cc ; (6,sp)
      00876E 88               [ 1]    3     push a   ; (5,sp)
      00876F 89               [ 2]    4     pushw x  ; (3,sp)
      008770 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008772 CD 80 CC         [ 4]    3     call uart3_puts 
      000196                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008775 90 85            [ 2]    2     popw y 
      008777 85               [ 2]    3     popw x 
      008778 84               [ 1]    4     pop a 
      008779 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                    144 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
      00877A 90 AE 88 19      [ 2]  145     ldw y,#test_format
      00019F                        146     _dbg_puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                           000001     1     .if DEBUG 
      00019F                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00877E 8A               [ 1]    2     push cc ; (6,sp)
      00877F 88               [ 1]    3     push a   ; (5,sp)
      008780 89               [ 2]    4     pushw x  ; (3,sp)
      008781 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008783 CD 80 CC         [ 4]    3     call uart3_puts 
      0001A7                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008786 90 85            [ 2]    2     popw y 
      008788 85               [ 2]    3     popw x 
      008789 84               [ 1]    4     pop a 
      00878A 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                           000001   147     BUFF=1 ; 2
                           000003   148     FMT=3 ; 2 
                           000005   149     SPC1=5 ; 1 
                           000006   150     CHR1=6 ; 1
                           000007   151     SPC2=7 ; 1
                           000008   152     STR=8  ; 2
                           00000A   153     SPC3=10 ; 1 
                           00000B   154     I1=11  ; 3 
                           00000E   155     SPC4=14 ; 1 
                           00000F   156     I2 =15  ; 3
                           000012   157     VSIZE=I2+3   
      00878B 52 12            [ 2]  158     sub sp,#VSIZE 
      00878D A6 04            [ 1]  159     ld a,#4
      00878F 6B 05            [ 1]  160     ld (SPC1,sp),a 
      008791 6B 07            [ 1]  161     ld (SPC2,sp),a 
      008793 6B 0A            [ 1]  162     ld (SPC3,sp),a 
      008795 6B 0E            [ 1]  163     ld (SPC4,sp),a
      008797 AE 00 6D         [ 2]  164     ldw x,#buffer 
      00879A 1F 01            [ 2]  165     ldw (BUFF,sp),x  
      00879C AE 88 35         [ 2]  166     ldw x,#fmt 
      00879F 1F 03            [ 2]  167     ldw (FMT,sp),x 
      0087A1 A6 FF            [ 1]  168     ld a,#0xff
      0087A3 AE 02 7F         [ 2]  169     ldw x,#0x27f
      0087A6 6B 0D            [ 1]  170     ld (I1+2,sp),a 
      0087A8 1F 0B            [ 2]  171     ldw (I1,sp),x 
      0087AA A6 56            [ 1]  172     ld a,#0x56
      0087AC AE 12 34         [ 2]  173     ldw x,#0x1234
      0087AF 6B 11            [ 1]  174     ld (I2+2,sp),a 
      0087B1 1F 0F            [ 2]  175     ldw (I2,sp),x 
      0087B3 AE 88 51         [ 2]  176     ldw x,#hello 
      0087B6 1F 08            [ 2]  177     ldw (STR,sp),x  
      0087B8 A6 55            [ 1]  178     ld a,#'U 
      0087BA 6B 06            [ 1]  179     ld (CHR1,sp),a 
      0087BC CD 88 65         [ 4]  180     call format 
      0001E0                        181     _drop VSIZE 
      0087BF 5B 12            [ 2]    1     addw sp,#VSIZE 
      0087C1 90 AE 00 6D      [ 2]  182     ldw y,#buffer
      0001E6                        183     _dbg_puts  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                           000001     1     .if DEBUG 
      0001E6                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0087C5 8A               [ 1]    2     push cc ; (6,sp)
      0087C6 88               [ 1]    3     push a   ; (5,sp)
      0087C7 89               [ 2]    4     pushw x  ; (3,sp)
      0087C8 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087CA CD 80 CC         [ 4]    3     call uart3_puts 
      0001EE                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0087CD 90 85            [ 2]    2     popw y 
      0087CF 85               [ 2]    3     popw x 
      0087D0 84               [ 1]    4     pop a 
      0087D1 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0087D2 83               [ 9]  184     trap 
      0087D3 20 FE            [ 2]  185     jra .
                                    186 
      0087D5 0A 74 65 73 74 20 69   187 test_i24toa: .asciz "\ntest i24toa\n"
             32 34 74 6F 61 0A 00
      0087E3 0A 74 65 73 74 20 61   188 test_atoi24: .asciz "\ntest atoi24\n"
             74 6F 69 32 34 0A 00
      0087F1 0A 74 65 73 74 20 73   189 test_strlen: .asciz "\ntest strlen\n"
             74 72 6C 65 6E 0A 00
      0087FF 0A 74 65 73 74 20 66   190 test_fill: .asciz "\ntest fill\n"
             69 6C 6C 0A 00
      00880B 0A 74 65 73 74 20 6D   191 test_memcpy: .asciz "\ntest memcpy\n" 
             65 6D 63 70 79 0A 00
      008819 0A 74 65 73 74 20 66   192 test_format: .asciz "\ntest format\n"
             6F 72 6D 61 74 0A 00
      008827 0A 74 65 73 74 20 73   193 test_strcpy: .asciz "\ntest strcpy\n"
             74 72 63 70 79 0A 00
                                    194 
      008835 41 42 43 25 61 25 63   195 fmt: .asciz "ABC%a%c%a%s%a%d%a%x\n"
             25 61 25 73 25 61 25
             64 25 61 25 78 0A 00
      00884A 31 32 33 34 35 36 00   196 number: .asciz "123456"
      008851 48 65 6C 6C 6F 20 77   197 hello: .asciz "Hello world!"
             6F 72 6C 64 21 00
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]

Symbol Table

    .__.$$$.=  002710 L   |     .__.ABS.=  000000 G   |     .__.CPU.=  000000 L
    .__.H$L.=  000001 L   |     ADC_CR1 =  005401     |     ADC_CR1_=  000000 
    ADC_CR1_=  000001     |     ADC_CR1_=  000004     |     ADC_CR1_=  000005 
    ADC_CR1_=  000006     |     ADC_CR2 =  005402     |     ADC_CR2_=  000003 
    ADC_CR2_=  000004     |     ADC_CR2_=  000005     |     ADC_CR2_=  000006 
    ADC_CR2_=  000001     |     ADC_CR3 =  005403     |     ADC_CR3_=  000007 
    ADC_CR3_=  000006     |     ADC_CSR =  005400     |     ADC_CSR_=  000006 
    ADC_CSR_=  000004     |     ADC_CSR_=  000000     |     ADC_CSR_=  000001 
    ADC_CSR_=  000002     |     ADC_CSR_=  000003     |     ADC_CSR_=  000007 
    ADC_CSR_=  000005     |     ADC_DRH =  005404     |     ADC_DRL =  005405 
    ADC_TDRH=  005406     |     ADC_TDRL=  005407     |     AFR     =  004803 
    AFR0_ADC=  000000     |     AFR1_TIM=  000001     |     AFR2_CCO=  000002 
    AFR3_TIM=  000003     |     AFR4_TIM=  000004     |     AFR5_TIM=  000005 
    AFR6_I2C=  000006     |     AFR7_BEE=  000007     |     AWU_APR =  0050F1 
    AWU_CSR1=  0050F0     |     AWU_TBR =  0050F2     |     B0_MASK =  000001 
    B115200 =  000006     |     B19200  =  000003     |     B1_MASK =  000002 
    B230400 =  000007     |     B2400   =  000000     |     B2_MASK =  000004 
    B38400  =  000004     |     B3_MASK =  000008     |     B460800 =  000008 
    B4800   =  000001     |     B4_MASK =  000010     |     B57600  =  000005 
    B5_MASK =  000020     |     B6_MASK =  000040     |     B7_MASK =  000080 
    B921600 =  000009     |     B9600   =  000002     |     BEEP_BIT=  000004 
    BEEP_CSR=  0050F3     |     BEEP_MAS=  000010     |     BEEP_POR=  00000F 
    BELL    =  000007     |     BIT0    =  000000     |     BIT1    =  000001 
    BIT2    =  000002     |     BIT3    =  000003     |     BIT4    =  000004 
    BIT5    =  000005     |     BIT6    =  000006     |     BIT7    =  000007 
    BOOT_ROM=  006000     |     BOOT_ROM=  007FFF     |     BSP     =  000008 
    BUFF    =  000001     |     CAN_DGR =  005426     |     CAN_FPSR=  005427 
    CAN_IER =  005425     |     CAN_MCR =  005420     |     CAN_MSR =  005421 
    CAN_P0  =  005428     |     CAN_P1  =  005429     |     CAN_P2  =  00542A 
    CAN_P3  =  00542B     |     CAN_P4  =  00542C     |     CAN_P5  =  00542D 
    CAN_P6  =  00542E     |     CAN_P7  =  00542F     |     CAN_P8  =  005430 
    CAN_P9  =  005431     |     CAN_PA  =  005432     |     CAN_PB  =  005433 
    CAN_PC  =  005434     |     CAN_PD  =  005435     |     CAN_PE  =  005436 
    CAN_PF  =  005437     |     CAN_RFR =  005424     |     CAN_TPR =  005423 
    CAN_TSR =  005422     |     CC_C    =  000000     |     CC_H    =  000004 
    CC_I0   =  000003     |     CC_I1   =  000005     |     CC_N    =  000002 
    CC_V    =  000007     |     CC_Z    =  000001     |     CFG_GCR =  007F60 
    CFG_GCR_=  000001     |     CFG_GCR_=  000000     |     CHR1    =  000006 
    CLKOPT  =  004807     |     CLKOPT_C=  000002     |     CLKOPT_E=  000003 
    CLKOPT_P=  000000     |     CLKOPT_P=  000001     |     CLK_CCOR=  0050C9 
    CLK_CKDI=  0050C6     |     CLK_CKDI=  000000     |     CLK_CKDI=  000001 
    CLK_CKDI=  000002     |     CLK_CKDI=  000003     |     CLK_CKDI=  000004 
    CLK_CMSR=  0050C3     |     CLK_CSSR=  0050C8     |     CLK_ECKR=  0050C1 
    CLK_ECKR=  000000     |     CLK_ECKR=  000001     |     CLK_HSIT=  0050CC 
    CLK_ICKR=  0050C0     |     CLK_ICKR=  000002     |     CLK_ICKR=  000000 
    CLK_ICKR=  000001     |     CLK_ICKR=  000003     |     CLK_ICKR=  000004 
    CLK_ICKR=  000005     |     CLK_PCKE=  0050C7     |     CLK_PCKE=  000000 
    CLK_PCKE=  000001     |     CLK_PCKE=  000007     |     CLK_PCKE=  000005 
    CLK_PCKE=  000006     |     CLK_PCKE=  000004     |     CLK_PCKE=  000002 
    CLK_PCKE=  000003     |     CLK_PCKE=  0050CA     |     CLK_PCKE=  000003 
    CLK_PCKE=  000002     |     CLK_PCKE=  000007     |     CLK_SWCR=  0050C5 
    CLK_SWCR=  000000     |     CLK_SWCR=  000001     |     CLK_SWCR=  000002 
    CLK_SWCR=  000003     |     CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4 
    CLK_SWR_=  0000B4     |     CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2 
    CPU_A   =  007F00     |     CPU_CCR =  007F0A     |     CPU_PCE =  007F01 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]

Symbol Table

    CPU_PCH =  007F02     |     CPU_PCL =  007F03     |     CPU_SPH =  007F08 
    CPU_SPL =  007F09     |     CPU_XH  =  007F04     |     CPU_XL  =  007F05 
    CPU_YH  =  007F06     |     CPU_YL  =  007F07     |     CR      =  00000D 
    CTRL_A  =  000001     |     CTRL_B  =  000002     |     CTRL_C  =  000003 
    CTRL_D  =  000004     |     CTRL_E  =  000005     |     CTRL_F  =  000006 
    CTRL_G  =  000007     |     CTRL_H  =  000008     |     CTRL_I  =  000009 
    CTRL_J  =  00000A     |     CTRL_K  =  00000B     |     CTRL_L  =  00000C 
    CTRL_M  =  00000D     |     CTRL_N  =  00000E     |     CTRL_O  =  00000F 
    CTRL_P  =  000010     |     CTRL_Q  =  000011     |     CTRL_R  =  000012 
    CTRL_S  =  000013     |     CTRL_T  =  000014     |     CTRL_U  =  000015 
    CTRL_V  =  000016     |     CTRL_W  =  000017     |     CTRL_X  =  000018 
    CTRL_Y  =  000019     |     CTRL_Z  =  00001A     |     DBG_A   =  000005 
    DBG_CC  =  000006     |     DBG_X   =  000003     |     DBG_Y   =  000001 
    DEBUG   =  000001     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
    DEVID_BA=  0048CD     |     DEVID_EN=  0048D8     |     DEVID_LO=  0048D2 
    DEVID_LO=  0048D3     |     DEVID_LO=  0048D4     |     DEVID_LO=  0048D5 
    DEVID_LO=  0048D6     |     DEVID_LO=  0048D7     |     DEVID_LO=  0048D8 
    DEVID_WA=  0048D1     |     DEVID_XH=  0048CE     |     DEVID_XL=  0048CD 
    DEVID_YH=  0048D0     |     DEVID_YL=  0048CF     |     DM_BK1RE=  007F90 
    DM_BK1RH=  007F91     |     DM_BK1RL=  007F92     |     DM_BK2RE=  007F93 
    DM_BK2RH=  007F94     |     DM_BK2RL=  007F95     |     DM_CR1  =  007F96 
    DM_CR2  =  007F97     |     DM_CSR1 =  007F98     |     DM_CSR2 =  007F99 
    DM_ENFCT=  007F9A     |     EEPROM_B=  004000     |     EEPROM_E=  0047FF 
    EEPROM_S=  000800     |     ESC     =  00001B     |     EXTI_CR1=  0050A0 
    EXTI_CR2=  0050A1     |     FF      =  00000C     |     FHSE    =  7A1200 
    FHSI    =  F42400     |     FLASH_BA=  008000     |     FLASH_CR=  00505A 
    FLASH_CR=  000002     |     FLASH_CR=  000000     |     FLASH_CR=  000003 
    FLASH_CR=  000001     |     FLASH_CR=  00505B     |     FLASH_CR=  000005 
    FLASH_CR=  000004     |     FLASH_CR=  000007     |     FLASH_CR=  000000 
    FLASH_CR=  000006     |     FLASH_DU=  005064     |     FLASH_DU=  0000AE 
    FLASH_DU=  000056     |     FLASH_EN=  027FFF     |     FLASH_FP=  00505D 
    FLASH_FP=  000000     |     FLASH_FP=  000001     |     FLASH_FP=  000002 
    FLASH_FP=  000003     |     FLASH_FP=  000004     |     FLASH_FP=  000005 
    FLASH_IA=  00505F     |     FLASH_IA=  000003     |     FLASH_IA=  000002 
    FLASH_IA=  000006     |     FLASH_IA=  000001     |     FLASH_IA=  000000 
    FLASH_NC=  00505C     |     FLASH_NF=  00505E     |     FLASH_NF=  000000 
    FLASH_NF=  000001     |     FLASH_NF=  000002     |     FLASH_NF=  000003 
    FLASH_NF=  000004     |     FLASH_NF=  000005     |     FLASH_PU=  005062 
    FLASH_PU=  000056     |     FLASH_PU=  0000AE     |     FLASH_SI=  020000 
    FLASH_WS=  00480D     |     FLSI    =  01F400     |     FMT     =  000003 
    GPIO_BAS=  005000     |     GPIO_CR1=  000003     |     GPIO_CR2=  000004 
    GPIO_DDR=  000002     |     GPIO_IDR=  000001     |     GPIO_ODR=  000000 
    GPIO_SIZ=  000005     |     HSECNT  =  004809     |     I1      =  00000B 
    I2      =  00000F     |     I2C_CCRH=  00521C     |     I2C_CCRH=  000080 
    I2C_CCRH=  0000C0     |     I2C_CCRH=  000080     |     I2C_CCRH=  000000 
    I2C_CCRH=  000001     |     I2C_CCRH=  000000     |     I2C_CCRL=  00521B 
    I2C_CCRL=  00001A     |     I2C_CCRL=  000002     |     I2C_CCRL=  00000D 
    I2C_CCRL=  000050     |     I2C_CCRL=  000090     |     I2C_CCRL=  0000A0 
    I2C_CR1 =  005210     |     I2C_CR1_=  000006     |     I2C_CR1_=  000007 
    I2C_CR1_=  000000     |     I2C_CR2 =  005211     |     I2C_CR2_=  000002 
    I2C_CR2_=  000003     |     I2C_CR2_=  000000     |     I2C_CR2_=  000001 
    I2C_CR2_=  000007     |     I2C_DR  =  005216     |     I2C_FREQ=  005212 
    I2C_ITR =  00521A     |     I2C_ITR_=  000002     |     I2C_ITR_=  000000 
    I2C_ITR_=  000001     |     I2C_OARH=  005214     |     I2C_OARH=  000001 
    I2C_OARH=  000002     |     I2C_OARH=  000006     |     I2C_OARH=  000007 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]

Symbol Table

    I2C_OARL=  005213     |     I2C_OARL=  000000     |     I2C_OAR_=  000813 
    I2C_OAR_=  000009     |     I2C_PECR=  00521E     |     I2C_READ=  000001 
    I2C_SR1 =  005217     |     I2C_SR1_=  000003     |     I2C_SR1_=  000001 
    I2C_SR1_=  000002     |     I2C_SR1_=  000006     |     I2C_SR1_=  000000 
    I2C_SR1_=  000004     |     I2C_SR1_=  000007     |     I2C_SR2 =  005218 
    I2C_SR2_=  000002     |     I2C_SR2_=  000001     |     I2C_SR2_=  000000 
    I2C_SR2_=  000003     |     I2C_SR2_=  000005     |     I2C_SR3 =  005219 
    I2C_SR3_=  000001     |     I2C_SR3_=  000007     |     I2C_SR3_=  000004 
    I2C_SR3_=  000000     |     I2C_SR3_=  000002     |     I2C_TRIS=  00521D 
    I2C_TRIS=  000005     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000011     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_WRIT=  000000     |     INPUT_DI=  000000     |     INPUT_EI=  000001 
    INPUT_FL=  000000     |     INPUT_PU=  000001     |     INT_ADC2=  000016 
    INT_AUAR=  000012     |     INT_AWU =  000001     |     INT_CAN_=  000008 
    INT_CAN_=  000009     |     INT_CLK =  000002     |     INT_EXTI=  000003 
    INT_EXTI=  000004     |     INT_EXTI=  000005     |     INT_EXTI=  000006 
    INT_EXTI=  000007     |     INT_FLAS=  000018     |     INT_I2C =  000013 
    INT_SPI =  00000A     |     INT_TIM1=  00000C     |     INT_TIM1=  00000B 
    INT_TIM2=  00000E     |     INT_TIM2=  00000D     |     INT_TIM3=  000010 
    INT_TIM3=  00000F     |     INT_TIM4=  000017     |     INT_TLI =  000000 
    INT_UART=  000011     |     INT_UART=  000015     |     INT_UART=  000014 
    INT_VECT=  008060     |     INT_VECT=  00800C     |     INT_VECT=  008028 
    INT_VECT=  00802C     |     INT_VECT=  008010     |     INT_VECT=  008014 
    INT_VECT=  008018     |     INT_VECT=  00801C     |     INT_VECT=  008020 
    INT_VECT=  008024     |     INT_VECT=  008068     |     INT_VECT=  008054 
    INT_VECT=  008000     |     INT_VECT=  008030     |     INT_VECT=  008038 
    INT_VECT=  008034     |     INT_VECT=  008040     |     INT_VECT=  00803C 
    INT_VECT=  008048     |     INT_VECT=  008044     |     INT_VECT=  008064 
    INT_VECT=  008008     |     INT_VECT=  008004     |     INT_VECT=  008050 
    INT_VECT=  00804C     |     INT_VECT=  00805C     |     INT_VECT=  008058 
    ITC_SPR1=  007F70     |     ITC_SPR2=  007F71     |     ITC_SPR3=  007F72 
    ITC_SPR4=  007F73     |     ITC_SPR5=  007F74     |     ITC_SPR6=  007F75 
    ITC_SPR7=  007F76     |     ITC_SPR8=  007F77     |     IWDG_KR =  0050E0 
    IWDG_PR =  0050E1     |     IWDG_RLR=  0050E2     |     LED2_BIT=  000005 
    LED2_MAS=  000020     |     LED2_POR=  00500A     |     NAFR    =  004804 
    NCLKOPT =  004808     |     NFLASH_W=  00480E     |     NHSECNT =  00480A 
    NL      =  00000A     |     NOPT1   =  004802     |     NOPT2   =  004804 
    NOPT3   =  004806     |     NOPT4   =  004808     |     NOPT5   =  00480A 
    NOPT6   =  00480C     |     NOPT7   =  00480E     |     NOPTBL  =  00487F 
    NUBC    =  004802     |     NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD 
    NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE 
    OPT0    =  004800     |     OPT1    =  004801     |     OPT2    =  004803 
    OPT3    =  004805     |     OPT4    =  004807     |     OPT5    =  004809 
    OPT6    =  00480B     |     OPT7    =  00480D     |     OPTBL   =  00487E 
    OPTION_B=  004800     |     OPTION_E=  00487F     |     OUTPUT_F=  000001 
    OUTPUT_O=  000000     |     OUTPUT_P=  000001     |     OUTPUT_S=  000000 
    PA      =  000000     |     PA_BASE =  005000     |     PA_CR1  =  005003 
    PA_CR2  =  005004     |     PA_DDR  =  005002     |     PA_IDR  =  005001 
    PA_ODR  =  005000     |     PB      =  000005     |     PB_BASE =  005005 
    PB_CR1  =  005008     |     PB_CR2  =  005009     |     PB_DDR  =  005007 
    PB_IDR  =  005006     |     PB_ODR  =  005005     |     PC      =  00000A 
    PC_BASE =  00500A     |     PC_CR1  =  00500D     |     PC_CR2  =  00500E 
    PC_DDR  =  00500C     |     PC_IDR  =  00500B     |     PC_ODR  =  00500A 
    PD      =  00000F     |     PD_BASE =  00500F     |     PD_CR1  =  005012 
    PD_CR2  =  005013     |     PD_DDR  =  005011     |     PD_IDR  =  005010 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]

Symbol Table

    PD_ODR  =  00500F     |     PE      =  000014     |     PE_BASE =  005014 
    PE_CR1  =  005017     |     PE_CR2  =  005018     |     PE_DDR  =  005016 
    PE_IDR  =  005015     |     PE_ODR  =  005014     |     PF      =  000019 
    PF_BASE =  005019     |     PF_CR1  =  00501C     |     PF_CR2  =  00501D 
    PF_DDR  =  00501B     |     PF_IDR  =  00501A     |     PF_ODR  =  005019 
    PG      =  00001E     |     PG_BASE =  00501E     |     PG_CR1  =  005021 
    PG_CR2  =  005022     |     PG_DDR  =  005020     |     PG_IDR  =  00501F 
    PG_ODR  =  00501E     |     PH_BASE =  005023     |     PH_CR1  =  005026 
    PH_CR2  =  005027     |     PH_DDR  =  005025     |     PH_IDR  =  005024 
    PH_ODR  =  005023     |     PI_BASE =  005028     |     PI_CR1  =  00502B 
    PI_CR2  =  00502C     |     PI_DDR  =  00502A     |     PI_IDR  =  005029 
    PI_ODR  =  005028     |     RAM_BASE=  000000     |     RAM_END =  0017FF 
    RAM_SIZE=  001800     |     ROP     =  004800     |     RST_SR  =  0050B3 
    SFR_BASE=  005000     |     SFR_END =  0057FF     |     SPACE   =  000020 
    SPC1    =  000005     |     SPC2    =  000007     |     SPC3    =  00000A 
    SPC4    =  00000E     |     SPI_CR1 =  005200     |     SPI_CR2 =  005201 
    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_TXCR=  005207 
    STR     =  000008     |     SWIM_CSR=  007F80     |     TAB     =  000009 
    TIM1_ARR=  005262     |     TIM1_ARR=  005263     |     TIM1_BKR=  00526D 
    TIM1_CCE=  00525C     |     TIM1_CCE=  00525D     |     TIM1_CCM=  005258 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  005259 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  00525A 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  00525B 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCR=  005265 
    TIM1_CCR=  005266     |     TIM1_CCR=  005267     |     TIM1_CCR=  005268 
    TIM1_CCR=  005269     |     TIM1_CCR=  00526A     |     TIM1_CCR=  00526B 
    TIM1_CCR=  00526C     |     TIM1_CNT=  00525E     |     TIM1_CNT=  00525F 
    TIM1_CR1=  005250     |     TIM1_CR2=  005251     |     TIM1_CR2=  000000 
    TIM1_CR2=  000002     |     TIM1_CR2=  000004     |     TIM1_CR2=  000005 
    TIM1_CR2=  000006     |     TIM1_DTR=  00526E     |     TIM1_EGR=  005257 
    TIM1_EGR=  000007     |     TIM1_EGR=  000001     |     TIM1_EGR=  000002 
    TIM1_EGR=  000003     |     TIM1_EGR=  000004     |     TIM1_EGR=  000005 
    TIM1_EGR=  000006     |     TIM1_EGR=  000000     |     TIM1_ETR=  005253 
    TIM1_ETR=  000006     |     TIM1_ETR=  000000     |     TIM1_ETR=  000001 
    TIM1_ETR=  000002     |     TIM1_ETR=  000003     |     TIM1_ETR=  000007 
    TIM1_ETR=  000004     |     TIM1_ETR=  000005     |     TIM1_IER=  005254 
    TIM1_IER=  000007     |     TIM1_IER=  000001     |     TIM1_IER=  000002 
    TIM1_IER=  000003     |     TIM1_IER=  000004     |     TIM1_IER=  000005 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]

Symbol Table

    TIM1_IER=  000006     |     TIM1_IER=  000000     |     TIM1_OIS=  00526F 
    TIM1_PSC=  005260     |     TIM1_PSC=  005261     |     TIM1_RCR=  005264 
    TIM1_SMC=  005252     |     TIM1_SMC=  000007     |     TIM1_SMC=  000000 
    TIM1_SMC=  000001     |     TIM1_SMC=  000002     |     TIM1_SMC=  000004 
    TIM1_SMC=  000005     |     TIM1_SMC=  000006     |     TIM1_SR1=  005255 
    TIM1_SR1=  000007     |     TIM1_SR1=  000001     |     TIM1_SR1=  000002 
    TIM1_SR1=  000003     |     TIM1_SR1=  000004     |     TIM1_SR1=  000005 
    TIM1_SR1=  000006     |     TIM1_SR1=  000000     |     TIM1_SR2=  005256 
    TIM1_SR2=  000001     |     TIM1_SR2=  000002     |     TIM1_SR2=  000003 
    TIM1_SR2=  000004     |     TIM2_ARR=  00530D     |     TIM2_ARR=  00530E 
    TIM2_CCE=  005308     |     TIM2_CCE=  005309     |     TIM2_CCM=  005305 
    TIM2_CCM=  005306     |     TIM2_CCM=  005307     |     TIM2_CCR=  00530F 
    TIM2_CCR=  005310     |     TIM2_CCR=  005311     |     TIM2_CCR=  005312 
    TIM2_CCR=  005313     |     TIM2_CCR=  005314     |     TIM2_CNT=  00530A 
    TIM2_CNT=  00530B     |     TIM2_CR1=  005300     |     TIM2_EGR=  005304 
    TIM2_IER=  005301     |     TIM2_PSC=  00530C     |     TIM2_SR1=  005302 
    TIM2_SR2=  005303     |     TIM3_ARR=  00532B     |     TIM3_ARR=  00532C 
    TIM3_CCE=  005327     |     TIM3_CCE=  000000     |     TIM3_CCE=  000001 
    TIM3_CCE=  000004     |     TIM3_CCE=  000005     |     TIM3_CCE=  000000 
    TIM3_CCE=  000001     |     TIM3_CCM=  005325     |     TIM3_CCM=  005326 
    TIM3_CCM=  000000     |     TIM3_CCM=  000004     |     TIM3_CCM=  000003 
    TIM3_CCR=  00532D     |     TIM3_CCR=  00532E     |     TIM3_CCR=  00532F 
    TIM3_CCR=  005330     |     TIM3_CNT=  005328     |     TIM3_CNT=  005329 
    TIM3_CR1=  005320     |     TIM3_CR1=  000007     |     TIM3_CR1=  000000 
    TIM3_CR1=  000003     |     TIM3_CR1=  000001     |     TIM3_CR1=  000002 
    TIM3_EGR=  005324     |     TIM3_IER=  005321     |     TIM3_PSC=  00532A 
    TIM3_SR1=  005322     |     TIM3_SR2=  005323     |     TIM4_ARR=  005346 
    TIM4_CNT=  005344     |     TIM4_CR1=  005340     |     TIM4_CR1=  000007 
    TIM4_CR1=  000000     |     TIM4_CR1=  000003     |     TIM4_CR1=  000001 
    TIM4_CR1=  000002     |     TIM4_EGR=  005343     |     TIM4_EGR=  000000 
    TIM4_IER=  005341     |     TIM4_IER=  000000     |     TIM4_PSC=  005345 
    TIM4_PSC=  000000     |     TIM4_PSC=  000007     |     TIM4_PSC=  000004 
    TIM4_PSC=  000001     |     TIM4_PSC=  000005     |     TIM4_PSC=  000002 
    TIM4_PSC=  000006     |     TIM4_PSC=  000003     |     TIM4_PSC=  000000 
    TIM4_PSC=  000001     |     TIM4_PSC=  000002     |     TIM4_SR =  005342 
    TIM4_SR_=  000000     |     TIM_CR1_=  000007     |     TIM_CR1_=  000000 
    TIM_CR1_=  000006     |     TIM_CR1_=  000005     |     TIM_CR1_=  000004 
    TIM_CR1_=  000003     |     TIM_CR1_=  000001     |     TIM_CR1_=  000002 
    UART1   =  000000     |     UART1_BA=  005230     |     UART1_BR=  005232 
    UART1_BR=  005233     |     UART1_CR=  005234     |     UART1_CR=  005235 
    UART1_CR=  005236     |     UART1_CR=  005237     |     UART1_CR=  005238 
    UART1_DR=  005231     |     UART1_GT=  005239     |     UART1_PO=  000000 
    UART1_PS=  00523A     |     UART1_RX=  000004     |     UART1_SR=  005230 
    UART1_TX=  000005     |     UART3   =  000001     |     UART3_BA=  005240 
    UART3_BR=  005242     |     UART3_BR=  005243     |     UART3_CR=  005244 
    UART3_CR=  005245     |     UART3_CR=  005246     |     UART3_CR=  005247 
    UART3_CR=  004249     |     UART3_DR=  005241     |     UART3_PO=  00000F 
    UART3_RX=  000006     |     UART3_SR=  005240     |     UART3_TX=  000005 
    UART_BRR=  000002     |     UART_BRR=  000003     |     UART_CR1=  000004 
    UART_CR1=  000004     |     UART_CR1=  000002     |     UART_CR1=  000000 
    UART_CR1=  000001     |     UART_CR1=  000007     |     UART_CR1=  000006 
    UART_CR1=  000005     |     UART_CR1=  000003     |     UART_CR2=  000005 
    UART_CR2=  000004     |     UART_CR2=  000002     |     UART_CR2=  000005 
    UART_CR2=  000001     |     UART_CR2=  000000     |     UART_CR2=  000006 
    UART_CR2=  000003     |     UART_CR2=  000007     |     UART_CR3=  000006 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]

Symbol Table

    UART_CR3=  000003     |     UART_CR3=  000001     |     UART_CR3=  000002 
    UART_CR3=  000000     |     UART_CR3=  000006     |     UART_CR3=  000004 
    UART_CR3=  000005     |     UART_CR4=  000007     |     UART_CR4=  000000 
    UART_CR4=  000001     |     UART_CR4=  000002     |     UART_CR4=  000003 
    UART_CR4=  000004     |     UART_CR4=  000006     |     UART_CR4=  000005 
    UART_CR5=  000008     |     UART_CR5=  000003     |     UART_CR5=  000001 
    UART_CR5=  000002     |     UART_CR5=  000004     |     UART_CR5=  000005 
    UART_CR6=  000009     |     UART_CR6=  000004     |     UART_CR6=  000007 
    UART_CR6=  000001     |     UART_CR6=  000002     |     UART_CR6=  000000 
    UART_CR6=  000005     |     UART_DR =  000001     |     UART_GTR=  000009 
    UART_PSC=  00000A     |     UART_SR =  000000     |     UART_SR_=  000001 
    UART_SR_=  000004     |     UART_SR_=  000002     |     UART_SR_=  000003 
    UART_SR_=  000000     |     UART_SR_=  000005     |     UART_SR_=  000006 
    UART_SR_=  000007     |     UBC     =  004801     |     USR_BTN_=  000004 
    USR_BTN_=  000010     |     USR_BTN_=  005015     |     VSIZE   =  000012 
    VT      =  00000B     |     WDGOPT  =  004805     |     WDGOPT_I=  000002 
    WDGOPT_L=  000003     |     WDGOPT_W=  000000     |     WDGOPT_W=  000001 
    WWDG_CR =  0050D1     |     WWDG_WR =  0050D2     |     acc16      ****** GX
    acc24      ****** GX  |     atoi24     ****** GX  |   1 buffer     000000 GR
    fill       ****** GX  |   2 fmt        000256 R   |     format     ****** GX
  2 hello      000272 R   |     i24toa     ****** GX  |     memcpy     ****** GX
  2 number     00026B R   |     strcpy     ****** GX  |     strlen     ****** GX
  2 test_ato   000204 R   |   2 test_fil   000220 R   |   2 test_for   00023A R
  2 test_i24   0001F6 R   |   2 test_mai   000000 GR  |   2 test_mem   00022C R
  2 test_str   000248 R   |   2 test_str   000212 R   |     uart3_pr   ****** GX
    uart3_pr   ****** GX  |     uart3_pu   ****** GX  |     uart3_pu   ****** GX

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size     50   flags    0
   2 CODE       size    27F   flags    0

