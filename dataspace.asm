section .bss
dataspace: resb 1048576 * 8

section .data
dataptr dq 1

section .text

writebyte:
	mov [dataptr], dil
	inc dword[dataptr]
	ret

aligndataptr:
	mov rax, [dataptr]
	neg rax
	and rax, 7
	add [dataptr], rax
	ret

writedword:
	call aligndataptr
	mov [dataptr], rdi
	add dword[dataptr], 8
	ret
