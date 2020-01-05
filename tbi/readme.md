# TinyBASIC for STM8

Il s'agit d'une implémentation du [Tiny BASIC](https://en.wikipedia.org/wiki/Tiny_BASIC) originellement conçu par [Dennis Allison](https://en.wikipedia.org/wiki/Dennis_Allison) au milieu des années 197x. Cette implémentation est créée à partir des documents [TINYDISK.DOC](TINYDISK.DOC) et [TINYDISK.ASM](TINYDISK.ASM). Cepandant elle n'est pas exactement identique. 

Il s'agit d'un interpréteur pur. C'est à dire que le texte est lu à chaque exécution. Il n'y a pas de génération de code intermédiaire pour exécution sur une machine virtuelle. L'avantage est au niveau de la simplicité. Par exemple la commande **LIST** ne nécessite pas de désassemblage pour afficher le contenu du texte original puisque celui-ci est sauvegarder tel quel. 

L'inconvénient est au niveau de la vitesse d'éxécution qui est beaucoup plus lente. Chaque fois qu'une commande est lue dans le texte elle doit-être recherchée dans le dictionnaire pour connaître l'adresse de la routine d'exécution de cette commande. Alors que si les commandes étaient convertie en **bytecode**, il suffirait de consulter une table en utilisant ce code comme index dans la table. C'est beaucoup plus rapide. Par contre pour afficher le texte original ça demanderait plus de code et se serait plus long. Certaines implémentations de Tiny BASIC ont cependant opté pour la machine virtuelle exécutant du *byte code*.  

## Notes historique
* Avant même l'invention de l'expression *logiciel libre* Tiny BASIC a été le premier logiciel libre. Ce qui l'à rendu populaire sur les premiers ordinateurs qui possédaient peut de mémoire RAM.

* La première version TRS-80 modèle I, était vendu avec 4Ko de mémoire RAM et une version de Tiny BASIC en ROM. Cependant ils ont rapidement ajouter les calcul en virgule flottante par la suite.  

* Les mots réservés **GOTO** et **GOSUB** du BASIC viennent de l'époque du FORTRAN alors que les espaces dans ce langage n'étaient pas significatifs. Ainsi dans Tiny BASIC qui avait adopté cette syntaxe on pouvait écrire **GOTO** au lieu de **GO TO**. Ce **GOTO** en un seul mot est devenu usuel dans de nombreux langages par la suite comme le **goto** du **C**. 

## Référence du langage

### Type de données 
Le seul type de donné est l'entier 16 bits donc dans l'intervalle **-32768...32767**.  

Cependant pour des fins d'impression des chaînes de caractères entre guillemets sont disponibles. Seul les commandes **PRINT** et **INPUT** utilisent ces chaînes comme arguments. 

Il est aussi possible d'imprimer un caractère en utilisant la fonction **CHAR()**. Qui retourne un type de donnée **TK_CHAR**. Ce type de donnée ne peut-être sauvegardé dans une variable sauf en utilisant la fonction **ASC()** qui le convertie ent type **TK_INTGR** qui peut-être sauvegardé dans une variable ou utilisé dans un expression.  

### Variables 

Le nombre des variables est limité à 26 et chacune d'elle est représentée par une lettre de l'alphabet. 

### Tableau 

Il n'y a qu'un seul tableau appellée **@** et dont la taille dépend de la taille du programme. En effet ce tableau utilise la mémoire RAM laissée libre par le programme. Un programme peut connaître la taille de ce tableau en invoquant la fonction **UBOUND**. 

### expression arithmétiques 

Il y a 5 opérateurs arithmétiques par ordre de précédence:
1. **'-'**  moins unaire, qui a la plus haute priorité.
1.  __'*'__ mulitipliation, **'/'** division, **'%'** modulo 
1. **'+'** addition, **'-'** soustraction.

Notez que les opérations de division et de modulo réponde à la définition de la [division Euclidienne sur entiers relatif](https://fr.wikipedia.org/wiki/Division_euclidienne#Extension_aux_entiers_relatifs). Ce qui peut réserver des surprises aux non informés. Dans ce type de division le quotient est arrondie vers l'entier le plus petit et le reste (modulo) est toujours positif. Ainsi **-5/3=-2** et **-5%3=1** de sorte que __D=q*n+r__ où **D** est le dénominateur, **q** le quotient, **n** le diviseur et **r** le reste. Dans cet exemple on a donc __-5=-2*3+1__.  

### opérateurs relationnels.

Les opérateurs relationnels ont une priorités inférieure à celle des opérateurs arithmétiques. Le résultat d'une relation est **0|1** et ce résultat peut-être utilisé dans une expression arithmérique. Puisque les relations sont de moindre priorité elle doivent-être misent entre parenthères lorsqu'elles sont utilisées dans une expression arithmétique.

1. **'&gt;'**   Retourne vrai si le premier terme est plus grand que le deuxième.
1. **'&lt;'** Retourne vrai si le premier terme est plus petit que le second.
1. **'&gt;='** Retourne vrai si le premier terme est plus grand ou égal au second. 
1. **'&lt;='** Retourne vrai si le premier terme est plus petit ou égal au second. 
1. **'='** Retourne vrai si les 2 termes sont identiques. 
1. **'&lt;&gt;'** ou **'&gt;&lt;'** Retourne vrai si les 2 termes sont différents. 

## Syntaxe 

Une commande est suivie de ses arguments séparés par une virgule. Les arguments des fonctions doiven-être mis entre parenthèses. Par fonction j'entends une sous-routine qui retourne une valeur. Cependant une fonction qui n'utilise pas d'arguments n'est pas suivie de parenthèses. Les commandes reçoivent leur arguments sans parenthèses. 

Les *espaces* entre les *unitées lexicales* sont facultatifs sauf s'il y a ambiguité. Par exemple si le nom d'un commande est immédiatement suivit par le nom d'une variable un espace doit les séparés. 

Les commandes peuvent-être entrées indéfèramment en minuscule ou majuscule.
L'analyseur lexical convertie les lettres en  majuscule.

Les commandes peuvent-être abrégées au plus court à 2 caractères à condition qu'il n'y est pas d'ambiguité entre 2 commandes. L'abréviation doit-être d'au moins 2 lettres pour éviter la confusion avec les variables. Par exemple **GOTO**peut-être abrégé **GOT** et **GOSUB** peut-être abrégé **GOS**. 

Certaines commandes sont représentées facultativement par une caractère unique qui évite d'avoir à faire une recherche dans le dictionnaire ce qui accélère l'exécution. Par exemple la commande **PRINT** peut-être remplacée par **'?'**. 

Plusieurs commandes peuvent-être présentent sur la même ligne. Le caractère **':'** est utilisé comme terminateur de commande.  Son utilisation est facultative s'il n'y a pas d'ambiguité.

Une fin de ligne marque la fin d'une commande. Autrement dit une commande ne peut s'étendre sur plusieurs lignes. 

## bases numériques
Les entiers peuvent-être indiqués en décimal,hexadécimal ou binaire. Cependant ils ne peuvent-être affichés qu'en décimal ou hexadécimal. 

Forme lexicale des entiers. Ce qui est entre **'['** et **']'** est facultatif. Le caractère **'+'** indique que le symbole apparaît au moins une fois. 
*  digit: ('0','1','2','3','4','5','6','7','8','9')
*  hex_digit: (digit,'A','B','C','D','E','F') 
*  entier décimaux:  ['+'|'-']digit+
*  entier hexadécimaux: '$'hex_digit+
*  entier binaire: '&'('0'|'1')+   

examples d'entiers:

    -13534 ' entier décimal négatif 
    $ff0f  ' entier hexadécimal 
    &101   ' entier binaire correspondant à 5 en décimal. 

## Ligne de commande et programmes 
 
Au démarrage l'utilisateur retrouve à l'écran l'indicateur de commande *(prompt)* qui est le caractères **'&gt;'**. À partir de là il doit saisir une commande au clavier. Cette commande est considérée comme complétée lorsque la touche **ENTER** est enfoncée. C'est alors que l'interpréteur l'analyse et l'exécute. 

Cependant si cette commande débute par un entier, cette ligne est considéré comme faisant partie d'un programme et et au lieu d'être exécutée est les déposée en mémoire RAM.  

* Un numéro de ligne doit-être dans l'intervalle {1...32767}.

* Si une ligne avec le même numéro existe déjà elle est remplacée par la nouvelle. 

* Si la ligne ne contient qu'un numéro sans autre texte et qu'il existe déjà une ligne avec ce numéro la ligne en question est supprimée. 

* Les lignes sont insérée en ordre numérique croissant. 


Certaines commandes ne peuvent-être utilisées qu'à l'intérieur d'un programme et d'autres seulement en mode ligne de commande. Un message d'erreur s'affiche si une commande est utilisée dans un contexte innaproprié. 

Le programme en mémoire RAM est perdu à chaque réinitialiation du processeur sauf s'il a été sauvegardé comme fichier dans la mémoire flash. Les commandes de fichiers sont décrites dans la section référence qui suit.

## Référence des commandes et fonctions.
la remarque {C,P} après le nom de chaque commande indique dans quel contexte cette commande ou fonction peut-être utilisée. **P** pour *programme* et **C** pour ligne de commande. Lorsqu'une fonction est utilisée sur la ligne de commande la valeur retournée est automatiquement imprimée même si cette fonction n'est pas utilisée comme argument d'une commande **PRINT**. 

### ABS(expr)  {C,P}
Cette fonction retourne la valeur absolue de l'expression fournie en argument. 

    >? abs(-45)
    45

### ASC(*string*) {C,P}
La fonction **ascii** retourne la valeur ASCII du premier caractère de la chaîne fournie en argument.

    >asc("A")
    65 

### BRES addr,mask {C,P}
La commande **bit reset** met à **0** les bits de l'octet situé à *addr*. Seul les bits à **1** dans l'argument *mask* sont affectés. 

    >bres $500a,32 

Éteint la LED2 sur la carte en mettant le bit 5 à 0.

### BSET addr,mask  {C,P}
La commande **bit set** met à **1** les bits de l'octet situé à *addr*. Seul les bits à **1** dans l'argument *mask* sont affectés. 

    >bset $500a,&100000

Allume la LED2 sur la carte en mettant le bit 5 à 1.

### BTOGL addr,mask  {C,P}
La commande **bit toggle** inverse les bits de l'octet situé à *addr*. Seul les bits à **1** dans l'argument *mask* sont affectés. 


    >btogl $500a,32
Inverse l'état de la LED2 sur la carte. 

### BYE  {C,P}
Met le microcontrôleur en mode sommeil  profond. Dans ce mode tous les oscilleurs sont arrêtés et la consommation électrique est minimale. Une interruption extérieure ou un *reset* redémarre le MCU. Sur la care **NUCLEO-8S208RB** il y a un bouton **RESET** et un bouton **USER**. Le bouton **USER** est connecté à l'interruption externe **INT4** donc permet de réveiller le MCU. 

### CHAR(*expr*) {C,P}
La fonction *character* retourne le caractère ASCII correspondant aux 7 bits les moins significatifs de l'expression utilisée en argument. Pour l'interpréteur cette fonction retourne un jeton de type **TK_CHAR** qui n'est reconnu que par la commande **PRINT**.

    >for a=32 to 126:? char(a),:next a 
     !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
    > 

### DEC {C,P}
La commande *decimal* définie la base numérique pour l'affichage des entiers à la base décimale. C'est la base par défaut. Voir la commande **HEX**.

    >HEX:?-10:DEC:?-10
    $FFFFF6
    -10

### DIR {C,P}
La commande *directory*  affiche la liste des fichiers sauvegardés en mémoire flash.

    >dir
    table1   66
    hello   21
    blink   52
    3 files

### FOR *var*=*expr1* TO *expr2* [STEP *expr3*] {C,P}
Cette commande initialise une boucle avec compteur. La variable est initialisée avec la valeur de l'expression *expr1*. À chaque boucle la variable est incrémentée de la valeur indiquée par *expr3* qui suit le mot réservé **STEP**. Si **STEP** n'est pas indiqué la valeur par défaut **1** est utilisée. Une boucle **FOR** se termine par la commande **NEXT** tel qu'indiqué plus bas. Les instructions entre les comamndes **FOR** et **NEXT**
peuvent s'étaler sur plusieurs lignes à l'intérieur d'un programme. Mais sur la ligne de commande le bloc au complet doit-être sur la même ligne.
```
>for a=1to10:? a,:next a
   1   2   3   4   5   6   7   8   9  10
>
``` 
Exemple de boucle FOR...NEXT dans un programme.
```
>li
    5 ' table de multiplication de 1 a 17
   10 for a=1to17
   20 for b=1to17
   30 ?a*b,
   40 next b:?
   50 next a

>run
   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
   2   4   6   8  10  12  14  16  18  20  22  24  26  28  30  32  34
   3   6   9  12  15  18  21  24  27  30  33  36  39  42  45  48  51
   4   8  12  16  20  24  28  32  36  40  44  48  52  56  60  64  68
   5  10  15  20  25  30  35  40  45  50  55  60  65  70  75  80  85
   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90  96 102
   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105 112 119
   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120 128 136
   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135 144 153
  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170
  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165 176 187
  12  24  36  48  60  72  84  96 108 120 132 144 156 168 180 192 204
  13  26  39  52  65  78  91 104 117 130 143 156 169 182 195 208 221
  14  28  42  56  70  84  98 112 126 140 154 168 182 196 210 224 238
  15  30  45  60  75  90 105 120 135 150 165 180 195 210 225 240 255
  16  32  48  64  80  96 112 128 144 160 176 192 208 224 240 256 272
  17  34  51  68  85 102 119 136 153 170 187 204 221 238 255 272 289

>
```
### FORGET ["file"] {C,P}
Cette commande sert à supprimer un fichier sauvegardé dans la mémoire flash. 
**Tous les fichiers qui suivent celui nommé sont aussi supprimés. Si aucun fichier n'est nommé tous les fichiers sont supprimés.**
```
>dir
table1   66
hello   21
blink   52
   3 files

>forget "blink"

>dir
table1   66
hello   21
   2 files

>
```

### GOSUB *expr* {P}
Appel de sous-routine. *expr* doit résulté en un numéro de ligne existant sinon le programme arrête avec un message d'erreur.
```
>li
   10 a=0
   20 gosub 1000
   30 if a>20 : stop 
   40 goto 20
 1000 ? a,
 1010 a=a+1
 1020 ret

>run
   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20
>
```
### GOTO *expr* {P}
Passe le contrôle à la ligne dont le numéro est déterminé par *expr*. *expr* doit résulté en un numéro de ligne existant sinon le programme s'arrête avec un message d'erreur. 
```
>li
   10 a=0
   20 goto 1000
   30 if a>20 : stop 
   40 goto 20
 1000 ? a,
 1010 a=a+1
 1020 goto 30

>ru
   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20
>
```
### HEX {C,P}
Sélectionne la base numérique hexadécimale pour l'affichage des entiers.
Voir la commande **DEC**  pour revenir en décimale.

    >HEX:?-10:DEC:?-10
    $FFFFF6
    -10

### IF *relation* : cmd [:cmd]* {C,P}
Le **IF** permet d'exécuter les instructions qui suivent sur la même ligne si l'évalution de *relation* est vrai. Toute valeur différente de zéro est considérée comme vrai.  Si la résultat de *relation* est zéro les instructions qui suivent le **IF** sont ignorées.  Il n'y a pas de **ENDIF** ni de **ELSE**. Toutes les instructions à exécuter doivent-être sur la même ligne que le **IF**. 

```
>a=5%2:if a:?"vrai",a
vrai   1

>if a>2 : ? "vrai",a

>
```

### INPUT [*string*]*var* [,[*string*]*var*]+  {P}
Cette commande permet de saisir un entier fourni par l'utilisateur. Cet entier est déposé dans la variable donnée en argument. Plusieurs variables peuvent-être saisies en une seule commande en les séparant par la virgule. 
Facultativement un message peut-être affiché à la place du nom de la variable.
```
>10 input "age? "a,"sexe(1=M,2=F)? "s 

>run
age? 24
sexe(1=M,2=F)? 1

>? a,s
  24   1

>
```
### KEY {C,P}
Attend qu'un caractère soit reçu de la console. Ce caractère est retourné sous la forme d'un entier et peut-être affecté à une variable.
```
>? "Press a key to continue...":k=key
Press a key to continue...

>
```
### LET *var*=*expr* {C,P}
Affecte une valeur à une variable. En Tiny BASIC il n'y a que 26 variables représentées par les lettres de l'alphabet. *expr* peut-être arithmétique ou relationnel ou une combinaison des deux. Le mot réservé **LET** est facultatif. 
```
>LET A=24*2+3:?a
  51
>b=3*(a>=51):?b
   3
>c=-4*(a<51):?c
   0
>
```

### LIST [*expr1*][,*expr2*] {C}
Affiche le programme contenu dans la mémoire RAM à l'écran. Sans arguments toutes les lignes sont affichées. Avec un argument la liste débute à la ligne dont le numéro est **&gt;=expr1**. Avec 2 arguments la liste se termine au numéro **&lt;=expr2**. 
```
>list
   10 'fibonacci 
   20 a=1:b=1 
   30 if b>100 : stop 
   40 ? b,
   50 c=a+b: a=b:b=c
   60 goto 30

>run
   1   2   3   5   8  13  21  34  55  89
>list 20,40
   20 a=1:b1
   30 if b>100 : stop 
   40 ? b,

>

```

### LOAD *string*  {C}
Charge un fichier sauvegardé dans la mémoire flash vers la mémoire RAM dans le but de l'exécuter. *sting* est le nom du fichier à charger.
```
>save "fibonacci"
  86
>new

>li

>load "fibonacci"
  86
>li
   10 'fibonacci
   20 a=1:b=1
   30 if b>100: stop 
   40 ? b,
   50 c=a+b:a=b:b=c
   60 goto 30

>run
   1   2   3   5   8  13  21  34  55  89
>
```
### PAUSE *expr* {C,P}
Cette commande suspend l'exécution pour un nombre de millisecondes équivalent à la valeur d'*epxr*. pendant la pause le CPU est en mode suspendu c'est à dire qu'aucune instruction n'est exécutée jusqu'à la prochaine interruption. le TIMER4 génère une interruption à chaque milliseconde. Le compteur de **PAUSE** est alors décrémenté et lorsqu'il arrive à zéro l'exécution du programme reprend.
```
>li
   10 input "pause en secondes? "a
   20 pause 1000*a
   30 if a=0:stop
   40 goto 10

>ru
pause en secondes? 5
pause en secondes? 10
pause en secondes? 0

>
```

### PEEK(*expr*) {C,P}
Retourne la valeur de l'octet situé à l'adresse représentée par *expr*. Même s'il s'agit d'un octet il est retourné comme un entier positif entre {0..255}.
```
>hex:peek($5240)'UART3_SR 
 $D0
> ' $D0 signifie que le UART3 est inactif.

>
```
### POKE *expr1*,*expr2*
Dépose la valeur de *expr2* à l'adresse de *expr1*. 
```
>poke $5241,asc("A") 'UART3_DR, envoie 'A' au terminal
A
>
```

### PRINT [*string*|*expr*][,*string*|*expr*][','] {C,P}
La commande **PRINT** sans argument envoie le curseur du terminal sur la ligne suivante. Si la commande se termine par une virgule il n'y a pas de saut la ligne suivante et la prochaine commande **PRINT** se fera sur  la même ligne. Les arguments sont séparés par la virgule. 

Le **'?'** peut-être utilisé à la place de **PRINT**.

**PRINT** accepte 3 types d'arguments: 

* *string*,  chaîne de caractère entre guillemets
* *expr*,   Toute expression arithmétique et relationnelle qui retourne un entier.
* *char*,  Un caractère ASCII tel que retourné par la fonction **CHAR()**.
```
>? "la valeur de A=",a
la valeur de A=  51

>PRINT "Caractere recu du terminal ",char(key)
Caractere recu du terminal Z

>
```
### QKEY {C,P}
Cette commande vérifie s'il y a un caractère en attente dans le tampon de réception du terminal. Retourne **1** si c'est le cas sinon retourne **0**.
```
>for a=0to0ste0:a=qkey:next a

>a
```
L'exemple çi-haut est une astuce de programmation. Pour créer une boucle infinie on utilise un FOR...NEXT avec la valeur de STEP à zéro. À l'intérieur de la boucle on appelle la fonction **QKEY** dont la valeur est affectée à la variable **A** qui est la variable de contrôle de la boucle. Sitôt qu'une touche est enfoncée sur la console la valeur de **A** passe à **1** et la boucle se termine. De retour sur la ligne de commande le caractère reçu  de la console est affiché après le **'&gt;'** puisqu'il est lu par la fonction *readln* de l'interpréteur de commande.

### REM  *texte*
La commande **REM**  sert à insérer des commentaires (*remark*) dans un programme pour le documenter. Le mot réservé **REM** peut-être avantageusement remplacé par le caractère apostrophe (**'**). Un commentaire se termine avec la ligne et est ignoré par l'interpréteur.
```
>list
   10 REM ceci est un commentaire
   20 'ceci est aussi un commentaire, (plus rapide)
```

### RETURN {P}
La commande **RETURN**  indique la fin d'une sous-routine. Lorsque cette commande est rencontrée l'exécution se poursuit à la ligne qui suit le **GOSUB** qui a appellé cette sous-routine.
```
>li
    5 ? #6,"Suite de Fibonacci,'q'uitter, autre suivant"
   10 a=1:b=1:f=1
   12 ? f,
   20 gosub 100
   30 r=key:if r=asc("q"):stop
   40 goto 20
  100 'imprime terme, calcule suivant
  110 ?f,
  120 a=b:b=f:f=a+b
  130 return

>ru
Suite de Fibonacci,'q'uitter, autre suivant
     1     1     2     3     5     8    13    21    34    55    89
>
```
Dans cet exemple chaque fois qu'on presse une touche sur la console le terme suivant de la suite de Fibonacci est imprimé. La touche 'q' termine le programme. 

### RND(*expr*)
Cette fonction retourne un entier aléatoire dans l'intervalle {1..*expr*}.
*expr* doit-être un nombre positif sinon le programme s'arrête en indiquant une erreur de syntaxe.
```
>?#6:r=32767:fo a=1to100:r=rnd(r):?r,:r=abs(r*113):ne a  

 10061 15156  1114   572   587   771 13879  3472   109  7406  5650  9869   833 22330 22817 17725  7596  5740  2199  6776  9098 16066  8444 11069  2060 23863  1644  6927  2477  1129   893  9684 16320  2571 11309 25964  8347  2297  1663  1504  2144 17889  5946  4483 10146  1086  8073  2449  5911  5213   417  1796  4428  2811  8606  7311 25498  1127  1488 15552  8132  1370 23611 12255  7190  8535  3260 21717 19866  8811 11734 10410  2767  8649  2142 16396  4067   115  4256 16132  2431 10187 11490  2952  2431  2599 23978 11674  4296  1501 24609 26148  2133 20845  3084 18563    13  1086  3761 10511
>
```
### RUN {C}
Lance l'exécution du programme qui est chargé en mémoire RAM. Si aucun programme n'est chargé il ne se passe rien.

### SAVE *string* 
Sauvegarde le programme qui est en mémoire RAM dans un fichier. La mémoire FLASH qui n'est pas utilisée par TinyBASIC est utilisée comme mémoire permanente pour un système de fichier rudimentaire où les programmes sont sauvegardés. *string* est le nom du fichier. Si un fichier avec ce nom existe déjà un message d'erreur s'affiche.
```
>li
    5 ? #6,"Suite de Fibonacci,'q'uitter, autre suivant"
   10 a=1:b=1:f=1
   12 ? f,
   20 gosub 100
   30 r=key:if r=asc("q"):stop
   40 goto 20
  100 'imprime terme, calcule suivant
  110 ?f,
  120 a=b:b=f:f=a+b
  130 return

>save "fibo"
duplicate name.
save "fibo"
           ^
>
```
### SIZE {C,P}
Cette commande retourne le nombre d'octets libre dans la mémoire RAM
```
>size
5740
>10 ?hello world!"

>size
5721
>
```

### SLEEP {C,P}
Cette commande place le MCU en sommeil. En mode *sleep* le processeur est suspendu et dépense un minimum d'énergie. Pour redémarrer le processeur il faut une interruption externe. Comme le bouton **USER** sur la carte NUCLEO.

**SLEEP** utilise l'instruction machine **halt** qui arrête tous les oscillateurs du MCU donc les périphériques ne fonctionnent plus. Par exemple le TIMER4 utilisé pour compter les millisecondes cesse de fonctioner. Le temps est suspendu jusqu'au redémarrage. 
```
>li
   10 ?"hello ",
   20 sleep
   30 ?"world!"

>ru
hello world!

>
```
Dans cet exemple le mot **"hello "** s'affiche puis il ne passe plus rien jusqu'à ce qu'on appuie sur le bouton **USER** sur la carte **NUCLEO**. 
Ce qui déclenche l'interruption externe **INT4** et redémarre le MCU qui exécute la suite du programme et affiche le mot **"world!"**.

### STEP *expr* {C,P}
Ce mot réservé fait partie de la commande **FOR** et indique l'incrément de la variable de contrôle de la boucle. Pour plus de détail voir la commande **FOR**. 

### STOP {P}
Cette commande arrête l'exécution d'un programme et retourne le contrôle à la ligne de commande. Cette commande peut-être placée à plusieurs endroits dans un programme. 
```
>lis
   10 a=1
   20 a=a+1
   30 ? a,: if a>100:stop 'arrete lorsque A depasse 100
   40 goto 20

>run
   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95  96  97  98  99 100 101
>
```
### TICKS {C,P}
Le systême entretien un compteur de millisecondes en utilisant le **TIMER4**.  Cette commande retourne la valeur de ce compteur. Le compteur est de 16 bits donc le *roll over* est de 65536 millisecondes. Ce compteur peut-être utilisé pour chronométrer la durée d'exécution d'une routine. Par exemple ça prend combien de temps pour exécuter 1000 boucles FOR vide.
```
>t=ticks:fo a=1to1000:ne a:?ticks-t
  56

>
```
Réponse: 56 millisecondes. 

### TO *expr* {C,P}
Ce mot réservé est utilisé lors de l'initialisation d'une boucle **FOR**. **expr** détermine la valeur limite de la variable de contrôle de la boucle. Voir la commande **FOR** pour plus d'information. 

### UBOUND
Cette fonction retourne la taille de la variable tableau **@**. Comme expliqué plus haut cette variable utilise la mémoire RAM qui n'est pas utilisé par le programme BASIC. Donc plus le programme prend de place plus sa taille diminue. 
```
>ubound
2870
>10 'plus le programme prend de la place, plus @ diminue.

>ubound
2841
>
```
### WAIT *expr1*,*expr2*[,*expr3] {C,P}
Cette commande sert à attendre un changement d'état sur un périphérique.
*expr1* indique l'adresse du registre de périphérique susceptible de changer d'état. *expr2* est un masque de bits appliqué à l'octet lu dans le registre avec la fonction logique AND.  Si cette valeur est différente de zéro l'attente se termine. *expr3* peut-être utilisé pour attendre qu'un ou des bits passent à zéro. Il est appliqué après la fonction AND ave une fonction logique XOR.  Si B&E1^E2<>0 alors fin de l'attente. 
```
>wait $5240,&100000 ' attend reception caractere

>z
```
Dans cet exemple l'adresse $5240 correspond au registre UART3_SR. Lorsque le bit 5 de ce registre passe à **1** ça signifit qu'un caractère a été reçu.
L'exécution est suspendu jusqu'à la réception d'un caractère sur UART3.

### WRITE *expr1*,*expr2* 
Cette commande permet d'écrire un octet dans la mémoire EEPROM ou dans la mémoire FLASH. *expr1* indique l'adresse et *expr2* indique la valeur à écrire. le **STM8S208RB** possède 2Ko de mémoire EEPROM 128Ko de mémoire FLASH. 

**AVERTISSEMENT: La mémoire FLASH qui n'est pas utilisée par tinyBASIC sert de mémoire pour les fichiers, écrire dans cette mémoire risque d'endommager le système de fichier.** 

# Utilisation de TinyBASIC sur STM8
A faire: écrire le manuel de l'[utilisateur de tinyBASIC](manuel_util_tb.md).


# code source 

* **PABasic.asm**  Code source de l'interpréteur BASIC.
* **pab_macros.asm** macros utiles pour ce programme.

