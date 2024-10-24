module ALU_vectorial (
	input logic clk,
    input logic [4:0] aluVectorOp, // Entrada de control para la operación ALU
    input logic [127:0] srcA_vector, // Primer operando
    input logic [127:0] srcB_vector, // Segundo operando
    output logic [127:0] result_vector // Resultado de la operación
);

	// Variables para almacenar los resultados de las operaciones
	logic [127:0] subBytes_result, mixColumns_result, shiftRows_result, addRoundKey_result, new_key, inv_shiftRows_result, inv_mixColumns_result, inv_subBytes_result; // , rotWord_result, rcon_result
	
   encrypt encrypt_inst(
		.clk(clk),
		.srcA_vector(srcA_vector),
		.srcB_vector(srcB_vector),
		.addRoundKey_result(addRoundKey_result),
		.shiftRows_result(shiftRows_result),
		.mixColumns_result(mixColumns_result),
		.subBytes_result(subBytes_result),
		.new_key(new_key)
	);
	
	decrypt decrypt_inst(
		.clk(clk),
		.srcA_vector(srcA_vector),
		.srcB_vector(srcB_vector),
		.inv_shiftRows_result(inv_shiftRows_result),
		.inv_mixColumns_result(inv_mixColumns_result),
		.inv_subBytes_result(inv_subBytes_result)
	);
	
	
	always_comb begin
		case (aluVectorOp)
			5'b00000: result_vector = 128'b0; // nop
			5'b10011: result_vector = addRoundKey_result;
			5'b10100: result_vector = shiftRows_result; 
			5'b10101: result_vector = mixColumns_result;
			//5'b10110: result_vector = rotWord_result;
			//5'b10111: result_vector = rcon_result;
			5'b11000: result_vector = subBytes_result;
			5'b11001: result_vector = new_key;
			//5'b11010: result_vector = {new_key_aux_3, new_key_aux_2, new_key_aux_1, new_key_aux_0}; //xor columns of the round key
			5'b11100: result_vector = inv_mixColumns_result;
			5'b11101: result_vector = inv_shiftRows_result;
			5'b11110: result_vector = inv_subBytes_result;
			default: result_vector = 128'b0; // Para codigos que no existen
      endcase
    end
endmodule
