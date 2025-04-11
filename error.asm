%ifndef error.asm_included
%define error.asm_included

%include 'rstack.asm'
%include 'readword.asm'

%macro errorm 1
	section .data
		%%errormsg: db %1,0
	section .text
	mov rdi, %%errormsg
	call putsnonl
	call printerrorline
	call error
%endmacro 

section .data
linenumberprefix: db ": Line #",0

section .text

printerrorline:
	mov rdi, linenumberprefix
	call putsnonl
	mov rdi, qword [linenumber]
	call putint
	call cr
	ret

; error is useful because it doesnt reset already defined words
error:
	mov qword [stackptr], stack
	mov qword [returnstackptr], returnstack
	mov rsp, [programstackptrsave]
	jmp interpret

%endif
