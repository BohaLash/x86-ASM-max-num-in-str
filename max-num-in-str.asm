; Find largest number in a string with octal numbers preceded by 0 (e.g. 0123 = 83)
; Example: abc012de123f0415 Answer: 269

section .bss
    char resb 1

section .text
    global _start

_start:
    mov r8, 10
    mov r9, 0
    mov r10, 0

_loop:
    mov rax, 0 ; stdin
    mov rdi, 0 ; sys_read
    mov rsi, char
    mov rdx, 1
    syscall

    cmp word[char], 10 ; '\n'
    je _exit

    cmp word[char], '0'
    jl _alpha

    cmp word[char], '9'
    jg _alpha

    cmp word[char], '0'
    je _zero

    jmp _digit

_alpha:
    cmp r10, r9
    jge _reset
    
    mov r10, r9

_reset:
    mov r8, 10
    mov r9, 0
    jmp _loop

_zero:
    cmp r9, 0
    jg _digit
    
    mov r8, 8
    jmp _loop

_digit:
    imul r9, r8
    add r9, [char]
    sub r9, '0'    
    
    jmp _loop

_exit:
    cmp r10, r9
    jge _print
    
    mov r10, r9

_print:
    mov rax, r10
    mov r8, 0
    mov r10, 10

_factor:
    inc r8
    mov rdx, 0
    idiv r10
    add rdx, '0'
    push dx
    cmp rax, 0
    jg _factor

    shl r8, 1

    mov rax, 1 ; stdout
    mov rdi, 1 ; sys_write
    mov rsi, rsp
    mov rdx, r8
    syscall
    
    mov rax, 60
    mov rdi, 0
    syscall
