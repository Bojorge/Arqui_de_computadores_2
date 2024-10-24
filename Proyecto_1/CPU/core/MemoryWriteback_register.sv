module MemoryWriteback_register (
	input logic clk,
	input logic reset,
	input logic wre_memory,
	input logic vector_wre_memory,
	input logic [1:0] select_writeback_data_mux_memory,
	input logic [1:0] select_writeback_vector_data_mux_memory,
	input logic [7:0] data_from_memory_in,
	input logic [127:0] vector_data_from_memory_in,
	input logic [15:0] calc_data_in,
	input logic [127:0] calc_vector_in,
	input logic [4:0] rs1_memory,
	input logic [4:0] rs2_memory,
	input logic [4:0] rd_memory,
	
	output logic wre_writeback,
	output logic vector_wre_writeback,
	output logic [1:0] select_writeback_data_mux_writeback,
	output logic [1:0] select_writeback_vector_data_mux_writeback,
	output logic [15:0] data_from_memory_out,
	output logic [127:0] vector_data_from_memory_out,
	output logic [15:0] calc_data_out,
	output logic [127:0] calc_vector_out,
	output logic [4:0] rs1_writeback,
	output logic [4:0] rs2_writeback,
	output logic [4:0] rd_writeback
	
	
	
	
);
   logic wre;
	logic vector_wre;
	logic [1:0] select_writeback_data_mux;
	logic [1:0] select_writeback_vector_data_mux;
	logic [15:0] data_from_memory;
	logic [127:0] vector_data_from_memory;
	logic [15:0] calc_data;
	logic [127:0] calc_vector;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [4:0] rd;
	
   // Proceso de escritura en el registro
   always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            wre <= 1'b0;
				vector_wre <= 1'b0;
				select_writeback_data_mux <= 2'b0;
				select_writeback_vector_data_mux <= 2'b0;
				data_from_memory <= 16'b0;
				vector_data_from_memory <= 128'b0;
				calc_data <= 16'b0;
				calc_vector <= 128'b0;
				rs1 <= 5'b0;
				rs2 <= 5'b0;
				rd <= 5'b0;
				
        end else begin
            wre <= wre_memory;
				vector_wre <= vector_wre_memory;
				select_writeback_data_mux <= select_writeback_data_mux_memory;
				select_writeback_vector_data_mux <= select_writeback_vector_data_mux_memory;
				data_from_memory <= {8'b0,data_from_memory_in};
				vector_data_from_memory <= vector_data_from_memory_in;
				calc_data <= calc_data_in;
				calc_vector <= calc_vector_in;
				rs1 <= rs1_memory;
				rs2 <= rs2_memory;
				rd <= rd_memory;
        end
   end
	
    // Salidas del registro
   assign wre_writeback = wre;
	assign vector_wre_writeback = vector_wre;
	assign select_writeback_data_mux_writeback = select_writeback_data_mux;
	assign select_writeback_vector_data_mux_writeback = select_writeback_vector_data_mux;
	assign data_from_memory_out = data_from_memory;
	assign vector_data_from_memory_out = vector_data_from_memory;
	assign calc_data_out = calc_data;
	assign calc_vector_out = calc_vector;
	assign rs1_writeback = rs1;
	assign rs2_writeback = rs2;
	assign rd_writeback = rd;
    
endmodule
