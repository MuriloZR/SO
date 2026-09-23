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
	jmpc gt, _L5c382334_26
	ld r0, 0
	jmp _L5c382334_27
_L5c382334_26:
	ld r0, 1
_L5c382334_27:
	cmp r0, 0
	jmpc eq, _L5c382334_24
	ld r0, (bp+-2)
	jmp _L5c382334_25
_L5c382334_24:
	ld r0, (bp+-4)
_L5c382334_25:
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
	jmpc lt, _L5c382334_30
	ld r0, 0
	jmp _L5c382334_31
_L5c382334_30:
	ld r0, 1
_L5c382334_31:
	cmp r0, 0
	jmpc eq, _L5c382334_29
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L5c382334_32
	ld r0, 0
	jmp _L5c382334_33
_L5c382334_32:
	ld r0, 1
_L5c382334_33:
	cmp r0, 0
	jmpc eq, _L5c382334_29
	ld r0, 1
	jmp _L5c382334_28
_L5c382334_29:
	ld r0, 0
_L5c382334_28:
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
	jmpc lt, _L5c382334_36
	ld r0, 0
	jmp _L5c382334_37
_L5c382334_36:
	ld r0, 1
_L5c382334_37:
	cmp r0, 0
	jmpc ne, _L5c382334_35
	ld r0, (bp+-4)
	push r0
	ld r0, 0
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc gt, _L5c382334_38
	ld r0, 0
	jmp _L5c382334_39
_L5c382334_38:
	ld r0, 1
_L5c382334_39:
	cmp r0, 0
	jmpc ne, _L5c382334_35
	ld r0, 0
	jmp _L5c382334_34
_L5c382334_35:
	ld r0, 1
_L5c382334_34:
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 0
	st r0, (bp+-18)
_L5c382334_40:
	ld r0, (bp+-18)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c382334_42
	ld r0, 0
	jmp _L5c382334_43
_L5c382334_42:
	ld r0, 1
_L5c382334_43:
	cmp r0, 0
	jmpc eq, _L5c382334_41
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
	jmp _L5c382334_40
_L5c382334_41:
	ld r0, bp
	add r0, -14
	st r0, (bp+-16)
	ld r0, 0
	st r0, (bp+-18)
_L5c382334_44:
	ld r0, (bp+-18)
	push r0
	ld r0, 5
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _L5c382334_46
	ld r0, 0
	jmp _L5c382334_47
_L5c382334_46:
	ld r0, 1
_L5c382334_47:
	cmp r0, 0
	jmpc eq, _L5c382334_45
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
	jmp _L5c382334_44
_L5c382334_45:
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
