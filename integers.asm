%ifndef integers.asm_included
%define integers.asm_included

%include 'puts.asm'

section .data
base: dq 10
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
		; now a positive number, ez to deal with
		mov rdx, 0
		mov rax, rdi
		div qword [base]
		; convert to char and write
		mov dl, [baselookup + rdx]
		dec rsp
		mov byte[rsp], dl
		; exit if done 
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
	call puts
	mov rsp, rbp
	pop rbp 
	ret
	
; parses an int - respecting the current base 
; sets ZF if it does not parse as int
; returns the int
; takes a null terminated string as argument
parseint:
	; todo
%endif
