; processoB.asm -- o mesmo que processoA.asm, trocando só a letra
; impressa. Ver os comentários lá (e ../../README.md) para o motivo de
; usar "jmp"/"jmpc" normais aqui, em vez de "bra"/"brac".

        .equ    SYS_ESCREVE = 1

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
        jmpc    ne, pb_atraso
        jmp     pb_loop
