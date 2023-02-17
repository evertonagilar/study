segment .data

NULL            equ     0x0
CR              equ     0xD
LF              equ     0xA
EXIT_SUCCESS    equ     0x0


; IO

STD_IN      equ     0
STD_OUT     equ     1
STD_ERR     equ     2


; Kernel syscalls

SYS_READ    equ     0x0
SYS_WRITE   equ     0x1
SYS_EXIT    equ     0x3c

