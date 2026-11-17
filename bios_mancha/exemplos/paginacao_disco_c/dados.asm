; dados.asm -- as duas tabelas de página (já totalmente preenchidas aqui
; mesmo, em tempo de montagem -- nem a entrada de CÓDIGO nem a de DADOS
; precisam ser escritas em tempo de execução, diferente de
; ../paginacao_usuario_c/dados.asm: não há mapeamento por identidade nem
; área de dados "genérica" neste exemplo, cada processo sempre usa os
; MESMOS quadros físicos fixos), os quadros de código de cada processo
; (reservados, sem conteúdo -- carregados do disco em tempo de execução
; por _kernel_inicio, em ponte.asm) e as páginas de dados.
;
; MONTADO POR ÚLTIMO (depois de kernel.asm), pelo mesmo motivo de
; ../paginacao_usuario_c/dados.asm: o montador trata vários .asm
; passados numa só chamada como um módulo só, com um único contador de
; endereço que CONTINUA de um arquivo para o outro -- só estando DEPOIS
; de kernel.asm é que o ".org" abaixo tem garantia de estar depois do
; fim de tudo (bios.asm + ponte.asm + kernel.c compilado).
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
; só reservados (.ds, que não gera nenhum byte). _kernel_inicio, em
; ponte.asm, os preenche em tempo de execução, lendo o disco (ver
; disco.img, montado pelo Makefile a partir de processoA.bin/
; processoB.bin).
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
