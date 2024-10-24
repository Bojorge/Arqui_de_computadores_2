module controlUnit (
    input logic [3:0] opCode,
	 //input logic flagN,	// negative result flagN = 1
	 //input logic flagZ,	// zero result flagZ = 1
    output logic wre,	// write register enable
	 output logic [3:0] aluOp,	// operacion que debe realizar la ALU
);

    // Definición de las salidas en función del opCode
    always_comb begin
        case (opCode)
		  
				// nop/stall
            4'b0000: begin
                wre = 1'b0;
					 aluOp =4'b0000;
            end
            
				// add
            4'b0001: begin
                wre = 1'b1;
					 aluOp =4'b0001;
            end
            
            
            default: begin
                wre = 1'b0;
					 aluOp =4'b0000;
            end
        endcase
    end

endmodule