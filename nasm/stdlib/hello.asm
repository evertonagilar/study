bits 64

%include "strutils.inc"

;Prólogo e epílogo:
;    push %rbp
;    mov %rsp, %rbp
;    sub $16, %rsp
;
;    # etc...
;
;    mov %rbp, %rsp
;    pop %rbp
;    ret

section .data
    titulo          db  "Agenda de Contatos ( Versão 1.0.0 )", LF, NULL
    nome_label      db  "Nome: ", NULL
    sep             db  "--------------------------------------------------------------------------", LF, NULL
    seu_nome        db  "Seu nome: ", NULL
    BUFFER_LEN  equ 100

section .bss
    buffer: resb BUFFER_LEN

section .text
    global _start

_start:
    ; imprime título
    mov rdi, titulo
    call println

    mov rdi, nome_label
    call println

    mov rdi, buffer
    mov rsi, BUFFER_LEN
    call readln

    mov rdi, sep
    call println

    mov rdi, seu_nome
    call println

    mov rdi, buffer
    call println

    call finaliza
    ret


lenstr:
    mov rax, rdi            ; copia endereco msg para rax
.checkNullStr:
    cmp byte[rax], NULL     ; chegou \0
    je .exitLen
    inc rax
    jmp .checkNullStr
.exitLen:
    sub rax, rdi
    ret

;
; println
; rdi -> mensagem
;
println:
    push rbp                ; prólogo
    mov rbp, rsp
    sub rsp, 16             ; aloca 2 variáveis msg e msgLen

    mov [rbp-8], rdi        ; variável msg
    mov qword [rbp-16], 0   ; inicializa variavel tamanho

    ; calcula tamanho da msg
    mov rdi, [rbp-8]
    call lenstr
    mov [rbp-16], rax       ; variável tamanho msg

    ; write
    mov rax, SYS_WRITE      ; syscall sys_write
    mov rdi, STD_OUT        ; saída padrão
    mov rsi, [rbp-8]        ; msg imprimir
    mov rdx, [rbp-16]       ; tamanho da msg
    syscall

    mov rsp, rbp            ; epílogo
    pop rbp
    ret

readln:
    push rsi
    push rdi
    mov rax, SYS_READ
    mov rdi, STD_IN
    pop rsi
    pop rdx
    syscall
    ret


finaliza:
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall
    ret