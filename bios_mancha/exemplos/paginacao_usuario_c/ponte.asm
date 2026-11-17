; ponte.asm -- a "ponte" entre a convenção de chamada da BIOS (r0..r3,
; sem empilhar) e a do mcc (argumentos empilhados, ver
; ../../../compilador_c/README.md) -- mesmo papel de
; ../multitarefa_c/ponte.asm, com duas coisas novas:
;
;  1. "escreve_caractere" faz "trap 7" por dentro (não "outb" direto),
;     já que os processos rodam em modo usuário de verdade (I=0) --
;     ver o comentário em kernel.c.
;  2. Este arquivo também é responsável por preparar o mapeamento de
;     CÓDIGO por identidade (preenche_identidade, abaixo). As tabelas de
;     página e as páginas de dados em si ficam em dados.asm, um arquivo
;     SEPARADO montado por último -- ver o comentário perto do fim
;     deste arquivo para o motivo (um bug real, encontrado ao escrever
;     este exemplo).
;
; monte com (ver também o Makefile deste diretório):
;   mcc -Iinc kernel.c -o kernel.asm
;   montador ../../src/bios.asm ponte.asm kernel.asm dados.asm -o paginacao_usuario_c.mob

        .equ    TICKS_POR_FATIA = 4000    ; ver o aviso sobre isto em ../multitarefa.asm
        .equ    SYS_ESCREVE     = 1
        .equ    N_PAGINAS_IDENTIDADE = 32    ; cobre 32*512 = 16384 bytes de código
                                                ; compartilhado (bios.asm + este arquivo +
                                                ; kernel.c compilado) -- bem generoso de
                                                ; propósito (o mcc não otimiza, então o
                                                ; código compilado é maior do que se
                                                ; poderia imaginar à primeira vista -- ver
                                                ; o aviso perto do fim deste arquivo), para
                                                ; não precisar calcular o tamanho exato do
                                                ; módulo combinado

; ------------------------------------------------- E/S para o C (via syscall)
;
; void escreve_caractere(int c);  -- 1 argumento, convenção do mcc: fica
; em (bp+4).
_f_escreve_caractere:
        push    bp
        ld      bp, sp
        ld      r1, (bp+4)
        ld      r0, SYS_ESCREVE
        trap    7
        ld      sp, bp
        pop     bp
        ret

; recebe r0=número (ignorado), r1=caractere -- convenção da BIOS,
; instalada em tabela_syscalls[SYS_ESCREVE] por _kernel_inicio, abaixo
sys_escreve_impl:
        ld      r0, r1
        call    bios_putc
        ld      r0, 0
        ret

; preenche as N_PAGINAS_IDENTIDADE primeiras entradas de UMA tabela de
; páginas (r0 = endereço da tabela) com um mapeamento por IDENTIDADE
; (página N -> quadro N, o mesmo número) -- é isso que permite que o
; código compilado pelo mcc (que só sabe gerar jmp/jmpc/call absolutos,
; nunca relativos) continue funcionando corretamente mesmo com a
; paginação ligada: toda página de código mapeia para ela mesma,
; então endereço virtual == endereço físico, exatamente como se a
; tradução nem existisse. Só leitura (tipo=1), bit de acesso já ligado
; (evita a BIOS reescrever a entrada no primeiro acesso -- só por
; limpeza, não é obrigatório).
preenche_identidade:
        push    bp
        ld      bp, sp
        ld      r1, 0
pi_laco:
        cmp     r1, N_PAGINAS_IDENTIDADE
        jmpc    ge, pi_fim
        ld      r2, 0x6000
        add     r2, r1
        ld      r3, r0
        add     r3, r1
        add     r3, r1              ; r3 = r0 + r1*2 (endereço da entrada "r1" na tabela)
        st      r2, (r3)
        add     r1, 1
        jmp     pi_laco
pi_fim:
        ld      sp, bp
        pop     bp
        ret

; ----------------------------------------------------- inicialização
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

        ld      r0, escalonador_trampolim
        st      r0, (retomada_escalonador)

        ; prepara o mapeamento de código por identidade das duas tabelas
        ld      r0, tabela_pt_a
        call    preenche_identidade
        ld      r0, tabela_pt_b
        call    preenche_identidade

        ; monta os quadros iniciais (inicializa_processos, em kernel.c)
        ; -- convenção do mcc: argumentos empilhados da direita para a
        ; esquerda (quadro_boot é o 1º parâmetro, então é empilhado por
        ; último, ver ../../../compilador_c/README.md)
        ld      r1, dados_b
        push    r1
        ld      r1, tabela_pt_b
        push    r1
        ld      r1, dados_a
        push    r1
        ld      r1, tabela_pt_a
        push    r1
        ld      r1, pilha_sistema
        add     r1, -32
        push    r1
        call    _f_inicializa_processos
        add     sp, 10

        ei                                    ; liga interrupções externas

        ; "rete" a partir do endereço onde inicializa_processos() acabou
        ; de escrever o quadro do processo 0 -- mesmo aviso de
        ; ../multitarefa_c/ponte.asm: "rete" lê de "sp" de verdade, não
        ; de qualquer ponteiro usado para escrever os dados.
        ld      sp, pilha_sistema
        add     sp, -32
        rete

; -------------------------------------------------- ponte pro escalonador em C
;
; idêntica a ../multitarefa_c/ponte.asm -- escalonador() não precisa
; saber o que os campos do quadro significam, só copia 16 palavras de
; um lugar para o outro.
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

; As duas tabelas de páginas e as duas páginas de dados ficam num
; arquivo SEPARADO (dados.asm) -- não aqui. Motivo: o montador trata os
; arquivos .asm passados numa só chamada como um módulo só, com um
; único contador de endereço de carga que CONTINUA de um arquivo para o
; outro, na ordem dada na linha de comando (ver
; ../../../simulador_completo/README.md) -- e kernel.asm (gerado a
; partir de kernel.c) é montado DEPOIS deste arquivo (ver o Makefile).
; Se as páginas de dados fossem reservadas AQUI com um ".org" fixo,
; qualquer coisa que o kernel.c compilasse DEPOIS delas (processoA,
; processoB, etc. -- bem mais código do que cabe antes de um ".org"
; escolhido sem saber o tamanho exato do kernel.c compilado) acabaria
; colocada EM ENDEREÇOS MAIORES que o planejado, furando as páginas de
; identidade (foi exatamente o bug real encontrado ao escrever este
; exemplo: com as páginas de dados declaradas aqui, o código de
; processoA acabava montado DEPOIS delas, em endereços fora do alcance
; de preenche_identidade, e a primeira instrução de cada processo já
; causava "ausência de quadro"). Por isso dados.asm é montado por
; ÚLTIMO (depois de kernel.asm): a essa altura, o contador de endereço
; já reflete o fim de TUDO (bios.asm + este arquivo + kernel.asm
; compilado), e o ".org" generoso de dados.asm só precisa garantir que
; está depois desse fim, não adivinhar o tamanho de nada.

