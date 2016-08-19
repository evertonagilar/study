     1                                  ; hello_64.asm    print a string using printf
     2                                  ; Assemble:	  nasm -f elf64 -l hello_64.lst  hello_64.asm
     3                                  ; Link:		  gcc -m64 -o hello_64  hello_64.o
     4                                  ; Run:		  ./hello_64 > hello_64.out
     5                                  ; Output:	  cat hello_64.out
     6                                  
     7                                  ; Equivalent C code
     8                                  ; // hello.c
     9                                  ; #include <stdio.h>
    10                                  ; int main()
    11                                  ; {
    12                                  ;   char msg[] = "Hello world\n";
    13                                  ;   printf("%s\n",msg);
    14                                  ;   return 0;
    15                                  ; }
    16                                  	
    17                                  ; Declare needed C  functions
    18                                          extern	printf		; the C function, to be called
    19                                  
    20                                          section .data		; Data section, initialized variables
    21 00000000 48656C6C6F20776F72-     msg:	db "Hello world", 0	; C string needs 0
    22 00000009 6C6400             
    23 0000000C 25730A00                fmt:    db "%s", 10, 0          ; The printf format, "\n",'0'
    24                                  
    25                                          section .text           ; Code section.
    26                                  
    27                                          global main		; the standard gcc entry point
    28                                  main:				; the program label for the entry point
    29 00000000 55                              push    rbp		; set up stack frame, must be alligned
    30                                  	
    31 00000001 48BF-                   	mov	rdi,fmt
    32 00000003 [0C00000000000000] 
    33 0000000B 48BE-                   	mov	rsi,msg
    34 0000000D [0000000000000000] 
    35 00000015 B800000000              	mov	rax,0		; or can be  xor  rax,rax
    36 0000001A E8(00000000)                call    printf		; Call C function
    37                                  
    38 0000001F 5D                      	pop	rbp		; restore stack
    39                                  
    40 00000020 B800000000              	mov	rax,0		; normal, no error, return value
    41 00000025 C3                      	ret			; return
