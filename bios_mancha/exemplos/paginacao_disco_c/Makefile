MCC      = ../../../compilador_c/bin/mcc
MONTADOR = ../../../simulador_completo/bin/montador
MOB2BIN  = ../../../simulador_completo/bin/mob2bin
BIOS     = ../../src/bios.asm

TAM_SETOR = 512

all: paginacao_disco_c.mob disco.img

# processoA.c/processoB.c são compilados e depois montados SOZINHOS,
# junto só com escreve_caractere.asm (ver os comentários nos dois
# arquivos para o motivo).
processoA.asm: processoA.c
	$(MCC) processoA.c -o processoA.asm

processoB.asm: processoB.c
	$(MCC) processoB.c -o processoB.asm

processoA.mob: processoA.asm escreve_caractere.asm
	$(MONTADOR) processoA.asm escreve_caractere.asm -o $@

processoB.mob: processoB.asm escreve_caractere.asm
	$(MONTADOR) processoB.asm escreve_caractere.asm -o $@

processoA.bin: processoA.mob
	$(MOB2BIN) $< $(TAM_SETOR) $@

processoB.bin: processoB.mob
	$(MOB2BIN) $< $(TAM_SETOR) $@

# disco.img: setor 0 = processoA, setor 1 = processoB (face=0, trilha=0
# -- ver ponte.asm, _kernel_inicio)
disco.img: processoA.bin processoB.bin
	cat processoA.bin processoB.bin > $@

kernel.asm: kernel.c
	$(MCC) kernel.c -o kernel.asm

paginacao_disco_c.mob: $(BIOS) ponte.asm kernel.asm dados.asm
	$(MONTADOR) $(BIOS) ponte.asm kernel.asm dados.asm -o $@

clean:
	rm -f processoA.asm processoB.asm processoA.mob processoB.mob \
	      processoA.bin processoB.bin disco.img kernel.asm paginacao_disco_c.mob

.PHONY: all clean
