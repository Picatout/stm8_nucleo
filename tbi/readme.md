# TinyBASIC for STM8

Il s'agit d'une implémentation du [TinyBASIC](https://en.wikipedia.org/wiki/Tiny_BASIC) originellement conçu par [Dennis Allison](https://en.wikipedia.org/wiki/Dennis_Allison) au milieu des années 197x. Cette implémentation est créée à partir des documents [TINYDISK.DOC](TINYDISK.DOC) et [TINYDISK.ASM](TINYDISK.ASM). Cepandant elle n'est pas exactement identique. 

Il s'agit d'un interpréteur pure. C'est à dire que le texte est lu à chaque exécution. Il n'y a pas de génération de code intermédiaire pour exécution sur une machine virtuelle. L'avantage est au niveau de la simplicité. Par exemple la commande **LIST** ne nécessite pas de désassemblage pour afficher le contenu du text original puisque celui-ci est sauvegarder tel quel. 

L'inconvénient est au niveau de la vitesse d'éxécution qui est beaucoup plus lente. Chaque fois qu'une commande est lue dans le texte elle doit-être recherchée dans le dictionnaire pour connaître l'adresse de la routine d'exécution de cette commande. Alors que si les commandes étaient convertie en **bytecode**, il suffirait de consulter une table en utilisant ce code comme index dans la table. C'est beaucoup plus rapide. Par contre pour afficher le texte original ça demanderait plus de code et se serait plus long. Certaines implémentations de TinyBASIC ont cependant opter pour cette forme d'implémentation.  

## Référence du langage
### Type de données 
Le seul type de donné est l'entier 16 bits donc dans l'intervalle **-32768..32767**. 

Cependant pour des fins d'impression des chaînes de caractères entre guillemets sont disponibles. Seul les commandes **PRINT** et **INPUT** utilisent ces chaînes comme arguments. 

Il est aussi possible d'imprimer un caractère en utilisant la fonction **CHAR()**. Qui retourne un type de donnée **TK_CHAR**. Ce type de donnée ne peut-être sauvegardé dans une variable sauf en utilisant la fonction **ASC()** qui le convertie ent type **TK_INTGR** qui peut-être sauvegardé dans uen variable ou utilisé dans un expression.  

### Variables 
Le nombre des variables est limité à 26 et chacune d'elle est représentée par une lettre de l'alphabet. 
### Tableau 
Il n'y a qu'un seul tableau appellée **@** et dont la taille dépend de la taille du programme. En effet ce tableau utilise la mémoire RAM laissée libre par le programme. Un programme peut connaître la taille de ce tableau en invoquant la fonction **UBOUND**. 

### expression arithmétiques 

Il y a 5 opérateurs arithmétiques par ordre de précédence:
1. **-**  moins unaire, qui a la plus haute priorité.
1.  __*__ mulitipliation, **/** division, **%** modulo 
1. **+** addition, **-** soustraction.

Notez que les opérations de division et de modulo réponde à la définition de la [division Euclidienne sur entiers relatif](https://fr.wikipedia.org/wiki/Division_euclidienne#Extension_aux_entiers_relatifs). Ce qui peut réserver des surprises aux non informés. 

### opérateurs relationnels.
Les opérateurs relationnels ont une priorités inférieure à celle des opérateurs arithmétiques. Le résultat d'une relation est **0|1** et ce résultat peut-être utilisé dans une expression arithmérique. Puisque les relations sont de moindre priorité elle doivent-être misent entre parenthères lorsqu'elles sont utilisées dans une expression arithmétique.

1. **&gt;**   Retourne vrai si le premier terme est plus grand que le deuxième.
1. **&lt;** Retourne vrai si le premier terme est plus petit que le second.
1. **&gt;=** Retourne vrai si le premier terme est plus grand ou égal au second. 
1. **&lt;=** Retourne vrai si le premier terme est plus petit ou égal au second. 
1. **=** Retourne vrai si les 2 termes sont identiques. 
1. **&lt;&gt;** ou **&gt;&lt;** Retourne vrai si les 2 termes sont différents. 

## Syntaxe 
Une commande est suivie de ses arguments séparés par une virgule. Les arguments des fonctions doiven-être mis entre parenthèses. Cependant une fonction qui n'utilise pas d'arguments n'est pas suivie de parenthèses.

Les *espaces* entre les unitées lexicales sont facultatives sauf s'il y a ambiguité. Par exemple si le nom d'un commande est immédiatement suivit par le nom d'une variable un espace doit les séparés. 

Les commandes peuvent-être abrégées au plus court à condition qu'il n'y est pas d'ambiguité entre 2 commandes. L'abrévation doit-être d'au moins 2 lettres pour éviter la confusion avec les variables. Par exemple **GOTO**peut-être abrégé **GOT** et **GOSUB** peut-être abrégé **GOS**. 

Certaines commandes sont représentées facultativement par une caractère unique qui évite d'avoir à faire une recherche dans le dictionnaire ce qui accélaire l'exécution. Par exemple la commande **PRINT** peut-être remplacée par **'?'**. 

Plusieurs commandes peuvent-être présentent sur la même ligne. Le caractère **':'** est utilisé comme séparateur de commande.  Son utilisation est facultative s'il n'y a pas d'ambiguité. 

## Ligne de commande et programmes 
 
Au démarrage l'utilisateur retrouve à l'écran l'indicateur de commande qui est le caractères **&gt;**. À partir de là il doit saisir une commande au clavier. Cette commande est considérée comme complétée lorsque la touche **ENTER** est enfoncée. C'est alors que l'interpréteur la décompose et l'exécute. 

Cependant si cette commande débute par un entier. Dans ce cas cette ligne est considéré comme faisant partie d'un programme et le numéro de ligne est conservé comme entier 16 bits avant le texte, suivit d'un octet qui indique la longueur du texte de cette ligne. 

Certaines commandes ne peuvent-être utilisées qu'à l'intérieur d'un programme et d'autres seulement en mode ligne de commande. Un message d'erreur s'affiche si commande est utilisée dans un contexte inaproprié. 

Le programme en mémoire RAM est perdu à chaque réinitialiation du processeur sauf s'il a été sauvegardé comme fichier dans la mémoire flash. Les commandes de fichiers sont décrites dans la section référence qui suit.

## Référence des comamndes et fonctions.

### ABS(expr)
Cette fonction retourne la valeur absolue de l'expression fournie en argument. 

### BRES addr,mask 
Met à **0** les bits indiqués par le *mask*  à l'adresse indiquée *addr*. 

    >bres $500a,32 

Éteint la LED2 sur la carte en mettant le bit 5 à 0.

### BSET addr,mask 
Met à **1** les bits indiqués par le *mask* à l'adresse *addr*. 

    >bset $500a,32

Allume la LED2 sur la carte en mettant le bit 5 à 1.

### BTOGL addr,mask 
Inverse la valeur des bits indiqués par le *mask* à l'adresse *addr*. 

    >btogl $500a,32
Inverse l'état de la LED2 sur la carte. 

## code source 

* **PABasic.asm**  Code source de l'interpréteur BASIC.
* **pab_macros.asm** macros utiles pour ce programme.

