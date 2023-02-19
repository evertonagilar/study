bits 16

org 0x100

mov ah, 0x0e
mov al, 'H'
int 0x10
mov al, 'i'
int 0x10

ret


