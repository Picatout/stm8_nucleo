#############################
# conio make file
#############################
NAME=conio
LIBNAME=$(NAME).lib 
AS=sdasstm8
CC=sdcc
LD=sdld
AR=sdar
CFLAGS=-mstm8 -DSTM8S208 -I ../../inc
LDFLAGS=-rc
INC=../../inc/
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
TARGET=$(BUILD)conio_test.ihx 
TEST_HELP=../build/test_help.rel

.PHONY: all

all: title clean archive

.PHONY: archive 

archive: $(LIBREL) 
	@echo
	@echo "****************************"
	@echo "creating $(LIBNAME) archives"
	@echo "****************************"
	$(AR) -rc $(LIB) $(BUILD)$(LIBREL)

 
$(NAME).rel:
	@echo
	@echo "*****************"
	@echo "assembling $(ASM_SRC)"
	@echo "*****************"
	$(AS) -g -l -o $(OBJECTS) $(ASM_SRC)

.PHONY: test 

test: $(LIB)
	@echo
	@echo "*****************"
	@echo "creating test    "
	@echo "*****************"
	$(AS) -g -l -o $(BUILD)conio_test.rel conio_test.asm 
	$(CC) $(CFLAGS) -L$(LIB_PATH) -luart -lconio -o$(TARGET) $(TEST_HELP) $(BUILD)conio_test.rel
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(TARGET)


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

