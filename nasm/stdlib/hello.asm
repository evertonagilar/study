bits 64

segment .data
NULL            equ     0x0
CR              equ     0xD
LF              equ     0xA
EXIT_SUCCESS    equ     0x0
STD_IN      equ     0
STD_OUT     equ     1
STD_ERR     equ     2
SYS_READ    equ     0x0
SYS_WRITE   equ     0x1
SYS_EXIT    equ     0x3c

section .data
    titulo          db  "Feliz Carnaval Gurizada!!!", NULL
    str_newline     db LF
section .text
    global _start
_start:
    ; imprime título
    mov rdi, titulo
    call println
    call newline
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