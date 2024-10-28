#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void apply_sobel(unsigned char **input, unsigned char **output, int width, int height) {
    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{1, 2, 1}, {0, 0, 0}, {-1, -2, -1}};

    for (int y = 1; y < height - 1; y++) {
        for (int x = 1; x < width - 1; x++) {
            int sum_x = 0, sum_y = 0;

            for (int i = -1; i <= 1; i++) {
                for (int j = -1; j <= 1; j++) {
                    sum_x += input[y + i][x + j] * Gx[i + 1][j + 1];
                    sum_y += input[y + i][x + j] * Gy[i + 1][j + 1];
                }
            }

            int magnitude = (int)(sqrt(sum_x * sum_x + sum_y * sum_y));
            output[y][x] = magnitude > 255 ? 255 : magnitude;
        }
    }
}

unsigned char **read_pgm(const char *filename, int *width, int *height) {
    FILE *file = fopen(filename, "rb");
    if (!file) return NULL;

    char buffer[16];
    fscanf(file, "%s", buffer);
    fscanf(file, "%d %d", width, height);
    int maxval;
    fscanf(file, "%d", &maxval);

    unsigned char **data = (unsigned char **)malloc(*height * sizeof(unsigned char *));
    for (int i = 0; i < *height; i++) {
        data[i] = (unsigned char *)malloc(*width * sizeof(unsigned char));
        fread(data[i], sizeof(unsigned char), *width, file);
    }

    fclose(file);
    return data;
}

void write_pgm(const char *filename, unsigned char **data, int width, int height) {
    FILE *file = fopen(filename, "wb");
    if (!file) return;

    fprintf(file, "P5\n%d %d\n255\n", width, height);
    for (int i = 0; i < height; i++) {
        fwrite(data[i], sizeof(unsigned char), width, file);
    }

    fclose(file);
}

void free_image(unsigned char **data, int height) {
    for (int i = 0; i < height; i++) {
        free(data[i]);
    }
    free(data);
}

int main() {
    const char *imageNames[] = {"alien.pgm", "bike.pgm", "dinosaur.pgm", "building.pgm", "guitar.pgm"};
    const int numImages = sizeof(imageNames) / sizeof(imageNames[0]);
    
    // Crea la carpeta donde se guardarán las imágenes procesadas
    system("mkdir -p sobel_serial_result");

    for (int i = 0; i < numImages; i++) {
        int width, height;
        unsigned char **input = read_pgm(imageNames[i], &width, &height);
        if (input == NULL) {
            printf("Error al leer la imagen %s\n", imageNames[i]);
            continue;
        }

        // Crea una imagen de salida del mismo tamaño que la entrada
        unsigned char **output = (unsigned char **)malloc(height * sizeof(unsigned char *));
        for (int j = 0; j < height; j++) {
            output[j] = (unsigned char *)malloc(width * sizeof(unsigned char));
            memset(output[j], 0, width * sizeof(unsigned char)); // Inicializa la salida
        }

        // Aplica el filtro Sobel
        apply_sobel(input, output, width, height);

        // Guarda la imagen procesada
        char outputName[256];
        snprintf(outputName, sizeof(outputName), "sobel_serial_result/%s", imageNames[i]);
        write_pgm(outputName, output, width, height);

        // Libera la memoria
        free_image(input, height);
        free_image(output, height);
    }

    return 0;
}
