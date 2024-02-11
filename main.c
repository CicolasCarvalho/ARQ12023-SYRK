#include <stdio.h>
#include <stdlib.h>

typedef int DATA_TYPE;

void init_array(int n, int m, DATA_TYPE *C, DATA_TYPE *A) {
    int i, j;
    
    for (i = 0; i < n; i++)
        for (j = 0; j < m; j++) {
            printf("Insira o valor de A[%i][%i]:\n", i, j);
            scanf("%i", &A[i*m + j]);
        }

    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++) {
            printf("Insira o valor de C[%i][%i]:\n", i, j);
            scanf("%i", &C[i*n + j]);
        }
}

void print_array(int n, DATA_TYPE *C) {
    int i, j;
    
    for (i = 0; i < n; i++) {
        printf("\n");
        for (j = 0; j < n; j++) {
            printf("%i ", C[i*n + j]);
        }
    }
    printf("\n");
}

void kernel_syrk(int n, int m, DATA_TYPE alpha, DATA_TYPE beta, DATA_TYPE *C, DATA_TYPE *A) {
    int i, j, k;
    
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            C[i*n + j] *= beta;

        for (k = 0; k < m; k++)
            for (j = 0; j < n; j++)
                C[i*n + j] += alpha * A[i*m + k] * A[j*m + k];
    }
}

void free_array(DATA_TYPE *C, DATA_TYPE *A) {
    free(A);
    free(C);
}

int main(void) {
    int N, M;
    printf("Insira os valores de N e M:\n");
    scanf("%i %i", &N, &M);

    DATA_TYPE *C = malloc(sizeof(DATA_TYPE) * N * N), 
              *A = malloc(sizeof(DATA_TYPE) * N * M);

    DATA_TYPE alpha, beta;
    printf("Insira os valores de alpha e beta:\n");
    scanf("%i %i", &alpha, &beta);

    init_array(N, M, C, A);

    kernel_syrk(N, M, alpha, beta, C, A);

    print_array(N, C);

    free_array(C, A);

    return 0;
}