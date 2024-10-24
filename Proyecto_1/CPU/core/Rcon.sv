module Rcon(
    input  logic [3:0] round,    // Número de ronda (4 bits)
    input  logic [7:0] col_in0,  // Primera celda de la columna de entrada
    input  logic [7:0] col_in1,  // Segunda celda de la columna de entrada
    input  logic [7:0] col_in2,  // Tercera celda de la columna de entrada
    input  logic [7:0] col_in3,  // Cuarta celda de la columna de entrada
    input  logic [7:0] col_in0_2, // Primera celda de la segunda columna de entrada
    input  logic [7:0] col_in1_2, // Segunda celda de la segunda columna de entrada
    input  logic [7:0] col_in2_2, // Tercera celda de la segunda columna de entrada
    input  logic [7:0] col_in3_2, // Cuarta celda de la segunda columna de entrada
    output logic [7:0] col_out0, // Primera celda de la columna de salida
    output logic [7:0] col_out1, // Segunda celda de la columna de salida
    output logic [7:0] col_out2, // Tercera celda de la columna de salida
    output logic [7:0] col_out3  // Cuarta celda de la columna de salida
);

    // Declaramos la tabla de Rcon para cada ronda
    logic [31:0] Rcon [0:10]; 

    // Inicializamos la tabla de Rcon
    initial begin
        Rcon[0]  = 32'h00000000;
        Rcon[1]  = 32'h01000000;
        Rcon[2]  = 32'h02000000;
        Rcon[3]  = 32'h04000000;
        Rcon[4]  = 32'h08000000;
        Rcon[5]  = 32'h10000000;
        Rcon[6]  = 32'h20000000;
        Rcon[7]  = 32'h40000000;
        Rcon[8]  = 32'h80000000;
        Rcon[9]  = 32'h1b000000;
        Rcon[10] = 32'h36000000;
    end

    // Asignamos la columna de salida al XOR de las columnas de entrada con la columna Rcon correspondiente
    always @(*) begin
        // Los primeros 8 bits de Rcon (MSB)
        col_out0 = col_in0 ^ col_in0_2 ^ Rcon[round][31:24];
        // Los siguientes 8 bits de Rcon
        col_out1 = col_in1 ^ col_in1_2 ^ Rcon[round][23:16];
        // Los siguientes 8 bits de Rcon
        col_out2 = col_in2 ^ col_in2_2 ^ Rcon[round][15:8];
        // Los últimos 8 bits de Rcon (LSB)
        col_out3 = col_in3 ^ col_in3_2 ^ Rcon[round][7:0];
    end

endmodule





/*
module Rcon (
    input  logic [3:0] index,    // Índice de la tabla Rcon (de 0 a 10 para AES-128)
    output logic [7:0] rcon_val  // Valor correspondiente de Rcon
);

    always_comb begin
        case (index)
            4'h0: rcon_val = 8'h01;
            4'h1: rcon_val = 8'h02;
            4'h2: rcon_val = 8'h04;
            4'h3: rcon_val = 8'h08;
            4'h4: rcon_val = 8'h10;
            4'h5: rcon_val = 8'h20;
            4'h6: rcon_val = 8'h40;
            4'h7: rcon_val = 8'h80;
            4'h8: rcon_val = 8'h1B;
            4'h9: rcon_val = 8'h36;
            default: rcon_val = 8'h00;  // Valor por defecto para índices fuera de rango
        endcase
    end

endmodule
*/
