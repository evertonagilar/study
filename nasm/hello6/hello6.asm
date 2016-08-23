section .text

global _main

_start:

	mov ebx, 1							; Arg 1: file descriptor (stdout)
	mov ecx, msg						; Arg 2: texto que será impresso
	mov edx, len						; Arg 3: tamanho do texto	
	mov eax, 4							; system call write
	int 0x80							
	
	mov eax, 1							; system call exit
	int 0x80		
	
section .data

msg	db		"Ola unistd.h", 10			; texto que será impresso
len equ 	$ - msg						; tamanho do texto

