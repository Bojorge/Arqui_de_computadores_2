module controlUnit (
    input logic [4:0] opCode,
	 output logic [19:0] control_signals // salida concatenada
);
	logic load; // indica si la operacion carga datos desde memoria
	logic wre;	// write register enable
	logic [4:0] aluOp;	// operacion que debe realizar la ALU
	logic [1:0] select_writeback_data_mux; // mux que elige entre el dato calculado en la alu o el dato que sale de memoria
	
	logic [4:0] aluVectorOp;
	logic [1:0] select_writeback_vector_data_mux;
	logic vector_wre = 1'b0; // write register enableV
	logic write_memory_enable_a ; // indica si la operacion escribe o no en la memoria (escalares)
	logic write_memory_enable_b ; // indica si la operacion escribe o no en la memoria (vectores)
	
	
	// Definición de las salidas en función del opCode
	always_comb begin
		case (opCode)		  
			// nop/stall
			5'b00000: begin
			   load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00000;
				aluVectorOp = 5'b00000;
			end
			// str: store 16 bits escalar
			5'b00001: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b1;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00001;
				aluVectorOp = 5'b00000;
			end
			// ldr: load 16 bits escalar
			5'b00010: begin
				load = 1'b1;
				wre = 1'b1;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00010;
				aluVectorOp = 5'b00000;
			end
			// add_1: incremento unitario
			5'b00100: begin
				load = 1'b0;
				wre = 1'b1;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b01;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00100;
				aluVectorOp = 5'b00000;
			end
			// add: suma de dos registros
			5'b00101: begin
				load = 1'b0;
				wre = 1'b1;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b01;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00101;
				aluVectorOp = 5'b00000;
			end
			// xor
			5'b00110: begin
				load = 1'b0;
				wre = 1'b1;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b01;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00110;
				aluVectorOp = 5'b00000;
			end
			// mul
			5'b00111: begin
				load = 1'b0;
				wre = 1'b1;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b01;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00111;
				aluVectorOp = 5'b00000;
			end
			// bne: salta si los valores que compara son diferentes
			5'b00011: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00000;
				aluVectorOp = 5'b00000;
			end
			// vstr: store 128 bits vectorial
			5'b10001: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b1;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10001;
			end
			// vldr: load 128 bits vectorial
			5'b10010: begin
				load = 1'b1;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10010;
			end
			// AddRoundKey
			5'b10011: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10011;
			end
			// ShiftRows
			5'b10100: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10100;
			end
			// MixColumns
			5'b10101: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10101;
			end
			// RotWord
			5'b10110: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10110;
			end
			// RCon
			5'b10111: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b10111;
			end
			// subBytes
			5'b11000: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11000;
			end
			// roundKey
			5'b11001: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11001;
			end
			// xorColumns
			5'b11010: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11010;
			end
			// InverseShiftRows 
			5'b11101: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11101;
			end
			// InverseMixColumns 
			5'b11100: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11100;
			end
			// InverseSubBytes 
			5'b11110: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b1;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b01;
				aluOp = 5'b00000;
				aluVectorOp = 5'b11110;
			end
			default: begin
				load = 1'b0;
				wre = 1'b0;
				vector_wre = 1'b0;
				write_memory_enable_a = 1'b0;
				write_memory_enable_b = 1'b0;
				select_writeback_data_mux = 2'b00;
				select_writeback_vector_data_mux = 2'b00;
				aluOp = 5'b00000;
				aluVectorOp = 5'b00000;
			end
		endcase
		control_signals = {1'b0,  load, wre, vector_wre, write_memory_enable_a, write_memory_enable_b, select_writeback_data_mux, select_writeback_vector_data_mux, aluOp, aluVectorOp};
	end
endmodule
