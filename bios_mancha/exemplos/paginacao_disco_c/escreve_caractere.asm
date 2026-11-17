; escreve_caractere.asm -- implementação, em assembly, da ponte entre a
; convenção de chamada do mcc e a da BIOS (ver
; ../../../compilador_c/README.md, "convenção de chamada") para
; "escreve_caractere" -- faz "trap 7" por dentro (não "outb" direto),
; já que os processos rodam em modo usuário de verdade (I=0). Idêntica,
; na lógica, a ../paginacao_usuario_c/ponte.asm, só que montada JUNTO
; com cada processo compilado (processoA.asm/processoB.asm), em vez de
; junto com o kernel -- este exemplo monta cada processo sozinho, sem
; ligador, então qualquer função que ele chama precisa estar no MESMO
; módulo (ver o Makefile e o comentário em processoA.c).
;
; void escreve_caractere(int c);  -- 1 argumento, convenção do mcc: fica
; em (bp+4).
_f_escreve_caractere:
        push    bp
        ld      bp, sp
        ld      r1, (bp+4)
        ld      r0, 1                        ; SYS_ESCREVE (ver kernel.c/ponte.asm)
        trap    7
        ld      sp, bp
        pop     bp
        ret
