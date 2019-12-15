# test_help 

Ce texte explique comment utiliser [test_help.asm](test_help.asm) pour assister le débogage des librairies. 

## Utilisation 

Le programme [test_help](test_help.asm) doit-être lié avec le programme de test de l'application. Ce programme exporte des fonctions qui permettent d'envoyer de l'information à un terminal en utilisant le périphérique **UART3** du **stm8s208R**. Le fichier [test_help.inc](test_help.inc) contient un ensemble de macros pour simplifier son utilisation. 

[test_help](test_help.asm) contient une facilité pour créer un minishell de commande dans le programme de test. Les tests peuvent donc être interactifs en utilisant un émulateur de terminal sur le PC branché au **UART3** de la carte **NUCLEO**. La configuration est de 115200 BAUD 8N1, pas de contrôle de flux. 

## Comment construire une application de test

### Makefile exemple 
Le code de test doit exporter une fonction appelée **test_main** qui est invoquée à partir de la fonction **main** contenue dans [test_help](test_help.asm).  La construction de l'application de test est simplifiée par l'utilisation de l'utilitaire **make** sous linux. À titre d'exemple voici le fichier [string/Makefile](string/Makefile) de la librairie [string/string.asm](string/string.asm).
```
#############################
# uart make file
#############################
NAME=string
LIBNAME=$(NAME).lib 
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
CFLAGS=-mstm8 -DSTM8S208 -I ../../inc
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
LIB_PATH=../../lib/
ASM_SRC=$(NAME).asm
C_SRC=
C_HEADERS=$(C_SRC:.c=.h)
OBJECTS=$(BUILD)$(ASM_SRC:.asm=.rel)
LIB=$(LIB_PATH)$(LIBNAME)
LIBREL=$(LIBNAME:.lib=.rel)
SYMBOLS=$(OBJECTS:.rel=.sym)
LISTS=$(OBJECTS:.rel=.lst)
FLASH=stm8flash
BOARD=stm8s208rb
PROGRAMMER=stlinkv21
TARGET=$(BUILD)string_test.ihx 
TEST_HELP=../build/test_help.rel
TEST_NAME=string_test

.PHONY: all

all: title clean archive

.PHONY: archive 

archive: $(LIBREL) 
	@echo
	@echo "****************************"
	@echo "creating $(LIBNAME) archives"
	@echo "****************************"
	$(SDAR) -rc $(LIB) $(BUILD)$(LIBREL)


.PHONY: title
title:
	@echo
	@echo "*****************"
	@echo "creating $(NAME)"
	@echo "*****************"

 
$(NAME).rel:
	@echo
	@echo "*****************"
	@echo "assembling $(ASM_SRC)"
	@echo "*****************"
	$(SDAS) -g -l -o $(OBJECTS) $(ASM_SRC)

.PHONY: test 

test: $(LIB)
	@echo
	@echo "*****************"
	@echo "creating test    "
	@echo "*****************"
	$(SDAS) -g -l -o $(BUILD)$(TEST_NAME).rel $(TEST_NAME).asm 
	$(SDCC) $(CFLAGS) -L$(LIB_PATH) -lmath24 -lstring -lconio -luart -o$(TARGET) $(TEST_HELP) $(BUILD)$(TEST_NAME).rel
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(TARGET)


.PHONY: clean 
clean: build
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*


build:
	mkdir build

```

Pour construire et progammer sur la carte **NUCLEO** avec le programme [string_test](string_test.asm) il suffit à partir du dossier **string** de faire la commande:
```
make test 
```

## Macros de test_help 

Le fichier [test_help.inc](test_help.inc) contient les macros suivantes:
```
    .macro _dbg 
    DEBUG=1
    .endm

    .macro _nodbg
    DEBUG=0
    .endm 

    DBG_CC=6
    DBG_A=5 
    DBG_X=3 
    DBG_Y=1 
    .macro _dbg_save_regs 
    .if DEBUG
    push cc ; (6,sp)
    push a   ; (5,sp)
    pushw x  ; (3,sp)
    pushw y  ; (1,sp)
    .endif 
    .endm 

    .macro _dbg_restore_regs 
    .if DEBUG 
    popw y 
    popw x 
    pop a 
    pop cc 
    .endif 
    .endm 

    .macro _dbg_getc 
    .if DEBUG 
    _dbg_save_regs 
    call uart3_getc
    ld (DBG_A,sp),a 
    _dbg_restore_regs  
    .endif
    .endm 

    .macro _dbg_putc 
    .if DEBUG
    _dbg_save_regs  
    call uart3_putc 
    _dbg_restore_regs 
    .endif 
    .endm 

    .macro _dbg_puts 
    .if DEBUG 
    _dbg_save_regs
    call uart3_puts 
    _dbg_restore_regs
    .endif 
    .endm 

    .macro _dbg_prti24 
    .if DEBUG 
    _dbg_save_regs
    call uart3_printi24 
    _dbg_restore_regs
    .endif
    .endm 

    .macro _dbg_prt_regs
    .if DEBUG
    _dbg_save_regs
    call uart3_ptr_regs 
    _dbg_restore_regs 
    .endif 
    .endm 

    .macro _dbg_peek addr 
    .if DEBUG
    _dbg_save_regs 
    ldw x,addr 
    call uart3_peek     
    _dbg_restore_regs
    .endif 
    .endm 

    .macro _dbg_parser_init 
    .if DEBUG 
    _dbg_save_regs
    call parser_init 
    _dbg_restore_regs
    .endif
    .endm

    .macro _dbg_readln
    .if DEBUG 
    _dbg_save_regs
    call uart3_readln
    _dbg_restore_regs
    .endif
    .endm

    .macro _dbg_number 
    .if DEBUG 
    _dbg_save_regs
    call number 
    _dbg_restore_regs
    .endif
    .endm  

    .macro _dbg_nextword
    .if DEBUG 
    _dbg_save_regs
    call next_word  
    _dbg_restore_regs
    .endif
    .endm  
```
Ces macros préservent l'état des registres incluant le registre **CC**. 

### _dbg 

Active le débogage en mettant la constante **DEBUG** à **1** ce qui permet l'assemblage conditionnel des autres macros.

### _nodbg 

Désactive le débogage en mettant la constante **DEBUG** à **0** ce qui empèche l'assemblage des macros de débogage.

### _dbg_save_regs 

Sauvegarde sur la pile l'état des registes **CC,A,X,Y** 

### _dbg_restore_regs 
Restore l'état des registres précédemment sauvegardés avec **_dbg_save_regs**

### _dbg_getc

Attend un caractère du **UART3**. Le caractère est retournée dans le registre **A**. 

### _dbg_putc 
Envoie le caractère qui est dans **A** au **UART3**. 

### _dbg_puts 

Envoie via le **UART3** une chaîne de caractères ASCIZ pointée par le registe **Y**. 

### _dbg_prti24

Envoie la représentation texte  ASCII d'un entier 24 bits via le **UART3**. L'entier doit-être dans la variable globale **acc24**. 

Le registre **A** doit contenir la base numérique utilisée pour la conversion en chaîne et **XL** contient la largeur du champ réservé pour cette chaîne de caractère. Si la conversion donne une chaîne plus courte que ce qui est spécifié dans **XL** la chaîne est comblée à gauche par des espaces.  

### _dbg_prt_regs 
Imprime l'état des registres internes du CPU sans en altérer le contenu.

### _dbg_peek addr 

Imprime en hexadécimal et décimal le contenu à l'adresse spécifiée. 

### _dbg_parser_init 
Pour faire des tests interactif il faut une interface avec l'utilisateur. Dans ce but [test_help](test_help.asm) contient une fonction **uart3_readln** et les fonctions d'analyse lexicales **next_word** et **number**. **parser_init** initialize l'analyseur lexical avant son utilisation pour l'analyse d'une nouvelle ligne. 
### _dbg_readln
Permet de lire une ligne de texte à partir du **UART3**. Cette ligne est déposée dans la variable globale **tib**.
### _dbg_nextword
Extrait le prochain mot de **tib** et le dépose dans la tampon **pad**.
### _dbg_number
Lorsqu'on attend un entier comme prochain mot sur la ligne de commande. On utilise cette macro pour l'extraire et le déposer dans **acc24**. 


## Variables exportées par [test_help](test_help.asm)

### acc24
Variable utilisée par **uart3_prti24**  cette variable est décomposée en octets en utilisant les variables supplémentaires **acc16** et **acc8**. Il faut concevoir ces 3 variables comme une structure en **C**. Il n'y a pas d'espace entre chaque octet donc l'instruction assembleur **ldw x,acc24** dépose acc24:acc16 dans le registre **X**. idem pour **ldw x,acc16** qui dépose **acc16:acc8** dans le registre **X**.
```    
struct{
    uint8_t acc24;
    uint8_t acc16; 
    int8_t acc8;
} acc24_t; 
```

### tib 
Variable tampon utilisée par **uart3_readln**. Ce tampon reçoit la ligne lue au terminal. La taille du tampon est de 80 octets.

### pad 
Variable tampon utilisée pour l'extraction des mots de la ligne lue dans **tib**. La taille du tampon est de 80 octets. 

## les fonctions exportées par [test_help](test_help.asm) 

### ledon 
Ne prend aucun argument et sert à allumer la LED2 sur la carte NUCLEO.

### ledoff 
 Ne prend aucun argument et sert à éteindre la LED2 sur la carte NUCLEO.

### ledtoggle 
Ne prend aucun argument et sert à inverser l'état de la LED2 sur la carte NUCLEO. 

### uart3_getc 
Ne prend aucun argument. Attend la réception d'un caractère à partir du **UART3**. Le caractère est retourné dans le regsitre **A**. Ne pas utiliser cette fonction directement mais plutôt la macro **_dbg_getc**.

### uart3_putc 
Prend le caractère dans le registre **A** et l'envoie via le **UART3**. 
Ne pas utiliser cette fonction directement mais utiliser la macro **_dbg_putc**. 

### uart3_puts 
Envoie via le **UART3** une chaîne ASCIZ. Le pointeur de cette chaîne doit-être dans le registre **Y**. 

### uart3_prti24 
Convertie l'entier 24 bits contenu dans **acc24** en chaîne ASCIZ et envoie le résultat via **UART3**. le registre **A** doit contenir la base numérique pour la conversion et le registre **XL** la largeur minimal du champ. Ne pas utiliser directment cette fonction mais plutôt la macro **_dbg_ptri24**. 

### uart3_prt_regs 
Ne prend aucun argument. Imprime l'état des registes du CPU au point d'appel. Ne doit pas être utilisé directement mais via la macro **_dbg_prt_regs** 

### uart3_peek 
Imprime en hexadécimal et décimal le contenu de l'adresse spécifiée dans **X**.     

### parser_init
Initialise l'analyseur lexical pour la prochaine extraction des mots dans **tib**. Ne doit pas être appellée directement mais plutôt avec la macro **_dbg_parser_init**.

### uart3_readln
Effectue la lecture d'une ligne de texte à partir d'un terminal connecté à **UART3** de la carte **NUCLEO**. Cette ligne est déposée dans le tampon pointé par la variable globale **tib**. Ne doit pas être appellée directement mais plutôt avec la macro **_dbg_readln**.

### next_word
Extrait le mot suivant du tampon **tib** pour le déposé dans le tampon **pad**.Ne doit pas être appellée directement mais plutôt avec la macro **_dbg_nextword**. 

### number 
Lorsqu'on s'attend à ce que le prochain mot dans **tib** soit un entier on utilise cette fonction pour l'extraire et le déposer dans **acc24**. Ne doit pas être appellée directement mais plutôt avec la macro **_dbg_number**.

## Interrupt par trap

Il est possible d'utiliser l'instruction **trap** pour interrompre le programme de test pour aller sur une ligne de commande simple. Cette ligne de commande n'accepte que 3 commandes:
* 'q' pour retourner dans le programme test au point d'arrêt.
* 'p [addr]' pour afficher le contenu de 8 adresses consécutives. 'p' sans arguments affiche les 8 adresses suivantes.
* 's addr'  pour imprimer la chaîne ASCIZ qui se trouve à l'adresse donnée. On l'utilise lorsqu'on s'attend à que l'adresse en question contienne une chaîne ASCIZ. 




