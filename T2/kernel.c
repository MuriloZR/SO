#define NUM_PROCESSOS 8
#define TAM_QUADRO  16

#define PID_INIT 1

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
void encerra_processos(void);
void cpu_halt(void);

// chamadas
int kernel_cria_proc(void (*entry)(void));
int kernel_mata_proc(int pid, int *quadro);
int kernel_escreve(int c);

int escreve_caractere(int c); // definida no ponte.asm

// retorna o primeiro índice livre da tabela de processos
int idx_livre_tabela(void) {
    for (int i = 0; i < NUM_PROCESSOS; i++) {
        if (tabela_processos[i].pid == 0 || tabela_processos[i].estado == LIVRE) {
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

int libera_entrada(int idx_morto) {
    int pid_morto = tabela_processos[idx_morto].pid;
    tabela_processos[idx_morto].pid = 0;
    tabela_processos[idx_morto].estado = LIVRE;
    return pid_morto;
}

int proc_morre(int *quadro) {
    int idx_morto = processo_execucao;
    processo_execucao = -1;
    libera_entrada(idx_morto);
    so_escalona(quadro);
    return quadro[0];
}

int proc_mata(int pid) {
    int idx_morto = -1;
    for (int i = 0; i < NUM_PROCESSOS; i++) {
        if (tabela_processos[i].pid == pid) {
            idx_morto = i;
            break;
        }
    }
    if (idx_morto < 0) { return -1; }
    int pid_morto = libera_entrada(idx_morto);
    return pid_morto;
}

// cuidar a parte de encerrar o sistema quando ocorrer exceção
int kernel_mata_proc(int pid, int *quadro) {
    if (pid < 1) { return -1; }
    if (pid == PID_INIT) { encerra_processos(); return PID_INIT; }
    int ret = 0;
    // o handler assume que processo_execucao >= 0
    if (pid == tabela_processos[processo_execucao].pid) {
        ret = proc_morre(quadro);
    } else {
        ret = proc_mata(pid);
    }
    return ret;
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

// falta tratar o caso do idle
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

int cria_proc(void (*entry)(void));
int mata_proc(int pid);
void escreve(int c);

void init() {
    if (cria_proc(proc2) == 2) {
        escreve('0');
    } else {
        escreve('X');
    }
    if (mata_proc(2) == 2) {
        escreve('0');
    } else {
        escreve('X');
    }
    mata_proc(PID_INIT);
}

int inicializa_processos(int *quadro) {
    int pid = kernel_cria_proc(init);
    if (pid != PID_INIT) { return -1; }
    so_escalona(quadro);
    return 0;
}

void print_metricas(void) {
    char s[4];
    s[0] = 'F';
    s[1] = 'I';
    s[2] = 'M';
    s[3] = '\0';
    kernel_escreve('\n');
    for (int i = 0; i < 4; i++) {
        kernel_escreve(s[i]);
    }
    kernel_escreve('\n');
}

void encerra_processos(void) {
    for (int i = 0; i < NUM_PROCESSOS; i++) {
        libera_entrada(i); //lembrar de verificar apenas as entradas válidas
    }
    print_metricas();
    cpu_halt();
}

int kernel_escreve(int c) {
    if (c == '\0') return 0;
      escreve_caractere(c);
      return 1;
}