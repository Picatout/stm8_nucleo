###########################################################
# makefile for $(NAME)
###########################################################

BOARD=stm8s208rb
PROGRAMMER=stlinkv21
NAME=mona05

SDAS=sdasstm8
SDCC=sdcc
SDLD=sdld
LDFLAGS=--out-fmt-ihx
CFLAGS=
FLASH=stm8flash
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
OBJECTS=$(BUILD)$(NAME).rel $(BUILD)mona_dasm.rel 
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

%.rel: $(NAME).asm  $(INC)stm8s208.inc $(INC)ascii.inc $(INC)nucleo_8s208.inc mona_dasm.asm mnemonics.inc 
	@echo
	@echo "***************"
	@echo "   assembling  "
	@echo "***************"
	$(SDAS) -g -l -s -o $(BUILD)$(NAME).rel $(NAME).asm
	$(SDAS) -g -l -s -o $(BUILD)mona_dasm.rel mona_dasm.asm
	
$(TARGET): $(OBJECTS) $(INCLUDES) mona_dasm.asm 
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
