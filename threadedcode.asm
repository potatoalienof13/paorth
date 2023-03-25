

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

section .data
	stringly db "hiiiiii",0Ah, 0

asmword wordputs, "puts", 0
	mov rdi, stringly
	call puts
	next

asmword quit, "quit", 0
	mov rdi, 0
	call exit

asmword leaveg, "leave", 0
	pop rbx 
	next
	
wordword putexit, "putexit", 0
	dq wordputs
	dq leaveg


wordword putexiter, "whargharder", 0
	dq putexit
	dq putexit
	dq quit
