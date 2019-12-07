# fonctions de la librairie uart.lib

## constantes 
Ces constantes sont définies dans le fichier **stm8s208.inc**.

## identifiants des périphériques uart 
Toutes les fonctions utilisent un identifiant uart comme dernier argument.
### UART1 = 0 
### UART3 = 1 

## constantes pour les vitesses BAUD 
Utitilsé par **uart_init** pour configurer la vitesse de tansmission.
### B2400=0
### B4800=1
### B9600=2
### B19200=3
### B38400=4
### B57600=5
### B115200=6
### B230400=7
### B460800=8
### B921600=9

# Fonctions 
Les arguments des fonctions sont passés sur la pile. L'empilement se fait selon la convention utilisée par **SDCC** pour **STM8**, soit de droite vers la gauche. Les valeurs de retour respectent la même convention. Soit **A** pour les valeurs octets, **X** pour les valeurs **int**, **X:YL** pour les valeurs de 24 bits et **X:Y** pour les valeurs de 32 bits.

Le contenu du regisrete **A** n'est jamais préservé mais les registres **X** et **Y** le sont lorsqu'ils sont utilisés sauf dans le cas de **uart_init()**.

## void uart_delete(uint8_t n,uint8_t uart_id)

Efface **n** caractères sur le console terminal à gauche du curseur.
l'effacement est produit par l'envoie d'une séquence de 3 caractères ASCII: **BKSP**,**SPACE**,**BKSP**. Cet séquence est envoyée **n** fois.

## int uart_getc(uint8_t uart_id) 

Attend un caractère en provenance du uart désigné par **uart_id**.
le caractère est retourné dans le registre **X**.

## void uart_init(uint8_t baud,uint8_t uart_id)
Initialise le périphérique uart désigné par **uart_id** à la vitesse indiquée par a constante **baud**. La configuration est **8N1**. Il n'y a pas de parité ni de contrôle de flux. Les interruptions ne sont pas utilisées.

## char uart_putc(char c, uint8_t uart_id)
Envoie le caractère **c** au uart désigné par **uart_id**. Le caractère envoyé est retourné tel quel dans **A**. 

## void uart_puts(char* str,uint8_t uart_id)
Envoie une chaîne de caractère terminée par un zéro au uart désigné par **uart_id**.  

## char uart_query(uint8_t uart_id)
Vérifie s'il y a un caractère de disponible sur le uart identifié par **uart_id**. Retourne **0** ou le caractère s'il y en a un de disponible.
Il n'y a pas d'attente.

## void uart_spaces(uint8_t n,uint8_t uart_id)
Envoie **n** espaces au uart désigné par **uart_id**. 


# utilisation des fonctions en assembleur

Il suffit de respecter la convention utilisée par le compilateur SDCC. Voici un exemple d'appel de la fonction **uart_puts()** en assembleur.
```
; imprime 'hello world!" sur le terminal.
puts_test:
     ld a,#UART3 ; empile uart_id
     push a 
     ldw x,#hello ; empile char* str
     pushw x
     call uart_puts  
     addw sp,#3 ; libère l'espace utilisé par les arguments
     ret

hello: .asciz "hello world!\n"     

```

