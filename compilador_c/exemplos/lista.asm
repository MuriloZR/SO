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
_Ldc454927_7:
	ld r0, (bp+-2)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _Ldc454927_9
	ld r0, 0
	jmp _Ldc454927_10
_Ldc454927_9:
	ld r0, 1
_Ldc454927_10:
	cmp r0, 0
	jmpc eq, _Ldc454927_8
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
	jmpc ne, _Ldc454927_11
	ld r0, 0
	jmp _Ldc454927_12
_Ldc454927_11:
	ld r0, 1
_Ldc454927_12:
	cmp r0, 0
	jmpc eq, _Ldc454927_13
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
_Ldc454927_13:
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1+2)
	st r0, (bp+-2)
	jmp _Ldc454927_7
_Ldc454927_8:
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
_Ldc454927_18:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _Ldc454927_20
	ld r0, 0
	jmp _Ldc454927_21
_Ldc454927_20:
	ld r0, 1
_Ldc454927_21:
	cmp r0, 0
	jmpc eq, _Ldc454927_19
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
	jmp _Ldc454927_18
_Ldc454927_19:
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
_Ldc454927_42:
	ld r0, (bp+-4)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc454927_45
	ld r0, 0
	jmp _Ldc454927_46
_Ldc454927_45:
	ld r0, 1
_Ldc454927_46:
	cmp r0, 0
	jmpc eq, _Ldc454927_44
	ld r0, 0
	st r0, (bp+-6)
_Ldc454927_47:
	ld r0, (bp+-6)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc454927_50
	ld r0, 0
	jmp _Ldc454927_51
_Ldc454927_50:
	ld r0, 1
_Ldc454927_51:
	cmp r0, 0
	jmpc eq, _Ldc454927_49
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
_Ldc454927_48:
	ld r0, (bp+-6)
	push r0
	add r0, 1
	st r0, (bp+-6)
	pop r0
	jmp _Ldc454927_47
_Ldc454927_49:
_Ldc454927_43:
	ld r0, (bp+-4)
	push r0
	add r0, 1
	st r0, (bp+-4)
	pop r0
	jmp _Ldc454927_42
_Ldc454927_44:
	ld r0, 0
	st r0, (bp+-4)
_Ldc454927_52:
	ld r0, (bp+-4)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc454927_55
	ld r0, 0
	jmp _Ldc454927_56
_Ldc454927_55:
	ld r0, 1
_Ldc454927_56:
	cmp r0, 0
	jmpc eq, _Ldc454927_54
	ld r0, 0
	st r0, (bp+-6)
_Ldc454927_57:
	ld r0, (bp+-6)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc454927_60
	ld r0, 0
	jmp _Ldc454927_61
_Ldc454927_60:
	ld r0, 1
_Ldc454927_61:
	cmp r0, 0
	jmpc eq, _Ldc454927_59
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
_Ldc454927_58:
	ld r0, (bp+-6)
	push r0
	add r0, 1
	st r0, (bp+-6)
	pop r0
	jmp _Ldc454927_57
_Ldc454927_59:
_Ldc454927_53:
	ld r0, (bp+-4)
	push r0
	add r0, 1
	st r0, (bp+-4)
	pop r0
	jmp _Ldc454927_52
_Ldc454927_54:
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
