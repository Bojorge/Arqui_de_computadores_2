module shiftRows #(N=127)(
	input logic [N:0] matrix_in,
	output logic [N:0] matrix_out
);
	// Dividimos la matriz en 16 partes de 8 bits
	logic [7:0] row1 [3:0];
	logic [7:0] row2 [3:0];
   logic [7:0] row3 [3:0];
	logic [7:0] row4 [3:0];
	// Asignamos cada byte a su fila correspondiente
	assign row1[0] = matrix_in[127:120];
   assign row1[1] = matrix_in[119:112];
   assign row1[2] = matrix_in[111:104];
   assign row1[3] = matrix_in[103:96];

   assign row2[0] = matrix_in[95:88];
   assign row2[1] = matrix_in[87:80];
   assign row2[2] = matrix_in[79:72];
   assign row2[3] = matrix_in[71:64];

   assign row3[0] = matrix_in[63:56];
   assign row3[1] = matrix_in[55:48];
   assign row3[2] = matrix_in[47:40];
   assign row3[3] = matrix_in[39:32];

   assign row4[0] = matrix_in[31:24];
   assign row4[1] = matrix_in[23:16];
   assign row4[2] = matrix_in[15:8];
   assign row4[3] = matrix_in[7:0];
	// No rotación en la primera fila
	assign matrix_out[127:120] = row1[0];
	assign matrix_out[119:112] = row1[1];
   assign matrix_out[111:104] = row1[2];
   assign matrix_out[103:96]  = row1[3];
	// Rotación de 1 byte en la segunda fila
   assign matrix_out[95:88]   = row2[1];
   assign matrix_out[87:80]   = row2[2];
   assign matrix_out[79:72]   = row2[3];
   assign matrix_out[71:64]   = row2[0];
   // Rotación de 2 bytes en la tercera fila
   assign matrix_out[63:56]   = row3[2];
   assign matrix_out[55:48]   = row3[3];
   assign matrix_out[47:40]   = row3[0];
   assign matrix_out[39:32]   = row3[1];
   // Rotación de 3 bytes en la cuarta fila
   assign matrix_out[31:24]   = row4[3];
   assign matrix_out[23:16]   = row4[0];
   assign matrix_out[15:8]    = row4[1];
   assign matrix_out[7:0]     = row4[2];
endmodule
