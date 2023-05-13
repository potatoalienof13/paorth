%ifndef words.asm_included
%define words.asm_included

%include 'puts.asm'
%include 'integers.asm'
%include 'word.asm'


section .text 
asmword _puts, "puts", 0
	pop rdi
	call puts
	next

asmword _quit, "quit", 0
	mov rdi, 0
	call exit

asmword _dot, ".", 0
	pop rdi
	call putint
	next

; literal isnt a normal word
; its job is to handle integer literals
; In memory, the integer is the 64 bits after the pointer to literal
; It wont ever be directly included in a definition for a word
asmword _literal, "LITERAL", 0
	push qword [rbx]
	add rbx, 8
	next

section .data

wordword _putexit, "putexit", 0
	dq _puts
	dq _leave
	
wordword _test, "test", 0
	dq _literal
	dq 9321
	dq _dot
	dq _leave

%endif
