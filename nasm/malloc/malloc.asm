;; Filename:	demo.asm
;; Developer:	Bryant Keller
;; Purpose:	To show dearhuseyin how a dynamic array in NASM might work.
;; Build:
;; 	Assemble:	nasm -f elf demo.asm -o demo.o
;; 	Link:		gcc demo.o -o demo
;; 	Execute:	./demo

bits 32
cpu 486

	extern printf
	extern malloc
	extern realloc
	extern free

	;; In this example, we will create a dynamic array. Because it's
	;; dynamic, we need a method to keep track of the number of elements
	;; in the array. This way, we can tell if we need to resize the array.
	struc DARRAY
	.ptr: resd 1	; Pointer to our block of memory. (contents of the array)
	.count: resd 1	; Number of elements currently allocated.
	endstruc

section .rodata

	;; This is a linux system, so I put my format strings in the
	;; read-only data section. GCC/LD likes this.

fmt:	DB "[%d] = %d", 10, 0

section .bss

	;; We will place our dynamic array variable and a global index
	;; into the unintialized data section. That way it doesn't actually
	;; add to the size of our executable, it'll be created at runtime.

myArray: resb DARRAY_size
index: resd 1

section .text

	;; We start our program with the main procedure. Since we will be using
	;; printf, we want to make sure that C produces it's startup code.

	global main

main:	push ebp
	mov ebp, esp

	;; Our dynamic array will contain 10 elements.
	mov eax, 10
	mov dword [myArray + DARRAY.count], eax

	;; Each element will be treated as an integer. (eg. count * sizeof(int))
	sal eax, 2

	;; We allocate our elements on the heap.
	push eax
	call malloc
	add esp, 4

	;; And we save a pointer to the first element in our array.
	mov dword [myArray + DARRAY.ptr], eax

	;; We initialize our array's index to zero.
	mov dword [index], 0

	;; And immediately jump to our comparison.
	jmp for_loop_1.compare

for_loop_1:

	;; This is our "For Loop" body.

	;; First we obtain the pointer to our array...
	mov eax, dword [myArray + DARRAY.ptr]

	;; .. and the current value of our index.
	mov edx, dword [index]

	;; We now get the address of the nth element of our array. (eg. array[index])
	sal edx, 2 ; index * sizeof(int)
	lea edx, [eax + edx]

	;; And we store the current index in it. 
	mov eax, dword [index]
	mov dword [edx], eax

	;; And finally we increment our index.
	inc dword [index]

.compare:
	;; If the index is less than the array's size, we continue.
	mov edx, dword [index]
	mov eax, dword [myArray + DARRAY.count]
	cmp edx, eax
	jb for_loop_1

	;; Once we've looped through all 10 elements, we've decide to add 3 more.

	;; Add 3 to our count...
	mov eax, dword [myArray + DARRAY.count]
	add eax, 3
	mov dword [myArray + DARRAY.count], eax

	;;... then update adjust the count to byte size. (eg. count * sizeof(int))
	sal eax, 2

	;; We reallocate our heap for the 3 extra elements.
	push eax
	push dword [myArray + DARRAY.ptr]
	call realloc
	add esp, 8

	;; And update our pointer.
	mov dword [myArray + DARRAY.ptr], eax

	;; Now we continue updating values.
	jmp for_loop_2.compare

	;; This for loop is just like the last one, except that
	;; we don't zero initialize our index. In this loop, we
	;; will start from where we left off.

for_loop_2:
	mov eax, dword [myArray + DARRAY.ptr]
	mov edx, dword [index]
	sal edx, 2
	lea edx, [eax + edx]
	mov eax, dword [index]
	mov dword [edx], eax
	inc dword [index]

.compare:
	mov edx, dword [index]
	mov eax, dword [myArray + DARRAY.count]
	cmp edx, eax
	jb for_loop_2

	;; Once we have updated all the elements, we need
	;; to start back over at the beginning, so we zero
	;; initialize index, and jump to our comparison.

	mov dword [index], 0
	jmp for_loop_3.compare

for_loop_3:
	;; This time, we grab the integer of the element at the current index.
	;; (eg. eax = array[index])
	mov eax, dword [myArray + DARRAY.ptr]
	mov edx, dword [index]
	sal edx, 2 ; edx = index * sizeof(int)
	add eax, edx ; eax = array[index]

	;; Now we will display the results to the screen.
	push dword [eax]	; array[index]
	push dword [index]	; index
	push dword fmt		; "[%d] = %d\n"
	call printf
	add esp, 12

	;; And we move on to the next element.
	inc dword [index]

.compare:
	;; Once again, if the index is less than the count
	;; we will continue.
	mov edx, dword [index]
	mov eax, dword [myArray + DARRAY.count]
	cmp edx, eax
	jb for_loop_3

	;; Once we have displayed the contents of the array, we no longer
	;; actually need it. Let's be good and free the memory.

	push dword [myArray + DARRAY.ptr]
	call free
	add esp, 4

	;; And finally we return an exit code of 0 (stdlib.h, EXIT_SUCCESS)
	mov eax, 0
	leave
	ret
