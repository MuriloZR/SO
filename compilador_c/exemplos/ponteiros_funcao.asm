; ===== código gerado por mcc =====
.text
_f_soma:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, (bp+6)
	ld r1, r0
	pop r0
	add r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_subtrai:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, (bp+6)
	ld r1, r0
	pop r0
	sub r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_multiplica:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, (bp+6)
	ld r1, r0
	pop r0
	mul r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_ponteiro_simples:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, _f_soma
	st r0, (bp+-2)
	ld r0, 4
	push r0
	ld r0, 3
	push r0
	ld r0, (bp+-2)
	call r0
	add sp, 4
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, _f_subtrai
	st r0, (bp+-2)
	ld r0, 4
	push r0
	ld r0, 10
	push r0
	ld r0, (bp+-2)
	call r0
	add sp, 4
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_tabela_despacho:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_Ldc4f4927_5:
	ld r0, (bp+-2)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc4f4927_8
	ld r0, 0
	jmp _Ldc4f4927_9
_Ldc4f4927_8:
	ld r0, 1
_Ldc4f4927_9:
	cmp r0, 0
	jmpc eq, _Ldc4f4927_7
	ld r0, 2
	push r0
	ld r0, 6
	push r0
	ld r0, _g_tabela_operacoes
	push r0
	ld r0, (bp+-2)
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
	call r0
	add sp, 4
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
_Ldc4f4927_6:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _Ldc4f4927_5
_Ldc4f4927_7:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_aplica:
	push bp
	ld bp, sp
	ld r0, (bp+8)
	push r0
	ld r0, (bp+6)
	push r0
	ld r0, (bp+4)
	call r0
	add sp, 4
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_tabela_comandos:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_Ldc4f4927_15:
	ld r0, (bp+-2)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc4f4927_18
	ld r0, 0
	jmp _Ldc4f4927_19
_Ldc4f4927_18:
	ld r0, 1
_Ldc4f4927_19:
	cmp r0, 0
	jmpc eq, _Ldc4f4927_17
	ld r0, _g_comandos
	push r0
	ld r0, (bp+-2)
	mul r0, 3
	pop r1
	add r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 61
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 3
	push r0
	ld r0, 8
	push r0
	ld r0, _g_comandos
	push r0
	ld r0, (bp+-2)
	mul r0, 3
	pop r1
	add r1, r0
	ld r0, (r1+1)
	call r0
	add sp, 4
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
_Ldc4f4927_16:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _Ldc4f4927_15
_Ldc4f4927_17:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_main:
	push bp
	ld bp, sp
	call _f_ponteiro_simples
	call _f_tabela_despacho
	ld r0, 5
	push r0
	ld r0, 20
	push r0
	ld r0, _f_soma
	push r0
	call _f_aplica
	add sp, 6
	ld r0, 5
	push r0
	ld r0, 20
	push r0
	ld r0, _f_multiplica
	push r0
	call _f_aplica
	add sp, 6
	call _f_tabela_comandos
	ld r0, 0
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret

.data
_g_tabela_operacoes:
	.dw _f_soma
	.dw _f_subtrai
	.dw _f_multiplica
_g_comandos:
	.db 83
	.dw _f_soma
	.db 68
	.dw _f_subtrai
	.db 77
	.dw _f_multiplica

; ----- literais de string -----
