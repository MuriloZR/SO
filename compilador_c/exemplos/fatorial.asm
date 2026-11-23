; ===== código gerado por mcc =====
.text
_f_fatorial:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc le, _Ldc474927_3
	ld r0, 0
	jmp _Ldc474927_4
_Ldc474927_3:
	ld r0, 1
_Ldc474927_4:
	cmp r0, 0
	jmpc eq, _Ldc474927_5
	ld r0, 1
	ld sp, bp
	pop bp
	ret
_Ldc474927_5:
	ld r0, (bp+4)
	push r0
	ld r0, (bp+4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	sub r0, r1
	push r0
	call _f_fatorial
	add sp, 2
	ld r1, r0
	pop r0
	mul r0, r1
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret
_f_fibonacci:
	push bp
	ld bp, sp
	ld r0, (bp+4)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc lt, _Ldc474927_9
	ld r0, 0
	jmp _Ldc474927_10
_Ldc474927_9:
	ld r0, 1
_Ldc474927_10:
	cmp r0, 0
	jmpc eq, _Ldc474927_11
	ld r0, (bp+4)
	ld sp, bp
	pop bp
	ret
_Ldc474927_11:
	ld r0, (bp+4)
	push r0
	ld r0, 1
	ld r1, r0
	pop r0
	sub r0, r1
	push r0
	call _f_fibonacci
	add sp, 2
	push r0
	ld r0, (bp+4)
	push r0
	ld r0, 2
	ld r1, r0
	pop r0
	sub r0, r1
	push r0
	call _f_fibonacci
	add sp, 2
	ld r1, r0
	pop r0
	add r0, r1
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
	ld r0, 0
	st r0, (bp+-2)
_Ldc474927_16:
	ld r0, (bp+-2)
	push r0
	ld r0, 7
	ld r1, r0
	pop r0
	cmp r0, r1
	jmpc le, _Ldc474927_18
	ld r0, 0
	jmp _Ldc474927_19
_Ldc474927_18:
	ld r0, 1
_Ldc474927_19:
	cmp r0, 0
	jmpc eq, _Ldc474927_17
	ld r0, (bp+-2)
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 58
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	call _f_fatorial
	add sp, 2
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 32
	push r0
	call _f_putchar
	add sp, 2
	ld r0, (bp+-2)
	push r0
	call _f_fibonacci
	add sp, 2
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
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
	jmp _Ldc474927_16
_Ldc474927_17:
	ld r0, 0
	ld sp, bp
	pop bp
	ret
	ld sp, bp
	pop bp
	ret

.data

; ----- literais de string -----
