; mostra uma mensagem na tela e usa strlen para computar o tamanho da string

%include "functions.asm"

SYS_WRITE       equ 4
SYS_EXIT        equ 1
EXIT_SUCESS     equ 0
STD_OUT         equ 1

section .data
    msg         db "Ola, eu fui executado em um programa assembly que tem biblioteca!!!", 0Ah
    aqui1       db "aqui1", 0Ah
    aqui2       db "aqui2", 0Ah
    aqui3       db "aqui3", 0Ah

section .code
    global _start

_start:
    ;mov rsi, aqui1
    ;call println

    mov rsi, msg
    call println

    ;mov rsi, aqui2
    ;call println

    call exit_application

    ;mov rsi, aqui3
    ;call println




