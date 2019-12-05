[licence: CC-BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/fr/) 

# Interface entre fonctions en 'C' et en assembleur

Dans ce chapitre on examine la façon de créer une application qui comprend un mélange de modules écris en **C** et en assembleur. Le programme démo comprend un fichier en assembleur [ch5_asm.asm](ch5_asm.asm) et un fichier en **C** [ch5_c.c](ch5_c.c). De plus la librairie **uart** est utilisée par les 2 modules.

## module en assembleur.

Pour interfacer entre **asm** et **C** il faut respecter un ensemble de conventions. 

* Les fonctions en assembleur qui doivent-être appellées par le code en **C** doivent avoir un nom qui débute par un soulignement **'_'**, par exembple **_uart_puts** . En examinant le code source de [uart.asm](../libs_src/uart/uart.asm) vous allez constatez que j'ai donné 2 noms à chaque fonction exportée. C'est le même nom sauf pour le premier caractère qui est un **'_'**. Dans le programme en **C** on utilise le nom sans le caractère **'_'**. C'est le compilateur qui ajoute ce caractère au début des fonctions globales. Si la fonction **main()** est dans un module écris en assembleur elle doit-être identifiée par **_main::**. 

* pour l'assembleur les étiquettes globales doivent se terminées par **::**.

* Les fonctions qui sont appellées par du code écris en **C** doivent respectés les conventions d'appel utilisé par SDCC pour stm8. Cette convention est à l'effet que les arguments sont passés sur la pile en empilant la liste de arguments de la droite vers la gauche.

* Les fonctions en **C** retourne la valeur de retour dans les registres du CPU de la façon suivante.
    * valeur d'un octet retournée dans **A** 
    * valeur de 16 bits retournée dans **X**
    * valeur de 24 bits retrournée dans **X:YL** 
    * valeur de 32 bits retournée dans **X:Y** 

## Organisation du démo.

### Le module en 'C'

La fonction **main()** est écrite dans le module [chr_c.c](ch5_c.c) les fonctions en assembleur appellées par le code en **C** sont les suivantes:
```
// prototype des fonctions en assembleur 
// fonctions dans uart.lib
void uart_init(uint8_t baud,uint8_t uart_id);
void uart_puts(char *str,uint8_t uart_id);
// fonctions dans ch4_asm.asm
void clock_init(void);
void led_init(void);
void loop(char *msg);
```
Les deux premières sont dans la librairie [uart.lib](../lib/uart.lib) et les 3 autres dans le module [ch5_asm.asm](ch5_asm.asm). Il faut évidemment fournir le prototype de ces fonctions pour que le compilateur sache comment les utilisées.
```
void main(void){
    clock_init();
    led_init();
    uart_init(B115200,UART3);
    uart_puts("\n\nAppel de la fonction 'loop' dans ch5_asm.asm\n",UART3);
    loop("Maintenant sur la ligne de commande de 'loop'.\n");
    uart_puts("sortie de la fonction loop.\nDe retour dans main().\n",UART3);
    uart_puts("Pressez le bouton RESET pour recommencer.\n",UART3);
    while(1);
}

```
La fonction main() commence par appeler les fonctions d'initialisation du MCU **clock_init(), led_init() et uart_init()**. Ensuite un message est envoyé au terminal. Finalement la fonction **void loop(char *)** qui est dans le module en assembleur est appelée. Lorsque la fonction en assembleur quitte de l'information supplémentaire est envoyé au terminal.

### Le module en assembleur

Ce module contient les fonctions d'initialisation du MCU ainsi que la fonction **_loop::** qui est appelée par le programme en **C**. **loop** reçoit des commandes simples pour contrôler l'état de la LED2 qui est sur la carte STM8-NUCLEO. 

```
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
```
Puisque **loop** est une fonction à 1 argument qui est un pointeur vers une chaîne à imprimer sur le terminal. Le compilateur réserve de l'espace sur la pile pour cet argument. 

* **ARG_OFS** est le décalage de 2 octets causé par l'appel de la fonction. Ces 2 octets contiennennt l'adresse de retour de la fonction. L'argument __char*__ se retrouve donc à la position **CHR_PTR=ARG_OFS+1**. Il s'agit de la position relative par rapport à la valeur de **SP** au moment d'entrer dans la fonction **loop**. La première chose que fait **loop** est de récupérer cet argument pour le mettre dans **Y** avant d'appeller **puts**. Afin de simplifier l'utilisation des fonctions de la librairie **uart** j'ai créer des fonctions **wrapper**  qui se charge préparer les arguments des fonctions de la librairie. Voici le code de  **puts**. 
```
; imprime chaîne pointée par Y
puts:
    push #UART3
    pushw y 
    call uart_puts 
    _drop 3
    ret 
```
Cette façon de faire simplifie l'utilisation  en assembleur des foinctions de la librairie **uart**. 

**_drop** est une macro qui simplifie la libération de l'espace réservé pour les arguments d'appel de fonctions. Cette macro remplace simplement une instruction **addw sp,#n**. 

### Appel vers une fonction écrite en **C**.

Dans le module écris en **C** on retrouve la fonction **uint8_t led_switch(uint8_t state)**. Cette fonction est appellée depuis le module écris en assembleur pour contrôler la LED. Cette fonction accepte un seul argument d'un octet qui est une des constantes **LED_OFF, LED_ON, LED_TOGGLE**. 
La fonction retourne l'état de la LED après application de la commande. Le programme en assembleur récupère cette valeur de retour et affiche l'état de la LED sur le terminal. 
```
Appel de la fonction 'loop' dans ch5_asm.asm ...
Maintenant sur la ligne de commande de 'loop'.
?a
Etat LED: on
?e
Etat LED: off
?i
Etat LED: on
?i
Etat LED: off
?z
Pas une commande.
'a' pour allumer la LED.
'e' pour eteindre la LED.
'i' pour inverser l'etat de la LED.
'q' pour quitter 'loop'.
?q
... sortie de la fonction loop.
De retour dans main().
Pressez le bouton RESET pour recommencer.

```

## Libération de l'espace des arguments

En **assembleur** ou en **C** c'est la fonction qui fait l'appel à une autre fonction qui est responsable de libérer l'espace utilisée pour le passage des arguments. En **C** le compilateur gère ces détails mais en assembleur c'est le programmeur qui est responsable de cette tâche. Un mauvais équilibrage de la pile occasionne habituellement un plantage de l'application ou à tout le moin un comportement très bizarre. Cette tâche étant répétive elle peut-être simplifiée par l'écriture des macros par exemple pour le projet MONA j'ai utilisé les 2 macros suivantes dans **mona_dasm.asm**.
```
; lsize est la taille réservé pour les variables locales
; name est le nom de la fonction 
    .macro _fn_entry lsize name
    LOCAL_SIZE = lsize
    STRUCT=3+LOCAL_SIZE
name:
    sub sp,#LOCAL_SIZE
    .endm

    .macro _fn_exit 
    addw sp,#LOCAL_SIZE 
    ret
    .endm

``` 
Et voici un exemple d'utilisation. **SPC,MNEMO et IMM8** sont des variables locales à la fonction **fn_imm8**. La valeur **4** est la taille en octets réservé sur la pile pour ces variables. Ces constantes sont des déplacements relatif par rapport à la valeur de **SP**. 
``` 
    SPC=1
    MNEMO=2
    IMM8=4
_fn_entry 4 fn_imm8 
    call get_int8
    ld (IMM8,sp),a 
    ldw y,(STRUCT,sp)
    call ld_mnemonic
    ldw y,#fmt_op_imm8 
    call format 
_fn_exit
``` 
Ces macros peuvent-être adaptées facilement à différentes situations.

## Makefile 
Le fichier [makefile](Makefile) permet de simplifier la construction du démo. en faisant **make flash** sur la ligne de commande le programme est compilé et programmé sur la carte automatiquement. 

## Conclusion

Je pense qu'en étudiant le code source des 2 fichiers du démo vous aurez une bonne compréhension de la méthode utilisée pour interfacer des modules **asm** et **C**.  L'étude du **Makefile** vous permettra de comprendre comment le construire. Notez que le module en **C** est compilé seulement en ajoutant l'option **-c** dans la ligne de commande de **sdcc**. Ceci est nécessaire car il faut lier le fichier ch5_adm.rel avec le fichier ch5_c.rel dans une étape suivante. 

