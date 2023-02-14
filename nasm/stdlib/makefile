all: 
	rm -f *.o
	nasm -f elf64 -g strutils_.asm
	
	# compila com a função main sendo _start
	#gcc -g -nostdlib -e main -no-pie strutils.c strutils_.o -o strutils

	# compila sem stdlib e lee_start sendo a função de entrada do executável
	gcc -g -nostdlib -e lee_start -no-pie strutils.c strutils_.o -o strutils

	# compila fazendo strip
	#gcc -s -nostdlib -e lee_start -no-pie strutils.c strutils_.o -o strutils

	
