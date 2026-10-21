#define NPROC 8
#define TAM_PILHA 64
#define TAM_QUADRO 16

// Estados de Processos
#define ESTADO_LIVRE     0
#define ESTADO_PRONTO    1
#define ESTADO_EXECUCAO  2
#define ESTADO_MORTO     3

// Estrutura do Bloco de Controle de Processo (PCB)
struct Processo {
    int pid;                  // Número de série único do processo
    int estado;               // ESTADO_LIVRE, ESTADO_PRONTO, etc.
    int quadro[TAM_QUADRO];   // Cópia das 16 palavras de contexto da CPU
    int pilha[TAM_PILHA];     // Pilha de trabalho em modo usuário
};
#define Processo struct Processo

// Globais do Kernel
Processo tabela_processos[NPROC];
int processo_atual = -1;      // Índice no vetor do processo em execução (-1 = nenhum)
int proximo_pid = 1;          // Gerador de número de série (PID)

void write_char(int c);       // Exportada por ponte.asm
void process_idle_code(void); // Protótipo
void init(void);
void espera_interrupcao(void);

// Salva o quadro da área fixa (0xEFE0) no PCB do processo indicado
void salva_contexto(int idx) {
    int *quadro_sis;
    int i;
    quadro_sis = (int*) 0xEFE0;

    if (idx < 0 || idx >= NPROC) return;

    i = 0;
    while (i < TAM_QUADRO) {
        tabela_processos[idx].quadro[i] = quadro_sis[i];
        i = i + 1;
    }
}

// Copia do PCB do processo indicado para a área fixa (0xEFE0)
void restaura_contexto(int idx) {
    int *quadro_sis;
    int i;
    quadro_sis = (int*) 0xEFE0;

    if (idx < 0 || idx >= NPROC) return;

    i = 0;
    while (i < TAM_QUADRO) {
        quadro_sis[i] = tabela_processos[idx].quadro[i];
        i = i + 1;
    }
}

// Configura o contexto inicial de um processo no PCB
void monta_quadro_processo(int idx, int pid, int ip_inicial, int sr_inicial) {
    int k;

    tabela_processos[idx].pid = pid;

    k = 0;
    while (k < TAM_QUADRO) {
        tabela_processos[idx].quadro[k] = 0;
        k = k + 1;
    }

    tabela_processos[idx].quadro[6] = (int) &tabela_processos[idx].pilha[TAM_PILHA]; // SP
    tabela_processos[idx].quadro[7] = ip_inicial;                                   // IP
    tabela_processos[idx].quadro[8] = sr_inicial;                                   // SR
}

// Inicialização convocada por ponte.asm no boot
void procinit(int addr_tabela_syscalls) {
    int i;

    // Zera a tabela de processos
    i = 0;
    while (i < NPROC) {
        tabela_processos[i].estado = ESTADO_LIVRE;
        tabela_processos[i].pid = -1;
        i = i + 1;
    }

    // Processo 0: IDLE (PID 0, SR = 0x8000 para Modo Supervisor)
    monta_quadro_processo(0, 0, (int)process_idle_code, 0x8000);
    tabela_processos[0].estado = ESTADO_PRONTO;

    // Processo 1: Init (Primeiro processo do usuário, PID 1, SR = 0x0000 para Modo Usuário)
    // O código do programa de usuário se inicia no endereço 0x1000 por convenção
    monta_quadro_processo(1, proximo_pid, (int)init, 0x0000);
    proximo_pid = proximo_pid + 1;
    tabela_processos[1].estado = ESTADO_EXECUCAO;

    processo_atual = 1;

    // Copia o quadro inicial do processo Init para a posição de boot
    restaura_contexto(1);
}

// Código do Processo IDLE
void process_idle_code(void) {
    while (1) {
        espera_interrupcao();
    }
}

// Escalonador Simples da Parte I
void so_escalona(void) {
    int atual;
    int i;
    int escolhido;

    atual = processo_atual;

    // 1. Salva o contexto do processo que acabou de ser interrompido
    if (atual != -1) {
        salva_contexto(atual);
        if (tabela_processos[atual].estado == ESTADO_EXECUCAO) {
            tabela_processos[atual].estado = ESTADO_PRONTO;
        }
    }

    // 2. Procura pelo primeiro processo PRONTO (pula o IDLE inicialmente)
    escolhido = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_PRONTO) {
            escolhido = i;
            break;
        }
        i = i + 1;
    }

    // Se nenhum processo de usuário estiver pronto, escolhe o IDLE (índice 0)
    if (escolhido == -1) {
        escolhido = 0;
    }

    // 3. Efetua a troca do processo em execução
    processo_atual = escolhido;
    tabela_processos[escolhido].estado = ESTADO_EXECUCAO;
    restaura_contexto(escolhido);
}

// --- Implementação das Syscalls da Parte I ---

int sys_read(void) {
    // E/S simples (sem bloqueio nesta fase)
    return 0;
}

int sys_write(int c) {
    if (c == 0) return 0;
    write_char(c);
    return 1;
}

int sys_newproc(void (*entry)(void)) {
    int i;

    // Procura por uma entrada LIVRE ou MORTO na tabela
    i = 1; // O índice 0 é exclusivo do IDLE
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_LIVRE || tabela_processos[i].estado == ESTADO_MORTO) {
            monta_quadro_processo(i, proximo_pid, (int)entry, 0x0000);
            tabela_processos[i].estado = ESTADO_PRONTO;

            proximo_pid = proximo_pid + 1; // Incrementa o número de série único
            return tabela_processos[i].pid; // Retorna o PID criado
        }
        i = i + 1;
    }
    return -1; // Tabela cheia
}

int sys_killproc(int pid) {
    int i;
    int idx_alvo;

    idx_alvo = -1;

    // Se pid == 0 ou pid for o próprio processo atual, encerra o processo em execução
    if (pid == 0 || pid == tabela_processos[processo_atual].pid) {
        idx_alvo = processo_atual;
    } else {
        // Procura pelo processo correspondente ao PID
        i = 1;
        while (i < NPROC) {
            if (tabela_processos[i].pid == pid && tabela_processos[i].estado != ESTADO_MORTO) {
                idx_alvo = i;
                break;
            }
            i = i + 1;
        }
    }

    if (idx_alvo != -1) {
        tabela_processos[idx_alvo].estado = ESTADO_MORTO;

        // Se o processo encerrou a si mesmo, chama o escalonador para trocar de processo
        if (idx_alvo == processo_atual) {
            so_escalona();
        }
        return 0;
    }

    return -1; // PID não encontrado
}

int sys_wait(int pid) {
    int i;
    int idx_alvo;

    // Requisito: Se for o próprio processo ou PID inválido/inexistente, retorna erro
    if (pid <= 0 || pid == tabela_processos[processo_atual].pid) {
        return -1;
    }

    // Busca o processo pelo PID na tabela
    idx_alvo = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].pid == pid && tabela_processos[i].estado != ESTADO_MORTO && tabela_processos[i].estado != ESTADO_LIVRE) {
            idx_alvo = i;
            break;
        }
        i = i + 1;
    }

    // Se o processo não existe, retorna erro (-1)
    if (idx_alvo == -1) {
        return -1;
    }

    // Na PARTE I (sem bloqueios ainda), apenas retorna 0 se o processo for válido.
    // Na PARTE II, esta função alterará o estado para ESTADO_BLOQUEADO e chamará o so_escalona().
    return 0;
}