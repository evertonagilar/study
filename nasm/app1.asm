; mostra uma mensagem na tela e usa strlen para computar o tamanho da string

bits 64

%include "functions.asm"

section .data
    msg         db "Eu sou o último biscoito do pacote", NULL
    aqui1       db "aqui1", NULL
    aqui2       db "aqui2", NULL
    aqui3       db "aqui3", NULL

section .text
    global _start

_start:
    ;mov rsi, aqui1
    ;call println

    mov rsi, msg
    call println

    ;mov rsi, aqui2
    ;call println

    call exit_application





