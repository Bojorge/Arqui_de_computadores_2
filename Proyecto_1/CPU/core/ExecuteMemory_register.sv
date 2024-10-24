module ExecuteMemory_register (
   input logic clk,
   input logic reset,
   input logic wre_execute,
	input logic vector_wre_execute,
   input logic [7:0] ALUresult_in,
   input logic [127:0] ALUvectorResult_in,
   input logic [1:0] select_writeback_data_mux_execute,
	input logic [1:0] select_writeback_vector_data_mux_execute,
   input logic write_memory_enable_a_execute,
	input logic write_memory_enable_b_execute,
	input logic [4:0] rs1_execute,
   input logic [4:0] rs2_execute,
   input logic [15:0] srcA_execute,
   input logic [15:0] srcB_execute,
   input logic [4:0] rd_execute,
	input logic [127:0] vector_srcB_execute,
	
   output logic wre_memory,
	output logic vector_wre_memory,
   output logic [15:0] ALUresult_out,
	output logic [127:0] ALUvectorResult_out,
	output logic [1:0] select_writeback_data_mux_memory,
	output logic [1:0] select_writeback_vector_data_mux_memory,
   output logic write_memory_enable_a_memory,
	output logic write_memory_enable_b_memory,
	output logic [4:0] rs1_memory,
   output logic [4:0] rs2_memory,
   output logic [15:0] srcA_memory,
   output logic [15:0] srcB_memory,
   output logic [4:0] rd_memory,
	output logic [127:0] vector_srcB_memory
);

    // Registros internos
	logic wre;
	logic vector_wre;
	logic [15:0] ALUresult;
	logic [127:0] ALUvectorResult;
	logic [1:0] select_writeback_data_mux;
	logic [1:0] select_writeback_vector_data_mux;
	logic write_memory_enable_a;
	logic write_memory_enable_b;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [15:0] srcA;
   logic [15:0] srcB;
   logic [4:0] rd;
	logic [127:0] vector_srcB;
   
   // Proceso de escritura en el registro
   always_ff @(posedge clk) begin
		if (reset) begin
			wre <= 1'b0;
			vector_wre <= 1'b0;
			ALUresult <= 16'b0;
			ALUvectorResult <= 128'b0;
			select_writeback_data_mux <= 2'b0;
			select_writeback_vector_data_mux <= 2'b0;
			write_memory_enable_a <= 1'b0;
			write_memory_enable_b <= 1'b0;
			rs1 <= 5'b0;
			rs2 <= 5'b0;
         srcA <= 16'b0;
         srcB <= 16'b0;
         rd <= 5'b0;
			vector_srcB <= 128'b0;
						
		end else begin
			wre <= wre_execute;
			vector_wre <= vector_wre_execute;
			ALUresult <= ALUresult_in;
			ALUvectorResult <= ALUvectorResult_in;
			select_writeback_data_mux <= select_writeback_data_mux_execute;
			select_writeback_vector_data_mux <= select_writeback_vector_data_mux_execute;
			write_memory_enable_a <= write_memory_enable_a_execute;
			write_memory_enable_b <= write_memory_enable_b_execute;
			rs1 <= rs1_execute;
			rs2 <= rs2_execute;
         srcA <= srcA_execute;
         srcB <= srcB_execute;
         rd <= rd_execute;
			vector_srcB <= vector_srcB_execute;
      end
	end
	
   // Salidas del registro
	assign wre_memory = wre;
	assign vector_wre_memory = vector_wre;
   assign ALUresult_out = ALUresult;
	assign ALUvectorResult_out = ALUvectorResult;
   assign select_writeback_data_mux_memory = select_writeback_data_mux;
	assign select_writeback_vector_data_mux_memory = select_writeback_vector_data_mux;
   assign write_memory_enable_a_memory = write_memory_enable_a;
	assign write_memory_enable_b_memory = write_memory_enable_b;
   assign rs1_memory = rs1;
	assign rs2_memory = rs2; 
	assign srcA_memory = srcA;
   assign srcB_memory = srcB;
   assign rd_memory = rd;
	assign vector_srcB_memory = vector_srcB;
endmodule
