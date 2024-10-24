module inverseShiftRows(
	input logic [127:0] matrix_in,
	output logic [127:0] matrix_out
);
	// Dividimos la matriz en 16 partes de 8 bits
	logic [7:0] row0 [3:0];
	logic [7:0] row1 [3:0];
	logic [7:0] row2 [3:0];
	logic [7:0] row3 [3:0];
	
	// Asignamos cada byte a su fila correspondiente
	
	// Asignaciones para la fila 0 (sin cambios)
	assign row0[0] = matrix_in[7:0];
	assign row0[1] = matrix_in[15:8];
	assign row0[2] = matrix_in[23:16];
	assign row0[3] = matrix_in[31:24];

	// Asignaciones para la fila 1
	assign row1[0] = matrix_in[39:32];
	assign row1[1] = matrix_in[47:40];
	assign row1[2] = matrix_in[55:48];
	assign row1[3] = matrix_in[63:56];

	// Asignaciones para la fila 2
	assign row2[0] = matrix_in[71:64];
	assign row2[1] = matrix_in[79:72];
	assign row2[2] = matrix_in[87:80];
	assign row2[3] = matrix_in[95:88];

	// Asignaciones para la fila 3
	assign row3[0] = matrix_in[103:96];
	assign row3[1] = matrix_in[111:104];
	assign row3[2] = matrix_in[119:112];
	assign row3[3] = matrix_in[127:120];

	// No rotación en la primera fila
	assign matrix_out[7:0] = row0[0];
	assign matrix_out[15:8] = row0[1];
	assign matrix_out[23:16] = row0[2];
	assign matrix_out[31:24] = row0[3];

	// Rotación de 1 byte hacia la derecha en la segunda fila
	assign matrix_out[39:32] = row1[3];
	assign matrix_out[47:40] = row1[0];
	assign matrix_out[55:48] = row1[1];
	assign matrix_out[63:56] = row1[2];

	// Rotación de 2 bytes hacia la derecha en la tercera fila
	assign matrix_out[71:64] = row2[2];
	assign matrix_out[79:72] = row2[3];
	assign matrix_out[87:80] = row2[0];
	assign matrix_out[95:88] = row2[1];

	// Rotación de 3 bytes hacia la derecha en la cuarta fila
	assign matrix_out[103:96] = row3[1];
	assign matrix_out[111:104] = row3[2];
	assign matrix_out[119:112] = row3[3];
	assign matrix_out[127:120] = row3[0];
	
endmodule
