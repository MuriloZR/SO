; processoA.asm -- o CÓDIGO do processo A deste exemplo (ver
; ../../README.md, "Processos de usuário com paginação real, carregados
; do disco"), montado SOZINHO (nenhum outro arquivo na mesma chamada do
; montador) e de propósito SEM nenhum ".org": o contador de endereço
; começa em 0 só para este módulo, então todo "jmp"/"jmpc" abaixo
; resolve para um endereço ABSOLUTO pequeno (0x0000, 0x0006, ...) -- que
; já É o endereço VIRTUAL correto, porque este processo, sob paginação,
; sempre roda com a página 0 de código começando em "ip"=0 virtual.
;
; Por isso este arquivo NÃO precisa da restrição de desvios relativos
; (bra/brac) que ../paginacao_usuario.asm precisa: lá, codigo_a é
; montado JUNTO com bios.asm e o kernel, numa única chamada do montador
; que compartilha um contador de endereço só -- então o endereço físico
; real (0x1400, por exemplo) fica embutido em qualquer "jmp" absoluto, e
; a tradução de página somaria essa base de novo. Aqui, como este
; arquivo nunca é montado junto com mais nada, o endereço embutido pelo
; montador nunca é físico -- é sempre o deslocamento dentro do próprio
; módulo, que por construção é também o endereço virtual certo. O
; kernel (ver kernel.asm, _kernel_inicio) carrega os bytes resultantes
; (depois de convertidos para binário puro por mob2bin, ver Makefile) num
; setor de disco; em tempo de execução, é lido de lá direto para QUALQUER
; quadro físico livre, via bios_disco_le_setor -- o endereço físico só é
; decidido nesse momento, bem depois deste arquivo já estar montado.
;
; monte sozinho (ver o Makefile deste diretório):
;   montador processoA.asm -o processoA.mob
;   ../../../simulador_completo/bin/mob2bin processoA.mob 512 processoA.bin

        .equ    SYS_ESCREVE = 1

pa_loop:
        ld      r3, 0                       ; endereço VIRTUAL 0 -- o contador mora no
        ld      r4, (r3)                      ; início da página de dados do processo
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
        jmpc    ne, pa_atraso                ; jmpc normal -- não precisa ser "brac"
        jmp     pa_loop                       ; idem, "jmp" normal em vez de "bra"
