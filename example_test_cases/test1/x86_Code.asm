%include "../include/helper_func.asm"

section .data
	i1 dd 0,0
	i2 dd 0,0
	i3 dd 0,0
	i4 dd 0,0
	i5 dd 0,0
	i6 dd 0,0
	i7 dd 0,0
	i8 dd 0,0
	i9 dd 0,0
	i10 dd 0,0
	i11 dd 0,0
	i12 dd 0,0
	i13 dd 0,0
	i14 dd 0,0
	i15 dd 0,0
	i16 dd 0,0
	i17 dd 0,0
	i18 dd 0,0
	i19 dd 0,0
	i20 dd 0,0
	stack_pointer dd 0,0

section .bss
	digitSpace resb 100
	digitSpacePos resb 8
	stack resb 1000000

section .text
	global _start

_start:
	call main
	mov rax,60
	mov rdi,0
	syscall
fibonacci:
	push rbp
	mov rbp,rsp
	pop_stack stack,stack_pointer,i1
	set_int i2,1
	equal_comp i3,i1,i2
	mov rax,[i3]
	mov rbx,0
	cmp rax,rbx
	je L_1
	set_int i4,1
	mov r8,[i4]
	pop rbp
	ret
	jmp L_2
L_1:
	set_int i5,2
	equal_comp i6,i1,i5
	mov rax,[i6]
	mov rbx,0
	cmp rax,rbx
	je L_2
	set_int i7,1
	mov r8,[i7]
	pop rbp
	ret
	jmp L_2
L_2:
	call pushing_algo
	set_int i8,1
	sub_int i9,i1,i8
	push_stack stack,stack_pointer,i9
	call fibonacci
	call popping_algo
	mov [i10],r8
	call pushing_algo
	set_int i11,2
	sub_int i12,i1,i11
	push_stack stack,stack_pointer,i12
	call fibonacci
	call popping_algo
	mov [i13],r8
	add_int i14,i10,i13
	mov r8,[i14]
	pop rbp
	ret
main:
	push rbp
	mov rbp,rsp
	set_int i15,1
	set_int_from_register i15,i15
	jmp L_3
L_3:
	set_int i16,50
	less_than i17,i15,i16
	mov rax,[i17]
	mov rbx,0
	cmp rax,rbx
	je L_4
	call pushing_algo
	push_stack stack,stack_pointer,i15
	call fibonacci
	call popping_algo
	mov [i18],r8
	print_int [i18]
	set_int i19,1
	add_int i15,i15,i19
	jmp L_3
L_4:
	pop rbp
	ret

popping_algo:
	pop_stack stack,stack_pointer,i1
	pop_stack stack,stack_pointer,i2
	pop_stack stack,stack_pointer,i3
	pop_stack stack,stack_pointer,i4
	pop_stack stack,stack_pointer,i5
	pop_stack stack,stack_pointer,i6
	pop_stack stack,stack_pointer,i7
	pop_stack stack,stack_pointer,i8
	pop_stack stack,stack_pointer,i9
	pop_stack stack,stack_pointer,i10
	pop_stack stack,stack_pointer,i11
	pop_stack stack,stack_pointer,i12
	pop_stack stack,stack_pointer,i13
	pop_stack stack,stack_pointer,i14
	pop_stack stack,stack_pointer,i15
	pop_stack stack,stack_pointer,i16
	pop_stack stack,stack_pointer,i17
	pop_stack stack,stack_pointer,i18
	pop_stack stack,stack_pointer,i19
	pop_stack stack,stack_pointer,i20
	ret

pushing_algo:
	push_stack stack,stack_pointer,i20
	push_stack stack,stack_pointer,i19
	push_stack stack,stack_pointer,i18
	push_stack stack,stack_pointer,i17
	push_stack stack,stack_pointer,i16
	push_stack stack,stack_pointer,i15
	push_stack stack,stack_pointer,i14
	push_stack stack,stack_pointer,i13
	push_stack stack,stack_pointer,i12
	push_stack stack,stack_pointer,i11
	push_stack stack,stack_pointer,i10
	push_stack stack,stack_pointer,i9
	push_stack stack,stack_pointer,i8
	push_stack stack,stack_pointer,i7
	push_stack stack,stack_pointer,i6
	push_stack stack,stack_pointer,i5
	push_stack stack,stack_pointer,i4
	push_stack stack,stack_pointer,i3
	push_stack stack,stack_pointer,i2
	push_stack stack,stack_pointer,i1
	ret
