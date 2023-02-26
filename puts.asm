%include "syscallno.asm"
global exit
exit:
	mov rax, SYS_exit
	syscall

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

cr:
	mov rdi, 32
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
