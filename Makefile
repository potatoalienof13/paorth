poarth : paorth.o
	ld.lld paorth.o -o paorth

paorth.o : *.asm
	yasm -gdwarf2 -f elf64 paorth.asm

clean:
	rm paorth paorth.o

