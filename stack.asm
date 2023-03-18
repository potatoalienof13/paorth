section .bss
stack: resb 1048576 * 8

section .data
stackptr dq 1

section .text

pushstack:
	mov [stackptr], rdi
	add dword[stackptr], 8
	ret

popstack:
	sub dword[stackptr], 8
	mov rax, [stackptr]
	ret


