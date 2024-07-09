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
	i21 dd 0,0
	i22 dd 0,0
	i23 dd 0,0
	i24 dd 0,0
	i25 dd 0,0
	i26 dd 0,0
	i27 dd 0,0
	i28 dd 0,0
	i29 dd 0,0
	i30 dd 0,0
	i31 dd 0,0
	i32 dd 0,0
	i33 dd 0,0
	i34 dd 0,0
	i35 dd 0,0
	i36 dd 0,0
	i37 dd 0,0
	i38 dd 0,0
	i39 dd 0,0
	i40 dd 0,0
	i41 dd 0,0
	i42 dd 0,0
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
maximum_list:
	push rbp
	mov rbp,rsp
	pop_stack stack,stack_pointer,i1
	pop_stack stack,stack_pointer,i2
	set_int i3,0
	set_int_from_register i3,i3
	set_int i4,0
	set_int_from_register i4,i4
	jmp L_1
L_1:
	less_than i5,i3,i2
	mov rax,[i5]
	mov rbx,0
	cmp rax,rbx
	je L_2
	access_list i6,i1,i3
	less_than i7,i4,i6
	mov rax,[i7]
	mov rbx,0
	cmp rax,rbx
	je L_3
	access_list i8,i1,i3
	set_int_from_register i4,i8
	jmp L_3
L_3:
	set_int i9,1
	add_int i3,i3,i9
	jmp L_1
L_2:
	mov r8,[i4]
	pop rbp
	ret
minimum_list:
	push rbp
	mov rbp,rsp
	pop_stack stack,stack_pointer,i10
	pop_stack stack,stack_pointer,i11
	set_int i12,0
	set_int_from_register i12,i12
	set_int i13,0
	set_int_from_register i13,i13
	jmp L_4
L_4:
	less_than i14,i12,i11
	mov rax,[i14]
	mov rbx,0
	cmp rax,rbx
	je L_5
	access_list i15,i10,i12
	greater_than i16,i13,i15
	mov rax,[i16]
	mov rbx,0
	cmp rax,rbx
	je L_6
	access_list i17,i10,i12
	set_int_from_register i13,i17
	jmp L_6
L_6:
	set_int i18,1
	add_int i12,i12,i18
	jmp L_4
L_5:
	mov r8,[i13]
	pop rbp
	ret
mean_list:
	push rbp
	mov rbp,rsp
	pop_stack stack,stack_pointer,i19
	pop_stack stack,stack_pointer,i20
	set_int i21,0
	set_int_from_register i21,i21
	set_int i22,0
	set_int_from_register i22,i22
	jmp L_7
L_7:
	less_than i23,i22,i20
	mov rax,[i23]
	mov rbx,0
	cmp rax,rbx
	je L_8
	access_list i24,i19,i22
	add_int i21,i21,i24
	set_int i25,1
	add_int i22,i22,i25
	jmp L_7
L_8:
	div_int i26,i21,i20
	mov r8,[i26]
	pop rbp
	ret
main:
	push rbp
	mov rbp,rsp
	set_int i27,1
	set_int i28,2
	set_int i29,3
	set_int i30,4
	set_int i31,5
	set_int i32,6
	set_int i33,7
	set_int i34,8
	set_int i35,9
	set_int i36,10
	set_pointer i37,i27
	set_int i38,10
	set_int_from_register i38,i38
	call pushing_algo
	push_stack stack,stack_pointer,i38
	push_stack stack,stack_pointer,i37
	call maximum_list
	call popping_algo
	mov [i39],r8
	print_int [i39]
	call pushing_algo
	push_stack stack,stack_pointer,i38
	push_stack stack,stack_pointer,i37
	call minimum_list
	call popping_algo
	mov [i40],r8
	print_int [i40]
	call pushing_algo
	push_stack stack,stack_pointer,i38
	push_stack stack,stack_pointer,i37
	call mean_list
	call popping_algo
	mov [i41],r8
	print_int [i41]
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
	pop_stack stack,stack_pointer,i21
	pop_stack stack,stack_pointer,i22
	pop_stack stack,stack_pointer,i23
	pop_stack stack,stack_pointer,i24
	pop_stack stack,stack_pointer,i25
	pop_stack stack,stack_pointer,i26
	pop_stack stack,stack_pointer,i27
	pop_stack stack,stack_pointer,i28
	pop_stack stack,stack_pointer,i29
	pop_stack stack,stack_pointer,i30
	pop_stack stack,stack_pointer,i31
	pop_stack stack,stack_pointer,i32
	pop_stack stack,stack_pointer,i33
	pop_stack stack,stack_pointer,i34
	pop_stack stack,stack_pointer,i35
	pop_stack stack,stack_pointer,i36
	pop_stack stack,stack_pointer,i37
	pop_stack stack,stack_pointer,i38
	pop_stack stack,stack_pointer,i39
	pop_stack stack,stack_pointer,i40
	pop_stack stack,stack_pointer,i41
	pop_stack stack,stack_pointer,i42
	ret

pushing_algo:
	push_stack stack,stack_pointer,i42
	push_stack stack,stack_pointer,i41
	push_stack stack,stack_pointer,i40
	push_stack stack,stack_pointer,i39
	push_stack stack,stack_pointer,i38
	push_stack stack,stack_pointer,i37
	push_stack stack,stack_pointer,i36
	push_stack stack,stack_pointer,i35
	push_stack stack,stack_pointer,i34
	push_stack stack,stack_pointer,i33
	push_stack stack,stack_pointer,i32
	push_stack stack,stack_pointer,i31
	push_stack stack,stack_pointer,i30
	push_stack stack,stack_pointer,i29
	push_stack stack,stack_pointer,i28
	push_stack stack,stack_pointer,i27
	push_stack stack,stack_pointer,i26
	push_stack stack,stack_pointer,i25
	push_stack stack,stack_pointer,i24
	push_stack stack,stack_pointer,i23
	push_stack stack,stack_pointer,i22
	push_stack stack,stack_pointer,i21
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
