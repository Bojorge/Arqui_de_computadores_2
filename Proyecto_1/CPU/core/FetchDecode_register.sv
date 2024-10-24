module FetchDecode_register (
    input logic clk,
    input logic reset,
    input logic [1:0] flush,
	 input logic [1:0] nop,
    input logic [15:0] pc,
    input logic [19:0] instruction_in,
    output logic [15:0] pc_decode,
    output logic [19:0] instruction_out
);

    // Registros de almacenamiento de 16 bits
    logic [19:0] instruction_out_reg;
    logic [15:0] pc_decode_reg;

    // Proceso de escritura en los registros
    always_ff @(posedge clk) begin
        if (reset) begin
            instruction_out_reg <= 20'b0; // Inicializar el registro de instrucción a 0 cuando se activa el reset
            pc_decode_reg <= 16'b0; // Inicializar el registro del PC a 0 cuando se activa el reset
        end 
		  if (flush == 2'b00) begin
				if (nop == 2'b00) begin
					instruction_out_reg <= instruction_in; // Actualizar la instrucción
					pc_decode_reg <= pc; // Actualizar el valor del PC
				end
				else if (nop == 2'b01) begin
					instruction_out_reg <= instruction_out; // No actualizar la instrucción
					pc_decode_reg <= pc_decode; // No actualizar el valor del PC
				end
        end 
		  else if (flush == 2'b01) begin
            instruction_out_reg <= 20'b0; // Si flush es 01, la salida de la instrucción es 0
            pc_decode_reg <= pc; 
				
        end
    end

    // Salidas del registro
    assign instruction_out = instruction_out_reg;
    assign pc_decode = pc_decode_reg;

endmodule
