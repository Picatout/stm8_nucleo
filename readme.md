[//]: # (test de commentaire)
# STM8 Nucleo
Mes explorations de la carte NUCLEO-8S208RB. Cette carte a des connecteurs (CN4,CN5,CN7 et CN8) qui sont compatible avec les cartes d'extension Arduino.
Les connecteurs CN1 et CN2 permettent l'installation de cartes d'extension vendu par STMicroelectronics.

De plus des projets pour cette carte peuvent-être développés en utilisant l'IDE Arduido. 

![carte NUCLEO-8S208RB](docs/images/carte.png)
## organisation
* **docs** contient des fichiers PDF fournis par le fabriquant STMicroelectronics ainsi que d'autres documents utiles.
* **docs/images**   Contient les images qui sont affichées dans les différents fichiers __*.md__.
* **inc** Contient les fichiers d'assembleur __*.inc__ d'usage pour les différents projets. 
* **chx_nom** pour chaque chapitre du tutoriel est dans son dossier dont le nom a cette forme. Par exemple le dossier **ch1_blink** est le chapitre du tutoriel avec le progamme exemple **blink.asm**. Chacun de ces dossiers contient un fichier **readme.md** qui contient le texte du tutoriel pour ce chapitre. 
* Tous les autres dossiers correspondent à un programme. Chacun d'eux contient les fichiers sources, un Makefile et des fichiers de documentations spécifiques au programme. Chacun d'eux devrait avoir un fichier **readme.md** qui s'affichera automatiquement lors de l'ouverture du dossier sur https://github.com/picatout/stm8_nucleo.
## fichiers à consulter
* [processeur STM8](stm8.md) pour une brève présentation du cpu STM8
* [manuel de programmation du STM8](docs/pm0044_stm8_programming.pdf)
* [feuillet de spécification du STM8S208](docs/stm8s208rb.pdf)
* [manuel de l'utilisateur de la carte NUCLEO-8S208RB](docs/nucleo-8s208rb_user_manual.pdf)
* [référence STM8S](docs/stm8s_reference.pdf) pour une description du fonctionnement des périphériques utilisés dans les MCU STM8S.
* [documentation de SDAS](docs/asmlnk.txt) documentation de l'assembleur SDAS faisant parti du projet SDCC.