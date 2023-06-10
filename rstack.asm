%ifndef stack.asm_included
%define stack.asm_included




section .bss
returnstack: resb 1048576 * 8
stack: resb 1048576 * 8

section .data
returnstackptr: dq returnstack
returnstackundererrormsg: db "Return stack underflowed!"
stackptr: dq stack
stackundererrormsg: db "Stack underflowed!"

section .text

returnstackunderflowerror:
	mov rdi, returnstackundererrormsg
	call puts
	mov rdi, 1
	call exit

; WARNING: pushrstack and pushstack overwrite r11
%macro pushrstack 1
	mov r11, qword[returnstackptr]
	mov qword [r11], %1
	add qword [returnstackptr], 8
%endmacro 

%macro poprstack 1
	sub qword [returnstackptr], 8
	cmp qword [returnstackptr], returnstack
	jl returnstackunderflowerror
	mov %1, qword[returnstackptr]
	mov %1, qword [%1]
%endmacro

stackunderflowerror:
	mov rdi, stackundererrormsg
	call puts
	mov rdi, 1
	call exit

; WARNING: pushrstack and pushstack overwrite r11
%macro pushstack 1
	mov r11, qword[stackptr]
	mov qword [r11], %1
	add qword [stackptr], 8
%endmacro 

%macro popstack 1
	sub qword [stackptr], 8
	cmp qword [stackptr], stack
	jl stackunderflowerror
	mov %1, qword[stackptr]
	mov %1, qword [%1]
%endmacro




%endif
