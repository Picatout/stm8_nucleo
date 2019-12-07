#############################
# uart make file
#############################
NAME=uart
LIBNAME=$(NAME).lib 
SDAS=sdasstm8
SDCC=sdcc
SDLD=sdldstm8
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
FLASH=stm8flash
BOARD=stm8s208rb
PROGRAMMER=stlinkv21
TARGET=$(BUILD)$(NAME)_test.ihx 

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
	@echo "*****************"
	@echo "assembling $(ASM_SRC)"
	@echo "*****************"
	$(SDAS) -l -o $(OBJECTS) $(ASM_SRC)

.PHONY: title
title:
	@echo
	@echo "*****************"
	@echo "creating $(NAME)"
	@echo "*****************"


PHONY: test 

test: $(OBJECTS)
	$(SDAS) -g -l -o $(BUILD)uart_test.rel uart_test.asm 
	$(SDCC) -mstm8 -lstm8 -L$(LIB_PATH) -luart -o $(BUILD)$(NAME)_test.ihx $(BUILD)$(NAME)_test.rel 
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

