ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ; test pour librairie math24.lib 
                                      2 
                                      3 
                                      4     .module MATH24_TEST
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
                                        
                                            .macro _dbg_parser_init 
                                        
                                            .macro _dbg_readln
                                        
                                            .macro _dbg_number 
                                        
                                            .macro _dbg_nextword
                                        
                                     10     .list 
                                     11 
                                     12     .area CODE
      0085ED                         13 _dbg 
                           000001     1     DEBUG=1
                                     14 
      0085ED                         15 test_main::
                           000000    16     IDX_ERR_SUM=0
                           000001    17     IDX_ERR_SUB=1 
                           000002    18     IDX_ERR_MUL=2
                           000003    19     IDX_ERR_DIV=3
                           000004    20     IDX_ERR_NEG=4
                                     21 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



      000000                         22 presentation:
      0085ED 90 AE 88 5C      [ 2]   23     ldw y,#whatisit
      000004                         24     _dbg_puts  
                           000001     1     .if DEBUG 
      000004                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0085F1 8A               [ 1]    2     push cc ; (6,sp)
      0085F2 88               [ 1]    3     push a   ; (5,sp)
      0085F3 89               [ 2]    4     pushw x  ; (3,sp)
      0085F4 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0085F6 CD 80 CC         [ 4]    3     call uart3_puts 
      00000C                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0085F9 90 85            [ 2]    2     popw y 
      0085FB 85               [ 2]    3     popw x 
      0085FC 84               [ 1]    4     pop a 
      0085FD 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     25     
      0085FE                         26 repl:
      000011                         27     _dbg_parser_init
                           000001     1     .if DEBUG 
      000011                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0085FE 8A               [ 1]    2     push cc ; (6,sp)
      0085FF 88               [ 1]    3     push a   ; (5,sp)
      008600 89               [ 2]    4     pushw x  ; (3,sp)
      008601 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008603 CD 83 26         [ 4]    3     call parser_init 
      000019                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008606 90 85            [ 2]    2     popw y 
      008608 85               [ 2]    3     popw x 
      008609 84               [ 1]    4     pop a 
      00860A 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
                                     28 ; move terminal cursor to next line
      00860B A6 0A            [ 1]   29 	ld a,#NL 
      000020                         30 	_dbg_putc 
                           000001     1     .if DEBUG
      000020                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      00860D 8A               [ 1]    2     push cc ; (6,sp)
      00860E 88               [ 1]    3     push a   ; (5,sp)
      00860F 89               [ 2]    4     pushw x  ; (3,sp)
      008610 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008612 CD 80 BA         [ 4]    3     call uart3_putc 
      000028                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      008615 90 85            [ 2]    2     popw y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



      008617 85               [ 2]    3     popw x 
      008618 84               [ 1]    4     pop a 
      008619 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     31 ; print prompt sign	 
      00861A A6 3E            [ 1]   32 	ld a,#'>
      00002F                         33 	_dbg_putc 
                           000001     1     .if DEBUG
      00002F                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      00861C 8A               [ 1]    2     push cc ; (6,sp)
      00861D 88               [ 1]    3     push a   ; (5,sp)
      00861E 89               [ 2]    4     pushw x  ; (3,sp)
      00861F 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008621 CD 80 BA         [ 4]    3     call uart3_putc 
      000037                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      008624 90 85            [ 2]    2     popw y 
      008626 85               [ 2]    3     popw x 
      008627 84               [ 1]    4     pop a 
      008628 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
                                     34 ; read command line	
      00003C                         35 	_dbg_readln 
                           000001     1     .if DEBUG 
      00003C                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008629 8A               [ 1]    2     push cc ; (6,sp)
      00862A 88               [ 1]    3     push a   ; (5,sp)
      00862B 89               [ 2]    4     pushw x  ; (3,sp)
      00862C 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00862E CD 83 C7         [ 4]    3     call uart3_readln
      000044                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008631 90 85            [ 2]    2     popw y 
      008633 85               [ 2]    3     popw x 
      008634 84               [ 1]    4     pop a 
      008635 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
                                     36 ;if empty line -> ignore it, loop.	
      008636 72 5D 00 01      [ 1]   37 	tnz tib
      00863A 27 C2            [ 1]   38 	jreq repl
                                     39 ; initialize parser and call eval function	  
      00863C CD 86 41         [ 4]   40 	call eval
                                     41 ; start over	
      00863F 20 BD            [ 2]   42 	jra repl  ; loop
                                     43 
                                     44 ; arguments locales 
                           000001    45     N1=1
                           000004    46     N2=4
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                           000007    47     OP=7
                           000007    48     LOCAL_SIZE=7  
      008641                         49 eval:
      008641 52 07            [ 2]   50     sub sp,#LOCAL_SIZE 
      000056                         51     _dbg_nextword 
                           000001     1     .if DEBUG 
      000056                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008643 8A               [ 1]    2     push cc ; (6,sp)
      008644 88               [ 1]    3     push a   ; (5,sp)
      008645 89               [ 2]    4     pushw x  ; (3,sp)
      008646 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008648 CD 84 F9         [ 4]    3     call next_word  
      00005E                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      00864B 90 85            [ 2]    2     popw y 
      00864D 85               [ 2]    3     popw x 
      00864E 84               [ 1]    4     pop a 
      00864F 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
      008650 C6 00 51         [ 1]   52     ld a,pad 
      008653 6B 07            [ 1]   53     ld (OP,sp),a
      000068                         54     _dbg_number
                           000001     1     .if DEBUG 
      000068                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      008655 8A               [ 1]    2     push cc ; (6,sp)
      008656 88               [ 1]    3     push a   ; (5,sp)
      008657 89               [ 2]    4     pushw x  ; (3,sp)
      008658 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00865A CD 84 F2         [ 4]    3     call number 
      000070                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      00865D 90 85            [ 2]    2     popw y 
      00865F 85               [ 2]    3     popw x 
      008660 84               [ 1]    4     pop a 
      008661 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
      008662 CE 00 A3         [ 2]   55     ldw x,acc24
      008665 1F 01            [ 2]   56     ldw (N1,sp),x
      008667 C6 00 A5         [ 1]   57     ld a,acc8  
      00866A 6B 03            [ 1]   58     ld (N1+2,sp),a 
      00007F                         59     _dbg_number
                           000001     1     .if DEBUG 
      00007F                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00866C 8A               [ 1]    2     push cc ; (6,sp)
      00866D 88               [ 1]    3     push a   ; (5,sp)
      00866E 89               [ 2]    4     pushw x  ; (3,sp)
      00866F 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      008671 CD 84 F2         [ 4]    3     call number 
      000087                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008674 90 85            [ 2]    2     popw y 
      008676 85               [ 2]    3     popw x 
      008677 84               [ 1]    4     pop a 
      008678 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
      008679 CE 00 A3         [ 2]   60     ldw x,acc24 
      00867C 1F 04            [ 2]   61     ldw (N2,sp),x
      00867E C6 00 A5         [ 1]   62     ld a, acc8  
      008681 6B 06            [ 1]   63     ld (N2+2,sp),a  
      008683 7B 07            [ 1]   64     ld a,(OP,sp)
      008685 A1 2B            [ 1]   65     cp a,#'+
      008687 26 03            [ 1]   66     jrne 1$
      008689 CC 86 B2         [ 2]   67     jp test_add
      00868C A1 2D            [ 1]   68 1$: cp a,#'- 
      00868E 26 03            [ 1]   69     jrne 2$ 
      008690 CC 86 CF         [ 2]   70     jp test_sub 
      008693 A1 2A            [ 1]   71 2$: cp a,#'* 
      008695 26 03            [ 1]   72     jrne 3$ 
      008697 CC 86 EC         [ 2]   73     jp test_mul 
      00869A A1 2F            [ 1]   74 3$: cp a,#'/ 
      00869C 26 03            [ 1]   75     jrne 4$ 
      00869E CC 87 09         [ 2]   76     jp test_div 
      0086A1 A1 6E            [ 1]   77 4$: cp a,#'n 
      0086A3 26 03            [ 1]   78     jrne 5$
      0086A5 CC 87 4B         [ 2]   79     jp test_neg
      0086A8                         80 5$:
      0086A8 A1 63            [ 1]   81     cp a,#'c 
      0086AA 26 03            [ 1]   82     jrne 6$
      0086AC CC 87 76         [ 2]   83     jp test_cmp
      0086AF                         84 6$:
      0086AF                         85 eval_exit:
      0086AF 5B 07            [ 2]   86     addw sp,#LOCAL_SIZE 
      0086B1 81               [ 4]   87     ret 
                                     88 
      0086B2                         89 test_add:
      0086B2 90 AE 88 7D      [ 2]   90     ldw y,#add24_test
      0000C9                         91     _dbg_puts 
                           000001     1     .if DEBUG 
      0000C9                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086B6 8A               [ 1]    2     push cc ; (6,sp)
      0086B7 88               [ 1]    3     push a   ; (5,sp)
      0086B8 89               [ 2]    4     pushw x  ; (3,sp)
      0086B9 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086BB CD 80 CC         [ 4]    3     call uart3_puts 
      0000D1                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086BE 90 85            [ 2]    2     popw y 
      0086C0 85               [ 2]    3     popw x 
      0086C1 84               [ 1]    4     pop a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      0086C2 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0086C3 CD 87 B1         [ 4]   92     call print_arguments
      0086C6 CD 88 CD         [ 4]   93     call add24 
      0086C9 CD 87 ED         [ 4]   94     call print_int24
      0086CC CC 86 AF         [ 2]   95     jp eval_exit
      0086CF                         96 test_sub:
      0086CF 90 AE 88 86      [ 2]   97     ldw y,#sub24_test
      0000E6                         98     _dbg_puts 
                           000001     1     .if DEBUG 
      0000E6                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086D3 8A               [ 1]    2     push cc ; (6,sp)
      0086D4 88               [ 1]    3     push a   ; (5,sp)
      0086D5 89               [ 2]    4     pushw x  ; (3,sp)
      0086D6 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086D8 CD 80 CC         [ 4]    3     call uart3_puts 
      0000EE                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086DB 90 85            [ 2]    2     popw y 
      0086DD 85               [ 2]    3     popw x 
      0086DE 84               [ 1]    4     pop a 
      0086DF 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0086E0 CD 87 B1         [ 4]   99     call print_arguments
      0086E3 CD 88 DA         [ 4]  100     call sub24 
      0086E6 CD 87 ED         [ 4]  101     call print_int24
      0086E9 CC 86 AF         [ 2]  102     jp eval_exit
      0086EC                        103 test_mul:
      0086EC 90 AE 88 9B      [ 2]  104     ldw y,#mul24s_test
      000103                        105     _dbg_puts
                           000001     1     .if DEBUG 
      000103                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0086F0 8A               [ 1]    2     push cc ; (6,sp)
      0086F1 88               [ 1]    3     push a   ; (5,sp)
      0086F2 89               [ 2]    4     pushw x  ; (3,sp)
      0086F3 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0086F5 CD 80 CC         [ 4]    3     call uart3_puts 
      00010B                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0086F8 90 85            [ 2]    2     popw y 
      0086FA 85               [ 2]    3     popw x 
      0086FB 84               [ 1]    4     pop a 
      0086FC 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0086FD CD 87 B1         [ 4]  106     call print_arguments
      008700 CD 89 54         [ 4]  107     call mul24s
      008703 CD 87 ED         [ 4]  108     call print_int24
      008706 CC 86 AF         [ 2]  109     jp eval_exit
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      008709                        110 test_div:
      008709 90 AE 88 B1      [ 2]  111     ldw y,#div24s_test
      000120                        112     _dbg_puts
                           000001     1     .if DEBUG 
      000120                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00870D 8A               [ 1]    2     push cc ; (6,sp)
      00870E 88               [ 1]    3     push a   ; (5,sp)
      00870F 89               [ 2]    4     pushw x  ; (3,sp)
      008710 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008712 CD 80 CC         [ 4]    3     call uart3_puts 
      000128                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008715 90 85            [ 2]    2     popw y 
      008717 85               [ 2]    3     popw x 
      008718 84               [ 1]    4     pop a 
      008719 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      00871A CD 87 B1         [ 4]  113     call print_arguments
      00871D CD 8A 45         [ 4]  114     call div24s 
      008720 CD 87 ED         [ 4]  115     call print_int24
      008723 A6 52            [ 1]  116     ld a,#'R 
      000138                        117     _dbg_putc 
                           000001     1     .if DEBUG
      000138                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      008725 8A               [ 1]    2     push cc ; (6,sp)
      008726 88               [ 1]    3     push a   ; (5,sp)
      008727 89               [ 2]    4     pushw x  ; (3,sp)
      008728 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00872A CD 80 BA         [ 4]    3     call uart3_putc 
      000140                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      00872D 90 85            [ 2]    2     popw y 
      00872F 85               [ 2]    3     popw x 
      008730 84               [ 1]    4     pop a 
      008731 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      008732 A6 3D            [ 1]  118     ld a,#'=
      000147                        119     _dbg_putc 
                           000001     1     .if DEBUG
      000147                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      008734 8A               [ 1]    2     push cc ; (6,sp)
      008735 88               [ 1]    3     push a   ; (5,sp)
      008736 89               [ 2]    4     pushw x  ; (3,sp)
      008737 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008739 CD 80 BA         [ 4]    3     call uart3_putc 
      00014F                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



      00873C 90 85            [ 2]    2     popw y 
      00873E 85               [ 2]    3     popw x 
      00873F 84               [ 1]    4     pop a 
      008740 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      008741 1E 01            [ 2]  120     ldw x,(1,sp)
      008743 7B 03            [ 1]  121     ld a,(3,sp)
      008745 CD 87 ED         [ 4]  122     call print_int24  
      008748 CC 86 AF         [ 2]  123     jp eval_exit
      00874B                        124 test_neg:
      00874B 90 AE 88 BB      [ 2]  125     ldw y,#neg24_test
      000162                        126     _dbg_puts 
                           000001     1     .if DEBUG 
      000162                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00874F 8A               [ 1]    2     push cc ; (6,sp)
      008750 88               [ 1]    3     push a   ; (5,sp)
      008751 89               [ 2]    4     pushw x  ; (3,sp)
      008752 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      008754 CD 80 CC         [ 4]    3     call uart3_puts 
      00016A                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008757 90 85            [ 2]    2     popw y 
      008759 85               [ 2]    3     popw x 
      00875A 84               [ 1]    4     pop a 
      00875B 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      00875C CD 87 B1         [ 4]  127     call print_arguments 
      00875F 7B 03            [ 1]  128     ld a,(N1+2,sp)
      008761 1E 01            [ 2]  129     ldw x,(N1,sp)
      008763 CD 8A C6         [ 4]  130     call neg24 
      008766 CD 87 ED         [ 4]  131     call print_int24 
      008769 7B 06            [ 1]  132     ld a,(N2+2,sp)
      00876B 1E 04            [ 2]  133     ldw x,(N2,sp)
      00876D CD 8A C6         [ 4]  134     call neg24 
      008770 CD 87 ED         [ 4]  135     call print_int24 
      008773 CC 86 AF         [ 2]  136     jp eval_exit 
      008776                        137 test_cmp:
      008776 90 AE 88 C4      [ 2]  138     ldw y,#cmp24_test
      00018D                        139     _dbg_puts 
                           000001     1     .if DEBUG 
      00018D                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      00877A 8A               [ 1]    2     push cc ; (6,sp)
      00877B 88               [ 1]    3     push a   ; (5,sp)
      00877C 89               [ 2]    4     pushw x  ; (3,sp)
      00877D 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      00877F CD 80 CC         [ 4]    3     call uart3_puts 
      000195                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      008782 90 85            [ 2]    2     popw y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



      008784 85               [ 2]    3     popw x 
      008785 84               [ 1]    4     pop a 
      008786 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      008787 CD 8A CE         [ 4]  140     call cmp24 
      00878A CD 87 ED         [ 4]  141 1$: call print_int24 
      00878D CC 86 AF         [ 2]  142     jp eval_exit 
                                    143 
      008790                        144 print_error:
      008790 90 AE 88 04      [ 2]  145     ldw y,#msg_erreur
      008794 72 5F 00 A4      [ 1]  146     clr acc16 
      008798 48               [ 1]  147     sll a 
      008799 C7 00 A5         [ 1]  148     ld acc8,a
      00879C 72 B9 00 A4      [ 2]  149     addw y,acc16 
      0087A0 90 FE            [ 2]  150     ldw y,(y)
      0001B5                        151     _dbg_puts
                           000001     1     .if DEBUG 
      0001B5                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0087A2 8A               [ 1]    2     push cc ; (6,sp)
      0087A3 88               [ 1]    3     push a   ; (5,sp)
      0087A4 89               [ 2]    4     pushw x  ; (3,sp)
      0087A5 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087A7 CD 80 CC         [ 4]    3     call uart3_puts 
      0001BD                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0087AA 90 85            [ 2]    2     popw y 
      0087AC 85               [ 2]    3     popw x 
      0087AD 84               [ 1]    4     pop a 
      0087AE 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0087AF 20 FE            [ 2]  152     jra .
                                    153 
                                    154 ;-------------------------
                                    155 ; name: print_arguments
                                    156 ; input:
                                    157 ;  N1     int24_t 
                                    158 ;  N2     int24_t 
                                    159 ; output:
                                    160 ;  none
                                    161 ;------------------------
                           000002   162     ARG_OFS=2
                           000003   163     N1=ARG_OFS+1 
                           000006   164     N2=ARG_OFS+4
      0087B1                        165 print_arguments:
      0087B1 A6 20            [ 1]  166     ld a,#SPACE 
      0001C6                        167     _dbg_putc 
                           000001     1     .if DEBUG
      0001C6                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      0087B3 8A               [ 1]    2     push cc ; (6,sp)
      0087B4 88               [ 1]    3     push a   ; (5,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



      0087B5 89               [ 2]    4     pushw x  ; (3,sp)
      0087B6 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087B8 CD 80 BA         [ 4]    3     call uart3_putc 
      0001CE                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      0087BB 90 85            [ 2]    2     popw y 
      0087BD 85               [ 2]    3     popw x 
      0087BE 84               [ 1]    4     pop a 
      0087BF 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0087C0 1E 03            [ 2]  168     ldw x,(N1,sp)
      0087C2 7B 05            [ 1]  169     ld a,(N1+2,sp)
      0087C4 CD 87 ED         [ 4]  170     call print_int24 
      0087C7 A6 20            [ 1]  171     ld a,#SPACE 
      0001DC                        172     _dbg_putc 
                           000001     1     .if DEBUG
      0001DC                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      0087C9 8A               [ 1]    2     push cc ; (6,sp)
      0087CA 88               [ 1]    3     push a   ; (5,sp)
      0087CB 89               [ 2]    4     pushw x  ; (3,sp)
      0087CC 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087CE CD 80 BA         [ 4]    3     call uart3_putc 
      0001E4                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      0087D1 90 85            [ 2]    2     popw y 
      0087D3 85               [ 2]    3     popw x 
      0087D4 84               [ 1]    4     pop a 
      0087D5 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif 
      0087D6 1E 06            [ 2]  173     ldw x,(N2,sp)
      0087D8 7B 08            [ 1]  174     ld a,(N2+2,sp)
      0087DA CD 87 ED         [ 4]  175     call print_int24 
      0087DD A6 3D            [ 1]  176     ld a,#'= 
      0001F2                        177     _dbg_putc 
                           000001     1     .if DEBUG
      0001F2                          2     _dbg_save_regs  
                           000001     1     .if DEBUG
      0087DF 8A               [ 1]    2     push cc ; (6,sp)
      0087E0 88               [ 1]    3     push a   ; (5,sp)
      0087E1 89               [ 2]    4     pushw x  ; (3,sp)
      0087E2 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087E4 CD 80 BA         [ 4]    3     call uart3_putc 
      0001FA                          4     _dbg_restore_regs 
                           000001     1     .if DEBUG 
      0087E7 90 85            [ 2]    2     popw y 
      0087E9 85               [ 2]    3     popw x 
      0087EA 84               [ 1]    4     pop a 
      0087EB 86               [ 1]    5     pop cc 
                                      6     .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                                      5     .endif 
      0087EC 81               [ 4]  178     ret 
                                    179 
      0087ED                        180 print_int24:
      0087ED CF 00 A3         [ 2]  181     ldw acc24,x 
      0087F0 C7 00 A5         [ 1]  182     ld acc8,a 
      0087F3 5F               [ 1]  183     clrw x 
      0087F4 A6 0A            [ 1]  184     ld a,#10
      000209                        185     _dbg_prti24 
                           000001     1     .if DEBUG 
      000209                          2     _dbg_save_regs
                           000001     1     .if DEBUG
      0087F6 8A               [ 1]    2     push cc ; (6,sp)
      0087F7 88               [ 1]    3     push a   ; (5,sp)
      0087F8 89               [ 2]    4     pushw x  ; (3,sp)
      0087F9 90 89            [ 2]    5     pushw y  ; (1,sp)
                                      6     .endif 
      0087FB CD 82 DD         [ 4]    3     call uart3_prti24 
      000211                          4     _dbg_restore_regs
                           000001     1     .if DEBUG 
      0087FE 90 85            [ 2]    2     popw y 
      008800 85               [ 2]    3     popw x 
      008801 84               [ 1]    4     pop a 
      008802 86               [ 1]    5     pop cc 
                                      6     .endif 
                                      5     .endif
      008803 81               [ 4]  186     ret 
                                    187 
                                    188 
      008804 88 0E 88 1C 88 28 88   189 msg_erreur: .word erreur_add,erreur_sub,erreur_mul,erreur_div,erreur_neg
             35 88 41
                                    190 
      00880E 65 72 72 65 75 72 20   191 erreur_add: .asciz "erreur somme\n"
             73 6F 6D 6D 65 0A 00
      00881C 65 72 72 65 75 72 20   192 erreur_sub: .asciz "erreur sub\n"
             73 75 62 0A 00
      008828 65 72 72 65 75 72 20   193 erreur_mul: .asciz "erreur mult\n"
             6D 75 6C 74 0A 00
      008835 65 72 72 65 75 72 20   194 erreur_div: .asciz "erreur div\n"
             64 69 76 0A 00
      008841 65 72 72 65 75 72 20   195 erreur_neg: .asciz "erreur neg\n"
             6E 65 67 0A 00
                                    196 
      00884D 0A 61 6C 6C 20 74 65   197 test_ok: .asciz "\nall tests ok\n"
             73 74 73 20 6F 6B 0A
             00
      00885C 0A 54 65 73 74 20 70   198 whatisit: .asciz "\nTest pour la librairie math24.\n"
             6F 75 72 20 6C 61 20
             6C 69 62 72 61 69 72
             69 65 20 6D 61 74 68
             32 34 2E 0A 00
      00887D 0A 61 64 64 32 34 3A   199 add24_test: .asciz "\nadd24: "
             20 00
      008886 0A 73 75 62 32 34 3A   200 sub24_test: .asciz "\nsub24: "
             20 00
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



      00888F 0A 6D 75 6C 32 34 5F   201 mul24_8u_test: .asciz "\nmul24_8u: " 
             38 75 3A 20 00
      00889B 0A 6D 75 6C 32 34 73   202 mul24s_test: .asciz "\nmul24s: "
             3A 20 00
      0088A5 0A 64 69 76 32 34 5F   203 div24_8u_test: .asciz "\ndiv24_8u: "
             38 75 3A 20 00
      0088B1 0A 64 69 76 32 34 73   204 div24s_test: .asciz "\ndiv24s: "
             3A 20 00
      0088BB 0A 6E 65 67 32 34 3A   205 neg24_test: .asciz "\nneg24: "
             20 00
      0088C4 0A 63 6D 70 32 34 3A   206 cmp24_test: .asciz "\ncmp24: " 
             20 00
                                    207 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
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
    AFR6_I2C=  000006     |     AFR7_BEE=  000007     |     ARG_OFS =  000002 
    AWU_APR =  0050F1     |     AWU_CSR1=  0050F0     |     AWU_TBR =  0050F2 
    B0_MASK =  000001     |     B115200 =  000006     |     B19200  =  000003 
    B1_MASK =  000002     |     B230400 =  000007     |     B2400   =  000000 
    B2_MASK =  000004     |     B38400  =  000004     |     B3_MASK =  000008 
    B460800 =  000008     |     B4800   =  000001     |     B4_MASK =  000010 
    B57600  =  000005     |     B5_MASK =  000020     |     B6_MASK =  000040 
    B7_MASK =  000080     |     B921600 =  000009     |     B9600   =  000002 
    BEEP_BIT=  000004     |     BEEP_CSR=  0050F3     |     BEEP_MAS=  000010 
    BEEP_POR=  00000F     |     BELL    =  000007     |     BIT0    =  000000 
    BIT1    =  000001     |     BIT2    =  000002     |     BIT3    =  000003 
    BIT4    =  000004     |     BIT5    =  000005     |     BIT6    =  000006 
    BIT7    =  000007     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BSP     =  000008     |     CAN_DGR =  005426     |     CAN_FPSR=  005427 
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
    CFG_GCR_=  000001     |     CFG_GCR_=  000000     |     CLKOPT  =  004807 
    CLKOPT_C=  000002     |     CLKOPT_E=  000003     |     CLKOPT_P=  000000 
    CLKOPT_P=  000001     |     CLK_CCOR=  0050C9     |     CLK_CKDI=  0050C6 
    CLK_CKDI=  000000     |     CLK_CKDI=  000001     |     CLK_CKDI=  000002 
    CLK_CKDI=  000003     |     CLK_CKDI=  000004     |     CLK_CMSR=  0050C3 
    CLK_CSSR=  0050C8     |     CLK_ECKR=  0050C1     |     CLK_ECKR=  000000 
    CLK_ECKR=  000001     |     CLK_HSIT=  0050CC     |     CLK_ICKR=  0050C0 
    CLK_ICKR=  000002     |     CLK_ICKR=  000000     |     CLK_ICKR=  000001 
    CLK_ICKR=  000003     |     CLK_ICKR=  000004     |     CLK_ICKR=  000005 
    CLK_PCKE=  0050C7     |     CLK_PCKE=  000000     |     CLK_PCKE=  000001 
    CLK_PCKE=  000007     |     CLK_PCKE=  000005     |     CLK_PCKE=  000006 
    CLK_PCKE=  000004     |     CLK_PCKE=  000002     |     CLK_PCKE=  000003 
    CLK_PCKE=  0050CA     |     CLK_PCKE=  000003     |     CLK_PCKE=  000002 
    CLK_PCKE=  000007     |     CLK_SWCR=  0050C5     |     CLK_SWCR=  000000 
    CLK_SWCR=  000001     |     CLK_SWCR=  000002     |     CLK_SWCR=  000003 
    CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4     |     CLK_SWR_=  0000B4 
    CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2     |     CPU_A   =  007F00 
    CPU_CCR =  007F0A     |     CPU_PCE =  007F01     |     CPU_PCH =  007F02 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]

Symbol Table

    CPU_PCL =  007F03     |     CPU_SPH =  007F08     |     CPU_SPL =  007F09 
    CPU_XH  =  007F04     |     CPU_XL  =  007F05     |     CPU_YH  =  007F06 
    CPU_YL  =  007F07     |     CR      =  00000D     |     CTRL_A  =  000001 
    CTRL_B  =  000002     |     CTRL_C  =  000003     |     CTRL_D  =  000004 
    CTRL_E  =  000005     |     CTRL_F  =  000006     |     CTRL_G  =  000007 
    CTRL_H  =  000008     |     CTRL_I  =  000009     |     CTRL_J  =  00000A 
    CTRL_K  =  00000B     |     CTRL_L  =  00000C     |     CTRL_M  =  00000D 
    CTRL_N  =  00000E     |     CTRL_O  =  00000F     |     CTRL_P  =  000010 
    CTRL_Q  =  000011     |     CTRL_R  =  000012     |     CTRL_S  =  000013 
    CTRL_T  =  000014     |     CTRL_U  =  000015     |     CTRL_V  =  000016 
    CTRL_W  =  000017     |     CTRL_X  =  000018     |     CTRL_Y  =  000019 
    CTRL_Z  =  00001A     |     DBG_A   =  000005     |     DBG_CC  =  000006 
    DBG_X   =  000003     |     DBG_Y   =  000001     |     DEBUG   =  000001 
    DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF     |     DEVID_BA=  0048CD 
    DEVID_EN=  0048D8     |     DEVID_LO=  0048D2     |     DEVID_LO=  0048D3 
    DEVID_LO=  0048D4     |     DEVID_LO=  0048D5     |     DEVID_LO=  0048D6 
    DEVID_LO=  0048D7     |     DEVID_LO=  0048D8     |     DEVID_WA=  0048D1 
    DEVID_XH=  0048CE     |     DEVID_XL=  0048CD     |     DEVID_YH=  0048D0 
    DEVID_YL=  0048CF     |     DM_BK1RE=  007F90     |     DM_BK1RH=  007F91 
    DM_BK1RL=  007F92     |     DM_BK2RE=  007F93     |     DM_BK2RH=  007F94 
    DM_BK2RL=  007F95     |     DM_CR1  =  007F96     |     DM_CR2  =  007F97 
    DM_CSR1 =  007F98     |     DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A 
    EEPROM_B=  004000     |     EEPROM_E=  0047FF     |     EEPROM_S=  000800 
    ESC     =  00001B     |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
    FF      =  00000C     |     FHSE    =  7A1200     |     FHSI    =  F42400 
    FLASH_BA=  008000     |     FLASH_CR=  00505A     |     FLASH_CR=  000002 
    FLASH_CR=  000000     |     FLASH_CR=  000003     |     FLASH_CR=  000001 
    FLASH_CR=  00505B     |     FLASH_CR=  000005     |     FLASH_CR=  000004 
    FLASH_CR=  000007     |     FLASH_CR=  000000     |     FLASH_CR=  000006 
    FLASH_DU=  005064     |     FLASH_DU=  0000AE     |     FLASH_DU=  000056 
    FLASH_EN=  027FFF     |     FLASH_FP=  00505D     |     FLASH_FP=  000000 
    FLASH_FP=  000001     |     FLASH_FP=  000002     |     FLASH_FP=  000003 
    FLASH_FP=  000004     |     FLASH_FP=  000005     |     FLASH_IA=  00505F 
    FLASH_IA=  000003     |     FLASH_IA=  000002     |     FLASH_IA=  000006 
    FLASH_IA=  000001     |     FLASH_IA=  000000     |     FLASH_NC=  00505C 
    FLASH_NF=  00505E     |     FLASH_NF=  000000     |     FLASH_NF=  000001 
    FLASH_NF=  000002     |     FLASH_NF=  000003     |     FLASH_NF=  000004 
    FLASH_NF=  000005     |     FLASH_PU=  005062     |     FLASH_PU=  000056 
    FLASH_PU=  0000AE     |     FLASH_SI=  020000     |     FLASH_WS=  00480D 
    FLSI    =  01F400     |     GPIO_BAS=  005000     |     GPIO_CR1=  000003 
    GPIO_CR2=  000004     |     GPIO_DDR=  000002     |     GPIO_IDR=  000001 
    GPIO_ODR=  000000     |     GPIO_SIZ=  000005     |     HSECNT  =  004809 
    I2C_CCRH=  00521C     |     I2C_CCRH=  000080     |     I2C_CCRH=  0000C0 
    I2C_CCRH=  000080     |     I2C_CCRH=  000000     |     I2C_CCRH=  000001 
    I2C_CCRH=  000000     |     I2C_CCRL=  00521B     |     I2C_CCRL=  00001A 
    I2C_CCRL=  000002     |     I2C_CCRL=  00000D     |     I2C_CCRL=  000050 
    I2C_CCRL=  000090     |     I2C_CCRL=  0000A0     |     I2C_CR1 =  005210 
    I2C_CR1_=  000006     |     I2C_CR1_=  000007     |     I2C_CR1_=  000000 
    I2C_CR2 =  005211     |     I2C_CR2_=  000002     |     I2C_CR2_=  000003 
    I2C_CR2_=  000000     |     I2C_CR2_=  000001     |     I2C_CR2_=  000007 
    I2C_DR  =  005216     |     I2C_FREQ=  005212     |     I2C_ITR =  00521A 
    I2C_ITR_=  000002     |     I2C_ITR_=  000000     |     I2C_ITR_=  000001 
    I2C_OARH=  005214     |     I2C_OARH=  000001     |     I2C_OARH=  000002 
    I2C_OARH=  000006     |     I2C_OARH=  000007     |     I2C_OARL=  005213 
    I2C_OARL=  000000     |     I2C_OAR_=  000813     |     I2C_OAR_=  000009 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]

Symbol Table

    I2C_PECR=  00521E     |     I2C_READ=  000001     |     I2C_SR1 =  005217 
    I2C_SR1_=  000003     |     I2C_SR1_=  000001     |     I2C_SR1_=  000002 
    I2C_SR1_=  000006     |     I2C_SR1_=  000000     |     I2C_SR1_=  000004 
    I2C_SR1_=  000007     |     I2C_SR2 =  005218     |     I2C_SR2_=  000002 
    I2C_SR2_=  000001     |     I2C_SR2_=  000000     |     I2C_SR2_=  000003 
    I2C_SR2_=  000005     |     I2C_SR3 =  005219     |     I2C_SR3_=  000001 
    I2C_SR3_=  000007     |     I2C_SR3_=  000004     |     I2C_SR3_=  000000 
    I2C_SR3_=  000002     |     I2C_TRIS=  00521D     |     I2C_TRIS=  000005 
    I2C_TRIS=  000005     |     I2C_TRIS=  000005     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_TRIS=  000011     |     I2C_WRIT=  000000 
    IDX_ERR_=  000003     |     IDX_ERR_=  000002     |     IDX_ERR_=  000004 
    IDX_ERR_=  000001     |     IDX_ERR_=  000000     |     INPUT_DI=  000000 
    INPUT_EI=  000001     |     INPUT_FL=  000000     |     INPUT_PU=  000001 
    INT_ADC2=  000016     |     INT_AUAR=  000012     |     INT_AWU =  000001 
    INT_CAN_=  000008     |     INT_CAN_=  000009     |     INT_CLK =  000002 
    INT_EXTI=  000003     |     INT_EXTI=  000004     |     INT_EXTI=  000005 
    INT_EXTI=  000006     |     INT_EXTI=  000007     |     INT_FLAS=  000018 
    INT_I2C =  000013     |     INT_SPI =  00000A     |     INT_TIM1=  00000C 
    INT_TIM1=  00000B     |     INT_TIM2=  00000E     |     INT_TIM2=  00000D 
    INT_TIM3=  000010     |     INT_TIM3=  00000F     |     INT_TIM4=  000017 
    INT_TLI =  000000     |     INT_UART=  000011     |     INT_UART=  000015 
    INT_UART=  000014     |     INT_VECT=  008060     |     INT_VECT=  00800C 
    INT_VECT=  008028     |     INT_VECT=  00802C     |     INT_VECT=  008010 
    INT_VECT=  008014     |     INT_VECT=  008018     |     INT_VECT=  00801C 
    INT_VECT=  008020     |     INT_VECT=  008024     |     INT_VECT=  008068 
    INT_VECT=  008054     |     INT_VECT=  008000     |     INT_VECT=  008030 
    INT_VECT=  008038     |     INT_VECT=  008034     |     INT_VECT=  008040 
    INT_VECT=  00803C     |     INT_VECT=  008048     |     INT_VECT=  008044 
    INT_VECT=  008064     |     INT_VECT=  008008     |     INT_VECT=  008004 
    INT_VECT=  008050     |     INT_VECT=  00804C     |     INT_VECT=  00805C 
    INT_VECT=  008058     |     ITC_SPR1=  007F70     |     ITC_SPR2=  007F71 
    ITC_SPR3=  007F72     |     ITC_SPR4=  007F73     |     ITC_SPR5=  007F74 
    ITC_SPR6=  007F75     |     ITC_SPR7=  007F76     |     ITC_SPR8=  007F77 
    IWDG_KR =  0050E0     |     IWDG_PR =  0050E1     |     IWDG_RLR=  0050E2 
    LED2_BIT=  000005     |     LED2_MAS=  000020     |     LED2_POR=  00500A 
    LOCAL_SI=  000007     |     N1      =  000003     |     N2      =  000006 
    NAFR    =  004804     |     NCLKOPT =  004808     |     NFLASH_W=  00480E 
    NHSECNT =  00480A     |     NL      =  00000A     |     NOPT1   =  004802 
    NOPT2   =  004804     |     NOPT3   =  004806     |     NOPT4   =  004808 
    NOPT5   =  00480A     |     NOPT6   =  00480C     |     NOPT7   =  00480E 
    NOPTBL  =  00487F     |     NUBC    =  004802     |     NWDGOPT =  004806 
    NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF 
    NWDGOPT_=  FFFFFFFE     |     OP      =  000007     |     OPT0    =  004800 
    OPT1    =  004801     |     OPT2    =  004803     |     OPT3    =  004805 
    OPT4    =  004807     |     OPT5    =  004809     |     OPT6    =  00480B 
    OPT7    =  00480D     |     OPTBL   =  00487E     |     OPTION_B=  004800 
    OPTION_E=  00487F     |     OUTPUT_F=  000001     |     OUTPUT_O=  000000 
    OUTPUT_P=  000001     |     OUTPUT_S=  000000     |     PA      =  000000 
    PA_BASE =  005000     |     PA_CR1  =  005003     |     PA_CR2  =  005004 
    PA_DDR  =  005002     |     PA_IDR  =  005001     |     PA_ODR  =  005000 
    PB      =  000005     |     PB_BASE =  005005     |     PB_CR1  =  005008 
    PB_CR2  =  005009     |     PB_DDR  =  005007     |     PB_IDR  =  005006 
    PB_ODR  =  005005     |     PC      =  00000A     |     PC_BASE =  00500A 
    PC_CR1  =  00500D     |     PC_CR2  =  00500E     |     PC_DDR  =  00500C 
    PC_IDR  =  00500B     |     PC_ODR  =  00500A     |     PD      =  00000F 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]

Symbol Table

    PD_BASE =  00500F     |     PD_CR1  =  005012     |     PD_CR2  =  005013 
    PD_DDR  =  005011     |     PD_IDR  =  005010     |     PD_ODR  =  00500F 
    PE      =  000014     |     PE_BASE =  005014     |     PE_CR1  =  005017 
    PE_CR2  =  005018     |     PE_DDR  =  005016     |     PE_IDR  =  005015 
    PE_ODR  =  005014     |     PF      =  000019     |     PF_BASE =  005019 
    PF_CR1  =  00501C     |     PF_CR2  =  00501D     |     PF_DDR  =  00501B 
    PF_IDR  =  00501A     |     PF_ODR  =  005019     |     PG      =  00001E 
    PG_BASE =  00501E     |     PG_CR1  =  005021     |     PG_CR2  =  005022 
    PG_DDR  =  005020     |     PG_IDR  =  00501F     |     PG_ODR  =  00501E 
    PH_BASE =  005023     |     PH_CR1  =  005026     |     PH_CR2  =  005027 
    PH_DDR  =  005025     |     PH_IDR  =  005024     |     PH_ODR  =  005023 
    PI_BASE =  005028     |     PI_CR1  =  00502B     |     PI_CR2  =  00502C 
    PI_DDR  =  00502A     |     PI_IDR  =  005029     |     PI_ODR  =  005028 
    RAM_BASE=  000000     |     RAM_END =  0017FF     |     RAM_SIZE=  001800 
    ROP     =  004800     |     RST_SR  =  0050B3     |     SFR_BASE=  005000 
    SFR_END =  0057FF     |     SPACE   =  000020     |     SPI_CR1 =  005200 
    SPI_CR2 =  005201     |     SPI_CRCP=  005205     |     SPI_DR  =  005204 
    SPI_ICR =  005202     |     SPI_RXCR=  005206     |     SPI_SR  =  005203 
    SPI_TXCR=  005207     |     SWIM_CSR=  007F80     |     TAB     =  000009 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
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
    USR_BTN_=  000010     |     USR_BTN_=  005015     |     VT      =  00000B 
    WDGOPT  =  004805     |     WDGOPT_I=  000002     |     WDGOPT_L=  000003 
    WDGOPT_W=  000000     |     WDGOPT_W=  000001     |     WWDG_CR =  0050D1 
    WWDG_WR =  0050D2     |     acc16      ****** GX  |     acc24      ****** GX
    acc8       ****** GX  |     add24      ****** GX  |   1 add24_te   000290 R
    cmp24      ****** GX  |   1 cmp24_te   0002D7 R   |   1 div24_8u   0002B8 R
    div24s     ****** GX  |   1 div24s_t   0002C4 R   |   1 erreur_a   000221 R
  1 erreur_d   000248 R   |   1 erreur_m   00023B R   |   1 erreur_n   000254 R
  1 erreur_s   00022F R   |   1 eval       000054 R   |   1 eval_exi   0000C2 R
  1 msg_erre   000217 R   |   1 mul24_8u   0002A2 R   |     mul24s     ****** GX
  1 mul24s_t   0002AE R   |     neg24      ****** GX  |   1 neg24_te   0002CE R
    next_wor   ****** GX  |     number     ****** GX  |     pad        ****** GX
    parser_i   ****** GX  |   1 presenta   000000 R   |   1 print_ar   0001C4 R
  1 print_er   0001A3 R   |   1 print_in   000200 R   |   1 repl       000011 R
    sub24      ****** GX  |   1 sub24_te   000299 R   |   1 test_add   0000C5 R
  1 test_cmp   000189 R   |   1 test_div   00011C R   |   1 test_mai   000000 GR
  1 test_mul   0000FF R   |   1 test_neg   00015E R   |   1 test_ok    000260 R
  1 test_sub   0000E2 R   |     tib        ****** GX  |     uart3_pr   ****** GX
    uart3_pu   ****** GX  |     uart3_pu   ****** GX  |     uart3_re   ****** GX
  1 whatisit   00026F R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 CODE       size    2E0   flags    0

