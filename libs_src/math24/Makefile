#############################
# librairies make file
#############################
BOARD=stm8s208rb
PROGRAMMER=stlinkv21
FLASH=stm8flash
NAME=math24
LIBNAME=$(NAME).lib 
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
CFLAGS=
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
LIB_PATH=../../lib/
ASM_SRC=$(NAME).asm
C_SRC=
C_HEADERS=$(C_SRC:.c=.h)
OBJECTS=$(BUILD)$(ASM_SRC:.asm=.rel)
LIB=$(LIB_PATH)$(LIBNAME)
LIBREL=$(LIBNAME:.lib=.rel)
SYMBOLS=$(OBJECTS:.rel=.sym)
LISTS=$(OBJECTS:.rel=.lst)

.PHONY: all

all: title clean archive

.PHONY: archive 

archive: $(LIBREL) 
	@echo
	@echo "****************************"
	@echo "creating $(LIBNAME) archives"
	@echo "****************************"
	$(SDAR) -rc $(LIB) $(BUILD)$(LIBREL)

 
$(NAME).rel:
	@echo
	@echo "**********************"
	@echo "assembling $(ASM_SRC)       "
	@echo "**********************"
	$(SDAS) -l -o $(OBJECTS) $(ASM_SRC)


.PHONY: title
title:
	@echo
	@echo "*****************"
	@echo "creating $(NAME)"
	@echo "*****************"


.PHONY: clean 
clean: build
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*

build:
	mkdir build

.PHONY: test 
test: $(OBJECTS)
	@echo
	@echo "***************"
	@echo "building test "
	@echo "***************"
	$(SDAS) -g -l -o $(BUILD)math24_test.rel math24_test.asm 
	$(SDCC) -L$(LIB_PATH) -lmath24 -luart -mstm8 -lstm8 $(LDFLAGS) -o $(BUILD)math24_test.ihx $(BUILD)math24_test.rel 
	@echo
	@echo "***************"
	@echo "flashing device"
	@echo "***************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(BUILD)math24_test.ihx 


