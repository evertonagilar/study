; Padrão chamada de função syscall x64
; --------------------------------
; rdi - first argument
; rsi - second argument
; rdx - third argument
; rcx - fourth argument
; r8 - fifth argument
; r9 - sixth

bits 64

; consts

%define SYS_WRITE       1
%define SYS_EXIT       60
%define STD_OUT         1
%define EXIT_SUCCESS    0
%define LF             10


section .data
    titulo_str              db "printargs - imprime os argumentos de linha de comando", 0h
    titulo_str_len          equ $ - titulo_str
    no_args_str             db "Não foi informado argumentos", 0h
    no_args_str_len         equ $ - no_args_str

section .bss
    argc   resd    1           

section .text

    global _start


_start:

    ; imprime o título do programa
    sub rsp, 16                             ; aloca espaço na pilha
    mov qword [rsp+8], titulo_str_len       ; primeiro a empilhar (size)
    mov qword [rsp], titulo_str             ; segundo empilhar (msg)
    call println
    add rsp, 16                             ; limpa a pilha

    ; salva o número de argumentos (que está na pilha) na variável argc
    pop rcx
    dec rcx
    add rsp, 8                              ; remove o nome do programa da pilha
    mov [argc], rcx

    ; verifica número de argumentos
    cmp rcx, 0
    jz sem_argumentos


    ; imprime cada argumento
print_arg:
    pop rax
    sub rsp, 16                             ; aloca espaço na pilha
    mov qword [rsp+8], 15                   ; primeiro a empilhar (size)
    mov qword [rsp], rax                    ; segundo empilhar (msg)
    call println
    add rsp, 16                             ; limpa a pilha
    mov rcx, [argc]
    dec rcx
    mov [argc], rcx
    cmp rcx, 0
    jnz print_arg
    jmp exit


sem_argumentos:
    ; imprime mensagem no_args_str
    sub rsp, 16                             ; aloca espaço na pilha
    mov qword [rsp+8], no_args_str_len      ; primeiro a empilhar (size)
    mov qword [rsp], no_args_str            ; segundo empilhar (msg)
    call println
    add rsp, 16                             ; limpa a pilha
    jmp exit


exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall


; *************** rotinas ***************


; imprime texto no console
; convenção de chamada: cdecl
; void println(char *msg, int size)
println:
    mov r10, rsp               ; salva a pilha 

    ; calcula o tamanho da string
    mov rax, [rsp+8]           ;titulo_str         
    sub rsp, 8
    mov [rsp], rax
    call strlen
    mov rdx, rax
    add rsp, 8

    ; print msg
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, [rsp+8]           ;titulo_str         
    syscall

    ; print LF
    mov rax, SYS_WRITE
    mov r9, LF
    push r9
    mov rsi, rsp
    mov rdx, 1
    syscall

    mov rsp, r10               ; restaura a pilha
    ret


; retorna tamanho da string
; convenção de chamada: cdecl
; void strlen(char *msg)
strlen:
    mov rdi, [rsp+8]            ; coloca o endereço da string em rdi e rsi
    mov rax, rdi
nextchar:    
    cmp byte [rax], 0h
    jz strlen_fim
    inc rax
    jmp nextchar
strlen_fim:
    sub rax, rdi
    ret

