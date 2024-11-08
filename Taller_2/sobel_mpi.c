#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>
#include <sys/resource.h>
#include <time.h>

long getRAMUsage() {
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    return usage.ru_maxrss; // Devuelve el uso máximo de RAM en kilobytes
}

double getElapsedTime(clock_t start, clock_t end) {
    return (double)(end - start) / CLOCKS_PER_SEC;
}

void apply_sobel(unsigned char *input, unsigned char *output, int width, int height, int start_row, int end_row) {
    clock_t start = clock();

    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{1, 2, 1}, {0, 0, 0}, {-1, -2, -1}};

    size_t totalDataRead = 0;
    size_t totalDataWritten = 0;

    for (int y = start_row; y < end_row; y++) {
        for (int x = 1; x < width - 1; x++) {
            int sum_x = 0, sum_y = 0;

            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    sum_x += input[(y + i) * width + (x + j)] * Gx[i + 1][j + 1];
                    sum_y += input[(y + i) * width + (x + j)] * Gy[i + 1][j + 1];
                    totalDataRead += sizeof(unsigned char);  // Corrige el tamaño de lectura
                }
            }

            int magnitude = (int)(sqrt(sum_x * sum_x + sum_y * sum_y));
            output[(y - start_row) * width + x] = (magnitude > 255) ? 255 : magnitude;
            totalDataWritten += sizeof(unsigned char); // Corrige el tamaño de escritura
        }
    }

    clock_t end = clock();
    double elapsedTime = getElapsedTime(start, end);

    if (elapsedTime > 0) {
        double bandwidth = (totalDataRead + totalDataWritten) / (elapsedTime * 1024 * 1024); // Conversión a MB
        printf("Ancho de banda: %.2f MB/s\n", bandwidth);
    } else {
        printf("Ancho de banda: N/A (tiempo transcurrido insignificante)\n");
    }

    long ramUsage = getRAMUsage();
    printf("Uso de RAM: %ld KB\n", ramUsage);
    printf("\n ---------------------------------- \n");
}


unsigned char *read_pgm(const char *filename, int *width, int *height) {
    FILE *file = fopen(filename, "rb");
    if (!file) return NULL;

    char buffer[16];
    fscanf(file, "%s", buffer);
    fscanf(file, "%d %d", width, height);
    int maxval;
    fscanf(file, "%d", &maxval);

    unsigned char *data = (unsigned char *)malloc(*height * *width * sizeof(unsigned char));
    fread(data, sizeof(unsigned char), *width * *height, file);

    fclose(file);
    return data;
}

void write_pgm(const char *filename, unsigned char *data, int width, int height) {
    FILE *file = fopen(filename, "wb");
    if (!file) return;

    fprintf(file, "P5\n%d %d\n255\n", width, height);
    fwrite(data, sizeof(unsigned char), width * height, file);

    fclose(file);
}

int main(int argc, char **argv) {
    clock_t start = clock();
    const char *imageNames[] = {"guitar.pgm", "alien.pgm", "building.pgm", "bike.pgm", "dinosaur.pgm"};
    const int numImages = sizeof(imageNames) / sizeof(imageNames[0]);
    
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        system("mkdir -p sobel_mpi_result");
    }
    MPI_Barrier(MPI_COMM_WORLD);

    for (int imgIndex = 0; imgIndex < numImages; imgIndex++) {
        int width = 0, height = 0;
        unsigned char *input = NULL;

        if (rank == 0) {
            input = read_pgm(imageNames[imgIndex], &width, &height);
            if (input == NULL) {
                printf("Error al leer la imagen %s\n", imageNames[imgIndex]);
                continue;
            }
        }

        MPI_Bcast(&width, 1, MPI_INT, 0, MPI_COMM_WORLD);
        MPI_Bcast(&height, 1, MPI_INT, 0, MPI_COMM_WORLD);

        int rows_per_process = height / size;
        int extra_rows = height % size;

        int start_row = rank * rows_per_process + (rank < extra_rows ? rank : extra_rows);
        int end_row = start_row + rows_per_process + (rank < extra_rows ? 1 : 0);

        int local_height = end_row - start_row;
        unsigned char *local_input = (unsigned char*)malloc((local_height + 2) * width * sizeof(unsigned char));
        unsigned char *local_output = (unsigned char*)calloc(local_height * width, sizeof(unsigned char));

        if (rank == 0) {
            MPI_Scatter(input, rows_per_process * width, MPI_UNSIGNED_CHAR, local_input + width, rows_per_process * width, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);
            free(input);
        } else {
            MPI_Scatter(NULL, rows_per_process * width, MPI_UNSIGNED_CHAR, local_input + width, rows_per_process * width, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);
        }

        apply_sobel(local_input, local_output, width, height, start_row, end_row);

        unsigned char *output = (rank == 0) ? (unsigned char*)malloc(width * height * sizeof(unsigned char)) : NULL;
        MPI_Gather(local_output, local_height * width, MPI_UNSIGNED_CHAR, output, local_height * width, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);

        if (rank == 0) {
            char outputName[256];
            snprintf(outputName, sizeof(outputName), "sobel_mpi_result/%s", imageNames[imgIndex]);
            write_pgm(outputName, output, width, height);
            free(output);
        }

        free(local_input);
        free(local_output);
    }

    if (rank == 0) {
        printf("Filtro Sobel aplicado con MPI y resultados guardados en 'sobel_mpi_result'.\n");
        clock_t end = clock();

        double latency = (double)(end - start) / CLOCKS_PER_SEC;
        printf("Latencia: %.2f segundos\n", latency);
    }

    MPI_Finalize();

    return 0;
}
