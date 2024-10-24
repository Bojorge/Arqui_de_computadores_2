module addRoundKey(
    input  logic [7:0] col_in0_a,   // Celda 0 de la columna A
    input  logic [7:0] col_in1_a,   // Celda 1 de la columna A
    input  logic [7:0] col_in2_a,   // Celda 2 de la columna A
    input  logic [7:0] col_in3_a,   // Celda 3 de la columna A

    input  logic [7:0] col_in0_b,   // Celda 0 de la columna B (Round Key)
    input  logic [7:0] col_in1_b,   // Celda 1 de la columna B (Round Key)
    input  logic [7:0] col_in2_b,   // Celda 2 de la columna B (Round Key)
    input  logic [7:0] col_in3_b,   // Celda 3 de la columna B (Round Key)

    output logic [7:0] col_out0,    // Celda 0 de la columna de salida
    output logic [7:0] col_out1,    // Celda 1 de la columna de salida
    output logic [7:0] col_out2,    // Celda 2 de la columna de salida
    output logic [7:0] col_out3     // Celda 3 de la columna de salida
);

    // Proceso combinacional para aplicar XOR entre las dos columnas
    always @(*) begin
        col_out0 = col_in0_a ^ col_in0_b;  // XOR entre celda 0 de columna A y celda 0 de columna B
        col_out1 = col_in1_a ^ col_in1_b;  // XOR entre celda 1 de columna A y celda 1 de columna B
        col_out2 = col_in2_a ^ col_in2_b;  // XOR entre celda 2 de columna A y celda 2 de columna B
        col_out3 = col_in3_a ^ col_in3_b;  // XOR entre celda 3 de columna A y celda 3 de columna B
    end

endmodule




/*
module addRoundKey
#(
    parameter N = 8
)
(
    input logic [N-1:0] in1, 
    input logic [N-1:0] in2,
    output logic [N-1:0] out
);

    always_comb begin
        out = in1 ^ in2;
    end

endmodule
*/