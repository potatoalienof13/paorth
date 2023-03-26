%ifndef threadedcode.asm_included
%define threadedcode.asm_included
%include 'word.asm'
%include 'rstack.asm'

%macro next 0
	mov rax, [rbx] ; rbx is a pointer to the next code to execute
	add rbx, 8 
	jmp [rax]
%endmacro

asmword _leave, "leave", 0
	poprstack rbx
	next

docol:
	pushrstack rbx
	add rax, 8 
	mov rbx, rax
	next
%endif
