; ===== código gerado por mcc =====
.text
_f_processoA:
	push bp
	ld bp, sp
	sub sp, 6
	ld r0, 0
	st r0, (bp+-2)
_Ldc644927_7:
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
_Ldc644927_10:
	ld r0, (bp+-6)
	push r0
	ld r0, 3000
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc644927_12
	ld r0, 0
	jmp _Ldc644927_13
_Ldc644927_12:
	ld r0, 1
_Ldc644927_13:
	cmp r0, 0
	jmpc eq, _Ldc644927_11
	ld r0, (bp+-6)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	add r0, r1
	st r0, (bp+-6)
	jmp _Ldc644927_10
_Ldc644927_11:
_Ldc644927_8:
	jmp _Ldc644927_7
_Ldc644927_9:
	ld sp, bp
	pop bp
	ret

.data

; ----- literais de string -----
