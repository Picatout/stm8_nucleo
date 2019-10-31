# Chapitre 2, interruption et mode HALT

Dans cette expérience je voulais vérifier les interruptions externes en utilisant le bouton utilisateur sur la carte (bouton bleu) qui est branché sur le GPIO PE_4. J'ai programmé PE_4 pour déclencher une interruption externe lorsque le bouton est enfoncé. Les interruption externes sur le port PE déclenchent **EXTI4**. 

Le programme bascule l'état de la LED2 chaque fois que le bouton est enfoncé.  LE MCU est mis en mode HALT entre chaque intervention. lorsque l'instruction machine **halt** est exécutée tous les signaux d'horloges du MCU sont arrêtés ce qui réduit la consommation électrique au minimum.

Je voulais savoir si à la sortie de l'interruption le MCU retournais en mode **HALT**. Ce n'est pas le cas il exécute plutôt l'instruction qui suit le **halt**. Donc il a fallu que je fasse une boucle pour revenir à l'instruction **halt**.

Donc le programme fonctionne de la façon suivante. Après l'initialisation l'instruction **halt** est exécutée ce qui arrête le MCU. Lorsque le bouton est enfoncé la routine d'interruption **usr_btn_isr** est exécutée et lorsqu'elle se termine le cpu exécute l'instruction **jra 1$** dans la procédure **main**. Ce qui ramène le cpu à l'instruction **halt**.

Par rapport au programme du chapitre il n'y a pas de nouvelles directives d'assembleur mais la routine d'interruption suivante a été ajoutée.
```
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       gestionnaire d'interruption pour le bouton USER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
usr_btn_isr:
    _led_toggle
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
3$: iret
```
Lorsqu'un contact électrique est activé il y a toujours un rebond du contact. Cet effet de rebond peut déclencher l'interruption à plusieurs reprise. Si elle est déclenchée un nombre pair de fois lorsque le bouton est enfoncé l'état de la LED2 ne changera pas. C'est pourquoi j'ai ajouter du code supplémentaire pour attendre que les rebonds soient terminés avant de sortir de l'interruption.

