
; syscall table
SYS_WRITE 	equ		1			
SYS_EXIT  	equ 	60

; entrada/saida padrão
STD_IN	  	equ 	0
STD_OUT   	equ		1

; outras contantes
EXIT_CODE	equ 	0
NEW_LINE	equ 	0xa



section .data
	msg db "Ola mundo Linux"
	len equ $ - msg
	

section .text
	global _start


; chamada de função
; --------------------------------
; rdi - first argument
; rsi - second argument
; rdx - third argument
; rcx - fourth argument
; r8 - fifth argument
; r9 - sixth

; syscall 
; --------------------------------
; rax - temporary register; when we call a syscal, rax must contain syscall number
; rdi - used to pass 1st argument to functions
; rsi - pointer used to pass 2nd argument to functions
; rdx - used to pass 3rd argument to functions

_start:
	call escreve_tela
	jmp fim

fim:
	mov eax, SYS_EXIT	
	mov rdi, 0
	syscall


escreve_tela:
	mov rax, SYS_WRITE   ; sys_write
	mov rdi, STD_OUT     ; saída padrão
	mov rsi, msg	
	mov rdx, len
	syscall
	ret

	
    

