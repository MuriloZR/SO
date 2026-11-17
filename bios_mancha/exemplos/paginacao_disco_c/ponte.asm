; ponte.asm -- a ponte entre a convenção de chamada da BIOS (r0..r3, sem
; empilhar) e a do mcc (argumentos empilhados, ver
; ../../../compilador_c/README.md) -- mesmo papel de
; ../multitarefa_c/ponte.asm, com uma coisa nova: _kernel_inicio, abaixo,
; carrega o CÓDIGO de cada processo de um disco simulado, em tempo de
; execução, antes de montar os quadros iniciais (ver
; ../../README.md, "O mesmo exemplo, com os processos em C").
;
; Note que "escreve_caractere" NÃO está aqui -- diferente de
; ../paginacao_usuario_c/ponte.asm. Como cada processo (processoA.c/
; processoB.c) é compilado e montado SOZINHO, a implementação dele
; precisa estar no MESMO módulo que cada processo -- ver
; escreve_caractere.asm, montado junto com processoA.asm/processoB.asm
; (ver o Makefile), não com o kernel.
;
; monte com (ver também o Makefile deste diretório):
;   mcc kernel.c -o kernel.asm
;   montador ../../src/bios.asm ponte.asm kernel.asm dados.asm -o paginacao_disco_c.mob

        .equ    TICKS_POR_FATIA = 4000    ; ver o aviso sobre isto em ../multitarefa.asm
        .equ    SYS_ESCREVE     = 1

; ----------------------------------------------------- inicialização
_kernel_inicio:
        ; carrega o CÓDIGO de cada processo do disco pro quadro físico
        ; que a tabela de páginas dele aponta (ver dados.asm) -- setor 0
        ; = processoA, setor 1 = processoB (é assim que o Makefile monta
        ; disco.img). Síncrono, sem necessidade de sincronização extra.
        ld      r0, 0                          ; face
        ld      r1, 0                          ; trilha
        ld      r2, 0                            ; setor 0 = processoA
        ld      r3, quadro_codigo_a
        call    bios_disco_le_setor

        ld      r0, 0
        ld      r1, 0
        ld      r2, 1                             ; setor 1 = processoB
        ld      r3, quadro_codigo_b
        call    bios_disco_le_setor

        ld      r0, SYS_ESCREVE
        add     r0, r0
        add     r0, tabela_syscalls
        ld      r1, sys_escreve_impl
        st      r1, (r0)

        ld      r0, TICKS_POR_FATIA
        ld      r1, r0
        shr     r1, 8
        outb    r1, (0x22)                  ; PORTA_RELOGIO_LIM_ALTO
        outb    r0, (0x23)                   ; PORTA_RELOGIO_LIM_BAIXO

        ld      r0, 5                          ; habilita console (bit0) e relogio (bit2)
        outb    r0, (0x30)                      ; PORTA_CTRL_INTERRUPCOES

        ld      r0, escalonador_trampolim
        st      r0, (retomada_escalonador)

        ; inicializa_processos(quadro_boot, tabela_a, tabela_b) -- convenção
        ; do mcc: argumentos empilhados da direita para a esquerda (ver
        ; ../../../compilador_c/README.md)
        ld      r1, tabela_pt_b
        push    r1
        ld      r1, tabela_pt_a
        push    r1
        ld      r1, pilha_sistema
        add     r1, -32
        push    r1
        call    _f_inicializa_processos
        add     sp, 6

        ei                                    ; liga interrupções externas

        ; "rete" a partir do endereço onde inicializa_processos() acabou
        ; de escrever o quadro do processo 0 -- mesmo aviso de
        ; ../multitarefa_c/ponte.asm: "rete" lê de "sp" de verdade, não
        ; de qualquer ponteiro usado para escrever os dados.
        ld      sp, pilha_sistema
        add     sp, -32
        rete

; -------------------------------------------------- ponte pro escalonador em C
escalonador_trampolim:
        ld      r1, sp
        ld      r0, _g_processo_atual
        push    r0
        ld      r0, _g_processos
        push    r0
        ld      r0, r1
        push    r0
        call    _f_escalonador
        add     sp, 6
        rete

; recebe r0=número (ignorado), r1=caractere -- convenção da BIOS,
; instalada em tabela_syscalls[SYS_ESCREVE] por _kernel_inicio, acima.
; Chamada pelos processos (processoA.c/processoB.c) via trap 7, não por
; chamada direta -- ver escreve_caractere.asm.
sys_escreve_impl:
        ld      r0, r1
        call    bios_putc
        ld      r0, 0
        ret
