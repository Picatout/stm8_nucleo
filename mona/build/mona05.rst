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
                                     18 
                                     19 ;  MONA   MONitor written in Assembly
                                     20 	.module MONA 
                                     21     .optsdcc -mstm8
                                     22 ;	.nlist
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     23 	.include "../inc/nucleo_8s208.inc"
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
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; NUCLEO-8S208RB board specific definitions
                                     20 ; Date: 2019/10/29
                                     21 ; author: Jacques Deschênes, copyright 2018,2019
                                     22 ; licence: GPLv3
                                     23 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     24 
                                     25 ; mcu on board is stm8s208rbt6
                                     26 
                                     27 ; crystal on board is 8Mhz
                           7A1200    28 FHSE = 8000000
                                     29 
                                     30 ; LED2 is user LED
                                     31 ; connected to PC5 via Q2 -> 2N7002 MOSFET
                           00500A    32 LED2_PORT = 0x500a ;port C  ODR
                           000005    33 LED2_BIT = 5
                           000020    34 LED2_MASK = (1<<LED2_BIT) ;bit 5 mask
                                     35 
                                     36 ; B1 on schematic is user button
                                     37 ; connected to PE4
                                     38 ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                           005015    39 USR_BTN_PORT = 0x5015 ; port E  IDR
                           000004    40 USR_BTN_BIT = 4
                           000010    41 USR_BTN_MASK = (1<<USR_BTN_BIT) ;bit 4 mask
                                     42 
                                     43 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                     24 	.include "../inc/stm8s208.inc"
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
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; 2019/10/18
                                     20 ; STM8S208RB µC registers map
                                     21 ; sdas source file
                                     22 ; author: Jacques Deschênes, copyright 2018,2019
                                     23 ; licence: GPLv3
                                     24 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     25 	.module stm8s208rb
                                     26 
                                     27 ;;;;;;;;;;;;
                                     28 ; bits
                                     29 ;;;;;;;;;;;;
                           000000    30  BIT0 = 0
                           000001    31  BIT1 = 1
                           000002    32  BIT2 = 2
                           000003    33  BIT3 = 3
                           000004    34  BIT4 = 4
                           000005    35  BIT5 = 5
                           000006    36  BIT6 = 6
                           000007    37  BIT7 = 7
                                     38  	
                                     39 ;;;;;;;;;;;;
                                     40 ; bits masks
                                     41 ;;;;;;;;;;;;
                           000001    42  B0_MASK = (1<<0)
                           000002    43  B1_MASK = (1<<1)
                           000004    44  B2_MASK = (1<<2)
                           000008    45  B3_MASK = (1<<3)
                           000010    46  B4_MASK = (1<<4)
                           000020    47  B5_MASK = (1<<5)
                           000040    48  B6_MASK = (1<<6)
                           000080    49  B7_MASK = (1<<7)
                                     50 
                                     51 ; HSI oscillator frequency 16Mhz
                           F42400    52  FHSI = 16000000
                                     53 ; LSI oscillator frequency 128Khz
                           01F400    54  FLSI = 128000 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                                     55 
                                     56 ; controller memory regions
                           001800    57  RAM_SIZE = (0x1800) ; 6KB 
                           000800    58  EEPROM_SIZE = (0x800) ; 2KB
                                     59 ; STM8S208RB have 128K flash
                           020000    60  FLASH_SIZE = (0x20000)
                                     61 
                           000000    62  RAM_BASE = (0)
                           0017FF    63  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    64  EEPROM_BASE = (0x4000)
                           0047FF    65  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    66  SFR_BASE = (0x5000)
                           0057FF    67  SFR_END = (0x57FF)
                           006000    68  BOOT_ROM_BASE = (0x6000)
                           007FFF    69  BOOT_ROM_END = (0x7fff)
                           008000    70  FLASH_BASE = (0x8000)
                           027FFF    71  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
                           004800    72  OPTION_BASE = (0x4800)
                           00487F    73  OPTION_END = (0x487F)
                           0048CD    74  DEVID_BASE = (0x48CD)
                           0048D8    75  DEVID_END = (0x48D8)
                           007F00    76  DEBUG_BASE = (0X7F00)
                           007FFF    77  DEBUG_END = (0X7FFF)
                                     78 
                                     79 ; options bytes
                                     80 ; this one can be programmed only from SWIM  (ICP)
                           004800    81  OPT0  = (0x4800)
                                     82 ; these can be programmed at runtime (IAP)
                           004801    83  OPT1  = (0x4801)
                           004802    84  NOPT1  = (0x4802)
                           004803    85  OPT2  = (0x4803)
                           004804    86  NOPT2  = (0x4804)
                           004805    87  OPT3  = (0x4805)
                           004806    88  NOPT3  = (0x4806)
                           004807    89  OPT4  = (0x4807)
                           004808    90  NOPT4  = (0x4808)
                           004809    91  OPT5  = (0x4809)
                           00480A    92  NOPT5  = (0x480A)
                           00480B    93  OPT6  = (0x480B)
                           00480C    94  NOPT6 = (0x480C)
                           00480D    95  OPT7 = (0x480D)
                           00480E    96  NOPT7 = (0x480E)
                           00487E    97  OPTBL  = (0x487E)
                           00487F    98  NOPTBL  = (0x487F)
                                     99 ; option registers usage
                                    100 ; read out protection, value 0xAA enable ROP
                           004800   101  ROP = OPT0  
                                    102 ; user boot code, {0..0x3e} 512 bytes row
                           004801   103  UBC = OPT1
                           004802   104  NUBC = NOPT1
                                    105 ; alternate function register
                           004803   106  AFR = OPT2
                           004804   107  NAFR = NOPT2
                                    108 ; miscelinous options
                           004805   109  WDGOPT = OPT3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



                           004806   110  NWDGOPT = NOPT3
                                    111 ; clock options
                           004807   112  CLKOPT = OPT4
                           004808   113  NCLKOPT = NOPT4
                                    114 ; HSE clock startup delay
                           004809   115  HSECNT = OPT5
                           00480A   116  NHSECNT = NOPT5
                                    117 ; flash wait state
                           00480D   118 FLASH_WS = OPT7
                           00480E   119 NFLASH_WS = NOPT7
                                    120 
                                    121 ; watchdog options bits
                           000003   122   WDGOPT_LSIEN   =  BIT3
                           000002   123   WDGOPT_IWDG_HW =  BIT2
                           000001   124   WDGOPT_WWDG_HW =  BIT1
                           000000   125   WDGOPT_WWDG_HALT = BIT0
                                    126 ; NWDGOPT bits
                           FFFFFFFC   127   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   128   NWDGOPT_IWDG_HW  = ~BIT2
                           FFFFFFFE   129   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   130   NWDGOPT_WWDG_HALT = ~BIT0
                                    131 
                                    132 ; CLKOPT bits
                           000003   133  CLKOPT_EXT_CLK  = BIT3
                           000002   134  CLKOPT_CKAWUSEL = BIT2
                           000001   135  CLKOPT_PRS_C1   = BIT1
                           000000   136  CLKOPT_PRS_C0   = BIT0
                                    137 
                                    138 ; AFR option, remapable functions
                           000007   139  AFR7_BEEP    = BIT7
                           000006   140  AFR6_I2C     = BIT6
                           000005   141  AFR5_TIM1    = BIT5
                           000004   142  AFR4_TIM1    = BIT4
                           000003   143  AFR3_TIM1    = BIT3
                           000002   144  AFR2_CCO     = BIT2
                           000001   145  AFR1_TIM2    = BIT1
                           000000   146  AFR0_ADC     = BIT0
                                    147 
                                    148 ; device ID = (read only)
                           0048CD   149  DEVID_XL  = (0x48CD)
                           0048CE   150  DEVID_XH  = (0x48CE)
                           0048CF   151  DEVID_YL  = (0x48CF)
                           0048D0   152  DEVID_YH  = (0x48D0)
                           0048D1   153  DEVID_WAF  = (0x48D1)
                           0048D2   154  DEVID_LOT0  = (0x48D2)
                           0048D3   155  DEVID_LOT1  = (0x48D3)
                           0048D4   156  DEVID_LOT2  = (0x48D4)
                           0048D5   157  DEVID_LOT3  = (0x48D5)
                           0048D6   158  DEVID_LOT4  = (0x48D6)
                           0048D7   159  DEVID_LOT5  = (0x48D7)
                           0048D8   160  DEVID_LOT6  = (0x48D8)
                                    161 
                                    162 
                           005000   163 GPIO_BASE = (0x5000)
                           000005   164 GPIO_SIZE = (5)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                                    165 ; PORTS SFR OFFSET
                           000000   166 PA = 0
                           000005   167 PB = 5
                           00000A   168 PC = 10
                           00000F   169 PD = 15
                           000014   170 PE = 20
                           000019   171 PF = 25
                           00001E   172 PG = 30
                           000023   173 PH = 35 
                           000028   174 PI = 40 
                                    175 
                                    176 ; GPIO
                                    177 ; gpio register offset to base
                           000000   178  GPIO_ODR = 0
                           000001   179  GPIO_IDR = 1
                           000002   180  GPIO_DDR = 2
                           000003   181  GPIO_CR1 = 3
                           000004   182  GPIO_CR2 = 4
                                    183 
                                    184 ; port A
                           005000   185  PA_BASE = (0X5000)
                           005000   186  PA_ODR  = (0x5000)
                           005001   187  PA_IDR  = (0x5001)
                           005002   188  PA_DDR  = (0x5002)
                           005003   189  PA_CR1  = (0x5003)
                           005004   190  PA_CR2  = (0x5004)
                                    191 ; port B
                           005005   192  PB_BASE = (0X5005)
                           005005   193  PB_ODR  = (0x5005)
                           005006   194  PB_IDR  = (0x5006)
                           005007   195  PB_DDR  = (0x5007)
                           005008   196  PB_CR1  = (0x5008)
                           005009   197  PB_CR2  = (0x5009)
                                    198 ; port C
                           00500A   199  PC_BASE = (0X500A)
                           00500A   200  PC_ODR  = (0x500A)
                           00500B   201  PC_IDR  = (0x500B)
                           00500C   202  PC_DDR  = (0x500C)
                           00500D   203  PC_CR1  = (0x500D)
                           00500E   204  PC_CR2  = (0x500E)
                                    205 ; port D
                           00500F   206  PD_BASE = (0X500F)
                           00500F   207  PD_ODR  = (0x500F)
                           005010   208  PD_IDR  = (0x5010)
                           005011   209  PD_DDR  = (0x5011)
                           005012   210  PD_CR1  = (0x5012)
                           005013   211  PD_CR2  = (0x5013)
                                    212 ; port E
                           005014   213  PE_BASE = (0X5014)
                           005014   214  PE_ODR  = (0x5014)
                           005015   215  PE_IDR  = (0x5015)
                           005016   216  PE_DDR  = (0x5016)
                           005017   217  PE_CR1  = (0x5017)
                           005018   218  PE_CR2  = (0x5018)
                                    219 ; port F
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



                           005019   220  PF_BASE = (0X5019)
                           005019   221  PF_ODR  = (0x5019)
                           00501A   222  PF_IDR  = (0x501A)
                           00501B   223  PF_DDR  = (0x501B)
                           00501C   224  PF_CR1  = (0x501C)
                           00501D   225  PF_CR2  = (0x501D)
                                    226 ; port G
                           00501E   227  PG_BASE = (0X501E)
                           00501E   228  PG_ODR  = (0x501E)
                           00501F   229  PG_IDR  = (0x501F)
                           005020   230  PG_DDR  = (0x5020)
                           005021   231  PG_CR1  = (0x5021)
                           005022   232  PG_CR2  = (0x5022)
                                    233 ; port H not present on LQFP48/LQFP64 package
                           005023   234  PH_BASE = (0X5023)
                           005023   235  PH_ODR  = (0x5023)
                           005024   236  PH_IDR  = (0x5024)
                           005025   237  PH_DDR  = (0x5025)
                           005026   238  PH_CR1  = (0x5026)
                           005027   239  PH_CR2  = (0x5027)
                                    240 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                           005028   241  PI_BASE = (0X5028)
                           005028   242  PI_ODR  = (0x5028)
                           005029   243  PI_IDR  = (0x5029)
                           00502A   244  PI_DDR  = (0x502a)
                           00502B   245  PI_CR1  = (0x502b)
                           00502C   246  PI_CR2  = (0x502c)
                                    247 
                                    248 ; input modes CR1
                           000000   249  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   250  INPUT_PULLUP = (1)
                                    251 ; output mode CR1
                           000000   252  OUTPUT_OD = (0) ; open drain
                           000001   253  OUTPUT_PP = (1) ; push pull
                                    254 ; input modes CR2
                           000000   255  INPUT_DI = (0)
                           000001   256  INPUT_EI = (1)
                                    257 ; output speed CR2
                           000000   258  OUTPUT_SLOW = (0)
                           000001   259  OUTPUT_FAST = (1)
                                    260 
                                    261 
                                    262 ; Flash memory
                           00505A   263  FLASH_CR1  = (0x505A)
                           00505B   264  FLASH_CR2  = (0x505B)
                           00505C   265  FLASH_NCR2  = (0x505C)
                           00505D   266  FLASH_FPR  = (0x505D)
                           00505E   267  FLASH_NFPR  = (0x505E)
                           00505F   268  FLASH_IAPSR  = (0x505F)
                           005062   269  FLASH_PUKR  = (0x5062)
                           005064   270  FLASH_DUKR  = (0x5064)
                                    271 ; data memory unlock keys
                           0000AE   272  FLASH_DUKR_KEY1 = (0xae)
                           000056   273  FLASH_DUKR_KEY2 = (0x56)
                                    274 ; flash memory unlock keys
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                           000056   275  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   276  FLASH_PUKR_KEY2 = (0xae)
                                    277 ; FLASH_CR1 bits
                           000003   278  FLASH_CR1_HALT = BIT3
                           000002   279  FLASH_CR1_AHALT = BIT2
                           000001   280  FLASH_CR1_IE = BIT1
                           000000   281  FLASH_CR1_FIX = BIT0
                                    282 ; FLASH_CR2 bits
                           000007   283  FLASH_CR2_OPT = BIT7
                           000006   284  FLASH_CR2_WPRG = BIT6
                           000005   285  FLASH_CR2_ERASE = BIT5
                           000004   286  FLASH_CR2_FPRG = BIT4
                           000000   287  FLASH_CR2_PRG = BIT0
                                    288 ; FLASH_FPR bits
                           000005   289  FLASH_FPR_WPB5 = BIT5
                           000004   290  FLASH_FPR_WPB4 = BIT4
                           000003   291  FLASH_FPR_WPB3 = BIT3
                           000002   292  FLASH_FPR_WPB2 = BIT2
                           000001   293  FLASH_FPR_WPB1 = BIT1
                           000000   294  FLASH_FPR_WPB0 = BIT0
                                    295 ; FLASH_NFPR bits
                           000005   296  FLASH_NFPR_NWPB5 = BIT5
                           000004   297  FLASH_NFPR_NWPB4 = BIT4
                           000003   298  FLASH_NFPR_NWPB3 = BIT3
                           000002   299  FLASH_NFPR_NWPB2 = BIT2
                           000001   300  FLASH_NFPR_NWPB1 = BIT1
                           000000   301  FLASH_NFPR_NWPB0 = BIT0
                                    302 ; FLASH_IAPSR bits
                           000006   303  FLASH_IAPSR_HVOFF = BIT6
                           000003   304  FLASH_IAPSR_DUL = BIT3
                           000002   305  FLASH_IAPSR_EOP = BIT2
                           000001   306  FLASH_IAPSR_PUL = BIT1
                           000000   307  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    308 
                                    309 ; Interrupt control
                           0050A0   310  EXTI_CR1  = (0x50A0)
                           0050A1   311  EXTI_CR2  = (0x50A1)
                                    312 
                                    313 ; Reset Status
                           0050B3   314  RST_SR  = (0x50B3)
                                    315 
                                    316 ; Clock Registers
                           0050C0   317  CLK_ICKR  = (0x50c0)
                           0050C1   318  CLK_ECKR  = (0x50c1)
                           0050C3   319  CLK_CMSR  = (0x50C3)
                           0050C4   320  CLK_SWR  = (0x50C4)
                           0050C5   321  CLK_SWCR  = (0x50C5)
                           0050C6   322  CLK_CKDIVR  = (0x50C6)
                           0050C7   323  CLK_PCKENR1  = (0x50C7)
                           0050C8   324  CLK_CSSR  = (0x50C8)
                           0050C9   325  CLK_CCOR  = (0x50C9)
                           0050CA   326  CLK_PCKENR2  = (0x50CA)
                           0050CC   327  CLK_HSITRIMR  = (0x50CC)
                           0050CD   328  CLK_SWIMCCR  = (0x50CD)
                                    329 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                                    330 ; Peripherals clock gating
                                    331 ; CLK_PCKENR1 
                           000007   332  CLK_PCKENR1_TIM1 = (7)
                           000006   333  CLK_PCKENR1_TIM3 = (6)
                           000005   334  CLK_PCKENR1_TIM2 = (5)
                           000004   335  CLK_PCKENR1_TIM4 = (4)
                           000003   336  CLK_PCKENR1_UART3 = (3)
                           000002   337  CLK_PCKENR1_UART1 = (2)
                           000001   338  CLK_PCKENR1_SPI = (1)
                           000000   339  CLK_PCKENR1_I2C = (0)
                                    340 ; CLK_PCKENR2
                           000007   341  CLK_PCKENR2_CAN = (7)
                           000003   342  CLK_PCKENR2_ADC = (3)
                           000002   343  CLK_PCKENR2_AWU = (2)
                                    344 
                                    345 ; Clock bits
                           000005   346  CLK_ICKR_REGAH = (5)
                           000004   347  CLK_ICKR_LSIRDY = (4)
                           000003   348  CLK_ICKR_LSIEN = (3)
                           000002   349  CLK_ICKR_FHW = (2)
                           000001   350  CLK_ICKR_HSIRDY = (1)
                           000000   351  CLK_ICKR_HSIEN = (0)
                                    352 
                           000001   353  CLK_ECKR_HSERDY = (1)
                           000000   354  CLK_ECKR_HSEEN = (0)
                                    355 ; clock source
                           0000E1   356  CLK_SWR_HSI = 0xE1
                           0000D2   357  CLK_SWR_LSI = 0xD2
                           0000B4   358  CLK_SWR_HSE = 0xB4
                                    359 
                           000003   360  CLK_SWCR_SWIF = (3)
                           000002   361  CLK_SWCR_SWIEN = (2)
                           000001   362  CLK_SWCR_SWEN = (1)
                           000000   363  CLK_SWCR_SWBSY = (0)
                                    364 
                           000004   365  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   366  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   367  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   368  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   369  CLK_CKDIVR_CPUDIV0 = (0)
                                    370 
                                    371 ; Watchdog
                           0050D1   372  WWDG_CR  = (0x50D1)
                           0050D2   373  WWDG_WR  = (0x50D2)
                           0050E0   374  IWDG_KR  = (0x50E0)
                           0050E1   375  IWDG_PR  = (0x50E1)
                           0050E2   376  IWDG_RLR  = (0x50E2)
                           0050F0   377  AWU_CSR1  = (0x50F0)
                           0050F1   378  AWU_APR  = (0x50F1)
                           0050F2   379  AWU_TBR  = (0x50F2)
                                    380 
                                    381 ; Beeper
                                    382 ; beeper output is alternate function AFR7 on PD4
                                    383 ; connected to CN9-6
                           0050F3   384  BEEP_CSR  = (0x50F3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                           00000F   385  BEEP_PORT = PD
                           000004   386  BEEP_BIT = 4
                           000010   387  BEEP_MASK = B4_MASK
                                    388 
                                    389 ; SPI
                           005200   390  SPI_CR1  = (0x5200)
                           005201   391  SPI_CR2  = (0x5201)
                           005202   392  SPI_ICR  = (0x5202)
                           005203   393  SPI_SR  = (0x5203)
                           005204   394  SPI_DR  = (0x5204)
                           005205   395  SPI_CRCPR  = (0x5205)
                           005206   396  SPI_RXCRCR  = (0x5206)
                           005207   397  SPI_TXCRCR  = (0x5207)
                                    398 
                                    399 ; I2C
                           005210   400  I2C_CR1  = (0x5210)
                           005211   401  I2C_CR2  = (0x5211)
                           005212   402  I2C_FREQR  = (0x5212)
                           005213   403  I2C_OARL  = (0x5213)
                           005214   404  I2C_OARH  = (0x5214)
                           005216   405  I2C_DR  = (0x5216)
                           005217   406  I2C_SR1  = (0x5217)
                           005218   407  I2C_SR2  = (0x5218)
                           005219   408  I2C_SR3  = (0x5219)
                           00521A   409  I2C_ITR  = (0x521A)
                           00521B   410  I2C_CCRL  = (0x521B)
                           00521C   411  I2C_CCRH  = (0x521C)
                           00521D   412  I2C_TRISER  = (0x521D)
                           00521E   413  I2C_PECR  = (0x521E)
                                    414 
                           000007   415  I2C_CR1_NOSTRETCH = (7)
                           000006   416  I2C_CR1_ENGC = (6)
                           000000   417  I2C_CR1_PE = (0)
                                    418 
                           000007   419  I2C_CR2_SWRST = (7)
                           000003   420  I2C_CR2_POS = (3)
                           000002   421  I2C_CR2_ACK = (2)
                           000001   422  I2C_CR2_STOP = (1)
                           000000   423  I2C_CR2_START = (0)
                                    424 
                           000000   425  I2C_OARL_ADD0 = (0)
                                    426 
                           000009   427  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   428  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    429 
                           000007   430  I2C_OARH_ADDMODE = (7)
                           000006   431  I2C_OARH_ADDCONF = (6)
                           000002   432  I2C_OARH_ADD9 = (2)
                           000001   433  I2C_OARH_ADD8 = (1)
                                    434 
                           000007   435  I2C_SR1_TXE = (7)
                           000006   436  I2C_SR1_RXNE = (6)
                           000004   437  I2C_SR1_STOPF = (4)
                           000003   438  I2C_SR1_ADD10 = (3)
                           000002   439  I2C_SR1_BTF = (2)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                           000001   440  I2C_SR1_ADDR = (1)
                           000000   441  I2C_SR1_SB = (0)
                                    442 
                           000005   443  I2C_SR2_WUFH = (5)
                           000003   444  I2C_SR2_OVR = (3)
                           000002   445  I2C_SR2_AF = (2)
                           000001   446  I2C_SR2_ARLO = (1)
                           000000   447  I2C_SR2_BERR = (0)
                                    448 
                           000007   449  I2C_SR3_DUALF = (7)
                           000004   450  I2C_SR3_GENCALL = (4)
                           000002   451  I2C_SR3_TRA = (2)
                           000001   452  I2C_SR3_BUSY = (1)
                           000000   453  I2C_SR3_MSL = (0)
                                    454 
                           000002   455  I2C_ITR_ITBUFEN = (2)
                           000001   456  I2C_ITR_ITEVTEN = (1)
                           000000   457  I2C_ITR_ITERREN = (0)
                                    458 
                                    459 ; Precalculated values, all in KHz
                           000080   460  I2C_CCRH_16MHZ_FAST_400 = 0x80
                           00000D   461  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    462 ;
                                    463 ; Fast I2C mode max rise time = 300ns
                                    464 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    465 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    466 
                           000005   467  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    468 
                           0000C0   469  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   470  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   471  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    472 
                           000080   473  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   474  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   475  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    476 
                           000000   477  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   478  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    479 ;
                                    480 ; Standard I2C mode max rise time = 1000ns
                                    481 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    482 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    483 
                           000011   484  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    485 
                           000000   486  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   487  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   488  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    489 
                           000001   490  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   491  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   492  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    493 
                           000001   494  I2C_READ = 1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



                           000000   495  I2C_WRITE = 0
                                    496 
                                    497 ; baudrate constant for brr_value table access
                                    498 ; to be used by uart_init 
                           000000   499 B2400=0
                           000001   500 B4800=1
                           000002   501 B9600=2
                           000003   502 B19200=3
                           000004   503 B38400=4
                           000005   504 B57600=5
                           000006   505 B115200=6
                           000007   506 B230400=7
                           000008   507 B460800=8
                           000009   508 B921600=9
                                    509 
                                    510 ; UART registers offset from
                                    511 ; base address 
                           000000   512 UART_SR=0
                           000001   513 UART_DR=1
                           000002   514 UART_BRR1=2
                           000003   515 UART_BRR2=3
                           000004   516 UART_CR1=4
                           000005   517 UART_CR2=5
                           000006   518 UART_CR3=6
                           000007   519 UART_CR4=7
                           000008   520 UART_CR5=8
                           000009   521 UART_CR6=9
                           000009   522 UART_GTR=9
                           00000A   523 UART_PSCR=10
                                    524 
                                    525 ; uart identifier
                                    526 ; to be used by uart_init
                           000000   527  UART1 = 0
                           000001   528  UART3 = 1
                                    529 
                                    530 ; pins used by uart 
                           000005   531 UART1_TX_PIN=BIT5
                           000004   532 UART1_RX_PIN=BIT4
                           000005   533 UART3_TX_PIN=BIT5
                           000006   534 UART3_RX_PIN=BIT6
                                    535 ; uart port base address 
                           000000   536 UART1_PORT=PA 
                           00000F   537 UART3_PORT=PD
                                    538 
                                    539 ; UART1 
                           005230   540  UART1_BASE  = (0x5230)
                           005230   541  UART1_SR    = (0x5230)
                           005231   542  UART1_DR    = (0x5231)
                           005232   543  UART1_BRR1  = (0x5232)
                           005233   544  UART1_BRR2  = (0x5233)
                           005234   545  UART1_CR1   = (0x5234)
                           005235   546  UART1_CR2   = (0x5235)
                           005236   547  UART1_CR3   = (0x5236)
                           005237   548  UART1_CR4   = (0x5237)
                           005238   549  UART1_CR5   = (0x5238)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



                           005239   550  UART1_GTR   = (0x5239)
                           00523A   551  UART1_PSCR  = (0x523A)
                                    552 
                                    553 ; UART3
                           005240   554  UART3_BASE  = (0x5240)
                           005240   555  UART3_SR    = (0x5240)
                           005241   556  UART3_DR    = (0x5241)
                           005242   557  UART3_BRR1  = (0x5242)
                           005243   558  UART3_BRR2  = (0x5243)
                           005244   559  UART3_CR1   = (0x5244)
                           005245   560  UART3_CR2   = (0x5245)
                           005246   561  UART3_CR3   = (0x5246)
                           005247   562  UART3_CR4   = (0x5247)
                           004249   563  UART3_CR6   = (0x4249)
                                    564 
                                    565 ; UART Status Register bits
                           000007   566  UART_SR_TXE = (7)
                           000006   567  UART_SR_TC = (6)
                           000005   568  UART_SR_RXNE = (5)
                           000004   569  UART_SR_IDLE = (4)
                           000003   570  UART_SR_OR = (3)
                           000002   571  UART_SR_NF = (2)
                           000001   572  UART_SR_FE = (1)
                           000000   573  UART_SR_PE = (0)
                                    574 
                                    575 ; Uart Control Register bits
                           000007   576  UART_CR1_R8 = (7)
                           000006   577  UART_CR1_T8 = (6)
                           000005   578  UART_CR1_UARTD = (5)
                           000004   579  UART_CR1_M = (4)
                           000003   580  UART_CR1_WAKE = (3)
                           000002   581  UART_CR1_PCEN = (2)
                           000001   582  UART_CR1_PS = (1)
                           000000   583  UART_CR1_PIEN = (0)
                                    584 
                           000007   585  UART_CR2_TIEN = (7)
                           000006   586  UART_CR2_TCIEN = (6)
                           000005   587  UART_CR2_RIEN = (5)
                           000004   588  UART_CR2_ILIEN = (4)
                           000003   589  UART_CR2_TEN = (3)
                           000002   590  UART_CR2_REN = (2)
                           000001   591  UART_CR2_RWU = (1)
                           000000   592  UART_CR2_SBK = (0)
                                    593 
                           000006   594  UART_CR3_LINEN = (6)
                           000005   595  UART_CR3_STOP1 = (5)
                           000004   596  UART_CR3_STOP0 = (4)
                           000003   597  UART_CR3_CLKEN = (3)
                           000002   598  UART_CR3_CPOL = (2)
                           000001   599  UART_CR3_CPHA = (1)
                           000000   600  UART_CR3_LBCL = (0)
                                    601 
                           000006   602  UART_CR4_LBDIEN = (6)
                           000005   603  UART_CR4_LBDL = (5)
                           000004   604  UART_CR4_LBDF = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                           000003   605  UART_CR4_ADD3 = (3)
                           000002   606  UART_CR4_ADD2 = (2)
                           000001   607  UART_CR4_ADD1 = (1)
                           000000   608  UART_CR4_ADD0 = (0)
                                    609 
                           000005   610  UART_CR5_SCEN = (5)
                           000004   611  UART_CR5_NACK = (4)
                           000003   612  UART_CR5_HDSEL = (3)
                           000002   613  UART_CR5_IRLP = (2)
                           000001   614  UART_CR5_IREN = (1)
                                    615 ; LIN mode config register
                           000007   616  UART_CR6_LDUM = (7)
                           000005   617  UART_CR6_LSLV = (5)
                           000004   618  UART_CR6_LASE = (4)
                           000002   619  UART_CR6_LHDIEN = (2) 
                           000001   620  UART_CR6_LHDF = (1)
                           000000   621  UART_CR6_LSF = (0)
                                    622 
                                    623 ; TIMERS
                                    624 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   625  TIM1_CR1  = (0x5250)
                           005251   626  TIM1_CR2  = (0x5251)
                           005252   627  TIM1_SMCR  = (0x5252)
                           005253   628  TIM1_ETR  = (0x5253)
                           005254   629  TIM1_IER  = (0x5254)
                           005255   630  TIM1_SR1  = (0x5255)
                           005256   631  TIM1_SR2  = (0x5256)
                           005257   632  TIM1_EGR  = (0x5257)
                           005258   633  TIM1_CCMR1  = (0x5258)
                           005259   634  TIM1_CCMR2  = (0x5259)
                           00525A   635  TIM1_CCMR3  = (0x525A)
                           00525B   636  TIM1_CCMR4  = (0x525B)
                           00525C   637  TIM1_CCER1  = (0x525C)
                           00525D   638  TIM1_CCER2  = (0x525D)
                           00525E   639  TIM1_CNTRH  = (0x525E)
                           00525F   640  TIM1_CNTRL  = (0x525F)
                           005260   641  TIM1_PSCRH  = (0x5260)
                           005261   642  TIM1_PSCRL  = (0x5261)
                           005262   643  TIM1_ARRH  = (0x5262)
                           005263   644  TIM1_ARRL  = (0x5263)
                           005264   645  TIM1_RCR  = (0x5264)
                           005265   646  TIM1_CCR1H  = (0x5265)
                           005266   647  TIM1_CCR1L  = (0x5266)
                           005267   648  TIM1_CCR2H  = (0x5267)
                           005268   649  TIM1_CCR2L  = (0x5268)
                           005269   650  TIM1_CCR3H  = (0x5269)
                           00526A   651  TIM1_CCR3L  = (0x526A)
                           00526B   652  TIM1_CCR4H  = (0x526B)
                           00526C   653  TIM1_CCR4L  = (0x526C)
                           00526D   654  TIM1_BKR  = (0x526D)
                           00526E   655  TIM1_DTR  = (0x526E)
                           00526F   656  TIM1_OISR  = (0x526F)
                                    657 
                                    658 ; Timer Control Register bits
                           000007   659  TIM_CR1_ARPE = (7)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



                           000006   660  TIM_CR1_CMSH = (6)
                           000005   661  TIM_CR1_CMSL = (5)
                           000004   662  TIM_CR1_DIR = (4)
                           000003   663  TIM_CR1_OPM = (3)
                           000002   664  TIM_CR1_URS = (2)
                           000001   665  TIM_CR1_UDIS = (1)
                           000000   666  TIM_CR1_CEN = (0)
                                    667 
                           000006   668  TIM1_CR2_MMS2 = (6)
                           000005   669  TIM1_CR2_MMS1 = (5)
                           000004   670  TIM1_CR2_MMS0 = (4)
                           000002   671  TIM1_CR2_COMS = (2)
                           000000   672  TIM1_CR2_CCPC = (0)
                                    673 
                                    674 ; Timer Slave Mode Control bits
                           000007   675  TIM1_SMCR_MSM = (7)
                           000006   676  TIM1_SMCR_TS2 = (6)
                           000005   677  TIM1_SMCR_TS1 = (5)
                           000004   678  TIM1_SMCR_TS0 = (4)
                           000002   679  TIM1_SMCR_SMS2 = (2)
                           000001   680  TIM1_SMCR_SMS1 = (1)
                           000000   681  TIM1_SMCR_SMS0 = (0)
                                    682 
                                    683 ; Timer External Trigger Enable bits
                           000007   684  TIM1_ETR_ETP = (7)
                           000006   685  TIM1_ETR_ECE = (6)
                           000005   686  TIM1_ETR_ETPS1 = (5)
                           000004   687  TIM1_ETR_ETPS0 = (4)
                           000003   688  TIM1_ETR_ETF3 = (3)
                           000002   689  TIM1_ETR_ETF2 = (2)
                           000001   690  TIM1_ETR_ETF1 = (1)
                           000000   691  TIM1_ETR_ETF0 = (0)
                                    692 
                                    693 ; Timer Interrupt Enable bits
                           000007   694  TIM1_IER_BIE = (7)
                           000006   695  TIM1_IER_TIE = (6)
                           000005   696  TIM1_IER_COMIE = (5)
                           000004   697  TIM1_IER_CC4IE = (4)
                           000003   698  TIM1_IER_CC3IE = (3)
                           000002   699  TIM1_IER_CC2IE = (2)
                           000001   700  TIM1_IER_CC1IE = (1)
                           000000   701  TIM1_IER_UIE = (0)
                                    702 
                                    703 ; Timer Status Register bits
                           000007   704  TIM1_SR1_BIF = (7)
                           000006   705  TIM1_SR1_TIF = (6)
                           000005   706  TIM1_SR1_COMIF = (5)
                           000004   707  TIM1_SR1_CC4IF = (4)
                           000003   708  TIM1_SR1_CC3IF = (3)
                           000002   709  TIM1_SR1_CC2IF = (2)
                           000001   710  TIM1_SR1_CC1IF = (1)
                           000000   711  TIM1_SR1_UIF = (0)
                                    712 
                           000004   713  TIM1_SR2_CC4OF = (4)
                           000003   714  TIM1_SR2_CC3OF = (3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



                           000002   715  TIM1_SR2_CC2OF = (2)
                           000001   716  TIM1_SR2_CC1OF = (1)
                                    717 
                                    718 ; Timer Event Generation Register bits
                           000007   719  TIM1_EGR_BG = (7)
                           000006   720  TIM1_EGR_TG = (6)
                           000005   721  TIM1_EGR_COMG = (5)
                           000004   722  TIM1_EGR_CC4G = (4)
                           000003   723  TIM1_EGR_CC3G = (3)
                           000002   724  TIM1_EGR_CC2G = (2)
                           000001   725  TIM1_EGR_CC1G = (1)
                           000000   726  TIM1_EGR_UG = (0)
                                    727 
                                    728 ; Capture/Compare Mode Register 1 - channel configured in output
                           000007   729  TIM1_CCMR1_OC1CE = (7)
                           000006   730  TIM1_CCMR1_OC1M2 = (6)
                           000005   731  TIM1_CCMR1_OC1M1 = (5)
                           000004   732  TIM1_CCMR1_OC1M0 = (4)
                           000003   733  TIM1_CCMR1_OC1PE = (3)
                           000002   734  TIM1_CCMR1_OC1FE = (2)
                           000001   735  TIM1_CCMR1_CC1S1 = (1)
                           000000   736  TIM1_CCMR1_CC1S0 = (0)
                                    737 
                                    738 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   739  TIM1_CCMR1_IC1F3 = (7)
                           000006   740  TIM1_CCMR1_IC1F2 = (6)
                           000005   741  TIM1_CCMR1_IC1F1 = (5)
                           000004   742  TIM1_CCMR1_IC1F0 = (4)
                           000003   743  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   744  TIM1_CCMR1_IC1PSC0 = (2)
                                    745 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   746  TIM1_CCMR1_CC1S0 = (0)
                                    747 
                                    748 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   749  TIM1_CCMR2_OC2CE = (7)
                           000006   750  TIM1_CCMR2_OC2M2 = (6)
                           000005   751  TIM1_CCMR2_OC2M1 = (5)
                           000004   752  TIM1_CCMR2_OC2M0 = (4)
                           000003   753  TIM1_CCMR2_OC2PE = (3)
                           000002   754  TIM1_CCMR2_OC2FE = (2)
                           000001   755  TIM1_CCMR2_CC2S1 = (1)
                           000000   756  TIM1_CCMR2_CC2S0 = (0)
                                    757 
                                    758 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   759  TIM1_CCMR2_IC2F3 = (7)
                           000006   760  TIM1_CCMR2_IC2F2 = (6)
                           000005   761  TIM1_CCMR2_IC2F1 = (5)
                           000004   762  TIM1_CCMR2_IC2F0 = (4)
                           000003   763  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   764  TIM1_CCMR2_IC2PSC0 = (2)
                                    765 ;  TIM1_CCMR2_CC2S1 = (1)
                           000000   766  TIM1_CCMR2_CC2S0 = (0)
                                    767 
                                    768 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   769  TIM1_CCMR3_OC3CE = (7)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



                           000006   770  TIM1_CCMR3_OC3M2 = (6)
                           000005   771  TIM1_CCMR3_OC3M1 = (5)
                           000004   772  TIM1_CCMR3_OC3M0 = (4)
                           000003   773  TIM1_CCMR3_OC3PE = (3)
                           000002   774  TIM1_CCMR3_OC3FE = (2)
                           000001   775  TIM1_CCMR3_CC3S1 = (1)
                           000000   776  TIM1_CCMR3_CC3S0 = (0)
                                    777 
                                    778 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   779  TIM1_CCMR3_IC3F3 = (7)
                           000006   780  TIM1_CCMR3_IC3F2 = (6)
                           000005   781  TIM1_CCMR3_IC3F1 = (5)
                           000004   782  TIM1_CCMR3_IC3F0 = (4)
                           000003   783  TIM1_CCMR3_IC3PSC1 = (3)
                           000002   784  TIM1_CCMR3_IC3PSC0 = (2)
                                    785 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   786  TIM1_CCMR3_CC3S0 = (0)
                                    787 
                                    788 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   789  TIM1_CCMR4_OC4CE = (7)
                           000006   790  TIM1_CCMR4_OC4M2 = (6)
                           000005   791  TIM1_CCMR4_OC4M1 = (5)
                           000004   792  TIM1_CCMR4_OC4M0 = (4)
                           000003   793  TIM1_CCMR4_OC4PE = (3)
                           000002   794  TIM1_CCMR4_OC4FE = (2)
                           000001   795  TIM1_CCMR4_CC4S1 = (1)
                           000000   796  TIM1_CCMR4_CC4S0 = (0)
                                    797 
                                    798 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   799  TIM1_CCMR4_IC4F3 = (7)
                           000006   800  TIM1_CCMR4_IC4F2 = (6)
                           000005   801  TIM1_CCMR4_IC4F1 = (5)
                           000004   802  TIM1_CCMR4_IC4F0 = (4)
                           000003   803  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   804  TIM1_CCMR4_IC4PSC0 = (2)
                                    805 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   806  TIM1_CCMR4_CC4S0 = (0)
                                    807 
                                    808 ; Timer 2 - 16-bit timer
                           005300   809  TIM2_CR1  = (0x5300)
                           005301   810  TIM2_IER  = (0x5301)
                           005302   811  TIM2_SR1  = (0x5302)
                           005303   812  TIM2_SR2  = (0x5303)
                           005304   813  TIM2_EGR  = (0x5304)
                           005305   814  TIM2_CCMR1  = (0x5305)
                           005306   815  TIM2_CCMR2  = (0x5306)
                           005307   816  TIM2_CCMR3  = (0x5307)
                           005308   817  TIM2_CCER1  = (0x5308)
                           005309   818  TIM2_CCER2  = (0x5309)
                           00530A   819  TIM2_CNTRH  = (0x530A)
                           00530B   820  TIM2_CNTRL  = (0x530B)
                           00530C   821  TIM2_PSCR  = (0x530C)
                           00530D   822  TIM2_ARRH  = (0x530D)
                           00530E   823  TIM2_ARRL  = (0x530E)
                           00530F   824  TIM2_CCR1H  = (0x530F)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



                           005310   825  TIM2_CCR1L  = (0x5310)
                           005311   826  TIM2_CCR2H  = (0x5311)
                           005312   827  TIM2_CCR2L  = (0x5312)
                           005313   828  TIM2_CCR3H  = (0x5313)
                           005314   829  TIM2_CCR3L  = (0x5314)
                                    830 
                                    831 ; Timer 3
                           005320   832  TIM3_CR1  = (0x5320)
                           005321   833  TIM3_IER  = (0x5321)
                           005322   834  TIM3_SR1  = (0x5322)
                           005323   835  TIM3_SR2  = (0x5323)
                           005324   836  TIM3_EGR  = (0x5324)
                           005325   837  TIM3_CCMR1  = (0x5325)
                           005326   838  TIM3_CCMR2  = (0x5326)
                           005327   839  TIM3_CCER1  = (0x5327)
                           005328   840  TIM3_CNTRH  = (0x5328)
                           005329   841  TIM3_CNTRL  = (0x5329)
                           00532A   842  TIM3_PSCR  = (0x532A)
                           00532B   843  TIM3_ARRH  = (0x532B)
                           00532C   844  TIM3_ARRL  = (0x532C)
                           00532D   845  TIM3_CCR1H  = (0x532D)
                           00532E   846  TIM3_CCR1L  = (0x532E)
                           00532F   847  TIM3_CCR2H  = (0x532F)
                           005330   848  TIM3_CCR2L  = (0x5330)
                                    849 
                                    850 ; TIM3_CR1  fields
                           000000   851  TIM3_CR1_CEN = (0)
                           000001   852  TIM3_CR1_UDIS = (1)
                           000002   853  TIM3_CR1_URS = (2)
                           000003   854  TIM3_CR1_OPM = (3)
                           000007   855  TIM3_CR1_ARPE = (7)
                                    856 ; TIM3_CCR2  fields
                           000000   857  TIM3_CCMR2_CC2S_POS = (0)
                           000003   858  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   859  TIM3_CCMR2_OC2M_POS = (4)  
                                    860 ; TIM3_CCER1 fields
                           000000   861  TIM3_CCER1_CC1E = (0)
                           000001   862  TIM3_CCER1_CC1P = (1)
                           000004   863  TIM3_CCER1_CC2E = (4)
                           000005   864  TIM3_CCER1_CC2P = (5)
                                    865 ; TIM3_CCER2 fields
                           000000   866  TIM3_CCER2_CC3E = (0)
                           000001   867  TIM3_CCER2_CC3P = (1)
                                    868 
                                    869 ; Timer 4
                           005340   870  TIM4_CR1  = (0x5340)
                           005341   871  TIM4_IER  = (0x5341)
                           005342   872  TIM4_SR  = (0x5342)
                           005343   873  TIM4_EGR  = (0x5343)
                           005344   874  TIM4_CNTR  = (0x5344)
                           005345   875  TIM4_PSCR  = (0x5345)
                           005346   876  TIM4_ARR  = (0x5346)
                                    877 
                                    878 ; Timer 4 bitmasks
                                    879 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                           000007   880  TIM4_CR1_ARPE = (7)
                           000003   881  TIM4_CR1_OPM = (3)
                           000002   882  TIM4_CR1_URS = (2)
                           000001   883  TIM4_CR1_UDIS = (1)
                           000000   884  TIM4_CR1_CEN = (0)
                                    885 
                           000000   886  TIM4_IER_UIE = (0)
                                    887 
                           000000   888  TIM4_SR_UIF = (0)
                                    889 
                           000000   890  TIM4_EGR_UG = (0)
                                    891 
                           000002   892  TIM4_PSCR_PSC2 = (2)
                           000001   893  TIM4_PSCR_PSC1 = (1)
                           000000   894  TIM4_PSCR_PSC0 = (0)
                                    895 
                           000000   896  TIM4_PSCR_1 = 0
                           000001   897  TIM4_PSCR_2 = 1
                           000002   898  TIM4_PSCR_4 = 2
                           000003   899  TIM4_PSCR_8 = 3
                           000004   900  TIM4_PSCR_16 = 4
                           000005   901  TIM4_PSCR_32 = 5
                           000006   902  TIM4_PSCR_64 = 6
                           000007   903  TIM4_PSCR_128 = 7
                                    904 
                                    905 ; ADC2
                           005400   906  ADC_CSR  = (0x5400)
                           005401   907  ADC_CR1  = (0x5401)
                           005402   908  ADC_CR2  = (0x5402)
                           005403   909  ADC_CR3  = (0x5403)
                           005404   910  ADC_DRH  = (0x5404)
                           005405   911  ADC_DRL  = (0x5405)
                           005406   912  ADC_TDRH  = (0x5406)
                           005407   913  ADC_TDRL  = (0x5407)
                                    914  
                                    915 ; ADC bitmasks
                                    916 
                           000007   917  ADC_CSR_EOC = (7)
                           000006   918  ADC_CSR_AWD = (6)
                           000005   919  ADC_CSR_EOCIE = (5)
                           000004   920  ADC_CSR_AWDIE = (4)
                           000003   921  ADC_CSR_CH3 = (3)
                           000002   922  ADC_CSR_CH2 = (2)
                           000001   923  ADC_CSR_CH1 = (1)
                           000000   924  ADC_CSR_CH0 = (0)
                                    925 
                           000006   926  ADC_CR1_SPSEL2 = (6)
                           000005   927  ADC_CR1_SPSEL1 = (5)
                           000004   928  ADC_CR1_SPSEL0 = (4)
                           000001   929  ADC_CR1_CONT = (1)
                           000000   930  ADC_CR1_ADON = (0)
                                    931 
                           000006   932  ADC_CR2_EXTTRIG = (6)
                           000005   933  ADC_CR2_EXTSEL1 = (5)
                           000004   934  ADC_CR2_EXTSEL0 = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                           000003   935  ADC_CR2_ALIGN = (3)
                           000001   936  ADC_CR2_SCAN = (1)
                                    937 
                           000007   938  ADC_CR3_DBUF = (7)
                           000006   939  ADC_CR3_DRH = (6)
                                    940 
                                    941 ; beCAN
                           005420   942  CAN_MCR = (0x5420)
                           005421   943  CAN_MSR = (0x5421)
                           005422   944  CAN_TSR = (0x5422)
                           005423   945  CAN_TPR = (0x5423)
                           005424   946  CAN_RFR = (0x5424)
                           005425   947  CAN_IER = (0x5425)
                           005426   948  CAN_DGR = (0x5426)
                           005427   949  CAN_FPSR = (0x5427)
                           005428   950  CAN_P0 = (0x5428)
                           005429   951  CAN_P1 = (0x5429)
                           00542A   952  CAN_P2 = (0x542A)
                           00542B   953  CAN_P3 = (0x542B)
                           00542C   954  CAN_P4 = (0x542C)
                           00542D   955  CAN_P5 = (0x542D)
                           00542E   956  CAN_P6 = (0x542E)
                           00542F   957  CAN_P7 = (0x542F)
                           005430   958  CAN_P8 = (0x5430)
                           005431   959  CAN_P9 = (0x5431)
                           005432   960  CAN_PA = (0x5432)
                           005433   961  CAN_PB = (0x5433)
                           005434   962  CAN_PC = (0x5434)
                           005435   963  CAN_PD = (0x5435)
                           005436   964  CAN_PE = (0x5436)
                           005437   965  CAN_PF = (0x5437)
                                    966 
                                    967 
                                    968 ; CPU
                           007F00   969  CPU_A  = (0x7F00)
                           007F01   970  CPU_PCE  = (0x7F01)
                           007F02   971  CPU_PCH  = (0x7F02)
                           007F03   972  CPU_PCL  = (0x7F03)
                           007F04   973  CPU_XH  = (0x7F04)
                           007F05   974  CPU_XL  = (0x7F05)
                           007F06   975  CPU_YH  = (0x7F06)
                           007F07   976  CPU_YL  = (0x7F07)
                           007F08   977  CPU_SPH  = (0x7F08)
                           007F09   978  CPU_SPL   = (0x7F09)
                           007F0A   979  CPU_CCR   = (0x7F0A)
                                    980 
                                    981 ; global configuration register
                           007F60   982  CFG_GCR   = (0x7F60)
                           000001   983  CFG_GCR_AL = 1
                           000000   984  CFG_GCR_SWIM = 0
                                    985 
                                    986 ; interrupt control registers
                           007F70   987  ITC_SPR1   = (0x7F70)
                           007F71   988  ITC_SPR2   = (0x7F71)
                           007F72   989  ITC_SPR3   = (0x7F72)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                           007F73   990  ITC_SPR4   = (0x7F73)
                           007F74   991  ITC_SPR5   = (0x7F74)
                           007F75   992  ITC_SPR6   = (0x7F75)
                           007F76   993  ITC_SPR7   = (0x7F76)
                           007F77   994  ITC_SPR8   = (0x7F77)
                                    995 
                                    996 ; SWIM, control and status register
                           007F80   997  SWIM_CSR   = (0x7F80)
                                    998 ; debug registers
                           007F90   999  DM_BK1RE   = (0x7F90)
                           007F91  1000  DM_BK1RH   = (0x7F91)
                           007F92  1001  DM_BK1RL   = (0x7F92)
                           007F93  1002  DM_BK2RE   = (0x7F93)
                           007F94  1003  DM_BK2RH   = (0x7F94)
                           007F95  1004  DM_BK2RL   = (0x7F95)
                           007F96  1005  DM_CR1   = (0x7F96)
                           007F97  1006  DM_CR2   = (0x7F97)
                           007F98  1007  DM_CSR1   = (0x7F98)
                           007F99  1008  DM_CSR2   = (0x7F99)
                           007F9A  1009  DM_ENFCTR   = (0x7F9A)
                                   1010 
                                   1011 ; Interrupt Numbers
                           000000  1012  INT_TLI = 0
                           000001  1013  INT_AWU = 1
                           000002  1014  INT_CLK = 2
                           000003  1015  INT_EXTI0 = 3
                           000004  1016  INT_EXTI1 = 4
                           000005  1017  INT_EXTI2 = 5
                           000006  1018  INT_EXTI3 = 6
                           000007  1019  INT_EXTI4 = 7
                           000008  1020  INT_CAN_RX = 8
                           000009  1021  INT_CAN_TX = 9
                           00000A  1022  INT_SPI = 10
                           00000B  1023  INT_TIM1_OVF = 11
                           00000C  1024  INT_TIM1_CCM = 12
                           00000D  1025  INT_TIM2_OVF = 13
                           00000E  1026  INT_TIM2_CCM = 14
                           00000F  1027  INT_TIM3_OVF = 15
                           000010  1028  INT_TIM3_CCM = 16
                           000011  1029  INT_UART1_TX_COMPLETED = 17
                           000012  1030  INT_AUART1_RX_FULL = 18
                           000013  1031  INT_I2C = 19
                           000014  1032  INT_UART3_TX_COMPLETED = 20
                           000015  1033  INT_UART3_RX_FULL = 21
                           000016  1034  INT_ADC2 = 22
                           000017  1035  INT_TIM4_OVF = 23
                           000018  1036  INT_FLASH = 24
                                   1037 
                                   1038 ; Interrupt Vectors
                           008000  1039  INT_VECTOR_RESET = 0x8000
                           008004  1040  INT_VECTOR_TRAP = 0x8004
                           008008  1041  INT_VECTOR_TLI = 0x8008
                           00800C  1042  INT_VECTOR_AWU = 0x800C
                           008010  1043  INT_VECTOR_CLK = 0x8010
                           008014  1044  INT_VECTOR_EXTI0 = 0x8014
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



                           008018  1045  INT_VECTOR_EXTI1 = 0x8018
                           00801C  1046  INT_VECTOR_EXTI2 = 0x801C
                           008020  1047  INT_VECTOR_EXTI3 = 0x8020
                           008024  1048  INT_VECTOR_EXTI4 = 0x8024
                           008028  1049  INT_VECTOR_CAN_RX = 0x8028
                           00802C  1050  INT_VECTOR_CAN_TX = 0x802c
                           008030  1051  INT_VECTOR_SPI = 0x8030
                           008034  1052  INT_VECTOR_TIM1_OVF = 0x8034
                           008038  1053  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C  1054  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1055  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1056  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1057  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1058  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1059  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1060  INT_VECTOR_I2C = 0x8054
                           008058  1061  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1062  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1063  INT_VECTOR_ADC2 = 0x8060
                           008064  1064  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1065  INT_VECTOR_FLASH = 0x8068
                                   1066 
                                   1067 ; Condition code register bits
                           000007  1068 CC_V = 7  ; overflow flag 
                           000005  1069 CC_I1= 5  ; interrupt bit 1
                           000004  1070 CC_H = 4  ; half carry 
                           000003  1071 CC_I0 = 3 ; interrupt bit 0
                           000002  1072 CC_N = 2 ;  negative flag 
                           000001  1073 CC_Z = 1 ;  zero flag  
                           000000  1074 CC_C = 0 ; carry bit 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



                                     25 	.include "../inc/ascii.inc"
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
                                     18 
                                     19 ;-------------------------------------------------------
                                     20 ;     ASCII control  values
                                     21 ;     CTRL_x   are VT100 keyboard values  
                                     22 ;-------------------------------------------------------
                           000001    23 		CTRL_A = 1
                           000002    24 		CTRL_B = 2
                           000003    25 		CTRL_C = 3
                           000004    26 		CTRL_D = 4
                           000005    27 		CTRL_E = 5
                           000006    28 		CTRL_F = 6
                                     29 
                           000007    30         BELL = 7    ; vt100 terminal generate a sound.
                           000007    31 		CTRL_G = 7
                                     32 
                           000008    33 		BSP = 8     ; back space 
                           000008    34 		CTRL_H = 8  
                                     35 
                           000009    36     	TAB = 9     ; horizontal tabulation
                           000009    37         CTRL_I = 9
                                     38 
                           00000A    39 		NL = 10     ; new line 
                           00000A    40         CTRL_J = 10 
                                     41 
                           00000B    42         VT = 11     ; vertical tabulation 
                           00000B    43 		CTRL_K = 11
                                     44 
                           00000C    45         FF = 12      ; new page
                           00000C    46 		CTRL_L = 12
                                     47 
                           00000D    48 		CR = 13      ; carriage return 
                           00000D    49 		CTRL_M = 13
                                     50 
                           00000E    51 		CTRL_N = 14
                           00000F    52 		CTRL_O = 15
                           000010    53 		CTRL_P = 16
                           000011    54 		CTRL_Q = 17
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



                           000012    55 		CTRL_R = 18
                           000013    56 		CTRL_S = 19
                           000014    57 		CTRL_T = 20
                           000015    58 		CTRL_U = 21
                           000016    59 		CTRL_V = 22
                           000017    60 		CTRL_W = 23
                           000018    61 		CTRL_X = 24
                           000019    62 		CTRL_Y = 25
                           00001A    63 		CTRL_Z = 26
                           00001B    64 		ESC = 27
                           000020    65 		SPACE = 32
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



                                     26 	.include "mona.inc"
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
                                     18 
                                     19 ;  MONA   MONitor written in Assembly
                                     20 	.module MONA 
                                     21     .optsdcc -mstm8
                                     22 ;	.nlist
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                                     23 	.include "../inc/nucleo_8s208.inc"
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
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; NUCLEO-8S208RB board specific definitions
                                     20 ; Date: 2019/10/29
                                     21 ; author: Jacques Deschênes, copyright 2018,2019
                                     22 ; licence: GPLv3
                                     23 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     24 
                                     25 ; mcu on board is stm8s208rbt6
                                     26 
                                     27 ; crystal on board is 8Mhz
                           7A1200    28 FHSE = 8000000
                                     29 
                                     30 ; LED2 is user LED
                                     31 ; connected to PC5 via Q2 -> 2N7002 MOSFET
                           00500A    32 LED2_PORT = 0x500a ;port C  ODR
                           000005    33 LED2_BIT = 5
                           000020    34 LED2_MASK = (1<<LED2_BIT) ;bit 5 mask
                                     35 
                                     36 ; B1 on schematic is user button
                                     37 ; connected to PE4
                                     38 ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                           005015    39 USR_BTN_PORT = 0x5015 ; port E  IDR
                           000004    40 USR_BTN_BIT = 4
                           000010    41 USR_BTN_MASK = (1<<USR_BTN_BIT) ;bit 4 mask
                                     42 
                                     43 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



                                     24 	.include "../inc/stm8s208.inc"
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
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; 2019/10/18
                                     20 ; STM8S208RB µC registers map
                                     21 ; sdas source file
                                     22 ; author: Jacques Deschênes, copyright 2018,2019
                                     23 ; licence: GPLv3
                                     24 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     25 	.module stm8s208rb
                                     26 
                                     27 ;;;;;;;;;;;;
                                     28 ; bits
                                     29 ;;;;;;;;;;;;
                           000000    30  BIT0 = 0
                           000001    31  BIT1 = 1
                           000002    32  BIT2 = 2
                           000003    33  BIT3 = 3
                           000004    34  BIT4 = 4
                           000005    35  BIT5 = 5
                           000006    36  BIT6 = 6
                           000007    37  BIT7 = 7
                                     38  	
                                     39 ;;;;;;;;;;;;
                                     40 ; bits masks
                                     41 ;;;;;;;;;;;;
                           000001    42  B0_MASK = (1<<0)
                           000002    43  B1_MASK = (1<<1)
                           000004    44  B2_MASK = (1<<2)
                           000008    45  B3_MASK = (1<<3)
                           000010    46  B4_MASK = (1<<4)
                           000020    47  B5_MASK = (1<<5)
                           000040    48  B6_MASK = (1<<6)
                           000080    49  B7_MASK = (1<<7)
                                     50 
                                     51 ; HSI oscillator frequency 16Mhz
                           F42400    52  FHSI = 16000000
                                     53 ; LSI oscillator frequency 128Khz
                           01F400    54  FLSI = 128000 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
Hexadecimal [24-Bits]



                                     55 
                                     56 ; controller memory regions
                           001800    57  RAM_SIZE = (0x1800) ; 6KB 
                           000800    58  EEPROM_SIZE = (0x800) ; 2KB
                                     59 ; STM8S208RB have 128K flash
                           020000    60  FLASH_SIZE = (0x20000)
                                     61 
                           000000    62  RAM_BASE = (0)
                           0017FF    63  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    64  EEPROM_BASE = (0x4000)
                           0047FF    65  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    66  SFR_BASE = (0x5000)
                           0057FF    67  SFR_END = (0x57FF)
                           006000    68  BOOT_ROM_BASE = (0x6000)
                           007FFF    69  BOOT_ROM_END = (0x7fff)
                           008000    70  FLASH_BASE = (0x8000)
                           027FFF    71  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
                           004800    72  OPTION_BASE = (0x4800)
                           00487F    73  OPTION_END = (0x487F)
                           0048CD    74  DEVID_BASE = (0x48CD)
                           0048D8    75  DEVID_END = (0x48D8)
                           007F00    76  DEBUG_BASE = (0X7F00)
                           007FFF    77  DEBUG_END = (0X7FFF)
                                     78 
                                     79 ; options bytes
                                     80 ; this one can be programmed only from SWIM  (ICP)
                           004800    81  OPT0  = (0x4800)
                                     82 ; these can be programmed at runtime (IAP)
                           004801    83  OPT1  = (0x4801)
                           004802    84  NOPT1  = (0x4802)
                           004803    85  OPT2  = (0x4803)
                           004804    86  NOPT2  = (0x4804)
                           004805    87  OPT3  = (0x4805)
                           004806    88  NOPT3  = (0x4806)
                           004807    89  OPT4  = (0x4807)
                           004808    90  NOPT4  = (0x4808)
                           004809    91  OPT5  = (0x4809)
                           00480A    92  NOPT5  = (0x480A)
                           00480B    93  OPT6  = (0x480B)
                           00480C    94  NOPT6 = (0x480C)
                           00480D    95  OPT7 = (0x480D)
                           00480E    96  NOPT7 = (0x480E)
                           00487E    97  OPTBL  = (0x487E)
                           00487F    98  NOPTBL  = (0x487F)
                                     99 ; option registers usage
                                    100 ; read out protection, value 0xAA enable ROP
                           004800   101  ROP = OPT0  
                                    102 ; user boot code, {0..0x3e} 512 bytes row
                           004801   103  UBC = OPT1
                           004802   104  NUBC = NOPT1
                                    105 ; alternate function register
                           004803   106  AFR = OPT2
                           004804   107  NAFR = NOPT2
                                    108 ; miscelinous options
                           004805   109  WDGOPT = OPT3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]



                           004806   110  NWDGOPT = NOPT3
                                    111 ; clock options
                           004807   112  CLKOPT = OPT4
                           004808   113  NCLKOPT = NOPT4
                                    114 ; HSE clock startup delay
                           004809   115  HSECNT = OPT5
                           00480A   116  NHSECNT = NOPT5
                                    117 ; flash wait state
                           00480D   118 FLASH_WS = OPT7
                           00480E   119 NFLASH_WS = NOPT7
                                    120 
                                    121 ; watchdog options bits
                           000003   122   WDGOPT_LSIEN   =  BIT3
                           000002   123   WDGOPT_IWDG_HW =  BIT2
                           000001   124   WDGOPT_WWDG_HW =  BIT1
                           000000   125   WDGOPT_WWDG_HALT = BIT0
                                    126 ; NWDGOPT bits
                           FFFFFFFC   127   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   128   NWDGOPT_IWDG_HW  = ~BIT2
                           FFFFFFFE   129   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   130   NWDGOPT_WWDG_HALT = ~BIT0
                                    131 
                                    132 ; CLKOPT bits
                           000003   133  CLKOPT_EXT_CLK  = BIT3
                           000002   134  CLKOPT_CKAWUSEL = BIT2
                           000001   135  CLKOPT_PRS_C1   = BIT1
                           000000   136  CLKOPT_PRS_C0   = BIT0
                                    137 
                                    138 ; AFR option, remapable functions
                           000007   139  AFR7_BEEP    = BIT7
                           000006   140  AFR6_I2C     = BIT6
                           000005   141  AFR5_TIM1    = BIT5
                           000004   142  AFR4_TIM1    = BIT4
                           000003   143  AFR3_TIM1    = BIT3
                           000002   144  AFR2_CCO     = BIT2
                           000001   145  AFR1_TIM2    = BIT1
                           000000   146  AFR0_ADC     = BIT0
                                    147 
                                    148 ; device ID = (read only)
                           0048CD   149  DEVID_XL  = (0x48CD)
                           0048CE   150  DEVID_XH  = (0x48CE)
                           0048CF   151  DEVID_YL  = (0x48CF)
                           0048D0   152  DEVID_YH  = (0x48D0)
                           0048D1   153  DEVID_WAF  = (0x48D1)
                           0048D2   154  DEVID_LOT0  = (0x48D2)
                           0048D3   155  DEVID_LOT1  = (0x48D3)
                           0048D4   156  DEVID_LOT2  = (0x48D4)
                           0048D5   157  DEVID_LOT3  = (0x48D5)
                           0048D6   158  DEVID_LOT4  = (0x48D6)
                           0048D7   159  DEVID_LOT5  = (0x48D7)
                           0048D8   160  DEVID_LOT6  = (0x48D8)
                                    161 
                                    162 
                           005000   163 GPIO_BASE = (0x5000)
                           000005   164 GPIO_SIZE = (5)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]



                                    165 ; PORTS SFR OFFSET
                           000000   166 PA = 0
                           000005   167 PB = 5
                           00000A   168 PC = 10
                           00000F   169 PD = 15
                           000014   170 PE = 20
                           000019   171 PF = 25
                           00001E   172 PG = 30
                           000023   173 PH = 35 
                           000028   174 PI = 40 
                                    175 
                                    176 ; GPIO
                                    177 ; gpio register offset to base
                           000000   178  GPIO_ODR = 0
                           000001   179  GPIO_IDR = 1
                           000002   180  GPIO_DDR = 2
                           000003   181  GPIO_CR1 = 3
                           000004   182  GPIO_CR2 = 4
                                    183 
                                    184 ; port A
                           005000   185  PA_BASE = (0X5000)
                           005000   186  PA_ODR  = (0x5000)
                           005001   187  PA_IDR  = (0x5001)
                           005002   188  PA_DDR  = (0x5002)
                           005003   189  PA_CR1  = (0x5003)
                           005004   190  PA_CR2  = (0x5004)
                                    191 ; port B
                           005005   192  PB_BASE = (0X5005)
                           005005   193  PB_ODR  = (0x5005)
                           005006   194  PB_IDR  = (0x5006)
                           005007   195  PB_DDR  = (0x5007)
                           005008   196  PB_CR1  = (0x5008)
                           005009   197  PB_CR2  = (0x5009)
                                    198 ; port C
                           00500A   199  PC_BASE = (0X500A)
                           00500A   200  PC_ODR  = (0x500A)
                           00500B   201  PC_IDR  = (0x500B)
                           00500C   202  PC_DDR  = (0x500C)
                           00500D   203  PC_CR1  = (0x500D)
                           00500E   204  PC_CR2  = (0x500E)
                                    205 ; port D
                           00500F   206  PD_BASE = (0X500F)
                           00500F   207  PD_ODR  = (0x500F)
                           005010   208  PD_IDR  = (0x5010)
                           005011   209  PD_DDR  = (0x5011)
                           005012   210  PD_CR1  = (0x5012)
                           005013   211  PD_CR2  = (0x5013)
                                    212 ; port E
                           005014   213  PE_BASE = (0X5014)
                           005014   214  PE_ODR  = (0x5014)
                           005015   215  PE_IDR  = (0x5015)
                           005016   216  PE_DDR  = (0x5016)
                           005017   217  PE_CR1  = (0x5017)
                           005018   218  PE_CR2  = (0x5018)
                                    219 ; port F
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]



                           005019   220  PF_BASE = (0X5019)
                           005019   221  PF_ODR  = (0x5019)
                           00501A   222  PF_IDR  = (0x501A)
                           00501B   223  PF_DDR  = (0x501B)
                           00501C   224  PF_CR1  = (0x501C)
                           00501D   225  PF_CR2  = (0x501D)
                                    226 ; port G
                           00501E   227  PG_BASE = (0X501E)
                           00501E   228  PG_ODR  = (0x501E)
                           00501F   229  PG_IDR  = (0x501F)
                           005020   230  PG_DDR  = (0x5020)
                           005021   231  PG_CR1  = (0x5021)
                           005022   232  PG_CR2  = (0x5022)
                                    233 ; port H not present on LQFP48/LQFP64 package
                           005023   234  PH_BASE = (0X5023)
                           005023   235  PH_ODR  = (0x5023)
                           005024   236  PH_IDR  = (0x5024)
                           005025   237  PH_DDR  = (0x5025)
                           005026   238  PH_CR1  = (0x5026)
                           005027   239  PH_CR2  = (0x5027)
                                    240 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                           005028   241  PI_BASE = (0X5028)
                           005028   242  PI_ODR  = (0x5028)
                           005029   243  PI_IDR  = (0x5029)
                           00502A   244  PI_DDR  = (0x502a)
                           00502B   245  PI_CR1  = (0x502b)
                           00502C   246  PI_CR2  = (0x502c)
                                    247 
                                    248 ; input modes CR1
                           000000   249  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   250  INPUT_PULLUP = (1)
                                    251 ; output mode CR1
                           000000   252  OUTPUT_OD = (0) ; open drain
                           000001   253  OUTPUT_PP = (1) ; push pull
                                    254 ; input modes CR2
                           000000   255  INPUT_DI = (0)
                           000001   256  INPUT_EI = (1)
                                    257 ; output speed CR2
                           000000   258  OUTPUT_SLOW = (0)
                           000001   259  OUTPUT_FAST = (1)
                                    260 
                                    261 
                                    262 ; Flash memory
                           00505A   263  FLASH_CR1  = (0x505A)
                           00505B   264  FLASH_CR2  = (0x505B)
                           00505C   265  FLASH_NCR2  = (0x505C)
                           00505D   266  FLASH_FPR  = (0x505D)
                           00505E   267  FLASH_NFPR  = (0x505E)
                           00505F   268  FLASH_IAPSR  = (0x505F)
                           005062   269  FLASH_PUKR  = (0x5062)
                           005064   270  FLASH_DUKR  = (0x5064)
                                    271 ; data memory unlock keys
                           0000AE   272  FLASH_DUKR_KEY1 = (0xae)
                           000056   273  FLASH_DUKR_KEY2 = (0x56)
                                    274 ; flash memory unlock keys
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



                           000056   275  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   276  FLASH_PUKR_KEY2 = (0xae)
                                    277 ; FLASH_CR1 bits
                           000003   278  FLASH_CR1_HALT = BIT3
                           000002   279  FLASH_CR1_AHALT = BIT2
                           000001   280  FLASH_CR1_IE = BIT1
                           000000   281  FLASH_CR1_FIX = BIT0
                                    282 ; FLASH_CR2 bits
                           000007   283  FLASH_CR2_OPT = BIT7
                           000006   284  FLASH_CR2_WPRG = BIT6
                           000005   285  FLASH_CR2_ERASE = BIT5
                           000004   286  FLASH_CR2_FPRG = BIT4
                           000000   287  FLASH_CR2_PRG = BIT0
                                    288 ; FLASH_FPR bits
                           000005   289  FLASH_FPR_WPB5 = BIT5
                           000004   290  FLASH_FPR_WPB4 = BIT4
                           000003   291  FLASH_FPR_WPB3 = BIT3
                           000002   292  FLASH_FPR_WPB2 = BIT2
                           000001   293  FLASH_FPR_WPB1 = BIT1
                           000000   294  FLASH_FPR_WPB0 = BIT0
                                    295 ; FLASH_NFPR bits
                           000005   296  FLASH_NFPR_NWPB5 = BIT5
                           000004   297  FLASH_NFPR_NWPB4 = BIT4
                           000003   298  FLASH_NFPR_NWPB3 = BIT3
                           000002   299  FLASH_NFPR_NWPB2 = BIT2
                           000001   300  FLASH_NFPR_NWPB1 = BIT1
                           000000   301  FLASH_NFPR_NWPB0 = BIT0
                                    302 ; FLASH_IAPSR bits
                           000006   303  FLASH_IAPSR_HVOFF = BIT6
                           000003   304  FLASH_IAPSR_DUL = BIT3
                           000002   305  FLASH_IAPSR_EOP = BIT2
                           000001   306  FLASH_IAPSR_PUL = BIT1
                           000000   307  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    308 
                                    309 ; Interrupt control
                           0050A0   310  EXTI_CR1  = (0x50A0)
                           0050A1   311  EXTI_CR2  = (0x50A1)
                                    312 
                                    313 ; Reset Status
                           0050B3   314  RST_SR  = (0x50B3)
                                    315 
                                    316 ; Clock Registers
                           0050C0   317  CLK_ICKR  = (0x50c0)
                           0050C1   318  CLK_ECKR  = (0x50c1)
                           0050C3   319  CLK_CMSR  = (0x50C3)
                           0050C4   320  CLK_SWR  = (0x50C4)
                           0050C5   321  CLK_SWCR  = (0x50C5)
                           0050C6   322  CLK_CKDIVR  = (0x50C6)
                           0050C7   323  CLK_PCKENR1  = (0x50C7)
                           0050C8   324  CLK_CSSR  = (0x50C8)
                           0050C9   325  CLK_CCOR  = (0x50C9)
                           0050CA   326  CLK_PCKENR2  = (0x50CA)
                           0050CC   327  CLK_HSITRIMR  = (0x50CC)
                           0050CD   328  CLK_SWIMCCR  = (0x50CD)
                                    329 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



                                    330 ; Peripherals clock gating
                                    331 ; CLK_PCKENR1 
                           000007   332  CLK_PCKENR1_TIM1 = (7)
                           000006   333  CLK_PCKENR1_TIM3 = (6)
                           000005   334  CLK_PCKENR1_TIM2 = (5)
                           000004   335  CLK_PCKENR1_TIM4 = (4)
                           000003   336  CLK_PCKENR1_UART3 = (3)
                           000002   337  CLK_PCKENR1_UART1 = (2)
                           000001   338  CLK_PCKENR1_SPI = (1)
                           000000   339  CLK_PCKENR1_I2C = (0)
                                    340 ; CLK_PCKENR2
                           000007   341  CLK_PCKENR2_CAN = (7)
                           000003   342  CLK_PCKENR2_ADC = (3)
                           000002   343  CLK_PCKENR2_AWU = (2)
                                    344 
                                    345 ; Clock bits
                           000005   346  CLK_ICKR_REGAH = (5)
                           000004   347  CLK_ICKR_LSIRDY = (4)
                           000003   348  CLK_ICKR_LSIEN = (3)
                           000002   349  CLK_ICKR_FHW = (2)
                           000001   350  CLK_ICKR_HSIRDY = (1)
                           000000   351  CLK_ICKR_HSIEN = (0)
                                    352 
                           000001   353  CLK_ECKR_HSERDY = (1)
                           000000   354  CLK_ECKR_HSEEN = (0)
                                    355 ; clock source
                           0000E1   356  CLK_SWR_HSI = 0xE1
                           0000D2   357  CLK_SWR_LSI = 0xD2
                           0000B4   358  CLK_SWR_HSE = 0xB4
                                    359 
                           000003   360  CLK_SWCR_SWIF = (3)
                           000002   361  CLK_SWCR_SWIEN = (2)
                           000001   362  CLK_SWCR_SWEN = (1)
                           000000   363  CLK_SWCR_SWBSY = (0)
                                    364 
                           000004   365  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   366  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   367  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   368  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   369  CLK_CKDIVR_CPUDIV0 = (0)
                                    370 
                                    371 ; Watchdog
                           0050D1   372  WWDG_CR  = (0x50D1)
                           0050D2   373  WWDG_WR  = (0x50D2)
                           0050E0   374  IWDG_KR  = (0x50E0)
                           0050E1   375  IWDG_PR  = (0x50E1)
                           0050E2   376  IWDG_RLR  = (0x50E2)
                           0050F0   377  AWU_CSR1  = (0x50F0)
                           0050F1   378  AWU_APR  = (0x50F1)
                           0050F2   379  AWU_TBR  = (0x50F2)
                                    380 
                                    381 ; Beeper
                                    382 ; beeper output is alternate function AFR7 on PD4
                                    383 ; connected to CN9-6
                           0050F3   384  BEEP_CSR  = (0x50F3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



                           00000F   385  BEEP_PORT = PD
                           000004   386  BEEP_BIT = 4
                           000010   387  BEEP_MASK = B4_MASK
                                    388 
                                    389 ; SPI
                           005200   390  SPI_CR1  = (0x5200)
                           005201   391  SPI_CR2  = (0x5201)
                           005202   392  SPI_ICR  = (0x5202)
                           005203   393  SPI_SR  = (0x5203)
                           005204   394  SPI_DR  = (0x5204)
                           005205   395  SPI_CRCPR  = (0x5205)
                           005206   396  SPI_RXCRCR  = (0x5206)
                           005207   397  SPI_TXCRCR  = (0x5207)
                                    398 
                                    399 ; I2C
                           005210   400  I2C_CR1  = (0x5210)
                           005211   401  I2C_CR2  = (0x5211)
                           005212   402  I2C_FREQR  = (0x5212)
                           005213   403  I2C_OARL  = (0x5213)
                           005214   404  I2C_OARH  = (0x5214)
                           005216   405  I2C_DR  = (0x5216)
                           005217   406  I2C_SR1  = (0x5217)
                           005218   407  I2C_SR2  = (0x5218)
                           005219   408  I2C_SR3  = (0x5219)
                           00521A   409  I2C_ITR  = (0x521A)
                           00521B   410  I2C_CCRL  = (0x521B)
                           00521C   411  I2C_CCRH  = (0x521C)
                           00521D   412  I2C_TRISER  = (0x521D)
                           00521E   413  I2C_PECR  = (0x521E)
                                    414 
                           000007   415  I2C_CR1_NOSTRETCH = (7)
                           000006   416  I2C_CR1_ENGC = (6)
                           000000   417  I2C_CR1_PE = (0)
                                    418 
                           000007   419  I2C_CR2_SWRST = (7)
                           000003   420  I2C_CR2_POS = (3)
                           000002   421  I2C_CR2_ACK = (2)
                           000001   422  I2C_CR2_STOP = (1)
                           000000   423  I2C_CR2_START = (0)
                                    424 
                           000000   425  I2C_OARL_ADD0 = (0)
                                    426 
                           000009   427  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   428  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    429 
                           000007   430  I2C_OARH_ADDMODE = (7)
                           000006   431  I2C_OARH_ADDCONF = (6)
                           000002   432  I2C_OARH_ADD9 = (2)
                           000001   433  I2C_OARH_ADD8 = (1)
                                    434 
                           000007   435  I2C_SR1_TXE = (7)
                           000006   436  I2C_SR1_RXNE = (6)
                           000004   437  I2C_SR1_STOPF = (4)
                           000003   438  I2C_SR1_ADD10 = (3)
                           000002   439  I2C_SR1_BTF = (2)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



                           000001   440  I2C_SR1_ADDR = (1)
                           000000   441  I2C_SR1_SB = (0)
                                    442 
                           000005   443  I2C_SR2_WUFH = (5)
                           000003   444  I2C_SR2_OVR = (3)
                           000002   445  I2C_SR2_AF = (2)
                           000001   446  I2C_SR2_ARLO = (1)
                           000000   447  I2C_SR2_BERR = (0)
                                    448 
                           000007   449  I2C_SR3_DUALF = (7)
                           000004   450  I2C_SR3_GENCALL = (4)
                           000002   451  I2C_SR3_TRA = (2)
                           000001   452  I2C_SR3_BUSY = (1)
                           000000   453  I2C_SR3_MSL = (0)
                                    454 
                           000002   455  I2C_ITR_ITBUFEN = (2)
                           000001   456  I2C_ITR_ITEVTEN = (1)
                           000000   457  I2C_ITR_ITERREN = (0)
                                    458 
                                    459 ; Precalculated values, all in KHz
                           000080   460  I2C_CCRH_16MHZ_FAST_400 = 0x80
                           00000D   461  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    462 ;
                                    463 ; Fast I2C mode max rise time = 300ns
                                    464 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    465 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    466 
                           000005   467  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    468 
                           0000C0   469  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   470  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   471  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    472 
                           000080   473  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   474  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   475  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    476 
                           000000   477  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   478  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    479 ;
                                    480 ; Standard I2C mode max rise time = 1000ns
                                    481 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    482 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    483 
                           000011   484  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    485 
                           000000   486  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   487  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   488  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    489 
                           000001   490  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   491  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   492  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    493 
                           000001   494  I2C_READ = 1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



                           000000   495  I2C_WRITE = 0
                                    496 
                                    497 ; baudrate constant for brr_value table access
                                    498 ; to be used by uart_init 
                           000000   499 B2400=0
                           000001   500 B4800=1
                           000002   501 B9600=2
                           000003   502 B19200=3
                           000004   503 B38400=4
                           000005   504 B57600=5
                           000006   505 B115200=6
                           000007   506 B230400=7
                           000008   507 B460800=8
                           000009   508 B921600=9
                                    509 
                                    510 ; UART registers offset from
                                    511 ; base address 
                           000000   512 UART_SR=0
                           000001   513 UART_DR=1
                           000002   514 UART_BRR1=2
                           000003   515 UART_BRR2=3
                           000004   516 UART_CR1=4
                           000005   517 UART_CR2=5
                           000006   518 UART_CR3=6
                           000007   519 UART_CR4=7
                           000008   520 UART_CR5=8
                           000009   521 UART_CR6=9
                           000009   522 UART_GTR=9
                           00000A   523 UART_PSCR=10
                                    524 
                                    525 ; uart identifier
                                    526 ; to be used by uart_init
                           000000   527  UART1 = 0
                           000001   528  UART3 = 1
                                    529 
                                    530 ; pins used by uart 
                           000005   531 UART1_TX_PIN=BIT5
                           000004   532 UART1_RX_PIN=BIT4
                           000005   533 UART3_TX_PIN=BIT5
                           000006   534 UART3_RX_PIN=BIT6
                                    535 ; uart port base address 
                           000000   536 UART1_PORT=PA 
                           00000F   537 UART3_PORT=PD
                                    538 
                                    539 ; UART1 
                           005230   540  UART1_BASE  = (0x5230)
                           005230   541  UART1_SR    = (0x5230)
                           005231   542  UART1_DR    = (0x5231)
                           005232   543  UART1_BRR1  = (0x5232)
                           005233   544  UART1_BRR2  = (0x5233)
                           005234   545  UART1_CR1   = (0x5234)
                           005235   546  UART1_CR2   = (0x5235)
                           005236   547  UART1_CR3   = (0x5236)
                           005237   548  UART1_CR4   = (0x5237)
                           005238   549  UART1_CR5   = (0x5238)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 37.
Hexadecimal [24-Bits]



                           005239   550  UART1_GTR   = (0x5239)
                           00523A   551  UART1_PSCR  = (0x523A)
                                    552 
                                    553 ; UART3
                           005240   554  UART3_BASE  = (0x5240)
                           005240   555  UART3_SR    = (0x5240)
                           005241   556  UART3_DR    = (0x5241)
                           005242   557  UART3_BRR1  = (0x5242)
                           005243   558  UART3_BRR2  = (0x5243)
                           005244   559  UART3_CR1   = (0x5244)
                           005245   560  UART3_CR2   = (0x5245)
                           005246   561  UART3_CR3   = (0x5246)
                           005247   562  UART3_CR4   = (0x5247)
                           004249   563  UART3_CR6   = (0x4249)
                                    564 
                                    565 ; UART Status Register bits
                           000007   566  UART_SR_TXE = (7)
                           000006   567  UART_SR_TC = (6)
                           000005   568  UART_SR_RXNE = (5)
                           000004   569  UART_SR_IDLE = (4)
                           000003   570  UART_SR_OR = (3)
                           000002   571  UART_SR_NF = (2)
                           000001   572  UART_SR_FE = (1)
                           000000   573  UART_SR_PE = (0)
                                    574 
                                    575 ; Uart Control Register bits
                           000007   576  UART_CR1_R8 = (7)
                           000006   577  UART_CR1_T8 = (6)
                           000005   578  UART_CR1_UARTD = (5)
                           000004   579  UART_CR1_M = (4)
                           000003   580  UART_CR1_WAKE = (3)
                           000002   581  UART_CR1_PCEN = (2)
                           000001   582  UART_CR1_PS = (1)
                           000000   583  UART_CR1_PIEN = (0)
                                    584 
                           000007   585  UART_CR2_TIEN = (7)
                           000006   586  UART_CR2_TCIEN = (6)
                           000005   587  UART_CR2_RIEN = (5)
                           000004   588  UART_CR2_ILIEN = (4)
                           000003   589  UART_CR2_TEN = (3)
                           000002   590  UART_CR2_REN = (2)
                           000001   591  UART_CR2_RWU = (1)
                           000000   592  UART_CR2_SBK = (0)
                                    593 
                           000006   594  UART_CR3_LINEN = (6)
                           000005   595  UART_CR3_STOP1 = (5)
                           000004   596  UART_CR3_STOP0 = (4)
                           000003   597  UART_CR3_CLKEN = (3)
                           000002   598  UART_CR3_CPOL = (2)
                           000001   599  UART_CR3_CPHA = (1)
                           000000   600  UART_CR3_LBCL = (0)
                                    601 
                           000006   602  UART_CR4_LBDIEN = (6)
                           000005   603  UART_CR4_LBDL = (5)
                           000004   604  UART_CR4_LBDF = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



                           000003   605  UART_CR4_ADD3 = (3)
                           000002   606  UART_CR4_ADD2 = (2)
                           000001   607  UART_CR4_ADD1 = (1)
                           000000   608  UART_CR4_ADD0 = (0)
                                    609 
                           000005   610  UART_CR5_SCEN = (5)
                           000004   611  UART_CR5_NACK = (4)
                           000003   612  UART_CR5_HDSEL = (3)
                           000002   613  UART_CR5_IRLP = (2)
                           000001   614  UART_CR5_IREN = (1)
                                    615 ; LIN mode config register
                           000007   616  UART_CR6_LDUM = (7)
                           000005   617  UART_CR6_LSLV = (5)
                           000004   618  UART_CR6_LASE = (4)
                           000002   619  UART_CR6_LHDIEN = (2) 
                           000001   620  UART_CR6_LHDF = (1)
                           000000   621  UART_CR6_LSF = (0)
                                    622 
                                    623 ; TIMERS
                                    624 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   625  TIM1_CR1  = (0x5250)
                           005251   626  TIM1_CR2  = (0x5251)
                           005252   627  TIM1_SMCR  = (0x5252)
                           005253   628  TIM1_ETR  = (0x5253)
                           005254   629  TIM1_IER  = (0x5254)
                           005255   630  TIM1_SR1  = (0x5255)
                           005256   631  TIM1_SR2  = (0x5256)
                           005257   632  TIM1_EGR  = (0x5257)
                           005258   633  TIM1_CCMR1  = (0x5258)
                           005259   634  TIM1_CCMR2  = (0x5259)
                           00525A   635  TIM1_CCMR3  = (0x525A)
                           00525B   636  TIM1_CCMR4  = (0x525B)
                           00525C   637  TIM1_CCER1  = (0x525C)
                           00525D   638  TIM1_CCER2  = (0x525D)
                           00525E   639  TIM1_CNTRH  = (0x525E)
                           00525F   640  TIM1_CNTRL  = (0x525F)
                           005260   641  TIM1_PSCRH  = (0x5260)
                           005261   642  TIM1_PSCRL  = (0x5261)
                           005262   643  TIM1_ARRH  = (0x5262)
                           005263   644  TIM1_ARRL  = (0x5263)
                           005264   645  TIM1_RCR  = (0x5264)
                           005265   646  TIM1_CCR1H  = (0x5265)
                           005266   647  TIM1_CCR1L  = (0x5266)
                           005267   648  TIM1_CCR2H  = (0x5267)
                           005268   649  TIM1_CCR2L  = (0x5268)
                           005269   650  TIM1_CCR3H  = (0x5269)
                           00526A   651  TIM1_CCR3L  = (0x526A)
                           00526B   652  TIM1_CCR4H  = (0x526B)
                           00526C   653  TIM1_CCR4L  = (0x526C)
                           00526D   654  TIM1_BKR  = (0x526D)
                           00526E   655  TIM1_DTR  = (0x526E)
                           00526F   656  TIM1_OISR  = (0x526F)
                                    657 
                                    658 ; Timer Control Register bits
                           000007   659  TIM_CR1_ARPE = (7)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



                           000006   660  TIM_CR1_CMSH = (6)
                           000005   661  TIM_CR1_CMSL = (5)
                           000004   662  TIM_CR1_DIR = (4)
                           000003   663  TIM_CR1_OPM = (3)
                           000002   664  TIM_CR1_URS = (2)
                           000001   665  TIM_CR1_UDIS = (1)
                           000000   666  TIM_CR1_CEN = (0)
                                    667 
                           000006   668  TIM1_CR2_MMS2 = (6)
                           000005   669  TIM1_CR2_MMS1 = (5)
                           000004   670  TIM1_CR2_MMS0 = (4)
                           000002   671  TIM1_CR2_COMS = (2)
                           000000   672  TIM1_CR2_CCPC = (0)
                                    673 
                                    674 ; Timer Slave Mode Control bits
                           000007   675  TIM1_SMCR_MSM = (7)
                           000006   676  TIM1_SMCR_TS2 = (6)
                           000005   677  TIM1_SMCR_TS1 = (5)
                           000004   678  TIM1_SMCR_TS0 = (4)
                           000002   679  TIM1_SMCR_SMS2 = (2)
                           000001   680  TIM1_SMCR_SMS1 = (1)
                           000000   681  TIM1_SMCR_SMS0 = (0)
                                    682 
                                    683 ; Timer External Trigger Enable bits
                           000007   684  TIM1_ETR_ETP = (7)
                           000006   685  TIM1_ETR_ECE = (6)
                           000005   686  TIM1_ETR_ETPS1 = (5)
                           000004   687  TIM1_ETR_ETPS0 = (4)
                           000003   688  TIM1_ETR_ETF3 = (3)
                           000002   689  TIM1_ETR_ETF2 = (2)
                           000001   690  TIM1_ETR_ETF1 = (1)
                           000000   691  TIM1_ETR_ETF0 = (0)
                                    692 
                                    693 ; Timer Interrupt Enable bits
                           000007   694  TIM1_IER_BIE = (7)
                           000006   695  TIM1_IER_TIE = (6)
                           000005   696  TIM1_IER_COMIE = (5)
                           000004   697  TIM1_IER_CC4IE = (4)
                           000003   698  TIM1_IER_CC3IE = (3)
                           000002   699  TIM1_IER_CC2IE = (2)
                           000001   700  TIM1_IER_CC1IE = (1)
                           000000   701  TIM1_IER_UIE = (0)
                                    702 
                                    703 ; Timer Status Register bits
                           000007   704  TIM1_SR1_BIF = (7)
                           000006   705  TIM1_SR1_TIF = (6)
                           000005   706  TIM1_SR1_COMIF = (5)
                           000004   707  TIM1_SR1_CC4IF = (4)
                           000003   708  TIM1_SR1_CC3IF = (3)
                           000002   709  TIM1_SR1_CC2IF = (2)
                           000001   710  TIM1_SR1_CC1IF = (1)
                           000000   711  TIM1_SR1_UIF = (0)
                                    712 
                           000004   713  TIM1_SR2_CC4OF = (4)
                           000003   714  TIM1_SR2_CC3OF = (3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                           000002   715  TIM1_SR2_CC2OF = (2)
                           000001   716  TIM1_SR2_CC1OF = (1)
                                    717 
                                    718 ; Timer Event Generation Register bits
                           000007   719  TIM1_EGR_BG = (7)
                           000006   720  TIM1_EGR_TG = (6)
                           000005   721  TIM1_EGR_COMG = (5)
                           000004   722  TIM1_EGR_CC4G = (4)
                           000003   723  TIM1_EGR_CC3G = (3)
                           000002   724  TIM1_EGR_CC2G = (2)
                           000001   725  TIM1_EGR_CC1G = (1)
                           000000   726  TIM1_EGR_UG = (0)
                                    727 
                                    728 ; Capture/Compare Mode Register 1 - channel configured in output
                           000007   729  TIM1_CCMR1_OC1CE = (7)
                           000006   730  TIM1_CCMR1_OC1M2 = (6)
                           000005   731  TIM1_CCMR1_OC1M1 = (5)
                           000004   732  TIM1_CCMR1_OC1M0 = (4)
                           000003   733  TIM1_CCMR1_OC1PE = (3)
                           000002   734  TIM1_CCMR1_OC1FE = (2)
                           000001   735  TIM1_CCMR1_CC1S1 = (1)
                           000000   736  TIM1_CCMR1_CC1S0 = (0)
                                    737 
                                    738 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   739  TIM1_CCMR1_IC1F3 = (7)
                           000006   740  TIM1_CCMR1_IC1F2 = (6)
                           000005   741  TIM1_CCMR1_IC1F1 = (5)
                           000004   742  TIM1_CCMR1_IC1F0 = (4)
                           000003   743  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   744  TIM1_CCMR1_IC1PSC0 = (2)
                                    745 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   746  TIM1_CCMR1_CC1S0 = (0)
                                    747 
                                    748 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   749  TIM1_CCMR2_OC2CE = (7)
                           000006   750  TIM1_CCMR2_OC2M2 = (6)
                           000005   751  TIM1_CCMR2_OC2M1 = (5)
                           000004   752  TIM1_CCMR2_OC2M0 = (4)
                           000003   753  TIM1_CCMR2_OC2PE = (3)
                           000002   754  TIM1_CCMR2_OC2FE = (2)
                           000001   755  TIM1_CCMR2_CC2S1 = (1)
                           000000   756  TIM1_CCMR2_CC2S0 = (0)
                                    757 
                                    758 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   759  TIM1_CCMR2_IC2F3 = (7)
                           000006   760  TIM1_CCMR2_IC2F2 = (6)
                           000005   761  TIM1_CCMR2_IC2F1 = (5)
                           000004   762  TIM1_CCMR2_IC2F0 = (4)
                           000003   763  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   764  TIM1_CCMR2_IC2PSC0 = (2)
                                    765 ;  TIM1_CCMR2_CC2S1 = (1)
                           000000   766  TIM1_CCMR2_CC2S0 = (0)
                                    767 
                                    768 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   769  TIM1_CCMR3_OC3CE = (7)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



                           000006   770  TIM1_CCMR3_OC3M2 = (6)
                           000005   771  TIM1_CCMR3_OC3M1 = (5)
                           000004   772  TIM1_CCMR3_OC3M0 = (4)
                           000003   773  TIM1_CCMR3_OC3PE = (3)
                           000002   774  TIM1_CCMR3_OC3FE = (2)
                           000001   775  TIM1_CCMR3_CC3S1 = (1)
                           000000   776  TIM1_CCMR3_CC3S0 = (0)
                                    777 
                                    778 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   779  TIM1_CCMR3_IC3F3 = (7)
                           000006   780  TIM1_CCMR3_IC3F2 = (6)
                           000005   781  TIM1_CCMR3_IC3F1 = (5)
                           000004   782  TIM1_CCMR3_IC3F0 = (4)
                           000003   783  TIM1_CCMR3_IC3PSC1 = (3)
                           000002   784  TIM1_CCMR3_IC3PSC0 = (2)
                                    785 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   786  TIM1_CCMR3_CC3S0 = (0)
                                    787 
                                    788 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   789  TIM1_CCMR4_OC4CE = (7)
                           000006   790  TIM1_CCMR4_OC4M2 = (6)
                           000005   791  TIM1_CCMR4_OC4M1 = (5)
                           000004   792  TIM1_CCMR4_OC4M0 = (4)
                           000003   793  TIM1_CCMR4_OC4PE = (3)
                           000002   794  TIM1_CCMR4_OC4FE = (2)
                           000001   795  TIM1_CCMR4_CC4S1 = (1)
                           000000   796  TIM1_CCMR4_CC4S0 = (0)
                                    797 
                                    798 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   799  TIM1_CCMR4_IC4F3 = (7)
                           000006   800  TIM1_CCMR4_IC4F2 = (6)
                           000005   801  TIM1_CCMR4_IC4F1 = (5)
                           000004   802  TIM1_CCMR4_IC4F0 = (4)
                           000003   803  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   804  TIM1_CCMR4_IC4PSC0 = (2)
                                    805 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   806  TIM1_CCMR4_CC4S0 = (0)
                                    807 
                                    808 ; Timer 2 - 16-bit timer
                           005300   809  TIM2_CR1  = (0x5300)
                           005301   810  TIM2_IER  = (0x5301)
                           005302   811  TIM2_SR1  = (0x5302)
                           005303   812  TIM2_SR2  = (0x5303)
                           005304   813  TIM2_EGR  = (0x5304)
                           005305   814  TIM2_CCMR1  = (0x5305)
                           005306   815  TIM2_CCMR2  = (0x5306)
                           005307   816  TIM2_CCMR3  = (0x5307)
                           005308   817  TIM2_CCER1  = (0x5308)
                           005309   818  TIM2_CCER2  = (0x5309)
                           00530A   819  TIM2_CNTRH  = (0x530A)
                           00530B   820  TIM2_CNTRL  = (0x530B)
                           00530C   821  TIM2_PSCR  = (0x530C)
                           00530D   822  TIM2_ARRH  = (0x530D)
                           00530E   823  TIM2_ARRL  = (0x530E)
                           00530F   824  TIM2_CCR1H  = (0x530F)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



                           005310   825  TIM2_CCR1L  = (0x5310)
                           005311   826  TIM2_CCR2H  = (0x5311)
                           005312   827  TIM2_CCR2L  = (0x5312)
                           005313   828  TIM2_CCR3H  = (0x5313)
                           005314   829  TIM2_CCR3L  = (0x5314)
                                    830 
                                    831 ; Timer 3
                           005320   832  TIM3_CR1  = (0x5320)
                           005321   833  TIM3_IER  = (0x5321)
                           005322   834  TIM3_SR1  = (0x5322)
                           005323   835  TIM3_SR2  = (0x5323)
                           005324   836  TIM3_EGR  = (0x5324)
                           005325   837  TIM3_CCMR1  = (0x5325)
                           005326   838  TIM3_CCMR2  = (0x5326)
                           005327   839  TIM3_CCER1  = (0x5327)
                           005328   840  TIM3_CNTRH  = (0x5328)
                           005329   841  TIM3_CNTRL  = (0x5329)
                           00532A   842  TIM3_PSCR  = (0x532A)
                           00532B   843  TIM3_ARRH  = (0x532B)
                           00532C   844  TIM3_ARRL  = (0x532C)
                           00532D   845  TIM3_CCR1H  = (0x532D)
                           00532E   846  TIM3_CCR1L  = (0x532E)
                           00532F   847  TIM3_CCR2H  = (0x532F)
                           005330   848  TIM3_CCR2L  = (0x5330)
                                    849 
                                    850 ; TIM3_CR1  fields
                           000000   851  TIM3_CR1_CEN = (0)
                           000001   852  TIM3_CR1_UDIS = (1)
                           000002   853  TIM3_CR1_URS = (2)
                           000003   854  TIM3_CR1_OPM = (3)
                           000007   855  TIM3_CR1_ARPE = (7)
                                    856 ; TIM3_CCR2  fields
                           000000   857  TIM3_CCMR2_CC2S_POS = (0)
                           000003   858  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   859  TIM3_CCMR2_OC2M_POS = (4)  
                                    860 ; TIM3_CCER1 fields
                           000000   861  TIM3_CCER1_CC1E = (0)
                           000001   862  TIM3_CCER1_CC1P = (1)
                           000004   863  TIM3_CCER1_CC2E = (4)
                           000005   864  TIM3_CCER1_CC2P = (5)
                                    865 ; TIM3_CCER2 fields
                           000000   866  TIM3_CCER2_CC3E = (0)
                           000001   867  TIM3_CCER2_CC3P = (1)
                                    868 
                                    869 ; Timer 4
                           005340   870  TIM4_CR1  = (0x5340)
                           005341   871  TIM4_IER  = (0x5341)
                           005342   872  TIM4_SR  = (0x5342)
                           005343   873  TIM4_EGR  = (0x5343)
                           005344   874  TIM4_CNTR  = (0x5344)
                           005345   875  TIM4_PSCR  = (0x5345)
                           005346   876  TIM4_ARR  = (0x5346)
                                    877 
                                    878 ; Timer 4 bitmasks
                                    879 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



                           000007   880  TIM4_CR1_ARPE = (7)
                           000003   881  TIM4_CR1_OPM = (3)
                           000002   882  TIM4_CR1_URS = (2)
                           000001   883  TIM4_CR1_UDIS = (1)
                           000000   884  TIM4_CR1_CEN = (0)
                                    885 
                           000000   886  TIM4_IER_UIE = (0)
                                    887 
                           000000   888  TIM4_SR_UIF = (0)
                                    889 
                           000000   890  TIM4_EGR_UG = (0)
                                    891 
                           000002   892  TIM4_PSCR_PSC2 = (2)
                           000001   893  TIM4_PSCR_PSC1 = (1)
                           000000   894  TIM4_PSCR_PSC0 = (0)
                                    895 
                           000000   896  TIM4_PSCR_1 = 0
                           000001   897  TIM4_PSCR_2 = 1
                           000002   898  TIM4_PSCR_4 = 2
                           000003   899  TIM4_PSCR_8 = 3
                           000004   900  TIM4_PSCR_16 = 4
                           000005   901  TIM4_PSCR_32 = 5
                           000006   902  TIM4_PSCR_64 = 6
                           000007   903  TIM4_PSCR_128 = 7
                                    904 
                                    905 ; ADC2
                           005400   906  ADC_CSR  = (0x5400)
                           005401   907  ADC_CR1  = (0x5401)
                           005402   908  ADC_CR2  = (0x5402)
                           005403   909  ADC_CR3  = (0x5403)
                           005404   910  ADC_DRH  = (0x5404)
                           005405   911  ADC_DRL  = (0x5405)
                           005406   912  ADC_TDRH  = (0x5406)
                           005407   913  ADC_TDRL  = (0x5407)
                                    914  
                                    915 ; ADC bitmasks
                                    916 
                           000007   917  ADC_CSR_EOC = (7)
                           000006   918  ADC_CSR_AWD = (6)
                           000005   919  ADC_CSR_EOCIE = (5)
                           000004   920  ADC_CSR_AWDIE = (4)
                           000003   921  ADC_CSR_CH3 = (3)
                           000002   922  ADC_CSR_CH2 = (2)
                           000001   923  ADC_CSR_CH1 = (1)
                           000000   924  ADC_CSR_CH0 = (0)
                                    925 
                           000006   926  ADC_CR1_SPSEL2 = (6)
                           000005   927  ADC_CR1_SPSEL1 = (5)
                           000004   928  ADC_CR1_SPSEL0 = (4)
                           000001   929  ADC_CR1_CONT = (1)
                           000000   930  ADC_CR1_ADON = (0)
                                    931 
                           000006   932  ADC_CR2_EXTTRIG = (6)
                           000005   933  ADC_CR2_EXTSEL1 = (5)
                           000004   934  ADC_CR2_EXTSEL0 = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



                           000003   935  ADC_CR2_ALIGN = (3)
                           000001   936  ADC_CR2_SCAN = (1)
                                    937 
                           000007   938  ADC_CR3_DBUF = (7)
                           000006   939  ADC_CR3_DRH = (6)
                                    940 
                                    941 ; beCAN
                           005420   942  CAN_MCR = (0x5420)
                           005421   943  CAN_MSR = (0x5421)
                           005422   944  CAN_TSR = (0x5422)
                           005423   945  CAN_TPR = (0x5423)
                           005424   946  CAN_RFR = (0x5424)
                           005425   947  CAN_IER = (0x5425)
                           005426   948  CAN_DGR = (0x5426)
                           005427   949  CAN_FPSR = (0x5427)
                           005428   950  CAN_P0 = (0x5428)
                           005429   951  CAN_P1 = (0x5429)
                           00542A   952  CAN_P2 = (0x542A)
                           00542B   953  CAN_P3 = (0x542B)
                           00542C   954  CAN_P4 = (0x542C)
                           00542D   955  CAN_P5 = (0x542D)
                           00542E   956  CAN_P6 = (0x542E)
                           00542F   957  CAN_P7 = (0x542F)
                           005430   958  CAN_P8 = (0x5430)
                           005431   959  CAN_P9 = (0x5431)
                           005432   960  CAN_PA = (0x5432)
                           005433   961  CAN_PB = (0x5433)
                           005434   962  CAN_PC = (0x5434)
                           005435   963  CAN_PD = (0x5435)
                           005436   964  CAN_PE = (0x5436)
                           005437   965  CAN_PF = (0x5437)
                                    966 
                                    967 
                                    968 ; CPU
                           007F00   969  CPU_A  = (0x7F00)
                           007F01   970  CPU_PCE  = (0x7F01)
                           007F02   971  CPU_PCH  = (0x7F02)
                           007F03   972  CPU_PCL  = (0x7F03)
                           007F04   973  CPU_XH  = (0x7F04)
                           007F05   974  CPU_XL  = (0x7F05)
                           007F06   975  CPU_YH  = (0x7F06)
                           007F07   976  CPU_YL  = (0x7F07)
                           007F08   977  CPU_SPH  = (0x7F08)
                           007F09   978  CPU_SPL   = (0x7F09)
                           007F0A   979  CPU_CCR   = (0x7F0A)
                                    980 
                                    981 ; global configuration register
                           007F60   982  CFG_GCR   = (0x7F60)
                           000001   983  CFG_GCR_AL = 1
                           000000   984  CFG_GCR_SWIM = 0
                                    985 
                                    986 ; interrupt control registers
                           007F70   987  ITC_SPR1   = (0x7F70)
                           007F71   988  ITC_SPR2   = (0x7F71)
                           007F72   989  ITC_SPR3   = (0x7F72)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



                           007F73   990  ITC_SPR4   = (0x7F73)
                           007F74   991  ITC_SPR5   = (0x7F74)
                           007F75   992  ITC_SPR6   = (0x7F75)
                           007F76   993  ITC_SPR7   = (0x7F76)
                           007F77   994  ITC_SPR8   = (0x7F77)
                                    995 
                                    996 ; SWIM, control and status register
                           007F80   997  SWIM_CSR   = (0x7F80)
                                    998 ; debug registers
                           007F90   999  DM_BK1RE   = (0x7F90)
                           007F91  1000  DM_BK1RH   = (0x7F91)
                           007F92  1001  DM_BK1RL   = (0x7F92)
                           007F93  1002  DM_BK2RE   = (0x7F93)
                           007F94  1003  DM_BK2RH   = (0x7F94)
                           007F95  1004  DM_BK2RL   = (0x7F95)
                           007F96  1005  DM_CR1   = (0x7F96)
                           007F97  1006  DM_CR2   = (0x7F97)
                           007F98  1007  DM_CSR1   = (0x7F98)
                           007F99  1008  DM_CSR2   = (0x7F99)
                           007F9A  1009  DM_ENFCTR   = (0x7F9A)
                                   1010 
                                   1011 ; Interrupt Numbers
                           000000  1012  INT_TLI = 0
                           000001  1013  INT_AWU = 1
                           000002  1014  INT_CLK = 2
                           000003  1015  INT_EXTI0 = 3
                           000004  1016  INT_EXTI1 = 4
                           000005  1017  INT_EXTI2 = 5
                           000006  1018  INT_EXTI3 = 6
                           000007  1019  INT_EXTI4 = 7
                           000008  1020  INT_CAN_RX = 8
                           000009  1021  INT_CAN_TX = 9
                           00000A  1022  INT_SPI = 10
                           00000B  1023  INT_TIM1_OVF = 11
                           00000C  1024  INT_TIM1_CCM = 12
                           00000D  1025  INT_TIM2_OVF = 13
                           00000E  1026  INT_TIM2_CCM = 14
                           00000F  1027  INT_TIM3_OVF = 15
                           000010  1028  INT_TIM3_CCM = 16
                           000011  1029  INT_UART1_TX_COMPLETED = 17
                           000012  1030  INT_AUART1_RX_FULL = 18
                           000013  1031  INT_I2C = 19
                           000014  1032  INT_UART3_TX_COMPLETED = 20
                           000015  1033  INT_UART3_RX_FULL = 21
                           000016  1034  INT_ADC2 = 22
                           000017  1035  INT_TIM4_OVF = 23
                           000018  1036  INT_FLASH = 24
                                   1037 
                                   1038 ; Interrupt Vectors
                           008000  1039  INT_VECTOR_RESET = 0x8000
                           008004  1040  INT_VECTOR_TRAP = 0x8004
                           008008  1041  INT_VECTOR_TLI = 0x8008
                           00800C  1042  INT_VECTOR_AWU = 0x800C
                           008010  1043  INT_VECTOR_CLK = 0x8010
                           008014  1044  INT_VECTOR_EXTI0 = 0x8014
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



                           008018  1045  INT_VECTOR_EXTI1 = 0x8018
                           00801C  1046  INT_VECTOR_EXTI2 = 0x801C
                           008020  1047  INT_VECTOR_EXTI3 = 0x8020
                           008024  1048  INT_VECTOR_EXTI4 = 0x8024
                           008028  1049  INT_VECTOR_CAN_RX = 0x8028
                           00802C  1050  INT_VECTOR_CAN_TX = 0x802c
                           008030  1051  INT_VECTOR_SPI = 0x8030
                           008034  1052  INT_VECTOR_TIM1_OVF = 0x8034
                           008038  1053  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C  1054  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1055  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1056  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1057  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1058  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1059  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1060  INT_VECTOR_I2C = 0x8054
                           008058  1061  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1062  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1063  INT_VECTOR_ADC2 = 0x8060
                           008064  1064  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1065  INT_VECTOR_FLASH = 0x8068
                                   1066 
                                   1067 ; Condition code register bits
                           000007  1068 CC_V = 7  ; overflow flag 
                           000005  1069 CC_I1= 5  ; interrupt bit 1
                           000004  1070 CC_H = 4  ; half carry 
                           000003  1071 CC_I0 = 3 ; interrupt bit 0
                           000002  1072 CC_N = 2 ;  negative flag 
                           000001  1073 CC_Z = 1 ;  zero flag  
                           000000  1074 CC_C = 0 ; carry bit 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



                                     25 	.include "../inc/ascii.inc"
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
                                     18 
                                     19 ;-------------------------------------------------------
                                     20 ;     ASCII control  values
                                     21 ;     CTRL_x   are VT100 keyboard values  
                                     22 ;-------------------------------------------------------
                           000001    23 		CTRL_A = 1
                           000002    24 		CTRL_B = 2
                           000003    25 		CTRL_C = 3
                           000004    26 		CTRL_D = 4
                           000005    27 		CTRL_E = 5
                           000006    28 		CTRL_F = 6
                                     29 
                           000007    30         BELL = 7    ; vt100 terminal generate a sound.
                           000007    31 		CTRL_G = 7
                                     32 
                           000008    33 		BSP = 8     ; back space 
                           000008    34 		CTRL_H = 8  
                                     35 
                           000009    36     	TAB = 9     ; horizontal tabulation
                           000009    37         CTRL_I = 9
                                     38 
                           00000A    39 		NL = 10     ; new line 
                           00000A    40         CTRL_J = 10 
                                     41 
                           00000B    42         VT = 11     ; vertical tabulation 
                           00000B    43 		CTRL_K = 11
                                     44 
                           00000C    45         FF = 12      ; new page
                           00000C    46 		CTRL_L = 12
                                     47 
                           00000D    48 		CR = 13      ; carriage return 
                           00000D    49 		CTRL_M = 13
                                     50 
                           00000E    51 		CTRL_N = 14
                           00000F    52 		CTRL_O = 15
                           000010    53 		CTRL_P = 16
                           000011    54 		CTRL_Q = 17
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



                           000012    55 		CTRL_R = 18
                           000013    56 		CTRL_S = 19
                           000014    57 		CTRL_T = 20
                           000015    58 		CTRL_U = 21
                           000016    59 		CTRL_V = 22
                           000017    60 		CTRL_W = 23
                           000018    61 		CTRL_X = 24
                           000019    62 		CTRL_Y = 25
                           00001A    63 		CTRL_Z = 26
                           00001B    64 		ESC = 27
                           000020    65 		SPACE = 32
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
Hexadecimal [24-Bits]



                                     26 ;	.list
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]



                                     28 
                                     29 	.macro idx_tbl name value ptr  
                                     30 		name=value
                                     31 		.word ptr 
                                     32 	.endm
                                     33 
                                     34 ;-------------------------------------
                                     35 ;   MONA global assembler constants 
                                     36 ;-------------------------------------
                                     37 
                           000050    38 		TIB_SIZE = 80 ; transaction input buffer size
                           000050    39 		PAD_SIZE = 80 ; workding pad size
                                     40 
                                     41 ;------------------------------------------
                                     42 ;    boolean flags in variable 'flags'
                                     43 ;------------------------------------------
                           000000    44 	F_TRAP = 0  ; set by TrapHandler,cleared by 'q' command.
                           000001    45 	F_CC   = 1  ; save carry flag here 
                           000002    46 	F_FOUND = 2 ; set when a search_code succeed  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]



                                     27 
                                     28 ;	.list
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



                                     30 
                                     31 ;-------------------------------------------------------
                                     32 ; History:
                                     33 ;   2019-11-20  version 0.5
                                     34 ;				Code rework and modules reorganization
                                     35 ;				added 'd' command for disassembler
                                     36 ;		
                                     37 ;   2019-11-10  version 0.4
                                     38 ;				Added 'f' command to search string. 
                                     39 ;
                                     40 ;				parser rework.
                                     41 ;		
                                     42 ;	2019-11-05  version 0.3 
                                     43 ;				Added user button interrupt to exit from
                                     44 ;				infinite loop program and fall back du MONA.
                                     45 ;
                                     46 ;				A user application installed after MONA or in RAM 
                                     47 ;				can use *trap* instruction for debugging in MONA.
                                     48 ;				This fall to MONA shell. The application can be
                                     49 ;				resume with the 'q' command in the shell.
                                     50 ;
                                     51 ;				Added 'q' command for when MONA is entered from 
                                     52 ;				from a *trap* instruction. This will resume application
                                     53 ;               after the trap. Otherwise this instruction as no effect.
                                     54 ;
                                     55 ;				This version does not use *uart rx full* (int21) interrupt.
                                     56 ;				It is not working inside TrapHandler even though *rim*
                                     57 ;				instruction called.
                                     58 ;
                                     59 ;				The *main* function check if there is code at *flash_free_base*
                                     60 ;				and jump to it instead of entering MONA shell. The user button
                                     61 ;				can be used to fallback to MONA shell.
                                     62 ;
                                     63 ;				Change behavior of 'x' command. If no address given and 
                                     64 ;				there is an application installed jump to that application.
                                     65 ;
                                     66 ;   2019-11-04  version 0.2
                                     67 ;				Added 'e'rase command.
                                     68 ;				! command accept .asciz argument 
                                     69 ;
                                     70 ;	2019-10-28  starting work on version 0.2 to remove
                                     71 ; 				version 0.1 adressing range limitation.
                                     72 ;               version 0.1 was adapted from 
                                     73 ;			https://github.com/Picatout/stm8s-discovery/tree/master/mona
                                     74 ;
                                     75 ;-------------------------------------------------------
                                     76 
                                     77 
                                     78 ;--------------------------------------------------------
                                     79 ;      MACROS
                                     80 ;--------------------------------------------------------
                                     81 		.macro _ledenable ; set PC5 as push-pull output fast mode
                                     82 		bset PC_CR1,#LED2_BIT
                                     83 		bset PC_CR2,#LED2_BIT
                                     84 		bset PC_DDR,#LED2_BIT
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
Hexadecimal [24-Bits]



                                     85 		.endm
                                     86 		
                                     87 		.macro _ledon ; turn on green LED 
                                     88 		bset PC_ODR,#LED2_BIT
                                     89 		.endm
                                     90 		
                                     91 		.macro _ledoff ; turn off green LED
                                     92 		bres PC_ODR,#LED2_BIT
                                     93 		.endm
                                     94 		
                                     95 		.macro _ledtoggle ; invert green LED state
                                     96 		ld a,#LED2_MASK
                                     97 		xor a,PC_ODR
                                     98 		ld PC_ODR,a
                                     99 		.endm
                                    100 		
                                    101 		
                                    102 		.macro  _int_enable ; enable interrupts
                                    103 		 rim
                                    104 		.endm
                                    105 		
                                    106 		.macro _int_disable ; disable interrupts
                                    107 		sim
                                    108 		.endm
                                    109 
                                    110 ;--------------------------------------------------------
                                    111 ;some constants used by this program.
                                    112 ;--------------------------------------------------------
                           000100   113 		STACK_SIZE = 256 ; call stack size
                           001700   114 		STACK_BASE = RAM_SIZE-STACK_SIZE ; lowest address of stack
                           0017FF   115 		STACK_TOP = RAM_SIZE-1 ; stack top at end of ram
                                    116 		; vesrion major.minor
                           000000   117 		VERS_MAJOR = 0 ; major version number
                           000005   118 		VERS_MINOR = 5 ; minor version number
                                    119 
                                    120 ;--------------------------------------------------------
                                    121 ;   application variables 
                                    122 ;---------------------------------------------------------		
                                    123         .area DATA
      000001                        124 in.w:  .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
      000002                        125 in:		.blkb 1; parser position in tib
      000003                        126 count:  .blkb 1; length of string in tib
      000004                        127 tib:	.blkb TIB_SIZE ; transaction input buffer
      000054                        128 trap_sp: .blkw 1; value of sp at trap entry point.
      000056                        129 ram_free_base: .blkw 1
      000058                        130 flash_free_base: .blkw 1
                                    131 
                                    132 		.area USER_RAM_BASE
                                    133 ;--------------------------------------------------------
                                    134 ;   the following RAM is not used by MONA
                                    135 ;--------------------------------------------------------
      0000B2                        136  _user_ram:		
                                    137 
                                    138 ;--------------------------------------------------------
                                    139 ;  stack segment
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



                                    140 ;--------------------------------------------------------
                                    141        .area SSEG  (ABS)
      001700                        142 	   .org RAM_SIZE-STACK_SIZE
      001700                        143  __stack_bottom:
      001700                        144 	   .ds  256
                                    145 
                                    146 ;--------------------------------------------------------
                                    147 ; interrupt vector 
                                    148 ;--------------------------------------------------------
                                    149 	.area HOME
      008000                        150 __interrupt_vect:
      008000 82 00 81 16            151 	int init0 ;RESET vector
      008004 82 00 81 E6            152 	int TrapHandler 		;TRAP  software interrupt
      008008 82 00 81 E1            153 	int NonHandledInterrupt ;int0 TLI   external top level interrupt
      00800C 82 00 81 E1            154 	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
      008010 82 00 81 E1            155 	int NonHandledInterrupt ;int2 CLK   clock controller
      008014 82 00 81 E1            156 	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
      008018 82 00 81 E1            157 	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
      00801C 82 00 81 E1            158 	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
      008020 82 00 81 E1            159 	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
      008024 82 00 82 35            160 	int UserButtonHandler   ;int7 EXTI4 port E external interrupts
      008028 82 00 81 E1            161 	int NonHandledInterrupt ;int8 beCAN RX interrupt
      00802C 82 00 81 E1            162 	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
      008030 82 00 81 E1            163 	int NonHandledInterrupt ;int10 SPI End of transfer
      008034 82 00 81 E1            164 	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
      008038 82 00 81 E1            165 	int NonHandledInterrupt ;int12 TIM1 capture/compare
      00803C 82 00 81 E1            166 	int NonHandledInterrupt ;int13 TIM2 update /overflow
      008040 82 00 81 E1            167 	int NonHandledInterrupt ;int14 TIM2 capture/compare
      008044 82 00 81 E1            168 	int NonHandledInterrupt ;int15 TIM3 Update/overflow
      008048 82 00 81 E1            169 	int NonHandledInterrupt ;int16 TIM3 Capture/compare
      00804C 82 00 81 E1            170 	int NonHandledInterrupt ;int17 UART1 TX completed
      008050 82 00 81 E1            171 	int NonHandledInterrupt ;int18 UART1 RX full
      008054 82 00 81 E1            172 	int NonHandledInterrupt ;int19 I2C 
      008058 82 00 81 E1            173 	int NonHandledInterrupt ;int20 UART3 TX completed
      00805C 82 00 81 E1            174 	int NonHandledInterrupt ;int21 UART3 RX full
      008060 82 00 81 E1            175 	int NonHandledInterrupt ;int22 ADC2 end of conversion
      008064 82 00 81 E1            176 	int NonHandledInterrupt	;int23 TIM4 update/overflow
      008068 82 00 81 E1            177 	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
      00806C 82 00 81 E1            178 	int NonHandledInterrupt ;int25  not used
      008070 82 00 81 E1            179 	int NonHandledInterrupt ;int26  not used
      008074 82 00 81 E1            180 	int NonHandledInterrupt ;int27  not used
      008078 82 00 81 E1            181 	int NonHandledInterrupt ;int28  not used
      00807C 82 00 81 E1            182 	int NonHandledInterrupt ;int29  not used
                                    183 
                                    184 	.area CODE
      008080 4D 4F 4E 41            185 .ascii "MONA"
                                    186 	;initialize clock to use HSE 8 Mhz crystal
      008084                        187 clock_init:	
      008084 72 12 50 C5      [ 1]  188 	bset CLK_SWCR,#CLK_SWCR_SWEN
      008088 A6 B4            [ 1]  189 	ld a,#CLK_SWR_HSE
      00808A C7 50 C4         [ 1]  190 	ld CLK_SWR,a
      00808D C1 50 C3         [ 1]  191 1$:	cp a,CLK_CMSR
      008090 26 FB            [ 1]  192 	jrne 1$
      008092 81               [ 4]  193 	ret
                                    194 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
Hexadecimal [24-Bits]



                                    195 		; initialize TIMER4 ticks counter
                                    196 ;timer4_init:
                                    197 ;	clr ticks
                                    198 ;	clr cntdwn
                                    199 ;	ld a,#TIM4_PSCR_128 
                                    200 ;	ld TIM4_PSCR,a
                                    201 ;	bset TIM4_IER,#TIM4_IER_UIE
                                    202 ;	bres TIM4_SR,#TIM4_SR_UIF
                                    203 ;	ld a,#125
                                    204 ;	ld TIM4_ARR,a ; 1 msec interval
                                    205 ;	ld a,#((1<<TIM4_CR1_CEN)+(1<<TIM4_CR1_ARPE)) 
                                    206 ;	ld TIM4_CR1,a
                                    207 ;	ret
                                    208 
                                    209 ; initialize UART3, 115200 8N1
      008093                        210 uart3_init:
                                    211 	; configure tx pin
      008093 72 1A 50 11      [ 1]  212 	bset PD_DDR,#BIT5 ; tx pin
      008097 72 1A 50 12      [ 1]  213 	bset PD_CR1,#BIT5 ; push-pull output
      00809B 72 1A 50 13      [ 1]  214 	bset PD_CR2,#BIT5 ; fast output
                                    215 	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
      00809F 35 05 52 43      [ 1]  216 	mov UART3_BRR2,#0x05 ; must be loaded first
      0080A3 35 04 52 42      [ 1]  217 	mov UART3_BRR1,#0x4
      0080A7 35 0C 52 45      [ 1]  218 	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
      0080AB 81               [ 4]  219 	ret
                                    220 	
                                    221 	; pause in milliseconds
                                    222     ; input:  y delay
                                    223     ; output: none
                                    224 ;pause:
                                    225 ;	 ldw cntdwn,y
                                    226 ;1$: ldw y,cntdwn
                                    227 ;	 jrne 1$
                                    228 ;    ret
                                    229 
                                    230 ;-------------------------
                                    231 ;  zero all free ram
                                    232 ;-------------------------
      0080AC                        233 clear_all_free_ram:
      0080AC AE 00 00         [ 2]  234 	ldw x,#0
      0080AF                        235 1$:	
      0080AF 7F               [ 1]  236 	clr (x)
      0080B0 5C               [ 1]  237 	incw x
      0080B1 A3 17 FD         [ 2]  238 	cpw x,#STACK_TOP-2
      0080B4 23 F9            [ 2]  239 	jrule 1$
      0080B6 81               [ 4]  240 	ret
                                    241 
                                    242 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    243 ;  information printed at reset
                                    244 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0080B7                        245 print_mona_info:
      0080B7 52 02            [ 2]  246 	sub sp,#2
      0080B9 A6 00            [ 1]  247 	ld a, #VERS_MAJOR
      0080BB AB 30            [ 1]  248 	add a,#'0
      0080BD 6B 01            [ 1]  249 	ld (1,sp),a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]



      0080BF A6 05            [ 1]  250 	ld a, #VERS_MINOR
      0080C1 AB 30            [ 1]  251 	add a,#'0
      0080C3 6B 02            [ 1]  252 	ld (2,sp),a 
      0080C5 90 AE 8B 59      [ 2]  253 	ldw y,#VERSION
      0080C9 CD 8E 80         [ 4]  254 	call format 
      0080CC 5B 02            [ 2]  255 	addw sp,#2 
      0080CE 90 AE 8B 6E      [ 2]  256 	ldw y,#CPU_MODEL
      0080D2 CD 8F 39         [ 4]  257 	call uart_print
      0080D5 90 AE 8B A6      [ 2]  258 	ldw y,#RAM_FREE_MSG
      0080D9 CD 8F 39         [ 4]  259 	call uart_print
      0080DC 72 5F 00 AB      [ 1]  260 	clr acc24
      0080E0 55 00 56 00 AC   [ 1]  261 	mov acc24+1,ram_free_base
      0080E5 55 00 57 00 AD   [ 1]  262 	mov acc24+2,ram_free_base+1 
      0080EA 5F               [ 1]  263 	clrw x
      0080EB A6 10            [ 1]  264 	ld a,#16
      0080ED CD 8F 9D         [ 4]  265 	call print_int 
      0080F0 90 AE 8B B1      [ 2]  266 	ldw y,#RAM_LAST_FREE_MSG
      0080F4 CD 8F 39         [ 4]  267 	call uart_print
      0080F7 90 AE 8B BA      [ 2]  268 	ldw y,#FLASH_FREE_MSG
      0080FB CD 8F 39         [ 4]  269 	call uart_print
      0080FE A6 10            [ 1]  270 	ld a,#16
      008100 55 00 58 00 AC   [ 1]  271 	mov acc24+1,flash_free_base
      008105 55 00 59 00 AD   [ 1]  272 	mov acc24+2,flash_free_base+1 
      00810A 5F               [ 1]  273 	clrw x 
      00810B CD 8F 9D         [ 4]  274 	call print_int 
      00810E 90 AE 8B C7      [ 2]  275 	ldw y,#EEPROM_MSG
      008112 CD 8F 39         [ 4]  276 	call uart_print
      008115 81               [ 4]  277 	ret
                                    278 
      008116                        279 init0:
                                    280 	; initialize SP
      008116 AE 17 FF         [ 2]  281 	ldw x,#STACK_TOP
      008119 94               [ 1]  282 	ldw sp,x
      00811A CD 80 84         [ 4]  283 	call clock_init
      00811D CD 80 AC         [ 4]  284 	call clear_all_free_ram
                                    285 ;	clr ticks
                                    286 ;	clr cntdwn
      008120 A6 FF            [ 1]  287 	ld a,#255
      008122 C7 00 5A         [ 1]  288 	ld rx_char,a
                                    289 ;	call timer4_init
      008125 CD 80 93         [ 4]  290 	call uart3_init
      0000A8                        291 	_ledenable
      008128 72 1A 50 0D      [ 1]    1 		bset PC_CR1,#LED2_BIT
      00812C 72 1A 50 0E      [ 1]    2 		bset PC_CR2,#LED2_BIT
      008130 72 1A 50 0C      [ 1]    3 		bset PC_DDR,#LED2_BIT
      0000B4                        292 	_ledoff
      008134 72 1B 50 0A      [ 1]    1 		bres PC_ODR,#LED2_BIT
      008138 72 5F 00 01      [ 1]  293 	clr in.w ; must always be 0
                                    294 	; initialize free_ram_base variable
      00813C 90 AE 00 B2      [ 2]  295 	ldw y,#_user_ram ;#ram_free_base
                                    296 	; align on 16 bytes boundary
      008140 72 A9 00 0F      [ 2]  297 	addw y,#0xf
      008144 90 9F            [ 1]  298 	ld a,yl
      008146 A4 F0            [ 1]  299 	and a,#0xf0
      008148 90 97            [ 1]  300 	ld yl,a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]



      00814A 90 CF 00 56      [ 2]  301 	ldw ram_free_base,y
                                    302 	; initialize flash_free_base variable
      00814E 90 AE A9 A1      [ 2]  303 	ldw y,#mona_end
      008152 90 CF 00 58      [ 2]  304 	ldw flash_free_base,y
                                    305 ; active l'interruption sur PE_4 (bouton utilisateur)
      008156 72 18 50 18      [ 1]  306     bset PE_CR2,#USR_BTN_BIT
                                    307 
                                    308 ;------------------------
                                    309 ; program main function
                                    310 ;------------------------
      00815A                        311 main:	
                                    312 ; enable interrupts
      0000DA                        313 	_int_enable 
      00815A 9A               [ 1]    1 		 rim
                                    314 ; check for user application and run it 
                                    315 ; if there is one located at *flash_free_base*
      00815B 72 C6 00 58      [ 4]  316 	ld a,[flash_free_base]
      00815F 27 0F            [ 1]  317 	jreq 1$
      008161 90 AE 81 8F      [ 2]  318 	ldw y, #APP_MSG
      008165 CD 8F 39         [ 4]  319 	call uart_print
      008168 90 CE 00 58      [ 2]  320 	ldw y,flash_free_base
      00816C 90 5C            [ 1]  321 	incw y
      00816E 90 FC            [ 2]  322 	jp 	(y)	
                                    323 ; information printed at mcu reset.	
      008170 CD 80 B7         [ 4]  324 1$:	call print_mona_info
                                    325 ; Read Execute Print Loop
                                    326 ; MONA spend is time in this loop
      008173                        327 repl: 
                                    328 ; move terminal cursor to next line
      008173 A6 0A            [ 1]  329 	ld a,#NL 
      008175 CD 8F 2F         [ 4]  330 	call uart_tx
                                    331 ; print prompt sign	 
      008178 A6 3E            [ 1]  332 	ld a,#'>
      00817A CD 8F 2F         [ 4]  333 	call uart_tx
                                    334 ; read command line	
      00817D CD 83 44         [ 4]  335 	call readln 
                                    336 ;if empty line -> ignore it, loop.	
      008180 72 5D 00 03      [ 1]  337 	tnz count
      008184 27 ED            [ 1]  338 	jreq repl
                                    339 ; initialize parser and call eval function	  
      008186 72 5F 00 02      [ 1]  340 	clr in
      00818A CD 87 41         [ 4]  341 	call eval
                                    342 ; start over	
      00818D 20 E4            [ 2]  343 	jra repl  ; loop
                                    344 
      00818F 0A 41 70 70 6C 69 63   345 APP_MSG: .ascii "\nApplication dectected, running it.\n"
             61 74 69 6F 6E 20 64
             65 63 74 65 63 74 65
             64 2C 20 72 75 6E 6E
             69 6E 67 20 69 74 2E
             0A
      0081B3 50 72 65 73 73 20 55   346 		 .asciz "Press USER button to fallback to MONA shell.\n"
             53 45 52 20 62 75 74
             74 6F 6E 20 74 6F 20
             66 61 6C 6C 62 61 63
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal  6B-Bits]



             6B 20 74 6F 20 4D 4F
             4E 41 20 73 68 65 6C
             6C 2E 0A 00
                                    347 
                                    348 ;------------------------------------
                                    349 ;	interrupt NonHandledInterrupt
                                    350 ;   non handled interrupt reset MCU
                                    351 ;------------------------------------
      000161                        352 NonHandledInterrupt:
      0081D0 20 74            [ 1]  353 	ld a,#0x80
      0081D2 6F 20 4D         [ 1]  354 	ld WWDG_CR,a
                                    355 	;iret
                                    356 ;------------------------------------
                                    357 ; gestionnaire pour l'instrcution trap 
                                    358 ;------------------------------------
      000166                        359 TrapHandler:
                                    360 ; save sp for 'q' command resume.
      0081D5 4F 4E            [ 1]  361 	ldw y, sp 
      0081D7 41 20 73 68      [ 2]  362 	ldw trap_sp,y
      0081DB 65 6C 6C 2E      [ 2]  363 	ldw y, #SOFT_TRAP 
      0081DF 0A 00 00         [ 4]  364 	call uart_print 
      0081E1 CD 01 D4         [ 4]  365 	call print_registers
      0081E1 A6 80 C7 50      [ 1]  366 	bset flags,#F_TRAP 
                                    367 ; enable interrupts 
                                    368 ;	ld a,#(1<<CC_I1)
                                    369 ;	push a 
                                    370 ;	pop cc  
      0081E5 D1 00 F3         [ 2]  371 	jp repl
      0081E6                        372 app_resume:	
      0081E6 90               [11]  373 	iret
                                    374 
      0081E7 96 90 CF 00 54 90 AE   375 SOFT_TRAP: .asciz "Program interrupted by a software trap. 'q' to resume\n"
             81 FE CD 8F 39 CD 82
             54 72 10 00 B1 CC 81
             73 20 61 20 73 6F 66
             74 77 61 72 65 20 74
             72 61 70 2E 20 27 71
             27 20 74 6F 20 72 65
             73 75 6D 65 0A 00
                                    376 
                                    377 ;------------------------------------
                                    378 ;    user button interrupt handler
                                    379 ;    Cette interruption ne retourne pas
                                    380 ;    Après avoir affiché l'état des 
                                    381 ;    registres au moment de l'interruption
                                    382 ;    le pointeur de pile est réinitialiser
                                    383 ;    et un saut vers repl: est effectué.
                                    384 ;------------------------------------
      0081FD                        385 UserButtonHandler:
                                    386 	; attend que le bouton soit relâché
      0081FD 80 50 72         [ 2]  387 0$:	ldw x,0xffff
      008200 6F               [ 2]  388 1$: decw x 
      008201 67 72            [ 1]  389 	jrne 1$
      008203 61 6D 20 69 6E   [ 2]  390 	btjt USR_BTN_PORT,#USR_BTN_BIT, 2$
      008208 74 65            [ 2]  391 	jra 0$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]



      00820A 72 72 75 70      [ 2]  392 2$:	ldw y,#USER_ABORT
      00820E 74 65 64         [ 4]  393 	call uart_print
      008211 20 62 79         [ 4]  394     call print_registers 
      0001CC                        395 	_int_enable 
      008214 20               [ 1]    1 		 rim
      008215 61 20 73         [ 2]  396 	ldw x, #RAM_SIZE-1
      008218 6F               [ 1]  397 	ldw sp, x
      008219 66 74 77         [ 2]  398 	jp repl
                                    399 
                                    400 
                                    401 ; affiche les registres sauvegardés
                                    402 ; par l'interruption sur la pile.
      0001D4                        403 print_registers:
      00821C 61 72 65 20      [ 2]  404 	ldw y,#STATES
      008220 74 72 61         [ 4]  405 	call uart_print
                                    406 ; print EPC 
      008223 70 2E 20 27      [ 2]  407 	ldw y, #REG_EPC
      008227 71 27 20         [ 4]  408 	call uart_print 
      00822A 74 6F            [ 1]  409 	ld a, (11,sp)
      00822C 20 72 65         [ 1]  410 	ld acc24+2,a 
      00822F 73 75            [ 1]  411 	ld a, (10,sp) 
      008231 6D 65 0A         [ 1]  412 	ld acc24+1,a 
      008234 00 09            [ 1]  413 	ld a,(9,sp) 
      008235 C7 00 00         [ 1]  414 	ld acc24,a
      008235 CE               [ 1]  415 	clrw x  
      008236 FF FF            [ 1]  416 	ld a,#16
      008238 5A 26 FD         [ 4]  417 	call print_int  
                                    418 ; print Y 
      00823B 72 08 50 15      [ 2]  419 	ldw y,#REG_Y
      00823F 02 20 F3         [ 4]  420 	call uart_print 
      008242 90 AE 82 D3      [ 1]  421 	clr acc24 
      008246 CD 8F            [ 1]  422 	ld a,(8,sp)
      008248 39 CD 82         [ 1]  423 	ld acc24+2,a 
      00824B 54 9A            [ 1]  424 	ld a,(7,sp)
      00824D AE 17 FF         [ 1]  425 	ld acc24+1,a 
      008250 94 CC            [ 1]  426 	ld a,#16 
      008252 81 73 00         [ 4]  427 	call print_int 
                                    428 ; print X
      008254 90 AE 02 B4      [ 2]  429 	ldw y,#REG_X
      008254 90 AE 82         [ 4]  430 	call uart_print  
      008257 ED CD            [ 1]  431 	ld a,(6,sp)
      008259 8F 39 90         [ 1]  432 	ld acc24+2,a 
      00825C AE 83            [ 1]  433 	ld a,(5,sp)
      00825E 29 CD 8F         [ 1]  434 	ld acc24+1,a 
      008261 39 7B            [ 1]  435 	ld a,#16 
      008263 0B C7 00         [ 4]  436 	call print_int 
                                    437 ; print A 
      008266 AD 7B 0A C7      [ 2]  438 	ldw y,#REG_A 
      00826A 00 AC 7B         [ 4]  439 	call uart_print 
      00826D 09 C7 00 AB      [ 1]  440 	clr acc24+1
      008271 5F A6            [ 1]  441 	ld a, (4,sp) 
      008273 10 CD 8F         [ 1]  442 	ld acc24+2,a 
      008276 9D 90            [ 1]  443 	ld a,#16
      008278 AE 83 2F         [ 4]  444 	call print_int 
                                    445 ; print CC 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
Hexadecimal [24-Bits]



      00827B CD 8F 39 72      [ 2]  446 	ldw y,#REG_CC 
      00827F 5F 00 AB         [ 4]  447 	call uart_print 
      008282 7B 08            [ 1]  448 	ld a, (3,sp) 
      008284 C7 00 AD         [ 1]  449 	ld acc24+2,a
      008287 7B 07            [ 1]  450 	ld a,#16  
      008289 C7 00 AC         [ 4]  451 	call print_int 
      00828C A6 10            [ 1]  452 	ld a,#'\n' 
      00828E CD 8F 9D         [ 4]  453 	call uart_tx  
      008291 90               [ 4]  454 	ret
                                    455 
      008292 AE 83 34 CD 8F 39 7B   456 USER_ABORT: .asciz "Program aborted by user.\n"
             06 C7 00 AD 7B 05 C7
             00 AC A6 10 CD 8F 9D
             90 AE 83 39 CD
      0082AC 8F 39 72 5F 00 AC 7B   457 STATES:  .asciz "Registers state at abort point.\n--------------------------\n"
             04 C7 00 AD A6 10 CD
             8F 9D 90 AE 83 3E CD
             8F 39 7B 03 C7 00 AD
             A6 10 CD 8F 9D A6 0A
             CD 8F 2F 81 50 72 6F
             67 72 61 6D 20 61 62
             6F 72 74 65 64 20 62
             79 20 75 73
      0082E8 65 72 2E 0A 00 52      458 REG_EPC: .asciz "EPC: "
      0082EE 65 67 69 73 74         459 REG_Y:   .asciz "\nY: " 
      0082F3 65 72 73 20 73         460 REG_X:   .asciz "\nX: "
      0082F8 74 61 74 65 20         461 REG_A:   .asciz "\nA: " 
      0082FD 61 74 20 61 62 6F      462 REG_CC:  .asciz "\nCC: "
                                    463 
                                    464 ;------------------------------------
                                    465 ; TIMER4 interrupt service routine
                                    466 ;------------------------------------
                                    467 ;timer4_isr:
                                    468 ;	ldw y,ticks
                                    469 ;	incw y
                                    470 ;	ldw ticks,y
                                    471 ;	ldw y,cntdwn
                                    472 ;	jreq 1$
                                    473 ;	decw y
                                    474 ;	ldw cntdwn,y
                                    475 ;1$: bres TIM4_SR,#TIM4_SR_UIF
                                    476 ;	iret
                                    477 
                                    478 ;------------------------------------
                                    479 ; uart3 receive interrupt service
                                    480 ;------------------------------------
                                    481 ;uart_rx_isr:
                                    482 ; local variables
                                    483 ;  UART_STATUS = 2
                                    484 ;  UART_DATA = 1
                                    485 ; read uart registers and save them in local variables  
                                    486 ;  ld a, UART3_SR
                                    487 ;  push a  ; local variable UART_STATUS
                                    488 ;  ld a,UART3_DR
                                    489 ;  push a ; local variable UART_DATA
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]



                                    490 ; test uart status register
                                    491 ; bit RXNE must 1
                                    492 ; bits OR|FE|NF must be 0	
                                    493 ;  ld a, (UART_STATUS,sp)
                                    494 ; keep only significant bits
                                    495 ;  and a, #((1<<UART_SR_RXNE)|(1<<UART_SR_OR)|(1<<UART_SR_FE)|(1<<UART_SR_NF))
                                    496 ; A value shoudl be == (1<<UART_SR_RNXE)  
                                    497 ;  cp a, #(1<<UART_SR_RXNE)
                                    498 ;  jrne 1$
                                    499 ; no receive error accept it.  
                                    500 ;  ld a,(UART_DATA,sp)
                                    501 ;  ld rx_char,a
                                    502 ;1$: 
                                    503 ; drop local variables
                                    504 ;  popw X	
                                    505 ;  iret
                                    506 
                                    507 ;------------------------------------
                                    508 ; read a line of text from terminal
                                    509 ; input:
                                    510 ;	none
                                    511 ; local variable on stack:
                                    512 ;	LEN (1,sp)
                                    513 ;   RXCHAR (2,sp)
                                    514 ; output:
                                    515 ;   text in tib  buffer
                                    516 ;   len in count variable
                                    517 ;------------------------------------
                                    518 	; local variables
                           000001   519 	LEN = 1  ; accepted line length
                           000002   520 	RXCHAR = 2 ; last char received
      0002C4                        521 readln::
      008303 72 74            [ 1]  522 	push #0  ; RXCHAR 
      008305 20 70            [ 1]  523 	push #0  ; LEN
      008307 6F 69 6E 74      [ 2]  524  	ldw y,#tib ; input buffer
      0002CC                        525 readln_loop:
      00830B 2E 0A 2D         [ 4]  526 	call uart_getchar
      00830E 2D 2D            [ 1]  527 	ld (RXCHAR,sp),a
      008310 2D 2D            [ 1]  528 	cp a,#CTRL_C
      008312 2D 2D            [ 1]  529 	jrne 2$
      008314 2D 2D 2D         [ 2]  530 	jp cancel
      008317 2D 2D            [ 1]  531 2$:	cp a,#CTRL_R
      008319 2D 2D            [ 1]  532 	jreq reprint
      00831B 2D 2D            [ 1]  533 	cp a,#CR
      00831D 2D 2D            [ 1]  534 	jrne 1$
      00831F 2D 2D 2D         [ 2]  535 	jp readln_quit
      008322 2D 2D            [ 1]  536 1$:	cp a,#NL
      008324 2D 2D            [ 1]  537 	jreq readln_quit
      008326 2D 0A            [ 1]  538 	cp a,#BSP
      008328 00 45            [ 1]  539 	jreq del_back
      00832A 50 43            [ 1]  540 	cp a,#CTRL_D
      00832C 3A 20            [ 1]  541 	jreq del_line
      00832E 00 0A            [ 1]  542 	cp a,#SPACE
      008330 59 3A            [ 1]  543 	jrpl accept_char
      008332 20 00            [ 2]  544 	jra readln_loop
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]



      0002F5                        545 del_line:
      008334 0A 58            [ 1]  546 	ld a,(LEN,sp)
      008336 3A 20 00         [ 4]  547 	call uart_delete
      008339 0A 41 3A 20      [ 2]  548 	ldw y,#tib
      00833D 00 0A 43 43      [ 1]  549 	clr count
      008341 3A 20            [ 1]  550 	clr (LEN,sp)
      008343 00 C6            [ 2]  551 	jra readln_loop
      008344                        552 del_back:
      008344 4B 00            [ 1]  553     tnz (LEN,sp)
      008346 4B 00            [ 1]  554     jreq readln_loop
      008348 90 AE            [ 1]  555     dec (LEN,sp)
      00834A 00 04            [ 2]  556     decw y
      00834C 90 7F            [ 1]  557     clr  (y)
      00834C CD 8F            [ 1]  558     ld a,#1
      00834E 5C 6B 02         [ 4]  559     call uart_delete
      008351 A1 03            [ 2]  560     jra readln_loop	
      000317                        561 accept_char:
      008353 26 03            [ 1]  562 	ld a,#TIB_SIZE-1
      008355 CC 83            [ 1]  563 	cp a, (1,sp)
      008357 D0 A1            [ 1]  564 	jreq readln_loop
      008359 12 27            [ 1]  565 	ld a,(RXCHAR,sp)
      00835B 50 A1            [ 1]  566 	ld (y),a
      00835D 0D 26            [ 1]  567 	inc (LEN,sp)
      00835F 03 CC            [ 1]  568 	incw y
      008361 83 DA            [ 1]  569 	clr (y)
      008363 A1 0A 27         [ 4]  570 	call uart_tx
      008366 73 A1            [ 2]  571 	jra readln_loop
      00032C                        572 reprint:
      008368 08 27            [ 1]  573 	tnz (LEN,sp)
      00836A 1B A1            [ 1]  574 	jrne readln_loop
      00836C 04 27 06 A1      [ 1]  575 	tnz count
      008370 20 2A            [ 1]  576 	jreq readln_loop
      008372 24 20 D7 03      [ 2]  577 	ldw y,#tib
      008375 90 89            [ 2]  578 	pushw y
      008375 7B 01 CD         [ 4]  579 	call uart_print
      008378 8F 6F            [ 2]  580 	popw y
      00837A 90 AE 00         [ 1]  581 	ld a,count
      00837D 04 72            [ 1]  582 	ld (LEN,sp),a
      00837F 5F 00            [ 1]  583 	ld a,yl
      008381 03 0F 01         [ 1]  584 	add a,count
      008384 20 C6            [ 1]  585 	ld yl,a
      008386 CC 02 CC         [ 2]  586 	jp readln_loop
      000350                        587 cancel:
      008386 0D 01 27 C2      [ 1]  588 	clr tib
      00838A 0A 01 90 5A      [ 1]  589 	clr count
      00838E 90 7F            [ 2]  590 	jra readln_quit2
      00035A                        591 readln_quit:
      008390 A6 01            [ 1]  592 	ld a,(LEN,sp)
      008392 CD 8F 6F         [ 1]  593 	ld count,a
      00035F                        594 readln_quit2:
      008395 20 B5            [ 2]  595 	addw sp,#2
      008397 A6 0A            [ 1]  596 	ld a,#NL
      008397 A6 4F 11         [ 4]  597 	call uart_tx
      00839A 01               [ 4]  598 	ret
                                    599 	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 63.
Hexadecimal [24-Bits]



                                    600 ;------------------------------------
                                    601 ; skip character c in tib starting from 'in'
                                    602 ; input:
                                    603 ;	 y 		point to tib 
                                    604 ;    a 		character to skip
                                    605 ; output:  
                                    606 ;	'in' ajusted to new position
                                    607 ;------------------------------------
                           000001   608 	C = 1 ; local var
      000367                        609 skip:
      00839B 27               [ 1]  610 	push a
      00839C AF 7B 02         [ 4]  611 1$:	ld a,([in.w],y)
      00839F 90 F7            [ 1]  612 	jreq 2$
      0083A1 0C 01            [ 1]  613 	cp a,(C,sp)
      0083A3 90 5C            [ 1]  614 	jrne 2$
      0083A5 90 7F CD 8F      [ 1]  615 	inc in
      0083A9 2F 20            [ 2]  616 	jra 1$
      0083AB A0               [ 1]  617 2$: pop a
      0083AC 81               [ 4]  618 	ret
                                    619 	
                                    620 ;------------------------------------
                                    621 ; scan tib for charater 'c' starting from 'in'
                                    622 ; input:
                                    623 ;	y  point to tib 
                                    624 ;	a character to skip
                                    625 ; output:
                                    626 ;	in point to chacter 'c'
                                    627 ;------------------------------------
                           000001   628 	C = 1 ; local var
      000379                        629 scan: 
      0083AC 0D               [ 1]  630 	push a
      0083AD 01 26 9C         [ 4]  631 1$:	ld a,([in.w],y)
      0083B0 72 5D            [ 1]  632 	jreq 2$
      0083B2 00 03            [ 1]  633 	cp a,(C,sp)
      0083B4 27 96            [ 1]  634 	jreq 2$
      0083B6 90 AE 00 04      [ 1]  635 	inc in
      0083BA 90 89            [ 2]  636 	jra 1$
      0083BC CD               [ 1]  637 2$: pop a
      0083BD 8F               [ 4]  638 	ret
                                    639 
                                    640 ;------------------------------------
                                    641 ; parse quoted string 
                                    642 ; input:
                                    643 ;   Y 	pointer to tib 
                                    644 ;   X   pointer to tab 
                                    645 ; output:
                                    646 ;	pad   containt string 
                                    647 ;------------------------------------
                           000001   648 	PREV = 1
                           000002   649 	CURR= 2
                           000002   650 	VSIZE=2
      00038B                        651 parse_quote:
      0083BE 39 90            [ 2]  652 	sub sp,#VSIZE
      0083C0 85               [ 1]  653 	clr a
      0083C1 C6 00            [ 1]  654 1$:	ld (PREV,sp),a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 64.
Hexadecimal [24-Bits]



      0083C3 03 6B 01 90      [ 1]  655 2$:	inc in
      0083C7 9F CB 00         [ 4]  656 	ld a,([in.w],y)
      0083CA 03 90            [ 1]  657 	jreq 6$
      0083CC 97 CC            [ 1]  658 	ld (CURR,sp),a 
      0083CE 83 4C            [ 1]  659 	ld a,#'\
      0083D0 11 01            [ 1]  660 	cp a, (PREV,sp)
      0083D0 72 5F            [ 1]  661 	jrne 3$
      0083D2 00 04            [ 1]  662 	clr (PREV,sp)
      0083D4 72 5F            [ 4]  663 	callr convert_escape
      0083D6 00               [ 1]  664 	ld (x),a 
      0083D7 03               [ 1]  665 	incw x 
      0083D8 20 05            [ 2]  666 	jra 2$
      0083DA 7B 02            [ 1]  667 3$: ld a,(CURR,sp)
      0083DA 7B 01            [ 1]  668 	cp a,#'\ 
      0083DC C7 00            [ 1]  669 	jreq 1$  
      0083DE 03 22            [ 1]  670 	cp a,#'"
      0083DF 27 04            [ 1]  671 	jreq 5$
      0083DF 5B               [ 1]  672 	ld (x),a 
      0083E0 02               [ 1]  673 	incw x 
      0083E1 A6 0A            [ 2]  674 	jra 2$
      0083E3 CD 8F 2F 81      [ 1]  675 5$:	inc in 
      0083E7 7F               [ 1]  676 6$:	clr (x)
      0083E7 88 91            [ 2]  677 	addw sp,#VSIZE  
      0083E9 D6               [ 4]  678 	ret 
                                    679 
                                    680 ;---------------------------------------
                                    681 ; called by parse_quote
                                    682 ; subtitute escaped character 
                                    683 ; by their ASCII value .
                                    684 ; input:
                                    685 ;   A  character following '\'
                                    686 ; output:
                                    687 ;   A  substitued char or same if not valid.
                                    688 ;---------------------------------------
      0003BF                        689 convert_escape:
      0083EA 01 27            [ 1]  690 	cp a,#'a'
      0083EC 0A 11            [ 1]  691 	jrne 1$
      0083EE 01 26            [ 1]  692 	ld a,#7
      0083F0 06               [ 4]  693 	ret 
      0083F1 72 5C            [ 1]  694 1$: cp a,#'b'
      0083F3 00 02            [ 1]  695 	jrne 2$
      0083F5 20 F1            [ 1]  696 	ld a,#8
      0083F7 84               [ 4]  697 	ret 
      0083F8 81 65            [ 1]  698 2$: cp a,#'e' 
      0083F9 26 03            [ 1]  699     jrne 3$
      0083F9 88 91            [ 1]  700 	ld a,#'\'
      0083FB D6               [ 4]  701 	ret  
      0083FC 01 27            [ 1]  702 3$: cp a,#'\'
      0083FE 0A 11            [ 1]  703 	jrne 4$
      008400 01 27            [ 1]  704 	ld a,#'\'
      008402 06               [ 4]  705 	ret 
      008403 72 5C            [ 1]  706 4$: cp a,#'f' 
      008405 00 02            [ 1]  707 	jrne 5$ 
      008407 20 F1            [ 1]  708 	ld a,#FF 
      008409 84               [ 4]  709 	ret  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 65.
Hexadecimal [24-Bits]



      00840A 81 6E            [ 1]  710 5$: cp a,#'n' 
      00840B 26 03            [ 1]  711     jrne 6$ 
      00840B 52 02            [ 1]  712 	ld a,#0xa 
      00840D 4F               [ 4]  713 	ret  
      00840E 6B 01            [ 1]  714 6$: cp a,#'r' 
      008410 72 5C            [ 1]  715 	jrne 7$
      008412 00 02            [ 1]  716 	ld a,#0xd 
      008414 91               [ 4]  717 	ret  
      008415 D6 01            [ 1]  718 7$: cp a,#'t' 
      008417 27 22            [ 1]  719 	jrne 8$ 
      008419 6B 02            [ 1]  720 	ld a,#9 
      00841B A6               [ 4]  721 	ret  
      00841C 5C 11            [ 1]  722 8$: cp a,#'v' 
      00841E 01 26            [ 1]  723 	jrne 9$  
      008420 08 0F            [ 1]  724 	ld a,#0xb 
      008422 01               [ 4]  725 9$:	ret 
                                    726 
                                    727 ;------------------------------------
                                    728 ; Command line tokenizer
                                    729 ; scan tib for next word
                                    730 ; move token in 'pad'
                                    731 ; use:
                                    732 ;	Y   pointer to tib 
                                    733 ;   X	pointer to pad 
                                    734 ;   in.w   index in tib
                                    735 ; output:
                                    736 ;   pad 	token as .asciz  
                                    737 ;------------------------------------
      0003FE                        738 next_word::
      008423 AD               [ 2]  739 	pushw x 
      008424 1A F7            [ 2]  740 	pushw y 
      008426 5C 20 E7         [ 2]  741 	ldw x, #pad 
      008429 7B 02 A1 5C      [ 2]  742 	ldw y, #tib  	
      00842D 27 DF            [ 1]  743 	ld a,#SPACE
      00842F A1 22 27         [ 4]  744 	call skip
      008432 04 F7 5C         [ 4]  745 	ld a,([in.w],y)
      008435 20 D9            [ 1]  746 	jreq 8$
      008437 72 5C            [ 1]  747 	cp a,#'"
      008439 00 02            [ 1]  748 	jrne 1$
      00843B 7F               [ 1]  749 	ld (x),a 
      00843C 5B               [ 1]  750 	incw x 
      00843D 02 81 8B         [ 4]  751 	call parse_quote
      00843F 20 13            [ 2]  752 	jra 9$
      00843F A1 61            [ 1]  753 1$: cp a,#SPACE
      008441 26 03            [ 1]  754 	jreq 8$
      008443 A6 07 81         [ 4]  755 	call to_lower 
      008446 A1               [ 1]  756 	ld (x),a 
      008447 62               [ 1]  757 	incw x 
      008448 26 03 A6 08      [ 1]  758 	inc in
      00844C 81 A1 65         [ 4]  759 	ld a,([in.w],y) 
      00844F 26 03            [ 1]  760 	jrne 1$
      008451 A6               [ 1]  761 8$: clr (x)
      008452 5C 81            [ 2]  762 9$:	popw y 
      008454 A1               [ 2]  763 	popw x 
      008455 5C               [ 4]  764 	ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 66.
Hexadecimal [24-Bits]



                                    765 
                                    766 ;----------------------------------
                                    767 ; convert to lower case
                                    768 ; input: 
                                    769 ;   A 		character to convert
                                    770 ; output:
                                    771 ;   A		result 
                                    772 ;----------------------------------
      000434                        773 to_lower::
      008456 26 03            [ 1]  774 	cp a,#'A
      008458 A6 5C            [ 1]  775 	jrult 9$
      00845A 81 A1            [ 1]  776 	cp a,#'Z 
      00845C 66 26            [ 1]  777 	jrugt 9$
      00845E 03 A6            [ 1]  778 	add a,#32
      008460 0C               [ 4]  779 9$: ret
                                    780 
                                    781 ;------------------------------------
                                    782 ; convert alpha to uppercase
                                    783 ; input:
                                    784 ;    a  character to convert
                                    785 ; output:
                                    786 ;    a  uppercase character
                                    787 ;------------------------------------
      00043F                        788 to_upper::
      008461 81 A1            [ 1]  789 	cp a,#'a
      008463 6E 26            [ 1]  790 	jrpl 1$
      008465 03               [ 4]  791 0$:	ret
      008466 A6 0A            [ 1]  792 1$: cp a,#'z	
      008468 81 A1            [ 1]  793 	jrugt 0$
      00846A 72 26            [ 1]  794 	sub a,#32
      00846C 03               [ 4]  795 	ret
                                    796 	
                                    797 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    798 ;        arithmetic operations
                                    799 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    800 
                                    801 ;--------------------------------------
                                    802 ;	24 bit integers addition
                                    803 ; input:
                                    804 ;	X 		*v1 
                                    805 ;	Y 		*v2 
                                    806 ; output:
                                    807 ;	X 		*v1+=*v2 
                                    808 ;--------------------------------------
      00044B                        809 add24::
      00846D A6 0D            [ 1]  810 	ld a,(2,x)
      00846F 81 A1 74         [ 1]  811 	add a,(2,y)
      008472 26 03            [ 1]  812 	ld (2,x),a 
      008474 A6 09            [ 1]  813 	ld a,(1,x)
      008476 81 A1 76         [ 1]  814 	adc a,(1,y)
      008479 26 02            [ 1]  815 	ld (1,x),a 
      00847B A6               [ 1]  816 	ld a,(x)
      00847C 0B 81            [ 1]  817 	adc a,(y)
      00847E F7               [ 1]  818 	ld (x),a 
      00847E 89               [ 4]  819 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 67.
Hexadecimal [24-Bits]



                                    820 
                                    821 
                                    822 ;--------------------------------------
                                    823 ; unsigned multiply uint24_t by uint8_t
                                    824 ; use to convert numerical string to uint24_t
                                    825 ; input:
                                    826 ;	acc24	uint24_t 
                                    827 ;   A		uint8_t
                                    828 ; output:
                                    829 ;   acc24   A*acc24
                                    830 ;-------------------------------------
                                    831 ; local variables offset  on sp
                           000003   832 	U8   = 3   ; A pushed on stack
                           000002   833 	OVFL = 2  ; multiplicaton overflow low byte
                           000001   834 	OVFH = 1  ; multiplication overflow high byte
                           000003   835 	LOCAL_SIZE = 3
      00045E                        836 mulu24_8::
      00847F 90               [ 2]  837 	pushw x    ; save X
                                    838 	; local variables
      008480 89               [ 1]  839 	push a     ; U8
      008481 AE               [ 1]  840 	clrw x     ; initialize overflow to 0
      008482 00               [ 2]  841 	pushw x    ; multiplication overflow
                                    842 ; multiply low byte.
      008483 5B 90 AE         [ 1]  843 	ld a,acc24+2
      008486 00               [ 1]  844 	ld xl,a
      008487 04 A6            [ 1]  845 	ld a,(U8,sp)
      008489 20               [ 4]  846 	mul x,a
      00848A CD               [ 1]  847 	ld a,xl
      00848B 83 E7 91         [ 1]  848 	ld acc24+2,a
      00848E D6               [ 1]  849 	ld a, xh
      00848F 01 27            [ 1]  850 	ld (OVFL,sp),a
                                    851 ; multipy middle byte
      008491 1D A1 22         [ 1]  852 	ld a,acc24+1
      008494 26               [ 1]  853 	ld xl,a
      008495 07 F7            [ 1]  854 	ld a, (U8,sp)
      008497 5C               [ 4]  855 	mul x,a
                                    856 ; add overflow to this partial product
      008498 CD 84 0B         [ 2]  857 	addw x,(OVFH,sp)
      00849B 20               [ 1]  858 	ld a,xl
      00849C 13 A1 20         [ 1]  859 	ld acc24+1,a
      00849F 27               [ 1]  860 	clr a
      0084A0 0E CD            [ 1]  861 	adc a,#0
      0084A2 84 B4            [ 1]  862 	ld (OVFH,sp),a
      0084A4 F7               [ 1]  863 	ld a,xh
      0084A5 5C 72            [ 1]  864 	ld (OVFL,sp),a
                                    865 ; multiply most signficant byte	
      0084A7 5C 00 02         [ 1]  866 	ld a, acc24
      0084AA 91               [ 1]  867 	ld xl, a
      0084AB D6 01            [ 1]  868 	ld a, (U8,sp)
      0084AD 26               [ 4]  869 	mul x,a
      0084AE EE 7F 90         [ 2]  870 	addw x, (OVFH,sp)
      0084B1 85               [ 1]  871 	ld a, xl
      0084B2 85 81 00         [ 1]  872 	ld acc24,a
      0084B4 5B 03            [ 2]  873     addw sp,#LOCAL_SIZE
      0084B4 A1               [ 2]  874 	popw x
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 68.
Hexadecimal [24-Bits]



      0084B5 41               [ 4]  875 	ret
                                    876 
                                    877 ;-------------------------------------
                                    878 ; divide uint24_t by uint8_t
                                    879 ; used to convert uint24_t to string
                                    880 ; input:
                                    881 ;	acc24	dividend
                                    882 ;   A 		divisor
                                    883 ; output:
                                    884 ;   acc24	quotient
                                    885 ;   A		remainder
                                    886 ;------------------------------------- 
                                    887 ; offset  on sp of arguments and locals
                           000001   888 	U8   = 1   ; divisor on stack
                           000001   889 	LOCAL_SIZE =1
      000498                        890 divu24_8::
      0084B6 25               [ 2]  891 	pushw x ; save x
      0084B7 06               [ 1]  892 	push a 
                                    893 	; ld dividend UU:MM bytes in X
      0084B8 A1 5A 22         [ 1]  894 	ld a, acc24
      0084BB 02               [ 1]  895 	ld xh,a
      0084BC AB 20 81         [ 1]  896 	ld a,acc24+1
      0084BF 97               [ 1]  897 	ld xl,a
      0084BF A1 61            [ 1]  898 	ld a,(U8,SP) ; divisor
      0084C1 2A               [ 2]  899 	div x,a ; UU:MM/U8
      0084C2 01               [ 1]  900 	push a  ;save remainder
      0084C3 81               [ 1]  901 	ld a,xh
      0084C4 A1 7A 22         [ 1]  902 	ld acc24,a
      0084C7 FB               [ 1]  903 	ld a,xl
      0084C8 A0 20 81         [ 1]  904 	ld acc24+1,a
      0084CB 84               [ 1]  905 	pop a
      0084CB E6               [ 1]  906 	ld xh,a
      0084CC 02 90 EB         [ 1]  907 	ld a,acc24+2
      0084CF 02               [ 1]  908 	ld xl,a
      0084D0 E7 02            [ 1]  909 	ld a,(U8,sp) ; divisor
      0084D2 E6               [ 2]  910 	div x,a  ; R:LL/U8
      0084D3 01 90            [ 1]  911 	ld (U8,sp),a ; save remainder
      0084D5 E9               [ 1]  912 	ld a,xl
      0084D6 01 E7 01         [ 1]  913 	ld acc24+2,a
      0084D9 F6               [ 1]  914 	pop a
      0084DA 90               [ 2]  915 	popw x
      0084DB F9               [ 4]  916 	ret
                                    917 
                                    918 ;------------------------------------
                                    919 ;  two's complement acc24
                                    920 ;  input:
                                    921 ;		acc24 variable
                                    922 ;  output:
                                    923 ;		acc24 variable
                                    924 ;-------------------------------------
      0004C0                        925 neg_acc24::
      0084DC F7 81 00 02      [ 1]  926 	cpl acc24+2
      0084DE 72 53 00 01      [ 1]  927 	cpl acc24+1
      0084DE 89 88 5F 89      [ 1]  928 	cpl acc24
      0084E2 C6 00            [ 1]  929 	ld a,#1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 69.
Hexadecimal [24-Bits]



      0084E4 AD 97 7B         [ 1]  930 	add a,acc24+2
      0084E7 03 42 9F         [ 1]  931 	ld acc24+2,a
      0084EA C7               [ 1]  932 	clr a
      0084EB 00 AD 9E         [ 1]  933 	adc a,acc24+1
      0084EE 6B 02 C6         [ 1]  934 	ld acc24+1,a 
      0084F1 00               [ 1]  935 	clr a 
      0084F2 AC 97 7B         [ 1]  936 	adc a,acc24 
      0084F5 03 42 72         [ 1]  937 	ld acc24,a 
      0084F8 FB               [ 4]  938 	ret
                                    939 
                                    940 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    941 ; incremente acc24 
                                    942 ; input:
                                    943 ;   X 		adresse de la variable 
                                    944 ;   A		incrément
                                    945 ; output:
                                    946 ;	aucun 
                                    947 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004E3                        948 inc_var24::
      0084F9 01 9F            [ 1]  949 	add a, (2,x)
      0084FB C7 00            [ 1]  950 	ld (2,x),a
      0084FD AC               [ 1]  951 	clr a
      0084FE 4F A9            [ 1]  952 	adc a,(1,x)
      008500 00 6B            [ 1]  953 	ld (1,x),a 
      008502 01               [ 1]  954 	clr a 
      008503 9E               [ 1]  955 	adc a,(x)
      008504 6B               [ 1]  956 	ld (x),a
      008505 02               [ 4]  957 	ret 
                                    958 	
                                    959 
                                    960 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    961 ; copy 24 bits variable 
                                    962 ; input:
                                    963 ;	X 		address var source
                                    964 ;   y		address var destination
                                    965 ; output:
                                    966 ;   dest = src
                                    967 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0004F0                        968 copy_var24::
      008506 C6 00            [ 1]  969 	ld a,(0,x)
      008508 AB 97 7B         [ 1]  970 	ld (0,y),a 
      00850B 03 42            [ 1]  971 	ld a,(1,x)
      00850D 72 FB 01         [ 1]  972 	ld (1,y),a 
      008510 9F C7            [ 1]  973 	ld a,(2,x)
      008512 00 AB 5B         [ 1]  974 	ld (2,y),a 
      008515 03               [ 4]  975 	ret
                                    976 
                                    977 ;------------------------------------
                                    978 ; check if A containt an ASCII letter.
                                    979 ; input:
                                    980 ;    A 		character to test 
                                    981 ; output:
                                    982 ;    A 		same 
                                    983 ;    C      0 not letter, 1 letter 
                                    984 ;------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 70.
Hexadecimal [24-Bits]



      000500                        985 is_alpha::
      008516 85               [ 1]  986 	push a 
      008517 81 20            [ 1]  987 	or a,#32
      008518 A1 61            [ 1]  988 	cp a,#'a 
      008518 89 88            [ 1]  989 	jrult not_alpha
      00851A C6 00            [ 1]  990 	cp a,#'z 
      00851C AB 95            [ 1]  991 	jrugt not_alpha 
      00851E C6               [ 1]  992 	scf 
      00851F 00               [ 1]  993 	pop a 
      008520 AC               [ 4]  994 	ret 
      00050E                        995 not_alpha:
      008521 97               [ 1]  996 	rcf 
      008522 7B               [ 1]  997 	pop a 
      008523 01               [ 4]  998 	ret 
                                    999 
                                   1000 
                                   1001 ;------------------------------------
                                   1002 ; check if character in {'0'..'9'}
                                   1003 ; input:
                                   1004 ;    A  character to test
                                   1005 ; output:
                                   1006 ;    A  0|1
                                   1007 ;------------------------------------
      000511                       1008 is_digit::
      008524 62 88            [ 1] 1009 	cp a,#'0
      008526 9E C7            [ 1] 1010 	jrpl 1$
      008528 00               [ 1] 1011 0$:	clr a
      008529 AB               [ 4] 1012 	ret
      00852A 9F C7            [ 1] 1013 1$: cp a,#'9
      00852C 00 AC            [ 1] 1014     jrugt 0$
      00852E 84 95            [ 1] 1015     ld a,#1
      008530 C6               [ 4] 1016     ret
                                   1017 	
                                   1018 ;------------------------------------
                                   1019 ; check if character in {'0'..'9','A'..'F'}
                                   1020 ; input:
                                   1021 ;   a  character to test
                                   1022 ; output:
                                   1023 ;   a   0|1 
                                   1024 ;------------------------------------
      00051E                       1025 is_hex::
      008531 00               [ 1] 1026 	push a
      008532 AD 97 7B         [ 4] 1027 	call is_digit
      008535 01 62            [ 1] 1028 	cp a,#1
      008537 6B 01            [ 1] 1029 	jrne 1$
      008539 9F C7            [ 2] 1030 	addw sp,#1
      00853B 00               [ 4] 1031 	ret
      00853C AD               [ 1] 1032 1$:	pop a
      00853D 84 85            [ 1] 1033 	cp a,#'a
      00853F 81 02            [ 1] 1034 	jrmi 2$
      008540 A0 20            [ 1] 1035 	sub a,#32
      008540 72 53            [ 1] 1036 2$: cp a,#'A
      008542 00 AD            [ 1] 1037     jrpl 3$
      008544 72               [ 1] 1038 0$: clr a
      008545 53               [ 4] 1039     ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 71.
Hexadecimal [24-Bits]



      008546 00 AC            [ 1] 1040 3$: cp a,#'F
      008548 72 53            [ 1] 1041     jrugt 0$
      00854A 00 AB            [ 1] 1042     ld a,#1
      00854C A6               [ 4] 1043     ret
                                   1044             	
                                   1045 ;------------------------------------
                                   1046 ; convert pad content in integer
                                   1047 ; input:
                                   1048 ;    pad		.asciz to convert
                                   1049 ; output:
                                   1050 ;    acc24      int24_t
                                   1051 ;------------------------------------
                                   1052 	; local variables
                           000001  1053 	SIGN=1 ; 1 byte, 
                           000002  1054 	BASE=2 ; 1 byte, numeric base used in conversion
                           000003  1055 	TEMP=3 ; 1 byte, temporary storage
                           000003  1056 	LOCAL_SIZE=3 ; 3 bytes reserved for local storage
      00053D                       1057 atoi::
      00854D 01               [ 2] 1058 	pushw x ;save x
      00854E CB 00            [ 2] 1059 	sub sp,#LOCAL_SIZE
                                   1060 	; acc24=0 
      008550 AD C7 00 AD      [ 1] 1061 	clr acc24    
      008554 4F C9 00 AC      [ 1] 1062 	clr acc16
      008558 C7 00 AC 4F      [ 1] 1063 	clr acc8 
      00855C C9 00 AB         [ 1] 1064 	ld a, pad 
      00855F C7 00            [ 1] 1065 	jreq atoi_exit
      008561 AB 81            [ 1] 1066 	clr (SIGN,sp)
      008563 A6 0A            [ 1] 1067 	ld a,#10
      008563 EB 02            [ 1] 1068 	ld (BASE,sp),a ; default base decimal
      008565 E7 02 4F         [ 2] 1069 	ldw x,#pad ; pointer to string to convert
      008568 E9               [ 1] 1070 	ld a,(x)
      008569 01 E7            [ 1] 1071 	jreq 9$  ; completed if 0
      00856B 01 4F            [ 1] 1072 	cp a,#'-
      00856D F9 F7            [ 1] 1073 	jrne 1$
      00856F 81 01            [ 1] 1074 	cpl (SIGN,sp)
      008570 20 08            [ 2] 1075 	jra 2$
      008570 E6 00            [ 1] 1076 1$: cp a,#'$
      008572 90 E7            [ 1] 1077 	jrne 3$
      008574 00 E6            [ 1] 1078 	ld a,#16
      008576 01 90            [ 1] 1079 	ld (BASE,sp),a
      008578 E7               [ 1] 1080 2$:	incw x
      008579 01               [ 1] 1081 	ld a,(x)
      00056F                       1082 3$:	
      00857A E6 02            [ 1] 1083 	cp a,#'a
      00857C 90 E7            [ 1] 1084 	jrmi 4$
      00857E 02 81            [ 1] 1085 	sub a,#32
      008580 A1 30            [ 1] 1086 4$:	cp a,#'0
      008580 88 AA            [ 1] 1087 	jrmi 9$
      008582 20 A1            [ 1] 1088 	sub a,#'0
      008584 61 25            [ 1] 1089 	cp a,#10
      008586 07 A1            [ 1] 1090 	jrmi 5$
      008588 7A 22            [ 1] 1091 	sub a,#7
      00858A 03 99            [ 1] 1092 	cp a,(BASE,sp)
      00858C 84 81            [ 1] 1093 	jrpl 9$
      00858E 6B 03            [ 1] 1094 5$:	ld (TEMP,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 72.
Hexadecimal [24-Bits]



      00858E 98 84            [ 1] 1095 	ld a,(BASE,sp)
      008590 81 04 5E         [ 4] 1096 	call mulu24_8
      008591 7B 03            [ 1] 1097 	ld a,(TEMP,sp)
      008591 A1 30 2A         [ 1] 1098 	add a,acc24+2
      008594 02 4F 81         [ 1] 1099 	ld acc24+2,a
      008597 A1               [ 1] 1100 	clr a
      008598 39 22 FA         [ 1] 1101 	adc a,acc24+1
      00859B A6 01 81         [ 1] 1102 	ld acc24+1,a
      00859E 4F               [ 1] 1103 	clr a
      00859E 88 CD 85         [ 1] 1104 	adc a,acc24
      0085A1 91 A1 01         [ 1] 1105 	ld acc24,a
      0085A4 26 03            [ 2] 1106 	jra 2$
      0085A6 5B 01            [ 1] 1107 9$:	tnz (SIGN,sp)
      0085A8 81 84            [ 1] 1108     jreq atoi_exit
      0085AA A1 61            [ 2] 1109     negw y
      0005AA                       1110 atoi_exit: 
      0085AC 2B 02            [ 2] 1111 	addw sp,#LOCAL_SIZE
      0085AE A0               [ 2] 1112 	popw x ; restore x
      0085AF 20               [ 4] 1113 	ret
                                   1114 
                                   1115 ;------------------------------------
                                   1116 ;strlen  return .asciz string length
                                   1117 ; input:
                                   1118 ;	y  	pointer to string
                                   1119 ; output:
                                   1120 ;	a   length  < 256
                                   1121 ;------------------------------------
                           000001  1122 	LEN=1
      0005AE                       1123 strlen::
      0085B0 A1 41            [ 2] 1124     pushw y
      0085B2 2A 02            [ 1] 1125     push #0 ; length 
      0085B4 4F 81            [ 1] 1126 0$: ld a,(y)
      0085B6 A1 46            [ 1] 1127     jreq 1$
      0085B8 22 FA            [ 1] 1128     inc (LEN,sp)
      0085BA A6 01            [ 1] 1129     incw y
      0085BC 81 F6            [ 2] 1130     jra 0$
      0085BD 84               [ 1] 1131 1$: pop a
      0085BD 89 52            [ 2] 1132     popw y
      0085BF 03               [ 4] 1133     ret
                                   1134 
                                   1135 
                                   1136 ;------------------------------------
                                   1137 ;  print padded text with spaces 
                                   1138 ;  input:
                                   1139 ;	Y 		pointer to text 
                                   1140 ;   A 		field width 
                                   1141 ;------------------------------------
      0005C0                       1142 print_padded::
      0085C0 72               [ 1] 1143 	push a 
      0085C1 5F 00            [ 2] 1144 	pushw y 
      0085C3 AB 72 5F         [ 4] 1145 	call uart_print 
      0085C6 00 AC            [ 2] 1146 	popw y 
      0085C8 72 5F 00         [ 4] 1147 	call strlen 
      0085CB AD C6 00         [ 1] 1148 	ld acc8,a
      0085CE 5B               [ 1] 1149 	pop a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 73.
Hexadecimal [24-Bits]



      0085CF 27 59 0F         [ 1] 1150 	sub a,acc8 
      0085D2 01 A6            [ 2] 1151 	jrule 2$
      0085D4 0A 6B 02         [ 4] 1152 	call spaces
      0085D7 AE               [ 4] 1153 2$:	ret 
                                   1154 
                                   1155 ;------------------------------------
                                   1156 ; sign extend a byte acc8 in acc24 
                                   1157 ; input:
                                   1158 ;	acc8 	 
                                   1159 ; output:
                                   1160 ;   acc24	acc8 sign extended
                                   1161 ;-------------------------------------
      0005D8                       1162 sex_acc8::
      0085D8 00 5B            [ 1] 1163 	ld a,#128
      0085DA F6 27 47         [ 1] 1164 	and a,acc8 
      0085DD A1 2D            [ 1] 1165 	jreq 1$
      0085DF 26               [ 1] 1166 	cpl a 
      0085E0 04 03 01         [ 1] 1167 1$:	ld acc16,a  
      0085E3 20 08 A1         [ 1] 1168 	ld acc24,a 
      0085E6 24               [ 4] 1169 	ret 
                                   1170 
                                   1171 ;------------------------------------
                                   1172 ; get byte at address 
                                   1173 ; farptr[X]
                                   1174 ; input:
                                   1175 ;	 farptr   address to peek
                                   1176 ;    X		  farptr index 	
                                   1177 ; output:
                                   1178 ;	 A 		  byte from memory  
                                   1179 ;    x		  incremented by 1
                                   1180 ;------------------------------------
      0005E7                       1181 peek::
      0085E7 26 06 A6 10      [ 5] 1182 	ldf a,([farptr],x)
      0085EB 6B               [ 1] 1183 	incw x
      0085EC 02               [ 4] 1184 	ret
                                   1185 
                                   1186 ;------------------------------------
                                   1187 ; get word at at address 
                                   1188 ; farptr[X]
                                   1189 ; input:
                                   1190 ;	 farptr   address to peek
                                   1191 ;    X		  farptr index 	
                                   1192 ; output:
                                   1193 ;    Y:   	  word from memory 
                                   1194 ;	 X:		  incremented by 2 
                                   1195 ;------------------------------------
      0005ED                       1196 peek16::
      0085ED 5C F6 00 00      [ 1] 1197 	 clr acc24 
      0085EF 92 AF 00 00      [ 5] 1198 	 ldf a,([farptr],x)
      0085EF A1 61            [ 1] 1199 	 ld yh,a 
      0085F1 2B               [ 1] 1200 	 incw x 
      0085F2 02 A0 20 A1      [ 5] 1201 	 ldf a,([farptr],x)
      0085F6 30 2B            [ 1] 1202 	 ld yl,a 
      0085F8 2B               [ 1] 1203 	 incw x 
      0085F9 A0               [ 4] 1204 	 ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 74.
Hexadecimal [24-Bits]



                                   1205 
                                   1206 
                                   1207 ;------------------------------------
                                   1208 ; get 24 bits integer at address
                                   1209 ; pointed by farptr[x] 
                                   1210 ; input:
                                   1211 ;	 farptr   address to peek
                                   1212 ;    X		  farptr index 	
                                   1213 ;    A   	  numeric base for convertion
                                   1214 ; output:
                                   1215 ;    acc24 	  value
                                   1216 ;    x		  incremented by 3 
                                   1217 ;------------------------------------
      000600                       1218 peek24::
      0085FA 30 A1 0A 2B      [ 5] 1219 	 ldf a,([farptr],x)
      0085FE 06 A0 07         [ 1] 1220 	 ld acc24,a 
      008601 11               [ 1] 1221 	 incw x 
      008602 02 2A 1F 6B      [ 5] 1222 	 ldf a,([farptr],x)
      008606 03 7B 02         [ 1] 1223 	 ld acc16,a 
      008609 CD               [ 1] 1224 	 incw x 
      00860A 84 DE 7B 03      [ 5] 1225 	 ldf a,([farptr],x)
      00860E CB 00 AD         [ 1] 1226 	 ld acc8,a 
      008611 C7               [ 1] 1227 	 incw x 
      008612 00               [ 4] 1228 	 ret
                                   1229 
                                   1230 ;------------------------------------
                                   1231 ; expect a number from command line next argument
                                   1232 ;  input:
                                   1233 ;	  none
                                   1234 ;  output:
                                   1235 ;    acc24   int24_t 
                                   1236 ;------------------------------------
      000619                       1237 number::
      008613 AD 4F C9         [ 4] 1238 	call next_word
      008616 00 AC C7         [ 4] 1239 	call atoi
      008619 00               [ 4] 1240 	ret
                                   1241 
                                   1242 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
                                   1243 ; write a byte in memory
                                   1244 ; input:
                                   1245 ;    a  		byte to write
                                   1246 ;    farptr  	address
                                   1247 ;    x          farptr[x]
                                   1248 ; output:
                                   1249 ;    none
                                   1250 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1251 	; variables locales
                           000001  1252 	BTW = 1   ; byte to write offset on stack
                           000002  1253 	OPT = 2   ; OPTION flag offset on stack
                           000002  1254 	LOCAL_SIZE = 2
      000620                       1255 write_byte:
      00861A AC 4F            [ 2] 1256 	pushw y
      00861C C9 00            [ 2] 1257 	sub sp,#LOCAL_SIZE  ; réservation d'espace pour variables locales  
      00861E AB C7            [ 1] 1258 	ld (BTW,sp),a ; byte to write 
      008620 00 AB            [ 1] 1259 	clr (OPT,sp)  ; OPTION flag
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 75.
Hexadecimal [24-Bits]



                                   1260 	; put addr[15:0] in Y, for bounds check.
      008622 20 C9 0D         [ 1] 1261 	ld a, farptr+1
      008625 01 27            [ 1] 1262 	ld yh,a
      008627 02 90 50         [ 1] 1263 	ld a, farptr+2
      00862A 90 97            [ 1] 1264 	ld yl,a  ; Y=addr15:0
                                   1265 	; check addr[23:16], if <> 0 then it is extened flash memory
      00862A 5B 03 85 81      [ 1] 1266 	tnz farptr 
      00862E 26 26            [ 1] 1267 	jrne write_flash
      00862E 90 89 4B 00      [ 2] 1268     cpw y,flash_free_base
      008632 90 F6            [ 1] 1269     jruge write_flash
      008634 27 06 0C 01      [ 2] 1270     cpw y,#SFR_BASE
      008638 90 5C            [ 1] 1271 	jruge write_ram
      00863A 20 F6 84 90      [ 2] 1272 	cpw y,#EEPROM_BASE  
      00863E 85 81            [ 1] 1273     jruge write_eeprom
      008640 90 C3 00 55      [ 2] 1274 	cpw y,ram_free_base
      008640 88 90            [ 1] 1275     jrult write_exit
      008642 89 CD 8F 39      [ 2] 1276     cpw y,#STACK_BASE
      008646 90 85            [ 1] 1277     jruge write_exit
                                   1278 
                                   1279 ;write RAM and SFR 
      000656                       1280 write_ram:
      008648 CD 86            [ 1] 1281 	ld a,(BTW,sp)
      00864A 2E C7 00 AD      [ 4] 1282 	ldf ([farptr],x),a
      00864E 84 C0            [ 2] 1283 	jra write_exit
                                   1284 
                                   1285 ; write program memory
      00065E                       1286 write_flash:
      008650 00 AD 23 03      [ 1] 1287 	mov FLASH_PUKR,#FLASH_PUKR_KEY1
      008654 CD 8F 1F 81      [ 1] 1288 	mov FLASH_PUKR,#FLASH_PUKR_KEY2
      008658 72 03 50 5F FB   [ 2] 1289 	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
      00066B                       1290 1$:	_int_disable
      008658 A6               [ 1]    1 		sim
      008659 80 C4            [ 1] 1291 	ld a,(BTW,sp)
      00865B 00 AD 27 01      [ 4] 1292 	ldf ([farptr],x),a ; farptr[x]=A
      00865F 43 C7 00 AC C7   [ 2] 1293 	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
      000677                       1294     _int_enable
      008664 00               [ 1]    1 		 rim
      008665 AB 81 50 5F      [ 1] 1295     bres FLASH_IAPSR,#FLASH_IAPSR_PUL
      008667 20 3E            [ 2] 1296     jra write_exit
                                   1297 
                                   1298 ; write eeprom and option
      00067E                       1299 write_eeprom:
                                   1300 	; check for data eeprom or option eeprom
      008667 92 AF 00 AE      [ 2] 1301 	cpw y,#OPTION_BASE
      00866B 5C 81            [ 1] 1302 	jrmi 1$
      00866D 90 A3 48 80      [ 2] 1303 	cpw y,#OPTION_END+1
      00866D 72 5F            [ 1] 1304 	jrpl 1$
      00866F 00 AB            [ 1] 1305 	cpl (OPT,sp)
      008671 92 AF 00 AE      [ 1] 1306 1$: mov FLASH_DUKR,#FLASH_DUKR_KEY1
      008675 90 95 5C 92      [ 1] 1307     mov FLASH_DUKR,#FLASH_DUKR_KEY2
      008679 AF 00            [ 1] 1308     tnz (OPT,sp)
      00867B AE 90            [ 1] 1309     jreq 2$
                                   1310 	; pour modifier une option il faut modifier ces 2 bits
      00867D 97 5C 81 5B      [ 1] 1311     bset FLASH_CR2,#FLASH_CR2_OPT
      008680 72 1F 50 5C      [ 1] 1312     bres FLASH_NCR2,#FLASH_CR2_OPT 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 76.
Hexadecimal [24-Bits]



      008680 92 AF 00 AE C7   [ 2] 1313 2$: btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
      008685 00 AB            [ 1] 1314     ld a,(BTW,sp)
      008687 5C 92 AF 00      [ 4] 1315     ldf ([farptr],x),a
      00868B AE C7            [ 1] 1316     tnz (OPT,sp)
      00868D 00 AC            [ 1] 1317     jreq 3$
      00868F 5C               [ 1] 1318     incw x
      008690 92 AF            [ 1] 1319     ld a,(BTW,sp)
      008692 00               [ 1] 1320     cpl a
      008693 AE C7 00 AD      [ 4] 1321     ldf ([farptr],x),a
      008697 5C 81 50 5F FB   [ 2] 1322 3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
      008699                       1323 write_exit:
                                   1324 ; ne pas oublier de réajuster sp 
                                   1325 ; et de restaurer les register empilés.
      008699 CD 84            [ 2] 1326 	addw sp,#LOCAL_SIZE 
      00869B 7E CD            [ 2] 1327 	popw y
      00869D 85               [ 4] 1328     ret
                                   1329         
                                   1330 		  
                                   1331 ;------------------------------------
                                   1332 ; evaluate command string in tib
                                   1333 ; list of commands
                                   1334 ;   @  addr display content at address
                                   1335 ;   !  addr byte [byte ]* store bytes at address
                                   1336 ;   ?  diplay command help
                                   1337 ;   b  n    convert n in the other base
                                   1338 ;	c  addr bitmask  clear  bits at address
                                   1339 ;	d addr  desassemble code starting at addr
                                   1340 ;   h  addr hex dump memory starting at address
                                   1341 ;   m  src dest count,  move memory block
                                   1342 ;   r  reset MCU
                                   1343 ;   s  addr bitmask  set a bits at address
                                   1344 ;   t  addr bitmask  toggle bits at address
                                   1345 ;   x  addr execute  code at address  
                                   1346 ;------------------------------------
      0006C1                       1347 eval:
      00869E BD 81 01         [ 1] 1348 	ld a, in
      0086A0 C1 00 02         [ 1] 1349 	cp a, count
      0086A0 90 89            [ 1] 1350 	jrne 0$
      0086A2 52               [ 4] 1351 	ret ; nothing to evaluate
      0086A3 02 6B 01         [ 4] 1352 0$:	call next_word
      0086A6 0F 02 C6 00      [ 2] 1353 	ldw y,#pad
      0086AA AF 90            [ 1] 1354     ld a,(y)
      0086AC 95 C6            [ 1] 1355 	cp a,#'@
      0086AE 00 B0            [ 1] 1356 	jrne 1$
      0086B0 90 97 72         [ 2] 1357 	jp fetch
      0086B3 5D 00            [ 1] 1358 1$:	cp a,#'!
      0086B5 AE 26            [ 1] 1359 	jrne 10$
      0086B7 26 90 C3         [ 2] 1360 	jp store
      0006E1                       1361 10$:
      0086BA 00 58            [ 1] 1362 	cp a,#'?
      0086BC 24 20            [ 1] 1363 	jrne 15$
      0086BE 90 A3 50         [ 2] 1364 	jp help
      0006E8                       1365 15$: 
      0086C1 00 24            [ 1] 1366 	cp a,#'b
      0086C3 12 90            [ 1] 1367     jrne 2$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 77.
Hexadecimal [24-Bits]



      0086C5 A3 40 00         [ 2] 1368     jp base_convert	
      0086C8 24 34            [ 1] 1369 2$:	cp a,#'c
      0086CA 90 C3            [ 1] 1370 	jrne 21$
      0086CC 00 56 25         [ 2] 1371 	jp clear_bits
      0006F6                       1372 21$:
      0086CF 6C 90            [ 1] 1373 	cp a,#'d
      0086D1 A3 17            [ 1] 1374 	jrne 23$
      0086D3 00 24 66         [ 4] 1375 	call dasm
      0086D6 81               [ 4] 1376 	ret 
      0006FE                       1377 23$:
      0086D6 7B 01            [ 1] 1378 	cp a,#'e 
      0086D8 92 A7            [ 1] 1379 	jrne 25$
      0086DA 00 AE 20         [ 2] 1380 	jp erase
      000705                       1381 25$:
      0086DD 5E 66            [ 1] 1382 	cp a,#'f
      0086DE 26 03            [ 1] 1383 	jrne 3$
      0086DE 35 56 50         [ 2] 1384 	jp find 	 	
      0086E1 62 35            [ 1] 1385 3$:	cp a,#'h
      0086E3 AE 50            [ 1] 1386 	jrne 4$
      0086E5 62 72 03         [ 2] 1387 	jp hexdump
      0086E8 50 5F            [ 1] 1388 4$:	cp a,#'m
      0086EA FB 9B            [ 1] 1389 	jrne 45$
      0086EC 7B 01 92         [ 2] 1390 	jp move_memory
      00071A                       1391 45$:
      0086EF A7 00            [ 1] 1392     cp a,#'q 
      0086F1 AE 72            [ 1] 1393 	jrne 5$
      0086F3 05 50 5F FB 9A   [ 2] 1394 	btjf flags,#F_TRAP,455$
      0086F8 72 13 50 5F      [ 1] 1395 	bres flags,#F_TRAP
      0086FC 20 3E 00 53      [ 2] 1396 	ldw y,trap_sp
      0086FE 90 94            [ 1] 1397 	ldw sp,y
      0086FE 90 A3 48         [ 2] 1398 	jp app_resume
      000730                       1399 455$:
      008701 00               [ 4] 1400 	ret 
      008702 2B 08            [ 1] 1401 5$: cp a,#'r
      008704 90 A3            [ 1] 1402     jrne 6$
      008706 48 80 2A         [ 4] 1403 	call NonHandledInterrupt	
      008709 02 03            [ 1] 1404 6$:	cp a,#'s
      00870B 02 35            [ 1] 1405 	jrne 7$
      00870D AE 50 64         [ 2] 1406 	jp set_bits
      008710 35 56            [ 1] 1407 7$:	cp a,#'t
      008712 50 64            [ 1] 1408 	jrne 8$
      008714 0D 02 27         [ 2] 1409 	jp toggle_bits
      008717 08 72            [ 1] 1410 8$:	cp a,#'x
      008719 1E 50            [ 1] 1411 	jrne 9$
      00871B 5B 72 1F         [ 2] 1412 	jp execute
      00871E 50 5C 72         [ 4] 1413 9$:	call uart_print
      008721 07 50 5F         [ 4] 1414 	call uart_tx
      008724 FB 7B            [ 1] 1415 	ld a,#SPACE 
      008726 01 92 A7         [ 4] 1416 	call uart_tx 
      008729 00 AE 0D 02      [ 2] 1417 	ldw y,#BAD_CMD
      00872D 27 08 5C         [ 4] 1418 	call uart_print
      008730 7B               [ 4] 1419 	ret
                                   1420 	
                                   1421 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1422 ;;      MONA commands 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 78.
Hexadecimal [24-Bits]



                                   1423 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1424 
                                   1425 ;------------------------------------
                                   1426 ; @ addr, fetch a byte and display it.
                                   1427 ;------------------------------------
      000760                       1428 fetch:
      008731 01               [ 2] 1429 	pushw x
      008732 43 92            [ 2] 1430 	pushw y
      008734 A7 00 AE         [ 4] 1431 	call number
      008737 72 05 50         [ 1] 1432 	ld a,pad
      00873A 5F FB            [ 1] 1433 	jreq fetch_miss_arg ; pas d'adresse 
      00873C AE 00 00         [ 2] 1434 	ldw x,#acc24
      00873C 5B 02 90 85      [ 2] 1435 	ldw y,#farptr
      008740 81 04 F0         [ 4] 1436 	call copy_var24
      008741 CD 00 00         [ 4] 1437 	call print_addr 
      008741 C6 00            [ 1] 1438 	ld a,#'=
      008743 02 C1 00         [ 4] 1439 	call uart_tx
      008746 03 26            [ 1] 1440 	ld a,#SPACE 
      008748 01 81 CD         [ 4] 1441 	call uart_tx 	
      00874B 84 7E 90         [ 1] 1442 	ld a,pad
      00874E AE 00            [ 1] 1443 	cp a,#'$
      008750 5B 90            [ 1] 1444 	jreq 1$
      008752 F6 A1            [ 1] 1445 	ld a,#10
      008754 40 26            [ 2] 1446 	jra 2$
      008756 03 CC            [ 1] 1447 1$: ld a,#16
      00078F                       1448 2$:	
      008758 87               [ 1] 1449 	clrw x  ; pour farptr[0]
      008759 E0 A1 21         [ 4] 1450 	call peek
      00875C 26 03 CC         [ 4] 1451 	call print_byte 
      00875F 88 1F            [ 2] 1452 	jra fetch_exit
      008761                       1453 fetch_miss_arg:
      008761 A1 3F 26         [ 4] 1454 	call error_print	
      00079B                       1455 fetch_exit:	
      008764 03 CC            [ 2] 1456 	popw y
      008766 88               [ 2] 1457 	popw x 
      008767 73               [ 4] 1458 	ret
                                   1459 	
                                   1460 ;------------------------------------
                                   1461 ; ! addr byte [byte ]*, store byte(s)
                                   1462 ;------------------------------------
      008768                       1463 store:
      008768 A1               [ 2] 1464 	pushw x 
      008769 62 26            [ 2] 1465 	pushw y
      00876B 03 CC 88         [ 4] 1466 	call number
      00876E 7B A1 63         [ 1] 1467 	ld a,pad 
      008771 26 03            [ 1] 1468 	jreq store_miss_arg ; pas d'arguments
      008773 CC 88 96         [ 2] 1469 	ldw x,#acc24
      008776 90 AE 00 00      [ 2] 1470 	ldw y,#farptr
      008776 A1 64 26         [ 4] 1471 	call copy_var24  ; farptr=acc24 
      008779 04               [ 1] 1472 	clrw x ; index pour farptr[x]
      00877A CD 9E 9C         [ 4] 1473 	call number
      00877D 81 00 00         [ 1] 1474 	ld a,pad 
      00877E 26 0E            [ 1] 1475 	jrne str01 ; missing data
      00877E A1 65 26         [ 4] 1476 	call error_print
      008781 03 CC 88         [ 2] 1477 	jp store_exit  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 79.
Hexadecimal [24-Bits]



      0007C3                       1478 store_loop:
      008784 CB 06 19         [ 4] 1479 	call number
      008785 C6 00 00         [ 1] 1480 	ld a, pad
      008785 A1 66            [ 1] 1481 	jreq store_exit ; pas d'octet à écrire.
      0007CB                       1482 str01:	
      008787 26 03            [ 1] 1483 	cp a,#'"'
      008789 CC 89            [ 1] 1484 	jreq store_string	
      00878B 09 A1 68         [ 1] 1485 	ld a,acc24+2 ; octet à écrire.
      00878E 26 03 CC         [ 4] 1486 	call write_byte
      008791 89               [ 1] 1487 	incw x ; x++
      008792 C9 A1            [ 2] 1488 	jra store_loop 
      0007D8                       1489 store_string:
      008794 6D 26 03 CC      [ 2] 1490 	ldw y,#pad 
      0007DC                       1491 str_loop:	
      008798 8A 49            [ 1] 1492     incw y 
      00879A 90 F6            [ 1] 1493 	ld a, (y)
      00879A A1 71            [ 1] 1494 	jreq store_loop 
      00879C 26 13            [ 1] 1495 	cp a,#'"'
      00879E 72 01            [ 1] 1496 	jreq store_loop
      0007E6                       1497 write_char:
      0087A0 00 B1 0D         [ 4] 1498 	call write_byte 
      0087A3 72               [ 1] 1499 	incw x 
      0087A4 11 00            [ 2] 1500 	jra str_loop 
      0007EC                       1501 store_miss_arg:
      0087A6 B1 90 CE         [ 4] 1502 	call error_print	
      0007EF                       1503 store_exit:	
      0087A9 00 54            [ 2] 1504 	popw y
      0087AB 90               [ 2] 1505 	popw x
      0087AC 94               [ 4] 1506 	ret
                                   1507 
                                   1508 
                                   1509 
                                   1510 ;------------------------------------
                                   1511 ; ? , display command information
                                   1512 ;------------------------------------
      0007F3                       1513 help:
      0087AD CC 81 FD BC      [ 2] 1514 	ldw y, #HELP
      0087B0 CD 00 00         [ 4] 1515 	call uart_print
      0087B0 81               [ 4] 1516 	ret
                                   1517 
                                   1518 ;-------------------------------------------
                                   1519 ;  b n|$n
                                   1520 ; convert from one numeric base to the other
                                   1521 ;-------------------------------------------
      0007FB                       1522 base_convert:
      0087B1 A1 72 26         [ 4] 1523     call number
      0087B4 03 CD 81         [ 1] 1524     ld a,pad
      0087B7 E1 A1            [ 1] 1525 	jreq base_miss_arg 
      0087B9 73 26            [ 1] 1526     cp a,#'$
      0087BB 03 CC            [ 1] 1527     jrne 1$
      0087BD 8A B7            [ 1] 1528     ld a,#10
      0087BF A1 74            [ 2] 1529     jra 2$
      0087C1 26 03            [ 1] 1530 1$: ld a,#16
      0087C3 CC               [ 1] 1531 2$: clrw x 
      0087C4 8A E9 A1         [ 4] 1532     call print_int 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 80.
Hexadecimal [24-Bits]



      0087C7 78               [ 4] 1533     ret
      000812                       1534 base_miss_arg:
      0087C8 26 03 CC         [ 4] 1535 	call error_print
      0087CB 8B               [ 4] 1536 	ret
                                   1537 	
                                   1538 ;------------------------------------
                                   1539 ; c addr mask, clear bitmask 
                                   1540 ;------------------------------------
      000816                       1541 clear_bits:
      0087CC 1B               [ 2] 1542 	pushw x 
      0087CD CD 8F            [ 2] 1543 	pushw y 
      0087CF 39 CD 8F         [ 4] 1544 	call number
      0087D2 2F A6 20         [ 1] 1545 	ld a, pad 
      0087D5 CD 8F            [ 1] 1546 	jreq 8$ ; pas d'adresse 
      0087D7 2F 90 AE         [ 2] 1547 	ldw x, #acc24 
      0087DA 8C 29 CD 8F      [ 2] 1548 	ldw y, #farptr 
      0087DE 39 81 F0         [ 4] 1549 	call copy_var24 
      0087E0 CD 06 19         [ 4] 1550 	call number
      0087E0 89 90 89         [ 1] 1551 	ld a, pad 
      0087E3 CD 86            [ 1] 1552 	jreq 8$ ; pas de masque 
      0087E5 99 C6 00 5B      [ 1] 1553 	cpl acc24+2 ; inverse masque de bits 
      0087E9 27 2D AE 00      [ 5] 1554 	ldf a,[farptr]
      0087ED AB 90 AE         [ 1] 1555 	and a,acc24+2
      0087F0 00               [ 1] 1556 	clrw x 
      0087F1 AE CD 85         [ 4] 1557 	call write_byte
      0087F4 70 CD            [ 2] 1558 	jra 9$
      0087F6 90 23 A6         [ 4] 1559 8$: call error_print	 
      0087F9 3D CD            [ 2] 1560 9$:	popw y 
      0087FB 8F               [ 2] 1561 	popw x
      0087FC 2F               [ 4] 1562     ret
                                   1563 
                                   1564 ;----------------------------------------
                                   1565 ; e addr count, efface une plage mémoire
                                   1566 ; cible la mémoire RAM,EEPROM ou FLASH
                                   1567 ;----------------------------------------
                                   1568 	; variables locales
                           000001  1569 	CNTR=1  ; nombre d'octets à effacer
                           000002  1570 	LOCAL_SIZE = 2
      00084B                       1571 erase:
      0087FD A6               [ 2] 1572 	pushw x 
      0087FE 20 CD            [ 2] 1573 	pushw y
      008800 8F 2F            [ 2] 1574 	sub sp,#LOCAL_SIZE 
      008802 C6 00 5B         [ 4] 1575 	call number
      008805 A1 24 27         [ 1] 1576 	ld a, pad 
      008808 04 A6            [ 1] 1577 	jreq erase_miss_arg ; pas de paramètres
      00880A 0A 20 02         [ 2] 1578 	ldw x, #acc24 
      00880D A6 10 00 00      [ 2] 1579 	ldw y, #farptr
      00880F CD 04 F0         [ 4] 1580 	call copy_var24
      00880F 5F CD 86         [ 4] 1581 	call number 
      008812 67 CD 8F         [ 1] 1582 	ld a, pad 
      008815 E6 20            [ 1] 1583 	jreq erase_miss_arg ; count manquant 
      008817 03 00 01         [ 1] 1584 	ld a, acc24+1
      008818 90 95            [ 1] 1585 	ld yh,a 
      008818 CD 8B 47         [ 1] 1586 	ld a, acc24+2
      00881B 90 97            [ 1] 1587 	ld yl,a   ; Y= count 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 81.
Hexadecimal [24-Bits]



      00881B 90               [ 1] 1588 	clrw X 
      000875                       1589 1$:
      00881C 85               [ 1] 1590 	clr a 
      00881D 85 81 20         [ 4] 1591 	call write_byte 
      00881F 90 5A            [ 2] 1592 	decw y 
      00881F 89 90            [ 1] 1593 	jreq erase_exit 
      008821 89               [ 1] 1594 	incw x 
      008822 CD 86            [ 2] 1595 	jra 1$
      000880                       1596 erase_miss_arg:
      008824 99 C6 00         [ 4] 1597 	call error_print
      000883                       1598 erase_exit:
      008827 5B 27            [ 2] 1599 	addw sp,#LOCAL_SIZE 
      008829 42 AE            [ 2] 1600 	popw y 
      00882B 00               [ 2] 1601 	popw x 
      00882C AB               [ 4] 1602 	ret  
                                   1603 
                                   1604 ;------------------------------------------
                                   1605 ; f addr [i] string,  search string in memory
                                   1606 ; stop at first occurence or end of memory
                                   1607 ;------------------------------------------
                                   1608 	; variable locale 
                           000001  1609 	CASE_SENSE=1  ; indicateur recherche sensible à casse.
      000889                       1610 find:
      00882D 90               [ 1] 1611 	clr a 
      00882E AE               [ 1] 1612 	push a  ; case sensitive
      00882F 00 AE CD         [ 4] 1613 	call number
      008832 85 70 5F         [ 1] 1614 	ld a,pad
      008835 CD 86            [ 1] 1615 	jrne 0$
      008837 99 C6 00 5B      [ 2] 1616 	jpf find_miss_arg 
      00883B 26 0E CD         [ 2] 1617 0$:	ldw x, #acc24 
      00883E 8B 47 CC 88      [ 2] 1618 	ldw y, #farptr
      008842 6F 04 F0         [ 4] 1619 	call copy_var24
      008843 CD 03 FE         [ 4] 1620 	call next_word 
      008843 CD 86 99         [ 1] 1621 	ld a,pad
      008846 C6 00            [ 1] 1622 	cp a,#'i
      008848 5B 27            [ 1] 1623 	jrne 2$
      00884A 24 20            [ 1] 1624 1$:	ld a,#32
      00884B 6B 01            [ 1] 1625 	ld (CASE_SENSE,sp),a ; case insensitive
      00884B A1 22 27         [ 4] 1626 	call next_word 
      00884E 09 C6 00         [ 1] 1627 	ld a,pad 
      008851 AD CD            [ 1] 1628 2$: cp a,#'" 
      008853 86 A0            [ 1] 1629 	jrne find_bad_arg
                                   1630 ; remove ["] character at end of string.
                                   1631 ; and convert to lower case if option [i]
      008855 5C 20 EB         [ 2] 1632 	ldw x, #pad+1
      008858 F6               [ 1] 1633 4$:	ld a,(x)
      008858 90 AE            [ 1] 1634 	jreq 5$
      00885A 00 5B 00         [ 4] 1635 	call is_alpha 
      00885C 24 02            [ 1] 1636 	jrnc 41$
      00885C 90 5C            [ 1] 1637 	or a,(CASE_SENSE,sp)
      0008C6                       1638 41$:	
      00885E 90               [ 1] 1639 	ld (x),a 
      00885F F6               [ 1] 1640 	incw x 
      008860 27 E1            [ 2] 1641 	jra 4$
      008862 A1               [ 2] 1642 5$: decw x
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 82.
Hexadecimal [24-Bits]



      008863 22               [ 1] 1643 	clr (x)
                                   1644 ; search loop 
      0008CC                       1645 20$:
                                   1646 ; initialize X at string first char.	
      008864 27 DD 01         [ 2] 1647 	ldw x, #pad+1
      008866 90 5F            [ 1] 1648 	clrw y ; farptr index 
                                   1649 ; string compare 	
      0008D1                       1650 21$:
      008866 CD               [ 1] 1651 	ld a,(x)
      008867 86 A0            [ 1] 1652 	jreq found 
      008869 5C 20 F0 00      [ 1] 1653 	ldf a,([farptr],y)
                                   1654 ; if letter and [i] convert to lower case 	
      00886C A1 41            [ 1] 1655 	cp a,#'A
      00886C CD 8B            [ 1] 1656 	jrult 24$
      00886E 47 5A            [ 1] 1657 	cp a,#'Z
      00886F 22 02            [ 1] 1658 	jrugt 24$
      00886F 90 85            [ 1] 1659 	or a,(CASE_SENSE,sp)	 
      008871 85               [ 1] 1660 24$: cp a,(x) 
      008872 81 05            [ 1] 1661 	jrne 30$
      008873 5C               [ 1] 1662 	incw x 
      008873 90 AE            [ 1] 1663 	incw y 
      008875 8C 3C            [ 2] 1664 	jra 21$
                                   1665 ; increment farptr for next comparison
      008877 CD 8F            [ 1] 1666 30$: ld a,#1 
      008879 39 81 00         [ 2] 1667 	ldw x,#farptr 
      00887B CD 04 E3         [ 4] 1668 	call inc_var24
                                   1669 ; check for memory end 	
      00887B CD 86 99         [ 2] 1670 	ldw x,#(FLASH_END>>8) 
      00887E C6 00 5B         [ 2] 1671 	cpw x, farptr
      008881 27 0F            [ 1] 1672 	jrne 20$
      008883 A1 24 26         [ 1] 1673 	ld a,farptr+2 
      008886 04 A6            [ 1] 1674 	cp a,#FLASH_END 
      008888 0A 20            [ 1] 1675 	jreq  find_failed ; not found 
      00888A 02 A6            [ 2] 1676 	jra 20$		
      000903                       1677 found:
      00888C 10 5F CD 8F      [ 2] 1678 	ldw y,#FOUND_AT 
      008890 9D 81 00         [ 4] 1679 	call uart_print
      008892 CD 00 00         [ 4] 1680 	call print_addr 
      008892 CD 8B            [ 2] 1681 	jra find_exit
      00090F                       1682 find_miss_arg:
      008894 47 81 C7         [ 4] 1683 	call error_print
      008896 20 0E            [ 2] 1684 	jra find_exit  
      000914                       1685 find_bad_arg:
      008896 89 90            [ 1] 1686 	ld a,#1
      008898 89 CD 86         [ 4] 1687 	call error_print 
      00889B 99 C6            [ 2] 1688 	jra find_exit 
      00091B                       1689 find_failed:
      00889D 00 5B 27 23      [ 2] 1690 	ldw y, #NOT_FOUND
      0088A1 AE 00 AB         [ 4] 1691 	call uart_print 
      000922                       1692 find_exit:
      0088A4 90               [ 1] 1693 	pop a 
      0088A5 AE               [ 4] 1694 	ret 
                                   1695 
      0088A6 00 AE CD 85 70 CD 86  1696 FOUND_AT:	.asciz "Found at address: "
             99 C6 00 5B 27 11 72
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 83.
Hexadecimal  53-Bits]



             73 73 3A 20 00
      0088B5 00 AD 92 BC 00 AE C4  1697 NOT_FOUND:  .asciz "String not found."
             00 AD 5F CD 86 A0 20
             03 CD 8B 47
                                   1698 
                                   1699 ;------------------------------------
                                   1700 ; h addr, memory dump in hexadecimal 
                                   1701 ; stop after each row, SPACE continue, other stop
                                   1702 ;------------------------------------
                           000008  1703 	ROW_CNT = 8 ; nombre d'octets par ligne 
                           000001  1704 	IDX=1 ; index pour farptr[x]
                           000002  1705 	LOCAL_SIZE=2
      000949                       1706 hexdump: 
      0088C7 90 85            [ 2] 1707 	sub sp,#LOCAL_SIZE
      0088C9 85 81 FE         [ 4] 1708 	call next_word
      0088CB C6 00 00         [ 1] 1709 	ld a, pad 
      0088CB 89 90            [ 1] 1710 	jrne 1$
      0088CD 89 52 02         [ 2] 1711 	jp hdump_missing_arg ; adresse manquante
      000956                       1712 1$:	
      0088D0 CD 86 99         [ 4] 1713 	call atoi ; acc24=addr 
                                   1714 	; farptr = addr 
      0088D3 C6 00 5B         [ 2] 1715 	ldw x,#acc24
      0088D6 27 28 AE 00      [ 2] 1716 	ldw y,#farptr
      0088DA AB 90 AE         [ 4] 1717 	call copy_var24
      000963                       1718 row_init:
      0088DD 00               [ 1] 1719 	clrw x 
      0088DE AE CD            [ 2] 1720 	ldw (IDX,sp),x
                                   1721 	; affiche l'adresse en début de ligne 
      0088E0 85 70 CD         [ 4] 1722 	call print_addr 
      0088E3 86 99            [ 1] 1723 	ld a,#TAB 
      0088E5 C6 00 5B         [ 4] 1724 	call uart_tx
      0088E8 27 16 C6         [ 4] 1725 	call uart_tx 
      0088EB 00 AC 90 95      [ 2] 1726 	ldw y, #pad
      0088EF C6 00            [ 2] 1727 	ldw x,(IDX,sp)
      000977                       1728 row:
      0088F1 AD               [ 2] 1729 	pushw x 
      0088F2 90 97 5F         [ 4] 1730 	call peek
      0088F5 CD 00 00         [ 4] 1731 	call print_byte 
      0088F5 4F               [ 2] 1732 	popw x  
      0088F6 CD 86 A0 90      [ 5] 1733 	ldf a,([farptr],x)
      0088FA 5A 27            [ 1] 1734 	cp a,#SPACE
      0088FC 06 5C            [ 1] 1735 	jrpl 1$
      0088FE 20 F5            [ 1] 1736 	ld a,#SPACE
      008900 A1 80            [ 1] 1737 1$:	cp a,#128
      008900 CD 8B            [ 1] 1738     jrmi 2$
      008902 47 20            [ 1] 1739     ld a,#SPACE
      008903 90 F7            [ 1] 1740 2$: ld (y),a
      008903 5B 02            [ 1] 1741 	incw y 
      008905 90               [ 1] 1742 	incw x
      008906 85 85 81         [ 2] 1743 	cpw x,#ROW_CNT
      008909 26 DE            [ 1] 1744 	jrne row
      008909 4F 88            [ 1] 1745 	ld a,#ROW_CNT 
      00890B CD 86 99         [ 2] 1746 	ldw x,#farptr
      00890E C6 00 5B         [ 4] 1747 	call inc_var24
      008911 26 04            [ 1] 1748 	ld a,#SPACE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 84.
Hexadecimal [24-Bits]



      008913 AC 00 89         [ 4] 1749 	call uart_tx
      008916 8F               [ 1] 1750 	clr a
      008917 AE 00            [ 1] 1751 	ld (y),a
      008919 AB 90            [ 1] 1752 	ld a,#SPACE 
      00891B AE 00 AE         [ 4] 1753 	call uart_tx  
      00891E CD 85 70 CD      [ 2] 1754 	ldw y,#pad
      008922 84 7E C6         [ 4] 1755 	call uart_print
      008925 00 5B            [ 1] 1756 	ld a,#NL
      008927 A1 69 26         [ 4] 1757 	call uart_tx
      00892A 0A A6 20         [ 4] 1758 	call uart_getchar
      00892D 6B 01            [ 1] 1759 	cp a,#SPACE
      00892F CD 84            [ 1] 1760 	jreq row_init
      008931 7E C6            [ 2] 1761 	jra hdump_exit 
      0009C3                       1762 hdump_missing_arg:
      008933 00 5B A1         [ 4] 1763 	call error_print 	
      0009C6                       1764 hdump_exit:	
      008936 22 26            [ 2] 1765     addw sp,#LOCAL_SIZE
      008938 5B               [ 4] 1766     ret
                                   1767     
                                   1768 ;------------------------------------
                                   1769 ; m src dest count, move memory block
                                   1770 ;------------------------------------
                           000001  1771     COUNT=1
                           000003  1772     SOURCE=3
                           000005  1773 	LOCAL_SIZE=5    
      0009C9                       1774 move_memory:
      008939 AE 00            [ 2] 1775 	sub sp,#LOCAL_SIZE
      00893B 5C F6 27         [ 4] 1776 	call number 
      00893E 0B CD 85         [ 1] 1777 	ld a, pad 
      008941 80 24            [ 1] 1778 	jreq move_missing_arg ; pas d'arguments 
                                   1779 	; save source address on stack
      008943 02 1A 01         [ 1] 1780 	ld a, acc24+2
      008946 6B 05            [ 1] 1781 	ld (SOURCE+2,sp),a
      008946 F7 5C 20         [ 1] 1782 	ld a, acc24+1
      008949 F2 5A            [ 1] 1783 	ld (SOURCE+1,sp),a
      00894B 7F 00 00         [ 1] 1784 	ld a,acc24
      00894C 6B 03            [ 1] 1785 	ld (SOURCE,sp),a
      00894C AE 00 5C         [ 4] 1786 	call number
      00894F 90 5F 00         [ 1] 1787 	ld a,pad
      008951 27 47            [ 1] 1788 	jreq move_missing_arg ; dest count manquant 
                                   1789 	; copy dest address in farptr
      008951 F6 27 2F 91 AF   [ 1] 1790 	mov farptr+2,acc24+2
      008956 00 AE A1 41 25   [ 1] 1791 	mov farptr+1,acc24+1
      00895B 06 A1 5A 22 02   [ 1] 1792 	mov farptr,acc24
      008960 1A 01 F1         [ 4] 1793     call number 
      008963 26 05 5C         [ 1] 1794 	ld a, pad 
      008966 90 5C            [ 1] 1795 	jreq move_missing_arg ; count manquant 
      008968 20 E7 A6         [ 1] 1796 	ld a, acc24+1 
      00896B 01 AE            [ 1] 1797 	ld yh, a
      00896D 00 AE CD         [ 1] 1798 	ld a, acc24+2 
      008970 85 63            [ 1] 1799 	ld yl,a  ; Y = count
      008972 AE 02            [ 2] 1800 	ldw (COUNT,sp),y
                                   1801 	; put back source in acc24
      008974 7F C3            [ 1] 1802 	ld a,(SOURCE,sp)
      008976 00 AE 26         [ 1] 1803 	ld acc24,a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 85.
Hexadecimal [24-Bits]



      008979 D2 C6            [ 1] 1804 	ld a,(SOURCE+1,sp) 
      00897B 00 B0 A1         [ 1] 1805 	ld acc24+1,a 
      00897E FF 27            [ 1] 1806 	ld a,(SOURCE+2,sp)
      008980 1A 20 C9         [ 1] 1807 	ld acc24+2,a
      008983 5F               [ 1] 1808 	clrw x
      000A1D                       1809 move_loop:
      008983 90 AE 89 A4      [ 5] 1810     ldf a,([acc24],x)
      008987 CD 8F 39         [ 4] 1811 	call write_byte
      00898A CD               [ 1] 1812     incw x
      00898B 90 23            [ 2] 1813 	ldw y, (COUNT,sp)
      00898D 20 13            [ 2] 1814 	decw y
      00898F 27 09            [ 1] 1815 	jreq move_exit
      00898F CD 8B            [ 2] 1816     ldw (COUNT,sp),y
      008991 47 20            [ 2] 1817     jra move_loop
      008993 0E 03            [ 2] 1818 	jra move_exit
      008994                       1819 move_missing_arg:
      008994 A6 01 CD         [ 4] 1820 	call error_print 	
      000A34                       1821 move_exit:
      008997 8B 47            [ 2] 1822     addw sp,#LOCAL_SIZE
      008999 20               [ 4] 1823     ret
                                   1824     
                                   1825 ;------------------------------------
                                   1826 ;  s addr mask, set bitmask 
                                   1827 ;------------------------------------
      000A37                       1828 set_bits:
      00899A 07               [ 2] 1829 	pushw x 
      00899B 90 89            [ 2] 1830 	pushw y 
      00899B 90 AE 89         [ 4] 1831 	call number 
      00899E B7 CD 8F         [ 1] 1832 	ld a, pad 
      0089A1 39 20            [ 1] 1833 	jreq 8$ ; arguments manquant
      0089A2 AE 00 00         [ 2] 1834 	ldw x, #acc24
      0089A2 84 81 46 6F      [ 2] 1835 	ldw y, #farptr 
      0089A6 75 6E 64         [ 4] 1836 	call copy_var24 
      0089A9 20 61 74         [ 4] 1837 	call number  
      0089AC 20 61 64         [ 1] 1838 	ld a, pad 
      0089AF 64 72            [ 1] 1839 	jreq 8$ ; mask manquant
      0089B1 65 73 73 3A      [ 5] 1840 	ldf a,[farptr]
      0089B5 20 00 53         [ 1] 1841 	or a, acc24+2
      0089B8 74               [ 1] 1842 	clrw x 
      0089B9 72 69 6E         [ 4] 1843 	call write_byte 
      0089BC 67 20 6E         [ 2] 1844 	jp 9$
      0089BF 6F 74 20         [ 4] 1845 8$: call error_print
      000A65                       1846 9$:
      0089C2 66 6F            [ 2] 1847 	popw y 
      0089C4 75               [ 2] 1848 	popw x 
      0089C5 6E               [ 4] 1849     ret
                                   1850     
                                   1851 ;------------------------------------
                                   1852 ; t addr mask, toggle bitmask
                                   1853 ;------------------------------------
      000A69                       1854 toggle_bits:
      0089C6 64               [ 2] 1855 	pushw x 
      0089C7 2E 00            [ 2] 1856 	pushw y 
      0089C9 CD 06 19         [ 4] 1857 	call number
      0089C9 52 02 CD         [ 1] 1858 	ld a, pad
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 86.
Hexadecimal [24-Bits]



      0089CC 84 7E            [ 1] 1859 	jreq 8$  ; pas d'adresse 
      0089CE C6 00 5B         [ 2] 1860 	ldw x,#acc24 
      0089D1 26 03 CC 8A      [ 2] 1861 	ldw y,#farptr
      0089D5 43 04 F0         [ 4] 1862 	call copy_var24
      0089D6 CD 06 19         [ 4] 1863     call number
      0089D6 CD 85 BD         [ 1] 1864 	ld a, pad 
      0089D9 AE 00            [ 1] 1865 	jreq 8$ ; pas de masque 
      0089DB AB 90 AE 00      [ 5] 1866 	ldf a,[farptr]
      0089DF AE CD 85         [ 1] 1867     xor a,acc24+2
      0089E2 70               [ 1] 1868     clrw x 
      0089E3 CD 06 20         [ 4] 1869 	call write_byte 
      0089E3 5F 1F 01         [ 2] 1870 	jp 9$
      0089E6 CD 90 23         [ 4] 1871 8$: call error_print
      000A97                       1872 9$:
      0089E9 A6 09            [ 2] 1873 	popw y
      0089EB CD               [ 2] 1874  	popw x 
      0089EC 8F               [ 4] 1875     ret
                                   1876     
                                   1877 ;------------------------------------
                                   1878 ; x addr, execute programme
                                   1879 ; addr < $10000 (<65536)
                                   1880 ;------------------------------------
      000A9B                       1881 execute:
      0089ED 2F CD 8F         [ 4] 1882 	call number
      0089F0 2F 90 AE         [ 1] 1883 	ld a, pad 
      0089F3 00 5B            [ 1] 1884 	jreq no_addr ; addr manquante 
      0089F5 1E 01 00 00      [ 1] 1885 	tnz acc24
      0089F7 26 11            [ 1] 1886 	jrne 9$ ; adresse > 0xFFFF ; adresse invalide.
      0089F7 89 CD 86         [ 1] 1887 	ld a, acc24+1
      0089FA 67 CD            [ 1] 1888 	ld yh,a 
      0089FC 8F E6 85         [ 1] 1889 	or a, acc24+2 
      0089FF 92 AF            [ 1] 1890 	jreq 9$ ; pointeur NULL 
      008A01 00 AE A1         [ 1] 1891 	ld a,acc24+2 
      008A04 20 2A            [ 1] 1892 	ld yl,a 
      008A06 02 A6            [ 2] 1893 	jp (y)
      008A08 20               [ 1] 1894 9$: inc a
                                   1895 
      000ABB                       1896 no_addr:
      008A09 A1 80 2B 02      [ 2] 1897 	ldw y,flash_free_base
      008A0D A6 20            [ 1] 1898 	incw y
      008A0F 90 F7            [ 1] 1899 	ld a,(y)
      008A11 90 5C            [ 1] 1900 	jreq error_print 
      008A13 5C A3            [ 2] 1901 	jp (y)
                                   1902 
                                   1903 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1904 ; print error messages
                                   1905 ; input:
                                   1906 ;	A 		error code 
                                   1907 ; output:
                                   1908 ;	none 
                                   1909 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000AC7                       1910 error_print::
      008A15 00 08            [ 1] 1911 	cp a,#0 ; missing argment
      008A17 26 DE            [ 1] 1912 	jrne 1$
      008A19 A6 08 AE 00      [ 2] 1913 	ldw y, #MISS_ARG
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 87.
Hexadecimal [24-Bits]



      008A1D AE CD            [ 2] 1914 	jra 9$
      008A1F 85 63 A6 20      [ 2] 1915 1$: ldw y, #BAD_ARG
      008A23 CD 8F 2F         [ 4] 1916 9$:	call uart_print 
      008A26 4F               [ 4] 1917 	ret
                                   1918 
                                   1919 ;------------------------
                                   1920 ;  run time CONSTANTS
                                   1921 ;------------------------
                                   1922 ; messages strings
                                   1923 ;------------------------	
      008A27 90 F7 A6 20 CD 8F 2F  1924 VERSION:	.asciz "\nMONA VERSION %c.%c\n"
             90 AE 00 5B CD 8F 39
             A6 0A CD 8F 2F CD 8F
      008A3C 5C A1 20 27 A2 20 03  1925 CPU_MODEL:  .asciz "stm8s208rb     memory map\n----------------------------\n"
             38 72 62 20 20 20 20
             20 6D 65 6D 6F 72 79
             20 6D 61 70 0A 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 0A 00
      008A43 72 61 6D 20 66 72 65  1926 RAM_FREE_MSG: .asciz "ram free: "
             65 3A 20 00
      008A43 CD 8B 47 31 36 46 46  1927 RAM_LAST_FREE_MSG: .asciz "- $16FF\n"
             0A 00
      008A46 66 72 65 65 20 66 6C  1928 FLASH_FREE_MSG: .asciz "free flash: "
             61 73 68 3A 20 00
      008A46 5B 02 81 24 32 37 46  1929 EEPROM_MSG: .ascii " - $27FFF\n"
             46 46 0A
      008A49 65 65 70 72 6F 6D 3A  1930             .ascii "eeprom: $4000 - $47ff\n"
             20 24 34 30 30 30 20
             2D 20 24 34 37 66 66
             0A
      008A49 52 05 CD 86 99 C6 00  1931             .ascii "option: $4800 - $487f\n"
             5B 27 5E C6 00 AD 6B
             05 C6 00 AC 6B 04 C6
             00
      008A5F AB 6B 03 CD 86 99 C6  1932             .ascii "SFR: $5000 - $57FF\n"
             00 5B 27 47 55 00 AD
             00 B0 55 00 AC
      008A72 00 AF 55 00 AB 00 AE  1933             .asciz "boot ROM: $6000 - $67FF\n"
             CD 86 99 C6 00 5B 27
             30 C6 00 AC 90 95 C6
             00 AD 90 97
      008A8B 17 01 7B 03 C7 00 AB  1934 BAD_CMD:    .asciz " is not a command\n"	
             7B 04 C7 00 AC 7B 05
             C7 00 AD 5F 00
      008A9D 63 6F 6D 6D 61 6E 64  1935 HELP: .ascii "commands:\n"
             73 3A 0A
      008A9D 92 AF 00 AB CD 86 A0  1936 	  .ascii "@ addr, display content at address\n"
             5C 16 01 90 5A 27 09
             17 01 20 EE 20 03 65
             6E 74 20 61 74 20 61
             64 64 72 65 73 73 0A
      008AB1 21 20 61 64 64 72 20  1937 	  .ascii "! addr byte|string [byte|string ]*, store bytes or string at addr++\n"
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 88.
Hexadecimal [24-Bits]



             62 79 74 65 7C 73 74
             72 69 6E 67 20 5B 62
             79 74 65 7C 73 74 72
             69 6E 67 20 5D 2A 2C
             20 73 74 6F 72 65 20
             62 79 74 65 73 20 6F
             72 20 73 74 72 69 6E
             67 20 61 74 20 61 64
             64 72 2B 2B 0A
      008AB1 CD 8B 47 64 69 70 6C  1938 	  .ascii "?, diplay command help\n"
             61 79 20 63 6F 6D 6D
             61 6E 64 20 68 65 6C
             70 0A
      008AB4 62 20 6E 7C 24 6E 2C  1939 	  .ascii "b n|$n, convert n in the other base\n"
             20 63 6F 6E 76 65 72
             74 20 6E 20 69 6E 20
             74 68 65 20 6F 74 68
             65 72 20 62 61 73 65
             0A
      008AB4 5B 05 81 64 64 72 20  1940 	  .ascii "c addr bitmask, clear bits at address\n"
             62 69 74 6D 61 73 6B
             2C 20 63 6C 65 61 72
             20 62 69 74 73 20 61
             74 20 61 64 64 72 65
             73 73 0A
      008AB7 64 20 61 64 64 72 2C  1941 	  .ascii "d addr, desassemble\n" 
             20 64 65 73 61 73 73
             65 6D 62 6C 65 0A
      008AB7 89 90 89 CD 86 99 C6  1942 	  .ascii "e addr count, clear memory range\n" 
             00 5B 27 20 AE 00 AB
             90 AE 00 AE CD 85 70
             CD 86 99 C6 00 5B 27
             0E 92 BC 00 AE
      008AD8 CA 00 AD 5F CD 86 A0  1943 	  .ascii "f addr [i] string, find string in memory\n"
             CC 8A E5 CD 8B 47 72
             69 6E 67 2C 20 66 69
             6E 64 20 73 74 72 69
             6E 67 20 69 6E 20 6D
             65 6D 6F 72 79 0A
      008AE5 68 20 61 64 64 72 2C  1944 	  .ascii "h addr, hex dump memory starting at address\n"
             20 68 65 78 20 64 75
             6D 70 20 6D 65 6D 6F
             72 79 20 73 74 61 72
             74 69 6E 67 20 61 74
             20 61 64 64 72 65 73
             73 0A
      008AE5 90 85 85 81 63 20 64  1945 	  .ascii "m src dest count, move memory block\n"
             65 73 74 20 63 6F 75
             6E 74 2C 20 6D 6F 76
             65 20 6D 65 6D 6F 72
             79 20 62 6C 6F 63 6B
             0A
      008AE9 71 20 2C 20 71 75 69  1946 	  .ascii "q , quit MONA after a trap entry.\n"
             74 20 4D 4F 4E 41 20
             61 66 74 65 72 20 61
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 89.
Hexadecimal [24-Bits]



             20 74 72 61 70 20 65
             6E 74 72 79 2E 0A
      008AE9 89 90 89 CD 86 99 C6  1947 	  .ascii "r reset MCU\n"
             00 5B 27 20 AE
      008AF5 00 AB 90 AE 00 AE CD  1948 	  .ascii "s addr bitmask, set bits at address\n"
             85 70 CD 86 99 C6 00
             5B 27 0E 92 BC 00 AE
             C8 00 AD 5F CD 86 A0
             CC 8B 17 CD 8B 47 73
             0A
      008B17 74 20 61 64 64 72 20  1949 	  .ascii "t addr bitmask, toggle bits at address\n"
             62 69 74 6D 61 73 6B
             2C 20 74 6F 67 67 6C
             65 20 62 69 74 73 20
             61 74 20 61 64 64 72
             65 73 73 0A
      008B17 90 85 85 81 64 72 2C  1950 	  .asciz "x addr, execute  code at address\n"
             20 65 78 65 63 75 74
             65 20 20 63 6F 64 65
             20 61 74 20 61 64 64
             72 65 73 73 0A 00
      008B1B 4D 69 73 73 69 6E 67  1951 MISS_ARG: .asciz "Missing arguments\n"
             20 61 72 67 75 6D 65
             6E 74 73 0A 00
      008B1B CD 86 99 C6 00 5B 27  1952 BAD_ARG:  .asciz "bad arguments\n"
             18 72 5D 00 AB 26 11
             C6
