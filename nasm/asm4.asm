SYS_EXIT    equ 1
SYS_WRITE   equ 4
SYS_OUT     equ 1

section .data

    x dd 50   ; 4 bytes
    y dd 10
    msg1 db 'X maior que Y', 0xa
    len1 equ $ - msg1
    msg2 db 'Y maior que X', 0xa
    len2 equ $ - msg2


section .text
    global _start

_start:
    mov eax, DWORD [x]
    mov ebx, DWORD [y]
    cmp eax, ebx
    jge x_maior

y_maior:
    mov eax, SYS_WRITE
    mov ebx, SYS_OUT
    mov ecx, msg2
    mov edx, len2
    jmp fim
    int 0x80

x_maior:
    mov eax, SYS_WRITE
    mov ebx, SYS_OUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

fim:
    mov eax, SYS_EXIT
    mov ebx, 1
    int 0x80





