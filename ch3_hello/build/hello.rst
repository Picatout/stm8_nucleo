ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;   tutoriel sdas pour stm8
                                      3 ;   chapitre 3  hello.asm
                                      4 ;   Date: 2019-10-31
                                      5 ;   Copyright Jacques Deschêens, 2019
                                      6 ;   licence:  CC-BY-SA version 2 ou ultérieure
                                      7 ;
                                      8 ;   Description: 
                                      9 ;       Chaque fois que le boutin USER est enfoncé le message
                                     10 ;       "Hello from extended memory.\n" est envoyé via le UART3.
                                     11 ;       Utilisation de la mémoire flash au delà de 0xffff.
                                     12 ;       Discution sur l'utilisation de la mémoire étendue.
                                     13 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     14 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     15     .include "../inc/nucleo_8s208.inc"
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ; NUCLEO-8S208RB board specific definitions
                                      3 ; Date: 2019/10/29
                                      4 ; author: Jacques Deschênes, copyright 2018,2019
                                      5 ; licence: GPLv3
                                      6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      7 
                                      8 ; mcu on board is stm8s208rbt6
                                      9 
                                     10 ; crystal on board is 8Mhz
                           7A1200    11 FHSE = 8000000
                                     12 
                                     13 ; LED2 is user LED
                                     14 ; connected to PC5 via Q2 -> 2N7002 MOSFET
                           00500A    15 LED2_PORT = 0x500a ;port C  ODR
                           000005    16 LED2_BIT = 5
                           000020    17 LED2_MASK = (1<<5) ;bit 5 mask
                                     18 
                                     19 ; B1 on schematic is user button
                                     20 ; connected to PE4
                                     21 ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                           005015    22 USR_BTN_PORT = 0x5015 ; port E  IDR
                           000004    23 USR_BTN_BIT = 4
                           000010    24 USR_BTN_MASK = (1<<4) ;bit 4 mask
                                     25 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                     16     .include "../inc/stm8s208.inc"
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ; 2019/10/18
                                      3 ; STM8S208RB µC registers map
                                      4 ; sdas source file
                                      5 ; author: Jacques Deschênes, copyright 2018,2019
                                      6 ; licence: GPLv3
                                      7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      8 	.module stm8s208rb
                                      9 
                                     10 ;;;;;;;;;;;;
                                     11 ; bits
                                     12 ;;;;;;;;;;;;
                           000000    13  BIT0 = 0
                           000001    14  BIT1 = 1
                           000002    15  BIT2 = 2
                           000003    16  BIT3 = 3
                           000004    17  BIT4 = 4
                           000005    18  BIT5 = 5
                           000006    19  BIT6 = 6
                           000007    20  BIT7 = 7
                                     21  	
                                     22 ;;;;;;;;;;;;
                                     23 ; bits masks
                                     24 ;;;;;;;;;;;;
                           000001    25  B0_MASK = (1<<0)
                           000002    26  B1_MASK = (1<<1)
                           000004    27  B2_MASK = (1<<2)
                           000008    28  B3_MASK = (1<<3)
                           000010    29  B4_MASK = (1<<4)
                           000020    30  B5_MASK = (1<<5)
                           000040    31  B6_MASK = (1<<6)
                           000080    32  B7_MASK = (1<<7)
                                     33 
                                     34 ; HSI oscillator frequency 16Mhz
                           F42400    35  FHSI = 16000000
                                     36 ; LSI oscillator frequency 128Khz
                           01F400    37  FLSI = 128000 
                                     38 
                                     39 ; controller memory regions
                           001800    40  RAM_SIZE = (0x1800) ; 6KB 
                           000800    41  EEPROM_SIZE = (0x800) ; 2KB
                                     42 ; STM8S208RB have 128K flash
                           020000    43  FLASH_SIZE = (0x20000)
                                     44 
                           000000    45  RAM_BASE = (0)
                           0017FF    46  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    47  EEPROM_BASE = (0x4000)
                           0047FF    48  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    49  SFR_BASE = (0x5000)
                           0057FF    50  SFR_END = (0x57FF)
                           006000    51  BOOT_ROM_BASE = (0x6000)
                           007FFF    52  BOOT_ROM_END = (0x7fff)
                           008000    53  FLASH_BASE = (0x8000)
                           027FFF    54  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                           004800    55  OPTION_BASE = (0x4800)
                           00487F    56  OPTION_END = (0x487F)
                           0048CD    57  DEVID_BASE = (0x48CD)
                           0048D8    58  DEVID_END = (0x48D8)
                           007F00    59  DEBUG_BASE = (0X7F00)
                           007FFF    60  DEBUG_END = (0X7FFF)
                                     61 
                                     62 ; options bytes
                                     63 ; this one can be programmed only from SWIM  (ICP)
                           004800    64  OPT0  = (0x4800)
                                     65 ; these can be programmed at runtime (IAP)
                           004801    66  OPT1  = (0x4801)
                           004802    67  NOPT1  = (0x4802)
                           004803    68  OPT2  = (0x4803)
                           004804    69  NOPT2  = (0x4804)
                           004805    70  OPT3  = (0x4805)
                           004806    71  NOPT3  = (0x4806)
                           004807    72  OPT4  = (0x4807)
                           004808    73  NOPT4  = (0x4808)
                           004809    74  OPT5  = (0x4809)
                           00480A    75  NOPT5  = (0x480A)
                           00480B    76  OPT6  = (0x480B)
                           00480C    77  NOPT6 = (0x480C)
                           00480D    78  OPT7 = (0x480D)
                           00480E    79  NOPT7 = (0x480E)
                           00487E    80  OPTBL  = (0x487E)
                           00487F    81  NOPTBL  = (0x487F)
                                     82 ; option registers usage
                                     83 ; read out protection, value 0xAA enable ROP
                           004800    84  ROP = OPT0  
                                     85 ; user boot code, {0..0x3e} 512 bytes row
                           004801    86  UBC = OPT1
                           004802    87  NUBC = NOPT1
                                     88 ; alternate function register
                           004803    89  AFR = OPT2
                           004804    90  NAFR = NOPT2
                                     91 ; miscelinous options
                           004805    92  WDGOPT = OPT3
                           004806    93  NWDGOPT = NOPT3
                                     94 ; clock options
                           004807    95  CLKOPT = OPT4
                           004808    96  NCLKOPT = NOPT4
                                     97 ; HSE clock startup delay
                           004809    98  HSECNT = OPT5
                           00480A    99  NHSECNT = NOPT5
                                    100 ; flash wait state
                           00480D   101 FLASH_WS = OPT7
                           00480E   102 NFLASH_WS = NOPT7
                                    103 
                                    104 ; watchdog options bits
                           000003   105   WDGOPT_LSIEN   =  BIT3
                           000002   106   WDGOPT_IWDG_HW =  BIT2
                           000001   107   WDGOPT_WWDG_HW =  BIT1
                           000000   108   WDGOPT_WWDG_HALT = BIT0
                                    109 ; NWDGOPT bits
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



                           FFFFFFFC   110   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   111   NWDGOPT_IWDG_HW  = ~BIT2
                           FFFFFFFE   112   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   113   NWDGOPT_WWDG_HALT = ~BIT0
                                    114 
                                    115 ; CLKOPT bits
                           000003   116  CLKOPT_EXT_CLK  = BIT3
                           000002   117  CLKOPT_CKAWUSEL = BIT2
                           000001   118  CLKOPT_PRS_C1   = BIT1
                           000000   119  CLKOPT_PRS_C0   = BIT0
                                    120 
                                    121 ; AFR option, remapable functions
                           000007   122  AFR7_BEEP    = BIT7
                           000006   123  AFR6_I2C     = BIT6
                           000005   124  AFR5_TIM1    = BIT5
                           000004   125  AFR4_TIM1    = BIT4
                           000003   126  AFR3_TIM1    = BIT3
                           000002   127  AFR2_CCO     = BIT2
                           000001   128  AFR1_TIM2    = BIT1
                           000000   129  AFR0_ADC     = BIT0
                                    130 
                                    131 ; device ID = (read only)
                           0048CD   132  DEVID_XL  = (0x48CD)
                           0048CE   133  DEVID_XH  = (0x48CE)
                           0048CF   134  DEVID_YL  = (0x48CF)
                           0048D0   135  DEVID_YH  = (0x48D0)
                           0048D1   136  DEVID_WAF  = (0x48D1)
                           0048D2   137  DEVID_LOT0  = (0x48D2)
                           0048D3   138  DEVID_LOT1  = (0x48D3)
                           0048D4   139  DEVID_LOT2  = (0x48D4)
                           0048D5   140  DEVID_LOT3  = (0x48D5)
                           0048D6   141  DEVID_LOT4  = (0x48D6)
                           0048D7   142  DEVID_LOT5  = (0x48D7)
                           0048D8   143  DEVID_LOT6  = (0x48D8)
                                    144 
                                    145 
                           005000   146 GPIO_BASE = (0x5000)
                           000005   147 GPIO_SIZE = (5)
                                    148 ; PORTS SFR OFFSET
                           000000   149 PA = 0
                           000005   150 PB = 5
                           00000A   151 PC = 10
                           00000F   152 PD = 15
                           000014   153 PE = 20
                           000019   154 PF = 25
                           00001E   155 PG = 30
                                    156 
                                    157 ; GPIO
                                    158 ; gpio register offset to base
                           000000   159  GPIO_ODR = 0
                           000001   160  GPIO_IDR = 1
                           000002   161  GPIO_DDR = 2
                           000003   162  GPIO_CR1 = 3
                           000004   163  GPIO_CR2 = 4
                                    164 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                                    165 ; port A
                           005000   166  PA_BASE = (0X5000)
                           005000   167  PA_ODR  = (0x5000)
                           005001   168  PA_IDR  = (0x5001)
                           005002   169  PA_DDR  = (0x5002)
                           005003   170  PA_CR1  = (0x5003)
                           005004   171  PA_CR2  = (0x5004)
                                    172 ; port B
                           005005   173  PB_BASE = (0X5005)
                           005005   174  PB_ODR  = (0x5005)
                           005006   175  PB_IDR  = (0x5006)
                           005007   176  PB_DDR  = (0x5007)
                           005008   177  PB_CR1  = (0x5008)
                           005009   178  PB_CR2  = (0x5009)
                                    179 ; port C
                           00500A   180  PC_BASE = (0X500A)
                           00500A   181  PC_ODR  = (0x500A)
                           00500B   182  PC_IDR  = (0x500B)
                           00500C   183  PC_DDR  = (0x500C)
                           00500D   184  PC_CR1  = (0x500D)
                           00500E   185  PC_CR2  = (0x500E)
                                    186 ; port D
                           00500F   187  PD_BASE = (0X500F)
                           00500F   188  PD_ODR  = (0x500F)
                           005010   189  PD_IDR  = (0x5010)
                           005011   190  PD_DDR  = (0x5011)
                           005012   191  PD_CR1  = (0x5012)
                           005013   192  PD_CR2  = (0x5013)
                                    193 ; port E
                           005014   194  PE_BASE = (0X5014)
                           005014   195  PE_ODR  = (0x5014)
                           005015   196  PE_IDR  = (0x5015)
                           005016   197  PE_DDR  = (0x5016)
                           005017   198  PE_CR1  = (0x5017)
                           005018   199  PE_CR2  = (0x5018)
                                    200 ; port F
                           005019   201  PF_BASE = (0X5019)
                           005019   202  PF_ODR  = (0x5019)
                           00501A   203  PF_IDR  = (0x501A)
                           00501B   204  PF_DDR  = (0x501B)
                           00501C   205  PF_CR1  = (0x501C)
                           00501D   206  PF_CR2  = (0x501D)
                                    207 ; port G
                           00501E   208  PG_BASE = (0X501E)
                           00501E   209  PG_ODR  = (0x501E)
                           00501F   210  PG_IDR  = (0x501F)
                           005020   211  PG_DDR  = (0x5020)
                           005021   212  PG_CR1  = (0x5021)
                           005022   213  PG_CR2  = (0x5022)
                                    214 ; port H not present on LQFP48/LQFP64 package
                           005023   215  PH_BASE = (0X5023)
                           005023   216  PH_ODR  = (0x5023)
                           005024   217  PH_IDR  = (0x5024)
                           005025   218  PH_DDR  = (0x5025)
                           005026   219  PH_CR1  = (0x5026)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



                           005027   220  PH_CR2  = (0x5027)
                                    221 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                           005028   222  PI_BASE = (0X5028)
                           005028   223  PI_ODR  = (0x5028)
                           005029   224  PI_IDR  = (0x5029)
                           00502A   225  PI_DDR  = (0x502a)
                           00502B   226  PI_CR1  = (0x502b)
                           00502C   227  PI_CR2  = (0x502c)
                                    228 
                                    229 ; input modes CR1
                           000000   230  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   231  INPUT_PULLUP = (1)
                                    232 ; output mode CR1
                           000000   233  OUTPUT_OD = (0) ; open drain
                           000001   234  OUTPUT_PP = (1) ; push pull
                                    235 ; input modes CR2
                           000000   236  INPUT_DI = (0)
                           000001   237  INPUT_EI = (1)
                                    238 ; output speed CR2
                           000000   239  OUTPUT_SLOW = (0)
                           000001   240  OUTPUT_FAST = (1)
                                    241 
                                    242 
                                    243 ; Flash memory
                           00505A   244  FLASH_CR1  = (0x505A)
                           00505B   245  FLASH_CR2  = (0x505B)
                           00505C   246  FLASH_NCR2  = (0x505C)
                           00505D   247  FLASH_FPR  = (0x505D)
                           00505E   248  FLASH_NFPR  = (0x505E)
                           00505F   249  FLASH_IAPSR  = (0x505F)
                           005062   250  FLASH_PUKR  = (0x5062)
                           005064   251  FLASH_DUKR  = (0x5064)
                                    252 ; data memory unlock keys
                           0000AE   253  FLASH_DUKR_KEY1 = (0xae)
                           000056   254  FLASH_DUKR_KEY2 = (0x56)
                                    255 ; flash memory unlock keys
                           000056   256  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   257  FLASH_PUKR_KEY2 = (0xae)
                                    258 ; FLASH_CR1 bits
                           000003   259  FLASH_CR1_HALT = BIT3
                           000002   260  FLASH_CR1_AHALT = BIT2
                           000001   261  FLASH_CR1_IE = BIT1
                           000000   262  FLASH_CR1_FIX = BIT0
                                    263 ; FLASH_CR2 bits
                           000007   264  FLASH_CR2_OPT = BIT7
                           000006   265  FLASH_CR2_WPRG = BIT6
                           000005   266  FLASH_CR2_ERASE = BIT5
                           000004   267  FLASH_CR2_FPRG = BIT4
                           000000   268  FLASH_CR2_PRG = BIT0
                                    269 ; FLASH_FPR bits
                           000005   270  FLASH_FPR_WPB5 = BIT5
                           000004   271  FLASH_FPR_WPB4 = BIT4
                           000003   272  FLASH_FPR_WPB3 = BIT3
                           000002   273  FLASH_FPR_WPB2 = BIT2
                           000001   274  FLASH_FPR_WPB1 = BIT1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                           000000   275  FLASH_FPR_WPB0 = BIT0
                                    276 ; FLASH_NFPR bits
                           000005   277  FLASH_NFPR_NWPB5 = BIT5
                           000004   278  FLASH_NFPR_NWPB4 = BIT4
                           000003   279  FLASH_NFPR_NWPB3 = BIT3
                           000002   280  FLASH_NFPR_NWPB2 = BIT2
                           000001   281  FLASH_NFPR_NWPB1 = BIT1
                           000000   282  FLASH_NFPR_NWPB0 = BIT0
                                    283 ; FLASH_IAPSR bits
                           000006   284  FLASH_IAPSR_HVOFF = BIT6
                           000003   285  FLASH_IAPSR_DUL = BIT3
                           000002   286  FLASH_IAPSR_EOP = BIT2
                           000001   287  FLASH_IAPSR_PUL = BIT1
                           000000   288  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    289 
                                    290 ; Interrupt control
                           0050A0   291  EXTI_CR1  = (0x50A0)
                           0050A1   292  EXTI_CR2  = (0x50A1)
                                    293 
                                    294 ; Reset Status
                           0050B3   295  RST_SR  = (0x50B3)
                                    296 
                                    297 ; Clock Registers
                           0050C0   298  CLK_ICKR  = (0x50c0)
                           0050C1   299  CLK_ECKR  = (0x50c1)
                           0050C3   300  CLK_CMSR  = (0x50C3)
                           0050C4   301  CLK_SWR  = (0x50C4)
                           0050C5   302  CLK_SWCR  = (0x50C5)
                           0050C6   303  CLK_CKDIVR  = (0x50C6)
                           0050C7   304  CLK_PCKENR1  = (0x50C7)
                           0050C8   305  CLK_CSSR  = (0x50C8)
                           0050C9   306  CLK_CCOR  = (0x50C9)
                           0050CA   307  CLK_PCKENR2  = (0x50CA)
                           0050CC   308  CLK_HSITRIMR  = (0x50CC)
                           0050CD   309  CLK_SWIMCCR  = (0x50CD)
                                    310 
                                    311 ; Peripherals clock gating
                                    312 ; CLK_PCKENR1 
                           000007   313  CLK_PCKENR1_TIM1 = (7)
                           000006   314  CLK_PCKENR1_TIM3 = (6)
                           000005   315  CLK_PCKENR1_TIM2 = (5)
                           000004   316  CLK_PCKENR1_TIM4 = (4)
                           000003   317  CLK_PCKENR1_UART3 = (3)
                           000002   318  CLK_PCKENR1_UART1 = (2)
                           000001   319  CLK_PCKENR1_SPI = (1)
                           000000   320  CLK_PCKENR1_I2C = (0)
                                    321 ; CLK_PCKENR2
                           000007   322  CLK_PCKENR2_CAN = (7)
                           000003   323  CLK_PCKENR2_ADC = (3)
                           000002   324  CLK_PCKENR2_AWU = (2)
                                    325 
                                    326 ; Clock bits
                           000005   327  CLK_ICKR_REGAH = (5)
                           000004   328  CLK_ICKR_LSIRDY = (4)
                           000003   329  CLK_ICKR_LSIEN = (3)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                           000002   330  CLK_ICKR_FHW = (2)
                           000001   331  CLK_ICKR_HSIRDY = (1)
                           000000   332  CLK_ICKR_HSIEN = (0)
                                    333 
                           000001   334  CLK_ECKR_HSERDY = (1)
                           000000   335  CLK_ECKR_HSEEN = (0)
                                    336 ; clock source
                           0000E1   337  CLK_SWR_HSI = 0xE1
                           0000D2   338  CLK_SWR_LSI = 0xD2
                           0000B4   339  CLK_SWR_HSE = 0xB4
                                    340 
                           000003   341  CLK_SWCR_SWIF = (3)
                           000002   342  CLK_SWCR_SWIEN = (2)
                           000001   343  CLK_SWCR_SWEN = (1)
                           000000   344  CLK_SWCR_SWBSY = (0)
                                    345 
                           000004   346  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   347  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   348  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   349  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   350  CLK_CKDIVR_CPUDIV0 = (0)
                                    351 
                                    352 ; Watchdog
                           0050D1   353  WWDG_CR  = (0x50D1)
                           0050D2   354  WWDG_WR  = (0x50D2)
                           0050E0   355  IWDG_KR  = (0x50E0)
                           0050E1   356  IWDG_PR  = (0x50E1)
                           0050E2   357  IWDG_RLR  = (0x50E2)
                           0050F0   358  AWU_CSR1  = (0x50F0)
                           0050F1   359  AWU_APR  = (0x50F1)
                           0050F2   360  AWU_TBR  = (0x50F2)
                                    361 
                                    362 ; Beeper
                                    363 ; beeper output is alternate function AFR7 on PD4
                                    364 ; connected to CN9-6
                           0050F3   365  BEEP_CSR  = (0x50F3)
                           00000F   366  BEEP_PORT = PD
                           000004   367  BEEP_BIT = 4
                           000010   368  BEEP_MASK = B4_MASK
                                    369 
                                    370 ; SPI
                           005200   371  SPI_CR1  = (0x5200)
                           005201   372  SPI_CR2  = (0x5201)
                           005202   373  SPI_ICR  = (0x5202)
                           005203   374  SPI_SR  = (0x5203)
                           005204   375  SPI_DR  = (0x5204)
                           005205   376  SPI_CRCPR  = (0x5205)
                           005206   377  SPI_RXCRCR  = (0x5206)
                           005207   378  SPI_TXCRCR  = (0x5207)
                                    379 
                                    380 ; I2C
                           005210   381  I2C_CR1  = (0x5210)
                           005211   382  I2C_CR2  = (0x5211)
                           005212   383  I2C_FREQR  = (0x5212)
                           005213   384  I2C_OARL  = (0x5213)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                           005214   385  I2C_OARH  = (0x5214)
                           005216   386  I2C_DR  = (0x5216)
                           005217   387  I2C_SR1  = (0x5217)
                           005218   388  I2C_SR2  = (0x5218)
                           005219   389  I2C_SR3  = (0x5219)
                           00521A   390  I2C_ITR  = (0x521A)
                           00521B   391  I2C_CCRL  = (0x521B)
                           00521C   392  I2C_CCRH  = (0x521C)
                           00521D   393  I2C_TRISER  = (0x521D)
                           00521E   394  I2C_PECR  = (0x521E)
                                    395 
                           000007   396  I2C_CR1_NOSTRETCH = (7)
                           000006   397  I2C_CR1_ENGC = (6)
                           000000   398  I2C_CR1_PE = (0)
                                    399 
                           000007   400  I2C_CR2_SWRST = (7)
                           000003   401  I2C_CR2_POS = (3)
                           000002   402  I2C_CR2_ACK = (2)
                           000001   403  I2C_CR2_STOP = (1)
                           000000   404  I2C_CR2_START = (0)
                                    405 
                           000000   406  I2C_OARL_ADD0 = (0)
                                    407 
                           000009   408  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   409  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    410 
                           000007   411  I2C_OARH_ADDMODE = (7)
                           000006   412  I2C_OARH_ADDCONF = (6)
                           000002   413  I2C_OARH_ADD9 = (2)
                           000001   414  I2C_OARH_ADD8 = (1)
                                    415 
                           000007   416  I2C_SR1_TXE = (7)
                           000006   417  I2C_SR1_RXNE = (6)
                           000004   418  I2C_SR1_STOPF = (4)
                           000003   419  I2C_SR1_ADD10 = (3)
                           000002   420  I2C_SR1_BTF = (2)
                           000001   421  I2C_SR1_ADDR = (1)
                           000000   422  I2C_SR1_SB = (0)
                                    423 
                           000005   424  I2C_SR2_WUFH = (5)
                           000003   425  I2C_SR2_OVR = (3)
                           000002   426  I2C_SR2_AF = (2)
                           000001   427  I2C_SR2_ARLO = (1)
                           000000   428  I2C_SR2_BERR = (0)
                                    429 
                           000007   430  I2C_SR3_DUALF = (7)
                           000004   431  I2C_SR3_GENCALL = (4)
                           000002   432  I2C_SR3_TRA = (2)
                           000001   433  I2C_SR3_BUSY = (1)
                           000000   434  I2C_SR3_MSL = (0)
                                    435 
                           000002   436  I2C_ITR_ITBUFEN = (2)
                           000001   437  I2C_ITR_ITEVTEN = (1)
                           000000   438  I2C_ITR_ITERREN = (0)
                                    439 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                                    440 ; Precalculated values, all in KHz
                           000080   441  I2C_CCRH_16MHZ_FAST_400 = 0x80
                           00000D   442  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    443 ;
                                    444 ; Fast I2C mode max rise time = 300ns
                                    445 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    446 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    447 
                           000005   448  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    449 
                           0000C0   450  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   451  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   452  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    453 
                           000080   454  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   455  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   456  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    457 
                           000000   458  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   459  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    460 ;
                                    461 ; Standard I2C mode max rise time = 1000ns
                                    462 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    463 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    464 
                           000011   465  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    466 
                           000000   467  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   468  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   469  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    470 
                           000001   471  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   472  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   473  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    474 
                           000001   475  I2C_READ = 1
                           000000   476  I2C_WRITE = 0
                                    477 
                                    478 ; baudrate constant for brr_value table access
                           000000   479 B2400=0
                           000001   480 B4800=1
                           000002   481 B9600=2
                           000003   482 B19200=3
                           000004   483 B38400=4
                           000005   484 B57600=5
                           000006   485 B115200=6
                           000007   486 B230400=7
                           000008   487 B460800=8
                           000009   488 B921600=9
                                    489 
                                    490 ; UART1 
                           005230   491  UART1_SR    = (0x5230)
                           005231   492  UART1_DR    = (0x5231)
                           005232   493  UART1_BRR1  = (0x5232)
                           005233   494  UART1_BRR2  = (0x5233)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



                           005234   495  UART1_CR1   = (0x5234)
                           005235   496  UART1_CR2   = (0x5235)
                           005236   497  UART1_CR3   = (0x5236)
                           005237   498  UART1_CR4   = (0x5237)
                           005238   499  UART1_CR5   = (0x5238)
                           005239   500  UART1_GTR   = (0x5239)
                           00523A   501  UART1_PSCR  = (0x523A)
                                    502 
                                    503 ; UART3
                           005240   504  UART3_SR    = (0x5240)
                           005241   505  UART3_DR    = (0x5241)
                           005242   506  UART3_BRR1  = (0x5242)
                           005243   507  UART3_BRR2  = (0x5243)
                           005244   508  UART3_CR1   = (0x5244)
                           005245   509  UART3_CR2   = (0x5245)
                           005246   510  UART3_CR3   = (0x5246)
                           005247   511  UART3_CR4   = (0x5247)
                           004249   512  UART3_CR6   = (0x4249)
                                    513 
                                    514 ; UART Status Register bits
                           000007   515  UART_SR_TXE = (7)
                           000006   516  UART_SR_TC = (6)
                           000005   517  UART_SR_RXNE = (5)
                           000004   518  UART_SR_IDLE = (4)
                           000003   519  UART_SR_OR = (3)
                           000002   520  UART_SR_NF = (2)
                           000001   521  UART_SR_FE = (1)
                           000000   522  UART_SR_PE = (0)
                                    523 
                                    524 ; Uart Control Register bits
                           000007   525  UART_CR1_R8 = (7)
                           000006   526  UART_CR1_T8 = (6)
                           000005   527  UART_CR1_UARTD = (5)
                           000004   528  UART_CR1_M = (4)
                           000003   529  UART_CR1_WAKE = (3)
                           000002   530  UART_CR1_PCEN = (2)
                           000001   531  UART_CR1_PS = (1)
                           000000   532  UART_CR1_PIEN = (0)
                                    533 
                           000007   534  UART_CR2_TIEN = (7)
                           000006   535  UART_CR2_TCIEN = (6)
                           000005   536  UART_CR2_RIEN = (5)
                           000004   537  UART_CR2_ILIEN = (4)
                           000003   538  UART_CR2_TEN = (3)
                           000002   539  UART_CR2_REN = (2)
                           000001   540  UART_CR2_RWU = (1)
                           000000   541  UART_CR2_SBK = (0)
                                    542 
                           000006   543  UART_CR3_LINEN = (6)
                           000005   544  UART_CR3_STOP1 = (5)
                           000004   545  UART_CR3_STOP0 = (4)
                           000003   546  UART_CR3_CLKEN = (3)
                           000002   547  UART_CR3_CPOL = (2)
                           000001   548  UART_CR3_CPHA = (1)
                           000000   549  UART_CR3_LBCL = (0)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



                                    550 
                           000006   551  UART_CR4_LBDIEN = (6)
                           000005   552  UART_CR4_LBDL = (5)
                           000004   553  UART_CR4_LBDF = (4)
                           000003   554  UART_CR4_ADD3 = (3)
                           000002   555  UART_CR4_ADD2 = (2)
                           000001   556  UART_CR4_ADD1 = (1)
                           000000   557  UART_CR4_ADD0 = (0)
                                    558 
                           000005   559  UART_CR5_SCEN = (5)
                           000004   560  UART_CR5_NACK = (4)
                           000003   561  UART_CR5_HDSEL = (3)
                           000002   562  UART_CR5_IRLP = (2)
                           000001   563  UART_CR5_IREN = (1)
                                    564 ; LIN mode config register
                           000007   565  UART_CR6_LDUM = (7)
                           000005   566  UART_CR6_LSLV = (5)
                           000004   567  UART_CR6_LASE = (4)
                           000002   568  UART_CR6_LHDIEN = (2) 
                           000001   569  UART_CR6_LHDF = (1)
                           000000   570  UART_CR6_LSF = (0)
                                    571 
                                    572 ; TIMERS
                                    573 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   574  TIM1_CR1  = (0x5250)
                           005251   575  TIM1_CR2  = (0x5251)
                           005252   576  TIM1_SMCR  = (0x5252)
                           005253   577  TIM1_ETR  = (0x5253)
                           005254   578  TIM1_IER  = (0x5254)
                           005255   579  TIM1_SR1  = (0x5255)
                           005256   580  TIM1_SR2  = (0x5256)
                           005257   581  TIM1_EGR  = (0x5257)
                           005258   582  TIM1_CCMR1  = (0x5258)
                           005259   583  TIM1_CCMR2  = (0x5259)
                           00525A   584  TIM1_CCMR3  = (0x525A)
                           00525B   585  TIM1_CCMR4  = (0x525B)
                           00525C   586  TIM1_CCER1  = (0x525C)
                           00525D   587  TIM1_CCER2  = (0x525D)
                           00525E   588  TIM1_CNTRH  = (0x525E)
                           00525F   589  TIM1_CNTRL  = (0x525F)
                           005260   590  TIM1_PSCRH  = (0x5260)
                           005261   591  TIM1_PSCRL  = (0x5261)
                           005262   592  TIM1_ARRH  = (0x5262)
                           005263   593  TIM1_ARRL  = (0x5263)
                           005264   594  TIM1_RCR  = (0x5264)
                           005265   595  TIM1_CCR1H  = (0x5265)
                           005266   596  TIM1_CCR1L  = (0x5266)
                           005267   597  TIM1_CCR2H  = (0x5267)
                           005268   598  TIM1_CCR2L  = (0x5268)
                           005269   599  TIM1_CCR3H  = (0x5269)
                           00526A   600  TIM1_CCR3L  = (0x526A)
                           00526B   601  TIM1_CCR4H  = (0x526B)
                           00526C   602  TIM1_CCR4L  = (0x526C)
                           00526D   603  TIM1_BKR  = (0x526D)
                           00526E   604  TIM1_DTR  = (0x526E)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                           00526F   605  TIM1_OISR  = (0x526F)
                                    606 
                                    607 ; Timer Control Register bits
                           000007   608  TIM_CR1_ARPE = (7)
                           000006   609  TIM_CR1_CMSH = (6)
                           000005   610  TIM_CR1_CMSL = (5)
                           000004   611  TIM_CR1_DIR = (4)
                           000003   612  TIM_CR1_OPM = (3)
                           000002   613  TIM_CR1_URS = (2)
                           000001   614  TIM_CR1_UDIS = (1)
                           000000   615  TIM_CR1_CEN = (0)
                                    616 
                           000006   617  TIM1_CR2_MMS2 = (6)
                           000005   618  TIM1_CR2_MMS1 = (5)
                           000004   619  TIM1_CR2_MMS0 = (4)
                           000002   620  TIM1_CR2_COMS = (2)
                           000000   621  TIM1_CR2_CCPC = (0)
                                    622 
                                    623 ; Timer Slave Mode Control bits
                           000007   624  TIM1_SMCR_MSM = (7)
                           000006   625  TIM1_SMCR_TS2 = (6)
                           000005   626  TIM1_SMCR_TS1 = (5)
                           000004   627  TIM1_SMCR_TS0 = (4)
                           000002   628  TIM1_SMCR_SMS2 = (2)
                           000001   629  TIM1_SMCR_SMS1 = (1)
                           000000   630  TIM1_SMCR_SMS0 = (0)
                                    631 
                                    632 ; Timer External Trigger Enable bits
                           000007   633  TIM1_ETR_ETP = (7)
                           000006   634  TIM1_ETR_ECE = (6)
                           000005   635  TIM1_ETR_ETPS1 = (5)
                           000004   636  TIM1_ETR_ETPS0 = (4)
                           000003   637  TIM1_ETR_ETF3 = (3)
                           000002   638  TIM1_ETR_ETF2 = (2)
                           000001   639  TIM1_ETR_ETF1 = (1)
                           000000   640  TIM1_ETR_ETF0 = (0)
                                    641 
                                    642 ; Timer Interrupt Enable bits
                           000007   643  TIM1_IER_BIE = (7)
                           000006   644  TIM1_IER_TIE = (6)
                           000005   645  TIM1_IER_COMIE = (5)
                           000004   646  TIM1_IER_CC4IE = (4)
                           000003   647  TIM1_IER_CC3IE = (3)
                           000002   648  TIM1_IER_CC2IE = (2)
                           000001   649  TIM1_IER_CC1IE = (1)
                           000000   650  TIM1_IER_UIE = (0)
                                    651 
                                    652 ; Timer Status Register bits
                           000007   653  TIM1_SR1_BIF = (7)
                           000006   654  TIM1_SR1_TIF = (6)
                           000005   655  TIM1_SR1_COMIF = (5)
                           000004   656  TIM1_SR1_CC4IF = (4)
                           000003   657  TIM1_SR1_CC3IF = (3)
                           000002   658  TIM1_SR1_CC2IF = (2)
                           000001   659  TIM1_SR1_CC1IF = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



                           000000   660  TIM1_SR1_UIF = (0)
                                    661 
                           000004   662  TIM1_SR2_CC4OF = (4)
                           000003   663  TIM1_SR2_CC3OF = (3)
                           000002   664  TIM1_SR2_CC2OF = (2)
                           000001   665  TIM1_SR2_CC1OF = (1)
                                    666 
                                    667 ; Timer Event Generation Register bits
                           000007   668  TIM1_EGR_BG = (7)
                           000006   669  TIM1_EGR_TG = (6)
                           000005   670  TIM1_EGR_COMG = (5)
                           000004   671  TIM1_EGR_CC4G = (4)
                           000003   672  TIM1_EGR_CC3G = (3)
                           000002   673  TIM1_EGR_CC2G = (2)
                           000001   674  TIM1_EGR_CC1G = (1)
                           000000   675  TIM1_EGR_UG = (0)
                                    676 
                                    677 ; Capture/Compare Mode Register 1 - channel configured in output
                           000007   678  TIM1_CCMR1_OC1CE = (7)
                           000006   679  TIM1_CCMR1_OC1M2 = (6)
                           000005   680  TIM1_CCMR1_OC1M1 = (5)
                           000004   681  TIM1_CCMR1_OC1M0 = (4)
                           000003   682  TIM1_CCMR1_OC1PE = (3)
                           000002   683  TIM1_CCMR1_OC1FE = (2)
                           000001   684  TIM1_CCMR1_CC1S1 = (1)
                           000000   685  TIM1_CCMR1_CC1S0 = (0)
                                    686 
                                    687 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   688  TIM1_CCMR1_IC1F3 = (7)
                           000006   689  TIM1_CCMR1_IC1F2 = (6)
                           000005   690  TIM1_CCMR1_IC1F1 = (5)
                           000004   691  TIM1_CCMR1_IC1F0 = (4)
                           000003   692  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   693  TIM1_CCMR1_IC1PSC0 = (2)
                                    694 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   695  TIM1_CCMR1_CC1S0 = (0)
                                    696 
                                    697 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   698  TIM1_CCMR2_OC2CE = (7)
                           000006   699  TIM1_CCMR2_OC2M2 = (6)
                           000005   700  TIM1_CCMR2_OC2M1 = (5)
                           000004   701  TIM1_CCMR2_OC2M0 = (4)
                           000003   702  TIM1_CCMR2_OC2PE = (3)
                           000002   703  TIM1_CCMR2_OC2FE = (2)
                           000001   704  TIM1_CCMR2_CC2S1 = (1)
                           000000   705  TIM1_CCMR2_CC2S0 = (0)
                                    706 
                                    707 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   708  TIM1_CCMR2_IC2F3 = (7)
                           000006   709  TIM1_CCMR2_IC2F2 = (6)
                           000005   710  TIM1_CCMR2_IC2F1 = (5)
                           000004   711  TIM1_CCMR2_IC2F0 = (4)
                           000003   712  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   713  TIM1_CCMR2_IC2PSC0 = (2)
                                    714 ;  TIM1_CCMR2_CC2S1 = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



                           000000   715  TIM1_CCMR2_CC2S0 = (0)
                                    716 
                                    717 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   718  TIM1_CCMR3_OC3CE = (7)
                           000006   719  TIM1_CCMR3_OC3M2 = (6)
                           000005   720  TIM1_CCMR3_OC3M1 = (5)
                           000004   721  TIM1_CCMR3_OC3M0 = (4)
                           000003   722  TIM1_CCMR3_OC3PE = (3)
                           000002   723  TIM1_CCMR3_OC3FE = (2)
                           000001   724  TIM1_CCMR3_CC3S1 = (1)
                           000000   725  TIM1_CCMR3_CC3S0 = (0)
                                    726 
                                    727 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   728  TIM1_CCMR3_IC3F3 = (7)
                           000006   729  TIM1_CCMR3_IC3F2 = (6)
                           000005   730  TIM1_CCMR3_IC3F1 = (5)
                           000004   731  TIM1_CCMR3_IC3F0 = (4)
                           000003   732  TIM1_CCMR3_IC3PSC1 = (3)
                           000002   733  TIM1_CCMR3_IC3PSC0 = (2)
                                    734 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   735  TIM1_CCMR3_CC3S0 = (0)
                                    736 
                                    737 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   738  TIM1_CCMR4_OC4CE = (7)
                           000006   739  TIM1_CCMR4_OC4M2 = (6)
                           000005   740  TIM1_CCMR4_OC4M1 = (5)
                           000004   741  TIM1_CCMR4_OC4M0 = (4)
                           000003   742  TIM1_CCMR4_OC4PE = (3)
                           000002   743  TIM1_CCMR4_OC4FE = (2)
                           000001   744  TIM1_CCMR4_CC4S1 = (1)
                           000000   745  TIM1_CCMR4_CC4S0 = (0)
                                    746 
                                    747 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   748  TIM1_CCMR4_IC4F3 = (7)
                           000006   749  TIM1_CCMR4_IC4F2 = (6)
                           000005   750  TIM1_CCMR4_IC4F1 = (5)
                           000004   751  TIM1_CCMR4_IC4F0 = (4)
                           000003   752  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   753  TIM1_CCMR4_IC4PSC0 = (2)
                                    754 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   755  TIM1_CCMR4_CC4S0 = (0)
                                    756 
                                    757 ; Timer 2 - 16-bit timer
                           005300   758  TIM2_CR1  = (0x5300)
                           005301   759  TIM2_IER  = (0x5301)
                           005302   760  TIM2_SR1  = (0x5302)
                           005303   761  TIM2_SR2  = (0x5303)
                           005304   762  TIM2_EGR  = (0x5304)
                           005305   763  TIM2_CCMR1  = (0x5305)
                           005306   764  TIM2_CCMR2  = (0x5306)
                           005307   765  TIM2_CCMR3  = (0x5307)
                           005308   766  TIM2_CCER1  = (0x5308)
                           005309   767  TIM2_CCER2  = (0x5309)
                           00530A   768  TIM2_CNTRH  = (0x530A)
                           00530B   769  TIM2_CNTRL  = (0x530B)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



                           00530C   770  TIM2_PSCR  = (0x530C)
                           00530D   771  TIM2_ARRH  = (0x530D)
                           00530E   772  TIM2_ARRL  = (0x530E)
                           00530F   773  TIM2_CCR1H  = (0x530F)
                           005310   774  TIM2_CCR1L  = (0x5310)
                           005311   775  TIM2_CCR2H  = (0x5311)
                           005312   776  TIM2_CCR2L  = (0x5312)
                           005313   777  TIM2_CCR3H  = (0x5313)
                           005314   778  TIM2_CCR3L  = (0x5314)
                                    779 
                                    780 ; Timer 3
                           005320   781  TIM3_CR1  = (0x5320)
                           005321   782  TIM3_IER  = (0x5321)
                           005322   783  TIM3_SR1  = (0x5322)
                           005323   784  TIM3_SR2  = (0x5323)
                           005324   785  TIM3_EGR  = (0x5324)
                           005325   786  TIM3_CCMR1  = (0x5325)
                           005326   787  TIM3_CCMR2  = (0x5326)
                           005327   788  TIM3_CCER1  = (0x5327)
                           005328   789  TIM3_CNTRH  = (0x5328)
                           005329   790  TIM3_CNTRL  = (0x5329)
                           00532A   791  TIM3_PSCR  = (0x532A)
                           00532B   792  TIM3_ARRH  = (0x532B)
                           00532C   793  TIM3_ARRL  = (0x532C)
                           00532D   794  TIM3_CCR1H  = (0x532D)
                           00532E   795  TIM3_CCR1L  = (0x532E)
                           00532F   796  TIM3_CCR2H  = (0x532F)
                           005330   797  TIM3_CCR2L  = (0x5330)
                                    798 
                                    799 ; TIM3_CR1  fields
                           000000   800  TIM3_CR1_CEN = (0)
                           000001   801  TIM3_CR1_UDIS = (1)
                           000002   802  TIM3_CR1_URS = (2)
                           000003   803  TIM3_CR1_OPM = (3)
                           000007   804  TIM3_CR1_ARPE = (7)
                                    805 ; TIM3_CCR2  fields
                           000000   806  TIM3_CCMR2_CC2S_POS = (0)
                           000003   807  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   808  TIM3_CCMR2_OC2M_POS = (4)  
                                    809 ; TIM3_CCER1 fields
                           000000   810  TIM3_CCER1_CC1E = (0)
                           000001   811  TIM3_CCER1_CC1P = (1)
                           000004   812  TIM3_CCER1_CC2E = (4)
                           000005   813  TIM3_CCER1_CC2P = (5)
                                    814 ; TIM3_CCER2 fields
                           000000   815  TIM3_CCER2_CC3E = (0)
                           000001   816  TIM3_CCER2_CC3P = (1)
                                    817 
                                    818 ; Timer 4
                           005340   819  TIM4_CR1  = (0x5340)
                           005341   820  TIM4_IER  = (0x5341)
                           005342   821  TIM4_SR  = (0x5342)
                           005343   822  TIM4_EGR  = (0x5343)
                           005344   823  TIM4_CNTR  = (0x5344)
                           005345   824  TIM4_PSCR  = (0x5345)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



                           005346   825  TIM4_ARR  = (0x5346)
                                    826 
                                    827 ; Timer 4 bitmasks
                                    828 
                           000007   829  TIM4_CR1_ARPE = (7)
                           000003   830  TIM4_CR1_OPM = (3)
                           000002   831  TIM4_CR1_URS = (2)
                           000001   832  TIM4_CR1_UDIS = (1)
                           000000   833  TIM4_CR1_CEN = (0)
                                    834 
                           000000   835  TIM4_IER_UIE = (0)
                                    836 
                           000000   837  TIM4_SR_UIF = (0)
                                    838 
                           000000   839  TIM4_EGR_UG = (0)
                                    840 
                           000002   841  TIM4_PSCR_PSC2 = (2)
                           000001   842  TIM4_PSCR_PSC1 = (1)
                           000000   843  TIM4_PSCR_PSC0 = (0)
                                    844 
                           000000   845  TIM4_PSCR_1 = 0
                           000001   846  TIM4_PSCR_2 = 1
                           000002   847  TIM4_PSCR_4 = 2
                           000003   848  TIM4_PSCR_8 = 3
                           000004   849  TIM4_PSCR_16 = 4
                           000005   850  TIM4_PSCR_32 = 5
                           000006   851  TIM4_PSCR_64 = 6
                           000007   852  TIM4_PSCR_128 = 7
                                    853 
                                    854 ; ADC2
                           005400   855  ADC_CSR  = (0x5400)
                           005401   856  ADC_CR1  = (0x5401)
                           005402   857  ADC_CR2  = (0x5402)
                           005403   858  ADC_CR3  = (0x5403)
                           005404   859  ADC_DRH  = (0x5404)
                           005405   860  ADC_DRL  = (0x5405)
                           005406   861  ADC_TDRH  = (0x5406)
                           005407   862  ADC_TDRL  = (0x5407)
                                    863  
                                    864 ; ADC bitmasks
                                    865 
                           000007   866  ADC_CSR_EOC = (7)
                           000006   867  ADC_CSR_AWD = (6)
                           000005   868  ADC_CSR_EOCIE = (5)
                           000004   869  ADC_CSR_AWDIE = (4)
                           000003   870  ADC_CSR_CH3 = (3)
                           000002   871  ADC_CSR_CH2 = (2)
                           000001   872  ADC_CSR_CH1 = (1)
                           000000   873  ADC_CSR_CH0 = (0)
                                    874 
                           000006   875  ADC_CR1_SPSEL2 = (6)
                           000005   876  ADC_CR1_SPSEL1 = (5)
                           000004   877  ADC_CR1_SPSEL0 = (4)
                           000001   878  ADC_CR1_CONT = (1)
                           000000   879  ADC_CR1_ADON = (0)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                                    880 
                           000006   881  ADC_CR2_EXTTRIG = (6)
                           000005   882  ADC_CR2_EXTSEL1 = (5)
                           000004   883  ADC_CR2_EXTSEL0 = (4)
                           000003   884  ADC_CR2_ALIGN = (3)
                           000001   885  ADC_CR2_SCAN = (1)
                                    886 
                           000007   887  ADC_CR3_DBUF = (7)
                           000006   888  ADC_CR3_DRH = (6)
                                    889 
                                    890 ; beCAN
                           005420   891  CAN_MCR = (0x5420)
                           005421   892  CAN_MSR = (0x5421)
                           005422   893  CAN_TSR = (0x5422)
                           005423   894  CAN_TPR = (0x5423)
                           005424   895  CAN_RFR = (0x5424)
                           005425   896  CAN_IER = (0x5425)
                           005426   897  CAN_DGR = (0x5426)
                           005427   898  CAN_FPSR = (0x5427)
                           005428   899  CAN_P0 = (0x5428)
                           005429   900  CAN_P1 = (0x5429)
                           00542A   901  CAN_P2 = (0x542A)
                           00542B   902  CAN_P3 = (0x542B)
                           00542C   903  CAN_P4 = (0x542C)
                           00542D   904  CAN_P5 = (0x542D)
                           00542E   905  CAN_P6 = (0x542E)
                           00542F   906  CAN_P7 = (0x542F)
                           005430   907  CAN_P8 = (0x5430)
                           005431   908  CAN_P9 = (0x5431)
                           005432   909  CAN_PA = (0x5432)
                           005433   910  CAN_PB = (0x5433)
                           005434   911  CAN_PC = (0x5434)
                           005435   912  CAN_PD = (0x5435)
                           005436   913  CAN_PE = (0x5436)
                           005437   914  CAN_PF = (0x5437)
                                    915 
                                    916 
                                    917 ; CPU
                           007F00   918  CPU_A  = (0x7F00)
                           007F01   919  CPU_PCE  = (0x7F01)
                           007F02   920  CPU_PCH  = (0x7F02)
                           007F03   921  CPU_PCL  = (0x7F03)
                           007F04   922  CPU_XH  = (0x7F04)
                           007F05   923  CPU_XL  = (0x7F05)
                           007F06   924  CPU_YH  = (0x7F06)
                           007F07   925  CPU_YL  = (0x7F07)
                           007F08   926  CPU_SPH  = (0x7F08)
                           007F09   927  CPU_SPL   = (0x7F09)
                           007F0A   928  CPU_CCR   = (0x7F0A)
                                    929 
                                    930 ; global configuration register
                           007F60   931  CFG_GCR   = (0x7F60)
                           000001   932  CFG_GCR_AL = 1
                           000000   933  CFG_GCR_SWIM = 0
                                    934 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                                    935 ; interrupt control registers
                           007F70   936  ITC_SPR1   = (0x7F70)
                           007F71   937  ITC_SPR2   = (0x7F71)
                           007F72   938  ITC_SPR3   = (0x7F72)
                           007F73   939  ITC_SPR4   = (0x7F73)
                           007F74   940  ITC_SPR5   = (0x7F74)
                           007F75   941  ITC_SPR6   = (0x7F75)
                           007F76   942  ITC_SPR7   = (0x7F76)
                           007F77   943  ITC_SPR8   = (0x7F77)
                                    944 
                                    945 ; SWIM, control and status register
                           007F80   946  SWIM_CSR   = (0x7F80)
                                    947 ; debug registers
                           007F90   948  DM_BK1RE   = (0x7F90)
                           007F91   949  DM_BK1RH   = (0x7F91)
                           007F92   950  DM_BK1RL   = (0x7F92)
                           007F93   951  DM_BK2RE   = (0x7F93)
                           007F94   952  DM_BK2RH   = (0x7F94)
                           007F95   953  DM_BK2RL   = (0x7F95)
                           007F96   954  DM_CR1   = (0x7F96)
                           007F97   955  DM_CR2   = (0x7F97)
                           007F98   956  DM_CSR1   = (0x7F98)
                           007F99   957  DM_CSR2   = (0x7F99)
                           007F9A   958  DM_ENFCTR   = (0x7F9A)
                                    959 
                                    960 ; Interrupt Numbers
                           000000   961  INT_TLI = 0
                           000001   962  INT_AWU = 1
                           000002   963  INT_CLK = 2
                           000003   964  INT_EXTI0 = 3
                           000004   965  INT_EXTI1 = 4
                           000005   966  INT_EXTI2 = 5
                           000006   967  INT_EXTI3 = 6
                           000007   968  INT_EXTI4 = 7
                           000008   969  INT_CAN_RX = 8
                           000009   970  INT_CAN_TX = 9
                           00000A   971  INT_SPI = 10
                           00000B   972  INT_TIM1_OVF = 11
                           00000C   973  INT_TIM1_CCM = 12
                           00000D   974  INT_TIM2_OVF = 13
                           00000E   975  INT_TIM2_CCM = 14
                           00000F   976  INT_TIM3_OVF = 15
                           000010   977  INT_TIM3_CCM = 16
                           000011   978  INT_UART1_TX_COMPLETED = 17
                           000012   979  INT_AUART1_RX_FULL = 18
                           000013   980  INT_I2C = 19
                           000014   981  INT_UART3_TX_COMPLETED = 20
                           000015   982  INT_UART3_RX_FULL = 21
                           000016   983  INT_ADC2 = 22
                           000017   984  INT_TIM4_OVF = 23
                           000018   985  INT_FLASH = 24
                                    986 
                                    987 ; Interrupt Vectors
                           008000   988  INT_VECTOR_RESET = 0x8000
                           008004   989  INT_VECTOR_TRAP = 0x8004
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                           008008   990  INT_VECTOR_TLI = 0x8008
                           00800C   991  INT_VECTOR_AWU = 0x800C
                           008010   992  INT_VECTOR_CLK = 0x8010
                           008014   993  INT_VECTOR_EXTI0 = 0x8014
                           008018   994  INT_VECTOR_EXTI1 = 0x8018
                           00801C   995  INT_VECTOR_EXTI2 = 0x801C
                           008020   996  INT_VECTOR_EXTI3 = 0x8020
                           008024   997  INT_VECTOR_EXTI4 = 0x8024
                           008028   998  INT_VECTOR_CAN_RX = 0x8028
                           00802C   999  INT_VECTOR_CAN_TX = 0x802c
                           008030  1000  INT_VECTOR_SPI = 0x8030
                           008034  1001  INT_VECTOR_TIM1_OVF = 0x8034
                           008038  1002  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C  1003  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1004  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1005  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1006  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1007  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1008  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1009  INT_VECTOR_I2C = 0x8054
                           008058  1010  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1011  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1012  INT_VECTOR_ADC2 = 0x8060
                           008064  1013  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1014  INT_VECTOR_FLASH = 0x8068
                                   1015 
                                   1016  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



                                     17 
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ;           macros
                                     20 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     21     ; allume LED2
                                     22     .macro _ledon
                                     23     bset LED2_PORT,#LED2_BIT
                                     24     .endm
                                     25 
                                     26     ; éteint LED2
                                     27     .macro _ledoff
                                     28     bres LED2_PORT,#LED2_BIT
                                     29     .endm
                                     30    
                                     31     ; inverse l'état de LED2
                                     32     .macro _led_toggle
                                     33     ld a,LED2_PORT
                                     34     xor a,#LED2_MASK
                                     35     ld LED2_PORT,a
                                     36     .endm
                                     37 
                                     38     ; initialise farptr avec l'adresse étendu d'un message
                                     39     .macro _ld_farptr  msg 
                                     40     ld a,#msg>>16
                                     41     ld farptr,a
                                     42     ld a,#msg>>8
                                     43     ld farptrM,a
                                     44     ld a,#msg
                                     45     ld farptrL,a
                                     46     .endm
                                     47 
                                     48 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     49 ;       section des variables
                                     50 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     51     .area DATA
      000001                         52 farptr:  .blkb 1 ; pointeur étendu octet supérieur [23:16]
      000002                         53 farptrM: .blkb 1 ; pointeur étendu octet du milieur [15:8]
      000003                         54 farptrL: .blkb 1 ; pointeru étendu octet faible [7:0]
      000004                         55 phase:   .blkb 1 ; indique message à afficher
                                     56 
                                     57 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     58 ;       section de la pile
                                     59 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                           000100    60     STACK_SIZE = 256
                           0017FE    61     STACK_TOP = RAM_END-1
                                     62 
                                     63     .area SSEG (ABS)
      0016FF                         64     .org RAM_END-STACK_SIZE
      0016FF                         65     .ds STACK_SIZE
                                     66 
                                     67 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     68 ;     table des vecteurs d'interruption
                                     69 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     70     .area HOME
      008000 82 00 80 7C             71     int main  ; vecteur de réinitialisation
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



      008004 82 01 00 6A             72 	int NonHandledInterrupt ;TRAP  software interrupt
      008008 82 01 00 6A             73 	int NonHandledInterrupt ;int0 TLI   external top level interrupt
      00800C 82 01 00 6A             74 	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
      008010 82 01 00 6A             75 	int NonHandledInterrupt ;int2 CLK   clock controller
      008014 82 01 00 6A             76 	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
      008018 82 01 00 6A             77 	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
      00801C 82 01 00 6A             78 	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
      008020 82 01 00 6A             79 	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
      008024 82 01 00 6F             80 	int usr_btn_isr         ;int7 EXTI4 port E external interrupts
      008028 82 01 00 6A             81 	int NonHandledInterrupt ;int8 beCAN RX interrupt
      00802C 82 01 00 6A             82 	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
      008030 82 01 00 6A             83 	int NonHandledInterrupt ;int10 SPI End of transfer
      008034 82 01 00 6A             84 	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
      008038 82 01 00 6A             85 	int NonHandledInterrupt ;int12 TIM1 capture/compare
      00803C 82 01 00 6A             86 	int NonHandledInterrupt ;int13 TIM2 update /overflow
      008040 82 01 00 6A             87 	int NonHandledInterrupt ;int14 TIM2 capture/compare
      008044 82 01 00 6A             88 	int NonHandledInterrupt ;int15 TIM3 Update/overflow
      008048 82 01 00 6A             89 	int NonHandledInterrupt ;int16 TIM3 Capture/compare
      00804C 82 01 00 6A             90 	int NonHandledInterrupt ;int17 UART1 TX completed
      008050 82 01 00 6A             91 	int NonHandledInterrupt ;int18 UART1 RX full
      008054 82 01 00 6A             92 	int NonHandledInterrupt ;int19 I2C 
      008058 82 01 00 6A             93 	int NonHandledInterrupt ;int20 UART3 TX completed
      00805C 82 01 00 6A             94 	int NonHandledInterrupt ;int21 UART3 RX full
      008060 82 01 00 6A             95 	int NonHandledInterrupt ;int22 ADC2 end of conversion
      008064 82 01 00 6A             96 	int NonHandledInterrupt	;int23 TIM4 update/overflow
      008068 82 01 00 6A             97 	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
      00806C 82 01 00 6A             98 	int NonHandledInterrupt ;int25  not used
      008070 82 01 00 6A             99 	int NonHandledInterrupt ;int26  not used
      008074 82 01 00 6A            100 	int NonHandledInterrupt ;int27  not used
      008078 82 01 00 6A            101 	int NonHandledInterrupt ;int28  not used
                                    102 
                                    103     .area CODE
                                    104 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    105 ;   point d'entrée après une réinitialisation du MCU
                                    106 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00807C                        107 main:
                                    108 ; initialisation de la pile
      00807C AE 17 FE         [ 2]  109     ldw x,#STACK_TOP
      00807F 94               [ 1]  110     ldw sp,x
                                    111 ; initialise la variable farptr avec message hello
      000004                        112     _ld_farptr hello
      008080 A6 01            [ 1]    1     ld a,#hello>>16
      008082 C7 00 01         [ 1]    2     ld farptr,a
      008085 A6 00            [ 1]    3     ld a,#hello>>8
      008087 C7 00 02         [ 1]    4     ld farptrM,a
      00808A A6 7B            [ 1]    5     ld a,#hello
      00808C C7 00 03         [ 1]    6     ld farptrL,a
                                    113 ;   initialise variable phase
      00808F 72 5F 00 04      [ 1]  114     clr phase    
                                    115 ; initialise le clock système
      008093 CD 80 CA         [ 4]  116     call clock_init
                                    117 ; initialise la communication sérielle
      008096 CD 80 B1         [ 4]  118     call uart3_init        
                                    119 ; initialise la broche du LED2 en mode 
                                    120 ; sortie push pull
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



      008099 72 1A 50 0D      [ 1]  121     bset PC_CR1,#LED2_BIT
      00809D 72 1A 50 0E      [ 1]  122     bset PC_CR2,#LED2_BIT
      0080A1 72 1A 50 0C      [ 1]  123     bset PC_DDR,#LED2_BIT
                                    124 ; active l'interruption sur bouton utilisateur sur
                                    125 ; la transition descendante seulement
      0080A5 72 12 50 A1      [ 1]  126     bset EXTI_CR2,#1    
                                    127 ; active l'interruption sur PE_4 bouton utilisateur
      0080A9 72 18 50 18      [ 1]  128     bset PE_CR2,#USR_BTN_BIT
                                    129 ; active les interruptions
      0080AD 9A               [ 1]  130     rim 
                                    131 ; boucle vide. Tout est fait par l'interruption.
      0080AE 8F               [10]  132 1$: wfi
      0080AF 20 FD            [ 2]  133     jra 1$
                                    134 
                                    135 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    136 ; initialise le UART3, configuration: 115200 8N1
                                    137 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0080B1                        138 uart3_init:
                                    139 ;	bset CLK_PCKENR1,#CLK_PCKENR1_UART3
                                    140 	; configure tx pin
      0080B1 72 1A 50 11      [ 1]  141 	bset PD_DDR,#BIT5 ; tx pin
      0080B5 72 1A 50 12      [ 1]  142 	bset PD_CR1,#BIT5 ; push-pull output
      0080B9 72 1A 50 13      [ 1]  143 	bset PD_CR2,#BIT5 ; fast output
                                    144 	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
      0080BD 35 05 52 43      [ 1]  145 	mov UART3_BRR2,#0x05 ; must be loaded first
      0080C1 35 04 52 42      [ 1]  146 	mov UART3_BRR1,#0x4
      0080C5 35 0C 52 45      [ 1]  147 	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
      0080C9 81               [ 4]  148 	ret
                                    149 
                                    150 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    151 ;initialize clock, configuration HSE 8 Mhz
                                    152 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0080CA                        153 clock_init:	
      0080CA 72 12 50 C5      [ 1]  154 	bset CLK_SWCR,#CLK_SWCR_SWEN
      0080CE A6 B4            [ 1]  155 	ld a,#CLK_SWR_HSE
      0080D0 C7 50 C4         [ 1]  156 	ld CLK_SWR,a
      0080D3 C1 50 C3         [ 1]  157 1$:	cp a,CLK_CMSR
      0080D6 26 FB            [ 1]  158 	jrne 1$
      0080D8 72 5F 50 C6      [ 1]  159     clr CLK_CKDIVR
      0080DC 81               [ 4]  160 	ret
                                    161 
                                    162 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    163 ;    pointeur constant installé dans la mémoire 
                                    164 ;    flash. Les pointeurs ne peuvent-être que dans
                                    165 ;    le segment 0 i.e. 0x0000-0xffff
                                    166 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0080DD                        167 const_ptr: 
      0080DD 01 00 7B               168         .byte (hello>>16),(hello>>8),hello 
                                    169 
                                    170 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    171 ;  section de code situé dans la mémoire étendue
                                    172 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    173     .area CODE_FAR (ABS)
      010000                        174     .org 0x10000 ; segment 1 de la mémoire étendue
                                    175 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



                                    176 ;------------------------------------------
                                    177 ;  routines de communications port sériel
                                    178 ;------------------------------------------
                                    179 ;------------------------------------
                                    180 ; Transmet le caractère qui est dans A 
                                    181 ; via UART3
                                    182 ;------------------------------------
      010000                        183 uart_tx:
      010000 72 0F 52 40 FB   [ 2]  184 	btjf UART3_SR,#UART_SR_TXE,uart_tx
      010005 C7 52 41         [ 1]  185 	ld UART3_DR,a
      010008 81               [ 4]  186     ret
                                    187 
                                    188 ;------------------------------------
                                    189 ; transmet le message via UART3
                                    190 ; utilise un adresse par pointeur
                                    191 ; indexé par Y. 
                                    192 ;------------------------------------
                           000001   193     USE_PTR = 1 ; mettre à 0 pour pointeur dans mémoire flash
      010009                        194 print_msg:
      010009 89               [ 2]  195     pushw x
      01000A 90 89            [ 2]  196     pushw y
      01000C 90 5F            [ 1]  197     clrw y
                           000001   198     .if USE_PTR
                                    199     ; initialise farptr
      01000E 72 5D 00 04      [ 1]  200     tnz phase
      010012 27 27            [ 1]  201     jreq ph0 
      010014 72 00 00 04 11   [ 2]  202     btjt phase,#0,ph1
      010019                        203 ph2: 
      010019                        204     _ld_farptr reponse
      010019 A6 01            [ 1]    1     ld a,#reponse>>16
      01001B C7 00 01         [ 1]    2     ld farptr,a
      01001E A6 01            [ 1]    3     ld a,#reponse>>8
      010020 C7 00 02         [ 1]    4     ld farptrM,a
      010023 A6 0D            [ 1]    5     ld a,#reponse
      010025 C7 00 03         [ 1]    6     ld farptrL,a
      010028 20 20            [ 2]  205     jra print
      01002A                        206 ph1:
      01002A                        207     _ld_farptr trivia
      01002A A6 01            [ 1]    1     ld a,#trivia>>16
      01002C C7 00 01         [ 1]    2     ld farptr,a
      01002F A6 00            [ 1]    3     ld a,#trivia>>8
      010031 C7 00 02         [ 1]    4     ld farptrM,a
      010034 A6 98            [ 1]    5     ld a,#trivia
      010036 C7 00 03         [ 1]    6     ld farptrL,a
      010039 20 0F            [ 2]  208     jra print
      01003B                        209 ph0:
      01003B                        210     _ld_farptr hello         
      01003B A6 01            [ 1]    1     ld a,#hello>>16
      01003D C7 00 01         [ 1]    2     ld farptr,a
      010040 A6 00            [ 1]    3     ld a,#hello>>8
      010042 C7 00 02         [ 1]    4     ld farptrM,a
      010045 A6 7B            [ 1]    5     ld a,#hello
      010047 C7 00 03         [ 1]    6     ld farptrL,a
      01004A                        211 print:
      01004A 91 AF 00 01      [ 1]  212      ldf a,([farptr],y) ; addressage par pointer en RAM
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                           000000   213     .else    
                                    214 print:
                                    215 	ldf a,([const_ptr],y)  ; adressage indexé avec offset étendu
                                    216     .endif
      01004E 27 07            [ 1]  217 	jreq 9$
      010050 CD 00 00         [ 4]  218 	call uart_tx
      010053 90 5C            [ 1]  219 	incw y
      010055 20 F3            [ 2]  220 	jra print
      010057                        221 9$:
                           000001   222     .if USE_PTR
      010057 72 5C 00 04      [ 1]  223     inc phase
      01005B A6 03            [ 1]  224     ld a,#3
      01005D C1 00 04         [ 1]  225     cp a,phase
      010060 26 04            [ 1]  226     jrne 10$
      010062 72 5F 00 04      [ 1]  227     clr phase
                                    228     .endif
      010066                        229 10$:    
      010066 90 85            [ 2]  230     popw y
      010068 85               [ 2]  231     popw x
      010069 81               [ 4]  232     ret
                                    233 
                                    234 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    235 ;	gestionnaire d'interruption pour
                                    236 ;   les interruption non gérées
                                    237 ;   réinitialise le MCU
                                    238 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      01006A                        239 NonHandledInterrupt:
      01006A A6 80            [ 1]  240 	ld a,#0x80
      01006C C7 50 D1         [ 1]  241 	ld WWDG_CR,a
                                    242     ;iret
                                    243 
                                    244 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    245 ;       gestionnaire d'interruption pour le bouton USER
                                    246 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                           000000   247     DEBOUNCE = 0 ; mettre à zéro pour annule le code anti-rebond.
      01006F                        248 usr_btn_isr:
      01006F                        249     _ledon
      01006F 72 1A 50 0A      [ 1]    1     bset LED2_PORT,#LED2_BIT
      010073 CD 00 09         [ 4]  250     call print_msg
                           000000   251     .if DEBOUNCE
                                    252 ; anti-rebond
                                    253 ; attend que le bouton soit relâché
                                    254 1$: clrw x
                                    255     btjf USR_BTN_PORT,#USR_BTN_BIT,1$ 
                                    256 ; tant que le bouton est relâché incrémente X 
                                    257 ; si X==0x7fff quitte
                                    258 ; si bouton revient à zéro avant retourne à 1$     
                                    259 2$: incw x
                                    260     cpw x,#0x7fff
                                    261     jreq 3$
                                    262     btjt USR_BTN_PORT,#USR_BTN_BIT,2$
                                    263     jra 1$
                                    264     .endif; DEBOUNCE
      010076                        265     _ledoff  
      010076 72 1B 50 0A      [ 1]    1     bres LED2_PORT,#LED2_BIT
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



      01007A 80               [11]  266 3$: iret
                                    267 
                                    268 
                                    269 
      01007B                        270     hello:
      01007B 0C                     271         .byte   12
      01007C 48 65 6C 6C 6F 20 66   272         .asciz  "Hello from exented memory.\n"
             72 6F 6D 20 65 78 65
             6E 74 65 64 20 6D 65
             6D 6F 72 79 2E 0A 00
      010098                        273     trivia:
      010098 0C                     274         .byte 12
      010099 54 72 69 76 69 61 3A   275         .ascii "Trivia:\n"
             0A
      0100A1 51 75 65 6C 20 70 65   276         .ascii "Quel personnage d'une serie culte des annees 60 a dit:\n"
             72 73 6F 6E 6E 61 67
             65 20 64 27 75 6E 65
             20 73 65 72 69 65 20
             63 75 6C 74 65 20 64
             65 73 20 61 6E 6E 65
             65 73 20 36 30 20 61
             20 64 69 74 3A 0A
      0100D8 22                     277         .byte '"'
      0100D9 4A 65 20 6E 65 20 73   278         .ascii "Je ne suis pas un numero, je suis un homme libre."
             75 69 73 20 70 61 73
             20 75 6E 20 6E 75 6D
             65 72 6F 2C 20 6A 65
             20 73 75 69 73 20 75
             6E 20 68 6F 6D 6D 65
             20 6C 69 62 72 65 2E
      01010A 22 0A 00               279         .byte '"','\n',0
      01010D                        280     reponse:
      01010D 0A 4C 65 20 70 72 69   281         .asciz "\nLe prisonnier, serie tv de ce titre, acteur: Patrick McGoohan\n"
             73 6F 6E 6E 69 65 72
             2C 20 73 65 72 69 65
             20 74 76 20 64 65 20
             63 65 20 74 69 74 72
             65 2C 20 61 63 74 65
             75 72 3A 20 50 61 74
             72 69 63 6B 20 4D 63
             47 6F 6F 68 61 6E 0A
             00
                                    282     
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
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
    BIT0    =  000000     |     BIT1    =  000001     |     BIT2    =  000002 
    BIT3    =  000003     |     BIT4    =  000004     |     BIT5    =  000005 
    BIT6    =  000006     |     BIT7    =  000007     |     BOOT_ROM=  006000 
    BOOT_ROM=  007FFF     |     CAN_DGR =  005426     |     CAN_FPSR=  005427 
    CAN_IER =  005425     |     CAN_MCR =  005420     |     CAN_MSR =  005421 
    CAN_P0  =  005428     |     CAN_P1  =  005429     |     CAN_P2  =  00542A 
    CAN_P3  =  00542B     |     CAN_P4  =  00542C     |     CAN_P5  =  00542D 
    CAN_P6  =  00542E     |     CAN_P7  =  00542F     |     CAN_P8  =  005430 
    CAN_P9  =  005431     |     CAN_PA  =  005432     |     CAN_PB  =  005433 
    CAN_PC  =  005434     |     CAN_PD  =  005435     |     CAN_PE  =  005436 
    CAN_PF  =  005437     |     CAN_RFR =  005424     |     CAN_TPR =  005423 
    CAN_TSR =  005422     |     CFG_GCR =  007F60     |     CFG_GCR_=  000001 
    CFG_GCR_=  000000     |     CLKOPT  =  004807     |     CLKOPT_C=  000002 
    CLKOPT_E=  000003     |     CLKOPT_P=  000000     |     CLKOPT_P=  000001 
    CLK_CCOR=  0050C9     |     CLK_CKDI=  0050C6     |     CLK_CKDI=  000000 
    CLK_CKDI=  000001     |     CLK_CKDI=  000002     |     CLK_CKDI=  000003 
    CLK_CKDI=  000004     |     CLK_CMSR=  0050C3     |     CLK_CSSR=  0050C8 
    CLK_ECKR=  0050C1     |     CLK_ECKR=  000000     |     CLK_ECKR=  000001 
    CLK_HSIT=  0050CC     |     CLK_ICKR=  0050C0     |     CLK_ICKR=  000002 
    CLK_ICKR=  000000     |     CLK_ICKR=  000001     |     CLK_ICKR=  000003 
    CLK_ICKR=  000004     |     CLK_ICKR=  000005     |     CLK_PCKE=  0050C7 
    CLK_PCKE=  000000     |     CLK_PCKE=  000001     |     CLK_PCKE=  000007 
    CLK_PCKE=  000005     |     CLK_PCKE=  000006     |     CLK_PCKE=  000004 
    CLK_PCKE=  000002     |     CLK_PCKE=  000003     |     CLK_PCKE=  0050CA 
    CLK_PCKE=  000003     |     CLK_PCKE=  000002     |     CLK_PCKE=  000007 
    CLK_SWCR=  0050C5     |     CLK_SWCR=  000000     |     CLK_SWCR=  000001 
    CLK_SWCR=  000002     |     CLK_SWCR=  000003     |     CLK_SWIM=  0050CD 
    CLK_SWR =  0050C4     |     CLK_SWR_=  0000B4     |     CLK_SWR_=  0000E1 
    CLK_SWR_=  0000D2     |     CPU_A   =  007F00     |     CPU_CCR =  007F0A 
    CPU_PCE =  007F01     |     CPU_PCH =  007F02     |     CPU_PCL =  007F03 
    CPU_SPH =  007F08     |     CPU_SPL =  007F09     |     CPU_XH  =  007F04 
    CPU_XL  =  007F05     |     CPU_YH  =  007F06     |     CPU_YL  =  007F07 
    DEBOUNCE=  000000     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]

Symbol Table

    DEVID_BA=  0048CD     |     DEVID_EN=  0048D8     |     DEVID_LO=  0048D2 
    DEVID_LO=  0048D3     |     DEVID_LO=  0048D4     |     DEVID_LO=  0048D5 
    DEVID_LO=  0048D6     |     DEVID_LO=  0048D7     |     DEVID_LO=  0048D8 
    DEVID_WA=  0048D1     |     DEVID_XH=  0048CE     |     DEVID_XL=  0048CD 
    DEVID_YH=  0048D0     |     DEVID_YL=  0048CF     |     DM_BK1RE=  007F90 
    DM_BK1RH=  007F91     |     DM_BK1RL=  007F92     |     DM_BK2RE=  007F93 
    DM_BK2RH=  007F94     |     DM_BK2RL=  007F95     |     DM_CR1  =  007F96 
    DM_CR2  =  007F97     |     DM_CSR1 =  007F98     |     DM_CSR2 =  007F99 
    DM_ENFCT=  007F9A     |     EEPROM_B=  004000     |     EEPROM_E=  0047FF 
    EEPROM_S=  000800     |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
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
    I2C_READ=  000001     |     I2C_SR1 =  005217     |     I2C_SR1_=  000003 
    I2C_SR1_=  000001     |     I2C_SR1_=  000002     |     I2C_SR1_=  000006 
    I2C_SR1_=  000000     |     I2C_SR1_=  000004     |     I2C_SR1_=  000007 
    I2C_SR2 =  005218     |     I2C_SR2_=  000002     |     I2C_SR2_=  000001 
    I2C_SR2_=  000000     |     I2C_SR2_=  000003     |     I2C_SR2_=  000005 
    I2C_SR3 =  005219     |     I2C_SR3_=  000001     |     I2C_SR3_=  000007 
    I2C_SR3_=  000004     |     I2C_SR3_=  000000     |     I2C_SR3_=  000002 
    I2C_TRIS=  00521D     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000005     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_WRIT=  000000     |     INPUT_DI=  000000 
    INPUT_EI=  000001     |     INPUT_FL=  000000     |     INPUT_PU=  000001 
    INT_ADC2=  000016     |     INT_AUAR=  000012     |     INT_AWU =  000001 
    INT_CAN_=  000008     |     INT_CAN_=  000009     |     INT_CLK =  000002 
    INT_EXTI=  000003     |     INT_EXTI=  000004     |     INT_EXTI=  000005 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]

Symbol Table

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
    NAFR    =  004804     |     NCLKOPT =  004808     |     NFLASH_W=  00480E 
    NHSECNT =  00480A     |     NOPT1   =  004802     |     NOPT2   =  004804 
    NOPT3   =  004806     |     NOPT4   =  004808     |     NOPT5   =  00480A 
    NOPT6   =  00480C     |     NOPT7   =  00480E     |     NOPTBL  =  00487F 
    NUBC    =  004802     |     NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD 
    NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE 
  7 NonHandl   01006A R   |     OPT0    =  004800     |     OPT1    =  004801 
    OPT2    =  004803     |     OPT3    =  004805     |     OPT4    =  004807 
    OPT5    =  004809     |     OPT6    =  00480B     |     OPT7    =  00480D 
    OPTBL   =  00487E     |     OPTION_B=  004800     |     OPTION_E=  00487F 
    OUTPUT_F=  000001     |     OUTPUT_O=  000000     |     OUTPUT_P=  000001 
    OUTPUT_S=  000000     |     PA      =  000000     |     PA_BASE =  005000 
    PA_CR1  =  005003     |     PA_CR2  =  005004     |     PA_DDR  =  005002 
    PA_IDR  =  005001     |     PA_ODR  =  005000     |     PB      =  000005 
    PB_BASE =  005005     |     PB_CR1  =  005008     |     PB_CR2  =  005009 
    PB_DDR  =  005007     |     PB_IDR  =  005006     |     PB_ODR  =  005005 
    PC      =  00000A     |     PC_BASE =  00500A     |     PC_CR1  =  00500D 
    PC_CR2  =  00500E     |     PC_DDR  =  00500C     |     PC_IDR  =  00500B 
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
    PI_IDR  =  005029     |     PI_ODR  =  005028     |     RAM_BASE=  000000 
    RAM_END =  0017FF     |     RAM_SIZE=  001800     |     ROP     =  004800 
    RST_SR  =  0050B3     |     SFR_BASE=  005000     |     SFR_END =  0057FF 
    SPI_CR1 =  005200     |     SPI_CR2 =  005201     |     SPI_CRCP=  005205 
    SPI_DR  =  005204     |     SPI_ICR =  005202     |     SPI_RXCR=  005206 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]

Symbol Table

    SPI_SR  =  005203     |     SPI_TXCR=  005207     |     STACK_SI=  000100 
    STACK_TO=  0017FE     |     SWIM_CSR=  007F80     |     TIM1_ARR=  005262 
    TIM1_ARR=  005263     |     TIM1_BKR=  00526D     |     TIM1_CCE=  00525C 
    TIM1_CCE=  00525D     |     TIM1_CCM=  005258     |     TIM1_CCM=  000000 
    TIM1_CCM=  000001     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000003     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000003     |     TIM1_CCM=  005259     |     TIM1_CCM=  000000 
    TIM1_CCM=  000001     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000003     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000003     |     TIM1_CCM=  00525A     |     TIM1_CCM=  000000 
    TIM1_CCM=  000001     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000003     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000003     |     TIM1_CCM=  00525B     |     TIM1_CCM=  000000 
    TIM1_CCM=  000001     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000003     |     TIM1_CCM=  000007     |     TIM1_CCM=  000002 
    TIM1_CCM=  000004     |     TIM1_CCM=  000005     |     TIM1_CCM=  000006 
    TIM1_CCM=  000003     |     TIM1_CCR=  005265     |     TIM1_CCR=  005266 
    TIM1_CCR=  005267     |     TIM1_CCR=  005268     |     TIM1_CCR=  005269 
    TIM1_CCR=  00526A     |     TIM1_CCR=  00526B     |     TIM1_CCR=  00526C 
    TIM1_CNT=  00525E     |     TIM1_CNT=  00525F     |     TIM1_CR1=  005250 
    TIM1_CR2=  005251     |     TIM1_CR2=  000000     |     TIM1_CR2=  000002 
    TIM1_CR2=  000004     |     TIM1_CR2=  000005     |     TIM1_CR2=  000006 
    TIM1_DTR=  00526E     |     TIM1_EGR=  005257     |     TIM1_EGR=  000007 
    TIM1_EGR=  000001     |     TIM1_EGR=  000002     |     TIM1_EGR=  000003 
    TIM1_EGR=  000004     |     TIM1_EGR=  000005     |     TIM1_EGR=  000006 
    TIM1_EGR=  000000     |     TIM1_ETR=  005253     |     TIM1_ETR=  000006 
    TIM1_ETR=  000000     |     TIM1_ETR=  000001     |     TIM1_ETR=  000002 
    TIM1_ETR=  000003     |     TIM1_ETR=  000007     |     TIM1_ETR=  000004 
    TIM1_ETR=  000005     |     TIM1_IER=  005254     |     TIM1_IER=  000007 
    TIM1_IER=  000001     |     TIM1_IER=  000002     |     TIM1_IER=  000003 
    TIM1_IER=  000004     |     TIM1_IER=  000005     |     TIM1_IER=  000006 
    TIM1_IER=  000000     |     TIM1_OIS=  00526F     |     TIM1_PSC=  005260 
    TIM1_PSC=  005261     |     TIM1_RCR=  005264     |     TIM1_SMC=  005252 
    TIM1_SMC=  000007     |     TIM1_SMC=  000000     |     TIM1_SMC=  000001 
    TIM1_SMC=  000002     |     TIM1_SMC=  000004     |     TIM1_SMC=  000005 
    TIM1_SMC=  000006     |     TIM1_SR1=  005255     |     TIM1_SR1=  000007 
    TIM1_SR1=  000001     |     TIM1_SR1=  000002     |     TIM1_SR1=  000003 
    TIM1_SR1=  000004     |     TIM1_SR1=  000005     |     TIM1_SR1=  000006 
    TIM1_SR1=  000000     |     TIM1_SR2=  005256     |     TIM1_SR2=  000001 
    TIM1_SR2=  000002     |     TIM1_SR2=  000003     |     TIM1_SR2=  000004 
    TIM2_ARR=  00530D     |     TIM2_ARR=  00530E     |     TIM2_CCE=  005308 
    TIM2_CCE=  005309     |     TIM2_CCM=  005305     |     TIM2_CCM=  005306 
    TIM2_CCM=  005307     |     TIM2_CCR=  00530F     |     TIM2_CCR=  005310 
    TIM2_CCR=  005311     |     TIM2_CCR=  005312     |     TIM2_CCR=  005313 
    TIM2_CCR=  005314     |     TIM2_CNT=  00530A     |     TIM2_CNT=  00530B 
    TIM2_CR1=  005300     |     TIM2_EGR=  005304     |     TIM2_IER=  005301 
    TIM2_PSC=  00530C     |     TIM2_SR1=  005302     |     TIM2_SR2=  005303 
    TIM3_ARR=  00532B     |     TIM3_ARR=  00532C     |     TIM3_CCE=  005327 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]

Symbol Table

    TIM3_CCE=  000000     |     TIM3_CCE=  000001     |     TIM3_CCE=  000004 
    TIM3_CCE=  000005     |     TIM3_CCE=  000000     |     TIM3_CCE=  000001 
    TIM3_CCM=  005325     |     TIM3_CCM=  005326     |     TIM3_CCM=  000000 
    TIM3_CCM=  000004     |     TIM3_CCM=  000003     |     TIM3_CCR=  00532D 
    TIM3_CCR=  00532E     |     TIM3_CCR=  00532F     |     TIM3_CCR=  005330 
    TIM3_CNT=  005328     |     TIM3_CNT=  005329     |     TIM3_CR1=  005320 
    TIM3_CR1=  000007     |     TIM3_CR1=  000000     |     TIM3_CR1=  000003 
    TIM3_CR1=  000001     |     TIM3_CR1=  000002     |     TIM3_EGR=  005324 
    TIM3_IER=  005321     |     TIM3_PSC=  00532A     |     TIM3_SR1=  005322 
    TIM3_SR2=  005323     |     TIM4_ARR=  005346     |     TIM4_CNT=  005344 
    TIM4_CR1=  005340     |     TIM4_CR1=  000007     |     TIM4_CR1=  000000 
    TIM4_CR1=  000003     |     TIM4_CR1=  000001     |     TIM4_CR1=  000002 
    TIM4_EGR=  005343     |     TIM4_EGR=  000000     |     TIM4_IER=  005341 
    TIM4_IER=  000000     |     TIM4_PSC=  005345     |     TIM4_PSC=  000000 
    TIM4_PSC=  000007     |     TIM4_PSC=  000004     |     TIM4_PSC=  000001 
    TIM4_PSC=  000005     |     TIM4_PSC=  000002     |     TIM4_PSC=  000006 
    TIM4_PSC=  000003     |     TIM4_PSC=  000000     |     TIM4_PSC=  000001 
    TIM4_PSC=  000002     |     TIM4_SR =  005342     |     TIM4_SR_=  000000 
    TIM_CR1_=  000007     |     TIM_CR1_=  000000     |     TIM_CR1_=  000006 
    TIM_CR1_=  000005     |     TIM_CR1_=  000004     |     TIM_CR1_=  000003 
    TIM_CR1_=  000001     |     TIM_CR1_=  000002     |     UART1_BR=  005232 
    UART1_BR=  005233     |     UART1_CR=  005234     |     UART1_CR=  005235 
    UART1_CR=  005236     |     UART1_CR=  005237     |     UART1_CR=  005238 
    UART1_DR=  005231     |     UART1_GT=  005239     |     UART1_PS=  00523A 
    UART1_SR=  005230     |     UART3_BR=  005242     |     UART3_BR=  005243 
    UART3_CR=  005244     |     UART3_CR=  005245     |     UART3_CR=  005246 
    UART3_CR=  005247     |     UART3_CR=  004249     |     UART3_DR=  005241 
    UART3_SR=  005240     |     UART_CR1=  000004     |     UART_CR1=  000002 
    UART_CR1=  000000     |     UART_CR1=  000001     |     UART_CR1=  000007 
    UART_CR1=  000006     |     UART_CR1=  000005     |     UART_CR1=  000003 
    UART_CR2=  000004     |     UART_CR2=  000002     |     UART_CR2=  000005 
    UART_CR2=  000001     |     UART_CR2=  000000     |     UART_CR2=  000006 
    UART_CR2=  000003     |     UART_CR2=  000007     |     UART_CR3=  000003 
    UART_CR3=  000001     |     UART_CR3=  000002     |     UART_CR3=  000000 
    UART_CR3=  000006     |     UART_CR3=  000004     |     UART_CR3=  000005 
    UART_CR4=  000000     |     UART_CR4=  000001     |     UART_CR4=  000002 
    UART_CR4=  000003     |     UART_CR4=  000004     |     UART_CR4=  000006 
    UART_CR4=  000005     |     UART_CR5=  000003     |     UART_CR5=  000001 
    UART_CR5=  000002     |     UART_CR5=  000004     |     UART_CR5=  000005 
    UART_CR6=  000004     |     UART_CR6=  000007     |     UART_CR6=  000001 
    UART_CR6=  000002     |     UART_CR6=  000000     |     UART_CR6=  000005 
    UART_SR_=  000001     |     UART_SR_=  000004     |     UART_SR_=  000002 
    UART_SR_=  000003     |     UART_SR_=  000000     |     UART_SR_=  000005 
    UART_SR_=  000006     |     UART_SR_=  000007     |     UBC     =  004801 
    USE_PTR =  000001     |     USR_BTN_=  000004     |     USR_BTN_=  000010 
    USR_BTN_=  005015     |     WDGOPT  =  004805     |     WDGOPT_I=  000002 
    WDGOPT_L=  000003     |     WDGOPT_W=  000000     |     WDGOPT_W=  000001 
    WWDG_CR =  0050D1     |     WWDG_WR =  0050D2     |   5 clock_in   00004E R
  5 const_pt   000061 R   |   1 farptr     000000 R   |   1 farptrL    000002 R
  1 farptrM    000001 R   |   7 hello      01007B R   |   5 main       000000 R
  7 ph0        01003B R   |   7 ph1        01002A R   |   7 ph2        010019 R
  1 phase      000003 R   |   7 print      01004A R   |   7 print_ms   010009 R
  7 reponse    01010D R   |   7 trivia     010098 R   |   5 uart3_in   000035 R
  7 uart_tx    010000 R   |   7 usr_btn_   01006F R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size      4   flags    0
   2 SSEG       size      0   flags    8
   3 SSEG0      size    100   flags    8
   4 HOME       size     7C   flags    0
   5 CODE       size     64   flags    0
   6 CODE_FAR   size      0   flags    8
   7 CODE_FAR   size    14D   flags    8

