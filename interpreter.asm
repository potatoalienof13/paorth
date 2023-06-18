%ifndef interpreter.asm_included
%define interpreter.asm_included


%include 'readword.asm'
%include 'integers.asm'
%include 'find.asm'
%include 'compileflag.asm'
%include 'error.asm'

section .data
	wordnotfound: db "Word not found!",0
	
section .text
; reads in input, and runs the code
; r13 controls whether or not its in compiling mode
interpret:
	push rbx
	push r13
	mov r13, 0
	.inloop:
		call readword
		jz .end
		mov rdi, wordbuffer
		call find
		cmp rax, 0
		jne .found
		mov rdi, wordbuffer
		call parseint
		mov rbx, rax
		jz .notfound
		cmp r13, 0
		jnz .compileliteral
		pushstack rbx
		jmp .inloop
		.compileliteral:
			mov rdi, _lit
			call writeqword 
			mov rdi, rbx
			call writeqword
			jmp .inloop
		.found:
			cmp r13, 0
			je .run
			test qword [rax + wordtype.flags], FLAG_IMMEDIATE
			jnz .run
			lea rdi, [rax + wordtype.xt]
			call writeqword
			jmp .inloop
		.run:
			add rax, wordtype.xt
			callword rax
			mov r13, qword [compileflag] ; word might have changed it
			jmp .inloop
		.notfound:
			mov rdi, wordnotfound
			call puts
			call error
	.end:
		pop r13
		pop rbx
		ret
%endif
