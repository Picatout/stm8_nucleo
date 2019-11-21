###########################################################
# makefile for $(NAME)
###########################################################

BOARD=stm8s208rb
PROGRAMMER=stlinkv21
NAME=mona05
APP=app_test
SDAS=sdasstm8
SDCC=sdcc
SDLD=sdld
LDFLAGS=--out-fmt-ihx
CFLAGS=
FLASH=stm8flash
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
SRC=$(NAME).asm mona_glbls.asm mona_dasm.asm $(APP).asm 
INCLUDE=$(INC)ascii.inc $(INC)stm8s208.inc  $(INC)nucleo_8s208.inc mnemonics.inc mona.inc
OBJECTS=$(BUILD)$(NAME).rel  $(BUILD)mona_glbls.rel $(BUILD)mona_dasm.rel $(BUILD)$(APP).rel 
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

%.rel: $(SRC)  $(INCLUDES)
	@echo
	@echo "***************"
	@echo "   assembling  "
	@echo "***************"
	$(SDAS) -g -l -s -o $(BUILD)$(NAME).rel $(NAME).asm
	$(SDAS) -g -l -s -o $(BUILD)mona_glbls.rel mona_glbls.asm
	$(SDAS) -g -l -s -o $(BUILD)mona_dasm.rel mona_dasm.asm
	$(SDAS) -g -l -s -o $(BUILD)$(APP).rel $(APP).asm
	
$(TARGET): $(OBJECTS) $(INCLUDES) $(SRC) 
	@echo
	@echo "***************"
	@echo "linking files"
	@echo "***************"
	$(SDCC) -mstm8 -lstm8 $(LDFLAGS) -o $@ $(OBJECTS) 
	@ls -gG $(TARGET)
	
    	
clean:
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*

.PHONY: all clean flash
