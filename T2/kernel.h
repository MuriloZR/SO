// kernel.h
#ifndef KERNEL_H
#define KERNEL_H

#define MAX_PROC 8

typedef enum {
    LIVRE = 0,
    PRONTO,
    EM_EXECUCAO,
    BLOQUEADO,
    MORTO
} Estado;

typedef enum {
    MOTIVO_NENHUM = 0,
    MOTIVO_ESPERA_IO_LEITURA,
    MOTIVO_ESPERA_IO_ESCRITA,
    MOTIVO_ESPERA_PROCESSO
} MotivoBloqueio;

typedef struct {
    int pid;
    int pid_esperado;
    Estado estado;
    MotivoBloqueio motivo;
    unsigned short quadro[16]; // Cópia dos 16 registradores
} Processo;

// Globais declaradas conforme esperadas por ponte.asm
Processo processos[MAX_PROC];
int processo_atual;

#endif