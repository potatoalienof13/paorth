%ifndef dataspace.asm_included
%define dataspace.asm_included
section .bss
dataspace: resb 1048576 * 8

section .data
dataptr dq dataspace

section .text

writebyte:
	mov rax, [dataptr]
	mov [rax], dil
	inc qword[dataptr]
	ret

aligndataptr:
	mov rax, [dataptr]
	neg rax
	and rax, 7
	add [dataptr], rax
	ret

writeqword:
	call aligndataptr
	mov rax, [dataptr]
	mov qword[rax], rdi
	add qword[dataptr], 8
	ret
%endif
