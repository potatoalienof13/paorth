
; rax will be the pointer to which docol should rbxurn
; rbx will contain the pointer to raxently executing code

%macro next 0
	mov rax, [rbx] ; rbx is a pointer to the next code to execute
	add rbx, 8 
	jmp [rax]
%endmacro

%macro asmword 1
%1:
	dq .%1
	.%1: 
%endmacro

%macro wordword 1
%1:
	dq docol
%endmacro 

docol:
	push rbx
	add rax, 8 
	mov rbx, rax
	next

section .data
	stringly db "hiiiiii",0 

section .text
asmword wordputs
	mov rdi, stringly
	call puts
	next

asmword exitword
	mov rdi, 0
	call exit

wordword putexit
	dq wordputs
	dq exitword

wordword putexiter
	dq putexit
