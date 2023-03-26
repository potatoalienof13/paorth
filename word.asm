%ifndef word.asm
%define word.asm

struc wordtype
	.next: resq 1
	.name: resq 1
	.flags: resq 1
	.definition: resq 1
endstruc

; null so that the last word has a pointer to null
%define NEXTWORDPTR 0

%macro wordheader 3 ; name, strname, flags
	; name will usually start with an underscore
	%%strname: db %2,0
	align 8
	global name%1
	link%1:
		dq NEXTWORDPTR
		%define NEXTWORDPTR link%1
		dq %%strname
		dq %3
%endmacro

%macro wordword 3 ; name, strname, flags
	section .data
	wordheader %1, %2, %3
		global %1
		%1:
			dq docol
%endmacro

%macro asmword 3 ; name, strname, flags
	section .data
	wordheader %1, %2, %3
		global %1
		%1:
			dq %%jump
	section .text
			%%jump:
%endmacro

%endif
