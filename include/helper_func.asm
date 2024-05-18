%macro print_string 1
        mov rax,%1
        call _print_string
%endmacro

%macro print_int 1
    mov rax,%1
    call _print_int
%endmacro

%macro negate 1
    mov rax,[%1]
    neg rax
    mov [%1],rax
%endmacro

%macro add_int 3
    mov rax,[%2]
    mov rbx,[%3]
    add rax,rbx
    mov [%1],rax
%endmacro

%macro sub_int 3
    mov rax,[%2]
    mov rbx,[%3]
    sub rax,rbx
    mov [%1],rax
%endmacro

%macro mul_int 3
    mov rax,[%2]
    imul rax,[%3]
    mov [%1],rax
%endmacro

%macro and_bitwise_int 3
    mov rax,[%2]
    and rax,[%3]
    mov [%1],rax
%endmacro

%macro or_bitwise_int 3
    mov rax,[%2]
    or rax,[%3]
    mov [%1],rax
%endmacro

%macro xor_bitwise_int 3
    mov rax,[%2]
    xor rax,[%3]
    mov [%1],rax
%endmacro

%macro not_bitwise_int 1
    mov rax,[%1]
    not rax
    mov [%1],rax
%endmacro

%macro push_stack 3
    mov rsi, %1
    mov r8, [%2]
    add rsi, r8
    mov r9, [%3]
    mov [rsi],r9
    add r8,8
    mov [%2],r8 
%endmacro

%macro pop_stack 3
    mov rsi, %1
    mov rbx, [%2]
    add rsi, rbx
    sub rsi, 8
    mov rax,[rsi]
    mov [%3],rax
    sub rbx,8
    mov [%2],rbx 

%endmacro

%macro top_stack 3
    mov rsi, %1
    mov rbx, [%2]
    add rsi, rbx
    sub rsi, 8
    mov rax,[rsi]
    mov [%3],rax 
%endmacro

%macro size_stack 1
    mov rax,[%1]
%endmacro


%macro div_int 3
    mov rax, [%2] 
    mov ebx, [%3]   
    xor edx, edx              
    div ebx                   
    mov [%1], rax
%endmacro



%macro mod_int 3
    mov rax, [%2] 
    mov ebx, [%3]   
    xor edx, edx              
    div ebx                   
    mov [%1], rdx
%endmacro

%macro set_int 2
    mov rax,%2
    mov [%1],rax
%endmacro

%macro set_int_from_register 2
    mov rax,[%2]
    mov [%1],rax
%endmacro

%macro access_list 3
    mov rsi,[%2]
    mov rax,[%3]
    imul rax,8
    add rsi,rax
    mov rax,[rsi]
    mov [%1],rax
%endmacro

%macro set_pointer 2
    mov rsi,%2
    mov [%1],rsi
%endmacro

%macro set_val_at_pointer 3
    mov rsi,[%1]
    mov rax,[%2]
    imul rax,8
    add rsi,rax
    mov rax,[%3]
    mov [rsi],rax
%endmacro

%macro greater_than 3
    mov rax,[%2]
    mov rbx,[%3]
    cmp rax,rbx
    jg  %%equal
    jl  %%else
    je  %%else

%%equal:
    mov rax,1
    jmp %%end
%%else:
    mov rax,0
    jmp %%end
%%end:
    mov [%1],rax
%endmacro

%macro less_than 3
    mov rax,[%2]
    mov rbx,[%3]
    cmp rax,rbx
    jg  %%else
    je  %%else
    jl  %%equal

%%equal:
    mov rax,1
    jmp %%end
%%else:
    mov rax,0
    jmp %%end
%%end:
    mov [%1],rax

%endmacro
%macro greater_than_equal 3
    mov rax,[%2]
    mov rbx,[%3]
    cmp rax,rbx
    jg  %%equal
    je  %%equal
    jl  %%else

%%equal:
    mov rax,1
    jmp %%end
%%else:
    mov rax,0
    jmp %%end
%%end:
    mov [%1],rax
%endmacro

%macro less_than_equal 3
    mov rax,[%2]
    mov rbx,[%3]
    cmp rax,rbx
    jg  %%else
    je  %%equal
    jl  %%equal

%%equal:
    mov rax,1
    jmp %%end
%%else:
    mov rax,0
    jmp %%end
%%end:
    mov [%1],rax
%endmacro

%macro equal_comp 3
    mov rax,[%2]
    mov rbx,[%3]
    cmp rax,rbx
    jg  %%else
    je  %%equal
    jl  %%else

%%equal:
    mov rax,1
    jmp %%end
%%else:
    mov rax,0
    jmp %%end
%%end:
    mov [%1],rax
%endmacro






_print_string:
        push rax
        mov rbx,0

_print_string_loop:
        inc rax
        inc rbx
        mov cl,[rax]
        cmp cl, 0

        jne _print_string_loop

        mov rax, 1
        mov rdi, 1
        pop rsi
        mov rdx,rbx
        syscall
        ret

_print_int:
        mov rcx,digitSpace
        mov rbx,10
        mov [rcx],rbx
        inc rcx
        mov [digitSpacePos],rcx

_print_int_loop:
        mov rdx, 0
        mov rbx, 10
        div rbx
        push rax
        add rdx, 48

        mov rcx,[digitSpacePos] 
        mov [rcx], dl
        inc rcx
        mov [digitSpacePos],rcx
       
        pop rax
        cmp rax,0
        jne _print_int_loop

_print_int_loop2:
        mov rcx,[digitSpacePos]

        mov rax,1
        mov rdi, 1
        mov rsi,rcx
        mov rdx,1
        syscall

        mov rcx,[digitSpacePos]
        dec rcx
        mov [digitSpacePos],rcx

        cmp rcx,digitSpace
        jge _print_int_loop2

        ret
