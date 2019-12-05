# Librairie math24

Cette librairie, écrite en assembleur, implémente des fonctions arithmétiques pour entiers 24 bits. Puisque le **C** ne possède pas de type **int24_t** et **uint24_t** ces fonctions ne peuvent  être appellée qu'à partir de code écris en assembleur. L'intervalle des ces entiers est **-8388608 .. 8388607**
. Il s'agit d'entiers en complément de 2.

Les fonctions qui utilisent 2 arguments attendent ces arguments sur la pile.
S'il n'y a qu'un argument celui-ci est passé dans les registres **X:A**. La valeur de retour est dans les registres **X:A**. Les arguments sont empilés de la droite vers la gauche selon la convention du langage **C**.

## Interface des fonctions

### int24_t add24(int24_t n1, int24_t n2)

Addition sur entiers 24 bits. Le débordement du bit 22 au bit 23 change le signe de la somme. Ainsi la somme de 2 entiers positifs peut résulté en un entier négatif. Ce résultat doit-être traité comme un débordement.

La somme  **n1+n2** est retournée dans la combinaison de registre **X:A** 
où **A** contient l'octet le moins significatif.

### int24_t sub24(int24_t n1, int24_t n2)

Différence **n1-n2**. Un emprunt du bit 22 au bit 23 de **n1** doit-être considéré comme un débordement.  La différence est retournée dans **X:A** où **A** contient l'octet le moins significatif.

### uint24_t mul24_8u(uint24_t n1,uint8_t n2) 

Retourne le produit de 2 entiers non signés **n1*n2**. Le produit est retourné dans **X:A**. S'il y a débordement au bit 23 du produit le résultat doit-être considéré comme invalide. 

### uint24_t mul24u(uint24_t n1, uint24_t n2)

Retourne le produit de 2 entiers 24 bits non signés **n1*n2**. Le produit est retourné dans **X:A**. S'il y a débordement au bit 23 du produit le résultat doit-être considéré comme invalide. 

### int24_t mul24s(int24_t n1, int24_t n2) 

Retourne le produit de 2 entiers signés de 24 bits. Le produit est retourné dans **X:A**. S'il y a débordement au bit 22 du produit le résultat doit-être considéré comme invalide. 

### uint24_t div24_8u(uint24_t n1, uint8_t n2)

Retourne le quotient **n1/n2**. Les 2 entiers sont non signés. Le quotient est retourné dans **X:A**. le reste de la division est retourné dans **n1** et peut donc être récupéré.

### uint24_t div24u(uint24_t n1,uint24_t n2)

Retourne le quotient **n1/n2**. Les 2 entiers sont de 24 bits et non signés. Le quotient est retourné dans **X:A**. Le reste est retourné dans **n1** et peut donc être récupéré.

### int24_t div24s(int24_t n1, int24_t n2)

Retourne le quotient **n1/n2**.  Les 2 entiers sont de 24 bits et signés. Le quotient est retourné dans **X:A**. Le reste est retourné dans **n1** et peut donc être récupéré. Il s'agit d'une [division euclidienne](https://fr.wikipedia.org/wiki/Division_euclidienne#Extension_aux_entiers_relatifs) donc le reste est toujours positif.

### uint8_t clz(int24_t *n)

*Count Leading Zero* retourne le nombre de zéro à partir du bit 23 vers la droite avant de rencontrer un bit à **1**. L'argument **n** est passé comme un pointer dans **X** et le compte des zéros est retourné dans **A**.

### int24_t abs(int24_t n)

Retourne la valeur absolue de **n**. **n** est passé dans **X:A**  et sa valeur absolue est retournée aussi dans **X:A**. 

### uint24_t inc24u(uint24_t n)

Incréente de **1** la valeur de **n**.  **n** est passé dans **X:A**  et sa valeur incrémentée est retournée aussi dans **X:A**. 

### int24_t neg24(int24_t n)

Retourne l'niverse de l'entier **n**. **n** est passé dans **X:A**  et sa valeur inverse est retournée aussi dans **X:A**.  Il s'agit du complément à 2. 

# exemple d'appel d'une fonction.

Pour en savoir plus sur la façon d'utiliser cette librairie vous pouvez étudier le [fichier de test](math24_test.asm).  Voici deux bref extraits:

Le programme présente une interface utilisateur simple qui permet de tester les différentes fonctions en entrant un opérateur suivit de 2 entiers. 
```
>* 2896 2896

mul24s: 2896 2896 =8386816 
>* -2896 2896

mul24s: -2896 2896 =-8386816 
>* -2896 -2896

mul24s: -2896 -2896 =8386816 
>* 2896 -2896

mul24s: 2896 -2896 =-8386816 
>/  2896 16

div24s: 2896 16 =181 R=0 
>/ 2897 16

div24s: 2897 16 =181 R=1 
>/ -2897 16

div24s: -2897 16 =-182 R=15 
>
```
### Extraits du programme de test.

Dans le premier extrait **eval** analyse la ligne de commande pour extraire l'opérateur et les 2 entiers. Les entiers **N1** et **N2** sont empilés dans l'espace réservés sur la pile.

```
; arguments locales 
    N1=1
    N2=4
    OP=7
    LOCAL_SIZE=7  
eval:
    sub sp,#LOCAL_SIZE 
    call next_word 
    ld a,pad 
    ld (OP,sp),a
    call number
    ldw (N1,sp),x 
    ld (N1+2,sp),a 
    call number 
    ldw (N2,sp),x 
    ld (N2+2,sp),a  

```
Cette portion de code montre comment l'opérateur **/** est traité. À ce point du code les arguments sont déjà empilés . Après l'appel à la fonction **div24s** le quotient et le reste sont imprimés.
```
test_div:
    ldw y,#div24s_test
    call puts
    call print_arguments
    call div24s 
    call print_int24
    ld a,#'R 
    call putc 
    ld a,#'=
    call putc 
    ldw x,(1,sp)
    ld a,(3,sp)
    call print_int24  
    jp eval_exit
```





