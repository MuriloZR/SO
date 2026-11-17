; paginacao_usuario.asm -- 2 processos em MODO USUÁRIO de verdade,
; alternados por um escalonador round-robin preemptivo, isolados por
; PAGINAÇÃO (mancha.pdf, secção 8) -- cada um com sua própria página de
; código e de dados, isoladas de verdade.
;
; monte com:
;   montador ../src/bios.asm paginacao_usuario.asm -o paginacao_usuario.mob
;
; LEIA ISTO -- um bug real do simulador foi encontrado e corrigido
; durante o desenvolvimento deste exemplo (ver
; ../../simulador_completo/src/cpu.c, função cpu_interrompe): toda
; interrupção/trap zera "cs"/"ds" para os valores fixos do quadro do
; vetor, mas, ANTES da correção, não desligava o bit P (paginação) de
; "sr" -- então, se um processo com paginação ativa fosse interrompido
; (pelo relógio, por um "trap", por qualquer exceção), o PRÓPRIO
; atendimento da interrupção continuaria traduzindo endereços com P=1 e
; "pt" já zerado (o valor fixo do vetor), lendo "entradas de tabela de
; páginas" de dentro do vetor de interrupções (endereço físico 0) --
; um resultado sem sentido, quase certo de travar o kernel assim que a
; primeira interrupção chegasse. Nenhum exemplo anterior expôs isso
; porque nenhum disparava uma interrupção estando com P=1 (o
; ../../simulador_completo/exemplos/paginacao.asm original só faz
; "halt" direto, que não passa pelo mecanismo de interrupção). Esse bug
; tornava multitarefa preemptiva com paginação impossível de verdade,
; não só deste exemplo -- por isso a correção foi no simulador, não
; contornada aqui.
;
; A MECÂNICA de paginação, em poucas palavras (mancha.pdf, secção 8;
; ver também ../../simulador_completo/src/cpu.c, função "traduz"): com
; P=1 em "sr", o registrador de supervisor s4 (chamado "pt" neste modo,
; em vez de "cs") aponta para uma TABELA DE PÁGINAS de até 256 entradas
; de 2 bytes. O endereço virtual de 16 bits é dividido em página (7
; bits mais altos) e deslocamento dentro da página (9 bits mais
; baixos, ou seja, páginas de 512 bytes). Acessos de CÓDIGO usam as
; entradas 0-127 (uma por página de código); acessos de DADOS usam as
; entradas 128-255 (a MESMA tabela, só que na segunda metade) -- é por
; isso que "pt" é o ÚNICO registrador de supervisor realmente usado sob
; paginação (diferente da segmentação, que precisa de cs/cl/ds/dl,
; quatro registradores). Cada entrada tem 3 bits de controle (tipo:
; 0=ausente, 1=só leitura, 2=leitura/escrita "limpa", 3=leitura/escrita
; "modificada"; e 1 bit de acesso) nos 3 bits mais altos, e o número do
; QUADRO FÍSICO (0 a 8191) nos 13 bits mais baixos -- o endereço físico
; final é "quadro*512 + deslocamento". Uma entrada com tipo 0 (o padrão,
; já que a memória começa zerada) causa a interrupção 5 (ausência de
; quadro) se o processo tentar alcançar essa página -- uma proteção de
; verdade, não só a tradução de endereço (ver o teste descrito no
; README do bios_mancha).
;
; Por causa do tamanho fixo do quadro (512 bytes), toda estrutura que
; precisa ser endereçável por número de quadro (as próprias tabelas de
; página não -- "pt" é um endereço físico comum; só o CÓDIGO e os DADOS
; de cada processo, que são alcançados a partir de um número de quadro
; dentro de uma entrada da tabela) tem que estar alinhada a um múltiplo
; de 512 bytes. Por isso este arquivo usa ".org" para posicionar cada
; bloco exatamente num múltiplo de 0x200 (ver mais abaixo).
;
; Por isso o código dos processos, abaixo, usa SÓ desvios RELATIVOS
; (bra/brac, nunca jmp/jmpc/call internos): enquanto o código de um
; processo couber inteiro numa única página (512 bytes, nosso caso), a
; tradução dentro dela é "quadro*512 + deslocamento" -- uma forma de
; "base + deslocamento" como qualquer outra. Um "jmp etiqueta" faria o
; montador gravar o endereço ABSOLUTO de "etiqueta" em "ip", e a próxima
; busca de instrução somaria a base de novo -- duas vezes (uma de
; verdade, pela tradução; outra escondida, porque o endereço resolvido
; pelo montador já embute a posição física real) -- desviando para o
; lugar errado. "bra"/"brac" não têm esse problema porque o montador
; resolve o alvo delas como um DESLOCAMENTO em bytes
; (valor_do_símbolo - endereço_da_próxima_instrução), somado ao "ip" em
; tempo de execução -- funciona certo seja qual for a base.

        .equ    TICKS_POR_FATIA = 4000    ; ver o aviso sobre isto em multitarefa.asm
        .equ    N_PROCESSOS     = 2
        .equ    SYS_ESCREVE     = 1

; ================================================================ kernel
;
; Mesma mecânica de ../multitarefa.asm -- o escalonador só copia 16
; palavras de um lugar para o outro (via bios_copia_quadro), sem se
; importar com o que elas significam.

_kernel_inicio:
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
; palavras"). Sob paginação, só "sr" e "s4" (pt) importam -- s1,s2,s3,
; s5,s6,s7 não são usados pela tradução (ver comentário grande no topo)
; e ficam 0 por simplicidade.
;   ip=0: endereço VIRTUAL inicial -- a página 0 de código de cada
;     processo (via a tabela dele) mapeia pro início do código de
;     verdade (codigo_a/codigo_b, mais abaixo).
;   sr=0x4000: S=0 (modo USUÁRIO), P=1 (PAGINAÇÃO ligada), I=0 (sem
;     "in"/"out" diretos), D=0 (interrompível -- sem isso o relógio
;     nunca teria uma chance de preemptar o processo).
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
; A partir daqui, tudo alinhado a múltiplos de 0x200 (512 bytes) -- o
; tamanho de um quadro físico. 0x1000 é só um valor confortavelmente
; maior que bios.asm + o código do kernel acima (que não chega a
; ocupar nem 1/4 disso), escolhido pra nem precisar calcular o fim
; exato: qualquer múltiplo de 0x200 que sobre espaço bastaria.
;
; tabela_pt_a/tabela_pt_b: 256 entradas de 2 bytes (512 bytes) cada,
; mas só 2 entradas de cada uma são realmente preenchidas -- entrada 0
; (página 0 de CÓDIGO) e entrada 128 (página 0 de DADOS, em
; "tabela+128*2" = "tabela+256"). O resto fica 0 (memória começa
; zerada) = "ausente" = causaria a interrupção 5 se o processo tentasse
; alcançar qualquer outra página, exatamente a mesma proteção que o
; limite de segmento dava no outro exemplo.
;
;   entrada = (tipo<<14) | (acesso<<13) | quadro_fisico
;   código: tipo=1 (só leitura), acesso=1 (evita a BIOS reescrever a
;     entrada no primeiro acesso, só por limpeza -- ver cpu.c, não é
;     obrigatório) -> 0x4000|0x2000|quadro = 0x6000|quadro
;   dados: tipo=3 (leitura/escrita, já "modificado") -> 0xC000|0x2000|
;     quadro = 0xE000|quadro

        .org    0x1000
tabela_pt_a:
        .dw     0x600A                   ; página 0 código -> quadro 10 (codigo_a)
        .org    0x1100
        .dw     0xE00C                   ; página 0 dados  -> quadro 12 (dados_a)

        .org    0x1200
tabela_pt_b:
        .dw     0x600B                   ; página 0 código -> quadro 11 (codigo_b)
        .org    0x1300
        .dw     0xE00D                   ; página 0 dados  -> quadro 13 (dados_b)

; códigos dos processos -- só desvios relativos (ver o aviso grande no
; topo), acesso a dados via "(r3)" com r3=literal 0, nunca por símbolo
; (pelo mesmo motivo: um rótulo como "dados_a" resolveria pro endereço
; físico ABSOLUTO, e a tradução por página somaria a base de novo).

        .org    0x1400                   ; quadro 10 = 0x1400 / 0x200
codigo_a:
pa_loop:
        ld      r3, 0                       ; r3 = endereço VIRTUAL 0 (o contador mora
                                              ; no início da página de dados do processo)
        ld      r4, (r3)
        addq    r4, 1
        st      r4, (r3)

        ld      r0, SYS_ESCREVE
        ld      r1, 'A'
        trap    7
        ld      r0, SYS_ESCREVE
        ld      r1, ':'
        trap    7

        ld      r2, r4
        div     r2, 10
        mul     r2, 10
        sub     r4, r2
        addq    r4, 48
        ld      r0, SYS_ESCREVE
        ld      r1, r4
        trap    7
        ld      r0, SYS_ESCREVE
        ld      r1, 32
        trap    7

        ld      r2, 3000
pa_atraso:
        addq    r2, -1
        cmp     r2, 0
        brac    ne, pa_atraso
        bra     pa_loop

        .org    0x1600                   ; quadro 11 = 0x1600 / 0x200
codigo_b:
pb_loop:
        ld      r3, 0
        ld      r4, (r3)
        addq    r4, 1
        st      r4, (r3)

        ld      r0, SYS_ESCREVE
        ld      r1, 'B'
        trap    7
        ld      r0, SYS_ESCREVE
        ld      r1, ':'
        trap    7

        ld      r2, r4
        div     r2, 10
        mul     r2, 10
        sub     r4, r2
        addq    r4, 48
        ld      r0, SYS_ESCREVE
        ld      r1, r4
        trap    7
        ld      r0, SYS_ESCREVE
        ld      r1, 32
        trap    7

        ld      r2, 3000
pb_atraso:
        addq    r2, -1
        cmp     r2, 0
        brac    ne, pb_atraso
        bra     pb_loop

        .org    0x1800                   ; quadro 12 = 0x1800 / 0x200
dados_a:
        .dw     0

        .org    0x1A00                   ; quadro 13 = 0x1A00 / 0x200
dados_b:
        .dw     0
