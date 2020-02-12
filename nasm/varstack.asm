
SYS_WRITE       equ  4
SYS_EXIT        equ  1
EXIT_SUCESS     equ  0
STD_OUT         equ  1
NULL            equ  0h
CR              equ 10
LF              equ 13

section .text
    global _start

_start:
    mov eax, LF
    push eax

    mov eax, CR
    push eax

    mov eax, 'C'
    push eax

    mov eax, 'B'
    push eax

    mov eax, 'A'
    push eax

    mov ecx, esp
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov edx, 14
    int 0x80


fim:
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCESS
    int 0x80    