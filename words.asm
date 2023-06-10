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
	popstack rdi
	call puts
	next

asmword _quit, "quit", 0
	mov rdi, 0
	call exit

asmword _dot, ".", 0
	popstack rdi
	call putint
	next

asmword _add, "+", 0
	popstack rdi
	popstack rax
	add rax, rdi
	pushstack rax
	next

asmword _sub, "-", 0
	popstack rdi
	popstack rax
	sub rax, rdi
	pushstack rax
	next

asmword _mul, "*", 0
	popstack rdi
	popstack rax
	imul rax, rdi
	pushstack rax
	next

asmword _div, "/", 0
	popstack rdi
	popstack rax
	cqo ; sign extends rax into rdx 
	idiv rdi
	pushstack rax
	next

asmword _eq, "=", 0
	popstack rdi
	popstack rax
	mov rsi, 1
	cmp rdi, rax
	je .equal
	mov rax, 0
	.equal:
		pushstack rsi
		next

asmword _drop, "drop", 0
	popstack rax
	next

asmword _dup, "dup", 0
	popstack rax
	pushstack rax
	pushstack rax
	next

asmword _swap, "swap", 0
	popstack rax
	popstack rdi
	pushstack rax
	pushstack rdi
	next

asmword _torstack, ">r", 0
	popstack rax
	pushrstack rax
	next

asmword _fromrstack, "r>", 0
	pushrstack rax
	popstack rax
	next

asmword _here, "here", 0
	mov rax, [dataptr]
	pushstack rax
	next

asmword _write, ",", 0
	popstack rdi
	call writeqword
	next

asmword _writechar, ",c", 0
	popstack rdi
	call writebyte
	next
	
asmword _at, "@", 0
	popstack rdi
	mov rax, [rdi]
	pushstack rax
	next

asmword _shove, "!", 0
	popstack rdi
	popstack rax
	mov [rdi], rax
	next

; jumps forward, or backward, 
asmword _branch, "branch", 0
	mov rbx, [rbx]
	next

asmword _0branch, "0branch", 0
	popstack rax
	cmp rax, 0
	je .jump
	add rbx, 8
	next
	.jump:
		mov rbx, [rbx]
		next

setwordflag:
	mov rax, [latestdefinedword]
	add rax, wordtype.flags
	mov rsi, [rax]
	or rsi, rdi
	mov [rax], rsi
	ret

unsetwordflag:
	mov rax, [latestdefinedword]
	add rax, wordtype.flags
	mov rsi, [rax]
	not rdi
	and rsi, rdi
	mov [rax], rsi
	ret

asmword _immediate, "immediate", FLAG_IMMEDIATE
	mov rdi, FLAG_IMMEDIATE
	call setwordflag
	next

asmword _hide, "hide", FLAG_IMMEDIATE
	mov rdi, FLAG_HIDDEN
	call setwordflag
	next

asmword _unhide, "unhide", FLAG_IMMEDIATE
	mov rdi, FLAG_HIDDEN
	call unsetwordflag
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
	mov rdi, FLAG_HIDDEN
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
	mov rdi, FLAG_HIDDEN
	call unsetwordflag
	next

asmword _latest, "latest", 0
	mov rax, [latestdefinedword] 
	pushstack rax
	next

; literal isnt a normal word
; its job is to handle integer literals
; In memory, the integer is the 64 bits after the pointer to literal
; It wont ever be directly included in a definition for a word
asmword _literal, "literal", 0
	mov rax, [rbx]
	pushstack rax
	add rbx, 8
	next

asmword _error, "error", 0
	call error
	; no next, error doesnt return contol flow here

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
