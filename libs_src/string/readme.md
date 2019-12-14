# string.lib

Cette librairie contient quelques fonctions pour la manipulation de chaînes de caractères ASCII. Toutes ces fonctions sont écrites en assembleur.

## int24_t atoi24(const char *string)

Convertie la chaîne de caractère en entier 24 bits. Si la chaîne débute par **"0x"** elle est présumée représenter un entier en base hexadécimal. Les entiers décimaux peuvent-être précédés par le signe **'-'**. 

## char* fill(char* buffer,char c,uint8_t count)
Remplie le tampon **buffer** avec le caractère **c**. **count** est le nombre de caractères à insérer dans le tampon. 

## char* format(char* buffer,const char* fmt, ....)
  Créé une chaîne de caractères ASCII en mettant en correspondance le format **fmt** et la liste variable des arguments. Il s'agit d'une version simplifiée de sprintf() disponible en **C**. Les formats sont les suivants:
* %a  remplissage avec le caractère ASCII *espace*. Le nombre de caractères à fournir est déterminé par l'argument de type **uint8_t**. 
* %c  insère un caractère ASCII dans la chaîne. L'argument est de type ASCII char. 
* %d  convertie l'argument de type int24_t en sa représentation ASCII décimale.
* %s  insère une chaîne ASCII terminée par 0 dans la chaîne. l'argument est de type uint16_t et est un pointeur vers la chaîne à insérer.
* %x  convertie l'argument de type int24_t en sa représentation ASCII hexadécimale. 

Si le caractère qui suit le **'%'** n'est pas dans la liste ci-haut il est inséré comme un caractère normal. Exemple:
```
const char fmt="ABC%a%c%a%s%a%d%a%x\n"
char  buffer[80];
char* p=format(buffer,fmt,4,'U',4,"Hello world!",4,-23545,4,0x123456);
// résultat:
// ABC    U    Hello world!    -23545    0x123456

```


## char* memcpy(char* dest, const char* src,uint16_t count)
   Copie **count** octets de **src** vers **dest**. retourne le pointeur **dest**. 

## char* i24toa(int24_t n,uint8_t base,char* buffer)
Convertie l'entier 24 bits **n** en chaîne ASCII 0 terminée en utilisant **base** comme base numérique de convertion. si cette base est **16** le préfix **"0x"** est ajoutée à la base. **buffer** reçoit le résultat de la convertion. la fonction retourne un pointer vers **buffer**. 

## char* strcpy(char* dest, const char* src)
Copie la chaîne ASCII 0 terminée **src** vers **dest**. Le pointeur retournée est celui de **dest**. 

## uint16_t strlen(const char* str)

Retourne la longueur de la chaîne ASCII 0 terminée **str**





