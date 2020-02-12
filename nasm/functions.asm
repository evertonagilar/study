; Padrão chamada de função syscall
; --------------------------------
; rdi - first argument
; rsi - second argument
; rdx - third argument
; rcx - fourth argument
; r8 - fifth argument
; r9 - sixth

; 0x80
SYS_WRITE           equ  4
SYS_EXIT            equ  1


; Syscalls table
SYSCALL_WRITE       equ  1
SYSCALL_EXIT        equ  60

; Constantes
EXIT_SUCESS         equ  0
STD_OUT             equ  1
NULL                equ  0h
CR                  equ 10
LF                  equ 13



; int strlen(char[] msg)
; msg -> rsi
; result -> rax
; computa o tamanho da string com aritmética de ponteiros
strlen:
    push r10                ; salva registradores
    push r11
    mov r10, rsi            ; r10 e r11 apontam para msg
    mov r11, r10
next_char:
    cmp byte [r11], NULL    ; chegou no fim da string?
    jz fim                  ; se fim, termina função
    inc r11                 ; próximo caractere
    jmp next_char
fim:
    sub r11, r10
    mov rax, r11
    pop r11                 ; volta registradores
    pop r10
    ret



; void print(char[] msg)
; rsi -> msg
print:
    push rdx
    push rax
    push rbx
    push rcx
    call strlen        ; pega tamanho string 

    mov edx, eax        ; e coloca em edx
    mov eax, SYS_WRITE  
    mov ebx, STD_OUT
    mov rcx, rsi
    int 0x80

    pop rcx
    pop rbx
    pop rax
    pop rdx
    ret


; void println(char[] msg)
; rsi -> msg
println:
    call print      ; imprime a mensagem 
    mov rax, CR
    push rax
    mov rax, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax
    ret


;println_:
;    call print
;    mov rsi, CRLF
;    call print
;    ret



; termina aplicação
exit_application:
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_SUCESS
    syscall
    ret
