; mostra uma mensagem na tela e usa strlen para computar o tamanho da string

SYS_WRITE       equ 4
SYS_EXIT        equ 1
EXIT_SUCESS     equ 0
STD_OUT         equ 1

section .data
    msg:           db "Ola, eu fui executado em um programa assembly!!!", 0Ah
        .len       equ $ - msg

section .code
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    mov ecx, msg
    ;mov edx, msg.len
    call str_len
    int 0x80

fim:
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCESS
    int 0x80    


; computa o tamanho da string com aritmética de ponteiros
str_len:
    push rax
    push rbx
    mov ebx, msg        ; r10 e r11 apontam para msg
    mov eax, ebx
next_char:
    cmp byte [eax], 0   ; chegou no fim da string?
    jz str_len_fim      ; se fim, termina função
    inc eax             ; próximo caractere
    jmp next_char
str_len_fim:
    sub eax, ebx
    mov edx, eax
    pop rbx
    pop rax
    ret

