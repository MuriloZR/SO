#define NUM_PROCESSOS 8
#define TAM_QUADRO  16
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

int cria_proc(void (*programa)(void)) {
    int idx_tabela = idx_livre_tabela();
    if (idx_tabela < 0) { return -1; }
    int pid = pid_gen();
    if (pid < 1) { return -1; }
    if (monta_quadro_inicial(idx_tabela, pid, (int)&pilhas[idx_tabela][STACK_SIZE], (int)programa) < 0) { return -1; }
    return pid;
}

void salva_contexto(int idx_tabela, int *quadro) {
    for (int i = 0; i < TAM_QUADRO; i++) {
        tabela_processos[idx_tabela].quadro[i] = quadro[i];
    }
}

void restaura_contexto(int idx_tabela, int *quadro) {
    for (int i = 0; i < TAM_QUADRO; i++) {
        quadro[i] = tabela_processos[idx_tabela].quadro[i];
    }
}

void so_escalona(void) {
    if (processo_execucao == -1) {
        for (int i = 0; i < NUM_PROCESSOS; i++) {
            if (tabela_processos[i].estado == PRONTO) {
                tabela_processos[i].estado = EXECUCAO;
                processo_execucao = i;
                break;
            }
        }
    }
}