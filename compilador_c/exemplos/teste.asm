; ===== código gerado por mcc =====
.text
_f_main:
	push bp
	ld bp, sp
	ld r0, _str3d9178c9_3
	push r0
	call _f_puts
	add sp, 2
	call _f_retorna_clock_max
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 12345
	push r0
	call _f_set_clock_max
	add sp, 2
	ld r0, _str3d9178c9_4
	push r0
	call _f_puts
	add sp, 2
	call _f_retorna_clock_max
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, _str3d9178c9_5
	push r0
	call _f_puts
	add sp, 2
	call _f_retorna_clock_atual
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld sp, bp
	pop bp
	ret

.data

; ----- literais de string -----
_str3d9178c9_0:
	.db 67, 108, 111, 99, 107, 32, 97, 110, 116, 101, 115, 32, 100, 111, 32, 115, 101, 116, 58, 0
_str3d9178c9_1:
	.db 67, 108, 111, 99, 107, 32, 100, 101, 112, 111, 105, 115, 32, 100, 111, 32, 115, 101, 116, 58, 0
_str3d9178c9_2:
	.db 67, 108, 111, 99, 107, 32, 97, 116, 117, 97, 108, 58, 32, 0
_str3d9178c9_3:
	.db 67, 108, 111, 99, 107, 32, 97, 110, 116, 101, 115, 32, 100, 111, 32, 115, 101, 116, 58, 0
_str3d9178c9_4:
	.db 67, 108, 111, 99, 107, 32, 100, 101, 112, 111, 105, 115, 32, 100, 111, 32, 115, 101, 116, 58, 0
_str3d9178c9_5:
	.db 67, 108, 111, 99, 107, 32, 97, 116, 117, 97, 108, 58, 32, 0
