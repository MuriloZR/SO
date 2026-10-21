#ifndef LIB_H
#define LIB_H

// Protótipos das funções exportadas pelo ponte.asm
int so_le(void);
int so_escreve(int c);
int so_cria_proc(void (*entry)(void));
int so_mata_proc(int pid);
int so_espera_proc(int pid);
#endif
