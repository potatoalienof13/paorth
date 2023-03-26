%ifndef list.asm_included
%define list.asm_included
struc node
	.next: resq 1
endstruc

; takes a register containing a pointer, overwrites it with a pointer to the next node
%macro nextnode 1
	mov %1, [%1]
%endmacro



%endif
