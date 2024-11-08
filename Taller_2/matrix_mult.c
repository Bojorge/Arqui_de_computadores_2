#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <unistd.h>
#include <sys/resource.h>
#include <time.h>

#define SIZE 4 // Dimensión de las matrices

long getRAMUsage() {
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    return usage.ru_maxrss; // Devuelve el uso máximo de RAM en kilobytes
}

double getElapsedTime(clock_t start, clock_t end) {
    return (double)(end - start) / CLOCKS_PER_SEC;
}

void print_matrix(int matrix[SIZE][SIZE]) {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char **argv) {
    clock_t start = clock();

    int rank, size;
    int matrix_a[SIZE][SIZE], matrix_b[SIZE][SIZE], result[SIZE][SIZE] = {0};

    size_t totalDataRead = 0;
    size_t totalDataWritten = 0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Solo el proceso 0 inicializa las matrices
    if (rank == 0) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                matrix_a[i][j] = i + j;
                matrix_b[i][j] = i * j;
            }
        }
        printf("Matrix A:\n");
        print_matrix(matrix_a);
        printf("Matrix B:\n");
        print_matrix(matrix_b);
    }

    // Transmite matrix_b a todos los procesos
    MPI_Bcast(matrix_b, SIZE * SIZE, MPI_INT, 0, MPI_COMM_WORLD);
    totalDataRead += SIZE * SIZE * sizeof(int); // Cuenta los datos leídos para matrix_b

    // Calcula cuántas filas le corresponden a cada proceso
    int rows_per_proc = SIZE / size;
    int remaining_rows = SIZE % size;

    // Define el tamaño local de filas y el buffer local para recibir filas
    int local_rows = (rank < remaining_rows) ? rows_per_proc + 1 : rows_per_proc;
    int local_matrix_a[local_rows][SIZE];
    int local_result[local_rows][SIZE];

    // Crea un desplazamiento para distribuir las filas con Scatterv
    int sendcounts[size];
    int displs[size];
    int offset = 0;

    for (int i = 0; i < size; i++) {
        sendcounts[i] = ((i < remaining_rows) ? rows_per_proc + 1 : rows_per_proc) * SIZE;
        displs[i] = offset;
        offset += sendcounts[i];
    }

    // Distribuye las filas de matrix_a usando Scatterv
    MPI_Scatterv(&matrix_a[0][0], sendcounts, displs, MPI_INT, &local_matrix_a[0][0],
                 local_rows * SIZE, MPI_INT, 0, MPI_COMM_WORLD);
    totalDataRead += local_rows * SIZE * sizeof(int); // Registra los datos leídos para matrix_a

    // Multiplica las filas asignadas localmente
    for (int i = 0; i < local_rows; i++) {
        for (int j = 0; j < SIZE; j++) {
            local_result[i][j] = 0;
            for (int k = 0; k < SIZE; k++) {
                local_result[i][j] += local_matrix_a[i][k] * matrix_b[k][j];
                totalDataRead += sizeof(int); // Registro de lectura para la multiplicación
            }
            totalDataWritten += sizeof(int); // Registro de escritura para el resultado
        }
    }

    // Configura los tamaños de recogida de resultados
    int recvcounts[size];
    for (int i = 0; i < size; i++) {
        recvcounts[i] = sendcounts[i];
    }

    // Recoge los resultados en el proceso 0 con Gatherv
    MPI_Gatherv(&local_result[0][0], local_rows * SIZE, MPI_INT, &result[0][0],
                recvcounts, displs, MPI_INT, 0, MPI_COMM_WORLD);
    totalDataWritten += local_rows * SIZE * sizeof(int); // Registro de escritura de resultados

    // El proceso 0 muestra el resultado y calcula las métricas de rendimiento
    if (rank == 0) {
        printf("Result Matrix:\n");
        print_matrix(result);

        clock_t end = clock();
        double elapsedTime = getElapsedTime(start, end);
        long ramUsage = getRAMUsage();

        double bandwidth = (totalDataRead + totalDataWritten) / (elapsedTime * 1024 * 1024); // MB/s
        printf("Uso de RAM: %ld KB\n", ramUsage);
        printf("Ancho de banda: %.2f MB/s\n", bandwidth);
        printf("Latencia: %.2f segundos\n", elapsedTime);

        printf("\n ---------------------------------- \n");
    }

    MPI_Finalize();
    return 0;
}
