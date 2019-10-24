MONA
====
Moniteur écris en assembleur

Ce moniteur peut-être utile pour interagir directement avec le microcontrôleur en observant l'effet produit par la modification des registres de 
contrôle des périphériques. Par exemple pour allumer la LED2 verte sur la carte, la commande **s $500a 32** peut-être utilisée. **$500a** est l'adresse du registre
**PC_ODR**  et la LED2 est branchée sur **PC5** d'où le masque **(1<<5)** pour masquer le bit 5 du registre. 

la commande **t $500a 32** inverse l'état de la LED2.
  
commandes:
----------
* @ addr, affiche la valeur de l'octet à l'adresse donnée.
* ! addr byte [byte ]*, dépose les octets données aux adresses successsives à partir de 'addr'.
* ?, affiche la liste des commandes.
* b n|$n, convertie l'entier dans l'autre base. i.e. dec->hex|hex->dec.
* c addr bitmask, met les bits masqués à zéro.
* h addr, Affiche le contenu de la mémoire en hexadécimal par rangée de 8 octets. Pause à chaque rangée. ESPACE continue, autre termine.
* m src dest count, copie le bloc mémoire de 'src' vers 'dest', 'count' est le nombre d'octets à copier.
* r  réinitialise le MCU
* s addr bitmask, met à 1 les bits masqués.
* t addr bitmask, inverse la valeur des bits masqués.
* x addr, exécute le code à l'adresse donnée. i.e. x $6000 réinialise la carte. 

 utilisation
 -----------
 
  Le UART3 du STM8S-DISCOVERY est branché sur les broches **TX -> PD5 -> CN7-2** et **RX -> PD6 -> CN7-1**. Il suffit de relier ces 2 broches à un 
  adapteur de niveaux pour port sériel qui est relié à un PC. MONA communique à la vitesse de **115200 BAUD** configuré en **8N1** pas de contrôle de flux.
  
  Personnellement je travaille sur un poste en Ubuntu 18.04 et j'utilise **gtkTerm** comme émulateur de terminal **VT100**. GtkTerm doit-être configuré 
  pour que lorsuqu'il reçoit un caractère **'\n'** *(newline)* et exécute aussi un **'\r'** *(return)* . 
  
  ![capture écran MONA](screenshot.png)
  
  Le moniteur bloque l'écriture dans la mémoire flash occupée par le moniteur ainsi que la mémoire ram utilisée par celui-ci.
  
  lors de la saisie d'une commande la combinaison de touches **CTRL-R** permet de répéter la dernière commande. Mais ça ne fonctionne qui si on
  l'utilise au début de la saisie. Par exemple si après avoir exécuter une fois la commande **t $500a 32** on fait des **CTRL-R** suivie de **ENTER**
  on peut basculer l'état de la LED2 rapidement.
  
  Pour une description du code source de MONA consulter le document suivant  [Étude du code source](MONA.md).

  

