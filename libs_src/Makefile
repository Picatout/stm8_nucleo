###############################
#   make all libraries
###############################

SUBDIRS=math24  uart conio 

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

test_help: test_help.asm
	@echo
	@echo *********************
	@echo *  make test_help   *
	@echo *********************
	rm -f build/*
	sdasstm8 -g -l -o build/test_help.rel test_help.asm

