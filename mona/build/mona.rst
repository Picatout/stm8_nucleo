ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;  MONA   MONitor written in Assembly
                                      2 	.module MONA 
                                      3     .optsdcc -mstm8
                                      4 ;	.nlist
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                      5 	.include "../inc/nucleo_8s208.inc"
                                      1 ; NUCLEO-8S208RB board specific definitions
                                      2 
                                      3 ; mcu on board is stm8s208rbt6
                                      4 
                                      5 ; crystal on board is 8Mhz
                           7A1200     6 FHSE = 8000000
                                      7 
                                      8 ; LED2 is user LED
                                      9 ; connected to PC5 via Q2 -> 2N7002 MOSFET
                           00500A    10 LED2_PORT = 0x500a ;port C
                           000005    11 LED2_BIT = 5
                           000020    12 LED2_MASK = (1<<5) ;bit 5 mask
                                     13 
                                     14 ; B1 is user button
                                     15 ; connected to PE4
                                     16 ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                           005014    17 BTN1_PORT = 0x5014 ; port E
                           000004    18 BTN1_BIT = 4
                           000010    19 BTN1_MASK = (1<<4) ;bit 4 mask
                                     20 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                      6 	.include "../inc/stm8s208.inc"
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ; 2019/10/18
                                      3 ; STM8S208RB µC registers map
                                      4 ; sdas file
                                      5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      6 	.module stm8s208rb
                                      7 
                                      8 ;;;;;;;;;;;;
                                      9 ; bits
                                     10 ;;;;;;;;;;;;
                           000000    11  BIT0 = 0
                           000001    12  BIT1 = 1
                           000002    13  BIT2 = 2
                           000003    14  BIT3 = 3
                           000004    15  BIT4 = 4
                           000005    16  BIT5 = 5
                           000006    17  BIT6 = 6
                           000007    18  BIT7 = 7
                                     19  	
                                     20 ;;;;;;;;;;;;
                                     21 ; bits masks
                                     22 ;;;;;;;;;;;;
                           000001    23  B0_MASK = (1<<0)
                           000002    24  B1_MASK = (1<<1)
                           000004    25  B2_MASK = (1<<2)
                           000008    26  B3_MASK = (1<<3)
                           000010    27  B4_MASK = (1<<4)
                           000020    28  B5_MASK = (1<<5)
                           000040    29  B6_MASK = (1<<6)
                           000080    30  B7_MASK = (1<<7)
                                     31 
                                     32 ; HSI oscillator frequency 16Mhz
                           F42400    33  FHSI = 16000000
                                     34 ; LSI oscillator frequency 128Khz
                           01F400    35  FLSI = 128000 
                                     36 
                                     37 ; controller memory regions
                           001800    38  RAM_SIZE = (0x1800) ; 6KB 
                           000800    39  EEPROM_SIZE = (0x800) ; 2KB
                                     40 ; STM8S208RB have 128K flash
                           020000    41  FLASH_SIZE = (0x20000)
                                     42 
                           000000    43  RAM_BASE = (0)
                           0017FF    44  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    45  EEPROM_BASE = (0x4000)
                           0047FF    46  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    47  SFR_BASE = (0x5000)
                           0057FF    48  SFR_END = (0x57FF)
                           006000    49  BOOT_ROM_BASE = (0x6000)
                           007FFF    50  BOOT_ROM_END = (0x7fff)
                           008000    51  FLASH_BASE = (0x8000)
                           027FFF    52  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
                           004800    53  OPTION_BASE = (0x4800)
                           00487F    54  OPTION_END = (0x487F)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                           0048CD    55  DEVID_BASE = (0x48CD)
                           0048D8    56  DEVID_END = (0x48D8)
                           007F00    57  DEBUG_BASE = (0X7F00)
                           007FFF    58  DEBUG_END = (0X7FFF)
                                     59 
                                     60 ; options bytes
                                     61 ; this one can be programmed only from SWIM  (ICP)
                           004800    62  OPT0  = (0x4800)
                                     63 ; these can be programmed at runtime (IAP)
                           004801    64  OPT1  = (0x4801)
                           004802    65  NOPT1  = (0x4802)
                           004803    66  OPT2  = (0x4803)
                           004804    67  NOPT2  = (0x4804)
                           004805    68  OPT3  = (0x4805)
                           004806    69  NOPT3  = (0x4806)
                           004807    70  OPT4  = (0x4807)
                           004808    71  NOPT4  = (0x4808)
                           004809    72  OPT5  = (0x4809)
                           00480A    73  NOPT5  = (0x480A)
                           00480B    74  OPT6  = (0x480B)
                           00480C    75  NOPT6 = (0x480C)
                           00480D    76  OPT7 = (0x480D)
                           00480E    77  NOPT7 = (0x480E)
                           00487E    78  OPTBL  = (0x487E)
                           00487F    79  NOPTBL  = (0x487F)
                                     80 ; option registers usage
                                     81 ; read out protection, value 0xAA enable ROP
                           004800    82  ROP = OPT0  
                                     83 ; user boot code, {0..0x3e} 512 bytes row
                           004801    84  UBC = OPT1
                           004802    85  NUBC = NOPT1
                                     86 ; alternate function register
                           004803    87  AFR = OPT2
                           004804    88  NAFR = NOPT2
                                     89 ; miscelinous options
                           004805    90  WDGOPT = OPT3
                           004806    91  NWDGOPT = NOPT3
                                     92 ; clock options
                           004807    93  CLKOPT = OPT4
                           004808    94  NCLKOPT = NOPT4
                                     95 ; HSE clock startup delay
                           004809    96  HSECNT = OPT5
                           00480A    97  NHSECNT = NOPT5
                                     98 ; flash wait state
                           00480D    99 FLASH_WS = OPT7
                           00480E   100 NFLASH_WS = NOPT7
                                    101 
                                    102 ; watchdog options bits
                           000003   103   WDGOPT_LSIEN   =  BIT3
                           000002   104   WDGOPT_IWDG_HW =  BIT2
                           000001   105   WDGOPT_WWDG_HW =  BIT1
                           000000   106   WDGOPT_WWDG_HALT = BIT0
                                    107 ; NWDGOPT bits
                           FFFFFFFC   108   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   109   NWDGOPT_IWDG_HW  = ~BIT2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



                           FFFFFFFE   110   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   111   NWDGOPT_WWDG_HALT = ~BIT0
                                    112 
                                    113 ; CLKOPT bits
                           000003   114  CLKOPT_EXT_CLK  = BIT3
                           000002   115  CLKOPT_CKAWUSEL = BIT2
                           000001   116  CLKOPT_PRS_C1   = BIT1
                           000000   117  CLKOPT_PRS_C0   = BIT0
                                    118 
                                    119 ; AFR option, remapable functions
                           000007   120  AFR7_BEEP    = BIT7
                           000006   121  AFR6_I2C     = BIT6
                           000005   122  AFR5_TIM1    = BIT5
                           000004   123  AFR4_TIM1    = BIT4
                           000003   124  AFR3_TIM1    = BIT3
                           000002   125  AFR2_CCO     = BIT2
                           000001   126  AFR1_TIM2    = BIT1
                           000000   127  AFR0_ADC     = BIT0
                                    128 
                                    129 ; device ID = (read only)
                           0048CD   130  DEVID_XL  = (0x48CD)
                           0048CE   131  DEVID_XH  = (0x48CE)
                           0048CF   132  DEVID_YL  = (0x48CF)
                           0048D0   133  DEVID_YH  = (0x48D0)
                           0048D1   134  DEVID_WAF  = (0x48D1)
                           0048D2   135  DEVID_LOT0  = (0x48D2)
                           0048D3   136  DEVID_LOT1  = (0x48D3)
                           0048D4   137  DEVID_LOT2  = (0x48D4)
                           0048D5   138  DEVID_LOT3  = (0x48D5)
                           0048D6   139  DEVID_LOT4  = (0x48D6)
                           0048D7   140  DEVID_LOT5  = (0x48D7)
                           0048D8   141  DEVID_LOT6  = (0x48D8)
                                    142 
                                    143 
                           005000   144 GPIO_BASE = (0x5000)
                           000005   145 GPIO_SIZE = (5)
                                    146 ; PORTS SFR OFFSET
                           000000   147 PA = 0
                           000005   148 PB = 5
                           00000A   149 PC = 10
                           00000F   150 PD = 15
                           000014   151 PE = 20
                           000019   152 PF = 25
                           00001E   153 PG = 30
                                    154 
                                    155 ; GPIO
                                    156 ; gpio register offset to base
                           000000   157  GPIO_ODR = 0
                           000001   158  GPIO_IDR = 1
                           000002   159  GPIO_DDR = 2
                           000003   160  GPIO_CR1 = 3
                           000004   161  GPIO_CR2 = 4
                                    162 
                                    163 ; port A
                           005000   164  PA_BASE = (0X5000)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                           005000   165  PA_ODR  = (0x5000)
                           005001   166  PA_IDR  = (0x5001)
                           005002   167  PA_DDR  = (0x5002)
                           005003   168  PA_CR1  = (0x5003)
                           005004   169  PA_CR2  = (0x5004)
                                    170 ; port B
                           005005   171  PB_BASE = (0X5005)
                           005005   172  PB_ODR  = (0x5005)
                           005006   173  PB_IDR  = (0x5006)
                           005007   174  PB_DDR  = (0x5007)
                           005008   175  PB_CR1  = (0x5008)
                           005009   176  PB_CR2  = (0x5009)
                                    177 ; port C
                           00500A   178  PC_BASE = (0X500A)
                           00500A   179  PC_ODR  = (0x500A)
                           00500B   180  PC_IDR  = (0x500B)
                           00500C   181  PC_DDR  = (0x500C)
                           00500D   182  PC_CR1  = (0x500D)
                           00500E   183  PC_CR2  = (0x500E)
                                    184 ; port D
                           00500F   185  PD_BASE = (0X500F)
                           00500F   186  PD_ODR  = (0x500F)
                           005010   187  PD_IDR  = (0x5010)
                           005011   188  PD_DDR  = (0x5011)
                           005012   189  PD_CR1  = (0x5012)
                           005013   190  PD_CR2  = (0x5013)
                                    191 ; port E
                           005014   192  PE_BASE = (0X5014)
                           005014   193  PE_ODR  = (0x5014)
                           005015   194  PE_IDR  = (0x5015)
                           005016   195  PE_DDR  = (0x5016)
                           005017   196  PE_CR1  = (0x5017)
                           005018   197  PE_CR2  = (0x5018)
                                    198 ; port F
                           005019   199  PF_BASE = (0X5019)
                           005019   200  PF_ODR  = (0x5019)
                           00501A   201  PF_IDR  = (0x501A)
                           00501B   202  PF_DDR  = (0x501B)
                           00501C   203  PF_CR1  = (0x501C)
                           00501D   204  PF_CR2  = (0x501D)
                                    205 ; port G
                           00501E   206  PG_BASE = (0X501E)
                           00501E   207  PG_ODR  = (0x501E)
                           00501F   208  PG_IDR  = (0x501F)
                           005020   209  PG_DDR  = (0x5020)
                           005021   210  PG_CR1  = (0x5021)
                           005022   211  PG_CR2  = (0x5022)
                                    212 ; port H not present on LQFP48/LQFP64 package
                           005023   213  PH_BASE = (0X5023)
                           005023   214  PH_ODR  = (0x5023)
                           005024   215  PH_IDR  = (0x5024)
                           005025   216  PH_DDR  = (0x5025)
                           005026   217  PH_CR1  = (0x5026)
                           005027   218  PH_CR2  = (0x5027)
                                    219 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



                           005028   220  PI_BASE = (0X5028)
                           005028   221  PI_ODR  = (0x5028)
                           005029   222  PI_IDR  = (0x5029)
                           00502A   223  PI_DDR  = (0x502a)
                           00502B   224  PI_CR1  = (0x502b)
                           00502C   225  PI_CR2  = (0x502c)
                                    226 
                                    227 ; input modes CR1
                           000000   228  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   229  INPUT_PULLUP = (1)
                                    230 ; output mode CR1
                           000000   231  OUTPUT_OD = (0) ; open drain
                           000001   232  OUTPUT_PP = (1) ; push pull
                                    233 ; input modes CR2
                           000000   234  INPUT_DI = (0)
                           000001   235  INPUT_EI = (1)
                                    236 ; output speed CR2
                           000000   237  OUTPUT_SLOW = (0)
                           000001   238  OUTPUT_FAST = (1)
                                    239 
                                    240 
                                    241 ; Flash memory
                           00505A   242  FLASH_CR1  = (0x505A)
                           00505B   243  FLASH_CR2  = (0x505B)
                           00505C   244  FLASH_NCR2  = (0x505C)
                           00505D   245  FLASH_FPR  = (0x505D)
                           00505E   246  FLASH_NFPR  = (0x505E)
                           00505F   247  FLASH_IAPSR  = (0x505F)
                           005062   248  FLASH_PUKR  = (0x5062)
                           005064   249  FLASH_DUKR  = (0x5064)
                                    250 ; data memory unlock keys
                           0000AE   251  FLASH_DUKR_KEY1 = (0xae)
                           000056   252  FLASH_DUKR_KEY2 = (0x56)
                                    253 ; flash memory unlock keys
                           000056   254  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   255  FLASH_PUKR_KEY2 = (0xae)
                                    256 ; FLASH_CR1 bits
                           000003   257  FLASH_CR1_HALT = BIT3
                           000002   258  FLASH_CR1_AHALT = BIT2
                           000001   259  FLASH_CR1_IE = BIT1
                           000000   260  FLASH_CR1_FIX = BIT0
                                    261 ; FLASH_CR2 bits
                           000007   262  FLASH_CR2_OPT = BIT7
                           000006   263  FLASH_CR2_WPRG = BIT6
                           000005   264  FLASH_CR2_ERASE = BIT5
                           000004   265  FLASH_CR2_FPRG = BIT4
                           000000   266  FLASH_CR2_PRG = BIT0
                                    267 ; FLASH_FPR bits
                           000005   268  FLASH_FPR_WPB5 = BIT5
                           000004   269  FLASH_FPR_WPB4 = BIT4
                           000003   270  FLASH_FPR_WPB3 = BIT3
                           000002   271  FLASH_FPR_WPB2 = BIT2
                           000001   272  FLASH_FPR_WPB1 = BIT1
                           000000   273  FLASH_FPR_WPB0 = BIT0
                                    274 ; FLASH_NFPR bits
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                           000005   275  FLASH_NFPR_NWPB5 = BIT5
                           000004   276  FLASH_NFPR_NWPB4 = BIT4
                           000003   277  FLASH_NFPR_NWPB3 = BIT3
                           000002   278  FLASH_NFPR_NWPB2 = BIT2
                           000001   279  FLASH_NFPR_NWPB1 = BIT1
                           000000   280  FLASH_NFPR_NWPB0 = BIT0
                                    281 ; FLASH_IAPSR bits
                           000006   282  FLASH_IAPSR_HVOFF = BIT6
                           000003   283  FLASH_IAPSR_DUL = BIT3
                           000002   284  FLASH_IAPSR_EOP = BIT2
                           000001   285  FLASH_IAPSR_PUL = BIT1
                           000000   286  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    287 
                                    288 ; Interrupt control
                           0050A0   289  EXTI_CR1  = (0x50A0)
                           0050A1   290  EXTI_CR2  = (0x50A1)
                                    291 
                                    292 ; Reset Status
                           0050B3   293  RST_SR  = (0x50B3)
                                    294 
                                    295 ; Clock Registers
                           0050C0   296  CLK_ICKR  = (0x50c0)
                           0050C1   297  CLK_ECKR  = (0x50c1)
                           0050C3   298  CLK_CMSR  = (0x50C3)
                           0050C4   299  CLK_SWR  = (0x50C4)
                           0050C5   300  CLK_SWCR  = (0x50C5)
                           0050C6   301  CLK_CKDIVR  = (0x50C6)
                           0050C7   302  CLK_PCKENR1  = (0x50C7)
                           0050C8   303  CLK_CSSR  = (0x50C8)
                           0050C9   304  CLK_CCOR  = (0x50C9)
                           0050CA   305  CLK_PCKENR2  = (0x50CA)
                           0050CC   306  CLK_HSITRIMR  = (0x50CC)
                           0050CD   307  CLK_SWIMCCR  = (0x50CD)
                                    308 
                                    309 ; Peripherals clock gating
                                    310 ; CLK_PCKENR1 
                           000007   311  CLK_PCKENR1_TIM1 = (7)
                           000006   312  CLK_PCKENR1_TIM3 = (6)
                           000005   313  CLK_PCKENR1_TIM2 = (5)
                           000004   314  CLK_PCKENR1_TIM4 = (4)
                           000003   315  CLK_PCKENR1_UART3 = (3)
                           000002   316  CLK_PCKENR1_UART1 = (2)
                           000001   317  CLK_PCKENR1_SPI = (1)
                           000000   318  CLK_PCKENR1_I2C = (0)
                                    319 ; CLK_PCKENR2
                           000007   320  CLK_PCKENR2_CAN = (7)
                           000003   321  CLK_PCKENR2_ADC = (3)
                           000002   322  CLK_PCKENR2_AWU = (2)
                                    323 
                                    324 ; Clock bits
                           000005   325  CLK_ICKR_REGAH = (5)
                           000004   326  CLK_ICKR_LSIRDY = (4)
                           000003   327  CLK_ICKR_LSIEN = (3)
                           000002   328  CLK_ICKR_FHW = (2)
                           000001   329  CLK_ICKR_HSIRDY = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                           000000   330  CLK_ICKR_HSIEN = (0)
                                    331 
                           000001   332  CLK_ECKR_HSERDY = (1)
                           000000   333  CLK_ECKR_HSEEN = (0)
                                    334 ; clock source
                           0000E1   335  CLK_SWR_HSI = 0xE1
                           0000D2   336  CLK_SWR_LSI = 0xD2
                           0000B4   337  CLK_SWR_HSE = 0xB4
                                    338 
                           000003   339  CLK_SWCR_SWIF = (3)
                           000002   340  CLK_SWCR_SWIEN = (2)
                           000001   341  CLK_SWCR_SWEN = (1)
                           000000   342  CLK_SWCR_SWBSY = (0)
                                    343 
                           000004   344  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   345  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   346  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   347  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   348  CLK_CKDIVR_CPUDIV0 = (0)
                                    349 
                                    350 ; Watchdog
                           0050D1   351  WWDG_CR  = (0x50D1)
                           0050D2   352  WWDG_WR  = (0x50D2)
                           0050E0   353  IWDG_KR  = (0x50E0)
                           0050E1   354  IWDG_PR  = (0x50E1)
                           0050E2   355  IWDG_RLR  = (0x50E2)
                           0050F0   356  AWU_CSR1  = (0x50F0)
                           0050F1   357  AWU_APR  = (0x50F1)
                           0050F2   358  AWU_TBR  = (0x50F2)
                                    359 
                                    360 ; Beeper
                                    361 ; beeper output is alternate function AFR7 on PD4
                                    362 ; connected to CN9-6
                           0050F3   363  BEEP_CSR  = (0x50F3)
                           00000F   364  BEEP_PORT = PD
                           000004   365  BEEP_BIT = 4
                           000010   366  BEEP_MASK = B4_MASK
                                    367 
                                    368 ; SPI
                           005200   369  SPI_CR1  = (0x5200)
                           005201   370  SPI_CR2  = (0x5201)
                           005202   371  SPI_ICR  = (0x5202)
                           005203   372  SPI_SR  = (0x5203)
                           005204   373  SPI_DR  = (0x5204)
                           005205   374  SPI_CRCPR  = (0x5205)
                           005206   375  SPI_RXCRCR  = (0x5206)
                           005207   376  SPI_TXCRCR  = (0x5207)
                                    377 
                                    378 ; I2C
                           005210   379  I2C_CR1  = (0x5210)
                           005211   380  I2C_CR2  = (0x5211)
                           005212   381  I2C_FREQR  = (0x5212)
                           005213   382  I2C_OARL  = (0x5213)
                           005214   383  I2C_OARH  = (0x5214)
                           005216   384  I2C_DR  = (0x5216)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                           005217   385  I2C_SR1  = (0x5217)
                           005218   386  I2C_SR2  = (0x5218)
                           005219   387  I2C_SR3  = (0x5219)
                           00521A   388  I2C_ITR  = (0x521A)
                           00521B   389  I2C_CCRL  = (0x521B)
                           00521C   390  I2C_CCRH  = (0x521C)
                           00521D   391  I2C_TRISER  = (0x521D)
                           00521E   392  I2C_PECR  = (0x521E)
                                    393 
                           000007   394  I2C_CR1_NOSTRETCH = (7)
                           000006   395  I2C_CR1_ENGC = (6)
                           000000   396  I2C_CR1_PE = (0)
                                    397 
                           000007   398  I2C_CR2_SWRST = (7)
                           000003   399  I2C_CR2_POS = (3)
                           000002   400  I2C_CR2_ACK = (2)
                           000001   401  I2C_CR2_STOP = (1)
                           000000   402  I2C_CR2_START = (0)
                                    403 
                           000000   404  I2C_OARL_ADD0 = (0)
                                    405 
                           000009   406  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   407  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    408 
                           000007   409  I2C_OARH_ADDMODE = (7)
                           000006   410  I2C_OARH_ADDCONF = (6)
                           000002   411  I2C_OARH_ADD9 = (2)
                           000001   412  I2C_OARH_ADD8 = (1)
                                    413 
                           000007   414  I2C_SR1_TXE = (7)
                           000006   415  I2C_SR1_RXNE = (6)
                           000004   416  I2C_SR1_STOPF = (4)
                           000003   417  I2C_SR1_ADD10 = (3)
                           000002   418  I2C_SR1_BTF = (2)
                           000001   419  I2C_SR1_ADDR = (1)
                           000000   420  I2C_SR1_SB = (0)
                                    421 
                           000005   422  I2C_SR2_WUFH = (5)
                           000003   423  I2C_SR2_OVR = (3)
                           000002   424  I2C_SR2_AF = (2)
                           000001   425  I2C_SR2_ARLO = (1)
                           000000   426  I2C_SR2_BERR = (0)
                                    427 
                           000007   428  I2C_SR3_DUALF = (7)
                           000004   429  I2C_SR3_GENCALL = (4)
                           000002   430  I2C_SR3_TRA = (2)
                           000001   431  I2C_SR3_BUSY = (1)
                           000000   432  I2C_SR3_MSL = (0)
                                    433 
                           000002   434  I2C_ITR_ITBUFEN = (2)
                           000001   435  I2C_ITR_ITEVTEN = (1)
                           000000   436  I2C_ITR_ITERREN = (0)
                                    437 
                                    438 ; Precalculated values, all in KHz
                           000080   439  I2C_CCRH_16MHZ_FAST_400 = 0x80
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                           00000D   440  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    441 ;
                                    442 ; Fast I2C mode max rise time = 300ns
                                    443 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    444 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    445 
                           000005   446  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    447 
                           0000C0   448  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   449  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   450  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    451 
                           000080   452  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   453  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   454  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    455 
                           000000   456  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   457  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    458 ;
                                    459 ; Standard I2C mode max rise time = 1000ns
                                    460 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    461 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    462 
                           000011   463  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    464 
                           000000   465  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   466  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   467  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    468 
                           000001   469  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   470  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   471  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    472 
                           000001   473  I2C_READ = 1
                           000000   474  I2C_WRITE = 0
                                    475 
                                    476 ; baudrate constant for brr_value table access
                           000000   477 B2400=0
                           000001   478 B4800=1
                           000002   479 B9600=2
                           000003   480 B19200=3
                           000004   481 B38400=4
                           000005   482 B57600=5
                           000006   483 B115200=6
                           000007   484 B230400=7
                           000008   485 B460800=8
                           000009   486 B921600=9
                                    487 
                                    488 ; UART1 
                           005230   489  UART1_SR    = (0x5230)
                           005231   490  UART1_DR    = (0x5231)
                           005232   491  UART1_BRR1  = (0x5232)
                           005233   492  UART1_BRR2  = (0x5233)
                           005234   493  UART1_CR1   = (0x5234)
                           005235   494  UART1_CR2   = (0x5235)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



                           005236   495  UART1_CR3   = (0x5236)
                           005237   496  UART1_CR4   = (0x5237)
                           005238   497  UART1_CR5   = (0x5238)
                           005239   498  UART1_GTR   = (0x5239)
                           00523A   499  UART1_PSCR  = (0x523A)
                                    500 
                                    501 ; UART3
                           005240   502  UART3_SR    = (0x5240)
                           005241   503  UART3_DR    = (0x5241)
                           005242   504  UART3_BRR1  = (0x5242)
                           005243   505  UART3_BRR2  = (0x5243)
                           005244   506  UART3_CR1   = (0x5244)
                           005245   507  UART3_CR2   = (0x5245)
                           005246   508  UART3_CR3   = (0x5246)
                           005247   509  UART3_CR4   = (0x5247)
                           004249   510  UART3_CR6   = (0x4249)
                                    511 
                                    512 ; UART Status Register bits
                           000007   513  UART_SR_TXE = (7)
                           000006   514  UART_SR_TC = (6)
                           000005   515  UART_SR_RXNE = (5)
                           000004   516  UART_SR_IDLE = (4)
                           000003   517  UART_SR_OR = (3)
                           000002   518  UART_SR_NF = (2)
                           000001   519  UART_SR_FE = (1)
                           000000   520  UART_SR_PE = (0)
                                    521 
                                    522 ; Uart Control Register bits
                           000007   523  UART_CR1_R8 = (7)
                           000006   524  UART_CR1_T8 = (6)
                           000005   525  UART_CR1_UARTD = (5)
                           000004   526  UART_CR1_M = (4)
                           000003   527  UART_CR1_WAKE = (3)
                           000002   528  UART_CR1_PCEN = (2)
                           000001   529  UART_CR1_PS = (1)
                           000000   530  UART_CR1_PIEN = (0)
                                    531 
                           000007   532  UART_CR2_TIEN = (7)
                           000006   533  UART_CR2_TCIEN = (6)
                           000005   534  UART_CR2_RIEN = (5)
                           000004   535  UART_CR2_ILIEN = (4)
                           000003   536  UART_CR2_TEN = (3)
                           000002   537  UART_CR2_REN = (2)
                           000001   538  UART_CR2_RWU = (1)
                           000000   539  UART_CR2_SBK = (0)
                                    540 
                           000006   541  UART_CR3_LINEN = (6)
                           000005   542  UART_CR3_STOP1 = (5)
                           000004   543  UART_CR3_STOP0 = (4)
                           000003   544  UART_CR3_CLKEN = (3)
                           000002   545  UART_CR3_CPOL = (2)
                           000001   546  UART_CR3_CPHA = (1)
                           000000   547  UART_CR3_LBCL = (0)
                                    548 
                           000006   549  UART_CR4_LBDIEN = (6)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



                           000005   550  UART_CR4_LBDL = (5)
                           000004   551  UART_CR4_LBDF = (4)
                           000003   552  UART_CR4_ADD3 = (3)
                           000002   553  UART_CR4_ADD2 = (2)
                           000001   554  UART_CR4_ADD1 = (1)
                           000000   555  UART_CR4_ADD0 = (0)
                                    556 
                           000005   557  UART_CR5_SCEN = (5)
                           000004   558  UART_CR5_NACK = (4)
                           000003   559  UART_CR5_HDSEL = (3)
                           000002   560  UART_CR5_IRLP = (2)
                           000001   561  UART_CR5_IREN = (1)
                                    562 ; LIN mode config register
                           000007   563  UART_CR6_LDUM = (7)
                           000005   564  UART_CR6_LSLV = (5)
                           000004   565  UART_CR6_LASE = (4)
                           000002   566  UART_CR6_LHDIEN = (2) 
                           000001   567  UART_CR6_LHDF = (1)
                           000000   568  UART_CR6_LSF = (0)
                                    569 
                                    570 ; TIMERS
                                    571 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   572  TIM1_CR1  = (0x5250)
                           005251   573  TIM1_CR2  = (0x5251)
                           005252   574  TIM1_SMCR  = (0x5252)
                           005253   575  TIM1_ETR  = (0x5253)
                           005254   576  TIM1_IER  = (0x5254)
                           005255   577  TIM1_SR1  = (0x5255)
                           005256   578  TIM1_SR2  = (0x5256)
                           005257   579  TIM1_EGR  = (0x5257)
                           005258   580  TIM1_CCMR1  = (0x5258)
                           005259   581  TIM1_CCMR2  = (0x5259)
                           00525A   582  TIM1_CCMR3  = (0x525A)
                           00525B   583  TIM1_CCMR4  = (0x525B)
                           00525C   584  TIM1_CCER1  = (0x525C)
                           00525D   585  TIM1_CCER2  = (0x525D)
                           00525E   586  TIM1_CNTRH  = (0x525E)
                           00525F   587  TIM1_CNTRL  = (0x525F)
                           005260   588  TIM1_PSCRH  = (0x5260)
                           005261   589  TIM1_PSCRL  = (0x5261)
                           005262   590  TIM1_ARRH  = (0x5262)
                           005263   591  TIM1_ARRL  = (0x5263)
                           005264   592  TIM1_RCR  = (0x5264)
                           005265   593  TIM1_CCR1H  = (0x5265)
                           005266   594  TIM1_CCR1L  = (0x5266)
                           005267   595  TIM1_CCR2H  = (0x5267)
                           005268   596  TIM1_CCR2L  = (0x5268)
                           005269   597  TIM1_CCR3H  = (0x5269)
                           00526A   598  TIM1_CCR3L  = (0x526A)
                           00526B   599  TIM1_CCR4H  = (0x526B)
                           00526C   600  TIM1_CCR4L  = (0x526C)
                           00526D   601  TIM1_BKR  = (0x526D)
                           00526E   602  TIM1_DTR  = (0x526E)
                           00526F   603  TIM1_OISR  = (0x526F)
                                    604 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                                    605 ; Timer Control Register bits
                           000007   606  TIM_CR1_ARPE = (7)
                           000006   607  TIM_CR1_CMSH = (6)
                           000005   608  TIM_CR1_CMSL = (5)
                           000004   609  TIM_CR1_DIR = (4)
                           000003   610  TIM_CR1_OPM = (3)
                           000002   611  TIM_CR1_URS = (2)
                           000001   612  TIM_CR1_UDIS = (1)
                           000000   613  TIM_CR1_CEN = (0)
                                    614 
                           000006   615  TIM1_CR2_MMS2 = (6)
                           000005   616  TIM1_CR2_MMS1 = (5)
                           000004   617  TIM1_CR2_MMS0 = (4)
                           000002   618  TIM1_CR2_COMS = (2)
                           000000   619  TIM1_CR2_CCPC = (0)
                                    620 
                                    621 ; Timer Slave Mode Control bits
                           000007   622  TIM1_SMCR_MSM = (7)
                           000006   623  TIM1_SMCR_TS2 = (6)
                           000005   624  TIM1_SMCR_TS1 = (5)
                           000004   625  TIM1_SMCR_TS0 = (4)
                           000002   626  TIM1_SMCR_SMS2 = (2)
                           000001   627  TIM1_SMCR_SMS1 = (1)
                           000000   628  TIM1_SMCR_SMS0 = (0)
                                    629 
                                    630 ; Timer External Trigger Enable bits
                           000007   631  TIM1_ETR_ETP = (7)
                           000006   632  TIM1_ETR_ECE = (6)
                           000005   633  TIM1_ETR_ETPS1 = (5)
                           000004   634  TIM1_ETR_ETPS0 = (4)
                           000003   635  TIM1_ETR_ETF3 = (3)
                           000002   636  TIM1_ETR_ETF2 = (2)
                           000001   637  TIM1_ETR_ETF1 = (1)
                           000000   638  TIM1_ETR_ETF0 = (0)
                                    639 
                                    640 ; Timer Interrupt Enable bits
                           000007   641  TIM1_IER_BIE = (7)
                           000006   642  TIM1_IER_TIE = (6)
                           000005   643  TIM1_IER_COMIE = (5)
                           000004   644  TIM1_IER_CC4IE = (4)
                           000003   645  TIM1_IER_CC3IE = (3)
                           000002   646  TIM1_IER_CC2IE = (2)
                           000001   647  TIM1_IER_CC1IE = (1)
                           000000   648  TIM1_IER_UIE = (0)
                                    649 
                                    650 ; Timer Status Register bits
                           000007   651  TIM1_SR1_BIF = (7)
                           000006   652  TIM1_SR1_TIF = (6)
                           000005   653  TIM1_SR1_COMIF = (5)
                           000004   654  TIM1_SR1_CC4IF = (4)
                           000003   655  TIM1_SR1_CC3IF = (3)
                           000002   656  TIM1_SR1_CC2IF = (2)
                           000001   657  TIM1_SR1_CC1IF = (1)
                           000000   658  TIM1_SR1_UIF = (0)
                                    659 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



                           000004   660  TIM1_SR2_CC4OF = (4)
                           000003   661  TIM1_SR2_CC3OF = (3)
                           000002   662  TIM1_SR2_CC2OF = (2)
                           000001   663  TIM1_SR2_CC1OF = (1)
                                    664 
                                    665 ; Timer Event Generation Register bits
                           000007   666  TIM1_EGR_BG = (7)
                           000006   667  TIM1_EGR_TG = (6)
                           000005   668  TIM1_EGR_COMG = (5)
                           000004   669  TIM1_EGR_CC4G = (4)
                           000003   670  TIM1_EGR_CC3G = (3)
                           000002   671  TIM1_EGR_CC2G = (2)
                           000001   672  TIM1_EGR_CC1G = (1)
                           000000   673  TIM1_EGR_UG = (0)
                                    674 
                                    675 ; Capture/Compare Mode Register 1 - channel configured in output
                           000007   676  TIM1_CCMR1_OC1CE = (7)
                           000006   677  TIM1_CCMR1_OC1M2 = (6)
                           000005   678  TIM1_CCMR1_OC1M1 = (5)
                           000004   679  TIM1_CCMR1_OC1M0 = (4)
                           000003   680  TIM1_CCMR1_OC1PE = (3)
                           000002   681  TIM1_CCMR1_OC1FE = (2)
                           000001   682  TIM1_CCMR1_CC1S1 = (1)
                           000000   683  TIM1_CCMR1_CC1S0 = (0)
                                    684 
                                    685 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   686  TIM1_CCMR1_IC1F3 = (7)
                           000006   687  TIM1_CCMR1_IC1F2 = (6)
                           000005   688  TIM1_CCMR1_IC1F1 = (5)
                           000004   689  TIM1_CCMR1_IC1F0 = (4)
                           000003   690  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   691  TIM1_CCMR1_IC1PSC0 = (2)
                                    692 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   693  TIM1_CCMR1_CC1S0 = (0)
                                    694 
                                    695 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   696  TIM1_CCMR2_OC2CE = (7)
                           000006   697  TIM1_CCMR2_OC2M2 = (6)
                           000005   698  TIM1_CCMR2_OC2M1 = (5)
                           000004   699  TIM1_CCMR2_OC2M0 = (4)
                           000003   700  TIM1_CCMR2_OC2PE = (3)
                           000002   701  TIM1_CCMR2_OC2FE = (2)
                           000001   702  TIM1_CCMR2_CC2S1 = (1)
                           000000   703  TIM1_CCMR2_CC2S0 = (0)
                                    704 
                                    705 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   706  TIM1_CCMR2_IC2F3 = (7)
                           000006   707  TIM1_CCMR2_IC2F2 = (6)
                           000005   708  TIM1_CCMR2_IC2F1 = (5)
                           000004   709  TIM1_CCMR2_IC2F0 = (4)
                           000003   710  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   711  TIM1_CCMR2_IC2PSC0 = (2)
                                    712 ;  TIM1_CCMR2_CC2S1 = (1)
                           000000   713  TIM1_CCMR2_CC2S0 = (0)
                                    714 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



                                    715 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   716  TIM1_CCMR3_OC3CE = (7)
                           000006   717  TIM1_CCMR3_OC3M2 = (6)
                           000005   718  TIM1_CCMR3_OC3M1 = (5)
                           000004   719  TIM1_CCMR3_OC3M0 = (4)
                           000003   720  TIM1_CCMR3_OC3PE = (3)
                           000002   721  TIM1_CCMR3_OC3FE = (2)
                           000001   722  TIM1_CCMR3_CC3S1 = (1)
                           000000   723  TIM1_CCMR3_CC3S0 = (0)
                                    724 
                                    725 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   726  TIM1_CCMR3_IC3F3 = (7)
                           000006   727  TIM1_CCMR3_IC3F2 = (6)
                           000005   728  TIM1_CCMR3_IC3F1 = (5)
                           000004   729  TIM1_CCMR3_IC3F0 = (4)
                           000003   730  TIM1_CCMR3_IC3PSC1 = (3)
                           000002   731  TIM1_CCMR3_IC3PSC0 = (2)
                                    732 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   733  TIM1_CCMR3_CC3S0 = (0)
                                    734 
                                    735 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   736  TIM1_CCMR4_OC4CE = (7)
                           000006   737  TIM1_CCMR4_OC4M2 = (6)
                           000005   738  TIM1_CCMR4_OC4M1 = (5)
                           000004   739  TIM1_CCMR4_OC4M0 = (4)
                           000003   740  TIM1_CCMR4_OC4PE = (3)
                           000002   741  TIM1_CCMR4_OC4FE = (2)
                           000001   742  TIM1_CCMR4_CC4S1 = (1)
                           000000   743  TIM1_CCMR4_CC4S0 = (0)
                                    744 
                                    745 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   746  TIM1_CCMR4_IC4F3 = (7)
                           000006   747  TIM1_CCMR4_IC4F2 = (6)
                           000005   748  TIM1_CCMR4_IC4F1 = (5)
                           000004   749  TIM1_CCMR4_IC4F0 = (4)
                           000003   750  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   751  TIM1_CCMR4_IC4PSC0 = (2)
                                    752 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   753  TIM1_CCMR4_CC4S0 = (0)
                                    754 
                                    755 ; Timer 2 - 16-bit timer
                           005300   756  TIM2_CR1  = (0x5300)
                           005301   757  TIM2_IER  = (0x5301)
                           005302   758  TIM2_SR1  = (0x5302)
                           005303   759  TIM2_SR2  = (0x5303)
                           005304   760  TIM2_EGR  = (0x5304)
                           005305   761  TIM2_CCMR1  = (0x5305)
                           005306   762  TIM2_CCMR2  = (0x5306)
                           005307   763  TIM2_CCMR3  = (0x5307)
                           005308   764  TIM2_CCER1  = (0x5308)
                           005309   765  TIM2_CCER2  = (0x5309)
                           00530A   766  TIM2_CNTRH  = (0x530A)
                           00530B   767  TIM2_CNTRL  = (0x530B)
                           00530C   768  TIM2_PSCR  = (0x530C)
                           00530D   769  TIM2_ARRH  = (0x530D)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



                           00530E   770  TIM2_ARRL  = (0x530E)
                           00530F   771  TIM2_CCR1H  = (0x530F)
                           005310   772  TIM2_CCR1L  = (0x5310)
                           005311   773  TIM2_CCR2H  = (0x5311)
                           005312   774  TIM2_CCR2L  = (0x5312)
                           005313   775  TIM2_CCR3H  = (0x5313)
                           005314   776  TIM2_CCR3L  = (0x5314)
                                    777 
                                    778 ; Timer 3
                           005320   779  TIM3_CR1  = (0x5320)
                           005321   780  TIM3_IER  = (0x5321)
                           005322   781  TIM3_SR1  = (0x5322)
                           005323   782  TIM3_SR2  = (0x5323)
                           005324   783  TIM3_EGR  = (0x5324)
                           005325   784  TIM3_CCMR1  = (0x5325)
                           005326   785  TIM3_CCMR2  = (0x5326)
                           005327   786  TIM3_CCER1  = (0x5327)
                           005328   787  TIM3_CNTRH  = (0x5328)
                           005329   788  TIM3_CNTRL  = (0x5329)
                           00532A   789  TIM3_PSCR  = (0x532A)
                           00532B   790  TIM3_ARRH  = (0x532B)
                           00532C   791  TIM3_ARRL  = (0x532C)
                           00532D   792  TIM3_CCR1H  = (0x532D)
                           00532E   793  TIM3_CCR1L  = (0x532E)
                           00532F   794  TIM3_CCR2H  = (0x532F)
                           005330   795  TIM3_CCR2L  = (0x5330)
                                    796 
                                    797 ; TIM3_CR1  fields
                           000000   798  TIM3_CR1_CEN = (0)
                           000001   799  TIM3_CR1_UDIS = (1)
                           000002   800  TIM3_CR1_URS = (2)
                           000003   801  TIM3_CR1_OPM = (3)
                           000007   802  TIM3_CR1_ARPE = (7)
                                    803 ; TIM3_CCR2  fields
                           000000   804  TIM3_CCMR2_CC2S_POS = (0)
                           000003   805  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   806  TIM3_CCMR2_OC2M_POS = (4)  
                                    807 ; TIM3_CCER1 fields
                           000000   808  TIM3_CCER1_CC1E = (0)
                           000001   809  TIM3_CCER1_CC1P = (1)
                           000004   810  TIM3_CCER1_CC2E = (4)
                           000005   811  TIM3_CCER1_CC2P = (5)
                                    812 ; TIM3_CCER2 fields
                           000000   813  TIM3_CCER2_CC3E = (0)
                           000001   814  TIM3_CCER2_CC3P = (1)
                                    815 
                                    816 ; Timer 4
                           005340   817  TIM4_CR1  = (0x5340)
                           005341   818  TIM4_IER  = (0x5341)
                           005342   819  TIM4_SR  = (0x5342)
                           005343   820  TIM4_EGR  = (0x5343)
                           005344   821  TIM4_CNTR  = (0x5344)
                           005345   822  TIM4_PSCR  = (0x5345)
                           005346   823  TIM4_ARR  = (0x5346)
                                    824 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



                                    825 ; Timer 4 bitmasks
                                    826 
                           000007   827  TIM4_CR1_ARPE = (7)
                           000003   828  TIM4_CR1_OPM = (3)
                           000002   829  TIM4_CR1_URS = (2)
                           000001   830  TIM4_CR1_UDIS = (1)
                           000000   831  TIM4_CR1_CEN = (0)
                                    832 
                           000000   833  TIM4_IER_UIE = (0)
                                    834 
                           000000   835  TIM4_SR_UIF = (0)
                                    836 
                           000000   837  TIM4_EGR_UG = (0)
                                    838 
                           000002   839  TIM4_PSCR_PSC2 = (2)
                           000001   840  TIM4_PSCR_PSC1 = (1)
                           000000   841  TIM4_PSCR_PSC0 = (0)
                                    842 
                           000000   843  TIM4_PSCR_1 = 0
                           000001   844  TIM4_PSCR_2 = 1
                           000002   845  TIM4_PSCR_4 = 2
                           000003   846  TIM4_PSCR_8 = 3
                           000004   847  TIM4_PSCR_16 = 4
                           000005   848  TIM4_PSCR_32 = 5
                           000006   849  TIM4_PSCR_64 = 6
                           000007   850  TIM4_PSCR_128 = 7
                                    851 
                                    852 ; ADC2
                           005400   853  ADC_CSR  = (0x5400)
                           005401   854  ADC_CR1  = (0x5401)
                           005402   855  ADC_CR2  = (0x5402)
                           005403   856  ADC_CR3  = (0x5403)
                           005404   857  ADC_DRH  = (0x5404)
                           005405   858  ADC_DRL  = (0x5405)
                           005406   859  ADC_TDRH  = (0x5406)
                           005407   860  ADC_TDRL  = (0x5407)
                                    861  
                                    862 ; ADC bitmasks
                                    863 
                           000007   864  ADC_CSR_EOC = (7)
                           000006   865  ADC_CSR_AWD = (6)
                           000005   866  ADC_CSR_EOCIE = (5)
                           000004   867  ADC_CSR_AWDIE = (4)
                           000003   868  ADC_CSR_CH3 = (3)
                           000002   869  ADC_CSR_CH2 = (2)
                           000001   870  ADC_CSR_CH1 = (1)
                           000000   871  ADC_CSR_CH0 = (0)
                                    872 
                           000006   873  ADC_CR1_SPSEL2 = (6)
                           000005   874  ADC_CR1_SPSEL1 = (5)
                           000004   875  ADC_CR1_SPSEL0 = (4)
                           000001   876  ADC_CR1_CONT = (1)
                           000000   877  ADC_CR1_ADON = (0)
                                    878 
                           000006   879  ADC_CR2_EXTTRIG = (6)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                           000005   880  ADC_CR2_EXTSEL1 = (5)
                           000004   881  ADC_CR2_EXTSEL0 = (4)
                           000003   882  ADC_CR2_ALIGN = (3)
                           000001   883  ADC_CR2_SCAN = (1)
                                    884 
                           000007   885  ADC_CR3_DBUF = (7)
                           000006   886  ADC_CR3_DRH = (6)
                                    887 
                                    888 ; beCAN
                           005420   889  CAN_MCR = (0x5420)
                           005421   890  CAN_MSR = (0x5421)
                           005422   891  CAN_TSR = (0x5422)
                           005423   892  CAN_TPR = (0x5423)
                           005424   893  CAN_RFR = (0x5424)
                           005425   894  CAN_IER = (0x5425)
                           005426   895  CAN_DGR = (0x5426)
                           005427   896  CAN_FPSR = (0x5427)
                           005428   897  CAN_P0 = (0x5428)
                           005429   898  CAN_P1 = (0x5429)
                           00542A   899  CAN_P2 = (0x542A)
                           00542B   900  CAN_P3 = (0x542B)
                           00542C   901  CAN_P4 = (0x542C)
                           00542D   902  CAN_P5 = (0x542D)
                           00542E   903  CAN_P6 = (0x542E)
                           00542F   904  CAN_P7 = (0x542F)
                           005430   905  CAN_P8 = (0x5430)
                           005431   906  CAN_P9 = (0x5431)
                           005432   907  CAN_PA = (0x5432)
                           005433   908  CAN_PB = (0x5433)
                           005434   909  CAN_PC = (0x5434)
                           005435   910  CAN_PD = (0x5435)
                           005436   911  CAN_PE = (0x5436)
                           005437   912  CAN_PF = (0x5437)
                                    913 
                                    914 
                                    915 ; CPU
                           007F00   916  CPU_A  = (0x7F00)
                           007F01   917  CPU_PCE  = (0x7F01)
                           007F02   918  CPU_PCH  = (0x7F02)
                           007F03   919  CPU_PCL  = (0x7F03)
                           007F04   920  CPU_XH  = (0x7F04)
                           007F05   921  CPU_XL  = (0x7F05)
                           007F06   922  CPU_YH  = (0x7F06)
                           007F07   923  CPU_YL  = (0x7F07)
                           007F08   924  CPU_SPH  = (0x7F08)
                           007F09   925  CPU_SPL   = (0x7F09)
                           007F0A   926  CPU_CCR   = (0x7F0A)
                                    927 
                                    928 ; global configuration register
                           007F60   929  CFG_GCR   = (0x7F60)
                                    930 
                                    931 ; interrupt control registers
                           007F70   932  ITC_SPR1   = (0x7F70)
                           007F71   933  ITC_SPR2   = (0x7F71)
                           007F72   934  ITC_SPR3   = (0x7F72)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                           007F73   935  ITC_SPR4   = (0x7F73)
                           007F74   936  ITC_SPR5   = (0x7F74)
                           007F75   937  ITC_SPR6   = (0x7F75)
                           007F76   938  ITC_SPR7   = (0x7F76)
                           007F77   939  ITC_SPR8   = (0x7F77)
                                    940 
                                    941 ; SWIM, control and status register
                           007F80   942  SWIM_CSR   = (0x7F80)
                                    943 ; debug registers
                           007F90   944  DM_BK1RE   = (0x7F90)
                           007F91   945  DM_BK1RH   = (0x7F91)
                           007F92   946  DM_BK1RL   = (0x7F92)
                           007F93   947  DM_BK2RE   = (0x7F93)
                           007F94   948  DM_BK2RH   = (0x7F94)
                           007F95   949  DM_BK2RL   = (0x7F95)
                           007F96   950  DM_CR1   = (0x7F96)
                           007F97   951  DM_CR2   = (0x7F97)
                           007F98   952  DM_CSR1   = (0x7F98)
                           007F99   953  DM_CSR2   = (0x7F99)
                           007F9A   954  DM_ENFCTR   = (0x7F9A)
                                    955 
                                    956 ; Interrupt Numbers
                           000000   957  INT_TLI = 0
                           000001   958  INT_AWU = 1
                           000002   959  INT_CLK = 2
                           000003   960  INT_EXTI0 = 3
                           000004   961  INT_EXTI1 = 4
                           000005   962  INT_EXTI2 = 5
                           000006   963  INT_EXTI3 = 6
                           000007   964  INT_EXTI4 = 7
                           000008   965  INT_CAN_RX = 8
                           000009   966  INT_CAN_TX = 9
                           00000A   967  INT_SPI = 10
                           00000B   968  INT_TIM1_OVF = 11
                           00000C   969  INT_TIM1_CCM = 12
                           00000D   970  INT_TIM2_OVF = 13
                           00000E   971  INT_TIM2_CCM = 14
                           00000F   972  INT_TIM3_OVF = 15
                           000010   973  INT_TIM3_CCM = 16
                           000011   974  INT_UART1_TX_COMPLETED = 17
                           000012   975  INT_AUART1_RX_FULL = 18
                           000013   976  INT_I2C = 19
                           000014   977  INT_UART3_TX_COMPLETED = 20
                           000015   978  INT_UART3_RX_FULL = 21
                           000016   979  INT_ADC2 = 22
                           000017   980  INT_TIM4_OVF = 23
                           000018   981  INT_FLASH = 24
                                    982 
                                    983 ; Interrupt Vectors
                           008000   984  INT_VECTOR_RESET = 0x8000
                           008004   985  INT_VECTOR_TRAP = 0x8004
                           008008   986  INT_VECTOR_TLI = 0x8008
                           00800C   987  INT_VECTOR_AWU = 0x800C
                           008010   988  INT_VECTOR_CLK = 0x8010
                           008014   989  INT_VECTOR_EXTI0 = 0x8014
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                           008018   990  INT_VECTOR_EXTI1 = 0x8018
                           00801C   991  INT_VECTOR_EXTI2 = 0x801C
                           008020   992  INT_VECTOR_EXTI3 = 0x8020
                           008024   993  INT_VECTOR_EXTI4 = 0x8024
                           008028   994  INT_VECTOR_CAN_RX = 0x8028
                           00802C   995  INT_VECTOR_CAN_TX = 0x802c
                           008030   996  INT_VECTOR_SPI = 0x8030
                           008034   997  INT_VECTOR_TIM1_OVF = 0x8034
                           008038   998  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C   999  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1000  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1001  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1002  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1003  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1004  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1005  INT_VECTOR_I2C = 0x8054
                           008058  1006  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1007  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1008  INT_VECTOR_ADC2 = 0x8060
                           008064  1009  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1010  INT_VECTOR_FLASH = 0x8068
                                   1011 
                                   1012  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



                                      7 ;	.list
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



                                      9 
                                     10 ;-------------------------------------------------------
                                     11 ;     vt100 CTRL_x  values
                                     12 ;-------------------------------------------------------
                           000001    13 		CTRL_A = 1
                           000002    14 		CTRL_B = 2
                           000003    15 		CTRL_C = 3
                           000004    16 		CTRL_D = 4
                           000005    17 		CTRL_E = 5
                           000006    18 		CTRL_F = 6
                           000007    19 		CTRL_G = 7
                           000008    20 		CTRL_H = 8
                           000009    21 		CTRL_I = 9
                           00000A    22 		CTRL_J = 10
                           00000B    23 		CTRL_K = 11
                           00000C    24 		CTRL_L = 12
                           00000D    25 		CTRL_M = 13
                           00000E    26 		CTRL_N = 14
                           00000F    27 		CTRL_O = 15
                           000010    28 		CTRL_P = 16
                           000011    29 		CTRL_Q = 17
                           000012    30 		CTRL_R = 18
                           000013    31 		CTRL_S = 19
                           000014    32 		CTRL_T = 20
                           000015    33 		CTRL_U = 21
                           000016    34 		CTRL_V = 22
                           000017    35 		CTRL_W = 23
                           000018    36 		CTRL_X = 24
                           000019    37 		CTRL_Y = 25
                           00001A    38 		CTRL_Z = 26
                           00001B    39 		ESC = 27
                           00000A    40 		NL = CTRL_J
                           00000D    41 		CR = CTRL_M
                           000008    42 		BSP = CTRL_H
                           000020    43 		SPACE = 32
                                     44 		
                                     45 ;--------------------------------------------------------
                                     46 ;      MACROS
                                     47 ;--------------------------------------------------------
                                     48 		.macro _ledenable ; set PC5 as push-pull output fast mode
                                     49 		bset PC_CR1,#LED2_BIT
                                     50 		bset PC_CR2,#LED2_BIT
                                     51 		bset PC_DDR,#LED2_BIT
                                     52 		.endm
                                     53 		
                                     54 		.macro _ledon ; turn on green LED 
                                     55 		bset PC_ODR,#LED2_BIT
                                     56 		.endm
                                     57 		
                                     58 		.macro _ledoff ; turn off green LED
                                     59 		bres PC_ODR,#LED2_BIT
                                     60 		.endm
                                     61 		
                                     62 		.macro _ledtoggle ; invert green LED state
                                     63 		ld a,#LED2_MASK
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



                                     64 		xor a,PC_ODR
                                     65 		ld PC_ODR,a
                                     66 		.endm
                                     67 		
                                     68 		
                                     69 		.macro  _interrupts ; enable interrupts
                                     70 		 rim
                                     71 		.endm
                                     72 		
                                     73 		.macro _no_interrupts ; disable interrupts
                                     74 		sim
                                     75 		.endm
                                     76 
                                     77 ;--------------------------------------------------------
                                     78 ;        OPTION BYTES
                                     79 ;--------------------------------------------------------
                                     80 ;		.area 	OPTION (ABS)
                                     81 ;		.org 0x4800
                                     82 ;		.byte 0,0,255,0,255,0,255,0,255,0,255
                                     83 		
                                     84 ;--------------------------------------------------------
                                     85 ; ram uninitialized variables
                                     86 ;--------------------------------------------------------
                           000100    87 		STACK_SIZE = 256
                           001700    88 		STACK_BASE = RAM_SIZE-STACK_SIZE
                           0017FF    89 		STACK_TOP = RAM_SIZE-1 ; stack at end of ram
                           000050    90 		TIB_SIZE = 80
                           000050    91 		PAD_SIZE = 80
                                     92         .area DATA
                                     93 ;ticks  .blkw 1 ; system ticks at every millisecond        
                                     94 ;cntdwn:	.blkw 1 ; millisecond count down timer
      000001                         95 rx_char: .blkb 1 ; last uart received char
      000002                         96 in.w:     .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
      000003                         97 in:		.blkb 1; parser position in tib
      000004                         98 count:  .blkb 1; length of string in tib
      000005                         99 idx_x:  .blkw 1; index for table pointed by x
      000007                        100 idx_y:  .blkw 1; index for table pointed by y
      000009                        101 tib:	.blkb TIB_SIZE ; transaction input buffer
      000059                        102 pad:	.blkb PAD_SIZE ; working pad
      0000A9                        103 acc16:  .blkw 1; 16 bits accumulator
      0000AB                        104 ram_free_base: .blkw 1
      0000AD                        105 flash_free_base: .blkw 1
                                    106 		.area USER_RAM_BASE
      0000AF                        107  _user_ram:		
                                    108 ;--------------------------------------------------------
                                    109 ; ram data
                                    110 ;--------------------------------------------------------
                                    111         .area INITIALIZED
                                    112 
                                    113 ;--------------------------------------------------------
                                    114 ;  stack segment
                                    115 ;--------------------------------------------------------
                                    116        .area SSEG  (ABS)
      001700                        117 	   .org RAM_SIZE-STACK_SIZE
      001700                        118  __stack_buttom:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



      001700                        119 	   .ds  256
                                    120 
                                    121 ;--------------------------------------------------------
                                    122 ; interrupt vector 
                                    123 ;--------------------------------------------------------
                                    124 	.area HOME
      008000                        125 __interrupt_vect:
      008000 82 00 80 AF            126 	int init0 ;RESET vector
      008004 82 00 81 4A            127 	int NonHandledInterrupt ;TRAP  software interrupt
      008008 82 00 81 4A            128 	int NonHandledInterrupt ;int0 TLI   external top level interrupt
      00800C 82 00 81 4A            129 	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
      008010 82 00 81 4A            130 	int NonHandledInterrupt ;int2 CLK   clock controller
      008014 82 00 81 4A            131 	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
      008018 82 00 81 4A            132 	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
      00801C 82 00 81 4A            133 	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
      008020 82 00 81 4A            134 	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
      008024 82 00 81 4A            135 	int NonHandledInterrupt ;int7 EXTI4 port E external interrupts
      008028 82 00 81 4A            136 	int NonHandledInterrupt ;int8 beCAN RX interrupt
      00802C 82 00 81 4A            137 	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
      008030 82 00 81 4A            138 	int NonHandledInterrupt ;int10 SPI End of transfer
      008034 82 00 81 4A            139 	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
      008038 82 00 81 4A            140 	int NonHandledInterrupt ;int12 TIM1 capture/compare
      00803C 82 00 81 4A            141 	int NonHandledInterrupt ;int13 TIM2 update /overflow
      008040 82 00 81 4A            142 	int NonHandledInterrupt ;int14 TIM2 capture/compare
      008044 82 00 81 4A            143 	int NonHandledInterrupt ;int15 TIM3 Update/overflow
      008048 82 00 81 4A            144 	int NonHandledInterrupt ;int16 TIM3 Capture/compare
      00804C 82 00 81 4A            145 	int NonHandledInterrupt ;int17 UART1 TX completed
      008050 82 00 81 4A            146 	int NonHandledInterrupt ;int18 UART1 RX full
      008054 82 00 81 4A            147 	int NonHandledInterrupt ;int19 I2C 
      008058 82 00 81 4A            148 	int NonHandledInterrupt ;int20 UART3 TX completed
      00805C 82 00 81 4F            149 	int uart_rx_isr         ;int21 UART3 RX full
      008060 82 00 81 4A            150 	int NonHandledInterrupt ;int22 ADC2 end of conversion
      008064 82 00 81 4A            151 	int NonHandledInterrupt	;int23 TIM4 update/overflow
      008068 82 00 81 4A            152 	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
      00806C 82 00 81 4A            153 	int NonHandledInterrupt ;int25  not used
      008070 82 00 81 4A            154 	int NonHandledInterrupt ;int26  not used
      008074 82 00 81 4A            155 	int NonHandledInterrupt ;int27  not used
      008078 82 00 81 4A            156 	int NonHandledInterrupt ;int28  not used
                                    157 
                                    158 	.area CODE
                                    159 
                                    160 	;initialize clock to HSE 16Mhz
      00807C                        161 clock_init:	
      00807C 72 12 50 C5      [ 1]  162 	bset CLK_SWCR,#CLK_SWCR_SWEN
      008080 A6 B4            [ 1]  163 	ld a,#CLK_SWR_HSE
      008082 C7 50 C4         [ 1]  164 	ld CLK_SWR,a
      008085 C1 50 C3         [ 1]  165 1$:	cp a,CLK_CMSR
      008088 26 FB            [ 1]  166 	jrne 1$
      00808A 81               [ 4]  167 	ret
                                    168 
                                    169 		; initialize TIMER4 ticks counter
                                    170 ;timer4_init:
                                    171 ;	clr ticks
                                    172 ;	clr cntdwn
                                    173 ;	ld a,#TIM4_PSCR_128 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                                    174 ;	ld TIM4_PSCR,a
                                    175 ;	bset TIM4_IER,#TIM4_IER_UIE
                                    176 ;	bres TIM4_SR,#TIM4_SR_UIF
                                    177 ;	ld a,#125
                                    178 ;	ld TIM4_ARR,a ; 1 msec interval
                                    179 ;	ld a,#((1<<TIM4_CR1_CEN)+(1<<TIM4_CR1_ARPE)) 
                                    180 ;	ld TIM4_CR1,a
                                    181 ;	ret
                                    182 
                                    183 	; initialize UART3, 115200 8N1
      00808B                        184 uart3_init:
                                    185 ;	bset CLK_PCKENR1,#CLK_PCKENR1_UART3
                                    186 	; configure tx pin
      00808B 72 1A 50 11      [ 1]  187 	bset PD_DDR,#BIT5 ; tx pin
      00808F 72 1A 50 12      [ 1]  188 	bset PD_CR1,#BIT5 ; push-pull output
      008093 72 1A 50 13      [ 1]  189 	bset PD_CR2,#BIT5 ; fast output
                                    190 	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
      008097 35 05 52 43      [ 1]  191 	mov UART3_BRR2,#0x05 ; must be loaded first
      00809B 35 04 52 42      [ 1]  192 	mov UART3_BRR1,#0x4
      00809F 35 2C 52 45      [ 1]  193 	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN))
      0080A3 81               [ 4]  194 	ret
                                    195 	
                                    196 	; pause in milliseconds
                                    197     ; input:  y delay
                                    198     ; output: none
                                    199 ;pause:
                                    200 ;	 ldw cntdwn,y
                                    201 ;1$: ldw y,cntdwn
                                    202 ;	 jrne 1$
                                    203 ;    ret
                                    204 
                                    205 ;-------------------------
                                    206 ;  zero all free ram
                                    207 ;-------------------------
      0080A4                        208 clear_all_free_ram:
      0080A4 AE 00 00         [ 2]  209 	ldw x,#0
      0080A7                        210 clear_ram0:	
      0080A7 7F               [ 1]  211 	clr (x)
      0080A8 5C               [ 1]  212 	incw x
      0080A9 A3 17 FD         [ 2]  213 	cpw x,#STACK_TOP-2
      0080AC 23 F9            [ 2]  214 	jrule clear_ram0
      0080AE 81               [ 4]  215 	ret
                                    216 
      0080AF                        217 init0:
                                    218 	; initialize SP
      0080AF AE 17 FF         [ 2]  219 	ldw x,#STACK_TOP
      0080B2 94               [ 1]  220 	ldw sp,x
      000037                        221 	_no_interrupts
      0080B3 9B               [ 1]    1 		sim
      0080B4 CD 80 7C         [ 4]  222 	call clock_init
      0080B7 CD 80 A4         [ 4]  223 	call clear_all_free_ram
                                    224 ;	clr ticks
                                    225 ;	clr cntdwn
      0080BA A6 FF            [ 1]  226 	ld a,#255
      0080BC C7 00 01         [ 1]  227 	ld rx_char,a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



                                    228 ;	call timer4_init
      0080BF CD 80 8B         [ 4]  229 	call uart3_init
      000046                        230 	_ledenable
      0080C2 72 1A 50 0D      [ 1]    1 		bset PC_CR1,#LED2_BIT
      0080C6 72 1A 50 0E      [ 1]    2 		bset PC_CR2,#LED2_BIT
      0080CA 72 1A 50 0C      [ 1]    3 		bset PC_DDR,#LED2_BIT
      000052                        231 	_ledoff
      0080CE 72 1B 50 0A      [ 1]    1 		bres PC_ODR,#LED2_BIT
      0080D2 72 5F 00 02      [ 1]  232 	clr in.w ; must always be 0
                                    233 	; initialize free_ram_base variable
      0080D6 90 AE 00 AF      [ 2]  234 	ldw y,#_user_ram ;#ram_free_base
                                    235 ;	addw y,#0xf
                                    236 ;	ld a,yl
                                    237 ;	and a,#0xf0
                                    238 ;	ld yl,a
      0080DA 90 CF 00 AB      [ 2]  239 	ldw ram_free_base,y
                                    240 	; initialize flash_free_base variable
      0080DE 90 AE 88 B1      [ 2]  241 	ldw y,#flash_free
      0080E2 72 A9 00 FF      [ 2]  242 	addw y,#0xff
      0080E6 4F               [ 1]  243 	clr a
      0080E7 90 97            [ 1]  244 	ld yl,a
      0080E9 90 CF 00 AD      [ 2]  245 	ldw flash_free_base,y
      0080ED                        246 main:
      000071                        247 	_interrupts
      0080ED 9A               [ 1]    1 		 rim
      0080EE A6 0C            [ 1]  248 	ld a,#0xc
      0080F0 CD 81 61         [ 4]  249 	call uart_tx
      0080F3 90 AE 86 50      [ 2]  250 	ldw y,#VERSION
      0080F7 CD 81 6B         [ 4]  251 	call uart_print
      0080FA 90 AE 86 98      [ 2]  252 	ldw y,#RAM_FREE_MSG
      0080FE CD 81 6B         [ 4]  253 	call uart_print
      008101 90 CE 00 AB      [ 2]  254 	ldw y,ram_free_base
      008105 A6 10            [ 1]  255 	ld a,#16
      008107 CD 82 D5         [ 4]  256 	call itoa
      00810A CD 81 6B         [ 4]  257 	call uart_print
      00810D 90 AE 86 A3      [ 2]  258 	ldw y,#RAM_LAST_FREE_MSG
      008111 CD 81 6B         [ 4]  259 	call uart_print
      008114 90 AE 86 AC      [ 2]  260 	ldw y,#FLASH_FREE_MSG
      008118 CD 81 6B         [ 4]  261 	call uart_print
      00811B A6 10            [ 1]  262 	ld a,#16
      00811D 90 CE 00 AD      [ 2]  263 	ldw y,flash_free_base
      008121 CD 82 D5         [ 4]  264 	call itoa
      008124 CD 81 6B         [ 4]  265 	call uart_print
      008127 90 AE 86 B9      [ 2]  266 	ldw y,#EEPROM_MSG
      00812B CD 81 6B         [ 4]  267 	call uart_print
                                    268 	; read execute print loop
      00812E                        269 repl:
      00812E A6 0A            [ 1]  270 	ld a,#NL
      008130 CD 81 61         [ 4]  271 	call uart_tx
      008133 A6 3E            [ 1]  272 	ld a,#'>
      008135 CD 81 61         [ 4]  273 	call uart_tx
      008138 CD 81 B1         [ 4]  274 	call readln
      00813B 72 5D 00 04      [ 1]  275 	tnz count
      00813F 27 ED            [ 1]  276 	jreq repl
      008141 72 5F 00 03      [ 1]  277 	clr in
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 28.
Hexadecimal [24-Bits]



      008145 CD 84 C0         [ 4]  278 	call eval
      008148 20 E4            [ 2]  279 	jra repl
                                    280 	 
                                    281 
                                    282 ;	interrupt NonHandledInterrupt
                                    283 ;   non handled interrupt reset MCU
      00814A                        284 NonHandledInterrupt:
      00814A A6 80            [ 1]  285 	ld a,#0x80
      00814C C7 50 D1         [ 1]  286 	ld WWDG_CR,a
                                    287 	;iret
                                    288 
                                    289 	; TIMER4 interrupt service
                                    290 ;timer4_isr:
                                    291 ;	ldw y,ticks
                                    292 ;	incw y
                                    293 ;	ldw ticks,y
                                    294 ;	ldw y,cntdwn
                                    295 ;	jreq 1$
                                    296 ;	decw y
                                    297 ;	ldw cntdwn,y
                                    298 ;1$: bres TIM4_SR,#TIM4_SR_UIF
                                    299 ;	iret
                                    300 
                                    301 	; uart3 receive interrupt service
      00814F                        302 uart_rx_isr:
      00814F 88               [ 1]  303     push a
      008150 C6 52 40         [ 1]  304     ld a, UART3_SR
      008153 6B 01            [ 1]  305     ld (1,sp),a
      008155 C6 52 41         [ 1]  306 	ld a, UART3_DR
      008158 0D 01            [ 1]  307 	tnz (1,sp)
      00815A 27 03            [ 1]  308 	jreq 1$
      00815C C7 00 01         [ 1]  309     ld rx_char,a
      00815F 84               [ 1]  310 1$: pop a
      008160 80               [11]  311 	iret
                                    312 	
                                    313 
                                    314 	; transmit character in a via UART3
                                    315 	; character to transmit on (3,sp)
      008161                        316 uart_tx:
      008161 72 5D 52 40      [ 1]  317 	tnz UART3_SR
      008165 2A FA            [ 1]  318 	jrpl uart_tx
      008167 C7 52 41         [ 1]  319 	ld UART3_DR,a
      00816A 81               [ 4]  320     ret
                                    321 
                                    322 	; send string via UART2
                                    323 	; y is pointer to str
      00816B                        324 uart_print:
      00816B 90 F6            [ 1]  325 	ld a,(y)
      00816D 27 07            [ 1]  326 	jreq 1$
      00816F CD 81 61         [ 4]  327 	call uart_tx
      008172 90 5C            [ 1]  328 	incw y
      008174 20 F5            [ 2]  329 	jra uart_print
      008176 81               [ 4]  330 1$: ret
                                    331 
                                    332 	 ; check if char available
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 29.
Hexadecimal [24-Bits]



      008177                        333 uart_qchar:
      008177 A6 FF            [ 1]  334 	ld a,#255
      008179 C1 00 01         [ 1]  335 	cp a,rx_char
      00817C 81               [ 4]  336     ret
                                    337 
      00817D                        338 ungetchar: ; return char ina A to queue
      000101                        339 	_no_interrupts
      00817D 9B               [ 1]    1 		sim
      00817E C7 00 01         [ 1]  340 	ld rx_char,a
      000105                        341     _interrupts
      008181 9A               [ 1]    1 		 rim
      008182 81               [ 4]  342     ret
                                    343     
                                    344 	 ; return character from uart2
      008183                        345 uart_getchar:
      008183 A6 FF            [ 1]  346 	ld a,#255
      008185 C1 00 01         [ 1]  347 	cp a,rx_char
      008188 27 F9            [ 1]  348 	jreq uart_getchar
      00010E                        349 	_no_interrupts
      00818A 9B               [ 1]    1 		sim
      00818B C6 00 01         [ 1]  350 	ld a, rx_char
      00818E 88               [ 1]  351 	push a
      00818F A6 FF            [ 1]  352 	ld a,#-1
      008191 C7 00 01         [ 1]  353 	ld rx_char,a
      000118                        354 	_interrupts
      008194 9A               [ 1]    1 		 rim
      008195 84               [ 1]  355 	pop a
      008196 81               [ 4]  356 	ret
                                    357 
                                    358 	; delete n character from input line
      008197                        359 uart_delete:
      008197 88               [ 1]  360 	push a ; n 
      008198                        361 del_loop:
      008198 0D 01            [ 1]  362 	tnz (1,sp)
      00819A 27 13            [ 1]  363 	jreq 1$
      00819C A6 08            [ 1]  364 	ld a,#BSP
      00819E CD 81 61         [ 4]  365 	call uart_tx
      0081A1 A6 20            [ 1]  366     ld a,#SPACE
      0081A3 CD 81 61         [ 4]  367     call uart_tx
      0081A6 A6 08            [ 1]  368     ld a,#BSP
      0081A8 CD 81 61         [ 4]  369     call uart_tx
      0081AB 0A 01            [ 1]  370     dec (1,sp)
      0081AD 20 E9            [ 2]  371     jra del_loop
      0081AF 84               [ 1]  372 1$: pop a
      0081B0 81               [ 4]  373 	ret 
                                    374 
                                    375 
                                    376     ;lecture d'une ligne de texte
                                    377     ; dans le tib
      0081B1                        378 readln:
                                    379 	; local variables
                           000001   380 	LEN = 1  ; accepted line length
                           000002   381 	RXCHAR = 2 ; last char received
      0081B1 4B 00            [ 1]  382 	push #0  ; RXCHAR 
      0081B3 4B 00            [ 1]  383 	push #0  ; LEN
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 30.
Hexadecimal [24-Bits]



      0081B5 90 AE 00 09      [ 2]  384  	ldw y,#tib ; input buffer
      0081B9                        385 readln_loop:
      0081B9 CD 81 83         [ 4]  386 	call uart_getchar
      0081BC 6B 02            [ 1]  387 	ld (RXCHAR,sp),a
      0081BE A1 03            [ 1]  388 	cp a,#CTRL_C
      0081C0 26 03            [ 1]  389 	jrne 2$
      0081C2 CC 82 3D         [ 2]  390 	jp cancel
      0081C5 A1 12            [ 1]  391 2$:	cp a,#CTRL_R
      0081C7 27 50            [ 1]  392 	jreq reprint
      0081C9 A1 0D            [ 1]  393 	cp a,#CR
      0081CB 26 03            [ 1]  394 	jrne 1$
      0081CD CC 82 47         [ 2]  395 	jp readln_quit
      0081D0 A1 0A            [ 1]  396 1$:	cp a,#NL
      0081D2 27 73            [ 1]  397 	jreq readln_quit
      0081D4 A1 08            [ 1]  398 	cp a,#BSP
      0081D6 27 1B            [ 1]  399 	jreq del_back
      0081D8 A1 04            [ 1]  400 	cp a,#CTRL_D
      0081DA 27 06            [ 1]  401 	jreq del_line
      0081DC A1 20            [ 1]  402 	cp a,#SPACE
      0081DE 2A 24            [ 1]  403 	jrpl accept_char
      0081E0 20 D7            [ 2]  404 	jra readln_loop
      0081E2                        405 del_line:
      0081E2 7B 01            [ 1]  406 	ld a,(LEN,sp)
      0081E4 CD 81 97         [ 4]  407 	call uart_delete
      0081E7 90 AE 00 09      [ 2]  408 	ldw y,#tib
      0081EB 72 5F 00 04      [ 1]  409 	clr count
      0081EF 0F 01            [ 1]  410 	clr (LEN,sp)
      0081F1 20 C6            [ 2]  411 	jra readln_loop
      0081F3                        412 del_back:
      0081F3 0D 01            [ 1]  413     tnz (LEN,sp)
      0081F5 27 C2            [ 1]  414     jreq readln_loop
      0081F7 0A 01            [ 1]  415     dec (LEN,sp)
      0081F9 90 5A            [ 2]  416     decw y
      0081FB 90 7F            [ 1]  417     clr  (y)
      0081FD A6 01            [ 1]  418     ld a,#1
      0081FF CD 81 97         [ 4]  419     call uart_delete
      008202 20 B5            [ 2]  420     jra readln_loop	
      008204                        421 accept_char:
      008204 A6 4F            [ 1]  422 	ld a,#TIB_SIZE-1
      008206 11 01            [ 1]  423 	cp a, (1,sp)
      008208 27 AF            [ 1]  424 	jreq readln_loop
      00820A 7B 02            [ 1]  425 	ld a,(RXCHAR,sp)
      00820C 90 F7            [ 1]  426 	ld (y),a
      00820E 0C 01            [ 1]  427 	inc (LEN,sp)
      008210 90 5C            [ 1]  428 	incw y
      008212 90 7F            [ 1]  429 	clr (y)
      008214 CD 81 61         [ 4]  430 	call uart_tx
      008217 20 A0            [ 2]  431 	jra readln_loop
      008219                        432 reprint:
      008219 0D 01            [ 1]  433 	tnz (LEN,sp)
      00821B 26 9C            [ 1]  434 	jrne readln_loop
      00821D 72 5D 00 04      [ 1]  435 	tnz count
      008221 27 96            [ 1]  436 	jreq readln_loop
      008223 90 AE 00 09      [ 2]  437 	ldw y,#tib
      008227 90 89            [ 2]  438 	pushw y
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 31.
Hexadecimal [24-Bits]



      008229 CD 81 6B         [ 4]  439 	call uart_print
      00822C 90 85            [ 2]  440 	popw y
      00822E C6 00 04         [ 1]  441 	ld a,count
      008231 6B 01            [ 1]  442 	ld (LEN,sp),a
      008233 90 9F            [ 1]  443 	ld a,yl
      008235 CB 00 04         [ 1]  444 	add a,count
      008238 90 97            [ 1]  445 	ld yl,a
      00823A CC 81 B9         [ 2]  446 	jp readln_loop
      00823D                        447 cancel:
      00823D 72 5F 00 09      [ 1]  448 	clr tib
      008241 72 5F 00 04      [ 1]  449 	clr count
      008245 20 05            [ 2]  450 	jra readln_quit2
      008247                        451 readln_quit:
      008247 7B 01            [ 1]  452 	ld a,(LEN,sp)
      008249 C7 00 04         [ 1]  453 	ld count,a
      00824C                        454 readln_quit2:
      00824C 5B 02            [ 2]  455 	addw sp,#2
      00824E A6 0A            [ 1]  456 	ld a,#NL
      008250 CD 81 61         [ 4]  457 	call uart_tx
      008253 81               [ 4]  458 	ret
                                    459 	
                                    460 	; skip character c in tib starting from 'in'
                                    461 	; input: 
                                    462 	;    a character to skip
                                    463 	; output:  'in' ajusted to new position
      008254                        464 skip:
                           000001   465 	C = 1 ; local var
      008254 88               [ 1]  466 	push a
      008255 90 AE 00 09      [ 2]  467 	ldw y,#tib
      008259 91 D6 02         [ 4]  468 1$:	ld a,([in.w],y)
      00825C 27 0A            [ 1]  469 	jreq 2$
      00825E 11 01            [ 1]  470 	cp a,(C,sp)
      008260 26 06            [ 1]  471 	jrne 2$
      008262 72 5C 00 03      [ 1]  472 	inc in
      008266 20 F1            [ 2]  473 	jra 1$
      008268 84               [ 1]  474 2$: pop a
      008269 81               [ 4]  475 	ret
                                    476 	
                                    477 	; scan tib for charater 'c' starting from 'in'
                                    478 	; input:
                                    479 	;    a character to skip
      00826A                        480 scan: 
                           000001   481 	C = 1 ; local var
      00826A 88               [ 1]  482 	push a
      00826B 90 AE 00 09      [ 2]  483 	ldw y,#tib
      00826F 91 D6 02         [ 4]  484 1$:	ld a,([in.w],y)
      008272 27 0A            [ 1]  485 	jreq 2$
      008274 11 01            [ 1]  486 	cp a,(C,sp)
      008276 27 06            [ 1]  487 	jreq 2$
      008278 72 5C 00 03      [ 1]  488 	inc in
      00827C 20 F1            [ 2]  489 	jra 1$
      00827E 84               [ 1]  490 2$: pop a
      00827F 81               [ 4]  491 	ret
                                    492 
                                    493 	; scan tib for next word
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



                                    494 	; move word in 'pad'
      008280                        495 next_word:	
                           000001   496 	FIRST = 1
                           000002   497 	XSAVE = 2
      008280 52 03            [ 2]  498 	sub sp,#3
      008282 1F 02            [ 2]  499 	ldw (XSAVE,sp),x ; save x
      008284 A6 20            [ 1]  500 	ld a,#SPACE
      008286 CD 82 54         [ 4]  501 	call skip
      008289 C6 00 03         [ 1]  502 	ld a,in
      00828C 6B 01            [ 1]  503 	ld (FIRST,sp),a
      00828E A6 20            [ 1]  504 	ld a,#SPACE
      008290 CD 82 6A         [ 4]  505 	call scan
                                    506 	; copy word in pad
      008293 AE 00 09         [ 2]  507 	ldw x,#tib  ; source
      008296 72 5F 00 05      [ 1]  508 	clr idx_x
      00829A 7B 01            [ 1]  509 	ld a,(FIRST,sp)
      00829C C7 00 06         [ 1]  510 	ld idx_x+1,a
      00829F 90 AE 00 59      [ 2]  511 	ldw y,#pad
      0082A3 72 5F 00 07      [ 1]  512 	clr idx_y
      0082A7 72 5F 00 08      [ 1]  513 	clr idx_y+1
      0082AB C6 00 03         [ 1]  514 	ld a,in
      0082AE 10 01            [ 1]  515 	sub a,(FIRST,sp)
      0082B0 CD 82 B8         [ 4]  516 	call strcpyn
      0082B3 1E 02            [ 2]  517 	ldw x,(XSAVE,sp)
      0082B5 5B 03            [ 2]  518 	addw sp,#3
      0082B7 81               [ 4]  519 	ret
                                    520 	
                                    521 	
                                    522 	; copy n character from (x) to (y)
                                    523 	; input:
                                    524 	;   	x   source pointer
                                    525 	;       idx_x index in (x)
                                    526 	;       y   destination pointer
                                    527 	;       idx_y  index in (y)
                                    528 	;       a   number of character to copy
      0082B8                        529 strcpyn:
                           000001   530 	N = 1 ; local variable count
      0082B8 88               [ 1]  531 	push a
      0082B9 7B 01            [ 1]  532 1$: ld a,(N,sp)		
      0082BB 27 13            [ 1]  533 	jreq 2$ 
      0082BD 72 D6 00 05      [ 4]  534 	ld a,([idx_x],x)
      0082C1 91 D7 07         [ 4]  535 	ld ([idx_y],y),a
      0082C4 72 5C 00 06      [ 1]  536 	inc idx_x+1
      0082C8 72 5C 00 08      [ 1]  537 	inc idx_y+1
      0082CC 0A 01            [ 1]  538 	dec (N,sp)
      0082CE 20 E9            [ 2]  539 	jra 1$
      0082D0 91 6F 07         [ 4]  540 2$: clr ([idx_y],y)
      0082D3 84               [ 1]  541 	pop a
      0082D4 81               [ 4]  542 	ret
                                    543 		
                                    544 	; convert integer to string
                                    545 	; input:
                                    546 	;   a  base
                                    547 	;	y  integer to convert
                                    548 	; output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



                                    549 	;   y  pointer to string
      0082D5                        550 itoa:
                           000001   551 	SIGN=1
                           000002   552 	BASE=2
                           000002   553 	LOCAL_SIZE=2
      0082D5 89               [ 2]  554 	pushw x
      0082D6 88               [ 1]  555 	push a  ; base
      0082D7 4B 00            [ 1]  556 	push #0 ; sign
      0082D9 A1 0A            [ 1]  557 	cp a,#10
      0082DB 26 0D            [ 1]  558 	jrne 1$
      0082DD 90 CF 00 A9      [ 2]  559 	ldw acc16,y
      0082E1 72 0F 00 A9 04   [ 2]  560 	btjf acc16,#7,1$
      0082E6 03 01            [ 1]  561 	cpl (SIGN,sp)
      0082E8 90 50            [ 2]  562 	negw y
                                    563 	; initialize string pointer 
      0082EA AE 00 4F         [ 2]  564 1$:	ldw x,#PAD_SIZE-1
      0082ED CF 00 A9         [ 2]  565 	ldw acc16,x
      0082F0 AE 00 59         [ 2]  566 	ldw x,#pad
      0082F3 72 BB 00 A9      [ 2]  567 	addw x,acc16
      0082F7 7F               [ 1]  568 	clr (x)
      0082F8 5A               [ 2]  569 	decw x
      0082F9 A6 20            [ 1]  570 	ld a,#SPACE
      0082FB F7               [ 1]  571 	ld (x),a
      0082FC 72 5F 00 A9      [ 1]  572 	clr acc16
      008300 72 5F 00 AA      [ 1]  573 	clr acc16+1
      008304                        574 itoa_loop:
      008304 7B 02            [ 1]  575     ld a,(BASE,sp)
      008306 90 62            [ 2]  576     div y,a
      008308 AB 30            [ 1]  577     add a,#'0
      00830A A1 3A            [ 1]  578     cp a,#'9+1
      00830C 2B 02            [ 1]  579     jrmi 2$
      00830E AB 07            [ 1]  580     add a,#7 
      008310 5A               [ 2]  581 2$: decw x
      008311 F7               [ 1]  582     ld (x),a
      008312 90 C3 00 A9      [ 2]  583     cpw y,acc16
      008316 26 EC            [ 1]  584     jrne itoa_loop
                                    585 	; copy string pointer in y
      008318 CF 00 A9         [ 2]  586     ldw acc16,x
      00831B 90 CE 00 A9      [ 2]  587     ldw y,acc16
      00831F 7B 02            [ 1]  588 	ld a,(BASE,sp)
      008321 A1 10            [ 1]  589 	cp a,#16
      008323 26 1B            [ 1]  590 	jrne 9$
      008325 CD 83 FC         [ 4]  591     call strlen
      008328 A1 03            [ 1]  592     cp a,#3
      00832A 27 0C            [ 1]  593     jreq 8$
      00832C 25 04            [ 1]  594     jrult 7$
      00832E A1 05            [ 1]  595 	cp a,#5
      008330 27 06            [ 1]  596 	jreq 8$
      008332 90 5A            [ 2]  597 7$: decw y
      008334 A6 30            [ 1]  598     ld a,#'0
      008336 90 F7            [ 1]  599     ld (y),a
      008338 90 5A            [ 2]  600 8$:	decw y
      00833A A6 24            [ 1]  601 	ld a,#'$
      00833C 90 F7            [ 1]  602 	ld (y),a
      00833E 20 0A            [ 2]  603 	jra 10$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



      008340 7B 01            [ 1]  604 9$: ld a,(SIGN,sp)
      008342 27 06            [ 1]  605     jreq 10$
      008344 90 5A            [ 2]  606     decw y
      008346 A6 2D            [ 1]  607     ld a,#'-
      008348 90 F7            [ 1]  608     ld (y),a
      00834A                        609 10$:
      00834A 5B 02            [ 2]  610 	addw sp,#LOCAL_SIZE
      00834C 85               [ 2]  611 	popw x
      00834D 81               [ 4]  612 	ret
                                    613 
                                    614 	;multiply Y=A*Y	
                                    615 	; input:
                                    616 	;    Y uint16_t
                                    617 	;    A uint8_t
                                    618 	; output:
                                    619 	;   Y uint16_t product modulo 65535
      00834E                        620 mul16x8:
      00834E 89               [ 2]  621 	pushw x ; save x
      00834F CE 00 A9         [ 2]  622 	ldw x, acc16 ; save it
      008352 89               [ 2]  623 	pushw x
      008353 93               [ 1]  624 	ldw x,y
      008354 42               [ 4]  625 	mul x,a ; a*yl
      008355 CF 00 A9         [ 2]  626 	ldw acc16,x
      008358 90 5E            [ 1]  627 	swapw y
      00835A 90 42            [ 4]  628 	mul y,a ; a*yh
                                    629 	; y*=256
      00835C 90 5E            [ 1]  630 	swapw y
      00835E 4F               [ 1]  631 	clr a
      00835F 90 97            [ 1]  632 	ld yl,a
      008361 72 B9 00 A9      [ 2]  633 	addw y,acc16
      008365 85               [ 2]  634 	popw x ; restore acc16
      008366 CF 00 A9         [ 2]  635 	ldw acc16,x
      008369 85               [ 2]  636 	popw x ; restore x
      00836A 81               [ 4]  637 	ret
                                    638 
                                    639 	; check if character in {'0'..'9'}
                                    640 	; input:
                                    641 	;    a  character to test
                                    642 	; output:
                                    643 	;    a  0|1
      00836B                        644 is_digit:
      00836B A1 30            [ 1]  645 	cp a,#'0
      00836D 2A 02            [ 1]  646 	jrpl 1$
      00836F 4F               [ 1]  647 0$:	clr a
      008370 81               [ 4]  648 	ret
      008371 A1 39            [ 1]  649 1$: cp a,#'9
      008373 22 FA            [ 1]  650     jrugt 0$
      008375 A6 01            [ 1]  651     ld a,#1
      008377 81               [ 4]  652     ret
                                    653 	
                                    654 	; check if character in {'0'..'9','A'..'F'}
                                    655 	; input:
                                    656 	;   a  character to test
                                    657 	; output:
                                    658 	;   a   0|1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



      008378                        659 is_hex:
      008378 88               [ 1]  660 	push a
      008379 CD 83 6B         [ 4]  661 	call is_digit
      00837C A1 01            [ 1]  662 	cp a,#1
      00837E 26 03            [ 1]  663 	jrne 1$
      008380 5B 01            [ 2]  664 	addw sp,#1
      008382 81               [ 4]  665 	ret
      008383 84               [ 1]  666 1$:	pop a
      008384 A1 61            [ 1]  667 	cp a,#'a
      008386 2B 02            [ 1]  668 	jrmi 2$
      008388 A0 20            [ 1]  669 	sub a,#32
      00838A A1 41            [ 1]  670 2$: cp a,#'A
      00838C 2A 02            [ 1]  671     jrpl 3$
      00838E 4F               [ 1]  672 0$: clr a
      00838F 81               [ 4]  673     ret
      008390 A1 46            [ 1]  674 3$: cp a,#'F
      008392 22 FA            [ 1]  675     jrugt 0$
      008394 A6 01            [ 1]  676     ld a,#1
      008396 81               [ 4]  677     ret
                                    678             	
                                    679 	; convert alpha to uppercase
                                    680 	; input:
                                    681 	;    a  character to convert
                                    682 	; output:
                                    683 	;    a  uppercase character
      008397                        684 a_upper:
      008397 A1 61            [ 1]  685 	cp a,#'a
      008399 2A 01            [ 1]  686 	jrpl 1$
      00839B 81               [ 4]  687 0$:	ret
      00839C A1 7A            [ 1]  688 1$: cp a,#'z	
      00839E 22 FB            [ 1]  689 	jrugt 0$
      0083A0 A0 20            [ 1]  690 	sub a,#32
      0083A2 81               [ 4]  691 	ret
                                    692 	
                                    693 	; convert pad content in integer
                                    694 	; input:
                                    695 	;    pad
                                    696 	; output:
                                    697 	;    y
      0083A3                        698 atoi:
                                    699 	; local variables
                           000001   700 	SIGN=1 ; 1 byte, 
                           000002   701 	BASE=2 ; 1 byte, numeric base used in conversion
                           000003   702 	TEMP=3 ; 1 byte, temporary storage
                           000003   703 	LOCAL_SIZE=3 ; 3 bytes reserved for local storage
      0083A3 89               [ 2]  704 	pushw x ;save x
      0083A4 52 03            [ 2]  705 	sub sp,#LOCAL_SIZE
      0083A6 0F 01            [ 1]  706 	clr (SIGN,sp)
      0083A8 A6 0A            [ 1]  707 	ld a,#10
      0083AA 6B 02            [ 1]  708 	ld (BASE,sp),a ; default base decimal
      0083AC AE 00 59         [ 2]  709 	ldw x,#pad ; pointer to string to convert
      0083AF 90 5F            [ 1]  710 	clrw y    ; convertion result
      0083B1 F6               [ 1]  711 	ld a,(x)
      0083B2 27 3E            [ 1]  712 	jreq 9$
      0083B4 A1 2D            [ 1]  713 	cp a,#'-
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



      0083B6 26 04            [ 1]  714 	jrne 1$
      0083B8 03 01            [ 1]  715 	cpl (SIGN,sp)
      0083BA 20 08            [ 2]  716 	jra 2$
      0083BC A1 24            [ 1]  717 1$: cp a,#'$
      0083BE 26 06            [ 1]  718 	jrne 3$
      0083C0 A6 10            [ 1]  719 	ld a,#16
      0083C2 6B 02            [ 1]  720 	ld (BASE,sp),a
      0083C4 5C               [ 1]  721 2$:	incw x
      0083C5 F6               [ 1]  722 	ld a,(x)
      0083C6                        723 3$:	
      0083C6 A1 61            [ 1]  724 	cp a,#'a
      0083C8 2B 02            [ 1]  725 	jrmi 4$
      0083CA A0 20            [ 1]  726 	sub a,#32
      0083CC A1 30            [ 1]  727 4$:	cp a,#'0
      0083CE 2B 22            [ 1]  728 	jrmi 9$
      0083D0 A0 30            [ 1]  729 	sub a,#'0
      0083D2 A1 0A            [ 1]  730 	cp a,#10
      0083D4 2B 06            [ 1]  731 	jrmi 5$
      0083D6 A0 07            [ 1]  732 	sub a,#7
      0083D8 11 02            [ 1]  733 	cp a,(BASE,sp)
      0083DA 2A 16            [ 1]  734 	jrpl 9$
      0083DC 6B 03            [ 1]  735 5$:	ld (TEMP,sp),a
      0083DE 7B 02            [ 1]  736 	ld a,(BASE,sp)
      0083E0 CD 83 4E         [ 4]  737 	call mul16x8
      0083E3 7B 03            [ 1]  738 	ld a,(TEMP,sp)
      0083E5 C7 00 AA         [ 1]  739 	ld acc16+1,a
      0083E8 72 5F 00 A9      [ 1]  740 	clr acc16
      0083EC 72 B9 00 A9      [ 2]  741 	addw y,acc16
      0083F0 20 D2            [ 2]  742 	jra 2$
      0083F2 0D 01            [ 1]  743 9$:	tnz (SIGN,sp)
      0083F4 27 02            [ 1]  744     jreq 11$
      0083F6 90 50            [ 2]  745     negw y
      0083F8 5B 03            [ 2]  746 11$: addw sp,#LOCAL_SIZE
      0083FA 85               [ 2]  747 	popw x ; restore x
      0083FB 81               [ 4]  748 	ret
                                    749 
                                    750 	;strlen  return ASCIIZ string length
                                    751 	; input:
                                    752 	;	y  pointer to string
                                    753 	; output:
                                    754 	;	a   length  < 256
      0083FC                        755 strlen:
                           000001   756 	LEN=1
      0083FC 90 89            [ 2]  757     pushw y
      0083FE 4B 00            [ 1]  758     push #0
      008400 90 F6            [ 1]  759 0$: ld a,(y)
      008402 27 06            [ 1]  760     jreq 1$
      008404 0C 01            [ 1]  761     inc (LEN,sp)
      008406 90 5C            [ 1]  762     incw y
      008408 20 F6            [ 2]  763     jra 0$
      00840A 84               [ 1]  764 1$: pop a
      00840B 90 85            [ 2]  765     popw y
      00840D 81               [ 4]  766     ret
                                    767 	
                                    768 	; peek addr, print byte at this address 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 37.
Hexadecimal [24-Bits]



                                    769 	; input:
                                    770 	;	 y   address to peek
                                    771 	;    a   numeric base for convertion
                                    772 	; output:
                                    773 	;    print byte value at this address
      00840E                        774 peek:
      00840E 90 89            [ 2]  775 	pushw y
      008410 88               [ 1]  776     push a
      008411 90 F6            [ 1]  777     ld a,(y)
      008413 90 97            [ 1]  778     ld yl,a
      008415 4F               [ 1]  779     clr a
      008416 90 95            [ 1]  780     ld yh,a
      008418 84               [ 1]  781     pop a
      008419 CD 82 D5         [ 4]  782     call itoa
      00841C CD 81 6B         [ 4]  783     call uart_print
      00841F 90 85            [ 2]  784     popw y
      008421 81               [ 4]  785     ret	
                                    786 	
                                    787 	; get a number from command line next argument
                                    788 	;  input:
                                    789 	;	  none
                                    790 	;  output:
                                    791 	;    y   uint16_t 
      008422                        792 number:
      008422 CD 82 80         [ 4]  793 	call next_word
      008425 CD 83 A3         [ 4]  794 	call atoi
      008428 81               [ 4]  795 	ret
                                    796 	
                                    797 	; write a byte in memory
                                    798 	; input:
                                    799 	;    a  byte to write
                                    800 	;    y  address 
                                    801 	; output:
                                    802 	;    none
      008429                        803 write_byte:
      008429 90 A3 80 00      [ 2]  804     cpw y,#FLASH_BASE
      00842D 2A 2E            [ 1]  805     jrpl write_flash
      00842F 90 A3 40 00      [ 2]  806     cpw y,#EEPROM_BASE
      008433 2B 06            [ 1]  807 	jrmi 1$
      008435 90 A3 48 80      [ 2]  808 	cpw y,#OPTION_END+1  
      008439 2B 44            [ 1]  809     jrmi write_eeprom
      00843B 90 C3 00 AB      [ 2]  810 1$: cpw y,ram_free_base
      00843F 2A 01            [ 1]  811     jrpl 2$
      008441 81               [ 4]  812     ret
      008442 90 A3 18 00      [ 2]  813 2$: cpw y,#STACK_TOP+1
      008446 2B 03            [ 1]  814     jrmi 3$
      008448 CC 84 4E         [ 2]  815     jp write_sfr    
      00844B 90 F7            [ 1]  816 3$: ld (y),a
      00844D 81               [ 4]  817 	ret
                                    818 	; write SFR
      00844E                        819 write_sfr:
      00844E 90 A3 50 00      [ 2]  820 	cpw y,#SFR_BASE
      008452 2B 08            [ 1]  821 	jrmi 2$
      008454 90 A3 58 00      [ 2]  822 	cpw y,#SFR_END+1
      008458 2A 02            [ 1]  823 	jrpl 2$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



      00845A 90 F7            [ 1]  824 	ld (y),a
      00845C 81               [ 4]  825 2$:	ret
                                    826 	; write program memory
      00845D                        827 write_flash:
      00845D 90 C3 00 AD      [ 2]  828 	cpw y,flash_free_base
      008461 2A 01            [ 1]  829 	jrpl 0$
      008463 81               [ 4]  830 	ret
      008464 35 56 50 62      [ 1]  831 0$:	mov FLASH_PUKR,#FLASH_PUKR_KEY1
      008468 35 AE 50 62      [ 1]  832 	mov FLASH_PUKR,#FLASH_PUKR_KEY2
      00846C 72 03 50 5F FB   [ 2]  833 	btjf FLASH_IAPSR,#FLASH_IAPSR_PUL,.
      0003F5                        834 1$:	_no_interrupts
      008471 9B               [ 1]    1 		sim
      008472 90 F7            [ 1]  835 	ld (y),a
      008474 72 05 50 5F FB   [ 2]  836 	btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
      0003FD                        837     _interrupts
      008479 9A               [ 1]    1 		 rim
      00847A 72 13 50 5F      [ 1]  838     bres FLASH_IAPSR,#FLASH_IAPSR_PUL
      00847E 81               [ 4]  839     ret
                                    840     ; write eeprom and option
      00847F                        841 write_eeprom:
                           000002   842 	OPT=2
                           000001   843 	BYTE=1
                           000002   844 	LOCAL_SIZE=2
      00847F 4B 00            [ 1]  845 	push #0
      008481 88               [ 1]  846 	push a
                                    847 	; check for data eeprom or option eeprom
      008482 90 A3 48 00      [ 2]  848 	cpw y,#OPTION_BASE
      008486 2B 08            [ 1]  849 	jrmi 1$
      008488 90 A3 48 80      [ 2]  850 	cpw y,#OPTION_END+1
      00848C 2A 02            [ 1]  851 	jrpl 1$
      00848E 03 02            [ 1]  852 	cpl (OPT,sp)
      008490 35 AE 50 64      [ 1]  853 1$: mov FLASH_DUKR,#FLASH_DUKR_KEY1
      008494 35 56 50 64      [ 1]  854     mov FLASH_DUKR,#FLASH_DUKR_KEY2
      008498 7B 02            [ 1]  855     ld a,(OPT,sp)
      00849A 27 08            [ 1]  856     jreq 2$
      00849C 72 1E 50 5B      [ 1]  857     bset FLASH_CR2,#FLASH_CR2_OPT
      0084A0 72 1F 50 5C      [ 1]  858     bres FLASH_NCR2,#FLASH_CR2_OPT 
      0084A4 72 07 50 5F FB   [ 2]  859 2$: btjf FLASH_IAPSR,#FLASH_IAPSR_DUL,.
      0084A9 7B 01            [ 1]  860     ld a,(BYTE,sp)
      0084AB 90 F7            [ 1]  861     ld (y),a
      0084AD 90 5C            [ 1]  862     incw y
      0084AF 7B 02            [ 1]  863     ld a,(OPT,sp)
      0084B1 27 05            [ 1]  864     jreq 3$
      0084B3 7B 01            [ 1]  865     ld a,(BYTE,sp)
      0084B5 43               [ 1]  866     cpl a
      0084B6 90 F7            [ 1]  867     ld (y),a
      0084B8 72 05 50 5F FB   [ 2]  868 3$: btjf FLASH_IAPSR,#FLASH_IAPSR_EOP,.
      0084BD 5B 02            [ 2]  869 	addw sp,#LOCAL_SIZE
      0084BF 81               [ 4]  870     ret
                                    871         
                                    872 		  
                                    873 	; evaluate command string in tib
                                    874 	; list of commands
                                    875 	;   @  addr display content at address
                                    876 	;   !  addr byte [byte ]* store bytes at address
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



                                    877 	;   ?  diplay command help
                                    878 	;   b  n    convert n in the other base
                                    879 	;	c  addr bitmask  clear  bits at address
                                    880 	;   h  addr hex dump memory starting at address
                                    881 	;   m  src dest count,  move memory block
                                    882 	;   r  reset MCU
                                    883 	;   s  addr bitmask  set a bits at address
                                    884 	;   t  addr bitmask  toggle bits at address
                                    885 	;   x  addr execute  code at address  
      0084C0                        886 eval:
      0084C0 C6 00 03         [ 1]  887 	ld a, in
      0084C3 C1 00 04         [ 1]  888 	cp a, count
      0084C6 26 01            [ 1]  889 	jrne 0$
      0084C8 81               [ 4]  890 	ret ; nothing to evaluate
      0084C9 CD 82 80         [ 4]  891 0$:	call next_word
      0084CC 90 AE 00 59      [ 2]  892 	ldw y,#pad
      0084D0 90 F6            [ 1]  893     ld a,(y)	
      0084D2 A1 40            [ 1]  894 	cp a,#'@
      0084D4 26 03            [ 1]  895 	jrne 1$
      0084D6 CC 85 2A         [ 2]  896 	jp fetch
      0084D9 A1 21            [ 1]  897 1$:	cp a,#'!
      0084DB 26 03            [ 1]  898 	jrne 10$
      0084DD CC 85 4E         [ 2]  899 	jp store
      0084E0                        900 10$:
      0084E0 A1 3F            [ 1]  901 	cp a,#'?
      0084E2 26 03            [ 1]  902 	jrne 15$
      0084E4 CC 85 70         [ 2]  903 	jp help
      0084E7                        904 15$: 
      0084E7 A1 62            [ 1]  905 	cp a,#'b
      0084E9 26 03            [ 1]  906     jrne 2$
      0084EB CC 85 78         [ 2]  907     jp base_convert	
      0084EE A1 63            [ 1]  908 2$:	cp a,#'c
      0084F0 26 03            [ 1]  909 	jrne 3$
      0084F2 CC 85 8F         [ 2]  910 	jp clear_bits
      0084F5 A1 68            [ 1]  911 3$:	cp a,#'h
      0084F7 26 03            [ 1]  912 	jrne 4$
      0084F9 CC 85 A1         [ 2]  913 	jp hexdump
      0084FC A1 6D            [ 1]  914 4$:	cp a,#'m
      0084FE 26 03            [ 1]  915 	jrne 5$
      008500 CC 85 FC         [ 2]  916 	jp move_memory
      008503 A1 72            [ 1]  917 5$: cp a,#'r
      008505 26 03            [ 1]  918     jrne 6$
      008507 CD 81 4A         [ 4]  919 	call NonHandledInterrupt	
      00850A A1 73            [ 1]  920 6$:	cp a,#'s
      00850C 26 03            [ 1]  921 	jrne 7$
      00850E CC 86 29         [ 2]  922 	jp set_bits
      008511 A1 74            [ 1]  923 7$:	cp a,#'t
      008513 26 03            [ 1]  924 	jrne 8$
      008515 CC 86 3A         [ 2]  925 	jp toggle_bits
      008518 A1 78            [ 1]  926 8$:	cp a,#'x
      00851A 26 03            [ 1]  927 	jrne 9$
      00851C CC 86 4B         [ 2]  928 	jp execute
      00851F CD 81 6B         [ 4]  929 9$:	call uart_print
      008522 90 AE 87 1B      [ 2]  930 	ldw y,#BAD_CMD
      008526 CD 81 6B         [ 4]  931 	call uart_print
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



      008529 81               [ 4]  932 	ret
                                    933 	
                                    934 	; fetch a byte and display it,  @  addr
      00852A                        935 fetch:
      00852A CD 84 22         [ 4]  936 	call number 
      00852D 90 89            [ 2]  937 	pushw y
      00852F 90 AE 00 59      [ 2]  938 	ldw y,#pad
      008533 CD 81 6B         [ 4]  939 	call uart_print
      008536 A6 3D            [ 1]  940 	ld a,#'=
      008538 CD 81 61         [ 4]  941 	call uart_tx	
      00853B 90 85            [ 2]  942 	popw y
      00853D C6 00 59         [ 1]  943 	ld a,pad
      008540 A1 24            [ 1]  944 	cp a,#'$
      008542 27 04            [ 1]  945 	jreq 1$
      008544 A6 0A            [ 1]  946 	ld a,#10
      008546 20 02            [ 2]  947 	jra 2$
      008548 A6 10            [ 1]  948 1$: ld a,#16	
      00854A CD 84 0E         [ 4]  949 2$:	call peek
      00854D 81               [ 4]  950 	ret
                                    951 	
                                    952 	; store bytes,   !  addr byte [byte ]*
      00854E                        953 store:
                           000001   954 	MADDR=1
      00854E CD 84 22         [ 4]  955 	call number
      008551 90 89            [ 2]  956 	pushw y
      008553 CD 84 22         [ 4]  957 1$:	call number
      008556 90 9F            [ 1]  958 	ld a,yl
      008558 16 01            [ 2]  959 	ldw y,(MADDR,sp)
      00855A CD 84 29         [ 4]  960 	call write_byte
      00855D C6 00 03         [ 1]  961 	ld a,in
      008560 C1 00 04         [ 1]  962 	cp a,count
      008563 27 08            [ 1]  963 	jreq 2$
      008565 16 01            [ 2]  964 	ldw y,(MADDR,sp)
      008567 90 5C            [ 1]  965 	incw y
      008569 17 01            [ 2]  966 	ldw (MADDR,sp),y
      00856B 20 E6            [ 2]  967 	jra 1$
      00856D 90 85            [ 2]  968 2$:	popw y
      00856F 81               [ 4]  969 	ret
                                    970 	; ? , display command information
      008570                        971 help:
      008570 90 AE 87 2E      [ 2]  972 	ldw y, #HELP
      008574 CD 81 6B         [ 4]  973 	call uart_print
      008577 81               [ 4]  974 	ret
                                    975 	; convert from one numeric base to the other
                                    976 	;  b n|$n
      008578                        977 base_convert:
      008578 CD 84 22         [ 4]  978     call number
      00857B C6 00 59         [ 1]  979     ld a,pad
      00857E A1 24            [ 1]  980     cp a,#'$
      008580 26 04            [ 1]  981     jrne 1$
      008582 A6 0A            [ 1]  982     ld a,#10
      008584 20 02            [ 2]  983     jra 2$
      008586 A6 10            [ 1]  984 1$: ld a,#16
      008588 CD 82 D5         [ 4]  985 2$: call itoa
      00858B CD 81 6B         [ 4]  986     call uart_print
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



      00858E 81               [ 4]  987     ret
                                    988         	
                                    989 	; clear bitmask, c addr mask
      00858F                        990 clear_bits:
      00858F CD 84 22         [ 4]  991 	call number
      008592 90 89            [ 2]  992 	pushw y
      008594 CD 84 22         [ 4]  993 	call number
      008597 90 9F            [ 1]  994 	ld a,yl
      008599 43               [ 1]  995 	cpl a
      00859A 90 85            [ 2]  996 	popw y
      00859C 90 F4            [ 1]  997 	and a,(y)
      00859E 90 F7            [ 1]  998 	ld (y),a
      0085A0 81               [ 4]  999     ret
                                   1000     
                                   1001     ; hexadecimal dump memory, h addr
                                   1002     ; stop after each row, SPACE continue, other stop
      0085A1                       1003 hexdump: 
                           000001  1004 	MADDR = 1
                           000003  1005 	CNTR = 3 ; loop counter
                           000003  1006 	LOCAL_SIZE=3
      0085A1 52 03            [ 2] 1007 	sub sp,#LOCAL_SIZE
      0085A3 CD 84 22         [ 4] 1008 	call number
      0085A6 17 01            [ 2] 1009     ldw (MADDR,sp),y ; save address
      0085A8                       1010 row_init:
      0085A8 AE 00 59         [ 2] 1011 	ldw x,#pad
      0085AB A6 10            [ 1] 1012 	ld a,#16
      0085AD CD 82 D5         [ 4] 1013 	call itoa
      0085B0 CD 81 6B         [ 4] 1014 	call uart_print
      0085B3 A6 20            [ 1] 1015 	ld a,#SPACE
      0085B5 CD 81 61         [ 4] 1016 	call uart_tx
      0085B8 A6 08            [ 1] 1017     ld a,#8
      0085BA 6B 03            [ 1] 1018     ld (CNTR,sp),a
      0085BC                       1019 row:
      0085BC A6 10            [ 1] 1020 	ld a,#16
      0085BE 16 01            [ 2] 1021 	ldw y,(MADDR,sp)
      0085C0 CD 84 0E         [ 4] 1022 	call peek
      0085C3 90 F6            [ 1] 1023 	ld a,(y)
      0085C5 A1 20            [ 1] 1024 	cp a,#SPACE
      0085C7 2A 02            [ 1] 1025 	jrpl 1$
      0085C9 A6 20            [ 1] 1026 	ld a,#SPACE
      0085CB A1 80            [ 1] 1027 1$:	cp a,#128
      0085CD 2B 02            [ 1] 1028     jrmi 2$
      0085CF A6 20            [ 1] 1029     ld a,#SPACE
      0085D1 F7               [ 1] 1030 2$: ld (x),a
      0085D2 5C               [ 1] 1031 	incw x
      0085D3 90 5C            [ 1] 1032 	incw y
      0085D5 17 01            [ 2] 1033 	ldw (MADDR,sp),y
      0085D7 0A 03            [ 1] 1034 	dec (CNTR,sp)
      0085D9 26 E1            [ 1] 1035 	jrne row
      0085DB A6 20            [ 1] 1036 	ld a,#SPACE
      0085DD CD 81 61         [ 4] 1037 	call uart_tx
      0085E0 4F               [ 1] 1038 	clr a
      0085E1 F7               [ 1] 1039 	ld (x),a
      0085E2 90 89            [ 2] 1040 	pushw y
      0085E4 90 AE 00 59      [ 2] 1041 	ldw y,#pad
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      0085E8 CD 81 6B         [ 4] 1042 	call uart_print
      0085EB 90 85            [ 2] 1043 	popw y
      0085ED A6 0A            [ 1] 1044 	ld a,#NL
      0085EF CD 81 61         [ 4] 1045 	call uart_tx
      0085F2 CD 81 83         [ 4] 1046 	call uart_getchar
      0085F5 A1 20            [ 1] 1047 	cp a,#SPACE
      0085F7 27 AF            [ 1] 1048 	jreq row_init
      0085F9 5B 03            [ 2] 1049     addw sp,#LOCAL_SIZE
      0085FB 81               [ 4] 1050     ret
                                   1051     
                                   1052     ; move memory block, m src dest count
      0085FC                       1053 move_memory:
                           000003  1054     SRC=3
                           000001  1055     DEST=1
                           000004  1056     LOCAL_SIZE=4    
      0085FC CD 84 22         [ 4] 1057     call number
      0085FF 90 89            [ 2] 1058     pushw y  ; source
      008601 CD 84 22         [ 4] 1059     call number
      008604 90 89            [ 2] 1060     pushw y  ; destination
      008606 CD 84 22         [ 4] 1061     call number 
      008609 90 CF 00 A9      [ 2] 1062     ldw acc16,y ; counter
      00860D 1E 03            [ 2] 1063     ldw x,(SRC,sp)  ; source
      00860F                       1064 move_loop:
      00860F 16 01            [ 2] 1065     ldw y,(DEST,sp)  ; destination
      008611 F6               [ 1] 1066     ld a,(x)
      008612 CD 84 29         [ 4] 1067     call write_byte
      008615 5C               [ 1] 1068     incw x
      008616 90 5C            [ 1] 1069     incw y
      008618 17 01            [ 2] 1070     ldw (DEST,sp),y
      00861A 90 CE 00 A9      [ 2] 1071     ldw y,acc16
      00861E 90 5A            [ 2] 1072     decw y
      008620 90 CF 00 A9      [ 2] 1073     ldw acc16,y
      008624 26 E9            [ 1] 1074     jrne move_loop
      008626 5B 04            [ 2] 1075     addw sp,#LOCAL_SIZE
      008628 81               [ 4] 1076     ret
                                   1077     
                                   1078     ; clear bitmask,  c addr mask
      008629                       1079 set_bits:
      008629 CD 84 22         [ 4] 1080 	call number
      00862C 90 89            [ 2] 1081 	pushw y
      00862E CD 84 22         [ 4] 1082 	call number
      008631 90 9F            [ 1] 1083 	ld a,yl
      008633 90 85            [ 2] 1084 	popw y
      008635 90 FA            [ 1] 1085 	or a,(y)
      008637 90 F7            [ 1] 1086 	ld (y),a
      008639 81               [ 4] 1087     ret
                                   1088     
                                   1089     ; toggle bitmask,  t addr mask
      00863A                       1090 toggle_bits:
      00863A CD 84 22         [ 4] 1091 	call number
      00863D 90 89            [ 2] 1092     pushw y
      00863F CD 84 22         [ 4] 1093     call number
      008642 90 9F            [ 1] 1094     ld a,yl
      008644 90 85            [ 2] 1095     popw y
      008646 90 F8            [ 1] 1096     xor a,(y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      008648 90 F7            [ 1] 1097     ld (y),a
      00864A 81               [ 4] 1098     ret
                                   1099     
                                   1100     ; execute binary code,   x addr
      00864B                       1101 execute:
      00864B CD 84 22         [ 4] 1102 	call number
      00864E 90 FC            [ 2] 1103 	jp (y)
                                   1104 	
                                   1105 
                                   1106 	
                                   1107 ;------------------------
                                   1108 ;  run time CONSTANTS
                                   1109 ;------------------------	
      008650 4D 4F 4E 41 20 56 45  1110 VERSION:	.asciz "MONA VERSION 0.1\nstm8s208rb     memory map\n---------------------------\n"
             52 53 49 4F 4E 20 30
             2E 31 0A 73 74 6D 38
             73 32 30 38 72 62 20
             20 20 20 20 6D 65 6D
             6F 72 79 20 6D 61 70
             0A 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             0A 00
      008698 72 61 6D 20 66 72 65  1111 RAM_FREE_MSG: .asciz "ram free: "
             65 3A 20 00
      0086A3 2D 20 24 31 36 46 46  1112 RAM_LAST_FREE_MSG: .asciz "- $16FF\n"
             0A 00
      0086AC 66 72 65 65 20 66 6C  1113 FLASH_FREE_MSG: .asciz "free flash: "
             61 73 68 3A 20 00
      0086B9 20 2D 20 24 32 37 46  1114 EEPROM_MSG: .ascii " - $27FFF\n"
             46 46 0A
      0086C3 65 65 70 72 6F 6D 3A  1115             .ascii "eeprom: $4000 - $47ff\n"
             20 24 34 30 30 30 20
             2D 20 24 34 37 66 66
             0A
      0086D9 6F 70 74 69 6F 6E 3A  1116             .ascii "option: $4800 - $487f\n"
             20 24 34 38 30 30 20
             2D 20 24 34 38 37 66
             0A
      0086EF 53 46 52 3A 20 24 35  1117             .ascii "SFR: $5000 - $57FF\n"
             30 30 30 20 2D 20 24
             35 37 46 46 0A
      008702 62 6F 6F 74 20 52 4F  1118             .asciz "boot ROM: $6000 - $67FF\n"
             4D 3A 20 24 36 30 30
             30 20 2D 20 24 36 37
             46 46 0A 00
      00871B 20 69 73 20 6E 6F 74  1119 BAD_CMD:    .asciz " is not a command\n"	
             20 61 20 63 6F 6D 6D
             61 6E 64 0A 00
      00872E 63 6F 6D 6D 61 6E 64  1120 HELP: .ascii "commands:\n"
             73 3A 0A
      008738 40 20 61 64 64 72 2C  1121 	  .ascii "@ addr, display content at address\n"
             20 64 69 73 70 6C 61
             79 20 63 6F 6E 74 65
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal  6E-Bits]



             6E 74 20 61 74 20 61
             64 64 72 65 73 73 0A
      00874E 74 20 61 74 20 61 64  1122 	  .ascii "! addr byte [byte ]*, store bytes at addr++\n"
             64 72 65 73 73 0A 21
             20 61 64 64 72 20 62
             79 74 65 20 5B 62 79
             74 65 20 5D 2A 2C 20
             73 74 6F 72 65 20 62
             79 74
      00877A 65 73 20 61 74 20 61  1123 	  .ascii "?, diplay command help\n"
             64 64 72 2B 2B 0A 3F
             2C 20 64 69 70 6C 61
             79 20
      008791 63 6F 6D 6D 61 6E 64  1124 	  .ascii "b n|$n, convert n in the other base\n"
             20 68 65 6C 70 0A 62
             20 6E 7C 24 6E 2C 20
             63 6F 6E 76 65 72 74
             20 6E 20 69 6E 20 74
             68
      0087B5 65 20 6F 74 68 65 72  1125 	  .ascii "c addr bitmask, clear bits at address\n"
             20 62 61 73 65 0A 63
             20 61 64 64 72 20 62
             69 74 6D 61 73 6B 2C
             20 63 6C 65 61 72 20
             62 69 74
      0087DB 73 20 61 74 20 61 64  1126 	  .ascii "h addr, hex dump memory starting at address\n"
             64 72 65 73 73 0A 68
             20 61 64 64 72 2C 20
             68 65 78 20 64 75 6D
             70 20 6D 65 6D 6F 72
             79 20 73 74 61 72 74
             69 6E
      008807 67 20 61 74 20 61 64  1127 	  .ascii "m src dest count, move memory block\n"
             64 72 65 73 73 0A 6D
             20 73 72 63 20 64 65
             73 74 20 63 6F 75 6E
             74 2C 20 6D 6F 76 65
             20
      00882B 6D 65 6D 6F 72 79 20  1128 	  .ascii "r reset MCU\n"
             62 6C 6F 63 6B
      008837 0A 72 20 72 65 73 65  1129 	  .ascii "s addr bitmask, set bits at address\n"
             74 20 4D 43 55 0A 73
             20 61 64 64 72 20 62
             69 74 6D 61 73 6B 2C
             20 73 65 74 20 62 69
             74
      00885B 73 20 61 74 20 61 64  1130 	  .ascii "t addr bitmask, toggle bits at address\n"
             64 72 65 73 73 0A 74
             20 61 64 64 72 20 62
             69 74 6D 61 73 6B 2C
             20 74 6F 67 67 6C 65
             20 62 69 74
      008882 73 20 61 74 20 61 64  1131 	  .asciz "x addr, execute  code at address\n"
             64 72 65 73 73 0A 78
             20 61 64 64 72 2C 20
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal  65-Bits]



             20 61 74 20 61 64 64
             72 65 73 73 0A 00
                                   1132 
      000835                       1133 flash_free:
                                   1134 	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
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
    B921600 =  000009     |     B9600   =  000002     |   7 BAD_CMD    00069F R
    BASE    =  000002     |     BEEP_BIT=  000004     |     BEEP_CSR=  0050F3 
    BEEP_MAS=  000010     |     BEEP_POR=  00000F     |     BIT0    =  000000 
    BIT1    =  000001     |     BIT2    =  000002     |     BIT3    =  000003 
    BIT4    =  000004     |     BIT5    =  000005     |     BIT6    =  000006 
    BIT7    =  000007     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BSP     =  000008     |     BTN1_BIT=  000004     |     BTN1_MAS=  000010 
    BTN1_POR=  005014     |     BYTE    =  000001     |     C       =  000001 
    CAN_DGR =  005426     |     CAN_FPSR=  005427     |     CAN_IER =  005425 
    CAN_MCR =  005420     |     CAN_MSR =  005421     |     CAN_P0  =  005428 
    CAN_P1  =  005429     |     CAN_P2  =  00542A     |     CAN_P3  =  00542B 
    CAN_P4  =  00542C     |     CAN_P5  =  00542D     |     CAN_P6  =  00542E 
    CAN_P7  =  00542F     |     CAN_P8  =  005430     |     CAN_P9  =  005431 
    CAN_PA  =  005432     |     CAN_PB  =  005433     |     CAN_PC  =  005434 
    CAN_PD  =  005435     |     CAN_PE  =  005436     |     CAN_PF  =  005437 
    CAN_RFR =  005424     |     CAN_TPR =  005423     |     CAN_TSR =  005422 
    CFG_GCR =  007F60     |     CLKOPT  =  004807     |     CLKOPT_C=  000002 
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
    CLK_SWR_=  0000D2     |     CNTR    =  000003     |     CPU_A   =  007F00 
    CPU_CCR =  007F0A     |     CPU_PCE =  007F01     |     CPU_PCH =  007F02 
    CPU_PCL =  007F03     |     CPU_SPH =  007F08     |     CPU_SPL =  007F09 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]

Symbol Table

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
    DEST    =  000001     |     DEVID_BA=  0048CD     |     DEVID_EN=  0048D8 
    DEVID_LO=  0048D2     |     DEVID_LO=  0048D3     |     DEVID_LO=  0048D4 
    DEVID_LO=  0048D5     |     DEVID_LO=  0048D6     |     DEVID_LO=  0048D7 
    DEVID_LO=  0048D8     |     DEVID_WA=  0048D1     |     DEVID_XH=  0048CE 
    DEVID_XL=  0048CD     |     DEVID_YH=  0048D0     |     DEVID_YL=  0048CF 
    DM_BK1RE=  007F90     |     DM_BK1RH=  007F91     |     DM_BK1RL=  007F92 
    DM_BK2RE=  007F93     |     DM_BK2RH=  007F94     |     DM_BK2RL=  007F95 
    DM_CR1  =  007F96     |     DM_CR2  =  007F97     |     DM_CSR1 =  007F98 
    DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A     |     EEPROM_B=  004000 
    EEPROM_E=  0047FF     |   7 EEPROM_M   00063D R   |     EEPROM_S=  000800 
    ESC     =  00001B     |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
    FHSE    =  7A1200     |     FHSI    =  F42400     |     FIRST   =  000001 
    FLASH_BA=  008000     |     FLASH_CR=  00505A     |     FLASH_CR=  000002 
    FLASH_CR=  000000     |     FLASH_CR=  000003     |     FLASH_CR=  000001 
    FLASH_CR=  00505B     |     FLASH_CR=  000005     |     FLASH_CR=  000004 
    FLASH_CR=  000007     |     FLASH_CR=  000000     |     FLASH_CR=  000006 
    FLASH_DU=  005064     |     FLASH_DU=  0000AE     |     FLASH_DU=  000056 
    FLASH_EN=  027FFF     |     FLASH_FP=  00505D     |     FLASH_FP=  000000 
    FLASH_FP=  000001     |     FLASH_FP=  000002     |     FLASH_FP=  000003 
    FLASH_FP=  000004     |     FLASH_FP=  000005     |   7 FLASH_FR   000630 R
    FLASH_IA=  00505F     |     FLASH_IA=  000003     |     FLASH_IA=  000002 
    FLASH_IA=  000006     |     FLASH_IA=  000001     |     FLASH_IA=  000000 
    FLASH_NC=  00505C     |     FLASH_NF=  00505E     |     FLASH_NF=  000000 
    FLASH_NF=  000001     |     FLASH_NF=  000002     |     FLASH_NF=  000003 
    FLASH_NF=  000004     |     FLASH_NF=  000005     |     FLASH_PU=  005062 
    FLASH_PU=  000056     |     FLASH_PU=  0000AE     |     FLASH_SI=  020000 
    FLASH_WS=  00480D     |     FLSI    =  01F400     |     GPIO_BAS=  005000 
    GPIO_CR1=  000003     |     GPIO_CR2=  000004     |     GPIO_DDR=  000002 
    GPIO_IDR=  000001     |     GPIO_ODR=  000000     |     GPIO_SIZ=  000005 
  7 HELP       0006B2 R   |     HSECNT  =  004809     |     I2C_CCRH=  00521C 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]

Symbol Table

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
    LEN     =  000001     |     LOCAL_SI=  000004     |     MADDR   =  000001 
    N       =  000001     |     NAFR    =  004804     |     NCLKOPT =  004808 
    NFLASH_W=  00480E     |     NHSECNT =  00480A     |     NL      =  00000A 
    NOPT1   =  004802     |     NOPT2   =  004804     |     NOPT3   =  004806 
    NOPT4   =  004808     |     NOPT5   =  00480A     |     NOPT6   =  00480C 
    NOPT7   =  00480E     |     NOPTBL  =  00487F     |     NUBC    =  004802 
    NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC 
    NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE     |   7 NonHandl   0000CE R
    OPT     =  000002     |     OPT0    =  004800     |     OPT1    =  004801 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
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
    RAM_BASE=  000000     |     RAM_END =  0017FF     |   7 RAM_FREE   00061C R
  7 RAM_LAST   000627 R   |     RAM_SIZE=  001800     |     ROP     =  004800 
    RST_SR  =  0050B3     |     RXCHAR  =  000002     |     SFR_BASE=  005000 
    SFR_END =  0057FF     |     SIGN    =  000001     |     SPACE   =  000020 
    SPI_CR1 =  005200     |     SPI_CR2 =  005201     |     SPI_CRCP=  005205 
    SPI_DR  =  005204     |     SPI_ICR =  005202     |     SPI_RXCR=  005206 
    SPI_SR  =  005203     |     SPI_TXCR=  005207     |     SRC     =  000003 
    STACK_BA=  001700     |     STACK_SI=  000100     |     STACK_TO=  0017FF 
    SWIM_CSR=  007F80     |     TEMP    =  000003     |     TIB_SIZE=  000050 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]

Symbol Table

    TIM1_IER=  000003     |     TIM1_IER=  000004     |     TIM1_IER=  000005 
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
    UART1_BR=  005232     |     UART1_BR=  005233     |     UART1_CR=  005234 
    UART1_CR=  005235     |     UART1_CR=  005236     |     UART1_CR=  005237 
    UART1_CR=  005238     |     UART1_DR=  005231     |     UART1_GT=  005239 
    UART1_PS=  00523A     |     UART1_SR=  005230     |     UART3_BR=  005242 
    UART3_BR=  005243     |     UART3_CR=  005244     |     UART3_CR=  005245 
    UART3_CR=  005246     |     UART3_CR=  005247     |     UART3_CR=  004249 
    UART3_DR=  005241     |     UART3_SR=  005240     |     UART_CR1=  000004 
    UART_CR1=  000002     |     UART_CR1=  000000     |     UART_CR1=  000001 
    UART_CR1=  000007     |     UART_CR1=  000006     |     UART_CR1=  000005 
    UART_CR1=  000003     |     UART_CR2=  000004     |     UART_CR2=  000002 
    UART_CR2=  000005     |     UART_CR2=  000001     |     UART_CR2=  000000 
    UART_CR2=  000006     |     UART_CR2=  000003     |     UART_CR2=  000007 
    UART_CR3=  000003     |     UART_CR3=  000001     |     UART_CR3=  000002 
    UART_CR3=  000000     |     UART_CR3=  000006     |     UART_CR3=  000004 
    UART_CR3=  000005     |     UART_CR4=  000000     |     UART_CR4=  000001 
    UART_CR4=  000002     |     UART_CR4=  000003     |     UART_CR4=  000004 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]

Symbol Table

    UART_CR4=  000006     |     UART_CR4=  000005     |     UART_CR5=  000003 
    UART_CR5=  000001     |     UART_CR5=  000002     |     UART_CR5=  000004 
    UART_CR5=  000005     |     UART_CR6=  000004     |     UART_CR6=  000007 
    UART_CR6=  000001     |     UART_CR6=  000002     |     UART_CR6=  000000 
    UART_CR6=  000005     |     UART_SR_=  000001     |     UART_SR_=  000004 
    UART_SR_=  000002     |     UART_SR_=  000003     |     UART_SR_=  000000 
    UART_SR_=  000005     |     UART_SR_=  000006     |     UART_SR_=  000007 
    UBC     =  004801     |   7 VERSION    0005D4 R   |     WDGOPT  =  004805 
    WDGOPT_I=  000002     |     WDGOPT_L=  000003     |     WDGOPT_W=  000000 
    WDGOPT_W=  000001     |     WWDG_CR =  0050D1     |     WWDG_WR =  0050D2 
    XSAVE   =  000002     |   6 __interr   000000 R   |   5 __stack_   001700 R
  2 _user_ra   000000 R   |   7 a_upper    00031B R   |   1 acc16      0000A8 R
  7 accept_c   000188 R   |   7 atoi       000327 R   |   7 base_con   0004FC R
  7 cancel     0001C1 R   |   7 clear_al   000028 R   |   7 clear_bi   000513 R
  7 clear_ra   00002B R   |   7 clock_in   000000 R   |   1 count      000003 R
  7 del_back   000177 R   |   7 del_line   000166 R   |   7 del_loop   00011C R
  7 eval       000444 R   |   7 execute    0005CF R   |   7 fetch      0004AE R
  7 flash_fr   000835 R   |   1 flash_fr   0000AC R   |   7 help       0004F4 R
  7 hexdump    000525 R   |   1 idx_x      000004 R   |   1 idx_y      000006 R
  1 in         000002 R   |   1 in.w       000001 R   |   7 init0      000033 R
  7 is_digit   0002EF R   |   7 is_hex     0002FC R   |   7 itoa       000259 R
  7 itoa_loo   000288 R   |   7 main       000071 R   |   7 move_loo   000593 R
  7 move_mem   000580 R   |   7 mul16x8    0002D2 R   |   7 next_wor   000204 R
  7 number     0003A6 R   |   1 pad        000058 R   |   7 peek       000392 R
  1 ram_free   0000AA R   |   7 readln     000135 R   |   7 readln_l   00013D R
  7 readln_q   0001CB R   |   7 readln_q   0001D0 R   |   7 repl       0000B2 R
  7 reprint    00019D R   |   7 row        000540 R   |   7 row_init   00052C R
  1 rx_char    000000 R   |   7 scan       0001EE R   |   7 set_bits   0005AD R
  7 skip       0001D8 R   |   7 store      0004D2 R   |   7 strcpyn    00023C R
  7 strlen     000380 R   |   1 tib        000008 R   |   7 toggle_b   0005BE R
  7 uart3_in   00000F R   |   7 uart_del   00011B R   |   7 uart_get   000107 R
  7 uart_pri   0000EF R   |   7 uart_qch   0000FB R   |   7 uart_rx_   0000D3 R
  7 uart_tx    0000E5 R   |   7 ungetcha   000101 R   |   7 write_by   0003AD R
  7 write_ee   000403 R   |   7 write_fl   0003E1 R   |   7 write_sf   0003D2 R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size     AE   flags    0
   2 USER_RAM   size      0   flags    0
   3 INITIALI   size      0   flags    0
   4 SSEG       size      0   flags    8
   5 SSEG0      size    100   flags    8
   6 HOME       size     7C   flags    0
   7 CODE       size    835   flags    0

