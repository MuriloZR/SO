.equ TICKS_POR_FATIA = 4000

; --- Wrappers para programas de usuário em C (so.h) ---

_f_so_le:
    push  bp
    ld    bp, sp
    ld    r0, 0        ; Código Syscall SO_LE
    trap  7
    ld    sp, bp
    pop   bp
    ret

_f_so_escreve:
    push  bp
    ld    bp, sp
    ld    r0, 1        ; Código Syscall SO_ESCREVE
    ld    r1, (bp+4)   ; Parâmetro: int c
    trap  7
    ld    sp, bp
    pop   bp
    ret

_f_so_cria_proc:
    push  bp
    ld    bp, sp
    ld    r0, 2        ; Código Syscall SO_CRIA_PROC
    ld    r1, (bp+4)   ; Parâmetro: ponteiro entry
    trap  7
    ld    sp, bp
    pop   bp
    ret

_f_so_mata_proc:
    push  bp
    ld    bp, sp
    ld    r0, 3        ; Código Syscall SO_MATA_PROC
    ld    r1, (bp+4)   ; Parâmetro: pid
    trap  7
    ld    sp, bp
    pop   bp
    ret

_f_so_espera_proc:
    push  bp
    ld    bp, sp
    ld    r0, 4        ; Código Syscall SO_ESPERA_PROC
    ld    r1, (bp+4)   ; Parâmetro: pid a esperar
    trap  7
    ld    sp, bp
    pop   bp
    ret

; --- Trampolins das Syscalls (executados em Modo Supervisor) ---

_trampolim_le:
    push  r1
    call  _f_sys_read
    add   sp, 2
    ret

_trampolim_escreve:
    push  r1
    call  _f_sys_write
    add   sp, 2
    ret

_trampolim_cria_proc:
    push  r1
    call  _f_sys_newproc
    add   sp, 2
    ret

_trampolim_mata_proc:
    push  r1
    call  _f_sys_killproc
    add   sp, 2
    ret

_trampolim_espera_proc:
    push  r1
    call  _f_sys_wait
    add   sp, 2
    ret

; --- Trampolim do Escalonador / Relógio ---

trampolim_escalonador:
    call  _f_so_escalona
    rete

; --- Rotina de Inicialização do Kernel ---

_kernel_inicio:
    ; Configura o temporizador da CPU
    ld    r0, TICKS_POR_FATIA
    ld    r1, r0
    shr   r1, 8
    outb  r1, (0x22)   ; PORTA_RELOGIO_LIM_ALTO
    outb  r0, (0x23)   ; PORTA_RELOGIO_LIM_BAIXO

    ; Habilita interrupções de console (bit0) e relógio (bit2)
    ld    r0, 5
    outb  r0, (0x30)

    ; Registra as chamadas na tabela_syscalls da BIOS
    ld    r0, _trampolim_le
    st    r0, (tabela_syscalls)
    ld    r0, _trampolim_escreve
    st    r0, (tabela_syscalls+2)
    ld    r0, _trampolim_cria_proc
    st    r0, (tabela_syscalls+4)
    ld    r0, _trampolim_mata_proc
    st    r0, (tabela_syscalls+6)
    ld    r0, _trampolim_espera_proc
    st    r0, (tabela_syscalls+8)

    ; Instala o manipulador de estouro de relógio
    ld    r0, trampolim_escalonador
    st    r0, (retomada_escalonador)

    ; Instala o manipulador de interrupção do console no quadro 8 (endereço 64)
    ld    r0, trampolim_console
    st    r0, (64)

    ; Mapeia a chamada de inicialização do Kernel C passando a tabela_syscalls
    ld    r0, tabela_syscalls
    push  r0
    call  _f_procinit
    add   sp, 2

    ei                 ; Habilita interrupções globais

    ; Prepara o retorno para o processo 'init' inicializado em C
    ld    sp, pilha_sistema
    add   sp, -32
    rete

; Rotina auxiliar de escrita direta na porta da console
_f_write_char:
    push  bp
    ld    bp, sp
    ld    r0, (bp+4)
    outb  r0, (1)
    ld    sp, bp
    pop   bp
    ret

; Permite ao Kernel C colocar a CPU em espera habilitando interrupções
_f_espera_interrupcao:
    ei
    ret

; --- Trampolim da Interrupção de Teclado/Console ---
trampolim_console:
.loop:
    inb   r0, (2)      ; Lê o estado da porta do console
    and   r0, 2
    cmp   r0, 0
    jmpc  eq, .end    ; Se não houver mais caracteres para ler, encerra

    inb   r0, (1)      ; Lê o caractere da porta 1
    and   r0, 255

    push  r0
    call  _f_received_key  ; Entrega o caractere para o Kernel C
    add   sp, 2

    jmp   .loop

.end:
    rete