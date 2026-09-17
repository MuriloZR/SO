; ===== código gerado por mcc =====
.text
_f_main:
	push bp
	ld bp, sp
	ld r0, _str3d9978c9_1
	push r0
	call _f_puts
	add sp, 2
	ld r0, 2
	push r0
	ld r0, 3
	push r0
	ld r0, 4
	ld r1, r0
	pop r0
	mul r0, r1
	ld r1, r0
	pop r0
	add r0, r1
	push r0
	call _f_print_int
	add sp, 2
	ld r0, 10
	push r0
	call _f_putchar
	add sp, 2
	ld r0, 4660
	push r0
	call _f_print_hex
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
_str3d9978c9_0:
	.db 79, 108, 97, 44, 32, 77, 97, 110, 99, 104, 97, 33, 0
_str3d9978c9_1:
	.db 79, 108, 97, 44, 32, 77, 97, 110, 99, 104, 97, 33, 0
