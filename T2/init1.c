#include "lib.h"

void processo_filho1(void) {
    so_escreve('F');
    so_escreve('1');
    so_escreve('\n');
    so_mata_proc(0);
}

void processo_filho2(void) {
    so_escreve('F');
    so_escreve('2');
    so_escreve('\n');
    so_mata_proc(0);
}

void init(void) {
    int pid1;
    int pid2;

    so_escreve('I');
    so_escreve('n');
    so_escreve('i');
    so_escreve('t');
    so_escreve('\n');

    pid1 = so_cria_proc(processo_filho1);
    pid2 = so_cria_proc(processo_filho2);

    // Espera os filhos encerrarem (sincronização explícita via Syscall)
    if (pid1 > 0) so_espera_proc(pid1);
    if (pid2 > 0) so_espera_proc(pid2);

    // O Init encerra por último, disparando a rotina de encerramento do SO
    so_mata_proc(0);
}