###########################################################
# makefile for $(NAME)
###########################################################

BOARD=stm8s208rb
PROGRAMMER=stlinkv21
CNAME=ch5_c
ANAME=ch5_asm
TNAME=ch5_demo
SDAS=sdasstm8
SDCC=sdcc
SDLD=sdldstm8
LDFLAGS=--out-fmt-ihx
CFLAGS=
FLASH=stm8flash
INC=../inc/
INCLUDES=$(INC)stm8s208.inc
BUILD=build/
LIB_PATH=../lib
CREL=$(BUILD)$(CNAME).rel 
AREL=$(BUILD)$(ANAME).rel
OBJECTS=$(CREL) $(AREL) 
SYMBOLS=$(OBJECTS:.rel=.sym)
ASMS=$(OBJECTS:.rel=.asm)
LISTS=$(OBJECTS:.rel=.lst)
RSTS=$(OBJECTS:.rel=.rst)
TARGET=$(BUILD)$(TNAME).ihx
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

%.rel: $(ANAME).asm $(CNAME).c  $(INC)stm8s208.inc
	@echo
	@echo "**************"
	@echo "  assemblage  "
	@echo "**************"
	$(SDAS) -g -l -o $(AREL) $(ANAME).asm 
	$(SDCC) -c -mstm8 -o $(CREL) $(CNAME).c 


$(TARGET): $(OBJECTS) $(INCLUDES)
	@echo
	@echo "***************"
	@echo "linking files"
	@echo "***************"
	$(SDCC)  -mstm8 -L$(LIB_PATH) -lstm8 -luart $(LDFLAGS) -o $@ $(OBJECTS) 
	@ls -gG $(TARGET)
	
    	
clean:
	@echo
	@echo "***************"
	@echo "cleaning files"
	@echo "***************"
	rm -f $(BUILD)*

.PHONY: all clean flash
