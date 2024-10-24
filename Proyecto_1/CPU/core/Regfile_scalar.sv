module Regfile_scalar(input logic clk,
					input logic wre,
					input logic [4:0] a1, a2, a3,
					input logic [15:0] wd3,
					output logic [15:0] rd1, rd2, rd3
);
	logic [15:0] rf[31:0] = '{default: 16'b0}; //vector con 32 registros de 16 bits cada uno
	always_ff @(negedge clk)
		if (wre) rf[a3] <= wd3;
		
	assign rd1 = rf[a1];
	assign rd2 = rf[a2];
	assign rd3 = rf[a3];
endmodule
