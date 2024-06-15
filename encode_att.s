.section .data
symbols:
		.ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\n"

.section .text
.global encode

.macro write_symbol_to_memory
    movb (%rbx, %rdx), %r11b
    movb %r11b, (%rdi, %r9)
.endm

# rdi -> encoded_buf, rsi -> original_text, rdx -> leng
encode:
    pushq %rbp
    movq %rsp, %rbp
    push %rbx
    push %rdx

    xorq %rax, %rax
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    xorq %r8, %r8
    xorq %r9, %r9
    xorq %r10, %r10
    lea symbols(%rip), %rbx

    .big_loop:
        movl (%rsi, %rcx), %eax
        add $3, %rcx
        cmpb $0, %al
        je .exit

        movb %al, %dl
        movb %al, %r8b
        
        shr $2, %dl
        shl $6, %r8b
        shr $2, %r8b

        write_symbol_to_memory

        inc %r9
        # =========================================

        shr $8, %rax

        movb %al, %dl
        movb %al, %r10b

        shr $4, %dl
        or %r8b, %dl
        shl $4, %r10b
        shr $2, %r10b

        write_symbol_to_memory

        inc %r9
        cmpb $0, %al
        je .if_zero
        # =========================================
        shr $8, %rax

        movb %al, %dl

        shr $6, %dl
        or %r10b, %dl

        write_symbol_to_memory

        inc %r9
        cmpb $0, %al
        je .if_zero

        movb %al, %dl
        shl $2, %dl
        shr $2, %dl

        write_symbol_to_memory

        inc %r9
        # =========================================
        shr $8, %rax
        cmpb $0, %al
        je .exit 

        jmp .big_loop

        .if_zero:
            pop %rdx
            sub %r9b, %dl
            .iter:
                cmpb $0, %dl
                je .exit
                movb $0x3d, (%rdi, %r9)
                inc %r9
                dec %rdx
                jmp .iter

        .exit:
            movb $0, (%rdi, %r9)
            movq %rdi, %rax

            pop %rbx
            movq %rbp, %rsp
            pop %rbp
            ret

