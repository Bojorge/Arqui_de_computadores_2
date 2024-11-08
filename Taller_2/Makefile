# Define los nombres de los archivos fuente y ejecutables
SERIAL_SRC = sobel_serial.c
OPENMP_SRC = sobel_openmp.c
MPI_SRC = sobel_mpi.c
MATRIX_SRC = matrix_mult.c

SERIAL_EXE = sobel_serial
OPENMP_EXE = sobel_openmp
MPI_EXE = sobel_mpi
MATRIX_EXE = matrix_mult

# Opciones de compilación
CC = gcc
MPICC = mpicc
CFLAGS = -lm

# Reglas
all: $(SERIAL_EXE) $(OPENMP_EXE) $(MPI_EXE) $(MATRIX_EXE)

$(SERIAL_EXE): $(SERIAL_SRC)
	$(CC) -o $@ $< $(CFLAGS)

$(OPENMP_EXE): $(OPENMP_SRC)
	$(CC) -fopenmp -o $@ $< $(CFLAGS)

$(MPI_EXE): $(MPI_SRC)
	$(MPICC) -o $@ $< $(CFLAGS)

$(MATRIX_EXE): $(MATRIX_SRC)
	$(MPICC) -o $@ $< $(CFLAGS)

clean:
	rm -f $(SERIAL_EXE) $(OPENMP_EXE) $(MPI_EXE) $(MATRIX_EXE)
