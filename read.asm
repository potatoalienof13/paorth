%ifndef read.asm_included
%define read.asm_included
SECTION .text

openr:
	mov rax, SYS_open
	; O_RDONLY
	mov rsi, 0
	syscall
	ret

readin:
	mov rax, SYS_read 
	syscall
	ret

readstdin:
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, 0
	call readin
	ret
%endif
