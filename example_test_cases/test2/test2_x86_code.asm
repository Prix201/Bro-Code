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
main:
	push rbp
	mov rbp,rsp
	set_int i1,1489
	set_int i2,13489
	set_int i3,24039
	set_int i4,1309490
	set_int i5,1343
	set_int i6,14
	set_int i7,32134
	set_int i8,3143
	set_int i9,3134
	set_int i10,34134
	set_int i11,34134
	set_int i12,4134
	set_int i13,143
	set_int i14,3143
	set_int i15,3134
	set_int i16,3313
	set_int i17,4133
	set_int i18,41343
	set_int i19,34134
	set_int i20,4313
	set_pointer i21,i1
	set_int i22,20
	set_int_from_register i22,i22
	set_int i23,0
	set_int_from_register i23,i23
	jmp L_1
L_1:
	less_than i24,i23,i22
	set_int i25,1
	set_int i25,1
	mov rax,[i26]
	mov rbx,0
	cmp rax,rbx
	je L_2
	set_int i27,1
	add_int i28,i23,i27
	set_int_from_register i28,i28
	jmp L_3
L_3:
	less_than i29,i28,i22
	mov rax,[i29]
	mov rbx,0
	cmp rax,rbx
	je L_4
	access_list i30,i21,i23
	access_list i31,i21,i28
	greater_than i32,i30,i31
	mov rax,[i32]
	mov rbx,0
	cmp rax,rbx
	je L_5
	access_list i33,i21,i23
	set_int_from_register i33,i33
	access_list i34,i21,i28
	set_val_at_pointer i21,i23,i34
	set_val_at_pointer i21,i28,i33
	jmp L_5
L_5:
	set_int i35,1
	add_int i28,i28,i35
	jmp L_3
L_4:
	set_int i36,1
	add_int i23,i23,i36
	jmp L_1
L_2:
	set_int i37,0
	set_int_from_register i23,i37
	jmp L_6
L_6:
	less_than i38,i23,i22
	mov rax,[i38]
	mov rbx,0
	cmp rax,rbx
	je L_7
	access_list i39,i21,i23
	print_int [i39]
	set_int i40,1
	add_int i23,i23,i40
	jmp L_6
L_7:
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
	ret

pushing_algo:
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
