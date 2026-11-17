; kernel.asm -- kernel deste exemplo (ver ../../README.md, "Processos de
; usuário com paginação real, carregados do disco"): a mesma mecânica de
; escalonamento round-robin de ../multitarefa.asm / ../paginacao_usuario.asm,
; com os dois processos isolados por paginação -- mas o CÓDIGO de cada
; processo não está neste arquivo. Ele é montado sozinho (ver
; processoA.asm/processoB.asm), convertido para um binário puro (mob2bin,
; ver Makefile) e gravado num setor de um disco simulado. É
; _kernel_inicio, abaixo, que carrega isso de verdade, EM TEMPO DE
; EXECUÇÃO, via bios_disco_le_setor -- direto para o quadro físico que a
; tabela de páginas de cada processo vai apontar (sem buffer
; intermediário: o destino do "bios_disco_le_setor" já é o quadro físico
; final).
;
; Por que isso elimina a necessidade de "bra"/"brac" (comparar com
; ../paginacao_usuario.asm): lá, codigo_a/codigo_b são montados JUNTO com
; bios.asm e o kernel, numa única chamada do montador que compartilha um
; contador de endereço só -- então o endereço físico real de cada um
; (0x1400/0x1600) fica embutido em qualquer "jmp" absoluto dentro deles, e
; a tradução de página somaria essa base de novo. Aqui, processoA.asm/
; processoB.asm nunca são montados junto com mais nada -- o endereço que
; o montador embute em cada "jmp"/"jmpc" deles é só o deslocamento dentro
; do próprio módulo (0x0000 em diante), que por construção já é também o
; endereço VIRTUAL certo (todo processo paginado roda com "ip"=0 virtual).
; O quadro físico real onde esses bytes acabam só é decidido por
; _kernel_inicio, bem depois de processoA.asm/processoB.asm já estarem
; montados -- então processoA/processoB podem usar "jmp"/"jmpc" normais.
;
; monte com (ver também o Makefile deste diretório):
;   montador ../../src/bios.asm kernel.asm -o paginacao_disco.mob
;
; execute com um disco montado na unidade 0 (ver Makefile/README):
;   ../../../simulador_completo/bin/simulador paginacao_disco.mob -D disco.img

        .equ    TICKS_POR_FATIA = 4000    ; ver o aviso sobre isto em ../multitarefa.asm
        .equ    N_PROCESSOS     = 2
        .equ    SYS_ESCREVE     = 1

; ================================================================ kernel
;
; Mesma mecânica de ../multitarefa.asm -- o escalonador só copia 16
; palavras de um lugar para o outro (via bios_copia_quadro), sem se
; importar com o que elas significam.

_kernel_inicio:
        ; carrega o CÓDIGO de cada processo do disco pro quadro físico
        ; que a tabela de páginas dele aponta (ver mais abaixo) -- setor 0
        ; = processoA, setor 1 = processoB (é assim que o Makefile monta
        ; disco.img a partir de processoA.bin/processoB.bin). Síncrono
        ; (bios_disco_le_setor só devolve o controle depois de terminar),
        ; então não precisa de nenhuma sincronização extra aqui.
        ld      r0, 0                          ; face
        ld      r1, 0                          ; trilha
        ld      r2, 0                            ; setor 0 = processoA
        ld      r3, quadro_codigo_a               ; destino: o próprio quadro físico
        call    bios_disco_le_setor                ; que tabela_pt_a vai apontar

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

        ld      r0, escalonador
        st      r0, (retomada_escalonador)

        ld      r0, 0
        st      r0, (processo_atual)

        ei

        ld      sp, pilha_sistema
        add     sp, -32
        ld      r1, processos
        ld      r0, (r1)
        ld      r1, sp
        call    bios_copia_quadro
        rete

escalonador:
        ld      r0, sp
        ld      r1, (processo_atual)
        ld      r2, r1
        add     r2, r2
        add     r2, processos
        ld      r1, (r2)
        call    bios_copia_quadro

        ld      r1, (processo_atual)
        add     r1, 1
        cmp     r1, N_PROCESSOS
        jmpc    lt, esc_indice_ok
        ld      r1, 0
esc_indice_ok:
        st      r1, (processo_atual)

        ld      r2, r1
        add     r2, r2
        add     r2, processos
        ld      r0, (r2)
        ld      r1, sp
        call    bios_copia_quadro

        rete

sys_escreve_impl:
        ld      r0, r1
        call    bios_putc
        ld      r0, 0
        ret

        .data
processo_atual: .dw 0
processos:
        .dw     quadro_a, quadro_b

; quadro de 16 palavras (ver README do bios_mancha, "o quadro de 16
; palavras"). Sob paginação, só "sr" e "s4" (pt) importam.
;   ip=0: endereço VIRTUAL inicial -- a página 0 de código de cada
;     processo (via a tabela dele) mapeia pro quadro físico onde
;     _kernel_inicio acabou de copiar o código, vindo do disco.
;   sr=0x4000: S=0 (modo USUÁRIO), P=1 (PAGINAÇÃO ligada), I=0, D=0.
;   s4(pt): endereço físico da tabela de páginas do processo.
quadro_a:
        .dw     0, 0, 0, 0, 0
        .dw     0
        .dw     0
        .dw     0
        .dw     0x4000
        .dw     0, 0, 0
        .dw     tabela_pt_a
        .dw     0, 0, 0

quadro_b:
        .dw     0, 0, 0, 0, 0
        .dw     0
        .dw     0
        .dw     0
        .dw     0x4000
        .dw     0, 0, 0
        .dw     tabela_pt_b
        .dw     0, 0, 0

; ================================================= estruturas paginadas
;
; Mesmo layout de ../paginacao_usuario.asm (ver os comentários lá para a
; explicação completa de alinhamento por quadro de 512 bytes): tabelas em
; 0x1000/0x1200, código em 0x1400/0x1600 (quadros 10 e 11), dados em
; 0x1800/0x1A00 (quadros 12 e 13).
;
;   entrada = (tipo<<14) | (acesso<<13) | quadro_fisico
;   código: tipo=1 (só leitura), acesso=1 -> 0x6000|quadro
;   dados: tipo=3 (leitura/escrita) -> 0xE000|quadro

        .org    0x1000
tabela_pt_a:
        .dw     0x600A                   ; página 0 código -> quadro 10 (quadro_codigo_a)
        .org    0x1100
        .dw     0xE00C                   ; página 0 dados  -> quadro 12 (dados_a)

        .org    0x1200
tabela_pt_b:
        .dw     0x600B                   ; página 0 código -> quadro 11 (quadro_codigo_b)
        .org    0x1300
        .dw     0xE00D                   ; página 0 dados  -> quadro 13 (dados_b)

; quadro 10 e 11 (código): propositalmente SEM conteúdo montado aqui --
; só reservados (.ds, que não gera nenhum byte). É _kernel_inicio, acima,
; que os preenche em tempo de execução, lendo o disco. Essa ausência de
; conteúdo é o ponto central do exemplo: o que vai rodar nesses quadros
; nunca passou pela montagem deste arquivo, então o montador nunca teve
; chance de embutir o endereço físico 0x1400/0x1600 em nenhum "jmp" --
; processoA.asm/processoB.asm foram montados isoladamente, sem saber (e
; sem precisar saber) onde fisicamente seu código ia acabar.
        .org    0x1400                   ; quadro 10 = 0x1400 / 0x200
quadro_codigo_a:
        .ds     256                       ; 256 palavras = 512 bytes = 1 quadro
        .org    0x1600                   ; quadro 11 = 0x1600 / 0x200
quadro_codigo_b:
        .ds     256

        .org    0x1800                   ; quadro 12 = 0x1800 / 0x200
dados_a:
        .dw     0

        .org    0x1A00                   ; quadro 13 = 0x1A00 / 0x200
dados_b:
        .dw     0
