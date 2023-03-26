%ifndef read.asm
%define read.asm
SECTION .text

readin:
	mov rax, SYS_read 
	syscall
	ret

readstdin:
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, 1
	call readin
	ret
%endif
