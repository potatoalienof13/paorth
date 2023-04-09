%ifndef retzf.asm_included
%define retzf.asm_included

%macro retzf 0
	jnz %%skip
		ret
	%%skip:
%endmacro

%endif
