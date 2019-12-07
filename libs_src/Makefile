###############################
#   make all libraries
###############################
FLASH=stm8flash
BOARD=stm8s208rb
PROGRAMMER=stlinkv21

SUBDIRS=math24  uart conio 

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

test_conio: $(SUBDIRS) conio/conio_test.asm
	rm -f build/*
	rm -f conio/build/*
	sdasstm8 -g -l -o build/test_help.rel test_help.asm
	sdasstm8 -g -l -o conio/build/conio_test.rel conio/conio_test.asm  
	sdcc -mstm8 -lstm8 -I../inc -L../lib -luart -lconio -o conio/build/conio_test.ihx\
	 build/test_help.rel conio/build/conio_test.rel
	$(FLASH) -c $(PROGRAMMER) -p $(BOARD) -w conio/build/conio_test.ihx 
