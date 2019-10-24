# Tutoriel assembleur sdas

## présentation

Utilisation du fichier [mona.asm](mona.asm) comme tutoriel de programmation en assembleur pour STM8 en utilisant sdas. Les deux documents requis pour suivre ce ditactitiel sont dans le dossier **docs**. Il s'agit de [asmlnk.txt](../docs/asmlnk.txt) qui documente l'assembleur. L'autre est le [manuel de programmation du STM8](../docs/pm0044_stm8_programming.pdf) qui est la référence pour la progammation des STM8. 

Un programme en assembleur contient les éléments suivants:
* Les commentaires qui débutent par le caractère **';'** et se terminent à la fin de la lgine.
* Les directives à l'assembleur ces directives commence toutes par un **'.'** suivit sans espace par le nom de la directive. La directive elle même peut-être suivit d'un certain nombre d'arguments. Exemple:
**.org 0x4000** ;déplace le pointeur de code à l'adresse 0x4000.
* la définition de symboles représentant des constantes.
* Les instructions machines. Il y a une instruction machine par ligne. Une instruction machine peut-être précédée par une étiquette qui représente une adresse de branchement ou la position d'une variable dans la RAM. Pour connaître les mnémoniques des instructions du STM8 il faut consulter le manuel de référence de programmation mentionné ci-haut.

Le fichier Makefile utilisé pour la construction du projet a été configuré pour que les fichiers générés par l'assembleur et le linker se retrouve dans le dossier **build**. Il y en a plusieurs mais on a pas vraiment besoin  de les consulter sauf peut-être le fichier [build/mona.lst](build/mona.lst) si on veut voir de quoi à l'air le code machine généré par l'assembleur.

Voici comment fonctionne la construction d'un projet. L'assembleur transforme le fichier source en un fichier de code binaire mais avec des adresses relatives [build/mona.rel](build/mona.rel) et génère aussi un listing appellé [build/mona.lst](build/mona.lst). Ensuite le linker (générateur de liens) utilise ces fichiers pour générer le fichier [build/mona.ihx](build/mona.ihx) qui contient le code binaire utilisé pour programmer le microcontrôleur. Le projet MONA contient un seul fichier source mais dans un projet plus complexe il y a plusieurs fichiers sources qui sont assemblés indépendemment les uns des autres et génèrent chacun des fichiers __*.rel__ et __*.lst__. Le travail du linker est de joindre tous ces bouts de codes ensemble en évitant les conflits d'adresses. S'il  n'y arrive pas il affiche un message d'erreur d'allocation.


## mona.asm

```
;  MONA   MONitor written in Assembly
	.module MONA 
    .optsdcc -mstm8
;	.nlist
	.include "../inc/nucleo_8s208.inc"
	.include "../inc/stm8s208.inc"
;	.list
	.page

```
A part les commentaires dans le bloc précédent on n'a que des directives destinées à l'assembleur. 

* **.module MONA** nomme simplement ce fichier.
* **.optsdcc -mstm8** indique à l'assembleur qu'il s'agit de code pour le STM8
* **.list** Cette directive indique simplement que les lignes de code suivantes n'apparaitrons pas dans le listing généré par l'assembleur. Ici la directive a été mise en commentaire et n'a donc aucun effet.
* **.include "../inc/nucleo_8s208.inc"**  informe l'assembleur qu'il doit traiter se fichier avant de continuer avec celui-ci. Ce fichier contient des informations spécifique à la carte NUCLE-8S208RB.
* **.include "../inc/stm8s208.inc"** informe l'assembleur qu'il doit traiter ce fichier avant de continuer avec celui-ci. Ce fichier contient toutes les constantes nécessaires à l'utilisation du mcu stm8s208. Ce fichier a été créé en consultant le datasheet du microcontrôleur et contient le nom de tous les registres de contrôle des périphériques avec leur adresse. Il contient aussi le nom symbolique des différents bits à l'intérieur de chacun de ces registres. L'utillisation de noms symboliques plutôt que des adresses simplifie grandement la programmation et rend le texte plus compréhensible.
* **.page** est une directive qui indique simplement à l'assembleur d'insérer un saut de page dans le listing qu'il génère.

```
;-------------------------------------------------------
;     vt100 CTRL_x  values
;-------------------------------------------------------
		CTRL_A = 1
		CTRL_B = 2
		CTRL_C = 3
		CTRL_D = 4
		CTRL_E = 5
		CTRL_F = 6
		CTRL_G = 7
		CTRL_H = 8
		CTRL_I = 9
		CTRL_J = 10
		CTRL_K = 11
		CTRL_L = 12
		CTRL_M = 13
		CTRL_N = 14
		CTRL_O = 15
		CTRL_P = 16
		CTRL_Q = 17
		CTRL_R = 18
		CTRL_S = 19
		CTRL_T = 20
		CTRL_U = 21
		CTRL_V = 22
		CTRL_W = 23
		CTRL_X = 24
		CTRL_Y = 25
		CTRL_Z = 26
		ESC = 27
		NL = CTRL_J
		CR = CTRL_M
		BSP = CTRL_H
		SPACE = 32

```
MONA communique avec le PC via un port sériel avec un émulateur de terminal VT100. Ici il s'agit simplement de définir des noms symboliques pour les codes de contrôles VT100.

```
;--------------------------------------------------------
;      MACROS
;--------------------------------------------------------
		.macro _ledenable ; set PC5 as push-pull output fast mode
		bset PC_CR1,#LED2_BIT
		bset PC_CR2,#LED2_BIT
		bset PC_DDR,#LED2_BIT
		.endm
		
		.macro _ledon ; turn on green LED 
		bset PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledoff ; turn off green LED
		bres PC_ODR,#LED2_BIT
		.endm
		
		.macro _ledtoggle ; invert green LED state
		ld a,#LED2_MASK
		xor a,PC_ODR
		ld PC_ODR,a
		.endm
		
		
		.macro  _interrupts ; enable interrupts
		 rim
		.endm
		
		.macro _no_interrupts ; disable interrupts
		sim
		.endm


```

SDAS possède un langage de macro. Les macros en assembleurs simplifie grandements la programmation. Entre les directives **.macro** et **.endm**
on retrouve des instructions machines qui seront insérées dans le code source chaque fois que l'assembleur rencontre le nom de la macro. Les macros rendent le code plus lisible et évite aussi d'avoir à resaissir plusieurs foit les même lignes de codes qui se répètent dans un programme. Prenons par exemple la macro **_ledenable**. Les 3 instructions machine qu'elle contient servent à configuré la broche sur laquelle est branchée la LED2 en mode sortie push-pull. Cette macro n'est invoquée qu'une seule fois on aurait put inscrire directement ces 3 instructions directement à l'endroit où est invoquée cette macro ou encore en faire une sous-routine mais cette façon de faire est aussi valide. Les macros **_ineterrupts** et **_no_interrupts** ne contiennent qu'une seule instruction qu'on aurait pu inséré directement dans le code mais il me semble que ces noms de macros sont plus parlant que le mnémonique qu'elle remplace.

**_ledon** est invoquée pour allumer la LED2. **_ledoff** pour l'éteindre et **_led_toggle** pour en inverser l'état.