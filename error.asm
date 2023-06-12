%ifndef error.asm_included
%define error.asm_included

%include 'rstack.asm'

%macro errorm 1
	section .data
		%%errormsg: db %1,0
	section .text
	mov rdi, %%errormsg
	call puts
	call error
%endmacro 

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
