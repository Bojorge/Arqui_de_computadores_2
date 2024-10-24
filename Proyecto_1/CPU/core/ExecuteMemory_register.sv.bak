module ExecuteMemory_register (
    input logic clk,
    input logic [15:0] ALUresult_in,
	 output logic [15:0] ALUresult_out
);

    logic [15:0] ALUresult;   

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        ALUresult <= ALUresult_in;
    end

    // Salidas del registro
    assign ALUresult_out = ALUresult;
	 
endmodule
