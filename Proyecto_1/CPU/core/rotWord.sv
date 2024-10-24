module rotWord(
    input  logic [7:0] col_in0,  // Celda 0 de la columna de entrada
    input  logic [7:0] col_in1,  // Celda 1 de la columna de entrada
    input  logic [7:0] col_in2,  // Celda 2 de la columna de entrada
    input  logic [7:0] col_in3,  // Celda 3 de la columna de entrada

    output logic [7:0] col_out0, // Celda 0 de la columna de salida
    output logic [7:0] col_out1, // Celda 1 de la columna de salida
    output logic [7:0] col_out2, // Celda 2 de la columna de salida
    output logic [7:0] col_out3  // Celda 3 de la columna de salida
);

    // Proceso combinacional para aplicar la rotación de las celdas
    always @(*) begin
        col_out0 = col_in1;  // La celda 1 sube a la posición 0
        col_out1 = col_in2;  // La celda 2 sube a la posición 1
        col_out2 = col_in3;  // La celda 3 sube a la posición 2
        col_out3 = col_in0;  // La celda 0 se coloca en la última posición (rotación)
    end

endmodule




/*
module rotWord (
    input  logic [31:0] word_in,   // Entrada de 32 bits
    output logic [31:0] word_out   // Salida de 32 bits con rotación
);

    always_comb begin
        word_out = {word_in[23:0], word_in[31:24]};
    end

endmodule
*/