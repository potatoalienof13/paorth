%ifndef puts.asm_included
%define puts.asm_included
%include "syscallno.asm"

; string, length
print:
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, 1 
	mov rax, SYS_write
	syscall
	ret

putchar:
	push rdi 
	mov rsi, 1
	mov rdi, rsp
	call print
	pop rdi 
	ret

space:
	mov rdi, 32
	call putchar
	ret

cr:
	mov rdi, 10
	call putchar
	ret

puts:
	push rbx 
	mov rbx, rdi
	call strlen
	mov rdi, rbx
	mov rsi, rax 
	call print
	call cr
	pop rbx
	ret

strlen:
	push rbx
	mov rbx, rdi
	.loop:
		cmp byte[rdi], 0
		je .end
		inc rdi
		jmp .loop
	.end:
	sub rdi, rbx
	pop rbx
	mov rax, rdi 
	ret
%endif
