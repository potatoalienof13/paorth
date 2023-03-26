%ifndef find.asm_included
%define find.asm_included

; words needs to have defined the pointer to the current last definition
; all word definitions need to be defined before here 
%include 'words.asm'
%include 'word.asm'

section .data
latestdefinedword: dq NEXTWORDPTR

section .text
; takes a string, and returns a word ptr, or null if it is not found

find:
	push rbx 
	mov rbx, [latestdefinedword]
	mov r13, rdi
	.loop:
		cmp rbx, 0
		je .wordnotfound
		mov rdi, [rbx + wordtype.name]
		mov rsi, r13
		call strieq
		je .wordfound
		mov rbx, [rbx + wordtype.next]
		jmp .loop
	.wordnotfound:
		mov rax, 0 
		pop rbx
		ret
	.wordfound:
		mov rax, rbx 
		pop rbx
		ret 
; This will make any word definition after this file fail.
%undef NEXTWORDPTR

%endif
