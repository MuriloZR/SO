; ===== código gerado por mcc =====
.text
_f_area:
	push bp
	ld bp, sp
	sub sp, 4
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1+4)
	push r0
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1)
	ld r1, r0
	pop r0
	sub r0, r1
	st r0, (bp+-2)
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1+6)
	push r0
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1+2)
	ld r1, r0
	pop r0
	sub r0, r1
	st r0, (bp+-4)
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	mul r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_desloca:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	ld r1, r0
	push r1
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1)
	push r0
	ld r0, (bp+6)
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1)
	ld r0, (bp+4)
	ld r1, r0
	push r1
	ld r0, (bp+4)
	ld r1, r0
	ld r0, (r1+2)
	push r0
	ld r0, (bp+8)
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1+2)
	ld sp, bp
	pop bp
	ret
_f_main:
	push bp
	ld bp, sp
	sub sp, 14
	ld r0, 1
	st r0, (bp+-8)
	ld r0, 1
	st r0, (bp+-6)
	ld r0, 5
	st r0, (bp+-4)
	ld r0, 4
	st r0, (bp+-2)
	ld r0, bp
	add r0, -8
	push r0
	call _f_area
	add sp, 2
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	st r0, (bp+-12)
	ld r0, 0
	st r0, (bp+-10)
	ld r0, 3
	xor r0, -1
	add r0, 1
	push r0
	ld r0, 10
	push r0
	ld r0, bp
	add r0, -12
	push r0
	call _f_desloca
	add sp, 6
	ld r0, (bp+-12)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 44
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-10)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	st r0, (bp+-14)
_L3d9778c9_8:
	ld r0, (bp+-14)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9778c9_10
	ld r0, 0
	jmp _L3d9778c9_11
_L3d9778c9_10:
	ld r0, 1
_L3d9778c9_11:
	cmp r0, 0
	jmpc eq, _L3d9778c9_9
	ld r0, _g_vetores
	push r0
	ld r0, (bp+-14)
	mul r0, 4
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+-14)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	mul r0, r1
	pop r1
	st r0, (r1)
	ld r0, _g_vetores
	push r0
	ld r0, (bp+-14)
	mul r0, 4
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+-14)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	mul r0, r1
	pop r1
	st r0, (r1+2)
	ld r0, (bp+-14)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-14)
	jmp _L3d9778c9_8
_L3d9778c9_9:
	ld r0, 0
	st r0, (bp+-14)
_L3d9778c9_12:
	ld r0, (bp+-14)
	push r0
	ld r0, 3
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9778c9_14
	ld r0, 0
	jmp _L3d9778c9_15
_L3d9778c9_14:
	ld r0, 1
_L3d9778c9_15:
	cmp r0, 0
	jmpc eq, _L3d9778c9_13
	ld r0, _g_vetores
	push r0
	ld r0, (bp+-14)
	mul r0, 4
	pop r1
	add r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 47
	push r0
	call _f_putchar
	add sp, 2
	ld r0, _g_vetores
	push r0
	ld r0, (bp+-14)
	mul r0, 4
	pop r1
	add r1, r0
	ld r0, (r1+2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-14)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-14)
	jmp _L3d9778c9_12
_L3d9778c9_13:
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
_g_vetores:
	.db 0
	.db 0
	.db 0
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
