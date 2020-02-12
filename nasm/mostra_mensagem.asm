SYS_WRITE   equ 1
STD_OUT     equ 1

; chamada de função
; --------------------------------
; rdi - first argument
; rsi - second argument
; rdx - third argument
; rcx - fourth argument
; r8 - fifth argument
; r9 - sixth

global mostra_mensagem

section .text

; Função: mostra_mensagem
; Argumentos:
;       rdi -> string que será exibido
;       rsi -> len da string
mostra_mensagem:
    mov r10, rdi        ; armazena ponteiro da strng em r10
    mov r11, rsi        ; armazena len da string em r11
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, r10
    mov rdx, r11
    syscall
    ret
    