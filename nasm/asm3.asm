section .text

global _start

_start:
    mov eax, 1          ; SYS_EXIT
    mov ebx, 2
    int 0x80

