; ===== código gerado por mcc =====
.text
_f_puts_sem_n:
	push bp
	ld bp, sp
_L330a79df_4:
	ld r0, (bp+4)
	ld r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L330a79df_6
	ld r0, 0
	jmp _L330a79df_7
_L330a79df_6:
	ld r0, 1
_L330a79df_7:
	cmp r0, 0
	jmpc eq, _L330a79df_5
	ld r0, (bp+4)
	ld r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+4)
	jmp _L330a79df_4
_L330a79df_5:
	ld sp, bp
	pop bp
	ret
_f_set_clock_max_main:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, 8
	ld r1, r0
	pop r0
	shr r0, r1
	push r0
	ld r0, 34
	push r0
	call _f_mancha_out
	add sp, 4
	ld r0, (bp+4)
	push r0
	ld r0, 35
	push r0
	call _f_mancha_out
	add sp, 4
	ld sp, bp
	pop bp
	ret
_f_retorna_clock_atual_main:
	push bp
	ld bp, sp
	ld r0, 32
	push r0
	call _f_mancha_in
	add sp, 2
	push r0
	ld r0, 8
	ld r1, r0
	pop r0
	shl r0, r1
	push r0
	ld r0, 33
	push r0
	call _f_mancha_in
	add sp, 2
	ld r1, r0
	pop r0
	or r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_retorna_time:
	push bp
	ld bp, sp
	ld r0, 36
	push r0
	call _f_mancha_in
	add sp, 2
	push r0
	ld r0, 8
	ld r1, r0
	pop r0
	shl r0, r1
	push r0
	ld r0, 37
	push r0
	call _f_mancha_in
	add sp, 2
	ld r1, r0
	pop r0
	or r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_srand:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	st r0, (_g_next)
	ld sp, bp
	pop bp
	ret
_f_rand:
	push bp
	ld bp, sp
	ld r0, (_g_next)
	push r0
	ld r0, 25173
	ld r1, r0
	pop r0
	mul r0, r1
	push r0
	ld r0, 13849
	ld r1, r0
	pop r0
	add r0, r1
	push r0
	ld r0, 32767
	ld r1, r0
	pop r0
	and r0, r1
	st r0, (_g_next)
	ld r0, (_g_next)
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_main:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 32767
	push r0
	call _f_set_clock_max_main
	add sp, 2
	call _f_retorna_time
	push r0
	call _f_srand
	add sp, 2
	ld r0, 0
	st r0, (bp+-2)
_L330a79df_13:
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L330a79df_16
	ld r0, 0
	jmp _L330a79df_17
_L330a79df_16:
	ld r0, 1
_L330a79df_17:
	cmp r0, 0
	jmpc eq, _L330a79df_15
	ld r0, _str330a79df_1
	push r0
	call _f_puts_sem_n
	add sp, 2
	call _f_rand
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
_L330a79df_14:
	ld r0, (bp+-2)
	push r0
	add r0, 1
	st r0, (bp+-2)
	pop r0
	jmp _L330a79df_13
_L330a79df_15:
	ld r0, 0
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret

.data
_g_next:
	.dw 1

; ----- literais de string -----
_str330a79df_0:
	.db 114, 97, 110, 100, 58, 32, 0
_str330a79df_1:
	.db 114, 97, 110, 100, 58, 32, 0
