; Hello world

section .data
    msg db "Hello World!!!", 0xA
    len equ $ - msg

section .text

global _start:

_start:
    mov eax, 4      ; SYS_WRITE
    mov ebx, 1      ; Saída padrão
    mov ecx, msg    ; string que deve mostrar
    mov edx, len    ; quantos caracteres mostrar
    int 0x80

    mov eax, 1      ; SYS_EXIT
    mov ebx, 0
    int 0x80





