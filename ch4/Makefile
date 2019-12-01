###########################################################
# makefile for $(NAME)
###########################################################

BOARD=stm8s208rb
PROGRAMMER=stlinkv21
NAME=ch4_demo
SDAS=sdasstm8
SDCC=sdcc
SDLD=sdld
LDFLAGS=--out-fmt-ihx
CFLAGS=
FLASH=stm8flash
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
LIB_PATH=../lib/
USE_LIB=uart  
OBJECTS=$(BUILD)$(NAME).rel
SYMBOLS=$(OBJECTS:.rel=.sym)
ASMS=$(OBJECTS:.rel=.asm)
LISTS=$(OBJECTS:.rel=.lst) 
RSTS=$(OBJECTS:.rel=.rst)
TARGET=$(BUILD)$(NAME).ihx
MAP=$(TARGET:.ihx=.map)
LK=$(TARGET:.ihx=.lk)
CDB=$(TARGET:.ihx=.cdb)

.PHONY: all flash

all: clean $(TARGET) 

flash: $(TARGET)
	@echo
	@echo "***************"
	@echo "flashing device"
	@echo "***************"
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w $(TARGET)

%.rel: $(NAME).asm  $(INC)stm8s208.inc
	@echo
	@echo "***************"
	@echo "   assembling  "
	@echo "***************"
	$(SDAS) -g -l -o $(BUILD)$(NAME).rel $(NAME).asm 
	
$(TARGET): $(OBJECTS) $(INCLUDES)
	@echo
	@echo "***************"
	@echo "linking files"
	@echo "***************"
	$(SDCC) -L$(LIB_PATH) -lmath24 -luart -mstm8 -lstm8 $(LDFLAGS) -o $@ $(OBJECTS) 
	@ls -gG $(TARGET)
	
    	
clean: build 
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*

build:
	mkdir build

.PHONY: all clean flash
