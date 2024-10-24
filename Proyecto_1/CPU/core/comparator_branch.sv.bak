module comparator_branch (
    input logic [3:0] opCode,
    input logic [15:0] rs1_value,
    input logic [15:0] rs2_value,
    output logic [1:0] select_pc_mux
);

    always_comb begin
        case (opCode)
		  
				// be = Branch on Equal
            4'b0100: begin
                if (rs1_value == rs2_value) begin
                    select_pc_mux = 2'b01; // toma la direccion del branch
                end else begin
                    select_pc_mux = 2'b00; // toma la direccion de PC+1
                end
            end
            

            default: begin
                select_pc_mux = 2'b00; // Valor por defecto = PC+1
            end
        endcase
    end

endmodule
