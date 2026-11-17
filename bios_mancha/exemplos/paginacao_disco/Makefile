MONTADOR = ../../../simulador_completo/bin/montador
MOB2BIN  = ../../../simulador_completo/bin/mob2bin
BIOS     = ../../src/bios.asm

# tamanho de um setor/quadro -- ver DISCO_TAM_SETOR em
# ../../../simulador_completo/src/dispositivos.h (não por acaso, igual
# ao tamanho de um quadro físico sob paginação)
TAM_SETOR = 512

all: paginacao_disco.mob disco.img

# processoA.asm/processoB.asm são montados SOZINHOS (nenhum outro .asm na
# mesma chamada) -- ver os comentários lá para o motivo.
processoA.mob: processoA.asm
	$(MONTADOR) $< -o $@

processoB.mob: processoB.asm
	$(MONTADOR) $< -o $@

processoA.bin: processoA.mob
	$(MOB2BIN) $< $(TAM_SETOR) $@

processoB.bin: processoB.mob
	$(MOB2BIN) $< $(TAM_SETOR) $@

# disco.img: setor 0 = processoA, setor 1 = processoB (face=0, trilha=0
# -- ver kernel.asm, _kernel_inicio, e disp_monta_disco em
# ../../../simulador_completo/src/dispositivos.c: um arquivo menor que o
# tamanho real do disco é aceito, o resto fica zerado)
disco.img: processoA.bin processoB.bin
	cat processoA.bin processoB.bin > $@

paginacao_disco.mob: $(BIOS) kernel.asm
	$(MONTADOR) $(BIOS) kernel.asm -o $@

clean:
	rm -f processoA.mob processoB.mob processoA.bin processoB.bin disco.img paginacao_disco.mob

.PHONY: all clean
