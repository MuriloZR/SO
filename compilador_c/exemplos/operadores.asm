; ===== código gerado por mcc =====
.text
_f_main:
	push bp
	ld bp, sp
	sub sp, 18
	ld r0, 13
	st r0, (bp+-2)
	ld r0, 5
	st r0, (bp+-4)
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	and r0, r1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	or r0, r1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	xor r0, r1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	xor r0, -1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	shl r0, r1
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
	shr r0, r1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	ld r2, r0
	div r0, r1
	mul r0, r1
	sub r2, r0
	ld r0, r2
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L3d9b78c9_26
	ld r0, 0
	jmp _L3d9b78c9_27
_L3d9b78c9_26:
	ld r0, 1
_L3d9b78c9_27:
	cmp r0, 0
	jmpc eq, _L3d9b78c9_24
	ld r0, (bp+-2)
	jmp _L3d9b78c9_25
_L3d9b78c9_24:
	ld r0, (bp+-4)
_L3d9b78c9_25:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9b78c9_30
	ld r0, 0
	jmp _L3d9b78c9_31
_L3d9b78c9_30:
	ld r0, 1
_L3d9b78c9_31:
	cmp r0, 0
	jmpc eq, _L3d9b78c9_29
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L3d9b78c9_32
	ld r0, 0
	jmp _L3d9b78c9_33
_L3d9b78c9_32:
	ld r0, 1
_L3d9b78c9_33:
	cmp r0, 0
	jmpc eq, _L3d9b78c9_29
	ld r0, 1
	jmp _L3d9b78c9_28
_L3d9b78c9_29:
	ld r0, 0
_L3d9b78c9_28:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	ld r0, (bp+-4)
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9b78c9_36
	ld r0, 0
	jmp _L3d9b78c9_37
_L3d9b78c9_36:
	ld r0, 1
_L3d9b78c9_37:
	cmp r0, 0
	jmpc ne, _L3d9b78c9_35
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L3d9b78c9_38
	ld r0, 0
	jmp _L3d9b78c9_39
_L3d9b78c9_38:
	ld r0, 1
_L3d9b78c9_39:
	cmp r0, 0
	jmpc ne, _L3d9b78c9_35
	ld r0, 0
	jmp _L3d9b78c9_34
_L3d9b78c9_35:
	ld r0, 1
_L3d9b78c9_34:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	st r0, (bp+-18)
_L3d9b78c9_40:
	ld r0, (bp+-18)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9b78c9_42
	ld r0, 0
	jmp _L3d9b78c9_43
_L3d9b78c9_42:
	ld r0, 1
_L3d9b78c9_43:
	cmp r0, 0
	jmpc eq, _L3d9b78c9_41
	ld r0, bp
	add r0, -14
	push r0
	ld r0, (bp+-18)
	mul r0, 2
	pop r1
	add r1, r0
	push r1
	ld r0, (bp+-18)
	push r0
	ld r0, (bp+-18)
	ld r1, r0
	pop r0
	mul r0, r1
	pop r1
	st r0, (r1)
	ld r0, (bp+-18)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-18)
	jmp _L3d9b78c9_40
_L3d9b78c9_41:
	ld r0, bp
	add r0, -14
	st r0, (bp+-16)
	ld r0, 0
	st r0, (bp+-18)
_L3d9b78c9_44:
	ld r0, (bp+-18)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L3d9b78c9_46
	ld r0, 0
	jmp _L3d9b78c9_47
_L3d9b78c9_46:
	ld r0, 1
_L3d9b78c9_47:
	cmp r0, 0
	jmpc eq, _L3d9b78c9_45
	ld r0, (bp+-16)
	ld r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-16)
	push r0
	add r0, 2
	st r0, (bp+-16)
	pop r0
	ld r0, (bp+-18)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-18)
	jmp _L3d9b78c9_44
_L3d9b78c9_45:
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, bp
	add r0, -14
	push r0
	ld r0, 2
	mul r0, 2
	pop r1
	add r1, r0
	ld r0, r1
	st r0, (bp+-16)
	ld r0, (bp+-16)
	push r0
	ld r0, 2
	mul r0, 2
	ld r1, r0
	pop r0
	add r0, r1
	ld r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-16)
	push r0
	ld r0, 1
	mul r0, 2
	ld r1, r0
	pop r0
	sub r0, r1
	ld r1, r0
	ld r0, (r1)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 10
	st r0, (bp+-2)
	ld r0, 5
	push r0
	ld r0, (bp+-2)
	pop r1
	add r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 3
	push r0
	ld r0, (bp+-2)
	pop r1
	sub r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 2
	push r0
	ld r0, (bp+-2)
	pop r1
	mul r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 4
	push r0
	ld r0, (bp+-2)
	pop r1
	div r0, r1
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 4
	push r0
	ld r0, (bp+-2)
	pop r1
	ld r3, r0
	div r0, r1
	mul r0, r1
	sub r3, r0
	ld r0, r3
	st r0, (bp+-2)
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 3
	st r0, (bp+-18)
	ld r0, (bp+-18)
	push r0
	add r0, 1
	st r0, (bp+-18)
	pop r0
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-18)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-18)
	add r0, 1
	st r0, (bp+-18)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-18)
	push r0
	add r0, -1
	st r0, (bp+-18)
	pop r0
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-18)
	push r0
	call _f_print_int
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
