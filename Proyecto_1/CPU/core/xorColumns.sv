module xorColumns(
    input  logic [7:0] col_in0,  // Primera celda de la primera columna
    input  logic [7:0] col_in1,  // Segunda celda de la primera columna
    input  logic [7:0] col_in2,  // Tercera celda de la primera columna
    input  logic [7:0] col_in3,  // Cuarta celda de la primera columna
    input  logic [7:0] col_in0_2, // Primera celda de la segunda columna
    input  logic [7:0] col_in1_2, // Segunda celda de la segunda columna
    input  logic [7:0] col_in2_2, // Tercera celda de la segunda columna
    input  logic [7:0] col_in3_2, // Cuarta celda de la segunda columna
    output logic [7:0] col_out0, // Primera celda de la columna de salida
    output logic [7:0] col_out1, // Segunda celda de la columna de salida
    output logic [7:0] col_out2, // Tercera celda de la columna de salida
    output logic [7:0] col_out3  // Cuarta celda de la columna de salida
);

    // Asignamos la columna de salida al XOR de las celdas correspondientes de las dos columnas de entrada
    always @(*) begin
        col_out0 = col_in0 ^ col_in0_2;
        col_out1 = col_in1 ^ col_in1_2;
        col_out2 = col_in2 ^ col_in2_2;
        col_out3 = col_in3 ^ col_in3_2;
    end

endmodule
