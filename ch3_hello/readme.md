# Chapitre 3,  mémoire étendue.

Démonstration de l'utilisation de la mémoire étendu aussi bien pour les données que pour le code.

## Le compteur ordinal

Le compteur ordinal du STM8 est de 24 bits ce qui permet d'adresser 16Mo cependant il n'y a que 5 instructions machine qui modifient les 8 bits supérieur du compteur ordinal **PCE** dans la nomenclature de ST. Ces instrucitons sont:

* **INT**  *interruption*. Utilisée seulement dans la table des vecteurs d'interruption. Une interruption sauvegarde les 3 octets du compteur ordinal **PCL,PCH et PCE**. Ce 3 octets sont remplacés par l'adresse de 24 bits indiquée dans la table. Ça implique que la routine de **RESET** et les routines d'interruptions peuvent-être installées n'importe où dans la mémoire FLASH. 

* **IRET** *sortie d'interruption*. C'est l'instruction utilisée pour sortir des interruptions. Cette instruction restaure les 9 octets sauvegardés sur la pile par **INT**.

* **CALLF**  *appel sous-routine éloigné*. Appel avec adresse de 24 bits à une sous-routine. Cet appel sauvegarde les 3 octets de **PC** sur la pile. Peut atteindre tout l'espace d'adressage.

* **RETF** *sortie d'une routine éloignée*. Il faut utiliser cette instrcution pour sortir d'une sous-routine appellée par **CALLF** sinon plantage assuré.

* **JPF**  *Saut éloigné*. Saut avec adresse étendue de 24 bits. Peut atteindre tout l'espace d'adressage.

### Les problèmes possibles

* Une routine chevauche deux segments de mémoire, un segment c'est 64Ko, soit ce qui est adressable avec 16 bits. Supposons que la routine commence à l'adresse 0xff00 et se termine à l'adresse 0x100a0. Cette routine ne peut-être appellée par un **CALL** car si elle se termine avec un **RET** le PCE est à **0** à son point d'entrée mais à **1** à son point de sortie. Comme l'instruction **RET** ne restaure que **PCH:PCL** retour se fait à **0x1MMLL** au lieu de **0x0MMLL**. Donc une routine qui chevauche 2 segments doit être appellée par un **CALLF** et se terminer par un **RETF**.

* Une routine qui se termine par un **CALL** ne peut-être appellée que par une autre routine qui est dans le même segment et elle doit se terminer par un **RET**. 

* Si une routine en appelle une autre qui est dans un autre segment cette dernière doit-être appellée par un **CALLF** et se terminer par un **RETF**.

Donc lorsqu'on écris un programme en assembleur il faut faire très attention à la façon dont on organise le code.  Si on sait que le programme va être plus gros que 32Ko il faut prendre le temps de réfléchir à la bonne stratégie à utiliser. J'ai bien écris 32Ko car la mémoire FLASH débute à l'adresse 0x8000 donc il n'y a que 32Ko disponible avant l'adresse étendue 0x10000. 

### Statégies à envisager.

1.  Le plus simple est de n'utiliser que des instructions **CALLF** et **RETF**. pour les sous-routines.

1. Segmenter l'application en modules qui ne sont contenus que dans 1 seul segment. l'interface entre les différents modules peut se faire par interruption logiciels **TRAP** ou encore par une inteface d'appels bien définie utilisant exclusiement des **CALLF**

## programme hello.asm

### Que fait ce programme

Ce programme envoie des messages à un émulateur de terminal situé sur l'ordianteur. La communication se par port sériel en utlisant le **UART3**.
Ce programme a deux variantes sur lequelles je vais revenir lors de l'analyse du code source.

Ce programme utilise la deuxième stratégie. Le code d'initialisation réside dans le segment **0** mais ne fait aucun appel dans un autre segment. L'application fonctionne par interruption. Lorsque le bouton **USER** est enfoncé l'interruption **usr_btn_isr** est activée. J'ai placé cette interruption dans le segment **1** ainsi que les sous-routines qu'elles utilise. Donc tout le code qui est exécuté pendant l'interruption se déroule dans le segment **1**. Il n'est donc pas nécessaire d'utiliser de **CALLF**.
