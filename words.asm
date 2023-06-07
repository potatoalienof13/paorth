%ifndef words.asm_included
%define words.asm_included

%include 'puts.asm'
%include 'integers.asm'
%include 'word.asm'
%include 'compileflag.asm'
%include 'readword.asm'
%include 'dataspace.asm'

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

asmword _define, ":", 0
	.start:
	push r13
	push r14
	call readword
	mov r13, wordbuffer
	mov r14, [dataptr]
	.writenameloop:
	mov dil, byte[r13]
	call writebyte
	cmp byte [r13], 0
	je .next
	inc r13
	jmp .writenameloop
	.next:
	call aligndataptr
	mov rsi, [dataptr]
	mov rdi, [latestdefinedword]
	call writeqword
	mov [latestdefinedword], rsi
	.name:
	mov rdi, r14
	call writeqword
	.flags:
	mov rdi, 0
	call writeqword
	.definition:
	mov rdi, docol
	call writeqword

	mov qword [compileflag], 1
	pop r14
	pop r13
	next

asmword _fin, ";", FLAG_IMMEDIATE
	mov byte [compileflag], 0
	mov rdi, _leave
	call writeqword
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
