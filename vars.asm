%ifndef vars.asm_included
%define vars.asm_included

%include 'word.asm'

section .data

%macro varword 3
	align 8
	%1:  dq %2
	wordword _%1, %3, 0
		dq _literal
		dq %1
		dq _leave
%endmacro

varword base, 10, "base"

%endif
