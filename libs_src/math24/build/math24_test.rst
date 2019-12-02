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
                                 
                                 
                                 
                                 
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                        
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                      9     .list 
                                     10 
                                     11 ;--------------------------------------------------------
                                     12 ;      MACROS
                                     13 ;--------------------------------------------------------
                                     14 		.macro _ledenable ; set PC5 as push-pull output fast mode
                                     15 		bset PC_CR1,#LED2_BIT
                                     16 		bset PC_CR2,#LED2_BIT
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     17 		bset PC_DDR,#LED2_BIT
                                     18 		.endm
                                     19 		
                                     20 		.macro _ledon ; turn on green LED 
                                     21 		bset PC_ODR,#LED2_BIT
                                     22 		.endm
                                     23 		
                                     24 		.macro _ledoff ; turn off green LED
                                     25 		bres PC_ODR,#LED2_BIT
                                     26 		.endm
                                     27 		
                                     28 		.macro _ledtoggle ; invert green LED state
                                     29 		ld a,#LED2_MASK
                                     30 		xor a,PC_ODR
                                     31 		ld PC_ODR,a
                                     32 		.endm
                                     33 		
                                     34 		
                                     35 		.macro  _int_enable ; enable interrupts
                                     36 		 rim
                                     37 		.endm
                                     38 		
                                     39 		.macro _int_disable ; disable interrupts
                                     40 		sim
                                     41 		.endm
                                     42 
                           000050    43     PAD_SIZE=80
                                     44     .area DATA
      000001                         45 acc24: .blkb 1
      000002                         46 acc16: .blkb 1
      000003                         47 acc8:  .blkb 1
      000004                         48 pad:   .ds PAD_SIZE 
                                     49 
                                     50     .area SSEG (ABS)
                           000100    51     STACK_SIZE=256 
      001700                         52     .org RAM_SIZE-STACK_SIZE
      001700                         53     .ds STACK_SIZE 
                                     54 
                                     55     .area HOME 
      008000 82 00 81 3D             56     INT init0
      008004 82 00 80 80             57     INT NonHandledInterrupt
      008008 82 00 80 80             58     INT NonHandledInterrupt
      00800C 82 00 80 80             59     INT NonHandledInterrupt
      008010 82 00 80 80             60     INT NonHandledInterrupt
      008014 82 00 80 80             61     INT NonHandledInterrupt
      008018 82 00 80 80             62     INT NonHandledInterrupt
      00801C 82 00 80 80             63     INT NonHandledInterrupt
      008020 82 00 80 80             64     INT NonHandledInterrupt
      008024 82 00 80 80             65     INT NonHandledInterrupt
      008028 82 00 80 80             66     INT NonHandledInterrupt
      00802C 82 00 80 80             67     INT NonHandledInterrupt
      008030 82 00 80 80             68     INT NonHandledInterrupt
      008034 82 00 80 80             69     INT NonHandledInterrupt
      008038 82 00 80 80             70     INT NonHandledInterrupt
      00803C 82 00 80 80             71     INT NonHandledInterrupt
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



      008040 82 00 80 80             72     INT NonHandledInterrupt
      008044 82 00 80 80             73     INT NonHandledInterrupt
      008048 82 00 80 80             74     INT NonHandledInterrupt
      00804C 82 00 80 80             75     INT NonHandledInterrupt
      008050 82 00 80 80             76     INT NonHandledInterrupt
      008054 82 00 80 80             77     INT NonHandledInterrupt
      008058 82 00 80 80             78     INT NonHandledInterrupt
      00805C 82 00 80 80             79     INT NonHandledInterrupt
      008060 82 00 80 80             80     INT NonHandledInterrupt
      008064 82 00 80 80             81     INT NonHandledInterrupt
      008068 82 00 80 80             82     INT NonHandledInterrupt
      00806C 82 00 80 80             83     INT NonHandledInterrupt
      008070 82 00 80 80             84     INT NonHandledInterrupt
      008074 82 00 80 80             85     INT NonHandledInterrupt
      008078 82 00 80 80             86     INT NonHandledInterrupt
      00807C 82 00 80 80             87     INT NonHandledInterrupt
                                     88 
                                     89 
                                     90     .area CODE
                                     91 
                                     92 
      008080                         93 NonHandledInterrupt:
      008080 71                      94     .byte 0x71  ; réinitialize le MCU
                                     95 
                                     96 	;initialize clock to use HSE 8 Mhz crystal
      008081                         97 clock_init:	
      008081 72 12 50 C5      [ 1]   98 	bset CLK_SWCR,#CLK_SWCR_SWEN
      008085 A6 B4            [ 1]   99 	ld a,#CLK_SWR_HSE
      008087 C7 50 C4         [ 1]  100 	ld CLK_SWR,a
      00808A C1 50 C3         [ 1]  101 1$:	cp a,CLK_CMSR
      00808D 26 FB            [ 1]  102 	jrne 1$
      00808F 81               [ 4]  103 	ret
                                    104 
                                    105 
                                    106 ;------------------------------------
                                    107 ; convert integer to string
                                    108 ; input:
                                    109 ;   A	  	base
                                    110 ;	acc24	integer to convert
                                    111 ; output:
                                    112 ;   y  		pointer to string
                                    113 ;   A 		string length 
                                    114 ;------------------------------------
                           000001   115 	SIGN=1  ; integer sign 
                           000002   116 	BASE=2  ; numeric base 
                           000002   117 	LOCAL_SIZE=2  ;locals size
      008090                        118 itoa:: 
      008090 52 02            [ 2]  119 	sub sp,#LOCAL_SIZE
      008092 6B 02            [ 1]  120 	ld (BASE,sp), a  ; base
      008094 0F 01            [ 1]  121 	clr (SIGN,sp)    ; sign
      008096 A1 0A            [ 1]  122 	cp a,#10
      008098 26 16            [ 1]  123 	jrne 1$
                                    124 	; base 10 string display with negative sign if bit 23==1
      00809A 72 0F 00 01 11   [ 2]  125 	btjf acc24,#7,1$
      00809F 03 01            [ 1]  126 	cpl (SIGN,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



      0080A1 C6 00 03         [ 1]  127 	ld a,acc8
      0080A4 CE 00 01         [ 2]  128     ldw x,acc24 
      0080A7 CD 84 38         [ 4]  129     call neg24
      0080AA C7 00 03         [ 1]  130     ld acc8,a 
      0080AD CF 00 01         [ 2]  131     ldw acc24,x 
      0080B0                        132 1$: 
                                    133 ; initialize string pointer 
      0080B0 90 AE 00 53      [ 2]  134 	ldw y,#pad+PAD_SIZE-1
      0080B4 90 7F            [ 1]  135 	clr (y)
      0080B6 90 5A            [ 2]  136     decw y 
      0080B8 A6 20            [ 1]  137     ld a,#SPACE 
      0080BA 90 F7            [ 1]  138     ld (y),a  
      0080BC                        139 itoa_loop:  
      0080BC 7B 02            [ 1]  140     ld a,(BASE,sp)
      0080BE 88               [ 1]  141     push a 
      0080BF C6 00 03         [ 1]  142     ld a,acc8 
      0080C2 CE 00 01         [ 2]  143     ldw x,acc24 
      0080C5 88               [ 1]  144     push a 
      0080C6 89               [ 2]  145     pushw x 
      0080C7 CD 83 DC         [ 4]  146     call div24_8u ; acc24/base
      0080CA AB 30            [ 1]  147     add a,#'0  ; remainder of division
      0080CC A1 3A            [ 1]  148     cp a,#'9+1
      0080CE 2B 02            [ 1]  149     jrmi 2$
      0080D0 AB 07            [ 1]  150     add a,#7 
      0080D2                        151 2$: 
      0080D2 90 5A            [ 2]  152     decw y
      0080D4 90 F7            [ 1]  153     ld (y),a
      0080D6 85               [ 2]  154     popw x
      0080D7 CF 00 01         [ 2]  155     ldw acc24,x 
      0080DA 84               [ 1]  156     pop a 
      0080DB C7 00 03         [ 1]  157     ld acc8,a 
      0080DE 5B 01            [ 2]  158     addw sp,#1
                                    159 	; if acc24==0 conversion done
      0080E0 CA 00 01         [ 1]  160 	or a,acc24
      0080E3 CA 00 02         [ 1]  161 	or a,acc16 
      0080E6 26 D4            [ 1]  162     jrne itoa_loop
                                    163 	;conversion done, next add '$' or '-' as required
      0080E8 7B 02            [ 1]  164 	ld a,(BASE,sp)
      0080EA A1 10            [ 1]  165 	cp a,#16
      0080EC 26 08            [ 1]  166 	jrne 8$
      0080EE A6 24            [ 1]  167     ld a,#'$
      0080F0 90 5A            [ 2]  168     decw y 
      0080F2 90 F7            [ 1]  169     ld (y),a 
      0080F4 20 0A            [ 2]  170     jra 10$
      0080F6 7B 01            [ 1]  171 8$: ld a,(SIGN,sp)
      0080F8 27 06            [ 1]  172     jreq 10$
      0080FA 90 5A            [ 2]  173     decw y
      0080FC A6 2D            [ 1]  174     ld a,#'-
      0080FE 90 F7            [ 1]  175     ld (y),a
      008100                        176 10$:
      008100 5B 02            [ 2]  177 	addw sp,#LOCAL_SIZE
      008102 81               [ 4]  178 	ret
                                    179 
                                    180 ; input:
                                    181 ;   X:A     uint24
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      008103                        182 print_uint24:
      008103 88               [ 1]  183     push a 
      008104 89               [ 2]  184     pushw x 
      008105 90 89            [ 2]  185     pushw y 
      008107 C7 00 03         [ 1]  186     ld acc8,a 
      00810A CF 00 01         [ 2]  187     ldw acc24,x 
      00810D A6 10            [ 1]  188     ld a,#16 
      00810F CD 80 90         [ 4]  189     call itoa 
      008112 A6 01            [ 1]  190     ld a,#UART3 
      008114 88               [ 1]  191     push a 
      008115 90 89            [ 2]  192     pushw y
      008117 CD 84 F2         [ 4]  193     call uart_puts
      00811A 5B 03            [ 2]  194     addw sp,#3     
      00811C 90 85            [ 2]  195     popw y 
      00811E 85               [ 2]  196     popw x 
      00811F 84               [ 1]  197     pop a 
      008120 81               [ 4]  198     ret 
                                    199 
      008121                        200 new_line:
      008121 88               [ 1]  201     push a 
      008122 89               [ 2]  202     pushw x 
      008123 A6 01            [ 1]  203     ld a,#UART3
      008125 88               [ 1]  204     push a 
      008126 A6 0D            [ 1]  205     ld a,#CR 
      008128 88               [ 1]  206     push a 
      008129 CD 84 CE         [ 4]  207     call uart_putc 
      00812C 5B 02            [ 2]  208     addw sp,#2
      00812E 84               [ 1]  209     pop a 
      00812F 85               [ 2]  210     popw x 
      008130 81               [ 4]  211     ret 
                                    212 
                                    213 ;-----------------
                                    214 ; input:
                                    215 ;   x   string to print 
                                    216 ;----------------------
      008131                        217 print_fn_name:
      008131 88               [ 1]  218     push a 
      008132 A6 01            [ 1]  219     ld a,#UART3
      008134 88               [ 1]  220     push a 
      008135 89               [ 2]  221     pushw x 
      008136 CD 84 F2         [ 4]  222     call uart_puts 
      008139 5B 03            [ 2]  223     addw sp,#3
      00813B 84               [ 1]  224     pop a 
      00813C 81               [ 4]  225     ret 
                                    226 
                                    227 
      00813D                        228 init0:
      00813D AE 17 FF         [ 2]  229     ldw x,#RAM_SIZE-1
      008140 94               [ 1]  230     ldw sp,x 
      008141 CD 80 81         [ 4]  231     call clock_init
                                    232 ; initialize UART3    
      008144 A6 01            [ 1]  233     ld a,#UART3 
      008146 88               [ 1]  234     push a 
      008147 A6 06            [ 1]  235     ld a,#B115200
      008149 88               [ 1]  236     push a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      00814A CD 84 80         [ 4]  237     call uart_init
                           000000   238     SEND_OK=0
      00814D 5B 02            [ 2]  239     addw sp,#2  
                                    240     
                           000000   241     IDX_ERR_SUM=0
                           000001   242     IDX_ERR_SUB=1 
                           000002   243     IDX_ERR_MUL=2
                           000003   244     IDX_ERR_DIV=3
                           000004   245     IDX_ERR_NEG=4
                                    246 
      00814F                        247 presentation:
      00814F A6 01            [ 1]  248     ld a,#UART3
      008151 AE 82 EA         [ 2]  249     ldw x,#whatisit
      008154 88               [ 1]  250     push a 
      008155 89               [ 2]  251     pushw x 
      008156 CD 84 F2         [ 4]  252     call uart_puts 
      008159 5B 03            [ 2]  253     addw sp,#3
      00815B                        254 add_test:
      00815B 52 06            [ 2]  255     sub sp,#6 ; espace pour les arguments test fonctions 
      00815D AE 83 0B         [ 2]  256     ldw x,#add24_test
      008160 CD 81 31         [ 4]  257     call print_fn_name
      008163 A6 55            [ 1]  258     ld a,#0x55 
      008165 AE 55 55         [ 2]  259     ldw x,#0x5555
      008168 CD 81 03         [ 4]  260     call print_uint24
      00816B 6B 03            [ 1]  261     ld (3,sp),a 
      00816D 1F 01            [ 2]  262     ldw (1,sp),x 
      00816F A6 AA            [ 1]  263     ld a,#0xaa
      008171 AE AA AA         [ 2]  264     ldw x,#0xaaaa
      008174 CD 81 03         [ 4]  265     call print_uint24 
      008177 1F 04            [ 2]  266     ldw (4,sp),x 
      008179 6B 06            [ 1]  267     ld (6,sp),a 
      00817B CD 83 55         [ 4]  268     call add24
                                    269     ; sum dans X:A
      00817E CD 81 03         [ 4]  270     call print_uint24 
      008181 A1 FF            [ 1]  271     cp a,#0xff 
      008183 27 04            [ 1]  272     jreq 1$
      008185 4F               [ 1]  273 0$: clr a
      008186 CC 82 7C         [ 2]  274     jp print_error
      008189 A3 FF FF         [ 2]  275 1$: cpw x,#0xffff
      00818C 26 F7            [ 1]  276     jrne 0$    
      00818E                        277 sub_test:
      00818E 1F 01            [ 2]  278     ldw (1,sp),x 
      008190 6B 03            [ 1]  279     ld (3,sp),a 
      008192 AE 83 14         [ 2]  280     ldw x,#sub24_test
      008195 CD 81 31         [ 4]  281     call print_fn_name
      008198 1E 01            [ 2]  282     ldw x,(1,sp)
      00819A CD 81 03         [ 4]  283     call print_uint24
      00819D A6 AA            [ 1]  284     ld a,#0xaa
      00819F AE AA AA         [ 2]  285     ldw x,#0xaaaa
      0081A2 CD 81 03         [ 4]  286     call print_uint24
      0081A5 1F 04            [ 2]  287     ldw (4,sp),x 
      0081A7 6B 06            [ 1]  288     ld (6,sp),a 
      0081A9 CD 83 62         [ 4]  289     call sub24
      0081AC CD 81 03         [ 4]  290     call print_uint24 
      0081AF A1 55            [ 1]  291     cp a,#0x55
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      0081B1 27 05            [ 1]  292     jreq 1$
      0081B3 A6 01            [ 1]  293 0$: ld a,#IDX_ERR_SUB
      0081B5 CC 82 7C         [ 2]  294     jp print_error 
      0081B8 A3 55 55         [ 2]  295 1$: cpw x,#0x5555
      0081BB 27 02            [ 1]  296     jreq mul_test
      0081BD 20 F4            [ 2]  297     jra 0$    
      0081BF                        298 mul_test: ; mul24_8u -> uint24_t * uint8_t 
      0081BF AE 83 1D         [ 2]  299     ldw x,#mul24_8u_test
      0081C2 CD 81 31         [ 4]  300     call print_fn_name    
      0081C5 A6 99            [ 1]  301     ld a,#0x99
      0081C7 AE 19 99         [ 2]  302     ldw x,#0x1999
      0081CA CD 81 03         [ 4]  303     call print_uint24
      0081CD 6B 03            [ 1]  304     ld (3,sp),a
      0081CF 1F 01            [ 2]  305     ldw (1,sp),x 
      0081D1 A6 0A            [ 1]  306     ld a,#10
      0081D3 6B 04            [ 1]  307     ld (4,sp),a 
      0081D5 5F               [ 1]  308     clrw x
      0081D6 CD 81 03         [ 4]  309     call print_uint24
      0081D9 CD 83 6F         [ 4]  310     call mul24_8u 
      0081DC CD 81 03         [ 4]  311     call print_uint24 
      0081DF A1 FA            [ 1]  312     cp a,#0xfa 
      0081E1 27 05            [ 1]  313     jreq 1$
      0081E3 A6 02            [ 1]  314 0$: ld a,#IDX_ERR_MUL
      0081E5 CC 82 7C         [ 2]  315     jp print_error 
      0081E8 A3 FF FF         [ 2]  316 1$: cpw x,#0xffff
      0081EB 26 F6            [ 1]  317     jrne 0$
      0081ED                        318 mul_test2: ; mul24u 
      0081ED AE 83 29         [ 2]  319     ldw x,#mul24u_test
      0081F0 CD 81 31         [ 4]  320     call print_fn_name
      0081F3 A6 99            [ 1]  321     ld a,#0x99
      0081F5 AE 19 99         [ 2]  322     ldw x,#0x1999
      0081F8 1F 01            [ 2]  323     ldw (1,sp),x 
      0081FA 6B 03            [ 1]  324     ld (3,sp),a 
      0081FC CD 81 03         [ 4]  325     call print_uint24
      0081FF A6 0A            [ 1]  326     ld a,#10
      008201 5F               [ 1]  327     clrw x 
      008202 1F 04            [ 2]  328     ldw (4,sp),x 
      008204 6B 06            [ 1]  329     ld (6,sp),a 
      008206 CD 81 03         [ 4]  330     call print_uint24
      008209 CD 83 98         [ 4]  331     call mul24u 
      00820C CD 81 03         [ 4]  332     call print_uint24 
      00820F A1 FA            [ 1]  333     cp a,#0xfa 
      008211 27 04            [ 1]  334     jreq 1$
      008213 A6 02            [ 1]  335 0$: ld a,#IDX_ERR_MUL
      008215 20 65            [ 2]  336     jra print_error
      008217 A3 FF FF         [ 2]  337 1$: cpw x,#0xffff
      00821A 26 F7            [ 1]  338     jrne 0$
      00821C                        339 div_test: ; div24_16u 
      00821C 89               [ 2]  340     pushw x 
      00821D AE 83 3F         [ 2]  341     ldw x,#div24_16u_test
      008220 CD 81 31         [ 4]  342     call print_fn_name 
      008223 85               [ 2]  343     popw x 
      008224 CD 81 03         [ 4]  344     call print_uint24
      008227 1F 01            [ 2]  345     ldw (1,sp),x 
      008229 6B 03            [ 1]  346     ld (3,sp),a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



      00822B A6 0A            [ 1]  347     ld a,#10
      00822D 5F               [ 1]  348     clrw x  
      00822E CD 81 03         [ 4]  349     call print_uint24
      008231 6B 05            [ 1]  350     ld (5,sp),a 
      008233 0F 04            [ 1]  351     clr (4,sp)
      008235 CD 83 F2         [ 4]  352     call div24_16u
      008238 CD 81 03         [ 4]  353     call print_uint24
      00823B B1 99            [ 1]  354     cp a,0x99
      00823D 27 04            [ 1]  355     jreq 1$
      00823F A6 03            [ 1]  356 0$: ld a,#IDX_ERR_DIV
      008241 20 39            [ 2]  357     jra print_error
      008243 A3 19 99         [ 2]  358 1$: cpw x,#0x1999 
      008246 26 F7            [ 1]  359     jrne 0$
      008248 90 9F            [ 1]  360     ld a,yl
      00824A A1 05            [ 1]  361     cp a,#5
      00824C 26 F1            [ 1]  362     jrne 0$    
      00824E                        363 neg_test:
      00824E CD 81 21         [ 4]  364     call new_line 
      008251 B6 AA            [ 1]  365     ld a,0xaa
      008253 AE AA AA         [ 2]  366     ldw x,#0xaaaa
      008256 CD 81 03         [ 4]  367     call print_uint24
      008259 CD 84 38         [ 4]  368     call neg24
      00825C CD 81 03         [ 4]  369     call print_uint24 
      00825F A1 55            [ 1]  370     cp a,#0x55
      008261 27 04            [ 1]  371     jreq 1$
      008263 A6 04            [ 1]  372 0$: ld a,#IDX_ERR_NEG
      008265 20 15            [ 2]  373     jra print_error 
      008267 A3 55 56         [ 2]  374 1$: cpw x,#0x5556    
      00826A 26 F7            [ 1]  375     jrne 0$
                                    376 ; tous les test ont passé avec succès.
      00826C 5B 06            [ 2]  377     addw sp,#6
      00826E AE 82 E0         [ 2]  378     ldw x,#test_ok
      008271 A6 01            [ 1]  379     ld a,#UART3
      008273 88               [ 1]  380     push a 
      008274 89               [ 2]  381     pushw x 
      008275 CD 84 F2         [ 4]  382     call uart_puts 
      008278 5B 03            [ 2]  383     addw sp,#3 
      00827A 20 FE            [ 2]  384     jra .
                                    385 
      00827C                        386 print_error:
      00827C AE 82 97         [ 2]  387     ldw x,#msg_erreur
      00827F 90 5F            [ 1]  388     clrw y
      008281 48               [ 1]  389     sll a 
      008282 90 97            [ 1]  390     ld yl,a
      008284 90 89            [ 2]  391     pushw y 
      008286 72 FB 01         [ 2]  392     addw x,(1,sp)
      008289 90 85            [ 2]  393     popw y  
      00828B FE               [ 2]  394     ldw x,(x)
      00828C A6 01            [ 1]  395     ld a,#UART3
      00828E 88               [ 1]  396     push a 
      00828F 89               [ 2]  397     pushw x 
      008290 CD 84 F2         [ 4]  398     call uart_puts
      008293 5B 03            [ 2]  399     addw sp,#3
      008295 20 FE            [ 2]  400     jra .
                                    401 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                                    402 
      008297 82 A1 82 AF 82 BB 82   403 msg_erreur: .word erreur_add,erreur_sub,erreur_mul,erreur_div,erreur_neg
             C8 82 D4
                                    404 
      0082A1 65 72 72 65 75 72 20   405 erreur_add: .asciz "erreur somme\n"
             73 6F 6D 6D 65 0A 00
      0082AF 65 72 72 65 75 72 20   406 erreur_sub: .asciz "erreur sub\n"
             73 75 62 0A 00
      0082BB 65 72 72 65 75 72 20   407 erreur_mul: .asciz "erreur mult\n"
             6D 75 6C 74 0A 00
      0082C8 65 72 72 65 75 72 20   408 erreur_div: .asciz "erreur div\n"
             64 69 76 0A 00
      0082D4 65 72 72 65 75 72 20   409 erreur_neg: .asciz "erreur neg\n"
             6E 65 67 0A 00
                                    410 
      0082E0 74 65 73 74 73 20 6F   411 test_ok: .asciz "tests ok\n"
             6B 0A 00
      0082EA 0A 54 65 73 74 20 70   412 whatisit: .asciz "\nTest pour la librairie math24.\n"
             6F 75 72 20 6C 61 20
             6C 69 62 72 61 69 72
             69 65 20 6D 61 74 68
             32 34 2E 0A 00
      00830B 0A 61 64 64 32 34 3A   413 add24_test: .asciz "\nadd24: "
             20 00
      008314 0A 73 75 62 32 34 3A   414 sub24_test: .asciz "\nsub24: "
             20 00
      00831D 0A 6D 75 6C 32 34 5F   415 mul24_8u_test: .asciz "\nmul24_8u: " 
             38 75 3A 20 00
      008329 0A 6D 75 6C 32 34 75   416 mul24u_test: .asciz "\nmul24u: "
             3A 20 00
      008333 0A 64 69 76 32 34 5F   417 div24_8u_test: .asciz "\ndiv24_8u: "
             38 75 3A 20 00
      00833F 0A 64 69 76 32 34 5F   418 div24_16u_test: .asciz "\ndiv24_16u: "
             31 36 75 3A 20 00
      00834C 0A 6E 65 67 32 34 3A   419 neg24_test: .asciz "\nneg24: "
             20 00
                                    420 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
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
    B921600 =  000009     |     B9600   =  000002     |     BASE    =  000002 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
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
    CTRL_Z  =  00001A     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
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
    FLASH_WS=  00480D     |     FLSI    =  01F400     |     GPIO_BAS=  005000 
    GPIO_CR1=  000003     |     GPIO_CR2=  000004     |     GPIO_DDR=  000002 
    GPIO_IDR=  000001     |     GPIO_ODR=  000000     |     GPIO_SIZ=  000005 
    HSECNT  =  004809     |     I2C_CCRH=  00521C     |     I2C_CCRH=  000080 
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
    I2C_OARL=  005213     |     I2C_OARL=  000000     |     I2C_OAR_=  000813 
    I2C_OAR_=  000009     |     I2C_PECR=  00521E     |     I2C_READ=  000001 
    I2C_SR1 =  005217     |     I2C_SR1_=  000003     |     I2C_SR1_=  000001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]

Symbol Table

    I2C_SR1_=  000002     |     I2C_SR1_=  000006     |     I2C_SR1_=  000000 
    I2C_SR1_=  000004     |     I2C_SR1_=  000007     |     I2C_SR2 =  005218 
    I2C_SR2_=  000002     |     I2C_SR2_=  000001     |     I2C_SR2_=  000000 
    I2C_SR2_=  000003     |     I2C_SR2_=  000005     |     I2C_SR3 =  005219 
    I2C_SR3_=  000001     |     I2C_SR3_=  000007     |     I2C_SR3_=  000004 
    I2C_SR3_=  000000     |     I2C_SR3_=  000002     |     I2C_TRIS=  00521D 
    I2C_TRIS=  000005     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000011     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_WRIT=  000000     |     IDX_ERR_=  000003     |     IDX_ERR_=  000002 
    IDX_ERR_=  000004     |     IDX_ERR_=  000001     |     IDX_ERR_=  000000 
    INPUT_DI=  000000     |     INPUT_EI=  000001     |     INPUT_FL=  000000 
    INPUT_PU=  000001     |     INT_ADC2=  000016     |     INT_AUAR=  000012 
    INT_AWU =  000001     |     INT_CAN_=  000008     |     INT_CAN_=  000009 
    INT_CLK =  000002     |     INT_EXTI=  000003     |     INT_EXTI=  000004 
    INT_EXTI=  000005     |     INT_EXTI=  000006     |     INT_EXTI=  000007 
    INT_FLAS=  000018     |     INT_I2C =  000013     |     INT_SPI =  00000A 
    INT_TIM1=  00000C     |     INT_TIM1=  00000B     |     INT_TIM2=  00000E 
    INT_TIM2=  00000D     |     INT_TIM3=  000010     |     INT_TIM3=  00000F 
    INT_TIM4=  000017     |     INT_TLI =  000000     |     INT_UART=  000011 
    INT_UART=  000015     |     INT_UART=  000014     |     INT_VECT=  008060 
    INT_VECT=  00800C     |     INT_VECT=  008028     |     INT_VECT=  00802C 
    INT_VECT=  008010     |     INT_VECT=  008014     |     INT_VECT=  008018 
    INT_VECT=  00801C     |     INT_VECT=  008020     |     INT_VECT=  008024 
    INT_VECT=  008068     |     INT_VECT=  008054     |     INT_VECT=  008000 
    INT_VECT=  008030     |     INT_VECT=  008038     |     INT_VECT=  008034 
    INT_VECT=  008040     |     INT_VECT=  00803C     |     INT_VECT=  008048 
    INT_VECT=  008044     |     INT_VECT=  008064     |     INT_VECT=  008008 
    INT_VECT=  008004     |     INT_VECT=  008050     |     INT_VECT=  00804C 
    INT_VECT=  00805C     |     INT_VECT=  008058     |     ITC_SPR1=  007F70 
    ITC_SPR2=  007F71     |     ITC_SPR3=  007F72     |     ITC_SPR4=  007F73 
    ITC_SPR5=  007F74     |     ITC_SPR6=  007F75     |     ITC_SPR7=  007F76 
    ITC_SPR8=  007F77     |     IWDG_KR =  0050E0     |     IWDG_PR =  0050E1 
    IWDG_RLR=  0050E2     |     LED2_BIT=  000005     |     LED2_MAS=  000020 
    LED2_POR=  00500A     |     LOCAL_SI=  000002     |     NAFR    =  004804 
    NCLKOPT =  004808     |     NFLASH_W=  00480E     |     NHSECNT =  00480A 
    NL      =  00000A     |     NOPT1   =  004802     |     NOPT2   =  004804 
    NOPT3   =  004806     |     NOPT4   =  004808     |     NOPT5   =  00480A 
    NOPT6   =  00480C     |     NOPT7   =  00480E     |     NOPTBL  =  00487F 
    NUBC    =  004802     |     NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD 
    NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE 
  5 NonHandl   000000 R   |     OPT0    =  004800     |     OPT1    =  004801 
    OPT2    =  004803     |     OPT3    =  004805     |     OPT4    =  004807 
    OPT5    =  004809     |     OPT6    =  00480B     |     OPT7    =  00480D 
    OPTBL   =  00487E     |     OPTION_B=  004800     |     OPTION_E=  00487F 
    OUTPUT_F=  000001     |     OUTPUT_O=  000000     |     OUTPUT_P=  000001 
    OUTPUT_S=  000000     |     PA      =  000000     |     PAD_SIZE=  000050 
    PA_BASE =  005000     |     PA_CR1  =  005003     |     PA_CR2  =  005004 
    PA_DDR  =  005002     |     PA_IDR  =  005001     |     PA_ODR  =  005000 
    PB      =  000005     |     PB_BASE =  005005     |     PB_CR1  =  005008 
    PB_CR2  =  005009     |     PB_DDR  =  005007     |     PB_IDR  =  005006 
    PB_ODR  =  005005     |     PC      =  00000A     |     PC_BASE =  00500A 
    PC_CR1  =  00500D     |     PC_CR2  =  00500E     |     PC_DDR  =  00500C 
    PC_IDR  =  00500B     |     PC_ODR  =  00500A     |     PD      =  00000F 
    PD_BASE =  00500F     |     PD_CR1  =  005012     |     PD_CR2  =  005013 
    PD_DDR  =  005011     |     PD_IDR  =  005010     |     PD_ODR  =  00500F 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]

Symbol Table

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
    ROP     =  004800     |     RST_SR  =  0050B3     |     SEND_OK =  000000 
    SFR_BASE=  005000     |     SFR_END =  0057FF     |     SIGN    =  000001 
    SPACE   =  000020     |     SPI_CR1 =  005200     |     SPI_CR2 =  005201 
    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_TXCR=  005207 
    STACK_SI=  000100     |     SWIM_CSR=  007F80     |     TAB     =  000009 
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
    TIM1_IER=  000006     |     TIM1_IER=  000000     |     TIM1_OIS=  00526F 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]

Symbol Table

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
    UART_CR3=  000003     |     UART_CR3=  000001     |     UART_CR3=  000002 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]

Symbol Table

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
    WWDG_WR =  0050D2     |   1 acc16      000001 R   |   1 acc24      000000 R
  1 acc8       000002 R   |     add24      ****** GX  |   5 add24_te   00028B R
  5 add_test   0000DB R   |   5 clock_in   000001 R   |     div24_16   ****** GX
  5 div24_16   0002BF R   |     div24_8u   ****** GX  |   5 div24_8u   0002B3 R
  5 div_test   00019C R   |   5 erreur_a   000221 R   |   5 erreur_d   000248 R
  5 erreur_m   00023B R   |   5 erreur_n   000254 R   |   5 erreur_s   00022F R
  5 init0      0000BD R   |   5 itoa       000010 GR  |   5 itoa_loo   00003C R
  5 msg_erre   000217 R   |     mul24_8u   ****** GX  |   5 mul24_8u   00029D R
    mul24u     ****** GX  |   5 mul24u_t   0002A9 R   |   5 mul_test   00013F R
  5 mul_test   00016D R   |     neg24      ****** GX  |   5 neg24_te   0002CC R
  5 neg_test   0001CE R   |   5 new_line   0000A1 R   |   1 pad        000003 R
  5 presenta   0000CF R   |   5 print_er   0001FC R   |   5 print_fn   0000B1 R
  5 print_ui   000083 R   |     sub24      ****** GX  |   5 sub24_te   000294 R
  5 sub_test   00010E R   |   5 test_ok    000260 R   |     uart_ini   ****** GX
    uart_put   ****** GX  |     uart_put   ****** GX  |   5 whatisit   00026A R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size     53   flags    0
   2 SSEG       size      0   flags    8
   3 SSEG0      size    100   flags    8
   4 HOME       size     80   flags    0
   5 CODE       size    2D5   flags    0

