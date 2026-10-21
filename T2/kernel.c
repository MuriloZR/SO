// kernel.c -- Implementação das Partes I e II (Bloqueios e E/S)

#define NPROC 8
#define TAM_PILHA 64
#define TAM_QUADRO 16
#define TAM_BUF 16

// Estados de Processos
#define ESTADO_LIVRE     0
#define ESTADO_PRONTO    1
#define ESTADO_EXECUCAO  2
#define ESTADO_BLOQUEADO 3
#define ESTADO_MORTO     4

// Motivos de Bloqueio
#define BLOQ_NENHUM      0
#define BLOQ_LEITURA     1
#define BLOQ_ESPERA_PROC 2

struct Processo {
    int pid;
    int estado;
    int motivo_bloqueio;
    int pid_esperado;        // Para SO_ESPERA_PROC
    int quadro[TAM_QUADRO];
    int pilha[TAM_PILHA];
};
#define Processo struct Processo

Processo tabela_processos[NPROC];
int processo_atual = -1;
int proximo_pid = 1;

// Buffer Circular de Teclado
int kbd_buf[TAM_BUF];
int kbd_head = 0;
int kbd_tail = 0;
int kbd_count = 0;

void write_char(int c);
void espera_interrupcao(void);
void process_idle_code(void);
void init(void);

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

void monta_quadro_processo(int idx, int pid, int ip_inicial, int sr_inicial) {
    int k;
    tabela_processos[idx].pid = pid;
    tabela_processos[idx].motivo_bloqueio = BLOQ_NENHUM;
    tabela_processos[idx].pid_esperado = -1;

    k = 0;
    while (k < TAM_QUADRO) {
        tabela_processos[idx].quadro[k] = 0;
        k = k + 1;
    }

    tabela_processos[idx].quadro[6] = (int) &tabela_processos[idx].pilha[TAM_PILHA]; // SP
    tabela_processos[idx].quadro[7] = ip_inicial;                                   // IP
    tabela_processos[idx].quadro[8] = sr_inicial;                                   // SR
}

void procinit(int addr_tabela_syscalls) {
    int i;
    i = 0;
    while (i < NPROC) {
        tabela_processos[i].estado = ESTADO_LIVRE;
        tabela_processos[i].pid = -1;
        i = i + 1;
    }

    monta_quadro_processo(0, 0, (int)process_idle_code, 0x8000);
    tabela_processos[0].estado = ESTADO_PRONTO;

    monta_quadro_processo(1, proximo_pid, (int)init, 0x0000);
    proximo_pid = proximo_pid + 1;
    tabela_processos[1].estado = ESTADO_EXECUCAO;

    processo_atual = 1;
    restaura_contexto(1);
}

void process_idle_code(void) {
    while (1) {
        espera_interrupcao();
    }
}

void so_escalona(void) {
    int atual;
    int i;
    int escolhido;

    atual = processo_atual;

    if (atual != -1) {
        salva_contexto(atual);
        if (tabela_processos[atual].estado == ESTADO_EXECUCAO) {
            tabela_processos[atual].estado = ESTADO_PRONTO;
        }
    }

    escolhido = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_PRONTO) {
            escolhido = i;
            break;
        }
        i = i + 1;
    }

    if (escolhido == -1) {
        escolhido = 0; // IDLE
    }

    processo_atual = escolhido;
    tabela_processos[escolhido].estado = ESTADO_EXECUCAO;
    restaura_contexto(escolhido);
}

// Desbloqueia processos que estavam aguardando a morte do PID especificado
void pwake(int pid_morto) {
    int i;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_BLOQUEADO &&
            tabela_processos[i].motivo_bloqueio == BLOQ_ESPERA_PROC &&
            tabela_processos[i].pid_esperado == pid_morto) {

            tabela_processos[i].estado = ESTADO_PRONTO;
            tabela_processos[i].motivo_bloqueio = BLOQ_NENHUM;
            tabela_processos[i].pid_esperado = -1;
        }
        i = i + 1;
    }
}

// Recebe interrupção de tecla do console
void received_key(int c) {
    int i;
    int p_esperando;

    p_esperando = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_BLOQUEADO &&
            tabela_processos[i].motivo_bloqueio == BLOQ_LEITURA) {
            p_esperando = i;
            break;
        }
        i = i + 1;
    }

    if (p_esperando != -1) {
        // Entrega o caractere direto no R0 do contexto salvo do processo
        tabela_processos[p_esperando].quadro[0] = c;
        tabela_processos[p_esperando].estado = ESTADO_PRONTO;
        tabela_processos[p_esperando].motivo_bloqueio = BLOQ_NENHUM;

        // Se a CPU estava rodando o IDLE, troca de imediato para o processo acordado
        if (processo_atual == 0) {
            so_escalona();
        }
    } else if (kbd_count < TAM_BUF) {
        kbd_buf[kbd_tail] = c;
        kbd_tail = (kbd_tail + 1) % TAM_BUF;
        kbd_count = kbd_count + 1;
    }
}

// --- Syscalls da Parte II ---

int sys_read(void) {
    int c;
    if (kbd_count > 0) {
        c = kbd_buf[kbd_head];
        kbd_head = (kbd_head + 1) % TAM_BUF;
        kbd_count = kbd_count - 1;
        return c;
    } else {
        // Bloqueia e cede o processador sem espera ocupada
        tabela_processos[processo_atual].estado = ESTADO_BLOQUEADO;
        tabela_processos[processo_atual].motivo_bloqueio = BLOQ_LEITURA;
        so_escalona();
        return tabela_processos[processo_atual].quadro[0]; // Retorna R0 preenchido pela interrupção
    }
}

int sys_write(int c) {
    if (c == 0) return 0;
    write_char(c);
    return 1;
}

int sys_newproc(void (*entry)(void)) {
    int i;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_LIVRE || tabela_processos[i].estado == ESTADO_MORTO) {
            monta_quadro_processo(i, proximo_pid, (int)entry, 0x0000);
            tabela_processos[i].estado = ESTADO_PRONTO;
            proximo_pid = proximo_pid + 1;
            return tabela_processos[i].pid;
        }
        i = i + 1;
    }
    return -1;
}

int sys_killproc(int pid) {
    int i;
    int idx_alvo;

    idx_alvo = -1;
    if (pid == 0 || pid == tabela_processos[processo_atual].pid) {
        idx_alvo = processo_atual;
    } else {
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
        pwake(tabela_processos[idx_alvo].pid); // Acorda dependentes

        if (idx_alvo == processo_atual) {
            so_escalona();
        }
        return 0;
    }
    return -1;
}

int sys_wait(int pid) {
    int i;
    int idx_alvo;

    // Erro se tentar esperar por si mesmo ou PID inválido
    if (pid <= 0 || pid == tabela_processos[processo_atual].pid) {
        return -1;
    }

    idx_alvo = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].pid == pid && tabela_processos[i].estado != ESTADO_MORTO && tabela_processos[i].estado != ESTADO_LIVRE) {
            idx_alvo = i;
            break;
        }
        i = i + 1;
    }

    // Se o processo não existe ou já morreu, retorna erro
    if (idx_alvo == -1) {
        return -1;
    }

    // Bloqueia o processo chamador até o PID esperado morrer
    tabela_processos[processo_atual].estado = ESTADO_BLOQUEADO;
    tabela_processos[processo_atual].motivo_bloqueio = BLOQ_ESPERA_PROC;
    tabela_processos[processo_atual].pid_esperado = pid;

    so_escalona();
    return 0;
}