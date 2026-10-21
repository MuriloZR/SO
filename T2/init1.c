#include "lib.h"

void processo_filho2(void) {
    so_escreve('F');
    so_escreve('2');
    so_escreve('\n');
    so_mata_proc(0); // Mata a si mesmo
}

void processo_filho1(void) {
    so_escreve('F');
    so_escreve('1');
    so_escreve('\n');
    so_mata_proc(0); // Mata a si mesmo
}

void init(void) {
    int pid1;
    int pid2;

    so_escreve('I');
    so_escreve('n');
    so_escreve('i');
    so_escreve('t');
    so_escreve('\n');

    // Cria o primeiro processo filho
    pid1 = so_cria_proc(processo_filho1);

    // Cria o segundo processo filho
    pid2 = so_cria_proc(processo_filho2);

    // Encerra o processo principal init
    so_mata_proc(0);
}