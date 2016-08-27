.text

	.global _start

_start:

	movl $1,   %ebx						# Arg 1: file descriptor (stdout)
	movl $msg, %ecx						# Arg 2: texto que será impresso
	movl $len, %edx						# Arg 3: tamanho do texto	
	movl $4,   %eax						# system call write
	int $0x80							
	
	mov $1, %eax						# system call exit
	int $0x80		
	
.data

msg:	.ascii		"Ola unistd.h\n"			# texto que será impresso
		len =	 	. - msg						# tamanho do texto

