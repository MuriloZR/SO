        .equ    TICKS_POR_FATIA = 4000
        .equ    SO_CRIA_PROC = 0 ; Código Syscall SO_CRIA_PROC

_kernel_inicio:
        ; programa o relógio (só dá pra fazer com "outb", que C não tem)
        ld      r0, TICKS_POR_FATIA
        ld      r1, r0
        shr     r1, 8
        outb    r1, (0x22)                  ; PORTA_RELOGIO_LIM_ALTO
        outb    r0, (0x23)                   ; PORTA_RELOGIO_LIM_BAIXO

        ; habilita interrupções de console (bit0) e relógio (bit2)
        ld      r0, 5
        outb    r0, (0x30)

        ld    r0, _trampolim_cria_proc
        st    r0, (tabela_syscalls)

        ld      sp, pilha_sistema
        add     sp, -32
        rete

_f_so_cria_proc:
    push  bp
    ld    bp, sp
    ld    r0, SO_CRIA_PROC
    ld    r1, (bp+4)              ; Parâmetro: ponteiro do programa
    trap  7
    ld    sp, bp
    pop   bp
    ret

_trampolim_cria_proc:
    push  r1
    call  _f_cria_proc
    add   sp, 2
    ret