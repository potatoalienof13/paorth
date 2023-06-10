%include 'words.asm'
%include 'debug.asm'
%include 'readword.asm'
%include 'exit.asm'
%include 'integers.asm'
%include 'interpreter.asm'

global _start

section .bss
; in the event an error occurs, this restores the stack ptr to the time before anything could have gone wrong
programstackptrsave: resq 1

section .text
_start:
	nop
	mov [programstackptrsave], rsp
	call interpret
	call exit
