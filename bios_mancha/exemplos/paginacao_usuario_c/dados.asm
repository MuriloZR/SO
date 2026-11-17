; dados.asm -- as duas tabelas de páginas e as duas páginas de dados dos
; processos. Deliberadamente um arquivo SEPARADO, montado por ÚLTIMO
; (depois de kernel.asm -- ver o Makefile e o comentário no fim de
; ponte.asm): o montador trata vários .asm passados numa só chamada
; como um módulo só, com um único contador de endereço que CONTINUA de
; um arquivo para o outro, na ordem dada na linha de comando. Só
; estando DEPOIS de kernel.asm é que o ".org" abaixo tem garantia de
; estar depois do fim de TUDO (bios.asm + ponte.asm + kernel.c
; compilado) -- colocar isso ANTES de kernel.asm foi exatamente o bug
; real encontrado ao escrever este exemplo (ver o comentário em
; ponte.asm).
;
; 0x4000 foi escolhido com bastante folga acima de N_PAGINAS_IDENTIDADE
; (32 páginas = até 0x3FFF, ver ponte.asm) -- não precisa ser exato,
; só confortavelmente maior que o fim real do código.

; as duas tabelas de páginas (256 entradas de 2 bytes = 512 bytes cada)
; -- NÃO precisam de alinhamento especial: "pt" é um endereço físico
; comum, nunca alcançado por tradução de página ele mesmo.
tabela_pt_a:    .ds 256
tabela_pt_b:    .ds 256

; as duas páginas de dados -- aqui sim, alinhamento de 512 bytes é
; obrigatório (são alcançadas por NÚMERO DE QUADRO, através da entrada
; de dados da tabela de páginas).
        .org    0x4000
dados_a:        .ds 256
        .org    0x4200
dados_b:        .ds 256
