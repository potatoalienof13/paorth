%ifndef integers.asm_included
%define integers.asm_included

%include 'puts.asm'
%include 'retzf.asm'
%include 'vars.asm'

section .data
baselookup: db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

section .text

; writes a signed 64 bit int to stdout - respecting the current base
putint:
	push rbp
	mov rbp, rsp
	push 0 ; null terminate
	mov r11, 0
	cmp rdi, 0
	jge .loop ; negative numbers need a minus sign
	mov r11, 1
	; technically, the LONG_MIN cannot be represented by a positive signed integer
	; but it still works.
	neg rdi
	.loop:
		mov rdx, 0
		mov rax, rdi
		div qword [base]
		; convert to char and write
		mov dl, [baselookup + rdx]
		dec rsp
		mov byte[rsp], dl
		; exit
		cmp rax, 0
		je .fin
		mov rdi, rax
		jmp .loop
	.fin:
	cmp r11, 0
	je .skipminus
	dec rsp
	mov byte[rsp], '-'
	.skipminus:
	mov rdi, rsp
	call putsnonl
	mov rsp, rbp
	pop rbp 
	ret

; takes a single character, and finds it in the base string
; O(N), but a smarter solution will make changing the base string
; harder
; sets ZF on failure
chartoint:
	mov rsi, baselookup
	mov rax, [base]
	.loop:
		lea rcx, [rax + baselookup]
		cmp rcx, rsi
		je .err
		cmp byte[rsi], dil
		je .end
		inc rsi
		jmp .loop 
	.end:
		; this sub wont set ZF for 0.
		sub rsi, baselookup 
		mov rax, rsi
		cmp rax, -1 
		ret
	.err:
		; zf conveniently set already
		ret
		
; parses an int - respecting the current base
; sets ZF if it does not parse as int
; returns the int
; takes a null terminated string as argument
parseint:
	push r14
	push r13
	push r12
	
	mov r13, rdi
	mov r12, 0
	mov r14, 1
	cmp byte[r13], '-'
	jne .loop
	inc r13
	mov r14, -1
	.loop:
		imul r12, [base]
		mov dil, byte[r13]
		; note that this stops empty strings.
		call chartoint
		jz .endfull
		add r12, rax
		inc r13
		cmp byte[r13], 0
		je .end
		jmp .loop
	.end:
		mov rax, r12
		imul rax, r14
		test rsp, rsp ; unset zf
		.endfull:
			pop r12
			pop r13
			pop r14
			ret
; todo
%endif
