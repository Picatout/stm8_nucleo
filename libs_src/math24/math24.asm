;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   librairie de fonctions arithmétiques sur entiers 24 bits.
;   Date: 2019-11-28
;   Copyright Jacques Deschêens, 2019
;   licence:  GPL v3 
;
;   Description: 
;       *  add24    addition. résultat dans X:A
;       *  sub24    soustraciton. résutlat dans X:A 
;       *  mul24    multiplication non signée. résultat dans X:A
;       *  div24    divisition non signée 24b/16b quotient dans X:A reste dans Y
;       *  neg24    complément à 2 d'un entier 24b. résutlant dans X:A 
;       Le résultat est retourné dans X:A, les 16 bits les plus
;       significatifs sont dans X et les 8 moins significatifs dans
;       A. 
;  NOTE:
;       Cette librairie est pour utilisation par les progammes
;       écris en assembleur seulement. Il n'existe pas de type
;       entier 24 bits en C.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .module MATH24
    .nlist
    .include "../../inc/nucleo_8s208.inc"
    .include "../../inc/stm8s208.inc"
    .list 

; NOTE: pour l'assembleur sdas une étiquette terminée par **::** est une 
; étiquette globale qui peut être référencée dans un autre module.

    .area CODE 

;----------------------------------
; addition 24 bits
; input:
;  N1       premier argument 
;  N2       deuxième argument 
; output:
;   X:A     somme N1+N2 
;--------------------------------
    ARG_OFS=2
    N1=ARG_OFS+1
    N2=ARG_OFS+4
 add24::
    ldw x,(N1,sp)
    ld a,(N1+2,sp)
    add a,(N2+2,sp)
    jrnc 1$
    incw x 
1$: addw x,(N2,sp)
    ret 

;----------------------------------
; soustraction 24 bits
; input:
;  N1       premier argument 
;  N2       deuxième argument 
; output:
;   X:A     somme N1-N2 
;--------------------------------
    ARG_OFS=2
    N1=ARG_OFS+1
    N2=ARG_OFS+4
sub24::
    ldw x,(N1,sp)
    ld a,(N1+2,sp)
    sub a,(N2+2,sp)
    jrnc 1$
    decw x 
1$: subw x,(N2,sp)
    ret 


;----------------------------------------
; multiplication non signée d'un 
; entier 24 bits par un entier 8 bits.
; input:
;   U24         entier non signé 24 bits 
;   U8          entier non signé 8 bits
; output:
;   X:A         produit U24*U8
; NOTE: cette routine jette le débordement
;       au delà du bit 23.
;---------------------------------------
; les arguments sont décalés de 5 octets à cause
; de la variable locale ACC24 de 3 octets.
    ARG_OFS=5
    U24 = ARG_OFS+1
    U8 = ARG_OFS+4
; variable locale pour produit partiel
    ACC24=1
    LOCAL_SIZE=3 
mul24_8u::
    sub sp,#LOCAL_SIZE 
    clr (ACC24,sp)
; U24bits7:0 x U8      
    ld a,(U24+2,sp)
    ld xl,a 
    ld a,(U8,sp)
    mul x,a
    ldw (ACC24+1,sp),x ; produit partiel 1
; produit U24bits15:8 x U8 
    ld a,(U24+1,sp)
    ld xl,a 
    ld a,(U8,sp)
    mul x,a
    addw x,(ACC24,sp)
    ldw (ACC24,sp),x ; produit partiel 2
; produit U24bits23:16 x U8 
    ld a,(U24,sp)
    ld xl,a
    ld a,(U8,sp) 
    mul x,a 
; le contenu de xh est un débordement au delà du bit 23 
; donc on l'ignore. xl représente les 23:16 de ce produit partiel.    
    ld a,xl 
    add a,(ACC24,sp)
    ld xh,a ; produit final bits 23:16
    ld a,(ACC24+1,sp)
    ld xl,a  ; produit final bits 15:8
    ld a,(ACC24+2,sp) ; produit final bits 7:0
    addw sp,#LOCAL_SIZE 
    ret 

;----------------------------------
; multiplication non signée de 24 bits
; input:
;  N1       premier argument 
;  N2       deuxième argument 
; output:
;   X:A     somme N1*N2 
; NOTE: cette routine jette le débordement
;       au delà du bit 23.
;--------------------------------
; les arguments sont décalés de 9 octets:
;   2 pour l'adresse de retour 
;   7 pour LOCAL_SIZE 
    ARG_OFS=9
    N1=ARG_OFS+1  ; argument 1 
    N2=ARG_OFS+4  ; argument 2
; variable locale de 24 bits
    U24 = 1 ; arg1 pour mul24_8u
    U8 = 4  ; arg2 pour mul24_8u
    ACC24=5 ; 3 octets
    LOCAL_SIZE=7
mul24u::
    sub sp,#LOCAL_SIZE
; multiplie  N1 * N2bit7:0  
    ld a,(N2+2,sp)
    ld (U8,sp),a 
    ld a,(N1+2,sp)
    ld (U24+2,sp),a 
    ldw x,(N1,sp)
    ldw (U24,sp),x 
    call mul24_8u
; produit partiel 1
    ld (ACC24+2,sp),a 
    ldw (ACC24,sp),x
; multiplie N1 * N2bit15:8     
    ld a,(N2+1,sp)
    ld (U8,sp),a 
    ld a,(N1+2,sp)
    ld (U24+2,sp),a 
    ldw x,(N1,sp)
    ldw (U24,sp),x 
    call mul24_8u
; additionne produit partiel 2 à produit partiel 1
;  xh représente un débordement après le bit 23 donc ignoré.
    rlwa x 
    addw x,(ACC24,sp)
    ldw (ACC24,sp),x 
; multiplie N1 * N2bits23:16
    ld a,(N2,sp)
    ld (U8,sp),a 
    ld a,(N1+2,sp)
    ld (U24+2,sp),a 
    ldw x,(N1,sp)
    ldw (U24,sp),x 
    call mul24_8u
; additionne produit partiel 3 à acc24 
    add a,(ACC24,sp)
    ld (ACC24,sp),a 
; retourne le produit dans X:A 
result: ; X:A 
    ldw x,(ACC24,sp)
    ld a,(ACC24+2,sp)
    addw sp,#LOCAL_SIZE 
    ret 

;----------------------------------------
; multiplication non signée d'un 
; entier 24 bits par un entier 8 bits.
; input:
;   I1         entier signé 24 bits 
;   I2          entier signé 24 bits
; output:
;   X:A         produit I1*I2
; NOTE: cette routine jette le débordement
;       au delà du bit 23.
;---------------------------------------
    ARG_OFS=9
    I1=ARG_OFS+1
    I2=ARG_OFS+4
; local variables
    U1=1
    U2=4
    SIGN=7   
    LOCAL_SIZE=7
mul24s::
    sub sp,#LOCAL_SIZE 
    clr (SIGN,sp)
    ld a,(I1+2,sp)
    ldw x,(I1,sp)
    tnz (I1,sp)
    jrpl 0$
    cpl (SIGN,sp)
    call neg24
0$: ld (U1+2,sp),a 
    ldw (U1,sp),x
1$: ld a,(I2+2,sp)
    ldw x,(I2,sp)
    tnz (I2,sp)
    jrpl 2$
    call neg24
    cpl (SIGN,sp)
2$: ld (U2+2,sp),a 
    ldw (U2,sp),x 
    call mul24u 
    tnz (SIGN,sp)
    jreq 3$
    call neg24    
3$: addw sp,#LOCAL_SIZE
    ret

;-------------------------------------
; division non signée uint24_t by uint8_t
; input:
;	dividend    uint24_t
;   divisor		uint8_t 
; output:
;    divident   quotient
;    A          remainder 
;------------------------------------- 
    ARG_OFS=2
    U24 = ARG_OFS+1
	U8   = ARG_OFS+4
div24_8u::
	;dividende bits 23:8 in X
	ldw x,(U24,sp)
	ld a,(U8,SP) ; diviseur
	div x,a ; 
    ldw (U24,sp),x 
	ld xh,a
	ld a,(U24+2,sp)
	ld xl,a
	ld a,(U8,sp) ; diviseur
	div x,a  
	ld (U8,sp),a ; sauve reste 
	ld a,xl
	ld (U24+2,sp),a
    ld a,(U8,sp)
	ret

;---------------------------------------
; compte le nombre de bits à zéro
; avant de rencontrer un 1 à partir
; du bit le plus significatif
; input:
;   X        adresse de l'entier 24 bits 
; output:
;   A        nombre de zéro à gauche
;--------------------------------------    
    LZ=1  ; compteur de zéros
    LOCAL_SIZE=1
clz24::
    clr a
    push a 
    scf 
1$: rrc a 
    jrnc 2$
    incw x
    rrc a    
2$: bcp a,(X)
    jrne 3$
    inc (LZ,sp)
    ld yl,a 
    ld a,#24
    cp a,(LZ,sp)
    jreq 3$
    ld a,yl
    rcf  
    jra 1$
3$: pop a 
    ret


;-------------------------------
;  division non signée de DVDEND/DVSOR 
; input:
;   DVDEND      dividende 24 bits
;   DVSOR      diviseur  24 bits 
; output:
;   X:A     quotient U1/DVSOR 
;   U1      reste 
;------------------------------
    ARG_OFS= 8
    DVDEND = ARG_OFS+1
    DVSOR = ARG_OFS+4
; variable locale 
    QUOT_LB = 1 ; quotient bits 7:0, 1 octets
    SHIFT=2 ;  compteur de décalage, 1 octet
    DIFF=3  ;  différence entre DVDEND et DVSOR, 3 octets
    SHIFTR=6 ; décalage du reste vers la droite, 1 octet
    LOCAL_SIZE=6
div24u::
    sub sp,#LOCAL_SIZE
    clr (QUOT_LB,sp)
; si diviseur zéro gènère exception fatale
    ld a,(DVSOR,sp)
    or a,(DVSOR+1,sp)
    or a,(DVSOR+2,sp)
    jrne 1$
    trap ; excepction division par zéro.
1$: ; si dividende < diviseur retourne X:A=0 R=dividende
    ldw x,sp 
    addw x,#DVDEND ; dividente 
    call clz24 
    ld (SHIFT,sp),a 
    ldw x,sp 
    addw x,#DVSOR ; diviseur 
    call clz24
    cp a,(SHIFT,sp)
    jruge 2$
    clrw x 
    clr a 
    jra 9$ 
; décale diviseur vers la gauche jusqu'à ce que A==SHIFT 
2$: sub a,(SHIFT,sp)
    ld (SHIFT,sp),a 
    ld (SHIFTR,sp),a 
    ldw y,(DVSOR,sp)
3$: tnz a 
    jreq 4$
    sll (DVSOR+2,sp)
    rlcw y
    dec a
    jra 3$
4$: ldw (DVSOR,sp),y 
; boucle de division
    clrw x  ; quotient bits 23:8 
5$: ld a,(DVDEND+2,sp) ; dividende bits 7:0
    ldw y,(DVDEND,sp); dividende bits 23:8
    sub a,(DVSOR+2,sp) ; diviseur bits 7:0
    ld (DIFF+2,sp),a
    ld a,yl 
    sbc a,(DVSOR+1,sp)
    ld (DIFF+1,sp),a 
    ld a,yh 
    sbc a,(DVSOR,sp)
    ld (DIFF,sp),a 
    jrc 6$
    ldw y,(DIFF,sp)
    ldw (DVDEND,sp),y
    ld a,(DIFF+2,sp) 
    ld (DVDEND+2,sp),a 
    jra 7$
6$: ld a,(DVDEND+2,sp)
    ldw y,(DVDEND,sp)
    ld (DIFF+2,sp),a 
    ldw (DIFF,sp),y 
7$: ccf
    rlc (QUOT_LB,sp)
    rlcw x
    tnz (SHIFT,sp)
    jreq 8$ 
    sll (DVDEND+2,sp) 
    rlc (DVDEND+1,sp) 
    rlc (DVDEND,sp)
    dec (SHIFT,sp)
    jra 5$
8$: ld a,(DIFF+2,sp)
    ldw y,(DIFF,sp) 
80$: ; réaligne le reste sur le bit 0.
    tnz (SHIFTR,sp)
    jreq 81$
    srlw y 
    rrc a
    dec (SHIFTR,sp)
    jra 80$ 
81$: 
    ld (DVDEND+2,sp),a 
    ldw (DVDEND,sp),y

9$: ld a,(QUOT_LB,sp) 
    addw sp,#LOCAL_SIZE 
    ret 

;------------------------------------------
; division signé int24_t/int24_t 
; input:
;   I1          dividende
;   I2          diviseur
; output:
;   X:A         quotient 
;   I1          reste 
;NOTE: le reste doit toujours être positif 
;REF: https://fr.wikipedia.org/wiki/Division_euclidienne#Extension_aux_entiers_relatifs
;--------------------------------------------
    ARG_OFS=12
    I1=ARG_OFS+1 
    I2=ARG_OFS+4
; variables locales 
    U1=1 
    U2=4 
    SIGN=7
    UDIV=8
    LOCAL_SIZE=10
div24s::
    sub sp,#LOCAL_SIZE
    clr (SIGN,sp)
    ld a,(I1+2,sp)
    ldw x,(I1,sp)
    tnz (I1,sp)
    jrpl 1$
    cpl (SIGN,sp)
    call neg24
1$: ld (U1+2,sp),a 
    ldw (U1,sp),x 
    ld a,(I2+2,sp)
    ldw x,(I2,sp)
    tnz (I2,sp)
    jrpl 2$ 
    cpl (SIGN,sp)
    call neg24 
2$: ld (U2+2,sp),a
    ldw (U2,sp),x
    ld (UDIV+2,sp),a 
    ldw (UDIV,sp),x 
    call div24u 
3$: ; dénominateur négatif et SIGN négatif incrémente quotient si R<>0
    ; et ajuste le reste=U2-mod(U1/U2)
    ; sauvegarde quotient
    ld (I2+2,sp),a 
    ldw (I2,sp),x 
; si le reste est 0 on ne fait aucun ajustement.    
    ld a,(U1,sp)
    or a,(U1+1,sp)
    or a,(U1+2,sp)
    jreq 5$
;vérifie signe du dénominateur et du quotient 
    ld a,(I1,sp)
    and a,#0x80 
    and a,(SIGN,sp)
    jreq 5$
    ld a,(I2+2,sp)
    call inc24u 
    ld (I2+2,sp),a 
    ldw (I2,sp),x 
; ajuste le reste UDIV-mod(U1/U2)
    ld a,(UDIV+2,sp)
    ldw x,(UDIV,sp)
    sub a,(U1+2,sp)
    jrnc 4$
    decw x 
4$: subw x,(U1,sp)
    ld (U1+2,sp),a 
    ldw (U1,sp),x 
; si le signe est négatif ajuste le quotient
5$:
    ld a,(U1+2,sp)
    ldw x,(U1,sp)
    ld (I1+2,sp),a 
    ldw (I1,sp),x 
    ld a,(I2+2,sp)
    ldw x,(I2,sp)
    tnz (SIGN,sp)
    jreq 6$ 
    call neg24
6$: 
    addw sp,#LOCAL_SIZE 
    ret 

;------------------------------------------------------
;  retourne la valeur absolue d'un entier 24 bits
;  input:
;       X:A         int24_t 
;  output:
;       X:A         abs(X:A)
;       Y           0 si était positif, -1 si était négatif
;-----------------------------------------------------
abs24:
    push a 
    ld a,xh 
    bcp a,#0x80
    pop a 
    jreq 1$
    call neg24 
1$: ret 


;-------------------------------------------
; incrémente de 1 un entier 24 bits non signé 
; input:
;   X:A          entier non signér à incrémenté
; output:
;   X:A         entier incrémenté de 1.
;-----------------------------------------------
inc24u:
    add a,#1  
    jrnc 1$ 
    incw x 
1$: ret 


;-------------------------------------------
; complément à 2 
; input:
;   X:A     entier 24 bits 
; output:
;   X:A     complément à 2 de l'entier.
;------------------------------------------
neg24::
    cpl a 
    cplw x 
    add a,#1
    jrnc 1$
    incw x 
1$: ret 

