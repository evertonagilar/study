bits 64

section .data
    msg     db "Ola Mundo", 0xA, 0
    tam     equ $ - msg

section .text
    global lee_strlen
    global lee_strlen2
    global _start

_start:
    mov eax, 4          ; escreve
    mov ebx, 1          ; em stdout
    mov ecx, msg        ; a mensagem msg
    mov edx, tam        ; de tamanho tam
    int 0x80

    mov eax, 1          ; sai do programa
    mov ebx, 0          ; com código retorno 0
    int 0x80
