CC = ../compilador_c/bin/mcc
MONTADOR = ../simulador_completo/bin/montador
RUNTIME = ../compilador_c/rt/runtime.asm ../compilador_c/rt/biblioteca.asm
INC = ../compilador_c/inc

# Obtém os arquivos .c da pasta atual (T1)
T1_C = $(wildcard *.c)
T1_MOB = $(T1_C:.c=.mob)

# Mantém os arquivos intermediários .asm gerados pelo compilador
.PRECIOUS: %.asm

all: $(T1_MOB)

# Regra para compilar o .c em .asm usando o mcc
%.asm: %.c
	$(CC) -I$(INC) $< -o $@

# Regra para montar o .asm em .mob usando o montador e o runtime
%.mob: %.asm
	$(MONTADOR) $(RUNTIME) $< -o $@

clean:
	rm -f *.asm *.mob

.PHONY: all clean
