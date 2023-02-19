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
    titulo          db  "Agenda de Contatos ( Versão 1.0.0 )", NULL
    nome_label      db  "Nome: ", NULL
    sep             db  "--------------------------------------------------------------------------", NULL
    seu_nome        db  "Seu nome: ", NULL
    BUFFER_LEN  equ 100
    param_label     db "Parâmetros: ", NULL
    str_newline     db LF




section .bss
    buffer: resb BUFFER_LEN
    argc            resq 1
    argv            resq 1

section .text
    global _start

_start:
    ; Salva argc e argv
    mov [argc], rsp
    mov rax, [rsp + 8]
    mov [argv], rax

    ; imprime título
    mov rdi, titulo
    call println

    call newline

    mov rdi, param_label
    call println

    ; Imprime parâmetros
    mov rdi, [argv]
    call println

    call newline
    call newline

    mov rdi, nome_label
    call print

    mov rdi, buffer
    mov rsi, BUFFER_LEN
    call readln

    mov rdi, sep
    call println

    mov rdi, seu_nome
    call print

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
print:
    push rbp                ; prólogo
    mov rbp, rsp
    sub rsp, 24             ; aloca 2 variáveis msg e msgLen

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

;
; println
; rdi -> mensagem
;
println:
    push rbp            ; prólogo
    mov rbp, rsp
    sub rsp, 8          ; variável LF

    ; usa os mesmos parâmetros recebidos
    call print

    ; write LF
    mov rax, SYS_WRITE      ; syscall sys_write
    mov rdi, STD_OUT        ; saída padrão
    mov byte[rbp-8], LF
    lea rsi, [rbp-8]       ; msg imprimir
    mov rdx, 1             ; tamanho da msg
    syscall

    mov rsp, rbp            ; epílogo
    pop rbp
    ret


;
; newline
;
newline:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    sub rsp, 1                  ; aloca 1 byte na pilha
    mov byte[rsp], LF           ; armazena LF
    mov rsi, rsp                ; mov rsi, str_newline
    mov rdx, 1
    syscall
    add rsp, 1
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