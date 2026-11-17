# Makefile do simulador do processador Mancha completo
# ver mancha.pdf (secções 2 a 13) e src/*.c para a implementação

CC = gcc
CFLAGS = -Wall -Wextra -std=gnu11 -g -Isrc
LDLIBS_SIM = -lcurses

SRC = src
BIN = bin
EX  = exemplos

COMUM = $(SRC)/instrucao.c $(SRC)/objeto.c $(SRC)/memoria.c

SIM_SRC = $(SRC)/main.c $(SRC)/cpu.c $(SRC)/dispositivos.c $(SRC)/tela.c $(COMUM)
MONT_SRC = $(SRC)/montador.c $(COMUM)

ASM_EXEMPLOS = $(wildcard $(EX)/*.asm)
MOB_EXEMPLOS = $(ASM_EXEMPLOS:.asm=.mob)

MOB2BIN_SRC = $(SRC)/mob2bin.c $(COMUM)

.PHONY: all simulador montador mob2bin exemplos clean

all: simulador montador mob2bin exemplos

simulador: $(BIN)/simulador

montador: $(BIN)/montador

mob2bin: $(BIN)/mob2bin

$(BIN):
	mkdir -p $(BIN)

$(BIN)/simulador: $(SIM_SRC) $(wildcard $(SRC)/*.h) | $(BIN)
	$(CC) $(CFLAGS) -o $@ $(SIM_SRC) $(LDLIBS_SIM)

$(BIN)/montador: $(MONT_SRC) $(wildcard $(SRC)/*.h) | $(BIN)
	$(CC) $(CFLAGS) -o $@ $(MONT_SRC)

# mob2bin: converte um .mob já resolvido num binário achatado (ver
# src/mob2bin.c) -- usado por exemplos que montam processos sozinhos
# (contador de endereço começando em 0) para gravar o resultado num
# setor de disco, em vez de num .mob combinado com o resto do sistema.
$(BIN)/mob2bin: $(MOB2BIN_SRC) $(wildcard $(SRC)/*.h) | $(BIN)
	$(CC) $(CFLAGS) -o $@ $(MOB2BIN_SRC)

exemplos: $(BIN)/montador $(MOB_EXEMPLOS)

$(EX)/%.mob: $(EX)/%.asm $(BIN)/montador
	$(BIN)/montador $< -o $@

clean:
	rm -rf $(BIN) $(EX)/*.mob
