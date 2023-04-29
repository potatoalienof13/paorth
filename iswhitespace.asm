%ifndef iswhitespace.asm_included
%define iswhitespace.asm_included

section .text
; sets ZF when it is whitespace
iswhitespace:
	cmp dil, 32 ; ' '
	je  .return
	cmp dil, 9 ; '\t'
	je  .return
	cmp dil, 10 ; '\n'
	je  .return
	cmp dil, 13 ; '\r'
	je  .return
	cmp dil, 11 ; '\v'
	je  .return
	cmp dil, 12 ; '\f'
	.return:
		ret

%endif
