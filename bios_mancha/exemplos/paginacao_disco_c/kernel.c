// kernel.c -- a parte do kernel deste exemplo escrita em C (ver
// ../../README.md, "O mesmo exemplo, com os processos em C"):
// escalonador() e a montagem dos quadros iniciais. O CÓDIGO dos
// processos (processoA.c/processoB.c) não está aqui -- cada um é
// compilado e montado SOZINHO (ver o Makefile), carregado de um disco
// simulado em tempo de execução por _kernel_inicio (em ponte.asm).
//
// Comparado com ../paginacao_usuario_c/kernel.c, este arquivo é mais
// simples porque não há nada para preencher em tempo de execução nas
// tabelas de página: tanto a entrada de CÓDIGO quanto a de DADOS de
// cada processo apontam para quadros físicos FIXOS, conhecidos desde a
// montagem (ver dados.asm) -- não existe mapeamento por identidade
// (que dependeria de saber, em tempo de execução, onde o código de
// cada processo foi colocado) nem área de dados "genérica" recebida
// por parâmetro. A única coisa que varia de processo para processo é
// qual tabela de páginas ("pt") cada quadro inicial usa.

#define N_PROCESSOS 2

int processos[32];     // tabela achatada de quadros salvos (2 * 16 palavras)
int processo_atual;

// monta o quadro inicial (16 palavras) do processo "indice". "ip"
// inicial é sempre 0 (virtual) -- não há como (nem necessidade de)
// passar um "ponto de entrada", já que o código de cada processo foi
// compilado e montado num módulo totalmente separado: o único jeito de
// endereçá-lo é pela PÁGINA 0 de código da tabela de páginas do
// processo, que dados.asm já aponta para o quadro físico certo.
void monta_quadro(int indice, int *tabela)
{
    int base;

    base = indice * 16;
    processos[base + 6] = 512;          // sp inicial (virtual): topo da página de dados
    processos[base + 7] = 0;               // ip inicial: sempre a página 0 de código, virtual
    processos[base + 8] = 0x4000;             // sr: S=0,P=1,I=0,D=0 -- usuário, paginação
    processos[base + 12] = (int) tabela;         // s4 = pt
    processos[base + 13] = 0;                       // s5 (não usado sob paginação)
    processos[base + 14] = 0;                          // s6 (não usado sob paginação)
    processos[base + 15] = 0;                             // s7 (não usado sob paginação)
}

// chamada por ponte.asm/_kernel_inicio, depois de _kernel_inicio já ter
// carregado o código de ambos os processos do disco.
void inicializa_processos(int *quadro_boot, int *tabela_a, int *tabela_b)
{
    int i;
    monta_quadro(0, tabela_a);
    monta_quadro(1, tabela_b);
    processo_atual = 0;
    for (i = 0; i < 16; i++) {
        quadro_boot[i] = processos[i];
    }
}

// o escalonador -- idêntico ao de ../multitarefa_c/ (só move os 16
// valores de um lugar para o outro, não precisa saber o que eles
// significam).
void escalonador(int *quadro, int *processos_tab, int *pproc)
{
    int atual;
    int i;
    int base;

    atual = *pproc;
    base = atual * 16;
    i = 0;
    while (i < 16) {
        processos_tab[base + i] = quadro[i];
        i = i + 1;
    }

    atual = atual + 1;
    if (atual >= N_PROCESSOS) {
        atual = 0;
    }
    *pproc = atual;

    base = atual * 16;
    i = 0;
    while (i < 16) {
        quadro[i] = processos_tab[base + i];
        i = i + 1;
    }
}
