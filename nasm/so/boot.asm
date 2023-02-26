org 0x7c00

bits 16

; loop:
;     mov al, 'E'
;     call print_char
;     jmp loop

start:
    mov si, message
    call print
    jmp $

print:
    lodsb
    cmp al, 0
    je .printExit
    call print_char
    jmp print
.printExit:
    ret

print_char:
    mov bx, 0
    mov ah, 0eh    
    int 0x10
    ret


; print:
;     mov bx, 0
; .loop:
;     lodsb
;     cmp al, 0
;     je .done
;     call print_char
;     jmp .loop
; .done:    
;     ret

; print_char:
;     mov ah, 0eh
;     int 0x10
;     ret

message db "Sistema Operacional", 0x10, 0

times 510 -($ - $$) db 0


db 0x55
db 0xAA