section .data
	stringly db "hiiiiii",0Ah, 0

asmword _puts, "puts", 0
	mov rdi, stringly
	call puts
	next

asmword _quit, "quit", 0
	mov rdi, 0
	call exit

asmword _leave, "leave", 0
	pop rbx 
	next
	
wordword _putexit, "putexit", 0
	dq _puts
	dq _leave


wordword _putexiter, "putexiter", 0
	dq _putexit
	dq _putexit
	dq _quit

