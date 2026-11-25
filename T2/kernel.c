#define NUM_PROCESSOS 8
#define TAM_QUADRO  16
#define LIVRE       0
#define EXECUCAO    1
#define PRONTO      2
#define BLOQUEADO   3

#define REG_SP 6
#define REG_IP 7
#define REG_SR 8

#define STACK_SIZE 128

struct Processo {
    int pid;
    int estado;
    int quadro[TAM_QUADRO];
};
// #define Processo struct Processo

int processo_execucao = -1; // -1 significa nenhum em execução
struct Processo tabela_processos[NUM_PROCESSOS];
int pilhas[NUM_PROCESSOS][STACK_SIZE]; // cada processo tem 256 bytes pra trabalhar
int next_pid = 1;

int idx_livre_tabela(void);
int pid_gen(void);
int monta_quadro_inicial(int idx_tabela, int pid, int sp, int ip);
void salva_contexto(int idx_tabela, int *quadro);
void restaura_contexto(int idx_tabela, int *quadro);
void so_escalona(int *quadro);
int inicializa_processos(int *quadro);

// chamadas
int kernel_cria_proc(void (*entry)(void));
int kernel_mata_proc(int pid);


// retorna o primeiro índice livre da tabela de processos
int idx_livre_tabela(void) {
    for (int i = 0; i < NUM_PROCESSOS; i++) {
        if (tabela_processos[i].pid == 0) {
            return i;
        }
    }

    return -1;
}

int pid_gen(void) {
    int prev_pid = next_pid;
    next_pid++;
    return prev_pid;
}

int monta_quadro_inicial(int idx_tabela, int pid, int sp, int ip) {
    if (pid < 1 || idx_tabela < 0 || idx_tabela >= NUM_PROCESSOS) { return -1; }
    tabela_processos[idx_tabela].pid = pid;
    for (int i = 0; i < TAM_QUADRO; i++) { tabela_processos[idx_tabela].quadro[i] = 0; } // limpa o quadro do processo antes de alocar um novo processo
    tabela_processos[idx_tabela].estado = PRONTO;
    tabela_processos[idx_tabela].quadro[REG_SP] = sp;
    tabela_processos[idx_tabela].quadro[REG_IP] = ip;
    tabela_processos[idx_tabela].quadro[REG_SR] = 0x0000;

    return 0;
}

// cria um processo a partir de uma entrada
// retorna o pid do processo criado em sucesso
// retorna -1 em caso de falha
int kernel_cria_proc(void (*entry)(void)) {
    int idx_tabela = idx_livre_tabela();
    if (idx_tabela < 0) { return -1; }
    int pid = pid_gen();
    if (pid < 1) { return -1; }
    if (monta_quadro_inicial(idx_tabela, pid, (int)&pilhas[idx_tabela][STACK_SIZE], (int)entry) < 0) { return -1; }
    return pid;
}

// ainda não tá correta
int kernel_mata_proc(int pid) {
    int idx_morto = -1;
    if (pid < 1) { return idx_morto; }
    for (int i = 0; i < NUM_PROCESSOS; i++) {
        if (tabela_processos[i].pid == pid) {
            idx_morto = i;
            break;
        }
    }
    if (idx_morto < 0) { return idx_morto; }

    if (tabela_processos[idx_morto].estado == EXECUCAO) {
        processo_execucao = -1;
    }
    int pid_morto = tabela_processos[idx_morto].pid;
    tabela_processos[idx_morto].pid = 0;
    tabela_processos[idx_morto].estado = LIVRE;
    return pid_morto;
}

void salva_contexto(int idx_tabela, int *quadro) {
    if (idx_tabela < 0) { return; }
    for (int i = 0; i < TAM_QUADRO; i++) {
        tabela_processos[idx_tabela].quadro[i] = quadro[i];
    }
}

void restaura_contexto(int idx_tabela, int *quadro) {
    if (idx_tabela < 0) { return; }
    for (int i = 0; i < TAM_QUADRO; i++) {
        quadro[i] = tabela_processos[idx_tabela].quadro[i];
    }
}

void escolhe_proximo(void) {
    if (processo_execucao >= 0) {
        for (int i = 0; i < NUM_PROCESSOS; i++) {
            int idx;
            int tmp = processo_execucao + i;
            if (tmp < NUM_PROCESSOS) {
                idx = tmp;
            } else {
                idx = 0 + (tmp - NUM_PROCESSOS);
            }
            if (tabela_processos[idx].estado == EXECUCAO) {
                return;
            } else {
                if (tabela_processos[idx].estado == PRONTO) {
                    processo_execucao = idx;
                    tabela_processos[idx].estado = EXECUCAO;
                    return;
                }
            }
        }
    } else {
        for (int i = 0; i < NUM_PROCESSOS; i++) {
            if (tabela_processos[i].estado == PRONTO) {
                tabela_processos[i].estado = EXECUCAO;
                processo_execucao = i;
                return;
            }
        }
    }
    processo_execucao = -1;
}

void so_escalona(int *quadro) {
    salva_contexto(processo_execucao, quadro); // tem verificação para o proc_exe == -1
    escolhe_proximo();
    restaura_contexto(processo_execucao, quadro);  // tem verificação para o proc_exe == -1
}

void proc2() {
    for (;;) {}
}

void init() {
    kernel_cria_proc(proc2);
    for (;;) {}
}

int inicializa_processos(int *quadro) {
    int pid = kernel_cria_proc(init);
    if (pid < 0) { return -1; }
    so_escalona(quadro);
    return 0;
}