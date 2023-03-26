%include 'list.asm'
%include 'puts.asm'
%include 'read.asm'
%include 'stack.asm'
%include 'dataspace.asm'
%include 'word.asm'
%include 'threadedcode.asm'
%include 'words.asm'
%include 'streq.asm'
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
