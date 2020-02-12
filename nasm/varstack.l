     1                                  
     2                                  SYS_WRITE       equ  4
     3                                  SYS_EXIT        equ  1
     4                                  EXIT_SUCESS     equ  0
     5                                  STD_OUT         equ  1
     6                                  NULL            equ  0h
     7                                  CR              equ 10
     8                                  LF              equ 13
     9                                  
    10                                  section .text
    11                                      global _start
    12                                  
    13                                  _start:
    14 00000000 B80D000000                  mov eax, LF
    15 00000005 50                          push eax
    16                                  
    17 00000006 B80A000000                  mov eax, CR
    18 0000000B 50                          push eax
    19                                  
    20 0000000C B843000000                  mov eax, 'C'
    21 00000011 50                          push eax
    22                                  
    23 00000012 B842000000                  mov eax, 'B'
    24 00000017 50                          push eax
    25                                  
    26 00000018 B841000000                  mov eax, 'A'
    27 0000001D 50                          push eax
    28                                  
    29 0000001E 89E1                        mov ecx, esp
    30 00000020 B804000000                  mov eax, SYS_WRITE
    31 00000025 BB01000000                  mov ebx, STD_OUT
    32 0000002A BA0E000000                  mov edx, 14
    33 0000002F CD80                        int 0x80
    34                                  
    35                                  
    36                                  fim:
    37 00000031 B801000000                  mov eax, SYS_EXIT
    38 00000036 BB00000000                  mov ebx, EXIT_SUCESS
    39 0000003B CD80                        int 0x80    
