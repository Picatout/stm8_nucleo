#############################
# librairies make file
#############################

LIBNAME=math24.lib 
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
CFLAGS=
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
LIB_PATH=../../lib/
ASM_SRC=math24.asm
C_SRC=
C_HEADERS=$(C_SRC:.c=.h)
OBJECTS=$(BUILD)$(ASM_SRC:.asm=.rel)
LIB=$(LIB_PATH)$(LIBNAME)
LIBREL=$(LIBNAME:.lib=.rel)
SYMBOLS=$(OBJECTS:.rel=.sym)
LISTS=$(OBJECTS:.rel=.lst)

.PHONY: all

all: clean archive

.PHONY: archive 

archive: $(LIBREL) 
	@echo
	@echo "*****************"
	@echo "creating archives"
	@echo "*****************"
	$(SDAR) -rc $(LIB) $(BUILD)$(LIBREL)

 
math24.rel: math24.asm 
	$(SDAS) -l -o $(OBJECTS) $(ASM_SRC)


.PHONY: clean 
clean: build
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*

build:
	mkdir build

