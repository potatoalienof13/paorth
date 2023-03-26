%ifndef debug.asm_included
%define debug.asm_included

section .data 
	onstring: db 'Zero flag is ON',0 
	offstring: db 'Zero flag is OFF',0 

section .text
printzeroflag:
	mov rdi, onstring
	je .skip
	mov rdi, offstring
	.skip:
		call puts
		ret
%endif
