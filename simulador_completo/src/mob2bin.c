// mob2bin.c -- converte um .mob já resolvido (endereços absolutos, ver
// objeto.h) num binário achatado de N bytes, preenchendo com zero onde
// não houver byte definido no .mob.
//
// Serve para quando um módulo é montado sozinho (sem .org, contador de
// endereço começando em 0) só para produzir uma imagem de bytes pronta
// pra ser copiada para outro lugar depois -- por exemplo, gravada num
// setor de disco e carregada em tempo de execução para dentro de um
// quadro físico qualquer (ver ../../bios_mancha/exemplos/paginacao_disco/).
// Reaproveita o mesmo carregador usado pelo simulador (obj_carrega) para
// não duplicar o parser do formato .mob.

#include <stdio.h>
#include <stdlib.h>
#include "memoria.h"
#include "objeto.h"

int main(int argc, char *argv[])
{
  if (argc != 4) {
    fprintf(stderr, "uso: %s entrada.mob tamanho saida.bin\n", argv[0]);
    return 1;
  }

  long tamanho = atol(argv[2]);
  if (tamanho <= 0 || tamanho > MEM_TAMANHO) {
    fprintf(stderr, "tamanho invalido: %s\n", argv[2]);
    return 1;
  }

  mem_t *mem = mem_cria();
  simbolo_t *simbolos = NULL;
  char erro[256];
  if (!obj_carrega(argv[1], mem, &simbolos, erro, sizeof(erro))) {
    fprintf(stderr, "erro: %s\n", erro);
    return 1;
  }
  obj_libera_simbolos(simbolos);

  FILE *out = fopen(argv[3], "wb");
  if (out == NULL) {
    fprintf(stderr, "nao foi possivel criar '%s'\n", argv[3]);
    return 1;
  }
  fwrite(mem_vetor(mem), 1, (size_t)tamanho, out);
  fclose(out);
  mem_destroi(mem);
  return 0;
}
