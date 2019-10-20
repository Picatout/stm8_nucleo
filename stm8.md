# processeur STM8

Ce document est une brève présentation du CPU STM8 au coeur des microcontrôleurs 8 bits de ST Microelectronics.

Le STM8 est un descendant du mythique MOS 6502 largement utilisé dans les années 70 entre autre dans le **Apple II**. Il est une extension de 
ce dernier. le modèle de programmation des 2 CPU est présenté ici bas pour comparaison.

processeur MOS 6502
![6502](docs/images/6502.png) 

processeur STM8
 ![STM8](docs/images/stm8.png)

Comme on le voit le STM8 étant les registres d'index **X** et **Y** à 16 bits ainsi que le pointeur de pile **SP**. Dans le 6502 les 8 bits supérieurs de **SP** était fixés à la valeur **0x01** ce qui veut dire que la pile était forcément située entre les adresses 0x0100 et 0x01ff. Le STM8 permet de la situer n'importe où entre 0x0000 et 0xffff. 

On constate aussi que le compteur ordinal est de 24 bits au lieu de 16 ce qui permet un espace d'adressage linéaire de 16Mo alors que le 6502 est limité à 64Ko.  

Les indicateurs booléens **CC** sont aussi différents bien qu'il y en est 7 dans les 2 cas. 

Le STM8 est en architecture Harvard contrairement au 6502 qui est en architecture Von Neumann.  Architecture Harvard signifie que la mémoire programme est sur un bus différent de la mémoire des données. La mémoire programme est de type **FLASH** comme la majorité des MCU modernes et est accédée 32 bits à la fois (4 octets) tandis que la mémoire RAM est accédée 8 bits à la fois (1 octet). Du point de vue de la programmation et de l'exécution un programme peut-être exécuté aussi bien dans la mémoire RAM que la mémoire FLASH. L'accès entre les 2 types de mémoire est transparent sauf que l'exécution à partir de la RAM est plus lente parce que le bus est de seulement 8 bits au lieu de 32 bits. 

Contrairement à la majorité des MCU le STM8 permet d'écrire dans la mémoire FLASH un octet à la fois bien que ce ne soit pas la méthode la plus efficace.

## jeu d'instructions

Le STM8 possède un jeu d'instruction plus étendu que le 6502 pour accommoder son espace d'adressage supplémentaire et d'autres fonctionnalités. Il possède 80 instructions avec 18 modes d'adressage différents. De plus il y a un multiplicateur et un diviseur matériel incorporé au processeur ce qui améliore grandement la performance des traitements numériques.

Au niveau de l'assembleur les mnénoniques sont les même pour les 2 processeurs pour les instructions qui existent dans les deux. Cependant le code binaire généré est différent. On ne peut donc pas exécuter un binaire du 6502 sur le STM8, il faut réassembler le code source.