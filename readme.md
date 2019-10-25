# STM8 Nucleo
Mes explorations de la carte NUCLEO-8S208RB

## organisation
* **docs** contient des fichiers PDF fournis par le fabriquant STMicroelectronics ainsi que d'autres documents utiles. Il contient aussi les images qui sont affichées dans les différents fichiers __*.md__.
* **build**  Tous les fichiers générés pendant la construction d'un programme sont déposé dans ce répertoire.
* **hal**  Ce dossier contient le code source en **C** pour la couche d'abstraction matérielle des différents périphériques.
* **inc** Contient les fichiers d'entête __*.h__ et d'assembleur __*.inc__ d'usage pour les différents projets. Par exemple les fichiers __*.c__ qui sont dans **hal** ont un fichier correspondant __*.h__ ici.
* Tous les autres dossiers correspondent à un programme. Chacun d'eux contient les fichiers sources, un Makefile et des fichiers de documentations spécifiques au programme. Chacun d'eux devrait avoir un fichier **readme.md** qui s'affichera automatiquement lors de l'ouverture du dossier sur https://github.com/picatout/stm8_nucleo.
## fichiers à consulter
* [processeur STM8](stm8.md) pour une brève présentation du cpu STM8
* [manuel de programmation du STM8](docs/pm0044_stm8_programming.pdf)
* [feuillet de spécification du STM8S208](docs/stm8s208rb.pdf)
* [manuel de l'utilisateur de la carte NUCLEO-8S208RB](docs/nucleo-8s208rb_user_manual.pdf)
* [référence STM8S](docs/stm8s_reference.pdf) pour une description du fonctionnement des périphériques utilisés dans les MCU STM8S.
* [documentation de SDAS](docs/asmlnk.txt) documentation de l'assembleur SDAS faisant parti du projet SDCC.