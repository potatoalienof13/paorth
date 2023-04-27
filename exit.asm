%ifndef exit.asm_included
%define exit.asm_included

exit:
	mov rax, SYS_exit
	syscall
 
%endif
