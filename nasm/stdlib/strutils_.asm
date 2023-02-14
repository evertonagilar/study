%include "strutils.inc"


segment .data
    msg     db "teste", 0xA, 0
    tam     equ $ - msg


section .text
    global lee_strlen
    global lee_println
    global lee_print
    global lee_exit
    global lee_test
    global lee_start
    global lee_strcpy

    extern main


lee_test:
    mov eax, 4          ; escreve
    mov ebx, 1          ; em stdout
    mov ecx, msg        ; a mensagem msg
    mov edx, tam        ; de tamanho tam
    int 0x80

    mov eax, 1          ; sai do programa
    mov ebx, 0          ; com código retorno 0
    int 0x80

;
; Recebe char* em rdi e retorna comprimento em rax
;
lee_strlen:
    mov rax, rdi
.next_char:    
    cmp word[eax], 0    ; funciona porque word é um char (16 bits)
    je .end_str
    inc rax
    jmp .next_char
.end_str:    
    sub rax, rdi
    ret

; 
; Função: lee_print
; Objetivo: imprime string na saída padrão
; Params: rdi -> ponteiro para string
; Retorno: nada
lee_print:
    call lee_strlen         ; calcula o tamanho da string que rdi aponta
    mov rdx, rax            ; move o tamanho calculado para rdx (parametro 2 syscall)
    mov rsi, rdi            ; buffer para a string (parâmetro 1 da syscall)
    mov rax, SYS_WRITE      ; syscall write do linux    
    mov rdi, STD_OUT        ; fd = 1 saída padrão (parâmetro 0 da syscall)
    syscall
    ret


; 
; Função: lee_strcpy
; Objetivo: Copia o buffer origem para o buffer destino
; Params: rdi -> buffer destino
;         rsi -> buffer origem    
; Retorno: ponteiro para buffer destino
lee_strcpy:
.copy_char:
    mov ax, word[rsi]       ; move char para rax
    mov word[rdi], ax      ; e para [rdi]
    cmp eax, NULL           ; chegou no null
    je .end_copy            ; se sim, termino
    inc rsi                 ; senão incrementa rsi e rdi
    inc rdi
    jmp .copy_char          ; e continua copiando 
.end_copy:
    ret

; 
; Função: lee_exit
; Objetivo: sai do programa
; Params: rdi -> status
; Retorno: nada
lee_exit:
    mov rax, SYS_EXIT
    syscall
    ret


; 
; Função: função _start do excutável
; Objetivo: executa main e sai do programa
; Params: rdi -> status
; Retorno: nada
lee_start:
    call main
    call lee_exit
