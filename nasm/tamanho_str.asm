%include "functions.asm"

section .data
    msg     db  "minha string bonita", NULL
    msg1    db  "aqui1", NULL

section .code
    global _start

_start:
    mov rsi, msg
    call strlen
    mov ebx, eax
    mov eax, 1
    int 0x80