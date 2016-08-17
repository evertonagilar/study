	.file	"struct.c"
	.section	.rodata
	.align 8
.LC1:
	.string	"Criando estrutura do banco %s\n"
.LC2:
	.string	"w"
	.align 32
.LC0:
	.value	1
	.string	"Everton Agilar"
	.zero	105
	.string	"UTF-8"
	.zero	74
	.text
	.globl	write_database
	.type	write_database, @function
write_database:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$256, %rsp
	movq	%rdi, -248(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-248(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	leaq	-224(%rbp), %rax
	movl	$.LC0, %edx
	movl	$25, %ecx
	movq	%rax, %rdi
	movq	%rdx, %rsi
	rep movsq
	movq	%rsi, %rdx
	movq	%rdi, %rax
	movzwl	(%rdx), %ecx
	movw	%cx, (%rax)
	leaq	2(%rax), %rax
	leaq	2(%rdx), %rdx
	movq	-248(%rbp), %rax
	movl	$.LC2, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rdx
	leaq	-224(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$202, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	-232(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L2
	call	__stack_chk_fail
.L2:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	write_database, .-write_database
	.section	.rodata
.LC3:
	.string	"Lendo estrutura do banco %s\n"
.LC4:
	.string	"r"
	.align 8
.LC5:
	.string	"version: %i\nauthor:%s\ncharset:%s\n"
	.text
	.globl	read_database
	.type	read_database, @function
read_database:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$256, %rsp
	movq	%rdi, -248(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-248(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	movq	-248(%rbp), %rax
	movl	$.LC4, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rdx
	leaq	-224(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$202, %esi
	movq	%rax, %rdi
	call	fread
	movzwl	-224(%rbp), %eax
	cwtl
	leaq	-224(%rbp), %rdx
	leaq	122(%rdx), %rcx
	leaq	-224(%rbp), %rdx
	addq	$2, %rdx
	movl	%eax, %esi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	movq	-232(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L4
	call	__stack_chk_fail
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	read_database, .-read_database
	.section	.rodata
	.align 8
.LC6:
	.string	"Informe o nome do arquivo para salvar a estrutura do banco"
.LC7:
	.string	"read"
.LC8:
	.string	"write"
	.text
	.globl	main
	.type	main, @function
main:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	cmpl	$2, -20(%rbp)
	jg	.L6
	movl	$.LC6, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L6:
	movq	-32(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-32(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L7
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	read_database
	jmp	.L8
.L7:
	movq	-8(%rbp), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L8
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	write_database
.L8:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.1) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
