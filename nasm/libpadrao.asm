
; constantes
SYS_WRITE equ   1
STD_OUT   equ   1

escreve:
        mov rax, SYS_WRITE   ; sys_write
        mov rdi, STD_OUT     ; saída padrão
        mov rsi, msg    
        mov rdx, len
        syscall
	ret


