module substractor_branch (
				input logic [15:0] a, 
				input logic [15:0] b,
				output logic [15:0] y
);

	assign y = a - b;
	
endmodule
