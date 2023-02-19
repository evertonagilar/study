all: 
	rm -f *.o
	nasm -f elf64 -g strutils_.asm
	
	# compila com a função main sendo _start
	#gcc -g -nostdlib -e main -no-pie strutils.c strutils_.o -o strutils

	# compila sem stdlib e lee_start sendo a função de entrada do executável
	gcc -g -no-pie strutils.c strutils_.o -o strutils

	# compila fazendo strip
	#gcc -s -nostdlib -e lee_start -no-pie strutils.c strutils_.o -o strutils

	
hello: hello.o
	ld -g -o hello hello.o
	rm -f hello.o

hello.o: hello.asm
	nasm -g -f elf64 hello.asm


agenda: agenda.o
	ld -g -o agenda agenda.o
	rm -f agenda.o

agenda.o: agenda.asm
	nasm -g -f elf64 agenda.asm
