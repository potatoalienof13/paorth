%include 'words.asm'
%include 'debug.asm'
%include 'readword.asm'
%include 'exit.asm'
%include 'integers.asm'

global _start

SECTION .data
message: db 'hello, world'

SECTION .bss
buffer: resb 64

SECTION .text

_start:
	e:
		nop ; used because of debugging being stupid
		mov qword [base], 10
		mov rdi, 9223372036854775808
		call putint
		mov rdi, -13
		call putint
		mov rdi, 13
		call putint
		mov rdi, 0
		call putint
		mov rdi, 1
		call putint
		mov rdi, -1
		call putint

		mov qword [base], 16
		mov rdi, 9223372036854775808
		call putint
		mov rdi, -13
		call putint
		mov rdi, 13
		call putint
		mov rdi, 0
		call putint
		mov rdi, 1
		call putint
		mov rdi, -1
		call putint


		call exit
	;mov rax, _putexiter
	;jmp docol
