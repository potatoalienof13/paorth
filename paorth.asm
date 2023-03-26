%include 'words.asm'
%include 'debug.asm'

global _start

SECTION .data
message: db 'hello, world'

SECTION .bss
buffer: resb 64

SECTION .text

_start:
	mov rax, _putexiter
	jmp docol
