module decrypt (
	input logic clk,
   input logic [127:0] srcA_vector, // Primer operando
   input logic [127:0] srcB_vector, // Segundo operando
   output logic [127:0] inv_shiftRows_result,
	output logic [127:0] inv_mixColumns_result,
	output logic [127:0] inv_subBytes_result
);

	
    // Señales para las filas de entrada (32 bits cada una)
	logic [31:0] row_in_a_0, row_in_a_1, row_in_a_2, row_in_a_3;  // Filas de srcA
	logic [31:0] row_in_b_0, row_in_b_1, row_in_b_2, row_in_b_3;  // Filas de srcB

	// Señales para las columnas de entrada (4 columnas de 8 bits cada una)
	logic [7:0] col_0_in_a_0, col_0_in_a_1, col_0_in_a_2, col_0_in_a_3;
	logic [7:0] col_1_in_a_0, col_1_in_a_1, col_1_in_a_2, col_1_in_a_3;
	logic [7:0] col_2_in_a_0, col_2_in_a_1, col_2_in_a_2, col_2_in_a_3;
	logic [7:0] col_3_in_a_0, col_3_in_a_1, col_3_in_a_2, col_3_in_a_3;

	logic [7:0] col_0_in_b_0, col_0_in_b_1, col_0_in_b_2, col_0_in_b_3;
	logic [7:0] col_1_in_b_0, col_1_in_b_1, col_1_in_b_2, col_1_in_b_3;
	logic [7:0] col_2_in_b_0, col_2_in_b_1, col_2_in_b_2, col_2_in_b_3;
	logic [7:0] col_3_in_b_0, col_3_in_b_1, col_3_in_b_2, col_3_in_b_3;

	// Descomposición de las filas en las columnas para srcA_vector
	assign row_in_a_0 = srcA_vector[31:0];
	assign row_in_a_1 = srcA_vector[63:32];
	assign row_in_a_2 = srcA_vector[95:64];
	assign row_in_a_3 = srcA_vector[127:96];

	// Columnas para srcA_vector
	assign col_0_in_a_0 = row_in_a_0[7:0];    // Columna 0, fila 0
	assign col_0_in_a_1 = row_in_a_1[7:0];    // Columna 0, fila 1
	assign col_0_in_a_2 = row_in_a_2[7:0];    // Columna 0, fila 2
	assign col_0_in_a_3 = row_in_a_3[7:0];    // Columna 0, fila 3

	assign col_1_in_a_0 = row_in_a_0[15:8];   // Columna 1, fila 0
	assign col_1_in_a_1 = row_in_a_1[15:8];   // Columna 1, fila 1
	assign col_1_in_a_2 = row_in_a_2[15:8];   // Columna 1, fila 2
	assign col_1_in_a_3 = row_in_a_3[15:8];   // Columna 1, fila 3

	assign col_2_in_a_0 = row_in_a_0[23:16];  // Columna 2, fila 0
	assign col_2_in_a_1 = row_in_a_1[23:16];  // Columna 2, fila 1
	assign col_2_in_a_2 = row_in_a_2[23:16];  // Columna 2, fila 2
	assign col_2_in_a_3 = row_in_a_3[23:16];  // Columna 2, fila 3

	assign col_3_in_a_0 = row_in_a_0[31:24];  // Columna 3, fila 0
	assign col_3_in_a_1 = row_in_a_1[31:24];  // Columna 3, fila 1
	assign col_3_in_a_2 = row_in_a_2[31:24];  // Columna 3, fila 2
	assign col_3_in_a_3 = row_in_a_3[31:24];  // Columna 3, fila 3

	// Descomposición de las filas en las columnas para srcB_vector (Round Key)
	assign row_in_b_0 = srcB_vector[31:0];
	assign row_in_b_1 = srcB_vector[63:32];
	assign row_in_b_2 = srcB_vector[95:64];
	assign row_in_b_3 = srcB_vector[127:96];

	// Columnas para srcB_vector
	assign col_0_in_b_0 = row_in_b_0[7:0];    // Columna 0, fila 0
	assign col_0_in_b_1 = row_in_b_1[7:0];    // Columna 0, fila 1
	assign col_0_in_b_2 = row_in_b_2[7:0];    // Columna 0, fila 2
	assign col_0_in_b_3 = row_in_b_3[7:0];    // Columna 0, fila 3

	assign col_1_in_b_0 = row_in_b_0[15:8];   // Columna 1, fila 0
	assign col_1_in_b_1 = row_in_b_1[15:8];   // Columna 1, fila 1
	assign col_1_in_b_2 = row_in_b_2[15:8];   // Columna 1, fila 2
	assign col_1_in_b_3 = row_in_b_3[15:8];   // Columna 1, fila 3

	assign col_2_in_b_0 = row_in_b_0[23:16];  // Columna 2, fila 0
	assign col_2_in_b_1 = row_in_b_1[23:16];  // Columna 2, fila 1
	assign col_2_in_b_2 = row_in_b_2[23:16];  // Columna 2, fila 2
	assign col_2_in_b_3 = row_in_b_3[23:16];  // Columna 2, fila 3

	assign col_3_in_b_0 = row_in_b_0[31:24];  // Columna 3, fila 0
	assign col_3_in_b_1 = row_in_b_1[31:24];  // Columna 3, fila 1
	assign col_3_in_b_2 = row_in_b_2[31:24];  // Columna 3, fila 2
	assign col_3_in_b_3 = row_in_b_3[31:24];  // Columna 3, fila 3
		
		

//////////////////////////////////////////////////////////////////////////////////////	 
		inverseMixColumns inv_mixColumns_inst_0 (
        .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b00),
        .result(inv_mixColumns_result[7:0]) 
		);
		inverseMixColumns inv_mixColumns_inst_1 (
        .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b00),
        .result(inv_mixColumns_result[39:32]) 
		);
		
		inverseMixColumns inv_mixColumns_inst_2 (
        .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b00),
        .result(inv_mixColumns_result[71:64]) 
		);
		
		inverseMixColumns inv_mixColumns_inst_3 (
        .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b00),
        .result(inv_mixColumns_result[103:96]) 
		);
		
		inverseMixColumns inv_mixColumns_inst_4 (
        .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b01),
        .result(inv_mixColumns_result[15:8]) 
		);
		inverseMixColumns inv_mixColumns_inst_5 (
        .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b01),
        .result(inv_mixColumns_result[47:40]) 
		);
		inverseMixColumns inv_mixColumns_inst_6 (
        .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b01),
        .result(inv_mixColumns_result[79:72]) 
		);
		inverseMixColumns inv_mixColumns_inst_7 (
        .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b01),
        .result(inv_mixColumns_result[111:104]) 
		);
		
		inverseMixColumns inv_mixColumns_inst_8 (
        .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b10),
        .result(inv_mixColumns_result[23:16]) 
		);
		inverseMixColumns inv_mixColumns_inst_9 (
        .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b10),
        .result(inv_mixColumns_result[55:48]) 
		);
		inverseMixColumns inv_mixColumns_inst_10 (
        .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b10),
        .result(inv_mixColumns_result[87:80]) 
		);
		inverseMixColumns inv_mixColumns_inst_11 (
        .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b10),
        .result(inv_mixColumns_result[119:112]) 
		);
		
		inverseMixColumns inv_mixColumns_inst_12 (
        .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b11),
        .result(inv_mixColumns_result[31:24]) 
		);
		inverseMixColumns inv_mixColumns_inst_13 (
        .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b11),
        .result(inv_mixColumns_result[63:56]) 
		);
		inverseMixColumns inv_mixColumns_inst_14 (
        .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b11),
        .result(inv_mixColumns_result[95:88]) 
		);
		inverseMixColumns inv_mixColumns_inst_15 (
        .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b11),
        .result(inv_mixColumns_result[127:120]) 
		);
//////////////////////////////////////////////////////////////////////////////////////	 
	
	inverseShiftRows inverseShiftRows_instance(
			.matrix_in(srcA_vector), 
			.matrix_out(inv_shiftRows_result)
	);	
	
//////////////////////////////////////////////////////////////////////////////////////	 
	inverseSubBytes inv_subBytes_instance_0 (
		  .byte_in(col_0_in_a_0),  // srcA_vector[7:0]
		  .byte_out(inv_subBytes_result[7:0])
	);

	inverseSubBytes inv_subBytes_instance_1 (
		  .byte_in(col_1_in_a_0),  // srcA_vector[15:8]
		  .byte_out(inv_subBytes_result[15:8])
	);

	inverseSubBytes inv_subBytes_instance_2 (
		  .byte_in(col_2_in_a_0),  // srcA_vector[23:16]
		  .byte_out(inv_subBytes_result[23:16])
	);

	inverseSubBytes inv_subBytes_instance_3 (
		  .byte_in(col_3_in_a_0),  // srcA_vector[31:24]
		  .byte_out(inv_subBytes_result[31:24])
	);

	inverseSubBytes inv_subBytes_instance_4 (
		  .byte_in(col_0_in_a_1),  // srcA_vector[39:32]
		  .byte_out(inv_subBytes_result[39:32])
	);

	inverseSubBytes inv_subBytes_instance_5 (
		  .byte_in(col_1_in_a_1),  // srcA_vector[47:40]
		  .byte_out(inv_subBytes_result[47:40])
	);

	inverseSubBytes inv_subBytes_instance_6 (
		  .byte_in(col_2_in_a_1),  // srcA_vector[55:48]
		  .byte_out(inv_subBytes_result[55:48])
	);

	inverseSubBytes inv_subBytes_instance_7 (
		  .byte_in(col_3_in_a_1),  // srcA_vector[63:56]
		  .byte_out(inv_subBytes_result[63:56])
	);

	inverseSubBytes inv_subBytes_instance_8 (
		  .byte_in(col_0_in_a_2),  // srcA_vector[71:64]
		  .byte_out(inv_subBytes_result[71:64])
	);

	inverseSubBytes inv_subBytes_instance_9 (
		  .byte_in(col_1_in_a_2),  // srcA_vector[79:72]
		  .byte_out(inv_subBytes_result[79:72])
	);

	inverseSubBytes inv_subBytes_instance_10 (
		  .byte_in(col_2_in_a_2),  // srcA_vector[87:80]
		  .byte_out(inv_subBytes_result[87:80])
	);

	inverseSubBytes inv_subBytes_instance_11 (
		  .byte_in(col_3_in_a_2),  // srcA_vector[95:88]
		  .byte_out(inv_subBytes_result[95:88])
	);

	inverseSubBytes inv_subBytes_instance_12 (
		  .byte_in(col_0_in_a_3),  // srcA_vector[103:96]
		  .byte_out(inv_subBytes_result[103:96])
	);

	inverseSubBytes inv_subBytes_instance_13 (
		  .byte_in(col_1_in_a_3),  // srcA_vector[111:104]
		  .byte_out(inv_subBytes_result[111:104])
	);

	inverseSubBytes inv_subBytes_instance_14 (
		  .byte_in(col_2_in_a_3),  // srcA_vector[119:112]
		  .byte_out(inv_subBytes_result[119:112])
	);

	inverseSubBytes inv_subBytes_instance_15 (
		  .byte_in(col_3_in_a_3),  // srcA_vector[127:120]
		  .byte_out(inv_subBytes_result[127:120])
	);



//////////////////////////////////////////////////////////////////////////////////////	 
	
	
	
endmodule
