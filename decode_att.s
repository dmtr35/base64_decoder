.section .data
symbols:
	.ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=\n"

.section .text
.global decode


# %rdi -> decoded_buf, %rsi -> original_text
decode:
    push %rbp
    movq %rsp, %rbp
    push %rbx

    xorq %rax, %rax
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    xorq %r9, %r9
    xorq %r10, %r10
    lea symbols(%rip), %rbx

    .big_loop:
        xorq %r11, %r11
        movl (%rsi, %rcx), %eax
        cmp $0, %al
        je .exit
        add $4, %cl


        .mini_loop:
            xor %rdx, %rdx
            .iter_table:
                cmp %al, (%rbx, %rdx)
                je .+6
                inc %dl
                jmp .iter_table

            cmp $0, %r11
            jne .sh_and_write_other
            movb %dl, %r9b
            jmp .sh_rax

            .sh_and_write_other:
                shl $8, %r9
                cmp $64, %dl
                jne .next
                movb $0, %r9b
                jmp .+5
                .next:
                movb %dl, %r9b
                shl $2, %r9b
                shr $2, %r9

            .sh_rax:    
                shr $8, %rax
                cmp $0, %al
                je .to_stack
                inc %r11
                jmp .mini_loop

        # =========================================
        
        .to_stack:
            movb %r9b, %dl
            push %rdx
            shr $8, %r9
            dec %r11
            cmp $0, %r11
            jne .to_stack

        .from_stack:
            pop %rdx
            cmp $0, %rdx
            je .exit
            movb %dl, (%rdi, %r10)
            inc %r10
            inc %r11
            cmp $3, %r11
            jne .from_stack

        jmp .big_loop

        # =========================================
        .exit:
            movb $0, (%rdi, %r10)
            movq %rdi, %rax

            pop %rbx
            movq %rbp, %rsp
            pop %rbp
            ret


