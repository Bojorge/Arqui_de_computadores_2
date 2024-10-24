module Regfile_vector (
    input logic clk,
    input logic wre,               // señal de habilitación de escritura
    input logic [4:0] a1,          // dirección del primer registro fuente
    input logic [4:0] a2,          // dirección del segundo registro fuente
    input logic [4:0] a3,          // dirección del registro destino
    input logic [127:0] wd3,       // datos de escritura (128 bits)
    output logic [127:0] rd1,      // datos de lectura del primer registro fuente (128 bits)
    output logic [127:0] rd2,       // datos de lectura del segundo registro fuente (128 bits)
	 output logic [127:0] rd3       // datos de registro writeback registro fuente (128 bits)
);
    logic [127:0] rf[31:0] = '{default: 128'b0}; // vector con 32 registros de 128 bits cada uno
	 
    always_ff @(negedge clk)
		if (wre) rf[a3] <= wd3;
		
	assign rd1 = rf[a1];
	assign rd2 = rf[a2];
	assign rd3 = rf[a3];
endmodule
