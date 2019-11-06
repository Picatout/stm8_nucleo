# Paramètres et variables locales

Dans ce chapitre j'examine le passage des paramètres aux sous-routines ainsi que l'utilisation de variables locale à celles-ci.

## Paramètres de sous-routines

Le CPU STM8 a très peu de registres internes qui peuvent-être utilisés pour passer des paramètres aux sous-routines. On peut envisager plusieurs méthodes pour contourner cette limitation mais quelque soit la méthode choisie il faut s'y tenir avec discipline pour éviter la confusion. La méthode que j'utilise est inspirée de celle des compilateurs **C**. D'ailleurs le CPU STM8 est bien adapté à cette méthode grâce aux modes d'adressage indexé sur le registre **sp** qui permet d'accéder aux différents éléments qui sont sur la pile avec facilité. Avec facilité lorsque c'est un compilateur **C** qui fait le travail mais qui demande plus d'attention lorsque c'est le programmeur qui le fait en assembleur.

Lorsqu'il n'y a qu'un octet à passer à une sous-routine j'utilise l'accumulateur **A**. Si je dois passer des entiers de 16 bits j'utilise les registres **X** et **Y**. Si la routine a plusieurs arguments on peut les empilés avant d'appeller la fonction.

Dans certaines circonstances j'utilise des variables en mémoire RAM. Je décris chacune de ces situations dans les exemples de codes qui suivent.

## Variables locales
Pour les variables locales on utilise soit les registres soit on cré de l'espace sur la pile pour ces variables. 

## Documenter les sous-routines

Quelque soit la méthode utilisée il est important de documenter l'interface de chaque sous-routine. C'est à dire ce qu'elle utilise en entré et ce qu'elle produit en sortie. Si elle modifie des variables en RAM il faut aussi l'indiquer.  Il est important d'être discipliné sur la documentation pour avoir un programme facile à maintenir. Et c'est en général une des tâche les plus négligée par les programmeurs.

## Pile et variables locale

Avec un CPU du type accumulateur comme le STM8 l'utilisation de la pile pour les variables locales est pratiquement inévitable. 

```
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; dépose un octet en mémoire
; entrée:
;    a  		octet à déposé en mémoire
;    farptr  	pointeur addresse
;    x          farptr[x] index
; sortie:
;    rien       mémoire cible modifiée.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; variables locales
	BTW = 1   ; Byte To Write , position sur la pile
	OPT = 2   ; option, position sur la pile
	LOCAL_SIZE = 2
write_byte:
	pushw y
	sub sp,#LOCAL_SIZE  ; réservation d'espace pour variables locales  
	ld (BTW,sp),a ; byte to write 
	clr (OPT,sp)  ; OPTION flag
```
Le morceau de code ci-haut est l'entête de la procédure **write_byte** qui accepte comme paramètres un octet dans **A** et un index dans **X**. De plus cette procédure utilise une variable pointeur appellée **farptr** qui contient une adresse de 24 bits qui correspond à l'adresse destination indexée par la valeur dans **X**. C'est l'équivalent en **C** de **farptr[x]=A**.

Ce que je veux indiqué dans ce morceau de code c'est l'utilisation de variables locales. **BTW** et **OPT** sont les noms des variables locales. Les valeurs associées à ces symboles représentent la position de ces variables sur la pile par rapport à la position actuelle de **SP**, le pointeur de pile du CPU. **LOCAL_SIZE** est le nombre d'octets réservés sur la pile pour les variables locales.

Notez que la première instruction est **pushw y**. **Y** est sauvegardé sur la pile car la routine utilise ce registre et qu'on veut lui rendre sa valeur originale avant de quitter la procédure. l'instruction **sub sp,#LOCAL_SIZE** cré l'espace nécessaire aux variables locales sur la pile. Ensuite on sauvegarde **A** sur la pile à la position **BTW** avec l'instruction **ld (BTW,sp),a** et on initialize à zéro la variable **OPT** avec l'instruction **clr (OPT,SP)**.  Ce mode d'adressage appellé indexé consiste à ajouter à la valeur de **sp** une constante pour obtenir l'adresse effecitve. Donc puisque **OPT=2** cette variable locale se trouve à l'adresse **sp+2** et **BTW** se trouve à l'adresse **sp+1**. Avec l'instruction **ld** l'adresse indexée peut-être utilisée autant comme source que comme destination, donc **ld a,(BTW,sp)** retourne la valeur de la variable dans **A**.  La partie du code qui cré l'espace pour les variables locales et les initialise s'appelle un *préambule*.

### Postface
```
write_exit:
; ne pas oublier de réajuster sp 
; et de restaurer les register empilés.
	addw sp,#LOCAL_SIZE 
	popw y
    ret
```
Avant de sortir de la sous-routine il faut faire le ménage. Cette partie du code s'appelle *postface* ou *conclusion*.  On avait réservé de l'espace pour les variables locales on doit maintenant libérer cet espace avec l'instruction **addw sp,#LOCAL_SIZE**.  Il ne faut pas oublier de remettre la valeur initiale de **Y** à sa place **popw y**. Maintenant on peut quitter la sous-routine sans problème **ret**. 

## Paramètres sur la pile

Imaginons une fonction qui additionne 2 entiers de 24 bits. Aucun registre ne peut contenir de telles valeurs. Je vais présenter deux méthodes.

### 1ère méthode
Comme les fonctions arithémtiques sont souvent utilisées dans un programmes ça fait du sens de réserver dans la mémoire RAM une variable qui va servir d'accumulateur 24 bits pour les opérations arithmétiques sur les entiers de cette taille. Ce 24 bits peut semblé inhabituel, car en **C** on voit plutôt des entiers de 8,16,32 ou 64 bits.  Mais le choix de 24 bits fait du sens pour le STM8 puisque c'est la taille du registre **EPC** (le compteur ordinal). Avec l'arithmétique des pointeurs on a donc souvent besoins d'entiers de cette taille.  Utiliser des entiers de 32 bits ralentirait les opérations inutilement.

```
    .area DATA
    acc24  .blkb 3 ; accumulateur 24 bits.
    
    .area CODE
;---------------------------------
; addition de 2 entiers de 24 bits
; entrées:
;    acc24   premier entier.
;    X:A     deuxième entier.
; sortie:
;   acc24    somme
;---------------------------------
add24m1:
;additionne les octets faibles bits 7:0
    add a,acc24+2
    ld acc24+2,a
;additionne les octets 2 et 3, bits 23:8    
    jrnc 1$
    incw x
1$: addw x,acc24
    ldw acc24,x
    ret

; routine qui appel add24
caller:
; dépose le premier entier dans acc24
    ldw x,#3141
    ldw acc24,x
    ld a,#59
    ld acc24+2,a
; dépose le deuxième dans X:A
    ldw x,#2718
    ld a, #28
    call add24m1
; la somme est maintenant dans acc24
    ...    
```
 Donc ici on utilise l'accumulateur de 24 bits nommé **acc24** pour passer le premier entier et pour retourner la somme. On utilise le registre **X** pour les 2 octest les plus forts du deuxième entier. et **A** pour l'octet le plus faible du deuxième entier. Notez qu'on aurait pu garder la somme dans **X:A** ce qui aurait sauver 2 instructions. 

 ### 2ième méthode

 On passe le 1 entier sur la pile, l'autre dans X:A. La somme est retournée dans X:A.

```
;-----------------------------------
; additionne 2 entiers de 24 bits
; entrées:
;   pile     premier entier
;   X:a      deuxième entier
; sortie:
;   X:A      somme
;----------------------------------
    ARG_OFS =2 ; 2 octest occupés par l'adresse de retour.
    I24_A = ARG_OFS+1   ; position sur la pile entier 1
add24m2:
    add a,(I24_A+2,sp)
    jrnc 1$
    incw x
1$: addw x,(I24_A,sp)
    ret

; routine appelante
    ARG_SIZE=3 ; nombre d'octets réservés sur pile
    I24_A = 1 ; position sur la pile 
caller:
; espace pour I24_A
    sub sp,#ARG_SIZE 
; envoie le premier entier sur la pile
    ldw x,#3141
    ldw (I24_A,sp),x
    ld a,#59
    ld (I24_A+2,sp),a
;deuxième entier dans X:A
    ldw x,#2718
    ld a,#28
    call add24m2
; somme maintenant dans X:A 
; libère l'espace sur la pile
    addw sp,#ARG_SIZE
    ...        
```

Les compilateurs **C** utilise cette méthode lorsqu'il y trop d'arguments pour les passer dans les registres. Ici la routine appellante est responsable de réserver l'espace sur la piles et d'y déposer les arguments dans le bon oordre avant de faire l'appel à la fonction. Après le retour l'appelant est responsable du nettoyage de la pile. 

    **IMPORTANT** Il faut tenir compte du type d'appel utilisé pour la fonction **add24m2** si elle est appelée avec un **callf** **ARG_OFS** sera 3 et non 2 car dans ce cas l'appel empile les 3 octets du compteur ordinal.






