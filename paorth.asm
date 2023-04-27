%include 'words.asm'
%include 'debug.asm'
%include 'readword.asm'
%include 'exit.asm'

global _start

SECTION .data
message: db 'hello, world'

SECTION .bss
buffer: resb 64

SECTION .text

_start:
	e:
		nop ; used because of debugging being stupid
		call readword
		mov rdi, wordbuffer
		call puts
		jmp e
	;mov rax, _putexiter
	;jmp docol
