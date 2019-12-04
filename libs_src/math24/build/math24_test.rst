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
                           000050    44     TIB_SIZE=80
                                     45 
                                     46     .area DATA
      000001                         47 acc24: .blkb 1
      000002                         48 acc16: .blkb 1
      000003                         49 acc8:  .blkb 1
      000004                         50 pad:   .ds PAD_SIZE 
      000054                         51 in.w:  .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
      000055                         52 in:		.blkb 1; parser position in tib
      000056                         53 count:  .blkb 1; length of string in tib
      000057                         54 tib:	.blkb TIB_SIZE ; transaction input buffer
                                     55 
                                     56     .area SSEG (ABS)
                           000100    57     STACK_SIZE=256 
      001700                         58     .org RAM_SIZE-STACK_SIZE
      001700                         59     .ds STACK_SIZE 
                                     60 
                                     61     .area HOME 
      008000 82 00 83 9E             62     INT init0
      008004 82 00 80 A2             63     INT exception
      008008 82 00 80 80             64     INT NonHandledInterrupt
      00800C 82 00 80 80             65     INT NonHandledInterrupt
      008010 82 00 80 80             66     INT NonHandledInterrupt
      008014 82 00 80 80             67     INT NonHandledInterrupt
      008018 82 00 80 80             68     INT NonHandledInterrupt
      00801C 82 00 80 80             69     INT NonHandledInterrupt
      008020 82 00 80 80             70     INT NonHandledInterrupt
      008024 82 00 80 80             71     INT NonHandledInterrupt
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



      008028 82 00 80 80             72     INT NonHandledInterrupt
      00802C 82 00 80 80             73     INT NonHandledInterrupt
      008030 82 00 80 80             74     INT NonHandledInterrupt
      008034 82 00 80 80             75     INT NonHandledInterrupt
      008038 82 00 80 80             76     INT NonHandledInterrupt
      00803C 82 00 80 80             77     INT NonHandledInterrupt
      008040 82 00 80 80             78     INT NonHandledInterrupt
      008044 82 00 80 80             79     INT NonHandledInterrupt
      008048 82 00 80 80             80     INT NonHandledInterrupt
      00804C 82 00 80 80             81     INT NonHandledInterrupt
      008050 82 00 80 80             82     INT NonHandledInterrupt
      008054 82 00 80 80             83     INT NonHandledInterrupt
      008058 82 00 80 80             84     INT NonHandledInterrupt
      00805C 82 00 80 80             85     INT NonHandledInterrupt
      008060 82 00 80 80             86     INT NonHandledInterrupt
      008064 82 00 80 80             87     INT NonHandledInterrupt
      008068 82 00 80 80             88     INT NonHandledInterrupt
      00806C 82 00 80 80             89     INT NonHandledInterrupt
      008070 82 00 80 80             90     INT NonHandledInterrupt
      008074 82 00 80 80             91     INT NonHandledInterrupt
      008078 82 00 80 80             92     INT NonHandledInterrupt
      00807C 82 00 80 80             93     INT NonHandledInterrupt
                                     94 
                                     95 
                                     96     .area CODE
                                     97 
                                     98 
      008080                         99 NonHandledInterrupt:
      008080 71                     100     .byte 0x71  ; réinitialize le MCU
                                    101 
      008081 65 72 72 65 72 20 66   102 div_fatal: .asciz "errer fatale: division par zero\n"
             61 74 61 6C 65 3A 20
             64 69 76 69 73 69 6F
             6E 20 70 61 72 20 7A
             65 72 6F 0A 00
                                    103 
      0080A2                        104 exception:
      0080A2 4D               [ 1]  105     tnz a 
      0080A3 26 07            [ 1]  106     jrne 1$
      0080A5 90 AE 80 81      [ 2]  107     ldw y,#div_fatal
      0080A9 CD 81 F0         [ 4]  108     call puts 
      0080AC 20 FE            [ 2]  109 1$: jra .
      0080AE 80               [11]  110     iret 
                                    111 
                                    112 
                                    113 	;initialize clock to use HSE 8 Mhz crystal
      0080AF                        114 clock_init:	
      0080AF 72 12 50 C5      [ 1]  115 	bset CLK_SWCR,#CLK_SWCR_SWEN
      0080B3 A6 B4            [ 1]  116 	ld a,#CLK_SWR_HSE
      0080B5 C7 50 C4         [ 1]  117 	ld CLK_SWR,a
      0080B8 C1 50 C3         [ 1]  118 1$:	cp a,CLK_CMSR
      0080BB 26 FB            [ 1]  119 	jrne 1$
      0080BD 81               [ 4]  120 	ret
                                    121 
                                    122 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                                    123 ;------------------------------------
                                    124 ; convert integer to string
                                    125 ; input:
                                    126 ;   A	  	base
                                    127 ;	acc24	integer to convert
                                    128 ; output:
                                    129 ;   y  		pointer to string
                                    130 ;------------------------------------
                           000001   131 	SIGN=1  ; integer sign 
                           000002   132 	BASE=2  ; numeric base 
                           000002   133 	LOCAL_SIZE=2  ;locals size
      0080BE                        134 itoa:: 
      0080BE 52 02            [ 2]  135 	sub sp,#LOCAL_SIZE
      0080C0 6B 02            [ 1]  136 	ld (BASE,sp), a  ; base
      0080C2 0F 01            [ 1]  137 	clr (SIGN,sp)    ; sign
      0080C4 A1 0A            [ 1]  138 	cp a,#10
      0080C6 26 16            [ 1]  139 	jrne 1$
                                    140 	; base 10 string display with negative sign if bit 23==1
      0080C8 72 0F 00 01 11   [ 2]  141 	btjf acc24,#7,1$
      0080CD 03 01            [ 1]  142 	cpl (SIGN,sp)
      0080CF C6 00 03         [ 1]  143 	ld a,acc8
      0080D2 CE 00 01         [ 2]  144     ldw x,acc24 
      0080D5 CD 87 45         [ 4]  145     call neg24
      0080D8 C7 00 03         [ 1]  146     ld acc8,a 
      0080DB CF 00 01         [ 2]  147     ldw acc24,x 
      0080DE                        148 1$: 
                                    149 ; initialize string pointer 
      0080DE 90 AE 00 53      [ 2]  150 	ldw y,#pad+PAD_SIZE-1
      0080E2 90 7F            [ 1]  151 	clr (y)
      0080E4 90 5A            [ 2]  152     decw y 
      0080E6 A6 20            [ 1]  153     ld a,#SPACE 
      0080E8 90 F7            [ 1]  154     ld (y),a  
      0080EA                        155 itoa_loop:  
      0080EA 7B 02            [ 1]  156     ld a,(BASE,sp)
      0080EC 88               [ 1]  157     push a 
      0080ED C6 00 03         [ 1]  158     ld a,acc8 
      0080F0 CE 00 01         [ 2]  159     ldw x,acc24 
      0080F3 88               [ 1]  160     push a 
      0080F4 89               [ 2]  161     pushw x 
      0080F5 CD 86 02         [ 4]  162     call div24_8u ; acc24/base
      0080F8 AB 30            [ 1]  163     add a,#'0  ; remainder of division
      0080FA A1 3A            [ 1]  164     cp a,#'9+1
      0080FC 2B 02            [ 1]  165     jrmi 2$
      0080FE AB 07            [ 1]  166     add a,#7 
      008100                        167 2$: 
      008100 90 5A            [ 2]  168     decw y
      008102 90 F7            [ 1]  169     ld (y),a
      008104 85               [ 2]  170     popw x
      008105 CF 00 01         [ 2]  171     ldw acc24,x 
      008108 84               [ 1]  172     pop a 
      008109 C7 00 03         [ 1]  173     ld acc8,a 
      00810C 5B 01            [ 2]  174     addw sp,#1
                                    175 	; if acc24==0 conversion done
      00810E CA 00 01         [ 1]  176 	or a,acc24
      008111 CA 00 02         [ 1]  177 	or a,acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



      008114 26 D4            [ 1]  178     jrne itoa_loop
                                    179 	;conversion done, next add '$' or '-' as required
      008116 7B 02            [ 1]  180 	ld a,(BASE,sp)
      008118 A1 10            [ 1]  181 	cp a,#16
      00811A 26 08            [ 1]  182 	jrne 8$
      00811C A6 24            [ 1]  183     ld a,#'$
      00811E 90 5A            [ 2]  184     decw y 
      008120 90 F7            [ 1]  185     ld (y),a 
      008122 20 0A            [ 2]  186     jra 10$
      008124 7B 01            [ 1]  187 8$: ld a,(SIGN,sp)
      008126 27 06            [ 1]  188     jreq 10$
      008128 90 5A            [ 2]  189     decw y
      00812A A6 2D            [ 1]  190     ld a,#'-
      00812C 90 F7            [ 1]  191     ld (y),a
      00812E                        192 10$:
      00812E 5B 02            [ 2]  193 	addw sp,#LOCAL_SIZE
      008130 81               [ 4]  194 	ret
                                    195 
                                    196 ;------------------------
                                    197 ; input:
                                    198 ;   X:A     int24
                                    199 ; output:
                                    200 ;   none 
                                    201 ;------------------------
      008131                        202 print_int24:
      008131 88               [ 1]  203     push a 
      008132 89               [ 2]  204     pushw x 
      008133 90 89            [ 2]  205     pushw y 
      008135 C7 00 03         [ 1]  206     ld acc8,a 
      008138 CF 00 01         [ 2]  207     ldw acc24,x 
      00813B A6 0A            [ 1]  208     ld a,#10
      00813D CD 80 BE         [ 4]  209     call itoa 
      008140 CD 81 F0         [ 4]  210     call puts
      008143 90 85            [ 2]  211     popw y 
      008145 85               [ 2]  212     popw x 
      008146 84               [ 1]  213     pop a 
      008147 81               [ 4]  214     ret 
                                    215 
                           000002   216     ARG_OFS=2
                           000003   217     ARG1=ARG_OFS+1
                           000006   218     ARG2=ARG_OFS+4 
      008148                        219 print_arguments:
      008148 1E 03            [ 2]  220     ldW x,(ARG1,sp)
      00814A 7B 05            [ 1]  221     ld a,(ARG1+2,sp)
      00814C CD 81 31         [ 4]  222     call print_int24 
      00814F 1E 06            [ 2]  223     ldW x,(ARG2,sp)
      008151 7B 08            [ 1]  224     ld a,(ARG2+2,sp)
      008153 CD 81 31         [ 4]  225     call print_int24 
      008156 A6 3D            [ 1]  226     ld a,#'=
      008158 CD 81 DA         [ 4]  227     call putc 
      00815B 81               [ 4]  228     ret 
                                    229 
      00815C                        230 new_line:
      00815C 88               [ 1]  231     push a 
      00815D 89               [ 2]  232     pushw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



      00815E A6 0D            [ 1]  233     ld a,#CR 
      008160 CD 81 DA         [ 4]  234     call putc 
      008163 84               [ 1]  235     pop a 
      008164 85               [ 2]  236     popw x 
      008165 81               [ 4]  237     ret 
                                    238 
                                    239 
                                    240 ;------------------------------------
                                    241 ; convert pad content in integer
                                    242 ; input:
                                    243 ;    pad		.asciz to convert
                                    244 ; output:
                                    245 ;    X:A      int24_t
                                    246 ;------------------------------------
                                    247 	; local variables
                           000001   248 	U24=1 ; 3 byte, utilisation temporaire pour la conversion
                           000004   249 	BASE=4 ; 1 byte, base numérique utilisée pour la conversion
                           000005   250 	SIGN=5 ; 1 byte, signe de l'entier
                           000005   251     LOCAL_SIZE=5 ; taille des variables locales 
      008166                        252 atoi::
      008166 90 89            [ 2]  253 	pushw y ;save y
      008168 52 05            [ 2]  254 	sub sp,#LOCAL_SIZE
      00816A 0F 05            [ 1]  255 	clr (SIGN,sp)
      00816C 0F 01            [ 1]  256 	clr (U24,sp)    
      00816E 0F 02            [ 1]  257 	clr (U24+1,sp)
      008170 0F 03            [ 1]  258 	clr (U24+2,sp)
      008172 C6 00 04         [ 1]  259 	ld a, pad 
      008175 27 53            [ 1]  260 	jreq 9$
      008177 A6 0A            [ 1]  261 	ld a,#10
      008179 6B 04            [ 1]  262 	ld (BASE,sp),a ; default base decimal
      00817B 90 AE 00 04      [ 2]  263 	ldw y,#pad ; pointer to string to convert
      00817F 90 F6            [ 1]  264 	ld a,(y)
      008181 27 47            [ 1]  265 	jreq 9$  ; completed if 0
      008183 A1 2D            [ 1]  266 	cp a,#'-
      008185 26 04            [ 1]  267 	jrne 1$
      008187 03 05            [ 1]  268 	cpl (SIGN,sp)
      008189 20 08            [ 2]  269 	jra 2$
      00818B A1 24            [ 1]  270 1$: cp a,#'$
      00818D 26 08            [ 1]  271 	jrne 3$
      00818F A6 10            [ 1]  272 	ld a,#16
      008191 6B 04            [ 1]  273 	ld (BASE,sp),a
                                    274 ; boucle de conversion    
      008193 90 5C            [ 1]  275 2$:	incw y
      008195 90 F6            [ 1]  276 	ld a,(y)
      008197                        277 3$:	
      008197 A1 61            [ 1]  278 	cp a,#'a
      008199 2B 02            [ 1]  279 	jrmi 4$
      00819B A0 20            [ 1]  280 	sub a,#32
      00819D A1 30            [ 1]  281 4$:	cp a,#'0
      00819F 2B 29            [ 1]  282 	jrmi 9$
      0081A1 A0 30            [ 1]  283 	sub a,#'0
      0081A3 A1 0A            [ 1]  284 	cp a,#10
      0081A5 2B 06            [ 1]  285 	jrmi 5$
      0081A7 A0 07            [ 1]  286 	sub a,#7
      0081A9 11 04            [ 1]  287 	cp a,(BASE,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



      0081AB 2A 1D            [ 1]  288 	jrpl 9$
      0081AD C7 00 03         [ 1]  289 5$:	ld acc8,a
      0081B0 CD 85 5E         [ 4]  290     call mul24_8u
      0081B3 6B 03            [ 1]  291     ld (U24+2,sp),a 
      0081B5 1F 01            [ 2]  292     ldw (U24,sp),x
      0081B7 C6 00 03         [ 1]  293     ld a,acc8 
      0081BA 1B 03            [ 1]  294     add a,(U24+2,sp)
      0081BC 6B 03            [ 1]  295     ld (U24+2,sp),a 
      0081BE 4F               [ 1]  296     clr a 
      0081BF 19 02            [ 1]  297     adc a,(U24+1,sp)
      0081C1 6B 02            [ 1]  298     ld (U24+1,sp),a 
      0081C3 4F               [ 1]  299     clr a 
      0081C4 19 01            [ 1]  300     adc a,(U24,sp)
      0081C6 6B 01            [ 1]  301     ld (U24,sp),a 
      0081C8 20 C9            [ 2]  302 	jra 2$
      0081CA 7B 03            [ 1]  303 9$:	ld a,(U24+2,sp)
      0081CC 1E 01            [ 2]  304     ldw x,(U24,sp)
      0081CE 0D 05            [ 1]  305     tnz (SIGN,sp)
      0081D0 27 03            [ 1]  306     jreq atoi_exit
      0081D2 CD 87 45         [ 4]  307     call neg24 
      0081D5                        308 atoi_exit: 
      0081D5 5B 05            [ 2]  309 	addw sp,#LOCAL_SIZE
      0081D7 90 85            [ 2]  310 	popw y
      0081D9 81               [ 4]  311 	ret
                                    312 
                                    313 ;----------------------------------
                                    314 ; envoie un caractère via UART3 
                                    315 ; input:
                                    316 ;   A       charactère à envoyé.
                                    317 ; output:
                                    318 ;   none 
                                    319 ;----------------------------------
      0081DA                        320 putc:
      0081DA 52 02            [ 2]  321     sub sp,#2
      0081DC 6B 01            [ 1]  322     ld (1,sp),a 
      0081DE A6 01            [ 1]  323     ld a,#UART3
      0081E0 6B 02            [ 1]  324     ld (2,sp),a 
      0081E2 CD 87 DB         [ 4]  325     call uart_putc 
      0081E5 5B 02            [ 2]  326     addw sp,#2
      0081E7 81               [ 4]  327     ret
                                    328 ;-----------------------------------
                                    329 ;  attend un caractère du UART3
                                    330 ;  input:
                                    331 ;       none 
                                    332 ;  output:
                                    333 ;    A      character reçu.
                                    334 ;-----------------------------------
      0081E8                        335 getc:
      0081E8 4B 01            [ 1]  336     push #UART3 
      0081EA CD 88 2F         [ 4]  337     call uart_getc 
      0081ED 5B 01            [ 2]  338     addw sp,#1 
      0081EF 81               [ 4]  339     ret 
                                    340 
                                    341     
                                    342 ;----------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                                    343 ; envoie une chaîne via UART3 
                                    344 ; input:
                                    345 ;   Y       ponteur chaîne
                                    346 ; output:
                                    347 ;   none 
                                    348 ;----------------------------------
      0081F0                        349 puts:
      0081F0 52 03            [ 2]  350     sub sp,#3
      0081F2 A6 01            [ 1]  351     ld a,#UART3 
      0081F4 6B 03            [ 1]  352     ld (3,sp),a 
      0081F6 17 01            [ 2]  353     ldw (1,sp),y 
      0081F8 CD 87 FF         [ 4]  354     call uart_puts 
      0081FB 5B 03            [ 2]  355     addw sp,#3
      0081FD 81               [ 4]  356     ret
                                    357 
                                    358 ;------------------------------------
                                    359 ; read a line of text from terminal
                                    360 ; input:
                                    361 ;	none
                                    362 ; output:
                                    363 ;   text in tib  buffer
                                    364 ;   len in count variable
                                    365 ;------------------------------------
                                    366 	; local variables
                           000001   367 	RXCHAR = 1 ; last char received
                           000002   368     LEN = 2  ; accepted line length
                           000002   369     LOCAL_SIZE=2 
      0081FE                        370 readln::
      0081FE 52 02            [ 2]  371     sub sp,#LOCAL_SIZE 
      008200 0F 01            [ 1]  372 	clr (RXCHAR,sp)  ; RXCHAR 
      008202 0F 02            [ 1]  373     clr (LEN,sp)  ; LEN
      008204 90 AE 00 57      [ 2]  374  	ldw y,#tib ; input buffer
      008208                        375 readln_loop:
      008208 CD 81 E8         [ 4]  376 	call getc
      00820B 6B 01            [ 1]  377 	ld (RXCHAR,sp),a
      00820D A1 03            [ 1]  378     cp a,#CTRL_C
      00820F 26 03            [ 1]  379 	jrne 2$
      008211 CC 82 9E         [ 2]  380 	jp cancel
      008214 A1 12            [ 1]  381 2$:	cp a,#CTRL_R
      008216 27 5F            [ 1]  382 	jreq reprint
      008218 A1 0D            [ 1]  383 	cp a,#CR
      00821A 26 03            [ 1]  384 	jrne 1$
      00821C CC 82 A8         [ 2]  385 	jp readln_quit
      00821F A1 0A            [ 1]  386 1$:	cp a,#NL
      008221 26 03            [ 1]  387 	jrne 3$ 
      008223 CC 82 A8         [ 2]  388     jp readln_quit
      008226 A1 08            [ 1]  389 3$:	cp a,#BSP
      008228 27 21            [ 1]  390 	jreq del_back
      00822A A1 04            [ 1]  391 	cp a,#CTRL_D
      00822C 27 06            [ 1]  392 	jreq del_line
      00822E A1 20            [ 1]  393 	cp a,#SPACE
      008230 2A 30            [ 1]  394 	jrpl accept_char
      008232 20 D4            [ 2]  395 	jra readln_loop
      008234                        396 del_line:
      008234 A6 01            [ 1]  397     ld a,#UART3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



      008236 88               [ 1]  398     push a 
      008237 7B 02            [ 1]  399 	ld a,(LEN,sp)
      008239 88               [ 1]  400     push a 
      00823A CD 88 3F         [ 4]  401 	call uart_delete
      00823D 5B 02            [ 2]  402     addw sp,#2 
      00823F 90 AE 00 57      [ 2]  403 	ldw y,#tib
      008243 72 5F 00 56      [ 1]  404 	clr count
      008247 0F 02            [ 1]  405 	clr (LEN,sp)
      008249 20 BD            [ 2]  406 	jra readln_loop
      00824B                        407 del_back:
      00824B 0D 02            [ 1]  408     tnz (LEN,sp)
      00824D 27 B9            [ 1]  409     jreq readln_loop
      00824F 0A 02            [ 1]  410     dec (LEN,sp)
      008251 90 5A            [ 2]  411     decw y
      008253 90 7F            [ 1]  412     clr  (y)
      008255 A6 01            [ 1]  413     ld a,#UART3
      008257 88               [ 1]  414     push a 
      008258 A6 01            [ 1]  415     ld a,#1
      00825A 88               [ 1]  416     push a 
      00825B CD 88 3F         [ 4]  417     call uart_delete
      00825E 5B 02            [ 2]  418     addw sp,#2
      008260 20 A6            [ 2]  419     jra readln_loop	
      008262                        420 accept_char:
      008262 A6 4F            [ 1]  421 	ld a,#TIB_SIZE-1
      008264 11 02            [ 1]  422 	cp a, (LEN,sp)
      008266 27 A0            [ 1]  423 	jreq readln_loop
      008268 7B 01            [ 1]  424 	ld a,(RXCHAR,sp)
      00826A 90 F7            [ 1]  425 	ld (y),a
      00826C 0C 02            [ 1]  426 	inc (LEN,sp)
      00826E 90 5C            [ 1]  427 	incw y
      008270 90 7F            [ 1]  428 	clr (y)
      008272 CD 81 DA         [ 4]  429 	call putc 
      008275 20 91            [ 2]  430 	jra readln_loop
      008277                        431 reprint:
      008277 0D 02            [ 1]  432 	tnz (LEN,sp)
      008279 26 8D            [ 1]  433 	jrne readln_loop
      00827B 72 5D 00 56      [ 1]  434 	tnz count
      00827F 26 03            [ 1]  435     jrne 4$
      008281 CC 82 08         [ 2]  436 	jp readln_loop
      008284 90 AE 00 57      [ 2]  437 4$:	ldw y,#tib
      008288 90 89            [ 2]  438     pushw y
      00828A CD 81 F0         [ 4]  439 	call puts 
      00828D 90 85            [ 2]  440 	popw y 
      00828F C6 00 56         [ 1]  441 	ld a,count
      008292 6B 02            [ 1]  442 	ld (LEN,sp),a
      008294 90 9F            [ 1]  443 	ld a,yl
      008296 CB 00 56         [ 1]  444 	add a,count
      008299 90 97            [ 1]  445 	ld yl,a
      00829B CC 82 08         [ 2]  446 	jp readln_loop
      00829E                        447 cancel:
      00829E 72 5F 00 57      [ 1]  448 	clr tib
      0082A2 72 5F 00 56      [ 1]  449 	clr count
      0082A6 20 05            [ 2]  450 	jra readln_quit2
      0082A8                        451 readln_quit:
      0082A8 7B 02            [ 1]  452 	ld a,(LEN,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



      0082AA C7 00 56         [ 1]  453 	ld count,a
      0082AD                        454 readln_quit2:
      0082AD 5B 02            [ 2]  455 	addw sp,#2
      0082AF A6 0A            [ 1]  456 	ld a,#NL
      0082B1 CD 81 DA         [ 4]  457 	call putc
      0082B4 81               [ 4]  458 	ret
                                    459 
                                    460 ;------------------------------------
                                    461 ; skip character c in tib starting from 'in'
                                    462 ; input:
                                    463 ;	 y 		point to tib 
                                    464 ;    a 		character to skip
                                    465 ; output:  
                                    466 ;	'in' ajusted to new position
                                    467 ;------------------------------------
                           000001   468 	C = 1 ; local var
      0082B5                        469 skip:
      0082B5 88               [ 1]  470 	push a
      0082B6 91 D6 54         [ 4]  471 1$:	ld a,([in.w],y)
      0082B9 27 0A            [ 1]  472 	jreq 2$
      0082BB 11 01            [ 1]  473 	cp a,(C,sp)
      0082BD 26 06            [ 1]  474 	jrne 2$
      0082BF 72 5C 00 55      [ 1]  475 	inc in
      0082C3 20 F1            [ 2]  476 	jra 1$
      0082C5 84               [ 1]  477 2$: pop a
      0082C6 81               [ 4]  478 	ret
                                    479 	
                                    480 ;------------------------------------
                                    481 ; scan tib for charater 'c' starting from 'in'
                                    482 ; input:
                                    483 ;	y  point to tib 
                                    484 ;	a character to skip
                                    485 ; output:
                                    486 ;	in point to chacter 'c'
                                    487 ;------------------------------------
                           000001   488 	C = 1 ; local var
      0082C7                        489 scan: 
      0082C7 88               [ 1]  490 	push a
      0082C8 91 D6 54         [ 4]  491 1$:	ld a,([in.w],y)
      0082CB 27 0A            [ 1]  492 	jreq 2$
      0082CD 11 01            [ 1]  493 	cp a,(C,sp)
      0082CF 27 06            [ 1]  494 	jreq 2$
      0082D1 72 5C 00 55      [ 1]  495 	inc in
      0082D5 20 F1            [ 2]  496 	jra 1$
      0082D7 84               [ 1]  497 2$: pop a
      0082D8 81               [ 4]  498 	ret
                                    499 
                                    500 ;------------------------------------
                                    501 ; parse quoted string 
                                    502 ; input:
                                    503 ;   Y 	pointer to tib 
                                    504 ;   X   pointer to tab 
                                    505 ; output:
                                    506 ;	pad   containt string 
                                    507 ;------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                           000001   508 	PREV = 1
      0082D9                        509 parse_quote:
      0082D9 4F               [ 1]  510 	clr a
      0082DA 88               [ 1]  511 	push a
      0082DB 6B 01            [ 1]  512 1$:	ld (PREV,sp),a 
      0082DD 72 5C 00 55      [ 1]  513 	inc in
      0082E1 91 D6 54         [ 4]  514 	ld a,([in.w],y)
      0082E4 27 22            [ 1]  515 	jreq 4$
      0082E6 88               [ 1]  516 	push a
      0082E7 7B 01            [ 1]  517 	ld a, (PREV,sp)
      0082E9 A1 5C            [ 1]  518 	cp a,#'\
      0082EB 84               [ 1]  519 	pop a 
      0082EC 26 08            [ 1]  520 	jrne 11$
      0082EE 0F 01            [ 1]  521 	clr (PREV,sp)
      0082F0 AD 19            [ 4]  522 	callr convert_escape
      0082F2 F7               [ 1]  523 	ld (x),a 
      0082F3 5C               [ 1]  524 	incw x 
      0082F4 20 E5            [ 2]  525 	jra 1$
      0082F6                        526 11$: 
      0082F6 A1 5C            [ 1]  527 	cp a,#'\'
      0082F8 26 04            [ 1]  528 	jrne 2$
      0082FA 6B 01            [ 1]  529 	ld (PREV,sp),a 
      0082FC 20 DD            [ 2]  530 	jra 1$
      0082FE F7               [ 1]  531 2$:	ld (x),a 
      0082FF 5C               [ 1]  532 	incw x 
      008300 A1 22            [ 1]  533 	cp a,#'"'
      008302 26 D7            [ 1]  534 	jrne 1$
      008304 72 5C 00 55      [ 1]  535 	inc in 
      008308 7F               [ 1]  536 4$:	clr (x)
      008309 84               [ 1]  537 	pop a 
      00830A 81               [ 4]  538 	ret 
                                    539 
                                    540 ;---------------------------------------
                                    541 ; called by parse_quote
                                    542 ; subtitute escaped character 
                                    543 ; by their ASCII value .
                                    544 ; input:
                                    545 ;   A  character following '\'
                                    546 ; output:
                                    547 ;   A  substitued char or same if not valid.
                                    548 ;---------------------------------------
      00830B                        549 convert_escape:
      00830B A1 61            [ 1]  550 	cp a,#'a'
      00830D 26 03            [ 1]  551 	jrne 1$
      00830F A6 07            [ 1]  552 	ld a,#7
      008311 81               [ 4]  553 	ret 
      008312 A1 62            [ 1]  554 1$: cp a,#'b'
      008314 26 03            [ 1]  555 	jrne 2$
      008316 A6 08            [ 1]  556 	ld a,#8
      008318 81               [ 4]  557 	ret 
      008319 A1 65            [ 1]  558 2$: cp a,#'e' 
      00831B 26 03            [ 1]  559     jrne 3$
      00831D A6 5C            [ 1]  560 	ld a,#'\'
      00831F 81               [ 4]  561 	ret  
      008320 A1 5C            [ 1]  562 3$: cp a,#'\'
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



      008322 26 03            [ 1]  563 	jrne 4$
      008324 A6 5C            [ 1]  564 	ld a,#'\'
      008326 81               [ 4]  565 	ret 
      008327 A1 66            [ 1]  566 4$: cp a,#'f' 
      008329 26 03            [ 1]  567 	jrne 5$ 
      00832B A6 0C            [ 1]  568 	ld a,#FF 
      00832D 81               [ 4]  569 	ret  
      00832E A1 6E            [ 1]  570 5$: cp a,#'n' 
      008330 26 03            [ 1]  571     jrne 6$ 
      008332 A6 0A            [ 1]  572 	ld a,#0xa 
      008334 81               [ 4]  573 	ret  
      008335 A1 72            [ 1]  574 6$: cp a,#'r' 
      008337 26 03            [ 1]  575 	jrne 7$
      008339 A6 0D            [ 1]  576 	ld a,#0xd 
      00833B 81               [ 4]  577 	ret  
      00833C A1 74            [ 1]  578 7$: cp a,#'t' 
      00833E 26 03            [ 1]  579 	jrne 8$ 
      008340 A6 09            [ 1]  580 	ld a,#9 
      008342 81               [ 4]  581 	ret  
      008343 A1 76            [ 1]  582 8$: cp a,#'v' 
      008345 26 02            [ 1]  583 	jrne 9$  
      008347 A6 0B            [ 1]  584 	ld a,#0xb 
      008349 81               [ 4]  585 9$:	ret 
                                    586 
                                    587 ;------------------------------------
                                    588 ; Command line tokenizer
                                    589 ; scan tib for next word
                                    590 ; move token in 'pad'
                                    591 ; use:
                                    592 ;	Y   pointer to tib 
                                    593 ;   X	pointer to pad 
                                    594 ;   in.w   index in tib
                                    595 ; output:
                                    596 ;   pad 	token as .asciz  
                                    597 ;------------------------------------
      00834A                        598 next_word::
      00834A 89               [ 2]  599 	pushw x 
      00834B 90 89            [ 2]  600 	pushw y 
      00834D AE 00 04         [ 2]  601 	ldw x, #pad 
      008350 90 AE 00 57      [ 2]  602 	ldw y, #tib  	
      008354 A6 20            [ 1]  603 	ld a,#SPACE
      008356 CD 82 B5         [ 4]  604 	call skip
      008359 91 D6 54         [ 4]  605 	ld a,([in.w],y)
      00835C 27 1D            [ 1]  606 	jreq 8$
      00835E A1 22            [ 1]  607 	cp a,#'"
      008360 26 07            [ 1]  608 	jrne 1$
      008362 F7               [ 1]  609 	ld (x),a 
      008363 5C               [ 1]  610 	incw x 
      008364 CD 82 D9         [ 4]  611 	call parse_quote
      008367 20 13            [ 2]  612 	jra 9$
      008369 A1 20            [ 1]  613 1$: cp a,#SPACE
      00836B 27 0E            [ 1]  614 	jreq 8$
      00836D CD 83 80         [ 4]  615 	call to_lower 
      008370 F7               [ 1]  616 	ld (x),a 
      008371 5C               [ 1]  617 	incw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



      008372 72 5C 00 55      [ 1]  618 	inc in
      008376 91 D6 54         [ 4]  619 	ld a,([in.w],y) 
      008379 26 EE            [ 1]  620 	jrne 1$
      00837B 7F               [ 1]  621 8$: clr (x)
      00837C 90 85            [ 2]  622 9$:	popw y 
      00837E 85               [ 2]  623 	popw x 
      00837F 81               [ 4]  624 	ret
                                    625 
                                    626 ;----------------------------------
                                    627 ; convert to lower case
                                    628 ; input: 
                                    629 ;   A 		character to convert
                                    630 ; output:
                                    631 ;   A		result 
                                    632 ;----------------------------------
      008380                        633 to_lower::
      008380 A1 41            [ 1]  634 	cp a,#'A
      008382 25 06            [ 1]  635 	jrult 9$
      008384 A1 5A            [ 1]  636 	cp a,#'Z 
      008386 22 02            [ 1]  637 	jrugt 9$
      008388 AB 20            [ 1]  638 	add a,#32
      00838A 81               [ 4]  639 9$: ret
                                    640 
                                    641 ;------------------------------------
                                    642 ; convert alpha to uppercase
                                    643 ; input:
                                    644 ;    a  character to convert
                                    645 ; output:
                                    646 ;    a  uppercase character
                                    647 ;------------------------------------
      00838B                        648 to_upper::
      00838B A1 61            [ 1]  649 	cp a,#'a
      00838D 2A 01            [ 1]  650 	jrpl 1$
      00838F 81               [ 4]  651 0$:	ret
      008390 A1 7A            [ 1]  652 1$: cp a,#'z	
      008392 22 FB            [ 1]  653 	jrugt 0$
      008394 A0 20            [ 1]  654 	sub a,#32
      008396 81               [ 4]  655 	ret
                                    656 
                                    657 ;------------------------------------
                                    658 ; expect a number from command line next argument
                                    659 ;  input:
                                    660 ;	  none
                                    661 ;  output:
                                    662 ;    acc24   int24_t 
                                    663 ;------------------------------------
      008397                        664 number::
      008397 CD 83 4A         [ 4]  665 	call next_word
      00839A CD 81 66         [ 4]  666 	call atoi
      00839D 81               [ 4]  667 	ret
                                    668 
      00839E                        669 init0:
      00839E AE 17 FF         [ 2]  670     ldw x,#RAM_SIZE-1
      0083A1 94               [ 1]  671     ldw sp,x 
      0083A2 CD 80 AF         [ 4]  672     call clock_init
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                                    673 ; initialize UART3    
      0083A5 A6 01            [ 1]  674     ld a,#UART3 
      0083A7 88               [ 1]  675     push a 
      0083A8 A6 06            [ 1]  676     ld a,#B115200
      0083AA 88               [ 1]  677     push a 
      0083AB CD 87 8D         [ 4]  678     call uart_init
      0083AE 5B 02            [ 2]  679     addw sp,#2  
                                    680     
                           000000   681     IDX_ERR_SUM=0
                           000001   682     IDX_ERR_SUB=1 
                           000002   683     IDX_ERR_MUL=2
                           000003   684     IDX_ERR_DIV=3
                           000004   685     IDX_ERR_NEG=4
                                    686 
      0083B0                        687 presentation:
      0083B0 90 AE 84 DC      [ 2]  688     ldw y,#whatisit
      0083B4 CD 81 F0         [ 4]  689     call puts 
      0083B7 72 5F 00 54      [ 1]  690     clr in.w
      0083BB                        691 repl:
                                    692 ; move terminal cursor to next line
      0083BB A6 0A            [ 1]  693 	ld a,#NL 
      0083BD CD 81 DA         [ 4]  694 	call putc 
                                    695 ; print prompt sign	 
      0083C0 A6 3E            [ 1]  696 	ld a,#'>
      0083C2 CD 81 DA         [ 4]  697 	call putc 
                                    698 ; read command line	
      0083C5 CD 81 FE         [ 4]  699 	call readln 
                                    700 ;if empty line -> ignore it, loop.	
      0083C8 72 5D 00 56      [ 1]  701 	tnz count
      0083CC 27 ED            [ 1]  702 	jreq repl
                                    703 ; initialize parser and call eval function	  
      0083CE 72 5F 00 55      [ 1]  704     clr in
      0083D2 CD 83 D7         [ 4]  705 	call eval
                                    706 ; start over	
      0083D5 20 E4            [ 2]  707 	jra repl  ; loop
                                    708 
                                    709 ; arguments locales 
                           000001   710     N1=1
                           000004   711     N2=4
                           000007   712     OP=7
                           000007   713     LOCAL_SIZE=7  
      0083D7                        714 eval:
      0083D7 52 07            [ 2]  715     sub sp,#LOCAL_SIZE 
      0083D9 CD 83 4A         [ 4]  716     call next_word 
      0083DC C6 00 04         [ 1]  717     ld a,pad 
      0083DF 6B 07            [ 1]  718     ld (OP,sp),a
      0083E1 CD 83 97         [ 4]  719     call number
      0083E4 1F 01            [ 2]  720     ldw (N1,sp),x 
      0083E6 6B 03            [ 1]  721     ld (N1+2,sp),a 
      0083E8 CD 83 97         [ 4]  722     call number 
      0083EB 1F 04            [ 2]  723     ldw (N2,sp),x 
      0083ED 6B 06            [ 1]  724     ld (N2+2,sp),a  
      0083EF 7B 07            [ 1]  725     ld a,(OP,sp)
      0083F1 A1 2B            [ 1]  726     cp a,#'+
      0083F3 26 03            [ 1]  727     jrne 1$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



      0083F5 CC 84 10         [ 2]  728     jp test_add
      0083F8 A1 2D            [ 1]  729 1$: cp a,#'- 
      0083FA 26 03            [ 1]  730     jrne 2$ 
      0083FC CC 84 23         [ 2]  731     jp test_sub 
      0083FF A1 2A            [ 1]  732 2$: cp a,#'* 
      008401 26 03            [ 1]  733     jrne 3$ 
      008403 CC 84 36         [ 2]  734     jp test_mul 
      008406 A1 2F            [ 1]  735 3$: cp a,#'/ 
      008408 26 03            [ 1]  736     jrne 4$ 
      00840A CC 84 49         [ 2]  737     jp test_div 
      00840D                        738 4$:     
      00840D                        739 eval_exit:
      00840D 5B 07            [ 2]  740     addw sp,#LOCAL_SIZE 
      00840F 81               [ 4]  741     ret 
                                    742 
      008410                        743 test_add:
      008410 90 AE 84 FD      [ 2]  744     ldw y,#add24_test
      008414 CD 81 F0         [ 4]  745     call puts 
      008417 CD 81 48         [ 4]  746     call print_arguments
      00841A CD 85 44         [ 4]  747     call add24 
      00841D CD 81 31         [ 4]  748     call print_int24
      008420 CC 84 0D         [ 2]  749     jp eval_exit
      008423                        750 test_sub:
      008423 90 AE 85 06      [ 2]  751     ldw y,#sub24_test
      008427 CD 81 F0         [ 4]  752     call puts 
      00842A CD 81 48         [ 4]  753     call print_arguments
      00842D CD 85 51         [ 4]  754     call sub24 
      008430 CD 81 31         [ 4]  755     call print_int24
      008433 CC 84 0D         [ 2]  756     jp eval_exit
      008436                        757 test_mul:
      008436 90 AE 85 1B      [ 2]  758     ldw y,#mul24s_test
      00843A CD 81 F0         [ 4]  759     call puts
      00843D CD 81 48         [ 4]  760     call print_arguments
      008440 CD 85 CB         [ 4]  761     call mul24s 
      008443 CD 81 31         [ 4]  762     call print_int24
      008446 CC 84 0D         [ 2]  763     jp eval_exit
      008449                        764 test_div:
      008449 90 AE 85 31      [ 2]  765     ldw y,#div24s_test
      00844D CD 81 F0         [ 4]  766     call puts
      008450 CD 81 48         [ 4]  767     call print_arguments
      008453 CD 86 C0         [ 4]  768     call div24s 
      008456 CD 81 31         [ 4]  769     call print_int24
      008459 A6 52            [ 1]  770     ld a,#'R 
      00845B CD 81 DA         [ 4]  771     call putc 
      00845E A6 3D            [ 1]  772     ld a,#'=
      008460 CD 81 DA         [ 4]  773     call putc 
      008463 1E 01            [ 2]  774     ldw x,(1,sp)
      008465 7B 03            [ 1]  775     ld a,(3,sp)
      008467 CD 81 31         [ 4]  776     call print_int24  
      00846A CC 84 0D         [ 2]  777     jp eval_exit
                                    778 
                                    779 
      00846D                        780 print_error:
      00846D 90 AE 84 84      [ 2]  781     ldw y,#msg_erreur
      008471 72 5F 00 02      [ 1]  782     clr acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



      008475 48               [ 1]  783     sll a 
      008476 C7 00 03         [ 1]  784     ld acc8,a
      008479 72 B9 00 02      [ 2]  785     addw y,acc16 
      00847D 90 FE            [ 2]  786     ldw y,(y)
      00847F CD 81 F0         [ 4]  787     call puts
      008482 20 FE            [ 2]  788     jra .
                                    789 
                                    790 
      008484 84 8E 84 9C 84 A8 84   791 msg_erreur: .word erreur_add,erreur_sub,erreur_mul,erreur_div,erreur_neg
             B5 84 C1
                                    792 
      00848E 65 72 72 65 75 72 20   793 erreur_add: .asciz "erreur somme\n"
             73 6F 6D 6D 65 0A 00
      00849C 65 72 72 65 75 72 20   794 erreur_sub: .asciz "erreur sub\n"
             73 75 62 0A 00
      0084A8 65 72 72 65 75 72 20   795 erreur_mul: .asciz "erreur mult\n"
             6D 75 6C 74 0A 00
      0084B5 65 72 72 65 75 72 20   796 erreur_div: .asciz "erreur div\n"
             64 69 76 0A 00
      0084C1 65 72 72 65 75 72 20   797 erreur_neg: .asciz "erreur neg\n"
             6E 65 67 0A 00
                                    798 
      0084CD 0A 61 6C 6C 20 74 65   799 test_ok: .asciz "\nall tests ok\n"
             73 74 73 20 6F 6B 0A
             00
      0084DC 0A 54 65 73 74 20 70   800 whatisit: .asciz "\nTest pour la librairie math24.\n"
             6F 75 72 20 6C 61 20
             6C 69 62 72 61 69 72
             69 65 20 6D 61 74 68
             32 34 2E 0A 00
      0084FD 0A 61 64 64 32 34 3A   801 add24_test: .asciz "\nadd24: "
             20 00
      008506 0A 73 75 62 32 34 3A   802 sub24_test: .asciz "\nsub24: "
             20 00
      00850F 0A 6D 75 6C 32 34 5F   803 mul24_8u_test: .asciz "\nmul24_8u: " 
             38 75 3A 20 00
      00851B 0A 6D 75 6C 32 34 73   804 mul24s_test: .asciz "\nmul24s: "
             3A 20 00
      008525 0A 64 69 76 32 34 5F   805 div24_8u_test: .asciz "\ndiv24_8u: "
             38 75 3A 20 00
      008531 0A 64 69 76 32 34 73   806 div24s_test: .asciz "\ndiv24s: "
             3A 20 00
      00853B 0A 6E 65 67 32 34 3A   807 neg24_test: .asciz "\nneg24: "
             20 00
                                    808 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
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
    AFR6_I2C=  000006     |     AFR7_BEE=  000007     |     ARG1    =  000003 
    ARG2    =  000006     |     ARG_OFS =  000002     |     AWU_APR =  0050F1 
    AWU_CSR1=  0050F0     |     AWU_TBR =  0050F2     |     B0_MASK =  000001 
    B115200 =  000006     |     B19200  =  000003     |     B1_MASK =  000002 
    B230400 =  000007     |     B2400   =  000000     |     B2_MASK =  000004 
    B38400  =  000004     |     B3_MASK =  000008     |     B460800 =  000008 
    B4800   =  000001     |     B4_MASK =  000010     |     B57600  =  000005 
    B5_MASK =  000020     |     B6_MASK =  000040     |     B7_MASK =  000080 
    B921600 =  000009     |     B9600   =  000002     |     BASE    =  000004 
    BEEP_BIT=  000004     |     BEEP_CSR=  0050F3     |     BEEP_MAS=  000010 
    BEEP_POR=  00000F     |     BELL    =  000007     |     BIT0    =  000000 
    BIT1    =  000001     |     BIT2    =  000002     |     BIT3    =  000003 
    BIT4    =  000004     |     BIT5    =  000005     |     BIT6    =  000006 
    BIT7    =  000007     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BSP     =  000008     |     C       =  000001     |     CAN_DGR =  005426 
    CAN_FPSR=  005427     |     CAN_IER =  005425     |     CAN_MCR =  005420 
    CAN_MSR =  005421     |     CAN_P0  =  005428     |     CAN_P1  =  005429 
    CAN_P2  =  00542A     |     CAN_P3  =  00542B     |     CAN_P4  =  00542C 
    CAN_P5  =  00542D     |     CAN_P6  =  00542E     |     CAN_P7  =  00542F 
    CAN_P8  =  005430     |     CAN_P9  =  005431     |     CAN_PA  =  005432 
    CAN_PB  =  005433     |     CAN_PC  =  005434     |     CAN_PD  =  005435 
    CAN_PE  =  005436     |     CAN_PF  =  005437     |     CAN_RFR =  005424 
    CAN_TPR =  005423     |     CAN_TSR =  005422     |     CC_C    =  000000 
    CC_H    =  000004     |     CC_I0   =  000003     |     CC_I1   =  000005 
    CC_N    =  000002     |     CC_V    =  000007     |     CC_Z    =  000001 
    CFG_GCR =  007F60     |     CFG_GCR_=  000001     |     CFG_GCR_=  000000 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]

Symbol Table

    CPU_A   =  007F00     |     CPU_CCR =  007F0A     |     CPU_PCE =  007F01 
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
    CTRL_Y  =  000019     |     CTRL_Z  =  00001A     |     DEBUG_BA=  007F00 
    DEBUG_EN=  007FFF     |     DEVID_BA=  0048CD     |     DEVID_EN=  0048D8 
    DEVID_LO=  0048D2     |     DEVID_LO=  0048D3     |     DEVID_LO=  0048D4 
    DEVID_LO=  0048D5     |     DEVID_LO=  0048D6     |     DEVID_LO=  0048D7 
    DEVID_LO=  0048D8     |     DEVID_WA=  0048D1     |     DEVID_XH=  0048CE 
    DEVID_XL=  0048CD     |     DEVID_YH=  0048D0     |     DEVID_YL=  0048CF 
    DM_BK1RE=  007F90     |     DM_BK1RH=  007F91     |     DM_BK1RL=  007F92 
    DM_BK2RE=  007F93     |     DM_BK2RH=  007F94     |     DM_BK2RL=  007F95 
    DM_CR1  =  007F96     |     DM_CR2  =  007F97     |     DM_CSR1 =  007F98 
    DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A     |     EEPROM_B=  004000 
    EEPROM_E=  0047FF     |     EEPROM_S=  000800     |     ESC     =  00001B 
    EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1     |     FF      =  00000C 
    FHSE    =  7A1200     |     FHSI    =  F42400     |     FLASH_BA=  008000 
    FLASH_CR=  00505A     |     FLASH_CR=  000002     |     FLASH_CR=  000000 
    FLASH_CR=  000003     |     FLASH_CR=  000001     |     FLASH_CR=  00505B 
    FLASH_CR=  000005     |     FLASH_CR=  000004     |     FLASH_CR=  000007 
    FLASH_CR=  000000     |     FLASH_CR=  000006     |     FLASH_DU=  005064 
    FLASH_DU=  0000AE     |     FLASH_DU=  000056     |     FLASH_EN=  027FFF 
    FLASH_FP=  00505D     |     FLASH_FP=  000000     |     FLASH_FP=  000001 
    FLASH_FP=  000002     |     FLASH_FP=  000003     |     FLASH_FP=  000004 
    FLASH_FP=  000005     |     FLASH_IA=  00505F     |     FLASH_IA=  000003 
    FLASH_IA=  000002     |     FLASH_IA=  000006     |     FLASH_IA=  000001 
    FLASH_IA=  000000     |     FLASH_NC=  00505C     |     FLASH_NF=  00505E 
    FLASH_NF=  000000     |     FLASH_NF=  000001     |     FLASH_NF=  000002 
    FLASH_NF=  000003     |     FLASH_NF=  000004     |     FLASH_NF=  000005 
    FLASH_PU=  005062     |     FLASH_PU=  000056     |     FLASH_PU=  0000AE 
    FLASH_SI=  020000     |     FLASH_WS=  00480D     |     FLSI    =  01F400 
    GPIO_BAS=  005000     |     GPIO_CR1=  000003     |     GPIO_CR2=  000004 
    GPIO_DDR=  000002     |     GPIO_IDR=  000001     |     GPIO_ODR=  000000 
    GPIO_SIZ=  000005     |     HSECNT  =  004809     |     I2C_CCRH=  00521C 
    I2C_CCRH=  000080     |     I2C_CCRH=  0000C0     |     I2C_CCRH=  000080 
    I2C_CCRH=  000000     |     I2C_CCRH=  000001     |     I2C_CCRH=  000000 
    I2C_CCRL=  00521B     |     I2C_CCRL=  00001A     |     I2C_CCRL=  000002 
    I2C_CCRL=  00000D     |     I2C_CCRL=  000050     |     I2C_CCRL=  000090 
    I2C_CCRL=  0000A0     |     I2C_CR1 =  005210     |     I2C_CR1_=  000006 
    I2C_CR1_=  000007     |     I2C_CR1_=  000000     |     I2C_CR2 =  005211 
    I2C_CR2_=  000002     |     I2C_CR2_=  000003     |     I2C_CR2_=  000000 
    I2C_CR2_=  000001     |     I2C_CR2_=  000007     |     I2C_DR  =  005216 
    I2C_FREQ=  005212     |     I2C_ITR =  00521A     |     I2C_ITR_=  000002 
    I2C_ITR_=  000000     |     I2C_ITR_=  000001     |     I2C_OARH=  005214 
    I2C_OARH=  000001     |     I2C_OARH=  000002     |     I2C_OARH=  000006 
    I2C_OARH=  000007     |     I2C_OARL=  005213     |     I2C_OARL=  000000 
    I2C_OAR_=  000813     |     I2C_OAR_=  000009     |     I2C_PECR=  00521E 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]

Symbol Table

    I2C_READ=  000001     |     I2C_SR1 =  005217     |     I2C_SR1_=  000003 
    I2C_SR1_=  000001     |     I2C_SR1_=  000002     |     I2C_SR1_=  000006 
    I2C_SR1_=  000000     |     I2C_SR1_=  000004     |     I2C_SR1_=  000007 
    I2C_SR2 =  005218     |     I2C_SR2_=  000002     |     I2C_SR2_=  000001 
    I2C_SR2_=  000000     |     I2C_SR2_=  000003     |     I2C_SR2_=  000005 
    I2C_SR3 =  005219     |     I2C_SR3_=  000001     |     I2C_SR3_=  000007 
    I2C_SR3_=  000004     |     I2C_SR3_=  000000     |     I2C_SR3_=  000002 
    I2C_TRIS=  00521D     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000005     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_WRIT=  000000     |     IDX_ERR_=  000003 
    IDX_ERR_=  000002     |     IDX_ERR_=  000004     |     IDX_ERR_=  000001 
    IDX_ERR_=  000000     |     INPUT_DI=  000000     |     INPUT_EI=  000001 
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
    LED2_MAS=  000020     |     LED2_POR=  00500A     |     LEN     =  000002 
    LOCAL_SI=  000007     |     N1      =  000001     |     N2      =  000004 
    NAFR    =  004804     |     NCLKOPT =  004808     |     NFLASH_W=  00480E 
    NHSECNT =  00480A     |     NL      =  00000A     |     NOPT1   =  004802 
    NOPT2   =  004804     |     NOPT3   =  004806     |     NOPT4   =  004808 
    NOPT5   =  00480A     |     NOPT6   =  00480C     |     NOPT7   =  00480E 
    NOPTBL  =  00487F     |     NUBC    =  004802     |     NWDGOPT =  004806 
    NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF 
    NWDGOPT_=  FFFFFFFE     |   5 NonHandl   000000 R   |     OP      =  000007 
    OPT0    =  004800     |     OPT1    =  004801     |     OPT2    =  004803 
    OPT3    =  004805     |     OPT4    =  004807     |     OPT5    =  004809 
    OPT6    =  00480B     |     OPT7    =  00480D     |     OPTBL   =  00487E 
    OPTION_B=  004800     |     OPTION_E=  00487F     |     OUTPUT_F=  000001 
    OUTPUT_O=  000000     |     OUTPUT_P=  000001     |     OUTPUT_S=  000000 
    PA      =  000000     |     PAD_SIZE=  000050     |     PA_BASE =  005000 
    PA_CR1  =  005003     |     PA_CR2  =  005004     |     PA_DDR  =  005002 
    PA_IDR  =  005001     |     PA_ODR  =  005000     |     PB      =  000005 
    PB_BASE =  005005     |     PB_CR1  =  005008     |     PB_CR2  =  005009 
    PB_DDR  =  005007     |     PB_IDR  =  005006     |     PB_ODR  =  005005 
    PC      =  00000A     |     PC_BASE =  00500A     |     PC_CR1  =  00500D 
    PC_CR2  =  00500E     |     PC_DDR  =  00500C     |     PC_IDR  =  00500B 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]

Symbol Table

    PC_ODR  =  00500A     |     PD      =  00000F     |     PD_BASE =  00500F 
    PD_CR1  =  005012     |     PD_CR2  =  005013     |     PD_DDR  =  005011 
    PD_IDR  =  005010     |     PD_ODR  =  00500F     |     PE      =  000014 
    PE_BASE =  005014     |     PE_CR1  =  005017     |     PE_CR2  =  005018 
    PE_DDR  =  005016     |     PE_IDR  =  005015     |     PE_ODR  =  005014 
    PF      =  000019     |     PF_BASE =  005019     |     PF_CR1  =  00501C 
    PF_CR2  =  00501D     |     PF_DDR  =  00501B     |     PF_IDR  =  00501A 
    PF_ODR  =  005019     |     PG      =  00001E     |     PG_BASE =  00501E 
    PG_CR1  =  005021     |     PG_CR2  =  005022     |     PG_DDR  =  005020 
    PG_IDR  =  00501F     |     PG_ODR  =  00501E     |     PH_BASE =  005023 
    PH_CR1  =  005026     |     PH_CR2  =  005027     |     PH_DDR  =  005025 
    PH_IDR  =  005024     |     PH_ODR  =  005023     |     PI_BASE =  005028 
    PI_CR1  =  00502B     |     PI_CR2  =  00502C     |     PI_DDR  =  00502A 
    PI_IDR  =  005029     |     PI_ODR  =  005028     |     PREV    =  000001 
    RAM_BASE=  000000     |     RAM_END =  0017FF     |     RAM_SIZE=  001800 
    ROP     =  004800     |     RST_SR  =  0050B3     |     RXCHAR  =  000001 
    SFR_BASE=  005000     |     SFR_END =  0057FF     |     SIGN    =  000005 
    SPACE   =  000020     |     SPI_CR1 =  005200     |     SPI_CR2 =  005201 
    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_TXCR=  005207 
    STACK_SI=  000100     |     SWIM_CSR=  007F80     |     TAB     =  000009 
    TIB_SIZE=  000050     |     TIM1_ARR=  005262     |     TIM1_ARR=  005263 
    TIM1_BKR=  00526D     |     TIM1_CCE=  00525C     |     TIM1_CCE=  00525D 
    TIM1_CCM=  005258     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  005259     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  00525A     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCM=  00525B     |     TIM1_CCM=  000000     |     TIM1_CCM=  000001 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000003 
    TIM1_CCM=  000007     |     TIM1_CCM=  000002     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000003 
    TIM1_CCR=  005265     |     TIM1_CCR=  005266     |     TIM1_CCR=  005267 
    TIM1_CCR=  005268     |     TIM1_CCR=  005269     |     TIM1_CCR=  00526A 
    TIM1_CCR=  00526B     |     TIM1_CCR=  00526C     |     TIM1_CNT=  00525E 
    TIM1_CNT=  00525F     |     TIM1_CR1=  005250     |     TIM1_CR2=  005251 
    TIM1_CR2=  000000     |     TIM1_CR2=  000002     |     TIM1_CR2=  000004 
    TIM1_CR2=  000005     |     TIM1_CR2=  000006     |     TIM1_DTR=  00526E 
    TIM1_EGR=  005257     |     TIM1_EGR=  000007     |     TIM1_EGR=  000001 
    TIM1_EGR=  000002     |     TIM1_EGR=  000003     |     TIM1_EGR=  000004 
    TIM1_EGR=  000005     |     TIM1_EGR=  000006     |     TIM1_EGR=  000000 
    TIM1_ETR=  005253     |     TIM1_ETR=  000006     |     TIM1_ETR=  000000 
    TIM1_ETR=  000001     |     TIM1_ETR=  000002     |     TIM1_ETR=  000003 
    TIM1_ETR=  000007     |     TIM1_ETR=  000004     |     TIM1_ETR=  000005 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]

Symbol Table

    TIM1_IER=  005254     |     TIM1_IER=  000007     |     TIM1_IER=  000001 
    TIM1_IER=  000002     |     TIM1_IER=  000003     |     TIM1_IER=  000004 
    TIM1_IER=  000005     |     TIM1_IER=  000006     |     TIM1_IER=  000000 
    TIM1_OIS=  00526F     |     TIM1_PSC=  005260     |     TIM1_PSC=  005261 
    TIM1_RCR=  005264     |     TIM1_SMC=  005252     |     TIM1_SMC=  000007 
    TIM1_SMC=  000000     |     TIM1_SMC=  000001     |     TIM1_SMC=  000002 
    TIM1_SMC=  000004     |     TIM1_SMC=  000005     |     TIM1_SMC=  000006 
    TIM1_SR1=  005255     |     TIM1_SR1=  000007     |     TIM1_SR1=  000001 
    TIM1_SR1=  000002     |     TIM1_SR1=  000003     |     TIM1_SR1=  000004 
    TIM1_SR1=  000005     |     TIM1_SR1=  000006     |     TIM1_SR1=  000000 
    TIM1_SR2=  005256     |     TIM1_SR2=  000001     |     TIM1_SR2=  000002 
    TIM1_SR2=  000003     |     TIM1_SR2=  000004     |     TIM2_ARR=  00530D 
    TIM2_ARR=  00530E     |     TIM2_CCE=  005308     |     TIM2_CCE=  005309 
    TIM2_CCM=  005305     |     TIM2_CCM=  005306     |     TIM2_CCM=  005307 
    TIM2_CCR=  00530F     |     TIM2_CCR=  005310     |     TIM2_CCR=  005311 
    TIM2_CCR=  005312     |     TIM2_CCR=  005313     |     TIM2_CCR=  005314 
    TIM2_CNT=  00530A     |     TIM2_CNT=  00530B     |     TIM2_CR1=  005300 
    TIM2_EGR=  005304     |     TIM2_IER=  005301     |     TIM2_PSC=  00530C 
    TIM2_SR1=  005302     |     TIM2_SR2=  005303     |     TIM3_ARR=  00532B 
    TIM3_ARR=  00532C     |     TIM3_CCE=  005327     |     TIM3_CCE=  000000 
    TIM3_CCE=  000001     |     TIM3_CCE=  000004     |     TIM3_CCE=  000005 
    TIM3_CCE=  000000     |     TIM3_CCE=  000001     |     TIM3_CCM=  005325 
    TIM3_CCM=  005326     |     TIM3_CCM=  000000     |     TIM3_CCM=  000004 
    TIM3_CCM=  000003     |     TIM3_CCR=  00532D     |     TIM3_CCR=  00532E 
    TIM3_CCR=  00532F     |     TIM3_CCR=  005330     |     TIM3_CNT=  005328 
    TIM3_CNT=  005329     |     TIM3_CR1=  005320     |     TIM3_CR1=  000007 
    TIM3_CR1=  000000     |     TIM3_CR1=  000003     |     TIM3_CR1=  000001 
    TIM3_CR1=  000002     |     TIM3_EGR=  005324     |     TIM3_IER=  005321 
    TIM3_PSC=  00532A     |     TIM3_SR1=  005322     |     TIM3_SR2=  005323 
    TIM4_ARR=  005346     |     TIM4_CNT=  005344     |     TIM4_CR1=  005340 
    TIM4_CR1=  000007     |     TIM4_CR1=  000000     |     TIM4_CR1=  000003 
    TIM4_CR1=  000001     |     TIM4_CR1=  000002     |     TIM4_EGR=  005343 
    TIM4_EGR=  000000     |     TIM4_IER=  005341     |     TIM4_IER=  000000 
    TIM4_PSC=  005345     |     TIM4_PSC=  000000     |     TIM4_PSC=  000007 
    TIM4_PSC=  000004     |     TIM4_PSC=  000001     |     TIM4_PSC=  000005 
    TIM4_PSC=  000002     |     TIM4_PSC=  000006     |     TIM4_PSC=  000003 
    TIM4_PSC=  000000     |     TIM4_PSC=  000001     |     TIM4_PSC=  000002 
    TIM4_SR =  005342     |     TIM4_SR_=  000000     |     TIM_CR1_=  000007 
    TIM_CR1_=  000000     |     TIM_CR1_=  000006     |     TIM_CR1_=  000005 
    TIM_CR1_=  000004     |     TIM_CR1_=  000003     |     TIM_CR1_=  000001 
    TIM_CR1_=  000002     |     U24     =  000001     |     UART1   =  000000 
    UART1_BA=  005230     |     UART1_BR=  005232     |     UART1_BR=  005233 
    UART1_CR=  005234     |     UART1_CR=  005235     |     UART1_CR=  005236 
    UART1_CR=  005237     |     UART1_CR=  005238     |     UART1_DR=  005231 
    UART1_GT=  005239     |     UART1_PO=  000000     |     UART1_PS=  00523A 
    UART1_RX=  000004     |     UART1_SR=  005230     |     UART1_TX=  000005 
    UART3   =  000001     |     UART3_BA=  005240     |     UART3_BR=  005242 
    UART3_BR=  005243     |     UART3_CR=  005244     |     UART3_CR=  005245 
    UART3_CR=  005246     |     UART3_CR=  005247     |     UART3_CR=  004249 
    UART3_DR=  005241     |     UART3_PO=  00000F     |     UART3_RX=  000006 
    UART3_SR=  005240     |     UART3_TX=  000005     |     UART_BRR=  000002 
    UART_BRR=  000003     |     UART_CR1=  000004     |     UART_CR1=  000004 
    UART_CR1=  000002     |     UART_CR1=  000000     |     UART_CR1=  000001 
    UART_CR1=  000007     |     UART_CR1=  000006     |     UART_CR1=  000005 
    UART_CR1=  000003     |     UART_CR2=  000005     |     UART_CR2=  000004 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]

Symbol Table

    UART_CR2=  000002     |     UART_CR2=  000005     |     UART_CR2=  000001 
    UART_CR2=  000000     |     UART_CR2=  000006     |     UART_CR2=  000003 
    UART_CR2=  000007     |     UART_CR3=  000006     |     UART_CR3=  000003 
    UART_CR3=  000001     |     UART_CR3=  000002     |     UART_CR3=  000000 
    UART_CR3=  000006     |     UART_CR3=  000004     |     UART_CR3=  000005 
    UART_CR4=  000007     |     UART_CR4=  000000     |     UART_CR4=  000001 
    UART_CR4=  000002     |     UART_CR4=  000003     |     UART_CR4=  000004 
    UART_CR4=  000006     |     UART_CR4=  000005     |     UART_CR5=  000008 
    UART_CR5=  000003     |     UART_CR5=  000001     |     UART_CR5=  000002 
    UART_CR5=  000004     |     UART_CR5=  000005     |     UART_CR6=  000009 
    UART_CR6=  000004     |     UART_CR6=  000007     |     UART_CR6=  000001 
    UART_CR6=  000002     |     UART_CR6=  000000     |     UART_CR6=  000005 
    UART_DR =  000001     |     UART_GTR=  000009     |     UART_PSC=  00000A 
    UART_SR =  000000     |     UART_SR_=  000001     |     UART_SR_=  000004 
    UART_SR_=  000002     |     UART_SR_=  000003     |     UART_SR_=  000000 
    UART_SR_=  000005     |     UART_SR_=  000006     |     UART_SR_=  000007 
    UBC     =  004801     |     USR_BTN_=  000004     |     USR_BTN_=  000010 
    USR_BTN_=  005015     |     VT      =  00000B     |     WDGOPT  =  004805 
    WDGOPT_I=  000002     |     WDGOPT_L=  000003     |     WDGOPT_W=  000000 
    WDGOPT_W=  000001     |     WWDG_CR =  0050D1     |     WWDG_WR =  0050D2 
  1 acc16      000001 R   |   1 acc24      000000 R   |   1 acc8       000002 R
  5 accept_c   0001E2 R   |     add24      ****** GX  |   5 add24_te   00047D R
  5 atoi       0000E6 GR  |   5 atoi_exi   000155 R   |   5 cancel     00021E R
  5 clock_in   00002F R   |   5 convert_   00028B R   |   1 count      000055 R
  5 del_back   0001CB R   |   5 del_line   0001B4 R   |     div24_8u   ****** GX
  5 div24_8u   0004A5 R   |     div24s     ****** GX  |   5 div24s_t   0004B1 R
  5 div_fata   000001 R   |   5 erreur_a   00040E R   |   5 erreur_d   000435 R
  5 erreur_m   000428 R   |   5 erreur_n   000441 R   |   5 erreur_s   00041C R
  5 eval       000357 R   |   5 eval_exi   00038D R   |   5 exceptio   000022 R
  5 getc       000168 R   |   1 in         000054 R   |   1 in.w       000053 R
  5 init0      00031E R   |   5 itoa       00003E GR  |   5 itoa_loo   00006A R
  5 msg_erre   000404 R   |     mul24_8u   ****** GX  |   5 mul24_8u   00048F R
    mul24s     ****** GX  |   5 mul24s_t   00049B R   |     neg24      ****** GX
  5 neg24_te   0004BB R   |   5 new_line   0000DC R   |   5 next_wor   0002CA GR
  5 number     000317 GR  |   1 pad        000003 R   |   5 parse_qu   000259 R
  5 presenta   000330 R   |   5 print_ar   0000C8 R   |   5 print_er   0003ED R
  5 print_in   0000B1 R   |   5 putc       00015A R   |   5 puts       000170 R
  5 readln     00017E GR  |   5 readln_l   000188 R   |   5 readln_q   000228 R
  5 readln_q   00022D R   |   5 repl       00033B R   |   5 reprint    0001F7 R
  5 scan       000247 R   |   5 skip       000235 R   |     sub24      ****** GX
  5 sub24_te   000486 R   |   5 test_add   000390 R   |   5 test_div   0003C9 R
  5 test_mul   0003B6 R   |   5 test_ok    00044D R   |   5 test_sub   0003A3 R
  1 tib        000056 R   |   5 to_lower   000300 GR  |   5 to_upper   00030B GR
    uart_del   ****** GX  |     uart_get   ****** GX  |     uart_ini   ****** GX
    uart_put   ****** GX  |     uart_put   ****** GX  |   5 whatisit   00045C R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size     A6   flags    0
   2 SSEG       size      0   flags    8
   3 SSEG0      size    100   flags    8
   4 HOME       size     80   flags    0
   5 CODE       size    4C4   flags    0

