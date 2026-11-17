MONTADOR = ../simulador_completo/bin/montador

EXEMPLOS_ASM = $(wildcard exemplos/*.asm)
EXEMPLOS_MOB = $(EXEMPLOS_ASM:.asm=.mob)

all: $(EXEMPLOS_MOB) multitarefa_c paginacao_usuario_c paginacao_disco paginacao_disco_c

exemplos/%.mob: exemplos/%.asm src/bios.asm
	$(MONTADOR) src/bios.asm $< -o $@

# exemplos à parte: têm seu próprio Makefile porque precisam compilar
# kernel.c com o mcc (../compilador_c/bin/mcc) antes de montar, ou (nos
# casos de paginacao_disco/paginacao_disco_c) montar processos sozinhos
# e montar um disco simulado antes do .mob final
multitarefa_c:
	$(MAKE) -C exemplos/multitarefa_c all

paginacao_usuario_c:
	$(MAKE) -C exemplos/paginacao_usuario_c all

paginacao_disco:
	$(MAKE) -C exemplos/paginacao_disco all

paginacao_disco_c:
	$(MAKE) -C exemplos/paginacao_disco_c all

clean:
	rm -f exemplos/*.mob
	$(MAKE) -C exemplos/multitarefa_c clean
	$(MAKE) -C exemplos/paginacao_usuario_c clean
	$(MAKE) -C exemplos/paginacao_disco clean
	$(MAKE) -C exemplos/paginacao_disco_c clean

.PHONY: all clean multitarefa_c paginacao_usuario_c paginacao_disco paginacao_disco_c
