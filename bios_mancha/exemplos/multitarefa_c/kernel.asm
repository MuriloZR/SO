; ===== código gerado por mcc =====
.text
_f_atraso:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_L5c2c2334_4:
	ld r0, (bp+-2)
	push r0
	ld r0, 600
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c2c2334_6
	ld r0, 0
	jmp _L5c2c2334_7
_L5c2c2334_6:
	ld r0, 1
_L5c2c2334_7:
	cmp r0, 0
	jmpc eq, _L5c2c2334_5
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	jmp _L5c2c2334_4
_L5c2c2334_5:
	ld sp, bp
	pop bp
	ret
_f_processoA:
	push bp
	ld bp, sp
_L5c2c2334_11:
	ld r0, 65
	push r0
	call _f_escreve_caractere
	add sp, 2
	call _f_atraso
_L5c2c2334_12:
	jmp _L5c2c2334_11
_L5c2c2334_13:
	ld sp, bp
	pop bp
	ret
_f_processoB:
	push bp
	ld bp, sp
_L5c2c2334_17:
	ld r0, 66
	push r0
	call _f_escreve_caractere
	add sp, 2
	call _f_atraso
_L5c2c2334_18:
	jmp _L5c2c2334_17
_L5c2c2334_19:
	ld sp, bp
	pop bp
	ret
_f_processoC:
	push bp
	ld bp, sp
_L5c2c2334_23:
	ld r0, 67
	push r0
	call _f_escreve_caractere
	add sp, 2
	call _f_atraso
_L5c2c2334_24:
	jmp _L5c2c2334_23
_L5c2c2334_25:
	ld sp, bp
	pop bp
	ret
_f_monta_quadro_inicial:
	push bp
	ld bp, sp
	sub sp, 2
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
	ld r0, _g_pilhas
	push r0
	ld r0, (bp+4)
	mul r0, 64
	pop r1
	add r1, r0
	ld r0, r1
	push r0
	ld r0, 32
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, r1
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
	ld r0, _g_pontos_entrada
	push r0
	ld r0, (bp+4)
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, (r1)
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
	ld r0, 40960
	pop r1
	st r0, (r1)
	ld sp, bp
	pop bp
	ret
_f_inicializa_processos:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_L5c2c2334_36:
	ld r0, (bp+-2)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c2c2334_39
	ld r0, 0
	jmp _L5c2c2334_40
_L5c2c2334_39:
	ld r0, 1
_L5c2c2334_40:
	cmp r0, 0
	jmpc eq, _L5c2c2334_38
	ld r0, (bp+-2)
	push r0
	call _f_monta_quadro_inicial
	add sp, 2
_L5c2c2334_37:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _L5c2c2334_36
_L5c2c2334_38:
	ld r0, 0
	st r0, (_g_processo_atual)
	ld r0, 0
	st r0, (bp+-2)
_L5c2c2334_41:
	ld r0, (bp+-2)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c2c2334_44
	ld r0, 0
	jmp _L5c2c2334_45
_L5c2c2334_44:
	ld r0, 1
_L5c2c2334_45:
	cmp r0, 0
	jmpc eq, _L5c2c2334_43
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
_L5c2c2334_42:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _L5c2c2334_41
_L5c2c2334_43:
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
_L5c2c2334_57:
	ld r0, (bp+-4)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c2c2334_59
	ld r0, 0
	jmp _L5c2c2334_60
_L5c2c2334_59:
	ld r0, 1
_L5c2c2334_60:
	cmp r0, 0
	jmpc eq, _L5c2c2334_58
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
	jmp _L5c2c2334_57
_L5c2c2334_58:
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ge, _L5c2c2334_61
	ld r0, 0
	jmp _L5c2c2334_62
_L5c2c2334_61:
	ld r0, 1
_L5c2c2334_62:
	cmp r0, 0
	jmpc eq, _L5c2c2334_63
	ld r0, 0
	st r0, (bp+-2)
_L5c2c2334_63:
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
_L5c2c2334_64:
	ld r0, (bp+-4)
	push r0
	ld r0, 16
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c2c2334_66
	ld r0, 0
	jmp _L5c2c2334_67
_L5c2c2334_66:
	ld r0, 1
_L5c2c2334_67:
	cmp r0, 0
	jmpc eq, _L5c2c2334_65
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
	jmp _L5c2c2334_64
_L5c2c2334_65:
	ld sp, bp
	pop bp
	ret

.data
_g_pontos_entrada:
	.dw _f_processoA
	.dw _f_processoB
	.dw _f_processoC
_g_pilhas:
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
