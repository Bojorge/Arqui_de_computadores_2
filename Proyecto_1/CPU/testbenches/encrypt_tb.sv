`timescale 1ps/1ps
module encrypt_tb;

	logic clk, reset;
	logic [127:0] srcA_vector;
   logic [127:0] srcB_vector;
	logic [127:0] subBytes_result, mixColumns_result, shiftRows_result, addRoundKey_result, new_key; 	

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
	
	always #10 clk = ~clk;
	initial begin
		srcA_vector = 128'h746578746f2061206369667261727365;
		srcB_vector = 128'h00112233445566778899aabbccddeeff;
		
		reset = 1;		
		clk = 0;               
      reset = 0;            
      
		#100
		$finish;
	end


endmodule
