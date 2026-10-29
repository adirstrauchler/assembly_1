.text

    .globl relation_code
    .type relation_code, @function
relation_code:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    cmpq %rsi, %rdi
    jl signed_less
    jb unsigned_less
    leave
    ret

signed_less:
    addq $1, %rax
    cmpq %rsi, %rdi
    jb unsigned_less
    leave
    ret

unsigned_less:
    addq $2, %rax
    leave
    ret

    .globl clamp_long
    .type clamp_long, @function
clamp_long:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    cmpq %rsi, %rdi
    jl bellow
    cmpq %rdx, %rdi
    jg above
    movq %rdi, %rax
    leave
    ret

bellow:
    movq %rsi, %rax
    leave
    ret

above:
    movq %rdx, %rax
    leave
    ret

    .globl weighted_sum8
    .type weighted_sum8, @function
weighted_sum8:

    pushq %rbp
    movq %rsp, %rbp

    movq $0, %rbx
    movq %rdx, %r15
    
    movq $1, %rax
    imulq %rdi
    addq %rdi, %rbx

    movq $2, %rax
    imulq %rsi
    addq %rax, %rbx

    movq $3, %rax
    imulq %r15
    addq %rax, %rbx

    movq $4, %rax    
    imulq %rcx
    addq %rax, %rbx

    movq $5, %rax
    imulq %r8
    addq %rax, %rbx

    movq $6, %rax
    imulq %r9
    addq %rax, %rbx

    movq $7, %rax
    imulq 16(%rbp)
    addq %rax, %rbx

    movq $8, %rax
    imulq 24(%rbp)
    addq %rax, %rbx

    movq %rbx, %rax

    leave
    ret

    .globl alternating_sum
    .type alternating_sum, @function
alternating_sum:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq $0, %r8
    cmpq %rdi, %r8
    jne add
    leave
    ret

add:
    addq $1, %r8
    addq %r8, %rax
    cmpq %rdi, %r8
    jb sub
    leave
    ret

sub:
    addq $1, %r8
    subq %r8, %rax
    cmpq %rdi, %r8
    jb add
    leave
    ret

    .globl recursive_power
    .type recursive_power, @function
recursive_power:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    subq $8, %rsp
    movq %rdi, (%rsp)
    movq $0, %rax
    cmpq %rsi, %rax
    je base
    subq $1, %rsi
    call recursive_power
    imulq (%rsp)
    leave
    ret

base:
    movq $1, %rax
    leave
    ret

    .globl combine_helpers
    .type combine_helpers, @function
combine_helpers:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    subq $32, %rsp
    movq %rdi, (%rsp)
    movq %rsi, 8(%rsp)
    call helper_square
    movq %rax, 24(%rsp)
    movq 8(%rsp), %rdi
    call helper_affine
    addq 24(%rsp), %rax 
    leave
    ret

helper_square:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq %rdi, %rax
    imulq %rdi
    leave
    ret

helper_affine:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq $3, %rax
    imulq %rdi
    addq $7, %rax
    leave
    ret

    .section .note.GNU-stack,"",@progbits
