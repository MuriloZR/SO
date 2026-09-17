; ===== código gerado por mcc =====
.text
_f_retorna_clock_atual:
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
_f_retorna_clock_max:
	push bp
	ld bp, sp
	ld r0, 34
	push r0
	call _f_mancha_in
	add sp, 2
	push r0
	ld r0, 8
	ld r1, r0
	pop r0
	shl r0, r1
	push r0
	ld r0, 35
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
_f_set_clock_max:
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
_f_putchar:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, 1
	push r0
	call _f_mancha_out
	add sp, 4
	ld r0, (bp+4)
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_getchar:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 2
	push r0
	call _f_mancha_in
	add sp, 2
	st r0, (bp+-2)
_L3d8278c9_4:
	ld r0, (bp+-2)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	and r0, r1
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc eq, _L3d8278c9_6
	ld r0, 0
	jmp _L3d8278c9_7
_L3d8278c9_6:
	ld r0, 1
_L3d8278c9_7:
	cmp r0, 0
	jmpc eq, _L3d8278c9_5
	ld r0, 2
	push r0
	call _f_mancha_in
	add sp, 2
	st r0, (bp+-2)
	jmp _L3d8278c9_4
_L3d8278c9_5:
	ld r0, 1
	push r0
	call _f_mancha_in
	add sp, 2
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_puts:
	push bp
	ld bp, sp
_L3d8278c9_12:
	ld r0, (bp+4)
	ld r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L3d8278c9_14
	ld r0, 0
	jmp _L3d8278c9_15
_L3d8278c9_14:
	ld r0, 1
_L3d8278c9_15:
	cmp r0, 0
	jmpc eq, _L3d8278c9_13
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
	jmp _L3d8278c9_12
_L3d8278c9_13:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret
_f_print_int:
	push bp
	ld bp, sp
	sub sp, 12
	ld r0, 0
	st r0, (bp+-10)
	ld r0, 0
	st r0, (bp+-12)
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d8278c9_31
	ld r0, 0
	jmp _L3d8278c9_32
_L3d8278c9_31:
	ld r0, 1
_L3d8278c9_32:
	cmp r0, 0
	jmpc eq, _L3d8278c9_33
	ld r0, 1
	st r0, (bp+-12)
	ld r0, (bp+4)
	xor r0, -1
	add r0, 1
	st r0, (bp+4)
_L3d8278c9_33:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc eq, _L3d8278c9_34
	ld r0, 0
	jmp _L3d8278c9_35
_L3d8278c9_34:
	ld r0, 1
_L3d8278c9_35:
	cmp r0, 0
	jmpc eq, _L3d8278c9_36
	ld r0, bp
	add r0, -8
	push r0
	ld r0, 0
	mul r0, 1
	pop r1
	add r1, r0
	push r1
	ld r0, 48
	pop r1
	stb r0, (r1)
	ld r0, 1
	st r0, (bp+-10)
_L3d8278c9_36:
_L3d8278c9_37:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L3d8278c9_39
	ld r0, 0
	jmp _L3d8278c9_40
_L3d8278c9_39:
	ld r0, 1
_L3d8278c9_40:
	cmp r0, 0
	jmpc eq, _L3d8278c9_38
	ld r0, bp
	add r0, -8
	push r0
	ld r0, (bp+-10)
	mul r0, 1
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+4)
	push r0
	ld r0, 10
	ld r1, r0
	pop r0
	ld r2, r0
	div r0, r1
	mul r0, r1
	sub r2, r0
	ld r0, r2
	push r0
	ld r0, 48
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	stb r0, (r1)
	ld r0, (bp+-10)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-10)
	ld r0, (bp+4)
	push r0
	ld r0, 10
	ld r1, r0
	pop r0
	div r0, r1
	st r0, (bp+4)
	jmp _L3d8278c9_37
_L3d8278c9_38:
	ld r0, (bp+-12)
	cmp r0, 0
	jmpc eq, _L3d8278c9_41
	ld r0, 45
	push r0
	call _f_putchar
	add sp, 2
_L3d8278c9_41:
_L3d8278c9_42:
	ld r0, (bp+-10)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L3d8278c9_44
	ld r0, 0
	jmp _L3d8278c9_45
_L3d8278c9_44:
	ld r0, 1
_L3d8278c9_45:
	cmp r0, 0
	jmpc eq, _L3d8278c9_43
	ld r0, (bp+-10)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	sub r0, r1
	st r0, (bp+-10)
	ld r0, bp
	add r0, -8
	push r0
	ld r0, (bp+-10)
	mul r0, 1
	pop r1
	add r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	call _f_putchar
	add sp, 2
	jmp _L3d8278c9_42
_L3d8278c9_43:
	ld sp, bp
	pop bp
	ret
_f_print_hex:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, _str3d8278c9_1
	st r0, (bp+-2)
	ld r0, 12
	st r0, (bp+-4)
_L3d8278c9_50:
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ge, _L3d8278c9_52
	ld r0, 0
	jmp _L3d8278c9_53
_L3d8278c9_52:
	ld r0, 1
_L3d8278c9_53:
	cmp r0, 0
	jmpc eq, _L3d8278c9_51
	ld r0, (bp+4)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	shr r0, r1
	push r0
	ld r0, 15
	ld r1, r0
	pop r0
	and r0, r1
	st r0, (bp+-6)
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-6)
	mul r0, 1
	pop r1
	add r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-4)
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	sub r0, r1
	st r0, (bp+-4)
	jmp _L3d8278c9_50
_L3d8278c9_51:
	ld sp, bp
	pop bp
	ret

.data

; ----- literais de string -----
_str3d8278c9_0:
	.db 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 0
_str3d8278c9_1:
	.db 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 0
