%include 'puts.asm'
%include 'read.asm'

global paorth 

SECTION .data
message: db 'hello, world'

SECTION .bss
buffer: resb 64

SECTION .text

paorth:
	.loop

	
	jmp .loop

