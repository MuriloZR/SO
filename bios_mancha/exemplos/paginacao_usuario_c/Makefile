MCC = ../../../compilador_c/bin/mcc
MONTADOR = ../../../simulador_completo/bin/montador
BIOS = ../../src/bios.asm

all: paginacao_usuario_c.mob

kernel.asm: kernel.c
	$(MCC) kernel.c -o kernel.asm

paginacao_usuario_c.mob: $(BIOS) ponte.asm kernel.asm dados.asm
	$(MONTADOR) $(BIOS) ponte.asm kernel.asm dados.asm -o paginacao_usuario_c.mob

clean:
	rm -f kernel.asm paginacao_usuario_c.mob

.PHONY: all clean
