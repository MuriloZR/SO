// kernel.c -- Implementação completa das métricas da Parte III

#define NPROC 8
#define TAM_PILHA 64
#define TAM_QUADRO 16
#define TAM_BUF 16
#define QUANTUM_DEFAULT 4

// Estados
#define ESTADO_LIVRE     0
#define ESTADO_PRONTO    1
#define ESTADO_EXECUCAO  2
#define ESTADO_BLOQUEADO 3
#define ESTADO_MORTO     4

// Motivos de Bloqueio
#define BLOQ_NENHUM      0
#define BLOQ_LEITURA     1
#define BLOQ_ESPERA_PROC 2

#define ENDERECO_QUADRO_SISTEMA 0xEFE0
#define TAM_BUFFER_ENTRADA 16

struct Processo {
    int pid;
    int estado;
    int motivo_bloqueio;
    int pid_esperado;
    int quadro[TAM_QUADRO];
    int pilha[TAM_PILHA];

    int prioridade;
    int t_exec;

    // --- Métricas por Processo ---
    int data_criacao;           // Tick em que foi criado
    int data_termino;           // Tick em que morreu
    int num_preempcoes;         // Número de preempções sofridas

    // Contadores de entradas nos estados
    int cnt_pronto;
    int cnt_bloqueado;
    int cnt_execucao;

    // Tempos acumulados em cada estado (em ticks)
    int tempo_pronto;
    int tempo_bloqueado;
    int tempo_execucao;

    // Controle de tempo de resposta (tempo entre desbloquear e ser escalonado)
    int tick_desbloqueio;       // Tick em que o processo ficou PRONTO
    int soma_tempo_resposta;   // Soma dos intervalos ate ser escalonado
    int num_respostas;          // Quantidade de vezes que foi escalonado apos ficar pronto

    int tick_ultimo_estado;     // Marca temporal da ultima mudanca de estado
};
#define Processo struct Processo

Processo tabela_processos[NPROC];
int processo_atual = -1;
int proximo_pid = 1;
int quantum_restante = QUANTUM_DEFAULT;

// --- Métricas Globais do Sistema ---
int relogio_ticks = 0;              // Tempo total de execução (ticks do relógio)
int ticks_ociosos = 0;              // Tempo em que o sistema ficou no IDLE
int total_processos_criados = 0;
int total_preempcoes_sistema = 0;

// Contadores de Interrupções por tipo
int int_relogio_count = 0;
int int_teclado_count = 0;
int int_syscall_count = 0;

int buffer_console_dados[TAM_BUFFER_ENTRADA];
int buffer_console_inicio = 0;  // Equivalente ao head
int buffer_console_fim = 0;     // Equivalente ao tail
int buffer_console_qtd = 0;      // Equivalente ao count

void write_char(int c);
void espera_interrupcao(void);
void process_idle_code(void);
void init(void);
void imprime_metricas(void);

// Função auxiliar para imprimir inteiros em C puro
void print_int(int num) {
    char buf[10];
    int i;
    int temp;

    if (num == 0) {
        write_char('0');
        return;
    }
    if (num < 0) {
        write_char('-');
        num = -num;
    }

    i = 0;
    temp = num;
    while (temp > 0) {
        buf[i] = '0' + (temp % 10);
        temp = temp / 10;
        i = i + 1;
    }

    while (i > 0) {
        i = i - 1;
        write_char(buf[i]);
    }
}

void print_str(char *s) {
    int i;
    i = 0;
    while (s[i] != '\0') {
        write_char(s[i]);
        i = i + 1;
    }
}

void salva_contexto(int idx) {
    int *quadro_hardware;
    int i;

    if (idx < 0 || idx >= NPROC) return;

    quadro_hardware = (int*) ENDERECO_QUADRO_SISTEMA;

    i = 0;
    while (i < TAM_QUADRO) {
        tabela_processos[idx].quadro[i] = quadro_hardware[i];
        i = i + 1;
    }
}

void restaura_contexto(int idx) {
    int *quadro_hardware;
    int i;

    if (idx < 0 || idx >= NPROC) return;

    quadro_hardware = (int*) ENDERECO_QUADRO_SISTEMA;

    i = 0;
    while (i < TAM_QUADRO) {
        quadro_hardware[i] = tabela_processos[idx].quadro[i];
        i = i + 1;
    }
}

// Atualiza o tempo acumulado no estado anterior antes de transicionar
void muda_estado(int idx, int novo_estado) {
    int delta;
    if (idx < 0 || idx >= NPROC) return;

    delta = relogio_ticks - tabela_processos[idx].tick_ultimo_estado;

    if (tabela_processos[idx].estado == ESTADO_PRONTO) {
        tabela_processos[idx].tempo_pronto = tabela_processos[idx].tempo_pronto + delta;
    } else if (tabela_processos[idx].estado == ESTADO_EXECUCAO) {
        tabela_processos[idx].tempo_execucao = tabela_processos[idx].tempo_execucao + delta;
    } else if (tabela_processos[idx].estado == ESTADO_BLOQUEADO) {
        tabela_processos[idx].tempo_bloqueado = tabela_processos[idx].tempo_bloqueado + delta;
    }

    tabela_processos[idx].estado = novo_estado;
    tabela_processos[idx].tick_ultimo_estado = relogio_ticks;

    // Registra métricas de entrada
    if (novo_estado == ESTADO_PRONTO) {
        tabela_processos[idx].cnt_pronto = tabela_processos[idx].cnt_pronto + 1;
        tabela_processos[idx].tick_desbloqueio = relogio_ticks;
    } else if (novo_estado == ESTADO_EXECUCAO) {
        tabela_processos[idx].cnt_execucao = tabela_processos[idx].cnt_execucao + 1;

        // Se estava aguardando na fila de PRONTO, calcula o tempo de resposta
        if (tabela_processos[idx].tick_desbloqueio >= 0) {
            tabela_processos[idx].soma_tempo_resposta = tabela_processos[idx].soma_tempo_resposta + (relogio_ticks - tabela_processos[idx].tick_desbloqueio);
            tabela_processos[idx].num_respostas = tabela_processos[idx].num_respostas + 1;
            tabela_processos[idx].tick_desbloqueio = -1;
        }
    } else if (novo_estado == ESTADO_BLOQUEADO) {
        tabela_processos[idx].cnt_bloqueado = tabela_processos[idx].cnt_bloqueado + 1;
    }
}

void monta_quadro_processo(int idx, int pid, int ip_inicial, int sr_inicial) {
    int k;
    tabela_processos[idx].pid = pid;
    tabela_processos[idx].motivo_bloqueio = BLOQ_NENHUM;
    tabela_processos[idx].pid_esperado = -1;

    tabela_processos[idx].data_criacao = relogio_ticks;
    tabela_processos[idx].data_termino = -1;
    tabela_processos[idx].num_preempcoes = 0;

    tabela_processos[idx].cnt_pronto = 0;
    tabela_processos[idx].cnt_bloqueado = 0;
    tabela_processos[idx].cnt_execucao = 0;

    tabela_processos[idx].tempo_pronto = 0;
    tabela_processos[idx].tempo_bloqueado = 0;
    tabela_processos[idx].tempo_execucao = 0;

    tabela_processos[idx].tick_desbloqueio = -1;
    tabela_processos[idx].soma_tempo_resposta = 0;
    tabela_processos[idx].num_respostas = 0;
    tabela_processos[idx].tick_ultimo_estado = relogio_ticks;

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

    monta_quadro_processo(0, 0, (int)process_idle_code, 0x8000);
    tabela_processos[0].estado = ESTADO_PRONTO;

    monta_quadro_processo(1, proximo_pid, (int)init, 0x0000);
    proximo_pid = proximo_pid + 1;
    total_processos_criados = total_processos_criados + 1;

    muda_estado(1, ESTADO_EXECUCAO);

    processo_atual = 1;
    quantum_restante = QUANTUM_DEFAULT;
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
    int proximo;
    int escolhido;

    int_relogio_count = int_relogio_count + 1;
    relogio_ticks = relogio_ticks + 1;

    atual = processo_atual;

    if (atual == 0) {
        ticks_ociosos = ticks_ociosos + 1;
    }

    // Preempção por estouro de quantum
    if (atual > 0 && tabela_processos[atual].estado == ESTADO_EXECUCAO) {
        quantum_restante = quantum_restante - 1;

        if (quantum_restante > 0) {
            return;
        }

        tabela_processos[atual].num_preempcoes = tabela_processos[atual].num_preempcoes + 1;
        total_preempcoes_sistema = total_preempcoes_sistema + 1;

        muda_estado(atual, ESTADO_PRONTO);
    }

    if (atual != -1) {
        salva_contexto(atual);
    }

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
        escolhido = 0;
    }

    processo_atual = escolhido;
    quantum_restante = QUANTUM_DEFAULT;

    muda_estado(escolhido, ESTADO_EXECUCAO);
    restaura_contexto(escolhido);
}

void pwake(int pid_morto) {
    int i;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_BLOQUEADO &&
            tabela_processos[i].motivo_bloqueio == BLOQ_ESPERA_PROC &&
            tabela_processos[i].pid_esperado == pid_morto) {

            muda_estado(i, ESTADO_PRONTO);
            tabela_processos[i].motivo_bloqueio = BLOQ_NENHUM;
            tabela_processos[i].pid_esperado = -1;
        }
        i = i + 1;
    }
}

// Trata o caractere vindo da interrupção do console (ponte.asm)
void received_key(int caractere) {
    int i;
    int proc_esperando;

    int_teclado_count = int_teclado_count + 1;

    // Busca se há algum processo bloqueado aguardando leitura
    proc_esperando = -1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_BLOQUEADO &&
            tabela_processos[i].motivo_bloqueio == BLOQ_LEITURA) {
            proc_esperando = i;
            break;
        }
        i = i + 1;
    }

    if (proc_esperando != -1) {
        // Grava o caractere lido diretamente no registrador R0 do processo
        tabela_processos[proc_esperando].quadro[0] = caractere;
        muda_estado(proc_esperando, ESTADO_PRONTO);
        tabela_processos[proc_esperando].motivo_bloqueio = BLOQ_NENHUM;

        if (processo_atual == 0) {
            so_escalona();
        }
    } else if (buffer_console_qtd < TAM_BUFFER_ENTRADA) {
        // Armazena na fila circular do SO
        buffer_console_dados[buffer_console_fim] = caractere;
        buffer_console_fim = (buffer_console_fim + 1) % TAM_BUFFER_ENTRADA;
        buffer_console_qtd = buffer_console_qtd + 1;
    }
}

// --- Syscalls ---

int sys_read(void) {
    int caractere;
    int_syscall_count = int_syscall_count + 1;

    if (buffer_console_qtd > 0) {
        caractere = buffer_console_dados[buffer_console_inicio];
        buffer_console_inicio = (buffer_console_inicio + 1) % TAM_BUFFER_ENTRADA;
        buffer_console_qtd = buffer_console_qtd - 1;
        return caractere;
    } else {
        // Bloqueia e cede a CPU sem fazer espera ocupada
        muda_estado(processo_atual, ESTADO_BLOQUEADO);
        tabela_processos[processo_atual].motivo_bloqueio = BLOQ_LEITURA;
        quantum_restante = 0;
        so_escalona();

        // Retorna o valor gravado em R0 pelo tratamento da interrupção
        return tabela_processos[processo_atual].quadro[0];
    }
}

int sys_write(int c) {
    int_syscall_count = int_syscall_count + 1;
    if (c == 0) return 0;
    write_char(c);
    return 1;
}

int sys_newproc(void (*entry)(void)) {
    int i;
    int_syscall_count = int_syscall_count + 1;
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].estado == ESTADO_LIVRE || tabela_processos[i].estado == ESTADO_MORTO) {
            monta_quadro_processo(i, proximo_pid, (int)entry, 0x0000);
            muda_estado(i, ESTADO_PRONTO);

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

    int_syscall_count = int_syscall_count + 1;
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
        tabela_processos[idx_alvo].data_termino = relogio_ticks;
        muda_estado(idx_alvo, ESTADO_MORTO);
        pwake(tabela_processos[idx_alvo].pid);

        // Imprime quando o Init morrer
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

    int_syscall_count = int_syscall_count + 1;

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

    muda_estado(processo_atual, ESTADO_BLOQUEADO);
    tabela_processos[processo_atual].motivo_bloqueio = BLOQ_ESPERA_PROC;
    tabela_processos[processo_atual].pid_esperado = pid;

    quantum_restante = 0;
    so_escalona();
    return 0;
}

// Impressão Detalhada do Relatório Exigido pelo Professor
void imprime_metricas(void) {
    int i;
    int tempo_retorno;
    int tm_resposta;

    print_str("\n================ RELATORIO DO SO ================\n");
    print_str("1. Processos Criados: "); print_int(total_processos_criados); print_str("\n");
    print_str("2. Tempo Total Execucao: "); print_int(relogio_ticks); print_str(" ticks\n");
    print_str("3. Tempo Ocioso (Idle): "); print_int(ticks_ociosos); print_str(" ticks\n");
    print_str("4. Total de Preempcoes: "); print_int(total_preempcoes_sistema); print_str("\n");

    print_str("5. Interrupcoes Recebidas:\n");
    print_str("   - Relogio: "); print_int(int_relogio_count); print_str("\n");
    print_str("   - Teclado: "); print_int(int_teclado_count); print_str("\n");
    print_str("   - Syscalls: "); print_int(int_syscall_count); print_str("\n");

    print_str("\n--- METRICAS POR PROCESSO ---\n");
    i = 1;
    while (i < NPROC) {
        if (tabela_processos[i].pid != -1) {
            print_str("Processo PID "); print_int(tabela_processos[i].pid); print_str(":\n");

            tempo_retorno = tabela_processos[i].data_termino - tabela_processos[i].data_criacao;
            print_str("  * Tempo Retorno: "); print_int(tempo_retorno); print_str(" ticks\n");
            print_str("  * Preempcoes: "); print_int(tabela_processos[i].num_preempcoes); print_str("\n");

            print_str("  * Entradas Estados (PR/BL/EX): ");
            print_int(tabela_processos[i].cnt_pronto); print_str(" / ");
            print_int(tabela_processos[i].cnt_bloqueado); print_str(" / ");
            print_int(tabela_processos[i].cnt_execucao); print_str("\n");

            print_str("  * Tempos acumulados (PR/BL/EX): ");
            print_int(tabela_processos[i].tempo_pronto); print_str(" / ");
            print_int(tabela_processos[i].tempo_bloqueado); print_str(" / ");
            print_int(tabela_processos[i].tempo_execucao); print_str(" ticks\n");

            tm_resposta = 0;
            if (tabela_processos[i].num_respostas > 0) {
                tm_resposta = tabela_processos[i].soma_tempo_resposta / tabela_processos[i].num_respostas;
            }
            print_str("  * Tempo Medio Resposta: "); print_int(tm_resposta); print_str(" ticks\n\n");
        }
        i = i + 1;
    }
    print_str("=================================================\n");
}