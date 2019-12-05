;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   tutoriel sdas pour stm8
;   chapitre 5  interface enter 'C' et 'asm'
;   Date: 2019-12-05
;   Copyright Jacques Deschêens, 2019
;   licence:  CC-BY-SA version 2 ou ultérieure
;
;   Description: 
;       le programme ch5_demo.c appelle une fonction 
;       ecrite en assembleur dans la librairie uart.
;       ch5_demo.asm appelle une fonction écrite en 'C' 
;       dans ch5_demo.c 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    .module CH5_DEMO_ASM
    .nlist
    .include "../inc/nucleo_8s208.inc"
    .include "../inc/stm8s208.inc"
    .include "../inc/ascii.inc"
    .list 

		.macro _ledenable ; set PC5 as push-pull output fast mode
		bset PC_CR1,#LED2_BIT
		bset PC_CR2,#LED2_BIT
		bset PC_DDR,#LED2_BIT
		.endm

        .macro _drop size 
        addw sp,#size 
        .endm

    .area DATA

    .area CODE

;initialize clock to use HSE 8 Mhz crystal
_clock_init::
clock_init::	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret


;----------------------------------
;initialise PORT C pin 5 en sortie.
; contrôle de la LED2 sur la carte.
;----------------------------------
_led_init::
    _ledenable
    ret

;-------------------------------------------------
;  imprime sur la concole l'état de la LED2.
; input:
;   A       indicateur d'état.
; output:
;   none
;------------------------------------------------
print_led_state:
    push a 
    ldw y,#etat_led 
    call puts
    pop a  
    cp a,#LED_ON 
    jrne 1$
    ldw y,#etat_on 
    jra 2$
1$: ldw y,#etat_off 
2$: call puts    
    ret 

; imprime chaîne pointée par Y
puts:
    push #UART3
    pushw y 
    call uart_puts 
    _drop 3
    ret 

; attend un caractère du terminal
getc:
    push #UART3
    call uart_getc 
    _drop 1
    ret

; imprime un caractère sur le terminal 
putc:
    push #UART3 
    push a 
    call uart_putc 
    _drop 2
    ret 

    ; commandes LED 
    LED_OFF=0
    LED_ON=1
    LED_TOGGLE=2

    ARG_OFS=2
    CHAR_PTR=ARG_OFS+1
_loop::
loop::
    ldw y,(CHAR_PTR,sp)
    call puts 
repl:    
    ld a,#'?
    call putc 
    call getc
    push a 
    call putc
    ld a,#CR 
    call putc 
    pop a 
    cp a,#'a 
    jrne 1$
    jra allume
1$: cp a,#'e 
    jrne 2$
    jra eteint
2$: cp a,#'i 
    jrne 3$ 
    jra inverse 
3$: cp a,#'q
    jrne 4$
    ret 
4$: ldw y,#bad_cmd
    call puts 
    jra repl
cmd:
    push a 
    call _led_switch
    _drop 1
    call print_led_state
    jra repl
allume:
    ld a,#LED_ON
    jra cmd 
eteint:
    ld a,#LED_OFF
    jra cmd
inverse:
    ld a,#LED_TOGGLE 
    jra cmd

bad_cmd: .ascii "Pas une commande.\n"
         .ascii "'a' pour allumer la LED.\n"
         .ascii "'e' pour eteindre la LED.\n"
         .ascii "'i' pour inverser l'etat de la LED.\n"
         .asciz "'q' pour quitter 'loop'.\n"
         
etat_led: .asciz "Etat LED: "
etat_on:  .asciz "on\n"
etat_off: .asciz "off\n"
