     1                                  ; Padrão chamada de função syscall x64
     2                                  ; --------------------------------
     3                                  ; rdi - first argument
     4                                  ; rsi - second argument
     5                                  ; rdx - third argument
     6                                  ; rcx - fourth argument
     7                                  ; r8 - fifth argument
     8                                  ; r9 - sixth
     9                                  
    10                                  bits 64
    11                                  
    12                                  ; consts
    13                                  
    14                                  %define SYS_WRITE       1
    15                                  %define SYS_EXIT       60
    16                                  %define STD_OUT         1
    17                                  %define EXIT_SUCCESS    0
    18                                  %define LF             10
    19                                  
    20                                  
    21                                  section .data
    22 00000000 7072696E7461726773-         titulo_str              db "printargs - imprime os argumentos de linha de comando", 0h
    22 00000009 202D20696D7072696D-
    22 00000012 65206F732061726775-
    22 0000001B 6D656E746F73206465-
    22 00000024 206C696E6861206465-
    22 0000002D 20636F6D616E646F00 
    23                                      titulo_str_len          equ $ - titulo_str
    24 00000036 4EC3A36F20666F6920-         no_args_str             db "Não foi informado argumentos", 0h
    24 0000003F 696E666F726D61646F-
    24 00000048 20617267756D656E74-
    24 00000051 6F7300             
    25                                      no_args_str_len         equ $ - no_args_str
    26                                  
    27                                  section .bss
    28 00000000 <res 00000004>              argc   resd    1           
    29                                  
    30                                  section .code
    31                                  
    32                                      global _start
    33                                  
    34                                  
    35                                  _start:
    36                                     
    37                                      ; imprime o título do programa
    38 00000000 4883EC10                    sub rsp, 16                             ; aloca espaço na pilha
    39 00000004 48C744240836000000          mov qword [rsp+8], titulo_str_len       ; primeiro a empilhar (size)
    40 0000000D 48C70424[00000000]          mov qword [rsp], titulo_str             ; segundo empilhar (msg)
    41 00000015 E878000000                  call println
    42 0000001A 4883C410                    add rsp, 16                             ; limpa a pilha
    43                                  
    44                                      ; salva o número de argumentos (que está na pilha) na variável argc
    45 0000001E 59                          pop rcx
    46 0000001F 48FFC9                      dec rcx
    47 00000022 48890C25[00000000]          mov [argc], rcx
    48                                  
    49                                      ; verifica número de argumentos
    50 0000002A 4883F900                    cmp rcx, 0
    51 0000002E 7436                        jz sem_argumentos
    52                                  
    53                                  
    54                                      ; imprime cada argumento
    55                                  print_arg:
    56 00000030 58                          pop rax
    57 00000031 4883EC10                    sub rsp, 16                             ; aloca espaço na pilha
    58 00000035 48C74424080F000000          mov qword [rsp+8], 15                    ; primeiro a empilhar (size)
    59 0000003E 48890424                    mov qword [rsp], rax                    ; segundo empilhar (msg)
    60 00000042 E84B000000                  call println
    61 00000047 4883C410                    add rsp, 16                             ; limpa a pilha
    62 0000004B 488B0C25[00000000]          mov rcx, [argc]
    63 00000053 48FFC9                      dec rcx
    64 00000056 48890C25[00000000]          mov [argc], rcx
    65 0000005E 4883F900                    cmp rcx, 0
    66 00000062 75CC                        jnz print_arg
    67 00000064 EB20                        jmp exit
    68                                  
    69                                  
    70                                  sem_argumentos:
    71                                      ; imprime mensagem no_args_str
    72 00000066 4883EC10                    sub rsp, 16                             ; aloca espaço na pilha
    73 0000006A 48C74424081E000000          mov qword [rsp+8], no_args_str_len      ; primeiro a empilhar (size)
    74 00000073 48C70424[36000000]          mov qword [rsp], no_args_str            ; segundo empilhar (msg)
    75 0000007B E812000000                  call println
    76 00000080 4883C410                    add rsp, 16                             ; limpa a pilha
    77 00000084 EB00                        jmp exit
    78                                  
    79                                  
    80                                  exit:
    81 00000086 B83C000000                  mov rax, SYS_EXIT
    82 0000008B BF00000000                  mov rdi, EXIT_SUCCESS
    83 00000090 0F05                        syscall
    84                                  
    85                                  
    86                                  ; *************** rotinas ***************
    87                                  
    88                                  
    89                                  ; imprime texto no console
    90                                  ; convenção de chamada: cdecl
    91                                  ; void println(char *msg, int size)
    92                                  println:
    93 00000092 4989E2                      mov r10, rsp               ; salva a pilha 
    94                                  
    95                                      ; print msg
    96 00000095 B801000000                  mov rax, SYS_WRITE
    97 0000009A BF01000000                  mov rdi, STD_OUT
    98 0000009F 488B742408                  mov rsi, [rsp+8]           ;titulo_str         
    99 000000A4 488B542410                  mov rdx, [rsp+16]          ;titulo_str_len     
   100 000000A9 0F05                        syscall
   101                                  
   102                                      ; print LF
   103 000000AB B801000000                  mov rax, SYS_WRITE
   104 000000B0 41B90A000000                mov r9, LF
   105 000000B6 4151                        push r9
   106 000000B8 4889E6                      mov rsi, rsp
   107 000000BB BA01000000                  mov rdx, 1
   108 000000C0 0F05                        syscall
   109                                  
   110 000000C2 4C89D4                      mov rsp, r10               ; restaura a pilha
   111 000000C5 C3                          ret
   112                                  
   113                                  
