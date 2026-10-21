#define NPROC 8
#define TAM_PILHA 64
#define TAM_QUADRO 16
#define TAM_BUF 16

#define QUANTUM_DEFAULT 4 // Quantum em número de ticks de relógio

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
    int pid_esperado;
    int quadro[TAM_QUADRO];
    int pilha[TAM_PILHA];

    // Prioridade e Preempção
    int prioridade;          // Representada em porcentagem (50 = 0.5)
    int t_exec;              // Ticks executados no quantum atual
    int num_preempcoes;      // Contador de preempções do processo

    // Métricas
    int num_entradas_pronto;
    int num_entradas_bloqueado;
    int num_entradas_execucao;
};
#define Processo struct Processo

Processo tabela_processos[NPROC];
int processo_atual = -1;
int proximo_pid = 1;
int quantum_restante = QUANTUM_DEFAULT;

// Métrica do Sistema
int total_processos_criados = 0;
int total_preempcoes_sistema = 0;
int ticks_ociosos = 0;
int ticks_totais = 0;

// Buffer Circular de Teclado
int kbd_buf[TAM_BUF];
int kbd_head = 0;
int kbd_tail = 0;
int kbd_count = 0;

void write_char(int c);
void espera_interrupcao(void);
void process_idle_code(void);
void init(void);
void imprime_metricas(void);

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

    tabela_processos[idx].prioridade = 50; // Prioridade inicial 0.5 (50%)
    tabela_processos[idx].t_exec = 0;
    tabela_processos[idx].num_preempcoes = 0;
    tabela_processos[idx].num_entradas_pronto = 0;
    tabela_processos[idx].num_entradas_bloqueado = 0;
    tabela_processos[idx].num_entradas_execucao = 0;

    k = 0;
    while (k < TAM_QUADRO) {
        tabela_processos[idx].quadro[k] = 0;
        k = k + 1;
    }

    tabela_processos[idx].quadro[6] = (int) &tabela_processos[idx].pilha[TAM_PILHA];
    tabela_processos[idx].quadro[7] = ip_inicial;
    tabela_processos[idx].quadro[8] = sr_inicial;
}

void procinit(int addr_tabela_syscalls) {
    int i;
    i = 0;
    while (i < NPROC) {
        tabela_processos[i].estado = ESTADO_LIVRE;
        tabela_processos[i].pid = -1;
        i = i + 1;
    }

    // Processo IDLE
    monta_quadro_processo(0, 0, (int)process_idle_code, 0x8000);
    tabela_processos[0].estado = ESTADO_PRONTO;

    // Processo Init
    monta_quadro_processo(1, proximo_pid, (int)init, 0x0000);
    proximo_pid = proximo_pid + 1;
    total_processos_criados = total_processos_criados + 1;

    tabela_processos[1].estado = ESTADO_EXECUCAO;
    tabela_processos[1].num_entradas_execucao = 1;

    processo_atual = 1;
    quantum_restante = QUANTUM_DEFAULT;
    restaura_contexto(1);
}

void process_idle_code(void) {
    while (1) {
        espera_interrupcao();
    }
}

// Recalcula prioridade ao perder a CPU: prio = (prio + t_exec/t_quantum) / 2
void recalcula_prioridade(int idx) {
    int percentual_exec;
    if (idx <= 0) return;

    percentual_exec = (tabela_processos[idx].t_exec * 100) / QUANTUM_DEFAULT;
    tabela_processos[idx].prioridade = (tabela_processos[idx].prioridade + percentual_exec) / 2;
    tabela_processos[idx].t_exec = 0;
}

// Escalonador Round-Robin Preemptivo com Tratamento de Quantum
void so_escalona(void) {
    int atual;
    int i;
    int proximo;
    int escolhido;

    ticks_totais = ticks_totais + 1;
    atual = processo_atual;

    if (atual == 0) {
        ticks_ociosos = ticks_ociosos + 1;
    }

    // Decrementa o quantum do processo atual se ele estiver rodando
    if (atual > 0 && tabela_processos[atual].estado == ESTADO_EXECUCAO) {
        tabela_processos[atual].t_exec = tabela_processos[atual].t_exec + 1;
        quantum_restante = quantum_restante - 1;

        // Se ainda tem quantum, continua no mesmo processo
        if (quantum_restante > 0) {
            return;
        }

        // Fim do Quantum -> Preempção
        tabela_processos[atual].num_preempcoes = tabela_processos[atual].num_preempcoes + 1;
        total_preempcoes_sistema = total_preempcoes_sistema + 1;
        recalcula_prioridade(atual);

        tabela_processos[atual].estado = ESTADO_PRONTO;
        tabela_processos[atual].num_entradas_pronto = tabela_processos[atual].num_entradas_pronto + 1;
    }

    if (atual != -1) {
        salva_contexto(atual);
    }

    // Busca o próximo processo PRONTO em fila circular
    escolhido = -1;
    proximo = (atual + 1) % NPROC;
    if (proximo == 0) proximo = 1;

    i = 0;
    while (i < NPROC - 1) {
        if (tabela_processos[proximo].estado == ESTADO_PRONTO) {
            escolhido = proximo;
            break;
        }
        proximo = (proximo + 1) % NPROC;
        if (proximo == 0) proximo = 1;
        i = i + 1;
    }

    if (escolhido == -1) {
        escolhido = 0; // Se não há processos de usuário prontos, roda o IDLE
    }

    processo_atual = escolhido;
    quantum_restante = QUANTUM_DEFAULT; // Reinicia o quantum para o novo processo

    tabela_processos[escolhido].estado = ESTADO_EXECUCAO;
    tabela_processos[escolhido].num_entradas_execucao = tabela_processos[escolhido].num_entradas_execucao + 1;

    restaura_contexto(escolhido);
}

void pwake(int pid_morto) {
    int i;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_BLOQUEADO &&
            tabela_processos[i].motivo_bloqueio == BLOQ_ESPERA_PROC &&
            tabela_processos[i].pid_esperado == pid_morto) {

            tabela_processos[i].estado = ESTADO_PRONTO;
            tabela_processos[i].num_entradas_pronto = tabela_processos[i].num_entradas_pronto + 1;
            tabela_processos[i].motivo_bloqueio = BLOQ_NENHUM;
            tabela_processos[i].pid_esperado = -1;
        }
        i = i + 1;
    }
}

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
        tabela_processos[p_esperando].quadro[0] = c;
        tabela_processos[p_esperando].estado = ESTADO_PRONTO;
        tabela_processos[p_esperando].num_entradas_pronto = tabela_processos[p_esperando].num_entradas_pronto + 1;
        tabela_processos[p_esperando].motivo_bloqueio = BLOQ_NENHUM;

        if (processo_atual == 0) {
            so_escalona();
        }
    } else if (kbd_count < TAM_BUF) {
        kbd_buf[kbd_tail] = c;
        kbd_tail = (kbd_tail + 1) % TAM_BUF;
        kbd_count = kbd_count + 1;
    }
}

// --- Syscalls ---

int sys_read(void) {
    int c;
    if (kbd_count > 0) {
        c = kbd_buf[kbd_head];
        kbd_head = (kbd_head + 1) % TAM_BUF;
        kbd_count = kbd_count - 1;
        return c;
    } else {
        recalcula_prioridade(processo_atual);
        tabela_processos[processo_atual].estado = ESTADO_BLOQUEADO;
        tabela_processos[processo_atual].num_entradas_bloqueado = tabela_processos[processo_atual].num_entradas_bloqueado + 1;
        tabela_processos[processo_atual].motivo_bloqueio = BLOQ_LEITURA;

        quantum_restante = 0; // Força a troca
        so_escalona();
        return tabela_processos[processo_atual].quadro[0];
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
            tabela_processos[i].num_entradas_pronto = 1;

            proximo_pid = proximo_pid + 1;
            total_processos_criados = total_processos_criados + 1;
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
        pwake(tabela_processos[idx_alvo].pid);

        // Se o Init morreu, o SO encerra e imprime o relatório final de métricas
        if (idx_alvo == 1) {
            imprime_metricas();
        }

        if (idx_alvo == processo_atual) {
            quantum_restante = 0;
            so_escalona();
        }
        return 0;
    }
    return -1;
}

int sys_wait(int pid) {
    int i;
    int idx_alvo;

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

    if (idx_alvo == -1) {
        return -1;
    }

    recalcula_prioridade(processo_atual);
    tabela_processos[processo_atual].estado = ESTADO_BLOQUEADO;
    tabela_processos[processo_atual].num_entradas_bloqueado = tabela_processos[processo_atual].num_entradas_bloqueado + 1;
    tabela_processos[processo_atual].motivo_bloqueio = BLOQ_ESPERA_PROC;
    tabela_processos[processo_atual].pid_esperado = pid;

    quantum_restante = 0;
    so_escalona();
    return 0;
}

void imprime_metricas(void) {
    write_char('\n');
    write_char('-');
    write_char('-');
    write_char(' ');
    write_char('M');
    write_char('E');
    write_char('T');
    write_char('R');
    write_char('I');
    write_char('C');
    write_char('A');
    write_char('S');
    write_char(' ');
    write_char('-');
    write_char('-');
    write_char('\n');

    write_char('P'); write_char('r'); write_char('o'); write_char('c'); write_char('s');
    write_char(' '); write_char('C'); write_char('r'); write_char('i'); write_char('a'); write_char('d'); write_char('o'); write_char('s'); write_char(':'); write_char(' ');
    write_char('0' + total_processos_criados);
    write_char('\n');

    write_char('P'); write_char('r'); write_char('e'); write_char('e'); write_char('m'); write_char('p'); write_char('c'); write_char('o'); write_char('e'); write_char('s'); write_char(':'); write_char(' ');
    write_char('0' + total_preempcoes_sistema);
    write_char('\n');
}