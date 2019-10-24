# Tutoriel assembleur sdas

## présentation

Utilisation du fichier [mona.asm](mona.asm) comme tutoriel de programmation en assembleur pour STM8 en utilisant sdas. Les deux documents requis pour suivre ce ditactitiel sont dans le dossier **docs**. Il s'agit de [asmlnk.txt](../docs/asmlnk.txt) qui documente l'assembleur. L'autre est le [manuel de programmation du STM8](../docs/pm0044_stm8_programming.pdf) qui est la référence pour la progammation des STM8. 

Un programme en assembleur contient les éléments suivants:
* Les commentaires qui débutent par le caractère **';'** et se terminent à la fin de la lgine.
* Les directives à l'assembleur ces directives commence toutes par un **'.'** suivit sans espace par le nom de la directive. La directive elle même peut-être suivit d'un certain nombre d'arguments. Exemple:
**.org 0x4000** ;déplace le pointeur de code à l'adresse 0x4000.
* la définition de symboles représentant des constantes.
* Les instructions machines. Il y a une instruction machine par ligne. Une instruction machine peut-être précédée par une étiquette qui représente une adresse de branchement ou la position d'une variable dans la RAM. Pour connaître les mnémoniques des instructions du STM8 il faut consulter le manuel de référence de programmation mentionné ci-haut.

Le fichier Makefile utilisé pour la construction du projet a été configuré pour que les fichiers générés par l'assembleur et le linker se retrouve dans le dossier **build**. Il y en a plusieurs mais on a pas vraiment besoin  de les consulter sauf peut-être le fichier [build/mona.lst](build/mona.lst) si on veut voir de quoi à l'air le code machine généré par l'assembleur.

Voici comment fonctionne la construction d'un projet. L'assembleur transforme le fichier source en un fichier de code binaire mais avec des adresses relatives [build/mona.rel](build/mona.rel) et génère aussi un listing appellé [build/mona.lst](build/mona.lst). Ensuite le linker (générateur de liens) utilise ces fichiers pour générer le fichier [build/mona.ihx](build/mona.ihx) qui contient le code binaire utilisé pour programmer le microcontrôleur. Le projet MONA contient un seul fichier source mais dans un projet plus complexe il y a plusieurs fichiers sources qui sont assemblés indépendemment les uns des autres et génèrent chacun des fichiers __*.rel__ et __*.lst__. Le travail du linker est de joindre tous ces bouts de codes ensemble en évitant les conflits d'adresses. S'il  n'y arrive pas il affiche un message d'erreur d'allocation.


## mona.asm

```
;  MONA   MONitor written in Assembly
	.module MONA 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
;	.list
	.page

```
A part les commentaires dans le bloc précédent on n'a que des directives destinées à l'assembleur. 

* **.module MONA** nomme simplement ce fichier.
* **.optsdcc -mstm8** indique à l'assembleur qu'il s'agit de code pour le STM8
* **.list** Cette directive indique simplement que les lignes de code suivantes n'apparaitrons pas dans le listing généré par l'assembleur. Ici la directive a été mise en commentaire et n'a donc aucun effet.
* **.include "../inc/nucleo_8s208.inc"**  informe l'assembleur qu'il doit traiter se fichier avant de continuer avec celui-ci. Ce fichier contient des informations spécifique à la carte NUCLE-8S208RB.
* **.include "../inc/stm8s208.inc"** informe l'assembleur qu'il doit traiter ce fichier avant de continuer avec celui-ci. Ce fichier contient toutes les constantes nécessaires à l'utilisation du mcu stm8s208. Ce fichier a été créé en consultant le datasheet du microcontrôleur et contient le nom de tous les registres de contrôle des périphériques avec leur adresse. Il contient aussi le nom symbolique des différents bits à l'intérieur de chacun de ces registres. L'utillisation de noms symboliques plutôt que des adresses simplifie grandement la programmation et rend le texte plus compréhensible.
* **.page** est une directive qui indique simplement à l'assembleur d'insérer un saut de page dans le listing qu'il génère.

```
;-------------------------------------------------------
;     vt100 CTRL_x  values
;-------------------------------------------------------
		CTRL_A = 1
		CTRL_B = 2
		CTRL_C = 3
		CTRL_D = 4
		CTRL_E = 5
		CTRL_F = 6
		CTRL_G = 7
		CTRL_H = 8
		CTRL_I = 9
		CTRL_J = 10
		CTRL_K = 11
		CTRL_L = 12
		CTRL_M = 13
		CTRL_N = 14
		CTRL_O = 15
		CTRL_P = 16
		CTRL_Q = 17
		CTRL_R = 18
		CTRL_S = 19
		CTRL_T = 20
		CTRL_U = 21
		CTRL_V = 22
		CTRL_W = 23
		CTRL_X = 24
		CTRL_Y = 25
		CTRL_Z = 26
		ESC = 27
		NL = CTRL_J
		CR = CTRL_M
		BSP = CTRL_H
		SPACE = 32

```
MONA communique avec le PC via un port sériel avec un émulateur de terminal VT100. Ici il s'agit simplement de définir des noms symboliques pour les codes de contrôles VT100.

```
;--------------------------------------------------------
;      MACROS
;--------------------------------------------------------
		.macro _ledenable ; set PC5 as push-pull output fast mode
		bset PC_CR1,#LED2_BIT
		bset PC_CR2,#LED2_BIT
		bset PC_DDR,#LED2_BIT
		.endm
		
		.macro _ledon ; turn on green LED 
		bset PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledoff ; turn off green LED
		bres PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledtoggle ; invert green LED state
		ld a,#LED2_MASK
		xor a,PC_ODR
		ld PC_ODR,a
		.endm
		
		
		.macro  _interrupts ; enable interrupts
		 rim
		.endm
		
		.macro _no_interrupts ; disable interrupts
		sim
		.endm


```

SDAS possède un langage de macro. Les macros en assembleurs simplifie grandements la programmation. Entre les directives **.macro** et **.endm**
on retrouve des instructions machines qui seront insérées dans le code source chaque fois que l'assembleur rencontre le nom de la macro. Les macros rendent le code plus lisible et évite aussi d'avoir à resaissir plusieurs foit les même lignes de codes qui se répètent dans un programme. Prenons par exemple la macro **_ledenable**. Les 3 instructions machine qu'elle contient servent à configuré la broche sur laquelle est branchée la LED2 en mode sortie push-pull. Cette macro n'est invoquée qu'une seule fois on aurait put inscrire directement ces 3 instructions directement à l'endroit où est invoquée cette macro ou encore en faire une sous-routine mais cette façon de faire est aussi valide. Les macros **_ineterrupts** et **_no_interrupts** ne contiennent qu'une seule instruction qu'on aurait pu inséré directement dans le code mais il me semble que ces noms de macros sont plus parlant que le mnémonique qu'elle remplace.

**_ledon** est invoquée pour allumer la LED2. **_ledoff** pour l'éteindre et **_led_toggle** pour en inverser l'état.

```
;--------------------------------------------------------
;        OPTION BYTES
;--------------------------------------------------------
;		.area 	OPTION (ABS)
;		.org 0x4800
;		.byte 0     ; 0x4800 ; OPT0 read out protection 
;		.byte 0,255 ; 0x4801 - 0x4802 OPT1 user boot code
;       .byte 0,255 ; 0x4803 - 0x4804 OPT2 alt. fct remapping 
;       .byte 0,255 ; 0x4805 - 0x4806 OPT3 watchdog options
;       .byte 0,255 ; 0x4807 - 0x4808 OPT4 clock options
;       .byte 0,255 ; 0x4809 - 0x480a OPT5 HSE clock startup
;       .byte 0,255 ; 0x480b - 0x480c OPT6 reserved
;       .byte 0,255 ; 0x480d - 0x480e OPT7 flash wait state
		.area BOOTLOADER (ABS)
		.org 0x487e
;       .byte 0,255 ; 0x487e - 0x487f rom bootloader checkpoint 

```
La directive **.area** permet de définir une zone mémoire. **OPTION** est le nom de cette zone et **(ABS)** indique que cette zone ne peut-être déplacée par le linker. Elle doit obligatoirement débutée à l'adresse indiquée par la directive **.org 0x4800**. Le mcu possède des registres de configurations qui permettent d'activer certaines options. Ces registres sont situés dans la plage **0x4800 - 0x487f**. Ici toutes les options sont mises en commentaire car elles ont toutes leur valeur par défaut. Comme il y a un espace d'adrsse inutilisée entre les 8 premières options et la dernière on doit créer une nouvelle région avec la directive **.area BOOTLOADER (ABS)**.  la directive **.org 0x487e** indique l'adresse où débute cette région.
La directive **.byte** sert à initialiser la mémoire avec les valeurs indiquées. Il s'agit de valeurs octets. Une directive **.word** est utilisée pour initialiser des mots de 16 bits.

```
;--------------------------------------------------------
;some sont constants used by this program.
;--------------------------------------------------------
		STACK_SIZE = 256 ; call stack size
		STACK_BASE = RAM_SIZE-STACK_SIZE ; lowest address of stack
		STACK_TOP = RAM_SIZE-1 ; stack top at end of ram
		TIB_SIZE = 80 ; transaction input buffer size
		PAD_SIZE = 80 ; workding pad size
```
 Quelques constantes utilisé par le programme.
```
;--------------------------------------------------------
;   application variables 
;---------------------------------------------------------		
        .area DATA
;ticks  .blkw 1 ; system ticks at every millisecond        
;cntdwn:	.blkw 1 ; millisecond count down timer
rx_char: .blkb 1 ; last uart received char
in.w:     .blkb 1 ; when 16 bits is required for indexing i.e. ld a,([in.w],y) 
in:		.blkb 1; parser position in tib
count:  .blkb 1; length of string in tib
idx_x:  .blkw 1; index for table pointed by x
idx_y:  .blkw 1; index for table pointed by y
tib:	.blkb TIB_SIZE ; transaction input buffer
pad:	.blkb PAD_SIZE ; working pad
acc16:  .blkw 1; 16 bits accumulator
ram_free_base: .blkw 1
flash_free_base: .blkw 1

```
Les variables utilisées par l'application MONA. **.area DATA** définie normalement une section de variables initialisées par la routine **crt0** lorsqu'on écris un programme en **C**. Mais ici les variables qui doivent-être initialisées le sont dans la procédure **init0**. Une directive **.blkb** ser à réserver un bloc de n octets. L'argument qui suit indique le nombre d'octets à réserver. La directive **.blkw** sert à réserver un bloc de mots de 16 bits.
```
		.area USER_RAM_BASE
;--------------------------------------------------------
;   the following RAM is not used by MONA
;--------------------------------------------------------
 _user_ram:		
```
La mémoire RAM après les variables utilisées par MONA est disponible pour l'utilisateur. L'Étiquette **_user_ram:** permet au programme de connaître l'adresse de début de cette zone mémoire et de l'utiliser pour initialiser 
la variable **ram_free_base**.
```
;--------------------------------------------------------
;  stack segment
;--------------------------------------------------------
       .area SSEG  (ABS)
	   .org RAM_SIZE-STACK_SIZE
 __stack_bottom:
	   .ds  256
```
La pile des appels est située à la fin de la mémoire RAM. Il s'agit d'une pile décroissante. C'est à dire que le pointeur de pile **SP** est décrémenté après chaque empilement d'un octet de sorte que **SP** pointe toujours sur le prochain octet libre. La directive **.ds 256** réserve 256 octets pour la pile.
```
;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int init0 ;RESET vector
	int NonHandledInterrupt ;TRAP  software interrupt
	int NonHandledInterrupt ;int0 TLI   external top level interrupt
	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
	int NonHandledInterrupt ;int2 CLK   clock controller
	int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
	int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
	int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
	int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
	int NonHandledInterrupt ;int7 EXTI4 port E external interrupts
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
	int uart_rx_isr         ;int21 UART3 RX full
	int NonHandledInterrupt ;int22 ADC2 end of conversion
	int NonHandledInterrupt	;int23 TIM4 update/overflow
	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
	int NonHandledInterrupt ;int25  not used
	int NonHandledInterrupt ;int26  not used
	int NonHandledInterrupt ;int27  not used
	int NonHandledInterrupt ;int28  not used
```
 La section **HOME** indique qu'il s'agit de la table des vecteurs d'interruption. En fait le premier vecteur est celui de la réinitialisation. Le deuxième celui de l'interruption logicielle.
 Tous les autres correspondes aux périphériques. MONA n'utilise qu'une seule interruption celle générée par la réception d'un caractère par le UART3.
 Les autres interruption pointent vers **NonHandledInterrupt**.
 Les vecteurs sont en fait des instruction **JPF** (jump far). Cette instruction occupe 4 octets. Le code **0x82** suivit d'une adresse de 24 bits. 
```
	.area CODE

	;initialize clock to HSE 16Mhz
clock_init:	
	bset CLK_SWCR,#CLK_SWCR_SWEN
	ld a,#CLK_SWR_HSE
	ld CLK_SWR,a
1$:	cp a,CLK_CMSR
	jrne 1$
	ret

		; initialize TIMER4 ticks counter
;timer4_init:
;	clr ticks
;	clr cntdwn
;	ld a,#TIM4_PSCR_128 
;	ld TIM4_PSCR,a
;	bset TIM4_IER,#TIM4_IER_UIE
;	bres TIM4_SR,#TIM4_SR_UIF
;	ld a,#125
;	ld TIM4_ARR,a ; 1 msec interval
;	ld a,#((1<<TIM4_CR1_CEN)+(1<<TIM4_CR1_ARPE)) 
;	ld TIM4_CR1,a
;	ret

	; initialize UART3, 115200 8N1
uart3_init:
;	bset CLK_PCKENR1,#CLK_PCKENR1_UART3
	; configure tx pin
	bset PD_DDR,#BIT5 ; tx pin
	bset PD_CR1,#BIT5 ; push-pull output
	bset PD_CR2,#BIT5 ; fast output
	; baud rate 115200 Fmaster=8Mhz  8000000/115200=69=0x45
	mov UART3_BRR2,#0x05 ; must be loaded first
	mov UART3_BRR1,#0x4
	mov UART3_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN))
	ret
	
	; pause in milliseconds
    ; input:  y delay
    ; output: none
;pause:
;	 ldw cntdwn,y
;1$: ldw y,cntdwn
;	 jrne 1$
;    ret

;-------------------------
;  zero all free ram
;-------------------------
clear_all_free_ram:
	ldw x,#0
1$:	
	clr (x)
	incw x
	cpw x,#STACK_TOP-2
	jrule 1$
	ret
```
La section **CODE** est la où débute vraiment le du programme. Ce n'est pas forcément le point d'entré du programme. Ce point d'entré peut-être placé n'importe où. Dans le cas de MONA il s'agit de la routine **init0** qui est située plus loin. J'ai choisi de placer les routines appellées par **init0** au début. On a donc
* **clock_init** qui initialise l'horloge utilisé par le programme. Il s'agit dans ce cas de l'oscillateur externe **HSE** et puisque le cristal qui branché broches de cet oscillateur est de 8Mhz le MCU fonctionne à cette fréquence même s'il est possible de le faire fonctionner jusqu'à 20Mhz.
Notez l'utilisation d'étiquettes de la forme **n$** ou **n** est un entier  dans l'intervalle **[0-65535]**. J'utilise cette forme d'étiquette pour les sauts relatif à l'intérieur des sous-routines. L'aventage est qu'on peut utiliser plusieurs fois le même nom. L'assembleur les traites comme des étiquettes spéciales qui sont utilisées à l'intérieur d'un bloc de code délimité par 2 étiquettes normales. Ces étiquettes sont supprimées chaque fois qu'une étiquette normale est rencontré. Dans le code montré ci-haut l'étiquette **1$** qui apparaît après **clock_init** n'est visible pour l'assembleur que jusqu'à l'apparition de **uart3_init**. Donc on pourrait la réutilisée dans la sous-routine **uart3_init** sans qu'elle entre en conflit avec la première instance.

* **timer4_init** sert à initialiser cette minuterie pour générer une interruption à intervalle d'une miliseconde. Elle a été mise en commentaire car elle n'est pas utilisée dans cette version de MONA.

* **uart3_init** sert à initialiser le périphérique de communication sériel utilisé pour communiquer avec le PC. la configuration est de 115200 BAUD 8 bits 1 stop bit pas de parité.
* **pause**  sert à créer un délais mais est mise en commentaire car elle n'est pas utilisée dans cette version de MONA
* **clear_all_free_ram** sert à mettre à zéro toute la mémoire RAM. Notez que la boucle s'arrête à TOP_STACK-2. On ne veut pas écraser l'adresse de retour qui a été empilée lors de l'appel de cette sous-routine. Notez la réutilisation de l'étiquette **1$:** sans conflit avec son utilisation dans **clock_init**.

```
init0:
	; initialize SP
	ldw x,#STACK_TOP
	ldw sp,x
	_no_interrupts
	call clock_init
	call clear_all_free_ram
;	clr ticks
;	clr cntdwn
	ld a,#255
	ld rx_char,a
;	call timer4_init
	call uart3_init
	_ledenable
	_ledoff
	clr in.w ; must always be 0
	; initialize free_ram_base variable
	ldw y,#_user_ram ;#ram_free_base
;	addw y,#0xf
;	ld a,yl
;	and a,#0xf0
;	ld yl,a
	ldw ram_free_base,y
	; initialize flash_free_base variable
	ldw y,#flash_free
	addw y,#0xff
	clr a
	ld yl,a
	ldw flash_free_base,y
```
La routine **init0** est le point d'entrée de MONA. C'est ici que le vecteur RESET fait un saut lors du démarrage du MCU.  La première opération consiste à initialisé le pointeur de pile **SP**. Ensuite on s'assure que les interruptions sont déscativées en invoquant la macro **_no_interrupts**. Suit un appel à **clock_init** pour commuter de l'oscillateur interne **HSI** à l'osciallateur externe **HSE**. À partir de là le MCU fonctionne à 8Mhz. Ensuite on appel **clear_all_free_ram** pour mettre toute la RAM à zéro. J'ignore les instructions commentées. On met la valeur **255** dans la variable **rx_char** qui contient le dernier caractère reçu par le UART3. La valeur 255 signifie qu'il n'y a pas de caractère reçu. On appel ensuite **uart3_init** pour initialiser le périphérique de communication.

Sur la carte la **LED2** est branchée à la pin 5 du port C. Il faut donc initialisé cette pin en mode sortie. C'est ce qui est fait par l'invocation de la macro **_ledenable**. Ensuite on s'assure que la LED est éteinte en invoquant la macro **_ledoff**.  Notez que j'utilise le caractère **'_'** comme premier caractère des noms de macros. Ça me permet de savoir au premier coup d'oeil qu'il s'agit bien d'une macro.

Le reste de la cette routine conssiste à initialiser les différentes variables.
```
main:
	_interrupts ; enable interrupts
	; print startup message
	ld a,#0xc
	call uart_tx
	ldw y,#VERSION
	call uart_print
	ldw y,#RAM_FREE_MSG
	call uart_print
	ldw y,ram_free_base
	ld a,#16
	call itoa
	call uart_print
	ldw y,#RAM_LAST_FREE_MSG
	call uart_print
	ldw y,#FLASH_FREE_MSG
	call uart_print
	ld a,#16
	ldw y,flash_free_base
	call itoa
	call uart_print
	ldw y,#EEPROM_MSG
	call uart_print
	; read execute print loop
repl:
	ld a,#NL
	call uart_tx
	ld a,#'>
	call uart_tx
	call readln
	tnz count
	jreq repl
	clr in
	call eval
	jra repl
```
L'initialisation est terminée on est rendu à la routine principale du programme. 





