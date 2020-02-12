SYS_WRITE   equ 4
STD_OUT     equ 1

section .data

    v1 dw '5', 0xa

section .text
    global _start

_start:
    call converte_valor

    mov ecx, v1
    call write_char

    mov eax, 1
    mov ebx, 0
    int 0x80


converte_valor:
    mov eax, [v1]
    sub eax, '0'                ; converte para inteiro
    add eax, 1
    add eax, '0'                ; converte para caractere
    mov [v1], eax
    ret

write_char:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov edx, 1
    int 0x80
    ret

