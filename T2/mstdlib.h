// Mancha Standart Library

#ifndef MSTDLIB_H
#define MSTDLIB_H

int cria_proc(void (*entry)(void));
int mata_proc(int pid);
void escreve(int c);

#endif