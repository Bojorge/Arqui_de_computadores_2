`timescale 1ps/1ps
module Fetch_Stage_tb;
    
   logic clk = 0;
	logic reset = 0;
	logic select_next_PC = 0;
	logic [15:0] pc_address;
   logic [15:0] jumpAddress;
	logic [15:0] pc_incremented;
	logic [15:0] offset = 16'b1;
   logic [15:0] mux_output;
	logic [15:0] instruction_fetched;
	logic [15:0] instruction_decode;
	 

    // Instanciar el módulo PC_register
    PC_register pc_reg (
        .clk(clk),
        .reset(reset),
        .address_in(mux_output),
        .address_out(pc_address)
    );

    // Instanciar el módulo PC_adder
    PC_adder pc_add (
        .address(pc_address),
        .offset(offset),
        .PC(pc_incremented)
    );

    // Instanciar el módulo mux_2inputs
    mux_2inputs mux_2inputs_PC (
        .data0(pc_incremented),
        .data1(jumpAddress),
        .select(select_next_PC),
        .out(mux_output)
    );

    // Instanciar el módulo ROM
    ROM rom_memory (
        .address(pc_address[7:0]), // Usando solo los 8 bits menos significativos porque la memoria es de 256 celdas
        .clock(clk),
        .q(instruction_fetched)
    );

		
		
    FetchDecode_register FetchDecode_register_instance (
        .clk(clk),
		  .reset(reset),
        .instruction_in(instruction_fetched),
        .instruction_out(instruction_decode)
    );
	 
	 	 
    
    always #10 clk = ~clk;
    initial begin
        
		  #100;
        
        // Finalizar la simulación
        $finish;
    end

endmodule
