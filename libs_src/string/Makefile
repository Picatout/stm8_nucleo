#############################
# uart make file
#############################
NAME=string
LIBNAME=$(NAME).lib 
SDAS=sdasstm8
SDCC=sdcc
SDAR=sdar
CFLAGS=-mstm8 -DSTM8S208 -I ../../inc
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
TARGET=$(BUILD)string_test.ihx 
TEST_HELP=../build/test_help.rel
TEST_NAME=string_test

.PHONY: all

all: title clean archive

.PHONY: archive 

archive: $(LIBREL) 
	@echo
	@echo "****************************"
	@echo "creating $(LIBNAME) archives"
	@echo "****************************"
	$(SDAR) -rc $(LIB) $(BUILD)$(LIBREL)


.PHONY: title
title:
	@echo
	@echo "*****************"
	@echo "creating $(NAME)"
	@echo "*****************"

 
$(NAME).rel:
	@echo
	@echo "*****************"
	@echo "assembling $(ASM_SRC)"
	@echo "*****************"
	$(SDAS) -g -l -o $(OBJECTS) $(ASM_SRC)

.PHONY: test 

test: $(LIB)
	@echo
	@echo "*****************"
	@echo "creating test    "
	@echo "*****************"
	$(SDAS) -g -l -o $(BUILD)$(TEST_NAME).rel $(TEST_NAME).asm 
	$(SDCC) $(CFLAGS) -L$(LIB_PATH) -lmath24 -lstring -lconio -luart -o$(TARGET) $(TEST_HELP) $(BUILD)$(TEST_NAME).rel
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(TARGET)


.PHONY: clean 
clean: build
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*


build:
	mkdir build

