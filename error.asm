%ifndef error.asm_included
%define error.asm_included

%include 'rstack.asm'


section .data
errormsg: db "Error occured, resetting stacks",0

section .text
; error is useful because it doesnt reset already defined words
error:
	mov qword [stackptr], stack
	mov qword [returnstackptr], returnstack
	mov rdi, errormsg
	call puts
	mov rsp, [programstackptrsave]
	jmp interpret

%endif
