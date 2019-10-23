                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.5.0 #9253 (Apr  3 2018) (Linux)
                                      4 ; This file was generated Tue Oct 22 21:47:16 2019
                                      5 ;--------------------------------------------------------
                                      6 	.module gpio_test
                                      7 	.optsdcc -mmcs51 --model-small
                                      8 	
                                      9 ;--------------------------------------------------------
                                     10 ; Public variables in this module
                                     11 ;--------------------------------------------------------
                                     12 	.globl _main
                                     13 ;--------------------------------------------------------
                                     14 ; special function registers
                                     15 ;--------------------------------------------------------
                                     16 	.area RSEG    (ABS,DATA)
      000000                         17 	.org 0x0000
                                     18 ;--------------------------------------------------------
                                     19 ; special function bits
                                     20 ;--------------------------------------------------------
                                     21 	.area RSEG    (ABS,DATA)
      000000                         22 	.org 0x0000
                                     23 ;--------------------------------------------------------
                                     24 ; overlayable register banks
                                     25 ;--------------------------------------------------------
                                     26 	.area REG_BANK_0	(REL,OVR,DATA)
      000000                         27 	.ds 8
                                     28 ;--------------------------------------------------------
                                     29 ; internal ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DSEG    (DATA)
                                     32 ;--------------------------------------------------------
                                     33 ; overlayable items in internal ram 
                                     34 ;--------------------------------------------------------
                                     35 	.area	OSEG    (OVR,DATA)
                                     36 ;--------------------------------------------------------
                                     37 ; Stack segment in internal ram 
                                     38 ;--------------------------------------------------------
                                     39 	.area	SSEG
      000009                         40 __start__stack:
      000009                         41 	.ds	1
                                     42 
                                     43 ;--------------------------------------------------------
                                     44 ; indirectly addressable internal ram data
                                     45 ;--------------------------------------------------------
                                     46 	.area ISEG    (DATA)
                                     47 ;--------------------------------------------------------
                                     48 ; absolute internal ram data
                                     49 ;--------------------------------------------------------
                                     50 	.area IABS    (ABS,DATA)
                                     51 	.area IABS    (ABS,DATA)
                                     52 ;--------------------------------------------------------
                                     53 ; bit data
                                     54 ;--------------------------------------------------------
                                     55 	.area BSEG    (BIT)
                                     56 ;--------------------------------------------------------
                                     57 ; paged external ram data
                                     58 ;--------------------------------------------------------
                                     59 	.area PSEG    (PAG,XDATA)
                                     60 ;--------------------------------------------------------
                                     61 ; external ram data
                                     62 ;--------------------------------------------------------
                                     63 	.area XSEG    (XDATA)
                                     64 ;--------------------------------------------------------
                                     65 ; absolute external ram data
                                     66 ;--------------------------------------------------------
                                     67 	.area XABS    (ABS,XDATA)
                                     68 ;--------------------------------------------------------
                                     69 ; external initialized ram data
                                     70 ;--------------------------------------------------------
                                     71 	.area XISEG   (XDATA)
                                     72 	.area HOME    (CODE)
                                     73 	.area GSINIT0 (CODE)
                                     74 	.area GSINIT1 (CODE)
                                     75 	.area GSINIT2 (CODE)
                                     76 	.area GSINIT3 (CODE)
                                     77 	.area GSINIT4 (CODE)
                                     78 	.area GSINIT5 (CODE)
                                     79 	.area GSINIT  (CODE)
                                     80 	.area GSFINAL (CODE)
                                     81 	.area CSEG    (CODE)
                                     82 ;--------------------------------------------------------
                                     83 ; interrupt vector 
                                     84 ;--------------------------------------------------------
                                     85 	.area HOME    (CODE)
      000000                         86 __interrupt_vect:
      000000 02 00 06         [24]   87 	ljmp	__sdcc_gsinit_startup
                                     88 ;--------------------------------------------------------
                                     89 ; global & static initialisations
                                     90 ;--------------------------------------------------------
                                     91 	.area HOME    (CODE)
                                     92 	.area GSINIT  (CODE)
                                     93 	.area GSFINAL (CODE)
                                     94 	.area GSINIT  (CODE)
                                     95 	.globl __sdcc_gsinit_startup
                                     96 	.globl __sdcc_program_startup
                                     97 	.globl __start__stack
                                     98 	.globl __mcs51_genXINIT
                                     99 	.globl __mcs51_genXRAMCLEAR
                                    100 	.globl __mcs51_genRAMCLEAR
                                    101 	.area GSFINAL (CODE)
      00005F 02 00 03         [24]  102 	ljmp	__sdcc_program_startup
                                    103 ;--------------------------------------------------------
                                    104 ; Home
                                    105 ;--------------------------------------------------------
                                    106 	.area HOME    (CODE)
                                    107 	.area HOME    (CODE)
      000003                        108 __sdcc_program_startup:
      000003 02 00 62         [24]  109 	ljmp	_main
                                    110 ;	return from main will return to caller
                                    111 ;--------------------------------------------------------
                                    112 ; code
                                    113 ;--------------------------------------------------------
                                    114 	.area CSEG    (CODE)
                                    115 ;------------------------------------------------------------
                                    116 ;Allocation info for local variables in function 'main'
                                    117 ;------------------------------------------------------------
                                    118 ;delay                     Allocated to registers r4 r5 r6 r7 
                                    119 ;------------------------------------------------------------
                                    120 ;	gpio_test.c:12: int main(){
                                    121 ;	-----------------------------------------
                                    122 ;	 function main
                                    123 ;	-----------------------------------------
      000062                        124 _main:
                           000007   125 	ar7 = 0x07
                           000006   126 	ar6 = 0x06
                           000005   127 	ar5 = 0x05
                           000004   128 	ar4 = 0x04
                           000003   129 	ar3 = 0x03
                           000002   130 	ar2 = 0x02
                           000001   131 	ar1 = 0x01
                           000000   132 	ar0 = 0x00
                                    133 ;	gpio_test.c:15: PC_DDR|=LED2;
      000062 90 50 0C         [24]  134 	mov	dptr,#0x500C
      000065 75 F0 00         [24]  135 	mov	b,#0x00
      000068 12 00 EA         [24]  136 	lcall	__gptrget
      00006B FF               [12]  137 	mov	r7,a
      00006C 43 07 20         [24]  138 	orl	ar7,#0x20
      00006F 90 50 0C         [24]  139 	mov	dptr,#0x500C
      000072 75 F0 00         [24]  140 	mov	b,#0x00
      000075 EF               [12]  141 	mov	a,r7
      000076 12 00 CF         [24]  142 	lcall	__gptrput
                                    143 ;	gpio_test.c:16: PC_CR1|=LED2;
      000079 90 50 0D         [24]  144 	mov	dptr,#0x500D
      00007C 75 F0 00         [24]  145 	mov	b,#0x00
      00007F 12 00 EA         [24]  146 	lcall	__gptrget
      000082 FF               [12]  147 	mov	r7,a
      000083 43 07 20         [24]  148 	orl	ar7,#0x20
      000086 90 50 0D         [24]  149 	mov	dptr,#0x500D
      000089 75 F0 00         [24]  150 	mov	b,#0x00
      00008C EF               [12]  151 	mov	a,r7
      00008D 12 00 CF         [24]  152 	lcall	__gptrput
                                    153 ;	gpio_test.c:17: while (1){
      000090                        154 00103$:
                                    155 ;	gpio_test.c:18: PC_ODR^=LED2;
      000090 90 50 0A         [24]  156 	mov	dptr,#0x500A
      000093 75 F0 00         [24]  157 	mov	b,#0x00
      000096 12 00 EA         [24]  158 	lcall	__gptrget
      000099 FF               [12]  159 	mov	r7,a
      00009A 63 07 20         [24]  160 	xrl	ar7,#0x20
      00009D 90 50 0A         [24]  161 	mov	dptr,#0x500A
      0000A0 75 F0 00         [24]  162 	mov	b,#0x00
      0000A3 EF               [12]  163 	mov	a,r7
      0000A4 12 00 CF         [24]  164 	lcall	__gptrput
                                    165 ;	gpio_test.c:19: for (delay=0;delay<DELAY;delay++);
      0000A7 7C FF            [12]  166 	mov	r4,#0xFF
      0000A9 7D FF            [12]  167 	mov	r5,#0xFF
      0000AB 7E 00            [12]  168 	mov	r6,#0x00
      0000AD 7F 00            [12]  169 	mov	r7,#0x00
      0000AF                        170 00107$:
      0000AF EC               [12]  171 	mov	a,r4
      0000B0 24 FF            [12]  172 	add	a,#0xFF
      0000B2 F8               [12]  173 	mov	r0,a
      0000B3 ED               [12]  174 	mov	a,r5
      0000B4 34 FF            [12]  175 	addc	a,#0xFF
      0000B6 F9               [12]  176 	mov	r1,a
      0000B7 EE               [12]  177 	mov	a,r6
      0000B8 34 FF            [12]  178 	addc	a,#0xFF
      0000BA FA               [12]  179 	mov	r2,a
      0000BB EF               [12]  180 	mov	a,r7
      0000BC 34 FF            [12]  181 	addc	a,#0xFF
      0000BE FB               [12]  182 	mov	r3,a
      0000BF 88 04            [24]  183 	mov	ar4,r0
      0000C1 89 05            [24]  184 	mov	ar5,r1
      0000C3 8A 06            [24]  185 	mov	ar6,r2
      0000C5 8B 07            [24]  186 	mov	ar7,r3
      0000C7 E8               [12]  187 	mov	a,r0
      0000C8 49               [12]  188 	orl	a,r1
      0000C9 4A               [12]  189 	orl	a,r2
      0000CA 4B               [12]  190 	orl	a,r3
      0000CB 70 E2            [24]  191 	jnz	00107$
                                    192 ;	gpio_test.c:21: return 0;
      0000CD 80 C1            [24]  193 	sjmp	00103$
                                    194 	.area CSEG    (CODE)
                                    195 	.area CONST   (CODE)
                                    196 	.area XINIT   (CODE)
                                    197 	.area CABS    (ABS,CODE)
