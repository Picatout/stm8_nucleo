;-------------------------------------------------------------
;  eForth for STM8S adapted from C. H. Ting source file to 
;  assemble using sdasstm8
;  implemented on NUCLEO-8S208RB board
;--------------------------------------------------------------
	.module EFORTH
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
;	.list
	.page

;===============================================================
;       STM8EF, Version 2.1, 13jul10cht
;               Implemented on STM8S-Discovery Board.
;               Assembled by ST VisualDevelop STVD 
;               Bootup on internal 2 MHz clock
;               Switch to external 16 MHz crystal clock
;
; FORTH Virtual Machine:
; Subroutine threaded model
; SP Return stack pointer
; X Data stack pointer
; A,Y Scratch pad registers
;
; Memory Map:
; $0 RAM memory, system variables
; $80 Start of user defined words, linked to ROM dictionary
; $780 Data stack, growing downward
; $790 Terminal input buffer TIB
; $7FF Return stack, growing downward
; $8000 Interrupt vector table
; $8080 FORTH startup code
; $80E7 Start of FORTH dictionary in ROM
; $$9584 End of FORTH dictionary
;
;       EF12, Version 2.1, 18apr00cht
;               move to 8000H replacing WHYP.
;               copy interrupt vectors from WHYPFLSH.S19
;               to EF12.S19 before flashing
;               add TICKS1 and DELAY1 for motor stepping
;
;       EF12, 02/18/00, C. H. Ting
;       Adapt 86eForth v2.02 to 68HC12.
;               Use WHYP to seed EF12.ASM
;               Use AS12 native 68HC12 assembler:
;               as12 ef12.asm >ef12.lst
;       EF12A, add ADC code, 02mar00cht
;       EF12B, 01mar00cht
;               stack to $78, return stack to $f8.
;               add all port definitions
;               add PWM registers
;               add SPI registers and code
;       EF12C, 12mar00cht
;               add MAX5250 D/A converter
;       EF12D, 15mar00cht
;               add all the Lexel interface words
;       EF12E, 18apr00cht, save for reference
;
;       Copyright (c) 2000
;       Dr. C. H. Ting
;       156 14th Avenue
;       San Mateo, CA 94402
;       (650) 571-7639
;
;*********************************************************
	segment byte at 0-7FF 'ram'
	segment byte at 4000-43FF 'eeprom'
	segment byte at 8080-FFFF 'rom'
;*********************************************************

main.l
	; clear stacks
	ldw X,#$700
clear_ram0
	clr (X)
	incw X
	cpw X,#$7FF	
	jrule clear_ram0

; initialize SP
	ldw X,#$7FE
	ldw SP,X
	jp ORIG

; non handled interrupt reset MCU
	interrupt NonHandledInterrupt
NonHandledInterrupt.l
        ld a, 0x80
        ld 0x50D1,a ; WWDG_CR used to reset mcu
	;iret

;*********************************************************
	segment byte at 8000-807F 'vectit'
	dc.l {$82000000+main}	                ; reset
	dc.l {$82000000+NonHandledInterrupt}	; trap
	dc.l {$82000000+NonHandledInterrupt}	; irq0
	dc.l {$82000000+NonHandledInterrupt}	; irq1
	dc.l {$82000000+NonHandledInterrupt}	; irq2
	dc.l {$82000000+NonHandledInterrupt}	; irq3
	dc.l {$82000000+NonHandledInterrupt}	; irq4
	dc.l {$82000000+NonHandledInterrupt}	; irq5
	dc.l {$82000000+NonHandledInterrupt}	; irq6
	dc.l {$82000000+NonHandledInterrupt}	; irq7
	dc.l {$82000000+NonHandledInterrupt}	; irq8
	dc.l {$82000000+NonHandledInterrupt}	; irq9
	dc.l {$82000000+NonHandledInterrupt}	; irq10
	dc.l {$82000000+NonHandledInterrupt}	; irq11
	dc.l {$82000000+NonHandledInterrupt}	; irq12
	dc.l {$82000000+NonHandledInterrupt}	; irq13
	dc.l {$82000000+NonHandledInterrupt}	; irq14
	dc.l {$82000000+NonHandledInterrupt}	; irq15
	dc.l {$82000000+NonHandledInterrupt}	; irq16
	dc.l {$82000000+NonHandledInterrupt}	; irq17
	dc.l {$82000000+NonHandledInterrupt}	; irq18
	dc.l {$82000000+NonHandledInterrupt}	; irq19
	dc.l {$82000000+NonHandledInterrupt}	; irq20
	dc.l {$82000000+NonHandledInterrupt}	; irq21
	dc.l {$82000000+NonHandledInterrupt}	; irq22
	dc.l {$82000000+NonHandledInterrupt}	; irq23
	dc.l {$82000000+NonHandledInterrupt}	; irq24
	dc.l {$82000000+NonHandledInterrupt}	; irq25
	dc.l {$82000000+NonHandledInterrupt}	; irq26
	dc.l {$82000000+NonHandledInterrupt}	; irq27
	dc.l {$82000000+NonHandledInterrupt}	; irq28
	dc.l {$82000000+NonHandledInterrupt}	; irq29

;*********************************************************
	segment 'rom'
;*********************************************************
REGBASE EQU	$5000	   ;register base
UARTSR   EQU	$5240	;UART status reg
UARTDR   EQU	$5241	;UART data reg
UARTBD1  EQU	$5242	;baud rate control 1
UARTBD2  EQU	$5243	;baud rate control 2
UARTCR1  EQU	$5244	;UART control reg 2
UARTCR2  EQU	$5245	;UART control reg 2
UARTCR3  EQU	$5246	;UART control reg 2
UARTCR4  EQU	$5247	;UART control reg 2
UARTCR5  EQU	$5248	;UART control reg 2
UARTCR6  EQU	$5249	;UART control reg 2
PD_DDR  EQU	$5011	; PD5 direction
PD_CR1  EQU	$5012	; PD5 control 1
PD_CR2  EQU	$5013	; PD5 control 1
CLK_SWR EQU $50C4 ; clock master switch 
CLK_SWCR EQU $50C5 ; clock switch control

RAMBASE EQU	$0000	   ;ram base
STACK   EQU	$7FF	;system (return) stack 
DATSTK  EQU	$780	;data stack 
;******  System Variables  ******
XTEMP	EQU	26	;address called by CREATE
YTEMP	EQU	28	;address called by CREATE
PROD1 EQU 26	;space for UM*
PROD2 EQU 28
PROD3 EQU 30
CARRY EQU 32
SP0	EQU	34	 ;initial data stack pointer
RP0	EQU	36	;initial return stack pointer

;***********************************************
;; Version control

VER     EQU     2         ;major release version
EXT     EQU     1         ;minor extension

;; Constants

TRUEE   EQU     $FFFF      ;true flag

COMPO   EQU     $40     ;lexicon compile only bit
IMEDD   EQU     $80     ;lexicon immediate bit
MASKK   EQU     $1F7F  ;lexicon bit mask

CELLL   EQU     2       ;size of a cell
BASEE   EQU     10      ;default radix
BKSPP   EQU     8       ;back space
LF      EQU     10      ;line feed
CRR     EQU     13      ;carriage return
ERR     EQU     27      ;error escape
TIC     EQU     39      ;tick
CALLL   EQU     $CD     ;CALL opcodes

;; Memory allocation

UPP     EQU     {RAMBASE+6}
SPP     EQU     {RAMBASE+$780}
RPP     EQU     {RAMBASE+$7FF}
TIBB    EQU     {RAMBASE+$790}
CTOP    EQU     {RAMBASE+$80}

;; Main entry points and COLD start data
	
ORIG:   
        LDW     X,#STACK  ;initialize return stack
        LDW     SP,X
        LDW     RP0,X
        LDW     X,#DATSTK ;initialize data stack
        LDW     SP0,X
        MOV     PD_DDR,#$1  ; LED, SWIM
        MOV     PD_CR1,#$3  ; pullups
        MOV     PD_CR2,#$1  ; speed
				BSET CLK_SWCR,#1 ; enable external clcok
				MOV CLK_SWR,#$B4 ; external cyrstal clock
WAIT0:  BTJF CLK_SWCR,#3,WAIT0 ; wait SWIF
        BRES CLK_SWCR,#3 ; clear SWIF
				MOV     UARTBD2,#$02  ;9600 baud
        MOV     UARTBD1,#$68  ;9600 baud
        MOV     UARTCR1,#$06  ;8 data bits, no parity
        MOV     UARTCR3,#$00  ;1 stop bit
        MOV     UARTCR2,#$0C  ;enable tx & rx
        JP      COLD   ;default=MN1

; COLD start initiates these variables.

UZERO:
        DC.W      BASEE   ;BASE
        DC.W      0       ;tmp
        DC.W      0       ;>IN
        DC.W      0       ;#TIB
        DC.W      TIBB    ;TIB
        DC.W      INTER   ;'EVAL
        DC.W      0       ;HLD
        DC.W       LASTN   ;CONTEXT pointer
        DC.W       CTOP   ;CP in RAM
        DC.W      LASTN   ;LAST
ULAST:  DC.W      0

;; Device dependent I/O
;       All channeled to DOS 21H services

;       ?RX     ( -- c T | F )
;         Return input byte and true, or false.
        DC.W      0
LINK	CEQU *
        DC.B      4
        DC.B     "?KEY"
QKEY
        BTJF UARTSR,#5,INCH   ;check status
        LD    A,UARTDR   ;get char in A
				SUBW	X,#2
        LD     (1,X),A
				CLR	(X)
				SUBW	X,#2
        LDW     Y,#$FFFF
        LDW     (X),Y
        RET
INCH    CLRW	Y
				SUBW	X,#2
        LDW     (X),Y
        RET

;       TX!     ( c -- )
;         Send character c to  output device.
        DC.W      LINK
LINK	CEQU	*
        DC.B      4
        DC.B     "EMIT"
EMIT
        LD     A,(1,X)
				ADDW	X,#2
OUTPUT  BTJF UARTSR,#7,OUTPUT  ;loop until tdre
        LD    UARTDR,A   ;send A
        RET

;; The kernel

;       doLIT   ( -- w )
;       Push an inline literal.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+5}
        DC.B     "doLit"
DOLIT
				SUBW X,#2
        POPW Y
				LDW YTEMP,Y
				LDW Y,(Y)
        LDW (X),Y
        LDW Y,YTEMP
				JP (2,Y)

;       next    ( -- )
;         Code for  single index loop.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+4}
        DC.B     "next"
DONXT
        LDW Y,(3,SP)
        DECW Y
        JRPL NEX1
				POPW Y
				POP A
				POP A
        JP (2,Y)
NEX1    LDW (3,SP),Y
        POPW Y
				LDW Y,(Y)
				JP (Y)

;       ?branch ( f -- )
;       Branch if flag is zero.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+7}
        DC.B     "?branch"
QBRAN	
        LDW Y,X
				ADDW X,#2
				LDW Y,(Y)
        JREQ     BRAN
				POPW Y
				JP (2,Y)
        
;       branch  ( -- )
;       Branch to an inline address.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+6}
        DC.B     "branch"
BRAN
        POPW Y
				LDW Y,(Y)
        JP     (Y)

;       EXECUTE ( ca -- )
;         Execute  word at ca.

        DC.W      LINK
LINK	CEQU	*
        DC.B       7
        DC.B     "EXECUTE"
EXECU
        LDW Y,X
				ADDW X,#2
				LDW     Y,(Y)
        JP     (Y)

;       EXIT    ( -- )
;       Terminate a colon definition.

        DC.W      LINK
LINK CEQU *
        DC.B      4
        DC.B     "EXIT"
EXIT
        POPW Y
        RET

;       !       ( w a -- )
;         Pop  data stack to memory.

        DC.W      LINK
LINK CEQU *
        DC.B      1
        DC.B     "!"
STORE
				LDW Y,X
				LDW Y,(Y)    ;Y=a
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(2,Y)
				LDW [YTEMP],Y
        ADDW X,#4 ;store w at a
        RET     

;       @       ( a -- w )
;         Push memory location to stack.

        DC.W      LINK
LINK	CEQU	*
        DC.B      1
        DC.B	"@"
AT
        LDW Y,X     ;Y = a
				LDW Y,(Y)
				LDW Y,(Y)
        LDW (X),Y ;w = @Y
        RET     

;       C!      ( c b -- )
;         Pop  data stack to byte memory.

        DC.W      LINK
LINK	CEQU	*
        DC.B      2
        DC.B     "C!"
CSTOR
        LDW Y,X
				LDW Y,(Y)    ;Y=b
        LD A,(3,X)    ;D = c
        LD  (Y),A     ;store c at b
				ADDW X,#4
        RET     

;       C@      ( b -- c )
;         Push byte in memory to  stack.

        DC.W      LINK
LINK	CEQU	*
        DC.B      2
        DC.B     "C@"
CAT
        LDW Y,X     ;Y=b
				LDW Y,(Y)
				LD A,(Y)
				LD (1,X),A
				CLR (X)
        RET     

;       RP@     ( -- a )
;         Push current RP to data stack.

        DC.W      LINK
LINK	CEQU	*
        DC.B      3
        DC.B     "rp@"
RPAT
        LDW Y,SP    ;save return addr
				SUBW X,#2
				LDW (X),Y
        RET     

;       RP!     ( a -- )
;         Set  return stack pointer.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+3}
        DC.B     "rp!"
RPSTO
        POPW Y
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(Y)
			  LDW SP,Y
				JP [YTEMP]

;       R>      ( -- w )
;         Pop return stack to data stack.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+2}
        DC.B     "R>"
RFROM
        POPW Y    ;save return addr
				LDW YTEMP,Y
				POPW Y
				SUBW X,#2
				LDW (X),Y
				JP [YTEMP]

;       R@      ( -- w )
;         Copy top of return stack to stack.

        DC.W      LINK
LINK	CEQU	*
        DC.B      2
        DC.B     "R@"
RAT
        POPW Y
				LDW YTEMP,Y
				POPW Y
				PUSHW Y
				SUBW X,#2
				LDW (X),Y
				JP [YTEMP]

;       >R      ( w -- )
;         Push data stack to return stack.

        DC.W      LINK
LINK	CEQU	*
			DC.B      {COMPO+2}
        DC.B     ">R"
TOR
        POPW Y    ;save return addr
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(Y)
        PUSHW Y    ;restore return addr
				ADDW X,#2
				JP [YTEMP]

;       SP@     ( -- a )
;         Push current stack pointer.

        DC.W      LINK
LINK	CEQU	*
        DC.B      3
        DC.B     "sp@"
SPAT
				LDW Y,X
        SUBW X,#2
				LDW (X),Y
        RET     

;       SP!     ( a -- )
;         Set  data stack pointer.

        DC.W      LINK
LINK	CEQU	*
        DC.B      3
        DC.B     "sp!"
SPSTO
        LDW     X,(X)     ;X = a
        RET     

;       DROP    ( w -- )
;       Discard top stack item.

        DC.W      LINK
LINK	CEQU	*
        DC.B      4
        DC.B     "DROP"
DROP
        ADDW X,#2     
        RET     

;       DUP     ( w -- w w )
;         Duplicate  top stack item.

        DC.W      LINK
LINK	CEQU	*
        DC.B      3
        DC.B     "DUP"
DUPP
				LDW Y,X
        SUBW X,#2
				LDW Y,(Y)
				LDW (X),Y
        RET     

;       SWAP    ( w1 w2 -- w2 w1 )
;       Exchange top two stack items.

        DC.W      LINK
LINK	CEQU	*
        DC.B      4
        DC.B     "SWAP"
SWAPP
        LDW Y,X
				LDW Y,(Y)
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(2,Y)
				LDW (X),Y
				LDW Y,YTEMP
				LDW (2,X),Y
        RET     

;       OVER    ( w1 w2 -- w1 w2 w1 )
;       Copy second stack item to top.

        DC.W      LINK
LINK	CEQU *
        DC.B      4
        DC.B     "OVER"
OVER
        SUBW X,#2
				LDW Y,X
				LDW Y,(4,Y)
				LDW (X),Y
        RET     

;       0<      ( n -- t )
;       Return true if n is negative.

        DC.W      LINK
LINK	CEQU *
        DC.B      2
        DC.B     "0<"
ZLESS
        LD A,#$FF
				LDW Y,X
				LDW Y,(Y)
        JRMI     ZL1
        CLR A   ;false
ZL1     LD     (X),A
        LD (1,X),A
				RET     

;       AND     ( w w -- w )
;       Bitwise AND.

        DC.W      LINK
LINK	CEQU *
        DC.B      3
        DC.B     "AND"
ANDD
        LD     A,(X)    ;D=w
				AND A,(2,X)
				LD (2,X),A
				LD A,(1,X)
				AND A,(3,X)
				LD (3,X),A
				ADDW X,#2
        RET

;       OR      ( w w -- w )
;       Bitwise inclusive OR.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "OR"
ORR
        LD     A,(X)    ;D=w
				OR A,(2,X)
				LD (2,X),A
				LD A,(1,X)
				OR A,(3,X)
				LD (3,X),A
				ADDW X,#2
        RET

;       XOR     ( w w -- w )
;       Bitwise exclusive OR.

        DC.W      LINK
LINK	CEQU *
        DC.B      3
        DC.B     "XOR"
XORR
        LD     A,(X)    ;D=w
				XOR A,(2,X)
				LD (2,X),A
				LD A,(1,X)
				XOR A,(3,X)
				LD (3,X),A
				ADDW X,#2
        RET

;       UM+     ( u u -- udsum )
;         Add two unsigned single
;         and return a double sum.

        DC.W      LINK
LINK	CEQU *
        DC.B      3
        DC.B     "UM+"
UPLUS
        LD A,#1
				LDW Y,X
				LDW Y,(2,Y)
				LDW YTEMP,Y
        LDW Y,X
				LDW Y,(Y)
				ADDW Y,YTEMP
				LDW (2,X),Y
        JRC     UPL1
        CLR A
UPL1    LD     (1,X),A
				CLR (X)
				RET

;; System and user variables

;       doVAR   ( -- a )
;         Code for VARIABLE and CREATE.

        DC.W      LINK
LINK	CEQU *
			DC.B      {COMPO+5}
        DC.B     "doVar"
DOVAR
				SUBW X,#2
        POPW Y    ;get return addr (pfa)
        LDW (X),Y    ;push on stack
        RET     ;go to RET of EXEC

;       BASE    ( -- a )
;         Radix base for numeric I/O.

        DC.W      LINK        
LINK CEQU *
        DC.B      4
        DC.B     "BASE"
BASE
			LDW Y,#{RAMBASE+6}
				SUBW X,#2
        LDW (X),Y
        RET

;       tmp     ( -- a )
;         A temporary storage.

        DC.W      LINK
        
LINK CEQU *
			DC.B      3
        DC.B     "tmp"
TEMP
			LDW Y,#{RAMBASE+8}
				SUBW X,#2
        LDW (X),Y
        RET

;       >IN     ( -- a )
;         Hold parsing pointer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B    ">IN"
INN
			LDW Y,#{RAMBASE+10}
				SUBW X,#2
        LDW (X),Y
        RET

;       #TIB    ( -- a )
;         Count in terminal input buffer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "#TIB"
NTIB
			LDW Y,#{RAMBASE+12}
				SUBW X,#2
        LDW (X),Y
        RET

;       "EVAL   ( -- a )
;       Execution vector of EVAL.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "'eval"
TEVAL
			LDW Y,#{RAMBASE+16}
				SUBW X,#2
        LDW (X),Y
        RET


;       HLD     ( -- a )
;         Hold a pointer of output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "hld"
HLD
			LDW Y,#{RAMBASE+18}
				SUBW X,#2
        LDW (X),Y
        RET

;       CONTEXT ( -- a )
;         Start vocabulary search.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "CONTEXT"
CNTXT
			LDW Y,#{RAMBASE+20}
				SUBW X,#2
        LDW (X),Y
        RET

;       CP      ( -- a )
;         Point to top of dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "cp"
CPP
			LDW Y,#{RAMBASE+22}
				SUBW X,#2
        LDW (X),Y
        RET

;       LAST    ( -- a )
;         Point to last name in dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "last"
LAST
			LDW Y,#{RAMBASE+24}
				SUBW X,#2
        LDW (X),Y
        RET

;; Common functions

;       ?DUP    ( w -- w w | 0 )
;       Dup tos if its is not zero.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "?DUP"
QDUP
        LDW Y,X
				LDW Y,(Y)
        JREQ     QDUP1
				SUBW X,#2
        LDW (X),Y
QDUP1:  RET

;       ROT     ( w1 w2 w3 -- w2 w3 w1 )
;       Rot 3rd item to top.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "ROT"
ROT
        LDW Y,X
				LDW Y,(4,Y)
				LDW YTEMP,Y
        LDW Y,X
				LDW Y,(2,Y)
				LDW XTEMP,Y
        LDW Y,X
				LDW Y,(Y)
				LDW (2,X),Y
				LDW Y,XTEMP
				LDW (4,X),Y
				LDW Y,YTEMP
				LDW (X),Y
        RET

;       2DROP   ( w w -- )
;       Discard two items on stack.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "2DROP"
DDROP
        ADDW X,#4
        RET

;       2DUP    ( w1 w2 -- w1 w2 w1 w2 )
;       Duplicate top two items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "2DUP"
DDUP
        SUBW X,#4
				LDW Y,X
				LDW Y,(6,Y)
				LDW (2,X),Y
				LDW Y,X
				LDW Y,(4,Y)
				LDW (X),Y
        RET

;       +       ( w w -- sum )
;       Add top two items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "+"
PLUS
				LDW Y,X
				LDW Y,(Y)
				LDW YTEMP,Y
				ADDW X,#2
        LDW Y,X
				LDW Y,(Y)
				ADDW Y,YTEMP
				LDW (X),Y
        RET

;       NOT     ( w -- w )
;       One's complement of tos.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "NOT"
INVER
        LDW Y,X
				LDW Y,(Y)
				CPLW Y
				LDW (X),Y
        RET

;       NEGATE  ( n -- -n )
;       Two's complement of tos.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "NEGATE"
NEGAT
        LDW Y,X
				LDW Y,(Y)
				NEGW Y
				LDW (X),Y
        RET

;       DNEGATE ( d -- -d )
;       Two's complement of top double.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "DNEGATE"
DNEGA
        LDW Y,X
				LDW Y,(Y)
        CPLW Y     
				LDW YTEMP,Y
        LDW Y,X
				LDW Y,(2,Y)
				CPLW Y
				INCW Y
				LDW (2,X),Y
				LDW Y,YTEMP
				JRNC DN1 
        INCW Y
DN1     LDW (X),Y
        RET

;       -       ( n1 n2 -- n1-n2 )
;       Subtraction.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "-"
SUBB
				LDW Y,X
				LDW Y,(Y)
				LDW YTEMP,Y
				ADDW X,#2
        LDW Y,X
				LDW Y,(Y)
				SUBW Y,YTEMP
				LDW (X),Y
        RET

;       ABS     ( n -- n )
;         Return  absolute value of n.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "ABS"
ABSS
        LDW Y,X
				LDW Y,(Y)
        JRPL     AB1     ;negate:
				NEGW     Y     ;else negate hi byte
				LDW (X),Y
AB1     RET

;       =       ( w w -- t )
;       Return true if top two are equal.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "="
EQUAL
        LD A,#$FF  ;true
        LDW Y,X    ;D = n2
        LDW Y,(Y)
				LDW YTEMP,Y
				ADDW X,#2
				LDW Y,X
				LDW Y,(Y)
				CPW Y,YTEMP     ;if n2 <> n1
        JREQ     EQ1
        CLR A
EQ1     LD (X),A
        LD (1,X),A
				RET     

;       U<      ( u u -- t )
;       Unsigned compare of top two items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "U<"
ULESS
        LD A,#$FF  ;true
        LDW Y,X    ;D = n2
        LDW Y,(Y)
				LDW YTEMP,Y
				ADDW X,#2
				LDW Y,X
				LDW Y,(Y)
				CPW Y,YTEMP     ;if n2 <> n1
        JRULT     ULES1
        CLR A
ULES1     LD (X),A
        LD (1,X),A
				RET     

;       <       ( n1 n2 -- t )
;       Signed compare of top two items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "<"
LESS
        LD A,#$FF  ;true
        LDW Y,X    ;D = n2
        LDW Y,(Y)
				LDW YTEMP,Y
				ADDW X,#2
				LDW Y,X
				LDW Y,(Y)
				CPW Y,YTEMP     ;if n2 <> n1
        JRSLT     LT1
        CLR A
LT1     LD (X),A
        LD (1,X),A
				RET     

;       MAX     ( n n -- n )
;         Return greater of two top items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "MAX"
MAX
        LDW Y,X    ;D = n2
        LDW Y,(2,Y)
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(Y)
				CPW Y,YTEMP     ;if n2 <> n1
        JRSLT     MAX1
        LDW (2,X),Y
MAX1		ADDW X,#2
				RET     

;       MIN     ( n n -- n )
;         Return smaller of top two items.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "MIN"
MIN
        LDW Y,X    ;D = n2
        LDW Y,(2,Y)
				LDW YTEMP,Y
				LDW Y,X
				LDW Y,(Y)
				CPW Y,YTEMP     ;if n2 <> n1
        JRSGT     MIN1
        LDW (2,X),Y
MIN1		ADDW X,#2
				RET     

;       WITHIN  ( u ul uh -- t )
;         Return true if u is within
;         range of ul and uh. ( ul <= u < uh )

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "WITHIN"
WITHI
        CALL     OVER
        CALL     SUBB
        CALL     TOR
        CALL     SUBB
        CALL     RFROM
        JP     ULESS

;; Divide

;       UM/MOD  ( udl udh un -- ur uq )
;       Unsigned divide of a double by a
;         single. Return mod and quotient.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "UM/MOD"
UMMOD
	LDW XTEMP,X	; save stack pointer
	LDW X,(X)		; un
	LDW YTEMP,X ; save un
	LDW Y,XTEMP	; stack pointer
	LDW Y,(4,Y) ; Y=udl
	LDW X,XTEMP
	LDW X,(2,X)	; X=udh
	CPW X,YTEMP
	JRULE MMSM1
	LDW X,XTEMP
	ADDW X,#2	; pop off 1 level
	LDW Y,#$FFFF
	LDW (X),Y
	CLRW Y
	LDW (2,X),Y
	RET
MMSM1:
	LD A,#17	; loop count
MMSM3:
	CPW X,YTEMP	; compare udh to un
	JRULT MMSM4	; can't subtract
	SUBW X,YTEMP	; can subtract
MMSM4:
	CCF	; quotient bit
	RLCW Y	; rotate into quotient
	RLCW X	; rotate into remainder
	DEC A	; repeat
	JRUGT MMSM3
	SRAW X
	LDW YTEMP,X	; done, save remainder
	LDW X,XTEMP
	ADDW X,#2	; drop
	LDW (X),Y
	LDW Y,YTEMP	; save quotient
	LDW (2,X),Y
	RET
	
;       M/MOD   ( d n -- r q )
;       Signed floored divide of double by
;         single. Return mod and quotient.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "M/MOD"
MSMOD
		CALL	DUPP
		CALL	ZLESS
		CALL	DUPP
		CALL	TOR
		CALL	QBRAN
		DC.W	MMOD1
		CALL	NEGAT
		CALL	TOR
		CALL	DNEGA
		CALL	RFROM
MMOD1:		CALL	TOR
		CALL	DUPP
		CALL	ZLESS
		CALL	QBRAN
		DC.W	MMOD2
		CALL	RAT
		CALL	PLUS
MMOD2:		CALL	RFROM
		CALL	UMMOD
		CALL	RFROM
		CALL	QBRAN
		DC.W	MMOD3
		CALL	SWAPP
		CALL	NEGAT
		CALL	SWAPP
MMOD3:		RET

;       /MOD    ( n n -- r q )
;       Signed divide. Return mod and quotient.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "/MOD"
SLMOD
		CALL	OVER
		CALL	ZLESS
		CALL	SWAPP
		JP	MSMOD

;       MOD     ( n n -- r )
;       Signed divide. Return mod only.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "MOD"
MODD
		CALL	SLMOD
		JP	DROP

;       /       ( n n -- q )
;       Signed divide. Return quotient only.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "/"
SLASH
		CALL	SLMOD
		CALL	SWAPP
		JP	DROP

;; Multiply

;       UM*     ( u u -- ud )
;       Unsigned multiply. Return double product.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "UM*"
UMSTA:	; stack have 4 bytes u1=a,b u2=c,d
	LD A,(2,X)	; b
	LD YL,A
	LD A,(X)	; d
	MUL Y,A
	LDW PROD1,Y
	LD A,(3,X)	; a
	LD YL,A
	LD A,(X)	; d
	MUL Y,A
	LDW PROD2,Y
	LD A,(2,X)	; b
	LD YL,A
	LD A,(1,X)	; c
	MUL Y,A
	LDW PROD3,Y
	LD A,(3,X)	; a
	LD YL,A
	LD A,(1,X)	; c
	MUL Y,A	; least signifiant product
	CLR A
	RRWA Y,A
	LD (3,X),A	; store least significant byte
	ADDW Y,PROD3
	CLR A
	ADC A,#0	; save carry
	LD CARRY,A
	ADDW Y,PROD2
	LD A,CARRY
	ADC A,#0	; add 2nd carry
	LD CARRY,A
	CLR A
	RRWA Y,A
	LD (2,X),A	; 2nd product byte
	ADDW Y,PROD1
	RRWA Y,A
	LD (1,X),A	; 3rd product byte
	RRWA Y,A	; 4th product byte now in A
	ADC A,CARRY	; fill in carry bits
	LD (X),A
	RET

;       *       ( n n -- n )
;       Signed multiply. Return single product.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "*"
STAR
		CALL	UMSTA
		JP	DROP

;       M*      ( n n -- d )
;       Signed multiply. Return double product.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "M*"
MSTAR      
		CALL	DDUP
		CALL	XORR
		CALL	ZLESS
		CALL	TOR
		CALL	ABSS
		CALL	SWAPP
		CALL	ABSS
		CALL	UMSTA
		CALL	RFROM
		CALL	QBRAN
		DC.W	MSTA1
		CALL	DNEGA
MSTA1:		RET

;       */MOD   ( n1 n2 n3 -- r q )
;       Multiply n1 and n2, then divide
;         by n3. Return mod and quotient.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "*/MOD"
SSMOD
        CALL     TOR
        CALL     MSTAR
        CALL     RFROM
        JP     MSMOD

;       */      ( n1 n2 n3 -- q )
;         Multiply n1 by n2, then divide
;         by n3. Return quotient only.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "*/"
STASL
		CALL	SSMOD
		CALL	SWAPP
		JP	DROP

;; Miscellaneous

;       CELL+   ( a -- a )
;       Add cell size in byte to address.

        DC.W      LINK
        
LINK CEQU *
        DC.B       2
        DC.B     "2+"
CELLP
        LDW Y,X
				LDW Y,(Y)
        ADDW Y,#2
        LDW (X),Y
        RET

;       CELL-   ( a -- a )
;         Subtract 2 from address.

        DC.W      LINK
        
LINK CEQU *
        DC.B       2
        DC.B     "2-"
CELLM
        LDW Y,X
				LDW Y,(Y)
        SUBW Y,#2
        LDW (X),Y
        RET

;       CELLS   ( n -- n )
;         Multiply tos by 2.

        DC.W      LINK
        
LINK CEQU *
        DC.B       2
        DC.B     "2*"
CELLS
        LDW Y,X
				LDW Y,(Y)
        SLAW Y
        LDW (X),Y
        RET

;       1+      ( a -- a )
;       Add cell size in byte to address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "1+"
ONEP
        LDW Y,X
				LDW Y,(Y)
        INCW Y
        LDW (X),Y
        RET

;       1-      ( a -- a )
;         Subtract 2 from address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "1-"
ONEM
        LDW Y,X
				LDW Y,(Y)
        DECW Y
        LDW (X),Y
        RET

;       2/      ( n -- n )
;         Multiply tos by 2.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "2/"
TWOSL
        LDW Y,X
				LDW Y,(Y)
        SRAW Y
        LDW (X),Y
        RET

;       BL      ( -- 32 )
;         Return 32,  blank character.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "BL"
BLANK
        SUBW X,#2
				LDW Y,#32
        LDW (X),Y
        RET

;         0     ( -- 0)
;         Return 0.

        DC.W      LINK
        
LINK CEQU *
        DC.B       1
        DC.B     "0"
ZERO
        SUBW X,#2
				CLRW Y
        LDW (X),Y
        RET

;         1     ( -- 1)
;         Return 1.

        DC.W      LINK
        
LINK CEQU *
        DC.B       1
        DC.B     "1"
ONE
        SUBW X,#2
				LDW Y,#1
        LDW (X),Y
        RET

;         -1    ( -- -1)
;         Return 32,  blank character.

        DC.W      LINK
        
LINK CEQU *
        DC.B       2
        DC.B     "-1"
MONE
        SUBW X,#2
				LDW Y,#$FFFF
        LDW (X),Y
        RET

;       >CHAR   ( c -- c )
;       Filter non-printing characters.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     ">CHAR"
TCHAR
        CALL     DOLIT
        DC.W       $7F
        CALL     ANDD
        CALL     DUPP    ;mask msb
        CALL     DOLIT
        DC.W      127
        CALL     BLANK
        CALL     WITHI   ;check for printable
        CALL     QBRAN
        DC.W      TCHA1
        CALL     DROP
        CALL     DOLIT
        DC.W     $5F		; "_"     ;replace non-printables
TCHA1:  RET

;       DEPTH   ( -- n )
;         Return  depth of  data stack.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "DEPTH"
DEPTH
        LDW Y,SP0    ;save data stack ptr
				LDW XTEMP,X
        SUBW Y,XTEMP     ;#bytes = SP0 - X
        SRAW Y    ;D = #stack items
				DECW Y
				SUBW X,#2
        LDW (X),Y     ; if neg, underflow
        RET

;       PICK    ( ... +n -- ... w )
;         Copy  nth stack item to tos.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "PICK"
PICK
        LDW Y,X   ;D = n1
        LDW Y,(Y)
				SLAW Y
				LDW XTEMP,X
				ADDW Y,XTEMP
        LDW Y,(Y)
        LDW (X),Y
        RET

;; Memory access

;       +!      ( n a -- )
;         Add n to  contents at address a.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "+!"
PSTOR
		CALL	SWAPP
		CALL	OVER
		CALL	AT
		CALL	PLUS
		CALL	SWAPP
		JP	STORE

;       2!      ( d a -- )
;         Store  double integer to address a.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "2!"
DSTOR
		CALL	SWAPP
		CALL	OVER
		CALL	STORE
		CALL	CELLP
		JP	STORE

;       2@      ( a -- d )
;       Fetch double integer from address a.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "2@"
DAT
		CALL	DUPP
		CALL	CELLP
		CALL	AT
		CALL	SWAPP
		JP	AT

;       COUNT   ( b -- b +n )
;       Return count byte of a string
;         and add 1 to byte address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "COUNT"
COUNT
        CALL     DUPP
        CALL     ONEP
        CALL     SWAPP
        JP     CAT

;       HERE    ( -- a )
;         Return  top of  code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "HERE"
HERE
        CALL     CPP
        JP     AT

;       PAD     ( -- a )
;         Return address of text buffer
;         above  code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "PAD"
PAD
        CALL     HERE
        CALL     DOLIT
        DC.W      80
        JP     PLUS

;       TIB     ( -- a )
;         Return address of terminal input buffer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "TIB"
TIB
        CALL     NTIB
        CALL     CELLP
        JP     AT

;       @EXECUTE        ( a -- )
;       Execute vector stored in address a.

        DC.W      LINK
        
LINK CEQU *
        DC.B      8
        DC.B     "@EXECUTE"
ATEXE
        CALL     AT
        CALL     QDUP    ;?address or zero
        CALL     QBRAN
        DC.W      EXE1
        CALL     EXECU   ;execute if non-zero
EXE1:   RET     ;do nothing if zero

;       CMOVE   ( b1 b2 u -- )
;       Copy u bytes from b1 to b2.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "CMOVE"
CMOVE
		CALL	TOR
		CALL	BRAN
		DC.W	CMOV2
CMOV1:		CALL	TOR
		CALL	DUPP
		CALL	CAT
		CALL	RAT
		CALL	CSTOR
		CALL	ONEP
		CALL	RFROM
		CALL	ONEP
CMOV2:		CALL	DONXT
		DC.W	CMOV1
		JP	DDROP

;       FILL    ( b u c -- )
;       Fill u bytes of character c
;         to area beginning at b.

        DC.W       LINK
        
LINK CEQU *
        DC.B       4
        DC.B     "FILL"
FILL
		CALL	SWAPP
		CALL	TOR
		CALL	SWAPP
		CALL	BRAN
		DC.W	FILL2
FILL1:		CALL	DDUP
		CALL	CSTOR
		CALL	ONEP
FILL2:		CALL	DONXT
		DC.W	FILL1
		JP	DDROP

;       ERASE   ( b u -- )
;       Erase u bytes beginning at b.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "ERASE"
ERASE
        CALL     ZERO
        JP     FILL

;       PACK$   ( b u a -- a )
;       Build a counted string with
;         u characters from b. Null fill.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "PACK$"
PACKS
        CALL     DUPP
        CALL     TOR     ;strings only on cell boundary
        CALL     DDUP
        CALL     CSTOR
        CALL     ONEP ;save count
        CALL     SWAPP
        CALL     CMOVE
        CALL     RFROM
        RET

;; Numeric output, single precision

;       DIGIT   ( u -- c )
;       Convert digit u to a character.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "DIGIT"
DIGIT
		CALL	DOLIT
		DC.W	9
		CALL	OVER
		CALL	LESS
		CALL	DOLIT
		DC.W	7
		CALL	ANDD
		CALL	PLUS
		CALL	DOLIT
		DC.W	48	;'0'
		JP	PLUS

;       EXTRACT ( n base -- n c )
;         Extract least significant digit from n.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "EXTRACT"
EXTRC
        CALL     ZERO
        CALL     SWAPP
        CALL     UMMOD
        CALL     SWAPP
        JP     DIGIT

;       <#      ( -- )
;         Initiate  numeric output process.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "<#"
BDIGS
        CALL     PAD
        CALL     HLD
        JP     STORE

;       HOLD    ( c -- )
;         Insert a character into output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "HOLD"
HOLD
        CALL     HLD
        CALL     AT
        CALL     ONEM
        CALL     DUPP
        CALL     HLD
        CALL     STORE
        JP     CSTOR

;       #       ( u -- u )
;         Extract one digit from u and
;         append digit to output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "#"
DIG
        CALL     BASE
        CALL     AT
        CALL     EXTRC
        JP     HOLD

;       #S      ( u -- 0 )
;         Convert u until all digits
;         are added to output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "#S"
DIGS
DIGS1:  CALL     DIG
        CALL     DUPP
        CALL     QBRAN
        DC.W      DIGS2
        JRA     DIGS1
DIGS2:  RET

;       SIGN    ( n -- )
;         Add a minus sign to
;         numeric output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "SIGN"
SIGN
        CALL     ZLESS
        CALL     QBRAN
        DC.W      SIGN1
        CALL     DOLIT
        DC.W      45	;"-"
        JP     HOLD
SIGN1:  RET

;       #>      ( w -- b u )
;         Prepare output string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "#>"
EDIGS
        CALL     DROP
        CALL     HLD
        CALL     AT
        CALL     PAD
        CALL     OVER
        JP     SUBB

;       str     ( w -- b u )
;       Convert a signed integer
;         to a numeric string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "str"
STR
        CALL     DUPP
        CALL     TOR
        CALL     ABSS
        CALL     BDIGS
        CALL     DIGS
        CALL     RFROM
        CALL     SIGN
        JP     EDIGS

;       HEX     ( -- )
;       Use radix 16 as base for
;         numeric conversions.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "HEX"
HEX
        CALL     DOLIT
        DC.W      16
        CALL     BASE
        JP     STORE

;       DECIMAL ( -- )
;       Use radix 10 as base
;         for numeric conversions.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "DECIMAL"
DECIM
        CALL     DOLIT
        DC.W      10
        CALL     BASE
        JP     STORE

;; Numeric input, single precision

;       DIGIT?  ( c base -- u t )
;       Convert a character to its numeric
;         value. A flag indicates success.

        DC.W      LINK
        
LINK CEQU *
        DC.B       6
        DC.B     "DIGIT?"
DIGTQ
        CALL     TOR
        CALL     DOLIT
        DC.W     48	; "0"
        CALL     SUBB
        CALL     DOLIT
        DC.W      9
        CALL     OVER
        CALL     LESS
        CALL     QBRAN
        DC.W      DGTQ1
        CALL     DOLIT
        DC.W      7
        CALL     SUBB
        CALL     DUPP
        CALL     DOLIT
        DC.W      10
        CALL     LESS
        CALL     ORR
DGTQ1:  CALL     DUPP
        CALL     RFROM
        JP     ULESS

;       NUMBER? ( a -- n T | a F )
;       Convert a number string to
;         integer. Push a flag on tos.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "NUMBER?"
NUMBQ
        CALL     BASE
        CALL     AT
        CALL     TOR
        CALL     ZERO
        CALL     OVER
        CALL     COUNT
        CALL     OVER
        CALL     CAT
        CALL     DOLIT
        DC.W     36	; "$"
        CALL     EQUAL
        CALL     QBRAN
        DC.W      NUMQ1
        CALL     HEX
        CALL     SWAPP
        CALL     ONEP
        CALL     SWAPP
        CALL     ONEM
NUMQ1:  CALL     OVER
        CALL     CAT
        CALL     DOLIT
        DC.W     45	; "-"
        CALL     EQUAL
        CALL     TOR
        CALL     SWAPP
        CALL     RAT
        CALL     SUBB
        CALL     SWAPP
        CALL     RAT
        CALL     PLUS
        CALL     QDUP
        CALL     QBRAN
        DC.W      NUMQ6
        CALL     ONEM
        CALL     TOR
NUMQ2:  CALL     DUPP
        CALL     TOR
        CALL     CAT
        CALL     BASE
        CALL     AT
        CALL     DIGTQ
        CALL     QBRAN
        DC.W      NUMQ4
        CALL     SWAPP
        CALL     BASE
        CALL     AT
        CALL     STAR
        CALL     PLUS
        CALL     RFROM
        CALL     ONEP
        CALL     DONXT
        DC.W      NUMQ2
        CALL     RAT
        CALL     SWAPP
        CALL     DROP
        CALL     QBRAN
        DC.W      NUMQ3
        CALL     NEGAT
NUMQ3:  CALL     SWAPP
        JRA     NUMQ5
NUMQ4:  CALL     RFROM
        CALL     RFROM
        CALL     DDROP
        CALL     DDROP
        CALL     ZERO
NUMQ5:  CALL     DUPP
NUMQ6:  CALL     RFROM
        CALL     DDROP
        CALL     RFROM
        CALL     BASE
        JP     STORE

;; Basic I/O

;       KEY     ( -- c )
;       Wait for and return an
;         input character.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "KEY"
KEY
KEY1:   CALL     QKEY
        CALL     QBRAN
        DC.W      KEY1
        RET

;       NUF?    ( -- t )
;       Return false if no input,
;         else pause and if CR return true.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "NUF?"
NUFQ
        CALL     QKEY
        CALL     DUPP
        CALL     QBRAN
        DC.W      NUFQ1
        CALL     DDROP
        CALL     KEY
        CALL     DOLIT
        DC.W      CRR
        JP     EQUAL
NUFQ1:  RET

;       SPACE   ( -- )
;         Send  blank character to
;         output device.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "SPACE"
SPACE
        CALL     BLANK
        JP     EMIT

;       SPACES  ( +n -- )
;         Send n spaces to output device.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "SPACES"
SPACS
        CALL     ZERO
        CALL     MAX
        CALL     TOR
        JRA     CHAR2
CHAR1:  CALL     SPACE
CHAR2:  CALL     DONXT
        DC.W      CHAR1
        RET

;       TYPE    ( b u -- )
;       Output u characters from b.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "TYPE"
TYPES
        CALL     TOR
        JRA     TYPE2
TYPE1:  CALL     DUPP
        CALL     CAT
        CALL     EMIT
        CALL     ONEP
TYPE2:  CALL     DONXT
        DC.W      TYPE1
        JP     DROP

;       CR      ( -- )
;       Output a carriage return
;         and a line feed.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "CR"
CR
        CALL     DOLIT
        DC.W      CRR
        CALL     EMIT
        CALL     DOLIT
        DC.W      LF
        JP     EMIT

;       do$     ( -- a )
;         Return  address of a compiled
;         string.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {COMPO+3}
        DC.B     "do$"
DOSTR
        CALL     RFROM
        CALL     RAT
        CALL     RFROM
        CALL     COUNT
        CALL     PLUS
        CALL     TOR
        CALL     SWAPP
        CALL     TOR
        RET

;       $"|     ( -- a )
;       Run time routine compiled by $".
;         Return address of a compiled string.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {COMPO+3}
        DC.B     '$','"','|'
STRQP
        CALL     DOSTR
        RET

;       ."|     ( -- )
;       Run time routine of ." .
;         Output a compiled string.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {COMPO+3}
        DC.B     '.','"','|'
DOTQP
        CALL     DOSTR
        CALL     COUNT
        JP     TYPES

;       .R      ( n +n -- )
;       Display an integer in a field
;         of n columns, right justified.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     ".R"
DOTR
        CALL     TOR
        CALL     STR
        CALL     RFROM
        CALL     OVER
        CALL     SUBB
        CALL     SPACS
        JP     TYPES

;       U.R     ( u +n -- )
;       Display an unsigned integer
;         in n column, right justified.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "U.R"
UDOTR
        CALL     TOR
        CALL     BDIGS
        CALL     DIGS
        CALL     EDIGS
        CALL     RFROM
        CALL     OVER
        CALL     SUBB
        CALL     SPACS
        JP     TYPES

;       U.      ( u -- )
;       Display an unsigned integer
;         in free format.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "U."
UDOT
        CALL     BDIGS
        CALL     DIGS
        CALL     EDIGS
        CALL     SPACE
        JP     TYPES

;       .       ( w -- )
;       Display an integer in free
;         format, preceeded by a space.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "."
DOT
        CALL     BASE
        CALL     AT
        CALL     DOLIT
        DC.W      10
        CALL     XORR    ;?decimal
        CALL     QBRAN
        DC.W      DOT1
        JP     UDOT
DOT1:   CALL     STR
        CALL     SPACE
        JP     TYPES

;       ?       ( a -- )
;         Display contents in memory cell.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "?"
QUEST
        CALL     AT
        JP     DOT

;; Parsing

;       parse   ( b u c -- b u delta ; <string> )
;       Scan string delimited by c.
;         Return found string and its offset.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "parse"
PARS
        CALL     TEMP
        CALL     STORE
        CALL     OVER
        CALL     TOR
        CALL     DUPP
        CALL     QBRAN
        DC.W      PARS8
        CALL     ONEM
        CALL     TEMP
        CALL     AT
        CALL     BLANK
        CALL     EQUAL
        CALL     QBRAN
        DC.W      PARS3
        CALL     TOR
PARS1:  CALL     BLANK
        CALL     OVER
        CALL     CAT     ;skip leading blanks ONLY
        CALL     SUBB
        CALL     ZLESS
        CALL     INVER
        CALL     QBRAN
        DC.W      PARS2
        CALL     ONEP
        CALL     DONXT
        DC.W      PARS1
        CALL     RFROM
        CALL     DROP
        CALL     ZERO
        JP     DUPP
PARS2:  CALL     RFROM
PARS3:  CALL     OVER
        CALL     SWAPP
        CALL     TOR
PARS4:  CALL     TEMP
        CALL     AT
        CALL     OVER
        CALL     CAT
        CALL     SUBB    ;scan for delimiter
        CALL     TEMP
        CALL     AT
        CALL     BLANK
        CALL     EQUAL
        CALL     QBRAN
        DC.W      PARS5
        CALL     ZLESS
PARS5:  CALL     QBRAN
        DC.W      PARS6
        CALL     ONEP
        CALL     DONXT
        DC.W      PARS4
        CALL     DUPP
        CALL     TOR
        JRA     PARS7
PARS6:  CALL     RFROM
        CALL     DROP
        CALL     DUPP
        CALL     ONEP
        CALL     TOR
PARS7:  CALL     OVER
        CALL     SUBB
        CALL     RFROM
        CALL     RFROM
        JP     SUBB
PARS8:  CALL     OVER
        CALL     RFROM
        JP     SUBB

;       PARSE   ( c -- b u ; <string> )
;       Scan input stream and return
;         counted string delimited by c.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "PARSE"
PARSE
        CALL     TOR
        CALL     TIB
        CALL     INN
        CALL     AT
        CALL     PLUS    ;current input buffer pointer
        CALL     NTIB
        CALL     AT
        CALL     INN
        CALL     AT
        CALL     SUBB    ;remaining count
        CALL     RFROM
        CALL     PARS
        CALL     INN
        JP     PSTOR

;       .(      ( -- )
;       Output following string up to next ) .

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+2}
        DC.B     ".("
DOTPR
        CALL     DOLIT
        DC.W     41	; ")"
        CALL     PARSE
        JP     TYPES

;       (       ( -- )
;         Ignore following string up to next ).
;         A comment.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+1}
        DC.B     "("
PAREN
        CALL     DOLIT
        DC.W     41	; ")"
        CALL     PARSE
        JP     DDROP

;       \       ( -- )
;         Ignore following text till
;         end of line.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+1}
        DC.B     "\\"
BKSLA
        CALL     NTIB
        CALL     AT
        CALL     INN
        JP     STORE

;       WORD    ( c -- a ; <string> )
;       Parse a word from input stream
;         and copy it to code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "WORD"
WORDD
        CALL     PARSE
        CALL     HERE
        CALL     CELLP
        JP     PACKS

;       TOKEN   ( -- a ; <string> )
;       Parse a word from input stream
;         and copy it to name dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "TOKEN"
TOKEN
        CALL     BLANK
        JP     WORDD

;; Dictionary search

;       NAME>   ( na -- ca )
;       Return a code address given
;         a name address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "NAME>"
NAMET
        CALL     COUNT
        CALL     DOLIT
        DC.W      31
        CALL     ANDD
        JP     PLUS

;       SAME?   ( a a u -- a a f \ -0+ )
;       Compare u cells in two
;         strings. Return 0 if identical.

        DC.W      LINK
        
LINK CEQU *
        DC.B       5
        DC.B     "SAME?"
SAMEQ
        CALL     ONEM
        CALL     TOR
        JRA     SAME2
SAME1:  CALL     OVER
        CALL     RAT
        CALL     PLUS
        CALL     CAT
        CALL     OVER
        CALL     RAT
        CALL     PLUS
        CALL     CAT
        CALL     SUBB
        CALL     QDUP
        CALL     QBRAN
        DC.W      SAME2
        CALL     RFROM
        JP     DROP
SAME2:  CALL     DONXT
        DC.W      SAME1
        JP     ZERO

;       find    ( a va -- ca na | a F )
;         Search vocabulary for string.
;         Return ca and na if succeeded.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "find"
FIND
        CALL     SWAPP
        CALL     DUPP
        CALL     CAT
        CALL     TEMP
        CALL     STORE
        CALL     DUPP
        CALL     AT
        CALL     TOR
        CALL     CELLP
        CALL     SWAPP
FIND1:  CALL     AT
        CALL     DUPP
        CALL     QBRAN
        DC.W      FIND6
        CALL     DUPP
        CALL     AT
        CALL     DOLIT
        DC.W      MASKK
        CALL     ANDD
        CALL     RAT
        CALL     XORR
        CALL     QBRAN
        DC.W      FIND2
        CALL     CELLP
        CALL     DOLIT
        DC.W     $FFFF
        JRA     FIND3
FIND2:  CALL     CELLP
        CALL     TEMP
        CALL     AT
        CALL     SAMEQ
FIND3:  CALL     BRAN
        DC.W      FIND4
FIND6:  CALL     RFROM
        CALL     DROP
        CALL     SWAPP
        CALL     CELLM
        JP     SWAPP
FIND4:  CALL     QBRAN
        DC.W      FIND5
        CALL     CELLM
        CALL     CELLM
        JRA     FIND1
FIND5:  CALL     RFROM
        CALL     DROP
        CALL     SWAPP
        CALL     DROP
        CALL     CELLM
        CALL     DUPP
        CALL     NAMET
        JP     SWAPP

;       NAME?   ( a -- ca na | a F )
;         Search vocabularies for a string.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "NAME?"
NAMEQ
        CALL     CNTXT
        JP     FIND

;; Terminal response

;       ^H      ( bot eot cur -- bot eot cur )
;         Backup cursor by one character.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "^h"
BKSP
        CALL     TOR
        CALL     OVER
        CALL     RFROM
        CALL     SWAPP
        CALL     OVER
        CALL     XORR
        CALL     QBRAN
        DC.W      BACK1
        CALL     DOLIT
        DC.W      BKSPP
        CALL     EMIT
        CALL     ONEM
        CALL     BLANK
        CALL     EMIT
        CALL     DOLIT
        DC.W      BKSPP
        JP     EMIT
BACK1:  RET

;       TAP     ( bot eot cur c -- bot eot cur )
;         Accept and echo key stroke
;         and bump cursor.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "TAP"
TAP
        CALL     DUPP
        CALL     EMIT
        CALL     OVER
        CALL     CSTOR
        JP     ONEP

;       kTAP    ( bot eot cur c -- bot eot cur )
;       Process a key stroke,
;         CR or backspace.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "kTAP"
KTAP
        CALL     DUPP
        CALL     DOLIT
        DC.W      CRR
        CALL     XORR
        CALL     QBRAN
        DC.W      KTAP2
        CALL     DOLIT
        DC.W      BKSPP
        CALL     XORR
        CALL     QBRAN
        DC.W      KTAP1
        CALL     BLANK
        JP     TAP
KTAP1:  JP     BKSP
KTAP2:  CALL     DROP
        CALL     SWAPP
        CALL     DROP
        JP     DUPP

;       accept  ( b u -- b u )
;       Accept characters to input
;         buffer. Return with actual count.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "ACCEPT"
ACCEP
        CALL     OVER
        CALL     PLUS
        CALL     OVER
ACCP1:  CALL     DDUP
        CALL     XORR
        CALL     QBRAN
        DC.W      ACCP4
        CALL     KEY
        CALL     DUPP
        CALL     BLANK
        CALL     DOLIT
        DC.W      127
        CALL     WITHI
        CALL     QBRAN
        DC.W      ACCP2
        CALL     TAP
        JRA     ACCP3
ACCP2:  CALL     KTAP
ACCP3:  JRA     ACCP1
ACCP4:  CALL     DROP
        CALL     OVER
        JP     SUBB

;       QUERY   ( -- )
;       Accept input stream to
;         terminal input buffer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "QUERY"
QUERY
        CALL     TIB
        CALL     DOLIT
        DC.W      80
        CALL     ACCEP
        CALL     NTIB
        CALL     STORE
        CALL     DROP
        CALL     ZERO
        CALL     INN
        JP     STORE

;       ABORT   ( -- )
;       Reset data stack and
;         jump to QUIT.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "ABORT"
ABORT
        CALL     PRESE
        JP     QUIT

;       abort"  ( f -- )
;         Run time routine of ABORT".
;         Abort with a message.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {COMPO+6}
        DC.B     "abort",'"'
ABORQ
        CALL     QBRAN
        DC.W      ABOR2   ;text flag
        CALL     DOSTR
ABOR1:  CALL     SPACE
        CALL     COUNT
        CALL     TYPES
        CALL     DOLIT
        DC.W     63 ; "?"
        CALL     EMIT
        CALL     CR
        JP     ABORT   ;pass error string
ABOR2:  CALL     DOSTR
        JP     DROP

;; The text interpreter

;       $INTERPRET      ( a -- )
;       Interpret a word. If failed,
;         try to convert it to an integer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      10
        DC.B     "$INTERPRET"
INTER
        CALL     NAMEQ
        CALL     QDUP    ;?defined
        CALL     QBRAN
        DC.W      INTE1
        CALL     AT
        CALL     DOLIT
		DC.W       $4000	; COMPO*256
        CALL     ANDD    ;?compile only lexicon bits
        CALL     ABORQ
        DC.B      13
        DC.B     " compile only"
        JP     EXECU
INTE1:  CALL     NUMBQ   ;convert a number
        CALL     QBRAN
        DC.W      ABOR1
        RET

;       [       ( -- )
;         Start  text interpreter.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+1}
        DC.B     "["
LBRAC
        CALL     DOLIT
        DC.W      INTER
        CALL     TEVAL
        JP     STORE

;       .OK     ( -- )
;         Display 'ok' while interpreting.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     ".OK"
DOTOK
        CALL     DOLIT
        DC.W      INTER
        CALL     TEVAL
        CALL     AT
        CALL     EQUAL
        CALL     QBRAN
        DC.W      DOTO1
        CALL     DOTQP
        DC.B      3
        DC.B     " ok"
DOTO1:  JP     CR

;       ?STACK  ( -- )
;         Abort if stack underflows.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "?STACK"
QSTAC
        CALL     DEPTH
        CALL     ZLESS   ;check only for underflow
        CALL     ABORQ
        DC.B      11
        DC.B     " underflow "
        RET

;       EVAL    ( -- )
;         Interpret  input stream.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "EVAL"
EVAL
EVAL1:  CALL     TOKEN
        CALL     DUPP
        CALL     CAT     ;?input stream empty
        CALL     QBRAN
        DC.W      EVAL2
        CALL     TEVAL
        CALL     ATEXE
        CALL     QSTAC   ;evaluate input, check stack
        CALL     BRAN
        DC.W      EVAL1
EVAL2:  CALL     DROP
        JP     DOTOK

;       PRESET  ( -- )
;         Reset data stack pointer and
;         terminal input buffer.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "PRESET"
PRESE
        CALL     DOLIT
        DC.W      SPP
        CALL     SPSTO
        CALL     DOLIT
        DC.W      TIBB
        CALL     NTIB
        CALL     CELLP
        JP     STORE

;       QUIT    ( -- )
;       Reset return stack pointer
;         and start text interpreter.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "QUIT"
QUIT
        CALL     DOLIT
        DC.W      RPP
        CALL     RPSTO   ;reset return stack pointer
QUIT1:  CALL     LBRAC   ;start interpretation
QUIT2:  CALL     QUERY   ;get input
        CALL     EVAL
        JRA     QUIT2   ;continue till error

;; The compiler

;       '       ( -- ca )
;         Search vocabularies for
;         next word in input stream.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "'"
TICK
        CALL     TOKEN
        CALL     NAMEQ   ;?defined
        CALL     QBRAN
        DC.W      ABOR1
        RET     ;yes, push code address

;       ALLOT   ( n -- )
;         Allocate n bytes to  code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "ALLOT"
ALLOT
        CALL     CPP
        JP     PSTOR

;       ,       ( w -- )
;         Compile an integer into
;         code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     ","
COMMA
        CALL     HERE
        CALL     DUPP
        CALL     CELLP   ;cell boundary
        CALL     CPP
        CALL     STORE
        JP     STORE

;       C,      ( c -- )
;         Compile a byte into
;         code dictionary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "C,"
CCOMMA
        CALL     HERE
        CALL     DUPP
        CALL     ONEP
        CALL     CPP
        CALL     STORE
        JP     CSTOR

;       [COMPILE]       ( -- ; <string> )
;         Compile next immediate
;         word into code dictionary.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+9}
        DC.B     "[COMPILE]"
BCOMP
        CALL     TICK
        JP     JSRC

;       COMPILE ( -- )
;         Compile next jsr in
;         colon list to code dictionary.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {COMPO+7}
        DC.B     "COMPILE"
COMPI
        CALL     RFROM
        CALL     ONEP
        CALL     DUPP
        CALL     AT
        CALL     JSRC    ;compile subroutine
        CALL     CELLP
        JP     TOR

;       LITERAL ( w -- )
;         Compile tos to dictionary
;         as an integer literal.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+7}
        DC.B     "LITERAL"
LITER
        CALL     COMPI
        CALL     DOLIT
        JP     COMMA

;       $,"     ( -- )
;       Compile a literal string
;         up to next " .

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     '$',',','"'
STRCQ
        CALL     DOLIT
        DC.W     34	; "
        CALL     PARSE
        CALL     HERE
        CALL     PACKS   ;string to code dictionary
        CALL     COUNT
        CALL     PLUS    ;calculate aligned end of string
        CALL     CPP
        JP     STORE

;; Structures

;       FOR     ( -- a )
;       Start a FOR-NEXT loop
;         structure in a colon definition.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+3}
        DC.B     "FOR"
FOR
        CALL     COMPI
        CALL     TOR
        JP     HERE

;       NEXT    ( a -- )
;         Terminate a FOR-NEXT loop.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+4}
        DC.B     "NEXT"
NEXT
        CALL     COMPI
        CALL     DONXT
        JP     COMMA

;       BEGIN   ( -- a )
;       Start an infinite or
;         indefinite loop structure.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+5}
        DC.B     "BEGIN"
BEGIN
        JP     HERE

;       UNTIL   ( a -- )
;       Terminate a BEGIN-UNTIL
;         indefinite loop structure.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+5}
        DC.B     "UNTIL"
UNTIL
        CALL     COMPI
        CALL     QBRAN
        JP     COMMA

;       AGAIN   ( a -- )
;       Terminate a BEGIN-AGAIN
;         infinite loop structure.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+5}
        DC.B     "AGAIN"
AGAIN
        CALL     COMPI
        CALL     BRAN
        JP     COMMA

;       IF      ( -- A )
;         Begin a conditional branch.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+2}
        DC.B     "IF"
IFF
        CALL     COMPI
        CALL     QBRAN
        CALL     HERE
        CALL     ZERO
        JP     COMMA

;   THEN        ( A -- )
;               Terminate a conditional branch structure.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+4}
        DC.B     "THEN"
THENN
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;   ELSE        ( A -- A )
;               Start the false clause in an IF-ELSE-THEN structure.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+4}
        DC.B     "ELSE"
ELSEE
        CALL     COMPI
        CALL     BRAN
        CALL     HERE
        CALL     ZERO
        CALL     COMMA
        CALL     SWAPP
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;   AHEAD       ( -- A )
;               Compile a forward branch instruction.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+5}
        DC.B     "AHEAD"
AHEAD
        CALL     COMPI
        CALL     BRAN
        CALL     HERE
        CALL     ZERO
        JP     COMMA

;   WHILE       ( a -- A a )
;       Conditional branch out of a BEGIN-WHILE-REPEAT loop.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+5}
        DC.B     "WHILE"
WHILE
        CALL     COMPI
        CALL     QBRAN
        CALL     HERE
        CALL     ZERO
        CALL     COMMA
        JP     SWAPP

;   REPEAT      ( A a -- )
;               Terminate a BEGIN-WHILE-REPEAT indefinite loop.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+6}
        DC.B     "REPEAT"
REPEA
        CALL     COMPI
        CALL     BRAN
        CALL     COMMA
        CALL     HERE
        CALL     SWAPP
        JP     STORE

;   AFT         ( a -- a A )
;               Jump to THEN in a FOR-AFT-THEN-NEXT loop the first time through.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+3}
        DC.B     "AFT"
AFT
        CALL     DROP
        CALL     AHEAD
        CALL     HERE
        JP     SWAPP

;   ABORT"      ( -- ; <string> )
;               Conditional abort with an error message.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+6}
        DC.B     "ABORT",'"'
ABRTQ
        CALL     COMPI
        CALL     ABORQ
        JP     STRCQ

;   $"          ( -- ; <string> )
;               Compile an inline string literal.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+2}
        DC.B     '$','"'
STRQ
        CALL     COMPI
        CALL     STRQP
        JP     STRCQ

;   ."          ( -- ; <string> )
;               Compile an inline string literal to be typed out at run time.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+2}
        DC.B     '.','"'
DOTQ
        CALL     COMPI
        CALL     DOTQP
        JP     STRCQ

;; Name compiler

;       ?UNIQUE ( a -- a )
;         Display a warning message
;         if word already exists.

        DC.W      LINK
        
LINK CEQU *
        DC.B      7
        DC.B     "?UNIQUE"
UNIQU
        CALL     DUPP
        CALL     NAMEQ   ;?name exists
        CALL     QBRAN
        DC.W      UNIQ1
        CALL     DOTQP   ;redef are OK
        DC.B       7
        DC.B     " reDef "       
        CALL     OVER
        CALL     COUNT
        CALL     TYPES   ;just in case
UNIQ1:  JP     DROP

;       $,n     ( na -- )
;         Build a new dictionary name
;         using string at na.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "$,n"
SNAME
        CALL     DUPP
        CALL     CAT     ;?null input
        CALL     QBRAN
        DC.W      PNAM1
        CALL     UNIQU   ;?redefinition
        CALL     DUPP
        CALL     COUNT
        CALL     PLUS
        CALL     CPP
        CALL     STORE
        CALL     DUPP
        CALL     LAST
        CALL     STORE   ;save na for vocabulary link
        CALL     CELLM   ;link address
        CALL     CNTXT
        CALL     AT
        CALL     SWAPP
        CALL     STORE
        RET     ;save code pointer
PNAM1:  CALL     STRQP
        DC.B      5
        DC.B     " name" ;null input
        JP     ABOR1

;; FORTH compiler

;       $COMPILE        ( a -- )
;         Compile next word to
;         dictionary as a token or literal.

        DC.W      LINK
        
LINK CEQU *
        DC.B      8
        DC.B     "$COMPILE"
SCOMP
        CALL     NAMEQ
        CALL     QDUP    ;?defined
        CALL     QBRAN
        DC.W      SCOM2
        CALL     AT
        CALL     DOLIT
        DC.W     $8000	;  IMEDD*256
        CALL     ANDD    ;?immediate
        CALL     QBRAN
        DC.W      SCOM1
        JP     EXECU
SCOM1:  JP     JSRC
SCOM2:  CALL     NUMBQ   ;try to convert to number
        CALL     QBRAN
        DC.W      ABOR1
        JP     LITER

;       OVERT   ( -- )
;         Link a new word into vocabulary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "OVERT"
OVERT
        CALL     LAST
        CALL     AT
        CALL     CNTXT
        JP     STORE

;       ;       ( -- )
;       Terminate a colon definition.

        DC.W      LINK
        
LINK CEQU *
			DC.B      {IMEDD+COMPO+1}
        DC.B     ";"
SEMIS
        CALL     COMPI
        CALL     EXIT
        CALL     LBRAC
        JP     OVERT

;       ]       ( -- )
;         Start compiling words in
;         input stream.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     "]"
RBRAC
        CALL     DOLIT
        DC.W      SCOMP
        CALL     TEVAL
        JP     STORE

;       CALL,    ( ca -- )
;         Compile a subroutine call.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "CALL,"
JSRC
        CALL     DOLIT
        DC.W     CALLL     ;CALL
        CALL     CCOMMA
        JP     COMMA

;       :       ( -- ; <string> )
;       Start a new colon definition
;         using next word as its name.

        DC.W      LINK
        
LINK CEQU *
        DC.B      1
        DC.B     ":"
COLON
        CALL     TOKEN
        CALL     SNAME
        JP     RBRAC

;       IMMEDIATE       ( -- )
;         Make last compiled word
;         an immediate word.

        DC.W      LINK
        
LINK CEQU *
        DC.B      9
        DC.B     "IMMEDIATE"
IMMED
        CALL     DOLIT
        DC.W     $8000	;  IMEDD*256
        CALL     LAST
        CALL     AT
        CALL     AT
        CALL     ORR
        CALL     LAST
        CALL     AT
        JP     STORE

;; Defining words

;       CREATE  ( -- ; <string> )
;         Compile a new array
;         without allocating space.

        DC.W      LINK
        
LINK CEQU *
        DC.B      6
        DC.B     "CREATE"
CREAT
        CALL     TOKEN
        CALL     SNAME
        CALL     OVERT
        CALL     COMPI
        CALL     DOVAR
        RET

;       VARIABLE        ( -- ; <string> )
;       Compile a new variable
;         initialized to 0.

        DC.W      LINK
        
LINK CEQU *
        DC.B      8
        DC.B     "VARIABLE"
VARIA
        CALL     CREAT
        CALL     ZERO
        JP     COMMA

;; Tools

;       _TYPE   ( b u -- )
;       Display a string. Filter
;         non-printing characters.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "_TYPE"
UTYPE
        CALL     TOR     ;start count down loop
        JRA     UTYP2   ;skip first pass
UTYP1:  CALL     DUPP
        CALL     CAT
        CALL     TCHAR
        CALL     EMIT    ;display only printable
        CALL     ONEP    ;increment address
UTYP2:  CALL     DONXT
        DC.W      UTYP1   ;loop till done
        JP     DROP

;       dm+     ( a u -- a )
;         Dump u bytes from ,
;         leaving a+u on  stack.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "dm+"
DUMPP
        CALL     OVER
        CALL     DOLIT
        DC.W      4
        CALL     UDOTR   ;display address
        CALL     SPACE
        CALL     TOR     ;start count down loop
        JRA     PDUM2   ;skip first pass
PDUM1:  CALL     DUPP
        CALL     CAT
        CALL     DOLIT
        DC.W      3
        CALL     UDOTR   ;display numeric data
        CALL     ONEP    ;increment address
PDUM2:  CALL     DONXT
        DC.W      PDUM1   ;loop till done
        RET

;       DUMP    ( a u -- )
;       Dump u bytes from a,
;         in a formatted manner.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "DUMP"
DUMP
        CALL     BASE
        CALL     AT
        CALL     TOR
        CALL     HEX     ;save radix, set hex
        CALL     DOLIT
        DC.W      16
        CALL     SLASH   ;change count to lines
        CALL     TOR     ;start count down loop
DUMP1:  CALL     CR
        CALL     DOLIT
        DC.W      16
        CALL     DDUP
        CALL     DUMPP   ;display numeric
        CALL     ROT
        CALL     ROT
        CALL     SPACE
        CALL     SPACE
        CALL     UTYPE   ;display printable characters
        CALL     DONXT
        DC.W      DUMP1   ;loop till done
DUMP3:  CALL     DROP
        CALL     RFROM
        CALL     BASE
        JP     STORE   ;restore radix

;       .S      ( ... -- ... )
;         Display  contents of stack.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     ".S"
DOTS
        CALL     CR
        CALL     DEPTH   ;stack depth
        CALL     TOR     ;start count down loop
        JRA     DOTS2   ;skip first pass
DOTS1:  CALL     RAT
        CALL ONEP
				CALL     PICK
        CALL     DOT     ;index stack, display contents
DOTS2:  CALL     DONXT
        DC.W      DOTS1   ;loop till done
        CALL     DOTQP
        DC.B      5
        DC.B     " <sp "
        RET

;       >NAME   ( ca -- na | F )
;       Convert code address
;         to a name address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     ">NAME"
TNAME
        CALL     CNTXT   ;vocabulary link
TNAM2:  CALL     AT
        CALL     DUPP    ;?last word in a vocabulary
        CALL     QBRAN
        DC.W      TNAM4
        CALL     DDUP
        CALL     NAMET
        CALL     XORR    ;compare
        CALL     QBRAN
        DC.W      TNAM3
        CALL     CELLM   ;continue with next word
        JRA     TNAM2
TNAM3:  CALL     SWAPP
        JP     DROP
TNAM4:  CALL     DDROP
        JP     ZERO

;       .ID     ( na -- )
;         Display  name at address.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     ".ID"
DOTID
        CALL     QDUP    ;if zero no name
        CALL     QBRAN
        DC.W      DOTI1
        CALL     COUNT
        CALL     DOLIT
        DC.W      $1F
        CALL     ANDD    ;mask lexicon bits
        JP     UTYPE
DOTI1:  CALL     DOTQP
        DC.B      9
        DC.B     " {noName}"
        RET

;       SEE     ( -- ; <string> )
;       A simple decompiler.
;         Updated for byte machines.

        DC.W      LINK
        
LINK CEQU *
        DC.B      3
        DC.B     "SEE"
SEE
        CALL     TICK    ;starting address
        CALL     CR
        CALL     ONEM
SEE1:   CALL     ONEP
        CALL     DUPP
        CALL     AT
        CALL     DUPP    ;?does it contain a zero
        CALL     QBRAN
        DC.W      SEE2
        CALL     TNAME   ;?is it a name
SEE2:   CALL     QDUP    ;name address or zero
        CALL     QBRAN
        DC.W      SEE3
        CALL     SPACE
        CALL     DOTID   ;display name
        CALL     ONEP
        JRA     SEE4
SEE3:   CALL     DUPP
        CALL     CAT
        CALL     UDOT    ;display number
SEE4:   CALL     NUFQ    ;user control
        CALL     QBRAN
        DC.W      SEE1
        JP     DROP

;       WORDS   ( -- )
;         Display names in vocabulary.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "WORDS"
WORDS
        CALL     CR
        CALL     CNTXT   ;only in context
WORS1:  CALL     AT
        CALL     QDUP    ;?at end of list
        CALL     QBRAN
        DC.W      WORS2
        CALL     DUPP
        CALL     SPACE
        CALL     DOTID   ;display a name
        CALL     CELLM
        CALL     BRAN
        DC.W      WORS1
        CALL     DROP
WORS2:  RET

        
;; Hardware reset

;       hi      ( -- )
;         Display sign-on message.

        DC.W      LINK
        
LINK CEQU *
        DC.B      2
        DC.B     "hi"
HI
        CALL     CR
        CALL     DOTQP   ;initialize I/O
        DC.B      15
        DC.B     "stm8eForth v"
			DC.B      {VER+'0'}
        DC.B      "."
			DC.B      {EXT+'0'} ;version
        JP     CR

;       DEBUG      ( -- )
;         Display sign-on message.

;        DC.W      LINK
        
;LINK CEQU *
;        DC.B      5
;        DC.B     "DEBUG"
;DEBUG:
;	CALL DOLIT
;	DC.W $65
;	CALL EMIT
;	CALL DOLIT
;	DC.W 0
; 	CALL ZLESS 
;	CALL DOLIT
;	DC.W $FFFE
;	CALL ZLESS 
;	CALL UPLUS 
; 	CALL DROP 
;	CALL DOLIT
;	DC.W 3
;	CALL UPLUS 
;	CALL UPLUS 
; 	CALL DROP
;	CALL DOLIT
;	DC.W $43
;	CALL UPLUS 
; 	CALL DROP
;	CALL EMIT
;	CALL DOLIT
;	DC.W $4F
;	CALL DOLIT
;	DC.W $6F
; 	CALL XORR
;	CALL DOLIT
;	DC.W $F0
; 	CALL ANDD
;	CALL DOLIT
;	DC.W $4F
; 	CALL ORR
;	CALL EMIT
;	CALL DOLIT
;	DC.W 8
;	CALL DOLIT
;	DC.W 6
; 	CALL SWAPP
;	CALL OVER
;	CALL XORR
;	CALL DOLIT
;	DC.W 3
;	CALL ANDD 
;	CALL ANDD
;	CALL DOLIT
;	DC.W $70
;	CALL UPLUS 
;	CALL DROP
;	CALL EMIT
;	CALL DOLIT
;	DC.W 0
;	CALL QBRAN
;	DC.W DEBUG1
;	CALL DOLIT
;	DC.W $3F
;DEBUG1:
;	CALL DOLIT
;	DC.W $FFFF
;	CALL QBRAN
;	DC.W DEBUG2
;	CALL DOLIT
;	DC.W $74
;	CALL BRAN
;	DC.W DEBUG3
;DEBUG2:
;	CALL DOLIT
;	DC.W $21
;DEBUG3:
;	CALL EMIT
;	CALL DOLIT
;	DC.W $68
;	CALL DOLIT
;	DC.W $80
;	CALL STORE
;	CALL DOLIT
;	DC.W $80
;	CALL AT
;	CALL EMIT
;	CALL DOLIT
;	DC.W $4D
;	CALL TOR
;	CALL RAT
;	CALL RFROM
;	CALL ANDD
;	CALL EMIT
;	CALL DOLIT
;	DC.W $61
;	CALL DOLIT
;	DC.W $A
;	CALL TOR
;DEBUG4:
;	CALL DOLIT
;	DC.W 1
;	CALL UPLUS 
;	CALL DROP
;	CALL DONXT
;	DC.W DEBUG4
;	CALL EMIT
;	CALL DOLIT
;	DC.W $656D
;	CALL DOLIT
;	DC.W $100
;	CALL UMSTA
;	CALL SWAPP
;	CALL DOLIT
;	DC.W $100
;	CALL UMSTA
;	CALL SWAPP 
;	CALL DROP
;	CALL EMIT
;	CALL EMIT
;	CALL DOLIT
;	DC.W $2043
;	CALL DOLIT
;	DC.W 0
;	CALL DOLIT
;	DC.W $100
;	CALL UMMOD
;	CALL EMIT
;	CALL EMIT
	;JP ORIG
;	RET

;       'BOOT   ( -- a )
;       The application startup vector.

        DC.W      LINK
        
LINK CEQU *
        DC.B      5
        DC.B     "'BOOT"
TBOOT
        CALL     DOVAR
        DC.W      HI       ;application to boot

;       COLD    ( -- )
;       The hilevel cold start sequence.

        DC.W      LINK
        
LINK CEQU *
        DC.B      4
        DC.B     "COLD"
COLD
;        CALL DEBUG
COLD1:  CALL     DOLIT
        DC.W      UZERO
				CALL     DOLIT
        DC.W      UPP
        CALL     DOLIT
			DC.W      {ULAST-UZERO}
        CALL     CMOVE   ;initialize user area
        CALL     PRESE   ;initialize data stack and TIB
        CALL     TBOOT
        CALL     ATEXE   ;application boot
        CALL     OVERT
        JP     QUIT    ;start interpretation


;       
;===============================================================

LASTN   EQU	LINK   ;last name defined
	END	

