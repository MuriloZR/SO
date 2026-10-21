#include "lib.h"

void processo_filho(void) {
    so_escreve('I');
    so_escreve('n');
    so_escreve('i');
    so_escreve('c');
    so_escreve('i');
    so_escreve('o');
    so_escreve(' ');
    so_escreve('F');
    so_escreve('i');
    so_escreve('l');
    so_escreve('h');
    so_escreve('o');
    so_escreve('\n');

    so_mata_proc(0); // Filho morre
}

void init(void) {
    int pid_filho;

    so_escreve('P');
    so_escreve('a');
    so_escreve('i');
    so_escreve(' ');
    so_escreve('c');
    so_escreve('r');
    so_escreve('i');
    so_escreve('a');
    so_escreve('\n');

    pid_filho = so_cria_proc(processo_filho);

    if (pid_filho > 0) {
        // Bloqueia e aguarda o término do filho
        so_espera_proc(pid_filho);

        so_escreve('P');
        so_escreve('a');
        so_escreve('i');
        so_escreve(' ');
        so_escreve('r');
        so_escreve('e');
        so_escreve('s');
        so_escreve('u');
        so_escreve('m');
        so_escreve('e');
        so_escreve('\n');
    }

    so_mata_proc(0);
}
