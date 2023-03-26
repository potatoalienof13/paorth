%ifndef stack.asm_included
%define stack.asm_included
section .bss
stack: resb 1048576 * 8

section .data
stackptr dq 1

section .text

%macro pushrstack 1
	mov [stackptr], %1
	add dword[stackptr], 8
%endmacro 

%macro poprstack 1
	sub dword[stackptr], 8
	mov %1, [stackptr]
%endmacro

%endif
