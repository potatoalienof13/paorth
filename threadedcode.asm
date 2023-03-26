%macro next 0
	mov rax, [rbx] ; rbx is a pointer to the next code to execute
	add rbx, 8 
	jmp [rax]
%endmacro

docol:
	push rbx
	add rax, 8 
	mov rbx, rax
	next
