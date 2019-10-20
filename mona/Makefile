###########################################################
# makefile for MONA
###########################################################

BOARD=stm8s208rb
PROGRAMMER=stlinkv21

SDAS=sdasstm8
SDCC=sdcc
SDLD=sdld
LDFLAGS=--out-fmt-ihx
CFLAGS=
FLASH=stm8flash
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
OBJECTS=$(BUILD)mona.rel
SYMBOLS=$(OBJECTS:.rel=.sym)
ASMS=$(OBJECTS:.rel=.asm)
LISTS=$(OBJECTS:.rel=.lst)
RSTS=$(OBJECTS:.rel=.rst)
TARGET=$(BUILD)mona.ihx
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

%.rel: mona.asm  $(INC)stm8s208.inc
	@echo
	@echo "***************"
	@echo "   assembling  "
	@echo "***************"
	$(SDAS) -g -l -o $(BUILD)mona.rel mona.asm 
	
$(TARGET): $(OBJECTS) $(INCLUDES)
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
