%ifndef readword.asm_included
%define readword.asm_included

%define keybuffersize 4096
%define wordbuffersize 256

%include 'read.asm'
%include 'iswhitespace.asm'
%include 'retzf.asm'

section .bss
; note: the key buffer is NOT null terminated
keybuffer: resb keybuffersize
; the wordbufffer is null terminated, as expected
wordbuffer: resb wordbuffersize

section .data
keybuffernext: dq keybuffer
keybuffertop: dq keybuffer


section .text
; puts new data in the key buffer
refillkeybuffer:
	mov rdi, keybuffer
	mov rsi, keybuffersize
	call readstdin
	cmp rax, 0
	jl exit ; fun error handling! 
	retzf
	; set everything up for a full input buffer
	add rax, keybuffer ; adding a pointer to an integer is fun!
	mov [keybuffertop], rax
	mov rax, keybuffer
	mov [keybuffernext], rax
	ret
		

; grabs one key from the input buffer, sets ZF on EOF
key:
	mov rax, [keybuffertop]
	cmp [keybuffernext], rax
	jl .skiprefill
		call refillkeybuffer
		; could have hit EOF
		retzf
	.skiprefill:
	mov rdi, [keybuffernext]
	xor rax, rax
	mov al, byte[rdi]
	add qword [keybuffernext], 1
	ret

; puts a word into the word buffer, sets ZF on EOF
; needs a newline at the end of the file?
readword:
	push r13
	push rbx
	mov r13, wordbuffer
	.loob:
		call key 
		jz .end ; zf on eof
		mov bl, al
		mov dil, al
		call iswhitespace
		jz .loob ; was whitespace, loob again 
	.newloob:
		mov [r13], bl
		inc r13 
		call key
		jz .end
		mov bl, al
		mov dil, al
		call iswhitespace
		jnz .newloob
	mov byte[r13], 0
	cmp r13, 0 ; should unset zf
	.end:
		pop rbx
		pop r13
		ret

%endif
