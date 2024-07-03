module Processor (
    input logic clk,
    input logic reset,
    input logic select,
    input logic [15:0] offset,
    output logic [15:0] ROM_data
);

    // Interconexiones
    logic [15:0] pc_address;
    logic [15:0] pc_incremented;
    logic [15:0] mux_output;
	 logic [15:0] instruction_fetch;
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
        .data0(pc_address),
        .data1(pc_incremented),
        .select(select),
        .out(mux_output)
    );

    // Instanciar el módulo ROM
    ROM rom_memory (
        .address(pc_address[7:0]), // Usando solo los 8 bits menos significativos
        .clock(clk),
        .q(ROM_data)
    );
	 
	 FetchDecode_register FetchDecode_register_instance (
        .clk(clk),
		  .reset(reset),
        .instruction_in(instruction_fetch),
        .instruction_out(instruction_decode)
    );

endmodule
