        .equ    TICKS_POR_FATIA = 4000
        .equ    KERNEL_CRIA_PROC = 0 ; Código Syscall KERNEL_CRIA_PROC
        .equ    KERNEL_MATA_PROC = 1 ; Código da Syscall KERNEL_MATA_PROC

_kernel_inicio:
        ; programa o relógio (só dá pra fazer com "outb", que C não tem)
        ld      r0, TICKS_POR_FATIA ; carrega o valor máximo do clock para r0
        ld      r1, r0              ; copia r0 pra r1
        shr     r1, 8               ; shift para a direita de 8 bits, agora r1 vale os 8 MSBs de TICKS_POR_FATIA
        outb    r1, (0x22)          ; carrega os 8 MSBs de TICKS_POR_FATIA na porta 0x22
        outb    r0, (0x23)          ; carrega os 8 LSBs de TICKS_POR_FATIA na porta 0x23

        ; habilita interrupções de console (bit0) e relógio (bit2)
        ld      r0, 5               ; 5 = 0b0101 -> bit 0 e bit 2 são 1
        outb    r0, (0x30)          ; escreve os bits na porta 0x30

        ld    r0, _trampolim_cria_proc ; carrega o endereço da chamada cria_proc em r0
        st    r0, (tabela_syscalls)    ; põe o endereço da chamada no "idx" 0 da tabela de chamadas

        ld    r0, _trampolim_mata_proc ; carrega o endereço da chamada mata_proc em r0
        st    r0, (tabela_syscalls+2)    ; põe o endereço da chamada no "idx" 1 da tabela de chamadas

        ld    r0, so_escalona_trampolim  ; carrega o endereço de so_escalona_trampolim em r0
        st    r0, (retomada_escalonador) ; põe o endereço de so_escalona_trampolim em retomada_escalonador

        ld      r0, pilha_sistema
        add     r0, -32
        push    r0
        call    _f_inicializa_processos
        add     sp, 2

        ld      sp, pilha_sistema      ; carrega o endereço da pilha do sistema para sp
        add     sp, -32                ; sp agora aponta para o começo do quadro de 16 palavras
        rete                           ; desempilha o quadro que começa em pilha_sistema para iniciar o primeiro processo

_f_KERNEL_CRIA_PROC:
    push  bp
    ld    bp, sp
    ld    r0, KERNEL_CRIA_PROC
    ld    r1, (bp+4)              ; Parâmetro: ponteiro do programa
    trap  7
    ld    sp, bp
    pop   bp
    ret

_trampolim_cria_proc:
    push  r1
    call  _f_kernel_cria_proc
    add   sp, 2
    ret

_f_KERNEL_MATA_PROC:
    push  bp
    ld    bp, sp
    ld    r0, KERNEL_MATA_PROC
    ld    r1, (bp+4)              ; Parâmetro: pid do processo a ser morto
    trap  7
    ld    sp, bp
    pop   bp
    ret

_trampolim_mata_proc:
    push  r1
    call  _f_kernel_mata_proc
    add   sp, 2
    ret

so_escalona_trampolim:
        ld      r1, sp
        push    r1
        call    _f_so_escalona
        add sp, 2
        rete