; ===== código gerado por mcc =====
.text
_f_processoA:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, 0
	st r0, (bp+-2)
_Ldc594927_7:
	ld r0, (bp+-2)
	ld r1, r0
	push r1
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1)
	ld r0, 65
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 58
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1)
	push r0
	ld r0, 10
	ld r1, r0
	pop r0
	ld r2, r0
	div r0, r1
	mul r0, r1
	sub r2, r0
	ld r0, r2
	st r0, (bp+-4)
	ld r0, (bp+-4)
	push r0
	ld r0, 48
	ld r1, r0
	pop r0
	add r0, r1
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 32
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 0
	st r0, (bp+-6)
_Ldc594927_10:
	ld r0, (bp+-6)
	push r0
	ld r0, 3000
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc594927_12
	ld r0, 0
	jmp _Ldc594927_13
_Ldc594927_12:
	ld r0, 1
_Ldc594927_13:
	cmp r0, 0
	jmpc eq, _Ldc594927_11
	ld r0, (bp+-6)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-6)
	jmp _Ldc594927_10
_Ldc594927_11:
_Ldc594927_8:
	jmp _Ldc594927_7
_Ldc594927_9:
	ld sp, bp
	pop bp
	ret
_f_processoB:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, 0
	st r0, (bp+-2)
_Ldc594927_21:
	ld r0, (bp+-2)
	ld r1, r0
	push r1
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1)
	ld r0, 66
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 58
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, (bp+-2)
	ld r1, r0
	ld r0, (r1)
	push r0
	ld r0, 10
	ld r1, r0
	pop r0
	ld r2, r0
	div r0, r1
	mul r0, r1
	sub r2, r0
	ld r0, r2
	st r0, (bp+-4)
	ld r0, (bp+-4)
	push r0
	ld r0, 48
	ld r1, r0
	pop r0
	add r0, r1
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 32
	push r0
	call _f_escreve_caractere
	add sp, 2
	ld r0, 0
	st r0, (bp+-6)
_Ldc594927_24:
	ld r0, (bp+-6)
	push r0
	ld r0, 3000
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc594927_26
	ld r0, 0
	jmp _Ldc594927_27
_Ldc594927_26:
	ld r0, 1
_Ldc594927_27:
	cmp r0, 0
	jmpc eq, _Ldc594927_25
	ld r0, (bp+-6)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-6)
	jmp _Ldc594927_24
_Ldc594927_25:
_Ldc594927_22:
	jmp _Ldc594927_21
_Ldc594927_23:
	ld sp, bp
	pop bp
	ret
_f_monta_quadro:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, (bp+4)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	mul r0, r1
	st r0, (bp+-2)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 6
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, 512
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 7
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+10)
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 8
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, 16384
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 12
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+6)
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 13
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, 0
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 14
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, 0
	pop r1
	st r0, (r1)
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	push r0
	ld r0, 15
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, 0
	pop r1
	st r0, (r1)
	ld r0, (bp+8)
	push r0
	ld r0, 9
	ld r1, r0
	pop r0
	shr r0, r1
	st r0, (bp+-4)
	ld r0, (bp+6)
	push r0
	ld r0, 128
	mul r0, 2
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-6)
	ld r0, (bp+-6)
	ld r1, r0
	push r1
	ld r0, 57344
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	or r0, r1
	pop r1
	st r0, (r1)
	ld sp, bp
	pop bp
	ret
_f_inicializa_processos:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, _f_processoA
	push r0
	ld r0, (bp+8)
	push r0
	ld r0, (bp+6)
	push r0
	ld r0, 0
	push r0
	call _f_monta_quadro
	add sp, 8
	ld r0, _f_processoB
	push r0
	ld r0, (bp+12)
	push r0
	ld r0, (bp+10)
	push r0
	ld r0, 1
	push r0
	call _f_monta_quadro
	add sp, 8
	ld r0, 0
	st r0, (_g_processo_atual)
	ld r0, 0
	st r0, (bp+-2)
_Ldc594927_33:
	ld r0, (bp+-2)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc594927_36
	ld r0, 0
	jmp _Ldc594927_37
_Ldc594927_36:
	ld r0, 1
_Ldc594927_37:
	cmp r0, 0
	jmpc eq, _Ldc594927_35
	ld r0, (bp+4)
	push r0
	ld r0, (bp+-2)
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, _g_processos
	push r0
	ld r0, (bp+-2)
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
	pop r1
	st r0, (r1)
_Ldc594927_34:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _Ldc594927_33
_Ldc594927_35:
	ld sp, bp
	pop bp
	ret
_f_escalonador:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, (bp+8)
	ld r1, r0
	ld r0, (r1)
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	mul r0, r1
	st r0, (bp+-6)
	ld r0, 0
	st r0, (bp+-4)
_Ldc594927_49:
	ld r0, (bp+-4)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc594927_51
	ld r0, 0
	jmp _Ldc594927_52
_Ldc594927_51:
	ld r0, 1
_Ldc594927_52:
	cmp r0, 0
	jmpc eq, _Ldc594927_50
	ld r0, (bp+6)
	push r0
	ld r0, (bp+-6)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+4)
	push r0
	ld r0, (bp+-4)
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
	pop r1
	st r0, (r1)
	ld r0, (bp+-4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-4)
	jmp _Ldc594927_49
_Ldc594927_50:
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ge, _Ldc594927_53
	ld r0, 0
	jmp _Ldc594927_54
_Ldc594927_53:
	ld r0, 1
_Ldc594927_54:
	cmp r0, 0
	jmpc eq, _Ldc594927_55
	ld r0, 0
	st r0, (bp+-2)
_Ldc594927_55:
	ld r0, (bp+8)
	ld r1, r0
	push r1
	ld r0, (bp+-2)
	pop r1
	st r0, (r1)
	ld r0, (bp+-2)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	mul r0, r1
	st r0, (bp+-6)
	ld r0, 0
	st r0, (bp+-4)
_Ldc594927_56:
	ld r0, (bp+-4)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc594927_58
	ld r0, 0
	jmp _Ldc594927_59
_Ldc594927_58:
	ld r0, 1
_Ldc594927_59:
	cmp r0, 0
	jmpc eq, _Ldc594927_57
	ld r0, (bp+4)
	push r0
	ld r0, (bp+-4)
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+6)
	push r0
	ld r0, (bp+-6)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	add r0, r1
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
	pop r1
	st r0, (r1)
	ld r0, (bp+-4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-4)
	jmp _Ldc594927_56
_Ldc594927_57:
	ld sp, bp
	pop bp
	ret

.data
_g_processos:
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
_g_processo_atual:
	.db 0
	.db 0

; ----- literais de string -----
