%ifndef stack.asm_included
%define stack.asm_included
section .bss
stack: resb 1048576 * 8

section .data
stackptr dq stack

section .text

%macro pushrstack 1
	mov rax, qword[stackptr]
	mov qword [rax], %1
	add qword [stackptr], 8
%endmacro 

%macro poprstack 1
	sub qword[stackptr], 8
	mov rax, qword[stackptr]
	mov %1, qword [rax]
%endmacro

%endif
