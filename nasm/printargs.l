     1                                  ; Padrão chamada de função syscall
     2                                  ; --------------------------------
     3                                  ; rdi - first argument
     4                                  ; rsi - second argument
     5                                  ; rdx - third argument
     6                                  ; rcx - fourth argument
     7                                  ; r8 - fifth argument
     8                                  ; r9 - sixth
     9                                  
    10                                  
    11                                  ; consts
    12                                  
    13                                  %define SYS_WRITE       1
    14                                  %define SYS_EXIT       60
    15                                  %define STD_OUT         1
    16                                  %define EXIT_SUCCESS    6
    17                                  %define LF             10
    18                                  
    19                                  
    20                                  section .data
    21 00000000 7072696E7461726773-         titulo_str              db "printargs - imprime os argumentos", 0h
    21 00000009 202D20696D7072696D-
    21 00000012 65206F732061726775-
    21 0000001B 6D656E746F7300     
    22                                      titulo_str_len          equ $ - titulo_str
    23                                  
    24                                  section .code
    25                                  
    26                                      global _start
    27                                  
    28                                  _start:
    29 00000000 4883EC10                    sub rsp, 16                     ; aloca espaço na pilha
    30 00000004 C744240822000000            mov dword [rsp+8], titulo_str_len     ; primeiro a empilhar (size)
    31 0000000C 48BC-                       mov rsp, titulo_str             ; segundo empilhar (msg)
    31 0000000E [0000000000000000] 
    32 00000016 E806000000                  call println
    33 0000001B 4883C410                    add rsp, 16                     ; limpa a pilha
    34 0000001F EB2B                        jmp exit
    35                                  
    36                                  
    37                                  
    38                                  ; imprime texto no console
    39                                  ; convenção de chamada: cdel
    40                                  ; void println(char *msg, int size)
    41                                  println:
    42 00000021 B801000000                  mov rax, SYS_WRITE
    43 00000026 BF01000000                  mov rdi, STD_OUT
    44 0000002B 488B742408                  mov rsi, [rsp+8]
    45 00000030 488B542410                  mov rdx, [rsp+16]
    46 00000035 0F05                        syscall
    47 00000037 41B90A000000                mov r9, LF
    48 0000003D 4151                        push r9
    49 0000003F 4889E6                      mov rsi, rsp
    50 00000042 BA01000000                  mov rdx, 1
    51 00000047 0F05                        syscall
    52 00000049 4159                        pop r9
    53 0000004B C3                          ret
    54                                  
    55                                  
    56                                  exit:
    57 0000004C B83C000000                  mov rax, SYS_EXIT
    58 00000051 BF06000000                  mov rdi, EXIT_SUCCESS
    59 00000056 0F05                        syscall
