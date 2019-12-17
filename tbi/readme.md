# TinyBASIC for STM8

Il s'agit d'une implémentation du [TinyBASIC](https://en.wikipedia.org/wiki/Tiny_BASIC) originellement conçu par [Dennis Allison](https://en.wikipedia.org/wiki/Dennis_Allison) au milieu des années 197x. Cette implémentation est créée à partir des documents fournis par Tom Pittman de [Itty Bitty Computers](http://www.ittybittycomputers.com/).

Il s'agit d'un système à 3 couches. 

*  Code assembleur décrivant une machine virtuelle qui exécute un langage intermétdiaire.
*  Code IL  qui tourne sur la machine virtuelle. Cette machine est décrite en annexe du document [TB_experimenter_kit.pdf](TB_experimenter_kit.pdf) produit par Tom Pittman en 1977. 
*  L'interpréteur TinyBASIC écris en language IL et qui exécute les programmes BASIC. Ce langage est décris dans le document [TB_user_manual.pdf](TB_user_manual.pdf).

## code source 

* **tbi_vm.asm**  Code source de la machine virtuelle.
* **tbi.asm** Code source de l'interpréteur TinyBASIC.

