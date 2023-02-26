SECTION .data
message db "hiiiiiiii", 0

SECTION .text

%include 'puts.asm'
%include 'read.asm'
global puts
;global _start
;_start:
;	pop rbx
;	.loop:
;		pop rax
;		cmp rax, 0
;		je .end
;		call puts
;		jmp .loop
;	.end:
;	call exit

