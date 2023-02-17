%include "strutils.inc"


section .data
    msg     db "teste", 0xA, NULL
    tam     equ $ - msg


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


section .text
    global lee_strlen
    global lee_println
    global lee_print
    global lee_exit
    global lee_test
    global lee_start
    global lee_strcpy
    global strcpy_asm_x64

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
    cmp byte[eax], NULL
    je .end_str
    inc rax
    jmp .next_char
.end_str:
    sub rax, rdi
    ret


strcpy_asm_x64:
	mov  r8b, BYTE[rdx] ; rdx = source
	test r8b, r8b
	mov  rax, rcx ; rax = destination
	je   label2
label1:
	mov  BYTE[rax], r8b
	mov  r8b, BYTE[rdx+1]
	inc  rax
	inc  rdx
	test r8b, r8b
	jne  label1
label2:
	mov  BYTE[rax], 0
	; could set rax to rcx if wanting to return the destination pointer instead of a pointer to the end of destination
	ret  0

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
; char* lee_strcpy(char *destination, char *source);
lee_strcpy:
.copy_char:
    mov ax, word[rsi]       ; move char para rax
    mov word [rdi], ax            ; e para [rdi]
    cmp ax, NULL           ; chegou no null
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
