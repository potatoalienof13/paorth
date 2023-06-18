%ifndef words.asm_included
%define words.asm_included

%include 'puts.asm'
%include 'integers.asm'
%include 'word.asm'
%include 'compileflag.asm'
%include 'readword.asm'
%include 'dataspace.asm'
%include 'error.asm'

section .text

; pushes a number to the stack in interpretation mode
; compiles it in immediate mode
literalhelper:
	cmp byte [compileflag], 0
	jne .comp
	pushstack rdi
	ret
	
	.comp:
		push rdi
		mov rdi, _lit
		call writeqword
		pop rdi
		call writeqword
		ret

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

asmword _and, "and", 0
	popstack rdi
	popstack rax
	and rax, rdi
	pushstack rax
	next

asmword _or, "or", 0
	popstack rdi
	popstack rax
	or rax, rdi
	pushstack rax
	next

asmword _xor, "xor", 0
	popstack rdi
	popstack rax
	xor rax, rdi
	pushstack rax
	next

asmword _eq, "=", 0
	popstack rdi
	popstack rax
	mov rsi, 1
	cmp rdi, rax
	je .equal
	mov rsi, 0
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

asmword _write, ",", 0
	popstack rdi
	call writeqword
	next

asmword _writechar, ",c", 0
	popstack rdi
	call writebyte
	next
	
asmword _get, "@", 0
	popstack rdi
	mov rax, [rdi]
	pushstack rax
	next

asmword _set, "!", 0
	popstack rdi
	popstack rax
	mov [rdi], rax
	next

asmword _getb, "C@", 0
	popstack rdi
	mov al, byte [rdi]
	pushstack rax
	next

asmword _setb, "C!", 0
	popstack rdi
	popstack rax
	mov byte [rdi], al
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

asmword _key, "key", 0
	call key
	pushstack rax
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

movestringtodataspace:
	push rbx
	mov rbx, rdi
	.loop:
		mov dil, byte [rbx]
		call writebyte
		inc rbx
		cmp byte [rbx-1], 0
		jne .loop
	.end:
	pop rbx
	ret 

asmword _persiststring, "persiststring", 0
	popstack rdi
	call movestringtodataspace
	next

asmword _create, "create", FLAG_IMMEDIATE
	call readword
	.writename:
	push qword [dataptr]
	mov rdi, wordbuffer
	call movestringtodataspace
	.next:
	call aligndataptr
	mov rsi, [dataptr]
	mov rdi, [latestdefinedword]
	call writeqword
	mov [latestdefinedword], rsi
	.name:
	pop rdi
	call writeqword
	.flags:
	mov rdi, FLAG_HIDDEN
	call writeqword
	next

asmword _fin, ";", FLAG_IMMEDIATE
	cmp byte [compileflag], 0 ; if not in compile mode, error
	jnz .allfine
	errorm "';' was used in interpretation mode."
	.allfine: mov byte [compileflag], 0
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
asmword _lit, "lit", 0
	mov rax, [rbx]
	pushstack rax
	add rbx, 8
	next

asmword _getxt, "'", FLAG_IMMEDIATE
	call readword
	jz .error
	mov rdi, wordbuffer
	call find
	cmp rax, 0
	je error
	add rax, wordtype.xt
	mov rdi, rax
	call literalhelper
	next
	.error: ; eof. I should handle this better
		call exit 

; note, wordbuffer gets invalidated with the next call to word
asmword _word, "word", 0
	call readword
	pushstack wordbuffer
	next
	
asmword _compile, "[COMPILE]", FLAG_IMMEDIATE
	call asm_getxt
	popstack rdi
	call writeqword
	next

asmword _startinterp, "[", FLAG_IMMEDIATE
	mov byte [compileflag], 0
	next

asmword _endinterp, "]", FLAG_IMMEDIATE
	mov byte [compileflag], 1
	next

asmword _break, "break", 0
	nop
	next

asmword _breaki, "breaki", FLAG_IMMEDIATE
	nop
	next


asmword _error, "error", 0
	call error
	; no next, error doesnt return contol flow here

section .data

wordword _define, ":", FLAG_IMMEDIATE
	dq _create
	dq _lit
	dq docol
	dq _write
	dq _hide
	dq _endinterp
	dq _leave

wordword _putexit, "putexit", 0
	dq _puts
	dq _leave
	
wordword _test, "test", 0
	dq _lit
	dq 9321
	dq _dot
	dq _leave

%endif
