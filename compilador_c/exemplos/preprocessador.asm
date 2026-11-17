; ===== código gerado por mcc =====
.text
_f_main:
	push bp
	ld bp, sp
	sub sp, 2
	ld r0, 0
	st r0, (bp+-2)
_L96224538_16:
	ld r0, (bp+-2)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L96224538_18
	ld r0, 0
	jmp _L96224538_19
_L96224538_18:
	ld r0, 1
_L96224538_19:
	cmp r0, 0
	jmpc eq, _L96224538_17
	ld r0, _g_quadrados
	push r0
	ld r0, (bp+-2)
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+-2)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	mul r0, r1
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	pop r1
	st r0, (r1)
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	jmp _L96224538_16
_L96224538_17:
	ld r0, 0
	st r0, (bp+-2)
_L96224538_20:
	ld r0, (bp+-2)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L96224538_22
	ld r0, 0
	jmp _L96224538_23
_L96224538_22:
	ld r0, 1
_L96224538_23:
	cmp r0, 0
	jmpc eq, _L96224538_21
	ld r0, _g_quadrados
	push r0
	ld r0, (bp+-2)
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
	ld r0, (bp+-2)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-2)
	jmp _L96224538_20
_L96224538_21:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 3
	push r0
	ld r0, 7
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L96224538_26
	ld r0, 0
	jmp _L96224538_27
_L96224538_26:
	ld r0, 1
_L96224538_27:
	cmp r0, 0
	jmpc eq, _L96224538_24
	ld r0, 3
	jmp _L96224538_25
_L96224538_24:
	ld r0, 7
_L96224538_25:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 10
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	mul r0, r1
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L96224538_30
	ld r0, 0
	jmp _L96224538_31
_L96224538_30:
	ld r0, 1
_L96224538_31:
	cmp r0, 0
	jmpc eq, _L96224538_28
	ld r0, 10
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	mul r0, r1
	jmp _L96224538_29
_L96224538_28:
	ld r0, 5
_L96224538_29:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, _str96224538_1
	push r0
	call _f_puts
	add sp, 2
	ld r0, 0
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret

.data
_g_quadrados:
	.db 0
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
_str96224538_0:
	.db 109, 111, 100, 111, 32, 100, 101, 98, 117, 103, 32, 108, 105, 103, 97, 100, 111, 0
_str96224538_1:
	.db 109, 111, 100, 111, 32, 100, 101, 98, 117, 103, 32, 108, 105, 103, 97, 100, 111, 0
