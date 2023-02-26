
poarth : paorth.o
	ld.lld paorth.o -o paorth

paorth.o : paorth.asm puts.asm syscallno.asm read.asm
	yasm -gdwarf2 -f elf64 paorth.asm


