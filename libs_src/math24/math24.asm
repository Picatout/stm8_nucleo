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
;   X:A        produit U24*U8
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
    mul x,a
    addw x,(ACC24,sp)
    ldw (ACC24,sp),x ; produit partiel 2
; produit U24bits23:16 x U8 
    ld a,(U24,sp)
    ld xl,a 
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
; les arguments sont décalés de 5 octets:
;   2 pour l'adresse de retour 
;   6 pour ACC24   variable locale 
    ARG_OFS=5
    N1=ARG_OFS+1  ; argument 1 
    N2=ARG_OFS+4  ; argument 2
; variable locale de 24 bits
    ACC24=1 ; 3 octets
    LOCAL_SIZE=3
mult24u:
    sub sp,#LOCAL_SIZE
; multiplie N2bit7:0 x N1 
    ld a,(N2+2,sp)
    push a 
    ld a,(N1+2,sp)
    ldw x,(N1,sp)
    push a 
    pushw x 
    call mul24_8u
    addw sp,#4 ;  supprime arguments de mul24_8u
; produit partiel 1
    ld (ACC24+2,sp),a 
    ldw (ACC24,sp),x
; multiplie N2bit15:8 x N1     
    ld a,(N2+1,sp)
    push a 
    ld a,(N1+2,sp)
    ldw x,(N1,sp)
    push a 
    pushw x 
    call mul24_8u
    addw sp,#4
; additionne produit partiel 2 à produit partiel 1
;  xh représente un débordement après le bit 23 donc ignoré.
    rlwa x 
    addw x,(ACC24+1,sp)
    ldw (ACC24,sp),x 
; multiplie N2bits23:16 x N1     
    ld a,(N2,sp)
    push a 
    ld a,(N1+2,sp)
    ldw x,(N1,sp)
    push a 
    pushw x 
    call mul24_8u
    addw sp,#4
; additionne produit partiel 3 à acc24 
    add a,(ACC24,sp)
    ld (ACC24,sp),a 
; retourne le produit dans X:A 
    ldw x,(ACC24,sp)
    ld a,(ACC24+2,sp)
    addw sp,#LOCAL_SIZE 
    ret 


;-------------------------------
;  division non signé de U1/U2 
; input:
;   U1      dividende 24 bits
;   U2      diviseur  16 bits 
; output:
;   X:A     quotient U1/U2 
;   Y       reste 
;------------------------------
    ARG_OFS= 7
    U1 = ARG_OFS+1
    U2 = ARG_OFS+4
; variable locale 
    QUOT = 1 ; quotient
    MOD = 4  ; reste de la division 
    LOCAL_SIZE=5
div24_16u::
    sub sp,#LOCAL_SIZE 
    clrw x 
    ldw (MOD,sp),x 
    ldw (QUOT,sp),x 
    clr (QUOT+2,sp)
    ldw y,(U2,sp)
    tnzw y 
    jrne 1$
    .byte 0x71 ; division par zéro réinitialise le MCU.
1$: ldw x,(U1,sp) 
    tnzw x 
    jrne 2$
    tnz (U1+2,sp)
    jreq 6$ ; U1==0 , division complétée  
2$:
    cpw x,(U2,sp)
    jruge 3$
; multiplie diviende par 2    
    ld a,(U1+2,sp)
    sll a 
    sllw x
    ld (U1+2,sp),a
    ldw (U1,sp),x 
; multiplie quotient par 2     
    ld a,(QUOT+2,sp)
    ldw x,(QUOT,sp)
    sll a 
    sllw x 
    ld (QUOT+2,sp),a 
    ldw (QUOT,sp),x 
    jra 2$ 
3$: divw x,y  
    ldw (MOD,sp),y 
    ldw y,(U2,sp) 
    addw x,(QUOT+1,sp)
    ldw (QUOT+1,sp),x 
;    jrnc 1$
;    inc ( QUOT,sp)
    jra 1$
6$: ldw x,(ACC24,sp)
    ld a,(ACC24+2,sp)
    ldw y,(MOD,sp)
    addw sp,#LOCAL_SIZE 
    ret 

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

