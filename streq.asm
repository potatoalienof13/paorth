%ifndef streq.asm
%define streq.asm

section .text
toupper:
	cmp dil, 'a'
	jl .end
	cmp dil, 'z'
	jg .end
	sub dil, 32
	.end:
	mov al, dil
	ret

streq:
	.loop:
		mov al, byte[rsi]
		cmp byte[rdi], al
		jne .unequal
		cmp byte[rdi], 0
		je .equal 
		inc rsi
		inc rdi
		jmp .loop
	.equal:
		mov rax, 1
		ret
	.unequal:
		mov rax, 0 
		ret

strieq:
	mov rbx, rdi 
	.loop:
		mov dil, byte[rbx] ; overwrites rdi, which is why that got moved
		call toupper
		mov r12b, al ; so toupper wont overwrite it 
		mov dil, byte[rsi]
		call toupper
		cmp al, r12b
		jne .unequal
		cmp al, 0
		je .equal 
		inc rbx
		inc rsi
		jmp .loop
	.equal:
		mov rax, 1
		ret
	.unequal:
		mov rax, 0 
		ret


%endif
