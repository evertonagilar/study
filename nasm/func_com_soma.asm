; padrão chamada de função syscall
; --------------------------------
; rdi - first argument
; rsi - second argument
; rdx - third argument
; rcx - fourth argument
; r8 - fifth argument
; r9 - sixth

bits 64

; syscall table
SYS_EXIT  	equ 	60


section .text
    global _start

_start:
    mov rdi, 2
    call f
    
fim:
    mov rdi, rax
    mov rax, SYS_EXIT
    syscall

f:
    lea rax, [rdi+rdi]    ; usei lea para somar o primeiro parâmetro (rdi)
    ret
