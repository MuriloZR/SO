; ===== código gerado por mcc =====
.text
_f_main:
	push bp
	ld bp, sp
	sub sp, 2
	call _f_getchar
	st r0, (bp+-2)
_L3d8378c9_4:
	ld r0, (bp+-2)
	push r0
	ld r0, 10
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc ne, _L3d8378c9_6
	ld r0, 0
	jmp _L3d8378c9_7
_L3d8378c9_6:
	ld r0, 1
_L3d8378c9_7:
	cmp r0, 0
	jmpc eq, _L3d8378c9_5
	ld r0, (bp+-2)
	push r0
	call _f_putchar
	add sp, 2
	call _f_getchar
	st r0, (bp+-2)
	jmp _L3d8378c9_4
_L3d8378c9_5:
	ld r0, 33
	push r0
	call _f_putchar
	add sp, 2
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

; ----- literais de string -----
