module encrypt (
	input logic clk,
   input logic [127:0] srcA_vector, // Primer operando
   input logic [127:0] srcB_vector, // Segundo operando
   output logic [127:0] addRoundKey_result,
	output logic [127:0] shiftRows_result,
	output logic [127:0] mixColumns_result,
	output logic [127:0] subBytes_result,
	output logic [127:0] new_key
			
);

	// Variables para almacenar los resultados de las operaciones
	logic [31:0] rotWord_column_result, subBytes_key_result, new_key_aux_0, new_key_aux_1, new_key_aux_2, new_key_aux_3;
	
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
		
		
		
	addRoundKey add_round_key_inst_0 (
        .col_in0_a(col_0_in_a_0), 
        .col_in1_a(col_0_in_a_1),
        .col_in2_a(col_0_in_a_2),
        .col_in3_a(col_0_in_a_3),
        .col_in0_b(col_0_in_b_0),
        .col_in1_b(col_0_in_b_1),
        .col_in2_b(col_0_in_b_2),
        .col_in3_b(col_0_in_b_3),
        .col_out0(addRoundKey_result[7:0]),  
		  .col_out1(addRoundKey_result[39:32]), 
		  .col_out2(addRoundKey_result[71:64]), 
		  .col_out3(addRoundKey_result[103:96])
    );
	 
	addRoundKey add_round_key_inst_1 (
		 .col_in0_a(col_1_in_a_0), 
		 .col_in1_a(col_1_in_a_1),
		 .col_in2_a(col_1_in_a_2),
		 .col_in3_a(col_1_in_a_3),
		 .col_in0_b(col_1_in_b_0),
		 .col_in1_b(col_1_in_b_1),
		 .col_in2_b(col_1_in_b_2),
		 .col_in3_b(col_1_in_b_3),
		 .col_out0(addRoundKey_result[15:8]),  
		 .col_out1(addRoundKey_result[47:40]), 
		 .col_out2(addRoundKey_result[79:72]), 
		 .col_out3(addRoundKey_result[111:104])
	);

	addRoundKey add_round_key_inst_2 (
		 .col_in0_a(col_2_in_a_0), 
		 .col_in1_a(col_2_in_a_1),
		 .col_in2_a(col_2_in_a_2),
		 .col_in3_a(col_2_in_a_3),
		 .col_in0_b(col_2_in_b_0),
		 .col_in1_b(col_2_in_b_1),
		 .col_in2_b(col_2_in_b_2),
		 .col_in3_b(col_2_in_b_3),
		 .col_out0(addRoundKey_result[23:16]),  
		 .col_out1(addRoundKey_result[55:48]), 
		 .col_out2(addRoundKey_result[87:80]), 
		 .col_out3(addRoundKey_result[119:112])
	);

	addRoundKey add_round_key_inst_3 (
		 .col_in0_a(col_3_in_a_0), 
		 .col_in1_a(col_3_in_a_1),
		 .col_in2_a(col_3_in_a_2),
		 .col_in3_a(col_3_in_a_3),
		 .col_in0_b(col_3_in_b_0),
		 .col_in1_b(col_3_in_b_1),
		 .col_in2_b(col_3_in_b_2),
		 .col_in3_b(col_3_in_b_3),
		 .col_out0(addRoundKey_result[31:24]),  
		 .col_out1(addRoundKey_result[63:56]), 
		 .col_out2(addRoundKey_result[95:88]), 
		 .col_out3(addRoundKey_result[127:120])
	);
//////////////////////////////////////////////////////////////////////////////////////	 
		mixColumns mixColumns_inst_0 (
		  .row(2'b00),
        .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b00),
        .result(mixColumns_result[7:0]) 
		);
		mixColumns mixColumns_inst_1 (
        .row(2'b01),
		  .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b00),
        .result(mixColumns_result[39:32]) 
		);
		
		mixColumns mixColumns_inst_2 (
        .row(2'b10),
		  .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b00),
        .result(mixColumns_result[71:64]) 
		);
		
		mixColumns mixColumns_inst_3 (
        .row(2'b11),
		  .col_in0(col_0_in_a_0), 
        .col_in1(col_0_in_a_1), 
        .col_in2(col_0_in_a_2), 
        .col_in3(col_0_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b00),
        .result(mixColumns_result[103:96]) 
		);
		
		mixColumns mixColumns_inst_4 (
        .row(2'b00),
		  .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b01),
        .result(mixColumns_result[15:8]) 
		);
		mixColumns mixColumns_inst_5 (
        .row(2'b01),
		  .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b01),
        .result(mixColumns_result[47:40]) 
		);
		mixColumns mixColumns_inst_6 (
        .row(2'b10),
		  .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b01),
        .result(mixColumns_result[79:72]) 
		);
		mixColumns mixColumns_inst_7 (
        .row(2'b11),
		  .col_in0(col_1_in_a_0), 
        .col_in1(col_1_in_a_1), 
        .col_in2(col_1_in_a_2), 
        .col_in3(col_1_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b01),
        .result(mixColumns_result[111:104]) 
		);
		
		mixColumns mixColumns_inst_8 (
        .row(2'b00),
		  .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b10),
        .result(mixColumns_result[23:16]) 
		);
		mixColumns mixColumns_inst_9 (
        .row(2'b01),
		  .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b10),
        .result(mixColumns_result[55:48]) 
		);
		mixColumns mixColumns_inst_10 (
        .row(2'b10),
		  .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b10),
        .result(mixColumns_result[87:80]) 
		);
		mixColumns mixColumns_inst_11 (
        .row(2'b11),
		  .col_in0(col_2_in_a_0), 
        .col_in1(col_2_in_a_1), 
        .col_in2(col_2_in_a_2), 
        .col_in3(col_2_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b10),
        .result(mixColumns_result[119:112]) 
		);
		
		mixColumns mixColumns_inst_12 (
        .row(2'b00),
		  .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b00), 
        .col_idx(2'b11),
        .result(mixColumns_result[31:24]) 
		);
		mixColumns mixColumns_inst_13 (
        .row(2'b01),
		  .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b01), 
        .col_idx(2'b11),
        .result(mixColumns_result[63:56]) 
		);
		mixColumns mixColumns_inst_14 (
        .row(2'b10),
		  .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b10), 
        .col_idx(2'b11),
        .result(mixColumns_result[95:88]) 
		);
		mixColumns mixColumns_inst_15 (
        .row(2'b11),
		  .col_in0(col_3_in_a_0), 
        .col_in1(col_3_in_a_1), 
        .col_in2(col_3_in_a_2), 
        .col_in3(col_3_in_a_3), 
        .row_idx(2'b11), 
        .col_idx(2'b11),
        .result(mixColumns_result[127:120]) 
		);
//////////////////////////////////////////////////////////////////////////////////////	 
	
		shiftRows shiftRows_instance(
		.matrix_in(srcA_vector), 
		.matrix_out(shiftRows_result)
	);	
//////////////////////////////////////////////////////////////////////////////////////	 
	subBytes subBytes_instance_0 (
		  .byte_in(col_0_in_a_0),  // srcA_vector[7:0]
		  .byte_out(subBytes_result[7:0])
	);

	subBytes subBytes_instance_1 (
		  .byte_in(col_1_in_a_0),  // srcA_vector[15:8]
		  .byte_out(subBytes_result[15:8])
	);

	subBytes subBytes_instance_2 (
		  .byte_in(col_2_in_a_0),  // srcA_vector[23:16]
		  .byte_out(subBytes_result[23:16])
	);

	subBytes subBytes_instance_3 (
		  .byte_in(col_3_in_a_0),  // srcA_vector[31:24]
		  .byte_out(subBytes_result[31:24])
	);

	subBytes subBytes_instance_4 (
		  .byte_in(col_0_in_a_1),  // srcA_vector[39:32]
		  .byte_out(subBytes_result[39:32])
	);

	subBytes subBytes_instance_5 (
		  .byte_in(col_1_in_a_1),  // srcA_vector[47:40]
		  .byte_out(subBytes_result[47:40])
	);

	subBytes subBytes_instance_6 (
		  .byte_in(col_2_in_a_1),  // srcA_vector[55:48]
		  .byte_out(subBytes_result[55:48])
	);

	subBytes subBytes_instance_7 (
		  .byte_in(col_3_in_a_1),  // srcA_vector[63:56]
		  .byte_out(subBytes_result[63:56])
	);

	subBytes subBytes_instance_8 (
		  .byte_in(col_0_in_a_2),  // srcA_vector[71:64]
		  .byte_out(subBytes_result[71:64])
	);

	subBytes subBytes_instance_9 (
		  .byte_in(col_1_in_a_2),  // srcA_vector[79:72]
		  .byte_out(subBytes_result[79:72])
	);

	subBytes subBytes_instance_10 (
		  .byte_in(col_2_in_a_2),  // srcA_vector[87:80]
		  .byte_out(subBytes_result[87:80])
	);

	subBytes subBytes_instance_11 (
		  .byte_in(col_3_in_a_2),  // srcA_vector[95:88]
		  .byte_out(subBytes_result[95:88])
	);

	subBytes subBytes_instance_12 (
		  .byte_in(col_0_in_a_3),  // srcA_vector[103:96]
		  .byte_out(subBytes_result[103:96])
	);

	subBytes subBytes_instance_13 (
		  .byte_in(col_1_in_a_3),  // srcA_vector[111:104]
		  .byte_out(subBytes_result[111:104])
	);

	subBytes subBytes_instance_14 (
		  .byte_in(col_2_in_a_3),  // srcA_vector[119:112]
		  .byte_out(subBytes_result[119:112])
	);

	subBytes subBytes_instance_15 (
		  .byte_in(col_3_in_a_3),  // srcA_vector[127:120]
		  .byte_out(subBytes_result[127:120])
	);


//////////////////////////////////////////////////////////////////////////////////////	
	rotWord rot_word_instance (
    .col_in0(col_3_in_a_0),   // Celda 0 de la columna de entrada
    .col_in1(col_3_in_a_1),   // Celda 1 de la columna de entrada
    .col_in2(col_3_in_a_2),   // Celda 2 de la columna de entrada
    .col_in3(col_3_in_a_3),   // Celda 3 de la columna de entrada
    .col_out0(rotWord_column_result[7:0]),    // Celda 0 de la columna de salida
    .col_out1(rotWord_column_result[15:8]),    // Celda 1 de la columna de salida
    .col_out2(rotWord_column_result[23:16]),    // Celda 2 de la columna de salida
    .col_out3(rotWord_column_result[31:24])     // Celda 3 de la columna de salida
);

//////////////////////////////////////////////////////////////////////////////////////	 
	
	subBytes subBytes_instance_16 (
		 .byte_in(rotWord_column_result[7:0]),
		 .byte_out(subBytes_key_result[7:0])
	);

	subBytes subBytes_instance_17 (
		 .byte_in(rotWord_column_result[15:8]),
		 .byte_out(subBytes_key_result[15:8])
	);

	subBytes subBytes_instance_18 (
		 .byte_in(rotWord_column_result[23:16]),
		 .byte_out(subBytes_key_result[23:16])
	);

	subBytes subBytes_instance_19 (
		 .byte_in(rotWord_column_result[31:24]),
		 .byte_out(subBytes_key_result[31:24])
	);
//////////////////////////////////////////////////////////////////////////////////////	
	Rcon rcon_instance (
		 .round(4'b0000),               // Número de ronda (4 bits)
		 .col_in0(col_0_in_a_0),        // Primera celda de la primera columna
		 .col_in1(col_0_in_a_1),      // Segunda celda de la primera columna
		 .col_in2(col_0_in_a_2),      // Tercera celda de la primera columna
		 .col_in3(col_0_in_a_3),     // Cuarta celda de la primera columna
		 .col_in0_2(subBytes_key_result[7:0]),     // Primera celda de la última columna
		 .col_in1_2(subBytes_key_result[15:8]),    // Segunda celda de la última columna
		 .col_in2_2(subBytes_key_result[23:16]),    // Tercera celda de la última columna
		 .col_in3_2(subBytes_key_result[31:24]),   // Cuarta celda de la última columna
		 .col_out0(new_key_aux_0[7:0]),   // Primera celda de la columna de salida
		 .col_out1(new_key_aux_0[15:8]),  // Segunda celda de la columna de salida
		 .col_out2(new_key_aux_0[23:16]), // Tercera celda de la columna de salida
		 .col_out3(new_key_aux_0[31:24])  // Cuarta celda de la columna de salida
	);
	
	assign new_key[7:0] = new_key_aux_0[7:0];
	assign new_key[39:32] = new_key_aux_0[15:8];
	assign new_key[71:64] = new_key_aux_0[23:16];
	assign new_key[103:96] = new_key_aux_0[31:24];
	
////////////////////////////////////////////////////////////////////////////////////// 
	xorColumns xor_instance_1 (
		 .col_in0(col_1_in_a_0),      // Primera celda de la columna 1
		 .col_in1(col_1_in_a_1),     // Segunda celda de la columna 1
		 .col_in2(col_1_in_a_2),    // Tercera celda de la columna 1
		 .col_in3(col_1_in_a_3),    // Cuarta celda de la columna 1
		 .col_in0_2(new_key[7:0]),    // Primera celda de la columna 2
		 .col_in1_2(new_key[15:8]),   // Segunda celda de la columna 2
		 .col_in2_2(new_key[23:16]),  // Tercera celda de la columna 2
		 .col_in3_2(new_key[31:24]),  // Cuarta celda de la columna 2
		 .col_out0(new_key_aux_1[7:0]),      // Primera celda de la salida
		 .col_out1(new_key_aux_1[15:8]),     // Segunda celda de la salida
		 .col_out2(new_key_aux_1[23:16]),    // Tercera celda de la salida
		 .col_out3(new_key_aux_1[31:24])     // Cuarta celda de la salida
	);
	
	assign new_key[15:8] = new_key_aux_1[7:0];
	assign new_key[47:40] = new_key_aux_1[15:8];
	assign new_key[79:72] = new_key_aux_1[23:16];
	assign new_key[111:104] = new_key_aux_1[31:24];
	
	xorColumns xor_instance_2 (
		 .col_in0(col_2_in_a_0),      // Primera celda de la columna 1
		 .col_in1(col_2_in_a_1),     // Segunda celda de la columna 1
		 .col_in2(col_2_in_a_2),    // Tercera celda de la columna 1
		 .col_in3(col_2_in_a_3),    // Cuarta celda de la columna 1
		 .col_in0_2(new_key[15:8]),    // Primera celda de la columna 2
		 .col_in1_2(new_key[47:40]),   // Segunda celda de la columna 2
		 .col_in2_2(new_key[79:72]),  // Tercera celda de la columna 2
		 .col_in3_2(new_key[111:104]),  // Cuarta celda de la columna 2
		 .col_out0(new_key_aux_2[7:0]),      // Primera celda de la salida
		 .col_out1(new_key_aux_2[15:8]),     // Segunda celda de la salida
		 .col_out2(new_key_aux_2[23:16]),    // Tercera celda de la salida
		 .col_out3(new_key_aux_2[31:24])     // Cuarta celda de la salida
	);
	
	assign new_key[23:16] = new_key_aux_2[7:0];
	assign new_key[55:48] = new_key_aux_2[15:8];
	assign new_key[87:80] = new_key_aux_2[23:16];
	assign new_key[119:112] = new_key_aux_2[31:24];

	xorColumns xor_instance_3 (
		 .col_in0(col_3_in_a_0),      // Primera celda de la columna 1
		 .col_in1(col_3_in_a_1),     // Segunda celda de la columna 1
		 .col_in2(col_3_in_a_2),    // Tercera celda de la columna 1
		 .col_in3(col_3_in_a_3),    // Cuarta celda de la columna 1
		 .col_in0_2(new_key[23:16]),    // Primera celda de la columna 2
		 .col_in1_2(new_key[55:48]),   // Segunda celda de la columna 2
		 .col_in2_2(new_key[87:80]),  // Tercera celda de la columna 2
		 .col_in3_2(new_key[119:112]),  // Cuarta celda de la columna 2	 
		 .col_out0(new_key_aux_3[7:0]),      // Primera celda de la salida
		 .col_out1(new_key_aux_3[15:8]),     // Segunda celda de la salida
		 .col_out2(new_key_aux_3[23:16]),    // Tercera celda de la salida
		 .col_out3(new_key_aux_3[31:24])     // Cuarta celda de la salida
	);

	assign new_key[31:24] = new_key_aux_3[7:0];
	assign new_key[63:56] = new_key_aux_3[15:8];
	assign new_key[95:88] = new_key_aux_3[23:16];
	assign new_key[127:120] = new_key_aux_3[31:24];
	
	
	
endmodule
