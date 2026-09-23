; ===== código gerado por mcc =====
.text
_f_aloca:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, _g_pool
	push r0
	ld r0, (_g_usados)
	mul r0, 4
	pop r1
	add r1, r0
	ld r0, r1
	st r0, (bp+-2)
	ld r0, (_g_usados)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (_g_usados)
	ld r0, (bp+-2)
	ld r1, r0
	push r1
	ld r0, (bp+4)
	pop r1
	st r0, (r1)
	ld r0, (bp+-2)
	ld r1, r0
	push r1
	ld r0, 0
	pop r1
	st r0, (r1+2)
	ld r0, (bp+-2)
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_insere:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, (bp+6)
	push r0
	call _f_aloca
	add sp, 2
	st r0, (bp+-2)
	ld r0, (bp+-2)
	ld r1, r0
	push r1
	ld r0, (bp+4)
	pop r1
	st r0, (r1+2)
	ld r0, (bp+-2)
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_imprime:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, (bp+4)
	st r0, (bp+-2)
_L5c3c2334_7:
	ld r0, (bp+-2)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L5c3c2334_9
	ld r0, 0
	jmp _L5c3c2334_10
_L5c3c2334_9:
	ld r0, 1
_L5c3c2334_10:
	cmp r0, 0
	jmpc eq, _L5c3c2334_8
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1+2)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L5c3c2334_11
	ld r0, 0
	jmp _L5c3c2334_12
_L5c3c2334_11:
	ld r0, 1
_L5c3c2334_12:
	cmp r0, 0
	jmpc eq, _L5c3c2334_13
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
_L5c3c2334_13:
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1+2)
	st r0, (bp+-2)
	jmp _L5c3c2334_7
_L5c3c2334_8:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_soma:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_L5c3c2334_18:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L5c3c2334_20
	ld r0, 0
	jmp _L5c3c2334_21
_L5c3c2334_20:
	ld r0, 1
_L5c3c2334_21:
	cmp r0, 0
	jmpc eq, _L5c3c2334_19
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1)
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1+2)
	st r0, (bp+4)
	jmp _L5c3c2334_18
_L5c3c2334_19:
	ld r0, (bp+-2)
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_main:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, 0
	st r0, (_g_usados)
	ld r0, 0
	st r0, (bp+-2)
	ld r0, 3
	push r0
	ld r0, (bp+-2)
	push r0
	call _f_insere
	add sp, 4
	st r0, (bp+-2)
	ld r0, 2
	push r0
	ld r0, (bp+-2)
	push r0
	call _f_insere
	add sp, 4
	st r0, (bp+-2)
	ld r0, 1
	push r0
	ld r0, (bp+-2)
	push r0
	call _f_insere
	add sp, 4
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_imprime
	add sp, 2
	ld r0, (bp+-2)
	push r0
	call _f_soma
	add sp, 2
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	st r0, (bp+-4)
_L5c3c2334_42:
	ld r0, (bp+-4)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c3c2334_45
	ld r0, 0
	jmp _L5c3c2334_46
_L5c3c2334_45:
	ld r0, 1
_L5c3c2334_46:
	cmp r0, 0
	jmpc eq, _L5c3c2334_44
	ld r0, 0
	st r0, (bp+-6)
_L5c3c2334_47:
	ld r0, (bp+-6)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c3c2334_50
	ld r0, 0
	jmp _L5c3c2334_51
_L5c3c2334_50:
	ld r0, 1
_L5c3c2334_51:
	cmp r0, 0
	jmpc eq, _L5c3c2334_49
	ld r0, _g_matriz
	push r0
	ld r0, (bp+-4)
	mul r0, 8
	pop r1
	add r1, r0
	ld r0, r1
	push r0
	ld r0, (bp+-6)
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+-4)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	mul r0, r1
	push r0
	ld r0, (bp+-6)
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1)
_L5c3c2334_48:
	ld r0, (bp+-6)
	push r0
	add r0, 1
	st r0, (bp+-6)
	pop r0
	jmp _L5c3c2334_47
_L5c3c2334_49:
_L5c3c2334_43:
	ld r0, (bp+-4)
	push r0
	add r0, 1
	st r0, (bp+-4)
	pop r0
	jmp _L5c3c2334_42
_L5c3c2334_44:
	ld r0, 0
	st r0, (bp+-4)
_L5c3c2334_52:
	ld r0, (bp+-4)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c3c2334_55
	ld r0, 0
	jmp _L5c3c2334_56
_L5c3c2334_55:
	ld r0, 1
_L5c3c2334_56:
	cmp r0, 0
	jmpc eq, _L5c3c2334_54
	ld r0, 0
	st r0, (bp+-6)
_L5c3c2334_57:
	ld r0, (bp+-6)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c3c2334_60
	ld r0, 0
	jmp _L5c3c2334_61
_L5c3c2334_60:
	ld r0, 1
_L5c3c2334_61:
	cmp r0, 0
	jmpc eq, _L5c3c2334_59
	ld r0, _g_matriz
	push r0
	ld r0, (bp+-4)
	mul r0, 8
	pop r1
	add r1, r0
	ld r0, r1
	push r0
	ld r0, (bp+-6)
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
_L5c3c2334_58:
	ld r0, (bp+-6)
	push r0
	add r0, 1
	st r0, (bp+-6)
	pop r0
	jmp _L5c3c2334_57
_L5c3c2334_59:
_L5c3c2334_53:
	ld r0, (bp+-4)
	push r0
	add r0, 1
	st r0, (bp+-4)
	pop r0
	jmp _L5c3c2334_52
_L5c3c2334_54:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret

.data
_g_pool:
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
_g_usados:
	.db 0
	.db 0
_g_matriz:
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0
	.db 0

; ----- literais de string -----
