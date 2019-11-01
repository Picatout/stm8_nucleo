;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   tutoriel sdas pour stm8
;   chapitre 3  hello.asm
;   Date: 2019-10-31
;   Copyright Jacques Deschêens, 2019
;   licence:  CC-BY-SA version 2 ou ultérieure
;
;   Description: 
;       Chaque fois que le boutin USER est enfoncé le message
;       "Hello from extended memory.\n" est envoyé via le UART3.
;       Utilisation de la mémoire flash au delà de 0xffff.
;       Discution sur l'utilisation de la mémoire étendue.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "../inc/nucleo_8s208.inc"
    .include "../inc/stm8s208.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; allume LED2
    .macro _ledon
    bset LED2_PORT,#LED2_BIT
    .endm

    ; éteint LED2
    .macro _ledoff
    bres LED2_PORT,#LED2_BIT
    .endm
   
    ; inverse l'état de LED2
    .macro _led_toggle
    ld a,LED2_PORT
    xor a,#LED2_MASK
    ld LED2_PORT,a
    .endm

    ; initialise farptr avec l'adresse étendu d'un message
    .macro _ld_farptr  msg 
    ld a,#msg>>16
    ld farptr,a
    ld a,#msg>>8
    ld farptrM,a
    ld a,#msg
    ld farptrL,a
    .endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       section des variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .area DATA
farptr:  .blkb 1 ; pointeur étendu octet supérieur [23:16]
farptrM: .blkb 1 ; pointeur étendu octet du milieur [15:8]
farptrL: .blkb 1 ; pointeru étendu octet faible [7:0]
phase:   .blkb 1 ; indique message à afficher

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       section de la pile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    STACK_SIZE = 256
    STACK_TOP = RAM_END-1

    .area SSEG (ABS)
    .org RAM_END-STACK_SIZE
    .ds STACK_SIZE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     table des vecteurs d'interruption
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .area HOME
    int main  ; vecteur de réinitialisation
	int NonHandledInterrupt ;TRAP  software interrupt
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
	int usr_btn_isr         ;int7 EXTI4 port E external interrupts
	int NonHandledInterrupt ;int8 beCAN RX interrupt
	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
	int NonHandledInterrupt ;int10 SPI End of transfer
	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
	int NonHandledInterrupt ;int12 TIM1 capture/compare
	int NonHandledInterrupt ;int13 TIM2 update /overflow
	int NonHandledInterrupt ;int14 TIM2 capture/compare
	int NonHandledInterrupt ;int15 TIM3 Update/overflow
	int NonHandledInterrupt ;int16 TIM3 Capture/compare
	int NonHandledInterrupt ;int17 UART1 TX completed
	int NonHandledInterrupt ;int18 UART1 RX full
	int NonHandledInterrupt ;int19 I2C 
	int NonHandledInterrupt ;int20 UART3 TX completed
	int NonHandledInterrupt ;int21 UART3 RX full
	int NonHandledInterrupt ;int22 ADC2 end of conversion
	int NonHandledInterrupt	;int23 TIM4 update/overflow
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used

    .area CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   point d'entrée après une réinitialisation du MCU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:
; initialisation de la pile
    ldw x,#STACK_TOP
    ldw sp,x
; initialise la variable farptr avec message hello
    _ld_farptr hello
;   initialise variable phase
    clr phase    
; initialise le clock système
    call clock_init
; initialise la communication sérielle
    call uart3_init        
; initialise la broche du LED2 en mode 
; sortie push pull
    bset PC_CR1,#LED2_BIT
    bset PC_CR2,#LED2_BIT
    bset PC_DDR,#LED2_BIT
; active l'interruption sur bouton utilisateur sur
; la transition descendante seulement
    bset EXTI_CR2,#1    
; active l'interruption sur PE_4 bouton utilisateur
    bset PE_CR2,#USR_BTN_BIT
; active les interruptions
    rim 
; suspend le MCU en attendant l'interruption du bouton
1$: ;halt
    jra 1$

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initialise le UART3, configuration: 115200 8N1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
uart3_init:
;	bset CLK_PCKENR1,#CLK_PCKENR1_UART3
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN));|(1<<UART_CR2_RIEN))
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;initialize clock, configuration HSE 8 Mhz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
    clr CLK_CKDIVR
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  section de code situé dans la mémoire étendue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .area CODE_FAR (ABS)
    .org 0x10000 ; segment 1 de la mémoire étendue

;------------------------------------
;  serial port communication routines
;------------------------------------
;------------------------------------
; Transmet le caractère qui est dans A 
; via UART3
;------------------------------------
uart_tx:
	btjf UART3_SR,#UART_SR_TXE,uart_tx
	ld UART3_DR,a
    ret

;------------------------------------
; transmet le message via UART3
;------------------------------------
    USE_PTR = 1 ; mettre à 0 pour adressage direct indexé
print_msg:
    pushw x
    pushw y
    clrw y
    .if USE_PTR
    ; initialise farptr
    tnz phase
    jreq ph0 
    btjt phase,#0,ph1
ph2: 
    _ld_farptr reponse
    jra print
ph1:
    _ld_farptr trivia
    jra print
ph0:
    _ld_farptr hello         
print:
     ldf a,([farptr],y) ; addressage par pointer en RAM
    .else    
print:
	ldf a,(hello,y)  ; adressage indexé avec offset étendu
    .endif
	jreq 9$
	call uart_tx
	incw y
	jra print
9$:
    .if USE_PTR
    inc phase
    ld a,#3
    cp a,phase
    jrne 10$
    clr phase
    .endif
10$:    
    popw y
    popw x
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	gestionnaire d'interruption pour
;   les interruption non gérées
;   réinitialise le MCU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NonHandledInterrupt:
	ld a,#0x80
	ld WWDG_CR,a
    ;iret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       gestionnaire d'interruption pour le bouton USER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    DEBOUNCE = 0 ; mettre à zéro pour annule le code anti-rebond.
usr_btn_isr:
    _ledon
    call print_msg
    .if DEBOUNCE
; anti-rebond
; attend que le bouton soit relâché
1$: clrw x
    btjf USR_BTN_PORT,#USR_BTN_BIT,1$ 
; tant que le bouton est relâché incrémente X 
; si X==0x7fff quitte
; si bouton revient à zéro avant retourne à 1$     
2$: incw x
    cpw x,#0x7fff
    jreq 3$
    btjt USR_BTN_PORT,#USR_BTN_BIT,2$
    jra 1$
    .endif; DEBOUNCE
    _ledoff  
3$: iret



    hello:
        .byte   12
        .asciz  "Hello from exented memory.\n"
    trivia:
        .byte 12
        .ascii "Trivia:\n"
        .ascii "Quel personnage d'une serie culte des annees 60 a dit:\n"
        .byte '"'
        .ascii "Je ne suis pas un numero, je suis un homme libre."
        .byte '"','\n',0
    reponse:
        .asciz "\nLe prisonnier, serie tv de ce titre, acteur: Patrick McGoohan\n"

