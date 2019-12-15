#############################
# librairies make file
#############################
NAME=math24
LIBNAME=$(NAME).lib 
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
CFLAGS=-mstm8 -lstm8 -L$(LIB_PATH)
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
FLASH=stm8flash
BOARD=stm8s208rb
PROGRAMMER=stlinkv21
TEST_NAME=math24_test
TEST_HELP=../build/test_help.rel

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

test: $(LIB)
	@echo
	@echo "*********************"
	@echo "building test_math24 "
	@echo "*********************"
	$(SDAS) -g -l -o $(BUILD)$(TEST_NAME).rel $(TEST_NAME).asm 
	$(SDCC) $(CFLAGS) -lmath24 -lstring -o $(BUILD)$(TEST_NAME).ihx $(TEST_HELP) $(BUILD)$(TEST_NAME).rel 
	@echo
	@echo "***************"
	@echo "flashing device"
	@echo "***************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(BUILD)$(TEST_NAME).ihx 


