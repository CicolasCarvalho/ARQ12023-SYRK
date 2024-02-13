.global main

.section .text
main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp

    # printf("Insira os valores de N e M:\n");
    movq    $str4, %rdi
    call    printf

    # scanf("%i %i", &N, &M);
    movq    $str5, %rdi
    leaq    -4(%rbp), %rsi
    leaq    -8(%rbp), %rdx
    call    scanf

    # DATA_TYPE *C = malloc(sizeof(DATA_TYPE) * N * N),
    movl    $4, %eax
    imull   -4(%rbp), %eax
    imull   -4(%rbp), %eax
    movslq  %eax, %rdi
    call    malloc
    movq    %rax, -16(%rbp)

    #           *A = malloc(sizeof(DATA_TYPE) * N * M);
    movl    $4, %eax
    imull   -4(%rbp), %eax
    imull   -8(%rbp), %eax
    movslq  %eax, %rdi
    call   malloc
    movq    %rax, -24(%rbp)

    # printf("Insira os valores de alpha e beta:\n");
    movq    $str6, %rdi
    call    printf

    # scanf("%i %i", &alpha, &beta);
    movq    $str5, %rdi
    leaq    -28(%rbp), %rsi
    leaq    -32(%rbp), %rdx
    call    scanf
    
    # init_array(N, M, C, A);
    movl    -4(%rbp), %edi
    movl    -8(%rbp), %esi
    movq    -16(%rbp), %rdx
    movq    -24(%rbp), %rcx
    call    init_array

    # kernel_syrk(N, M, alpha, beta, C, A);
    movl    -4(%rbp), %edi
    movl    -8(%rbp), %esi
    movq    -16(%rbp), %r8
    movq    -24(%rbp), %r9
    movl    -28(%rbp), %edx
    movl    -32(%rbp), %ecx
    call    kernel_syrk

    # print_array(N, C);
    movl    -4(%rbp), %edi
    movq    -16(%rbp), %rsi
    call    print_array

    # free_array(C, A)
    movq    -16(%rbp), %rdi
    movq    -24(%rbp), %rsi
    call    free_array

    leave
    ret

init_array:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    movl    %edi, -4(%rbp) # N
    movl    %esi, -8(%rbp) # M
    movq    %rdx, -16(%rbp) # C
    movq    %rcx, -24(%rbp) # A
    
    # for (i = 0; i < n; i++)
    movl    $0, -28(%rbp)
    loop_a:
        movl    -4(%rbp), %eax
        cmpl    %eax, -28(%rbp)
        jge     fora_loop_a

        # for (j = 0; j < m; j++)
        movl    $0, -32(%rbp)
        loop_a_2:
            movl    -8(%rbp), %ecx
            cmpl    %ecx, -32(%rbp)
            jge     fora_loop_a_2

            # printf("Insira o valor de A[%i][%i]:\n", i, j);
            movq    $str, %rdi
            movl    -28(%rbp), %esi
            movl    -32(%rbp), %edx
            call    printf
            
            # scanf("%i", &A[i*m + j]);
            movq    $str1, %rdi
            movl    -28(%rbp), %eax
            imull   -8(%rbp), %eax
            movl    -32(%rbp), %edx
            addl    %edx, %eax
            cltq
            movq    -24(%rbp), %r8
            leaq    (%r8, %rax, 4), %rsi
            call    scanf

            addl    $1, -32(%rbp)
            jmp     loop_a_2
        fora_loop_a_2:

        addl    $1, -28(%rbp)
        jmp     loop_a
    fora_loop_a:

    # for (i = 0; i < n; i++)
    movl    $0, -28(%rbp)
    loop_b:
        movl    -4(%rbp), %eax
        cmpl    %eax, -28(%rbp)
        jge     fora_loop_b

        # for (j = 0; j < n; j++)
        movl    $0, -32(%rbp)
        loop_b_2:
            movl    -4(%rbp), %ecx
            cmpl    %ecx, -32(%rbp)
            jge     fora_loop_b_2

            # printf("Insira o valor de C[%i][%i]:\n", i, j);
            movq    $str2, %rdi
            movl    -28(%rbp), %esi
            movl    -32(%rbp), %edx
            call    printf

            # scanf("%i", &C[i*n + j]);
            movq    $str1, %rdi
            movl    -28(%rbp), %eax
            imull   -4(%rbp), %eax
            movl    -32(%rbp), %edx
            addl    %edx, %eax
            cltq
            movq    -16(%rbp), %r8
            leaq    (%r8, %rax, 4), %rsi
            call    scanf

            addl    $1, -32(%rbp)
            jmp     loop_b_2
        fora_loop_b_2:

        addl    $1, -28(%rbp)
        jmp     loop_b
    fora_loop_b:
    
    leave
    ret

print_array:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    movl    %edi, -4(%rbp)  # N
    movq    %rsi, -12(%rbp) # C

    # for (i = 0; i < n; i++)
    movl    $0, -16(%rbp)
    loop_print:
        movl    -4(%rbp), %eax
        cmpl    %eax, -16(%rbp)
        jge     fora_loop_print

        # printf("\n");
        movq    $str3, %rdi
        call    printf

        # for (j = 0; j < n; j++)
        movl    $0, -20(%rbp)
        loop_print_2:
            movl    -4(%rbp), %ecx
            cmpl    %ecx, -20(%rbp)
            jge     fora_loop_print_2

            # scanf("%i", &A[i*n + j]);
            movq    $str7, %rdi
            movl    -16(%rbp), %eax
            imull   -4(%rbp), %eax
            movl    -20(%rbp), %edx
            addl    %edx, %eax
            cltq
            movq    -12(%rbp), %r8
            movl    (%r8, %rax, 4), %esi
            call    printf

            addl    $1, -20(%rbp)
            jmp     loop_print_2
        fora_loop_print_2:

        addl    $1, -16(%rbp)
        jmp     loop_print
    fora_loop_print:

    movq    $str3, %rdi
    call    printf    
    
    leave
    ret

kernel_syrk:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $48, %rsp
    movl    %edi, -4(%rbp)  # N
    movl    %esi, -8(%rbp)  # M
    movq    %r8,  -16(%rbp) # C
    movq    %r9,  -24(%rbp) # A
    movl    %edx, -28(%rbp) # alpha
    movl    %ecx, -32(%rbp) # beta
    
    # for (i = 0; i < n; i++)
    movl    $0, -36(%rbp)
    loop_kernel:
        movl    -4(%rbp), %eax
        cmpl    %eax, -36(%rbp)
        jge     fora_loop_kernel

        # for (j = 0; j < n; j++)
        movl    $0, -40(%rbp)
        loop_kernel_1:
            movl    -4(%rbp), %eax
            cmpl    %eax, -40(%rbp)
            jge     fora_loop_kernel_1

            # C[i*n + j] 
            movl    -36(%rbp), %eax
            imull   -4(%rbp), %eax
            movl    -40(%rbp), %edx
            addl    %edx, %eax
            cltq
            movq    -16(%rbp), %r8
            leaq    (%r8, %rax, 4), %rcx
            # *= beta;
            movl    (%rcx), %edx
            imull   -32(%rbp), %edx
            movl    %edx, (%rcx)

            addl    $1, -40(%rbp)
            jmp     loop_kernel_1
        fora_loop_kernel_1:

        # for (k = 0; k < m; k++)
        movl    $0, -44(%rbp)
        loop_kernel_2:
            movl    -8(%rbp), %eax
            cmpl    %eax, -44(%rbp)
            jge     fora_loop_kernel_2

            # for (j = 0; j < n; j++)
            movl    $0, -40(%rbp)
            loop_kernel_3:
                movl    -4(%rbp), %eax
                cmpl    %eax, -40(%rbp)
                jge     fora_loop_kernel_3

                # A[i*m + k]
                movl    -36(%rbp), %eax
                imull   -8(%rbp), %eax
                movl    -44(%rbp), %edx
                addl    %edx, %eax
                cltq
                movq    -24(%rbp), %r8
                leaq    (%r8, %rax, 4), %r9
                # A[j*m + k]
                movl    -40(%rbp), %eax
                imull   -8(%rbp), %eax
                movl    -44(%rbp), %edx
                addl    %edx, %eax
                cltq
                movq    -24(%rbp), %r8
                leaq    (%r8, %rax, 4), %r10

                # C[i*n + j] 
                movl    -36(%rbp), %eax
                imull   -4(%rbp), %eax
                movl    -40(%rbp), %edx
                addl    %edx, %eax
                cltq
                movq    -16(%rbp), %r8
                leaq    (%r8, %rax, 4), %rcx

                # += alpha * A[i*m + k] * A[j*m + k];
                movl    (%r9), %eax
                movl    (%r10), %edx
                imull   %eax, %edx
                imull   -28(%rbp), %edx
                movl    (%rcx), %eax
                addl    %eax, %edx
                movl    %edx, (%rcx)

                addl    $1, -40(%rbp)
                jmp     loop_kernel_3
            fora_loop_kernel_3:

            addl    $1, -44(%rbp)
            jmp     loop_kernel_2
        fora_loop_kernel_2:

        addl    $1, -36(%rbp)
        jmp     loop_kernel
    fora_loop_kernel:

    leave
    ret

free_array:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movq    %rdx, -8(%rbp)
    movq    %rcx, -16(%rbp)
    
    # free(A);
    movq    -8(%rbp), %rdi
    call    free
    # free(C);
    movq    -16(%rbp), %rdi
    call    free

    leave
    ret

str:
    .asciz  "Insira o valor de A[%i][%i]:\n"

str1:
    .asciz  "%i"

str2:
    .asciz  "Insira o valor de C[%i][%i]:\n"

str3:
    .asciz  "\n"

str4:
    .asciz  "Insira os valores de N e M:\n"

str5:
    .asciz  "%i %i"

str6:
    .asciz  "Insira os valores de alpha e beta:\n"

str7:
    .asciz  "%i, "
