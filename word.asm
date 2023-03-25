
struc wordtype
	.next: resq 1
	.name: resq 1
	.flags: resq 1
	.definition: resq 1
endstruc


%define lastdefword 0

%macro header 3 ; name, strname, flags
	strname_%1: db %2,0
	align 8
	global name_%1
	link_%1:
		dq lastdefword
		%define lastdefword link_%1
		dq strname_%1
		dq %3
%endmacro

%macro wordword 3 ; name, strname, flags
	section .data
	header %1, %2, %3
		global %1
		%1:
			dq docol
%endmacro

%macro asmword 3 ; name, strname, flags
	section .data
	header %1, %2, %3
		global %1
		%1:
			dq %%jump
	section .text
			%%jump:
%endmacro
