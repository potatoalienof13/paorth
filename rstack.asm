%ifndef stack.asm_included
%define stack.asm_included

%include 'rstack.asm'


section .bss
returnstack: resb 1048576 * 8
stack: resb 1048576 * 8

section .data
returnstackptr: dq returnstack
returnstackundererrormsg: db "Return stack underflowed!",0
stackptr: dq stack
stackundererrormsg: db "Stack underflowed!",0

section .text

returnstackunderflowerror:
	mov rdi, returnstackundererrormsg
	call puts
	call error

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
	call error

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
