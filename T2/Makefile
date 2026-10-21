CC = ../compilador_c/bin/mcc
MONTADOR = ../simulador_completo/bin/montador
BIOS = ../bios_mancha/src/bios.asm

# Isola o kernel dos outros arquivos .c da pasta
USER_C   = $(filter-out kernel.c, $(wildcard *.c))

# Define os arquivos .mob finais baseados nos programas de usuário encontrados
USER_MOB = $(USER_C:.c=.mob)

REMOVABLES = $(filter-out ponte.asm, $(wildcard *.asm))

# Mantém os arquivos intermediários .asm
.PRECIOUS: %.asm kernel.asm

all: $(USER_MOB)

# Regra genérica para compilar qualquer .c em .asm
%.asm: %.c
	$(CC) -I. $< -o $@

# Regra genérica para gerar cada .mob:
# Junta a BIOS, o ponte.asm, o kernel.asm e o .asm do programa de usuário correspondente
%.mob: %.asm kernel.asm
	$(MONTADOR) $(BIOS) ponte.asm kernel.asm $< -o $@

clean:
	rm -f $(REMOVABLES) *.mob

.PHONY: all clean