%ifndef word.asm_included
%define word.asm_included

%include 'rstack.asm'

struc wordtype
	.next: resq 1
	.name: resq 1
	.flags: resq 1
	.definition: resq 1
endstruc
%define FLAG_IMMEDIATE 1
%define FLAG_HIDDEN 2

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
			dq asm%1
	section .text
			asm%1:
%endmacro

%macro next 0
	mov r13, [rbx] ; rbx is a pointer to the next code to execute
	add rbx, 8
	jmp [r13]
%endmacro

asmword _leave, "leave", 0
	poprstack rbx
	next

section .text
docol:
	pushrstack rbx
	add r13, 8
	mov rbx, r13
	next


section .bss
	callword_word resq 1
	callword_return resq 1
section .text
; this "smart" callword returns control to its call site.
%macro callword 1
	section .data
		%%gamer: dq %%jumpback
	section .text
	mov qword [callword_return], %%gamer
	mov qword [callword_word], %1
	mov rbx, callword_word
	next
	%%jumpback:
%endmacro 

%endif
