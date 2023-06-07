%include 'words.asm'
%include 'debug.asm'
%include 'readword.asm'
%include 'exit.asm'
%include 'integers.asm'
%include 'interpreter.asm'

global _start

SECTION .data
message: db 'hello, world', 0
fail: db 'Failed lol', 0

SECTION .bss
buffer: resb 64


SECTION .text
_start:
	nop
	call interpret
	call exit
