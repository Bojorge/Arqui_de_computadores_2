module MemoryWriteback_register (
    input logic clk,
	 input logic [15:0] calcData_in,
	 output logic [15:0] calcData_out,
);

    logic [15:0] calcData;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        calcData <= calcData_in;
    end

    // Salidas del registro
    assign calcData_out = calcData;
    
endmodule
