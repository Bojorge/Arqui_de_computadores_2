module shiftRows (
    input  logic [127:0] matrix_in,  // Entrada de 128 bits
    output logic [127:0] matrix_out  // Salida de 128 bits
);

    // Dividir la entrada en bytes
    logic [7:0] state [15:0];

    // Asignar los bytes de entrada a la matriz estado
    assign state[0]  = matrix_in[127:120];
    assign state[1]  = matrix_in[119:112];
    assign state[2]  = matrix_in[111:104];
    assign state[3]  = matrix_in[103:96];
    assign state[4]  = matrix_in[95:88];
    assign state[5]  = matrix_in[87:80];
    assign state[6]  = matrix_in[79:72];
    assign state[7]  = matrix_in[71:64];
    assign state[8]  = matrix_in[63:56];
    assign state[9]  = matrix_in[55:48];
    assign state[10] = matrix_in[47:40];
    assign state[11] = matrix_in[39:32];
    assign state[12] = matrix_in[31:24];
    assign state[13] = matrix_in[23:16];
    assign state[14] = matrix_in[15:8];
    assign state[15] = matrix_in[7:0];

    // Realizar la operación de ShiftRows
    // Primera fila (sin cambio)
    assign matrix_out[127:120] = state[0];
    assign matrix_out[119:112] = state[1];
    assign matrix_out[111:104] = state[2];
    assign matrix_out[103:96]  = state[3];

    // Segunda fila (rotar 1 posición a la izquierda)
    assign matrix_out[95:88]   = state[5];
    assign matrix_out[87:80]   = state[6];
    assign matrix_out[79:72]   = state[7];
    assign matrix_out[71:64]   = state[4];

    // Tercera fila (rotar 2 posiciones a la izquierda)
    assign matrix_out[63:56]   = state[10];
    assign matrix_out[55:48]   = state[11];
    assign matrix_out[47:40]   = state[8];
    assign matrix_out[39:32]   = state[9];

    // Cuarta fila (rotar 3 posiciones a la izquierda)
    assign matrix_out[31:24]   = state[15];
    assign matrix_out[23:16]   = state[12];
    assign matrix_out[15:8]    = state[13];
    assign matrix_out[7:0]     = state[14];

endmodule