; ===== código gerado por mcc =====
.text
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
_Ldc424927_4:
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
	jmpc eq, _Ldc424927_6
	ld r0, 0
	jmp _Ldc424927_7
_Ldc424927_6:
	ld r0, 1
_Ldc424927_7:
	cmp r0, 0
	jmpc eq, _Ldc424927_5
	ld r0, 2
	push r0
	call _f_mancha_in
	add sp, 2
	st r0, (bp+-2)
	jmp _Ldc424927_4
_Ldc424927_5:
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
_Ldc424927_12:
	ld r0, (bp+4)
	ld r1, r0
	ldb r0, (r1)
	and r0, 255
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _Ldc424927_14
	ld r0, 0
	jmp _Ldc424927_15
_Ldc424927_14:
	ld r0, 1
_Ldc424927_15:
	cmp r0, 0
	jmpc eq, _Ldc424927_13
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
	jmp _Ldc424927_12
_Ldc424927_13:
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
	jmpc lt, _Ldc424927_31
	ld r0, 0
	jmp _Ldc424927_32
_Ldc424927_31:
	ld r0, 1
_Ldc424927_32:
	cmp r0, 0
	jmpc eq, _Ldc424927_33
	ld r0, 1
	st r0, (bp+-12)
	ld r0, (bp+4)
	xor r0, -1
	add r0, 1
	st r0, (bp+4)
_Ldc424927_33:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc eq, _Ldc424927_34
	ld r0, 0
	jmp _Ldc424927_35
_Ldc424927_34:
	ld r0, 1
_Ldc424927_35:
	cmp r0, 0
	jmpc eq, _Ldc424927_36
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
_Ldc424927_36:
_Ldc424927_37:
	ld r0, (bp+4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _Ldc424927_39
	ld r0, 0
	jmp _Ldc424927_40
_Ldc424927_39:
	ld r0, 1
_Ldc424927_40:
	cmp r0, 0
	jmpc eq, _Ldc424927_38
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
	jmp _Ldc424927_37
_Ldc424927_38:
	ld r0, (bp+-12)
	cmp r0, 0
	jmpc eq, _Ldc424927_41
	ld r0, 45
	push r0
	call _f_putchar
	add sp, 2
_Ldc424927_41:
_Ldc424927_42:
	ld r0, (bp+-10)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _Ldc424927_44
	ld r0, 0
	jmp _Ldc424927_45
_Ldc424927_44:
	ld r0, 1
_Ldc424927_45:
	cmp r0, 0
	jmpc eq, _Ldc424927_43
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
	jmp _Ldc424927_42
_Ldc424927_43:
	ld sp, bp
	pop bp
	ret
_f_print_hex:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, _strdc424927_1
	st r0, (bp+-2)
	ld r0, 12
	st r0, (bp+-4)
_Ldc424927_50:
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ge, _Ldc424927_52
	ld r0, 0
	jmp _Ldc424927_53
_Ldc424927_52:
	ld r0, 1
_Ldc424927_53:
	cmp r0, 0
	jmpc eq, _Ldc424927_51
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
	jmp _Ldc424927_50
_Ldc424927_51:
	ld sp, bp
	pop bp
	ret

.data

; ----- literais de string -----
_strdc424927_0:
	.db 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 0
_strdc424927_1:
	.db 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 0
