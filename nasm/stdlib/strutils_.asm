
segment .data
    msg     db "teste", 0xA, 0
    tam     equ $ - msg


section .text
    global lee_strlen
    global lee_strlen2
    global lee_test


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
; Recebe char* em RDI e retorna comprimento em rax
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

