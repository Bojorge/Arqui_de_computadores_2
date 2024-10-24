`timescale 1ps/1ps
module Memory_Stage_tb ;
   logic clk;
   logic reset;
	logic [7:0] alu_result_execute;
	logic wre_memory, wre_execute;
	logic vector_wre_memory, vector_wre_execute;
	logic [1:0] select_writeback_data_mux_memory, select_writeback_vector_data_mux_memory;
	logic [7:0] alu_result_memory;
	logic [15:0] srcA_memory;
	logic [15:0] srcB_memory;
	logic [4:0] rs1_memory; 
	logic [4:0] rs2_memory;
	logic [4:0] rd_memory;
	logic [2:0] select_forward_mux_A;
	logic [2:0] select_forward_mux_B;
	logic [7:0] data_from_memory;
	logic [15:0] data_from_memory_writeback;
	logic [7:0] alu_result_writeback;
	logic [4:0] rs1_writeback;
	logic [4:0] rs2_writeback;
	logic [4:0] rd_writeback;
	logic [1:0] select_writeback_data_mux_writeback, select_writeback_vector_data_mux_writeback;
	logic vector_wre_writeback;
	logic [127:0] vector_rd1, vector_rd2, vector_rd3;
	logic [127:0] vector_srcA_execute, vector_srcB_execute, vector_srcB_memory;
	logic [127:0] vector_writeback_data, vector_data_from_memory;
	logic [127:0] alu_vector_result_execute;
	logic [127:0] alu_vector_result_memory;
	logic [127:0] alu_vector_result_writeback;
	logic [127:0] writeback_vector;
	logic [4:0] aluVectorOp_execute;
   logic [7:0] ALUresult_in;
   logic [127:0] ALUvectorResult_in;
   logic [1:0] select_writeback_data_mux_execute;
	logic [1:0] select_writeback_vector_data_mux_execute;
   logic write_memory_enable_a_execute;
	logic write_memory_enable_b_execute;
	logic [4:0] rs1_execute;
   logic [4:0] rs2_execute;
   logic [4:0] rd_execute;
	logic [4:0] rd_decode;
	ExecuteMemory_register ExecuteMemory_register_instance (
		.clk(clk),
     	.reset(reset),
     	.wre_execute(wre_execute),
		.vector_wre_execute(vector_wre_execute),
		.ALUresult_in(alu_result_execute),
		.ALUvectorResult_in(alu_vector_result_execute),
		.select_writeback_data_mux_execute(select_writeback_data_mux_execute),
		.select_writeback_vector_data_mux_execute(select_writeback_vector_data_mux_execute),
     	.write_memory_enable_a_execute(write_memory_enable_a_execute),
		.write_memory_enable_b_execute(write_memory_enable_b_execute),
		.rs1_execute(rs1_execute),
     	.rs2_execute(rs2_execute),
		.srcA_execute(srcA_execute),
     	.srcB_execute(alu_src_B),
		.rd_execute(rd_execute),
		.vector_srcB_execute(vector_srcB_execute),
     	.wre_memory(wre_memory),
		.vector_wre_memory(vector_wre_memory),
		.ALUresult_out(alu_result_memory),
		.ALUvectorResult_out(alu_vector_result_memory),
		.select_writeback_data_mux_memory(select_writeback_data_mux_memory),
     	.select_writeback_vector_data_mux_memory(select_writeback_vector_data_mux_memory),
     	.write_memory_enable_a_memory(write_memory_enable_a_memory),
		.write_memory_enable_b_memory(write_memory_enable_b_memory),
		.rs1_memory(rs1_memory),
     	.rs2_memory(rs2_memory),
		.srcA_memory(srcA_memory),
     	.srcB_memory(srcB_memory),
     	.rd_memory(rd_memory),
		.vector_srcB_memory(vector_srcB_memory)
	);
	RAM RAM_instance(
		.address_a(srcA_memory),
		.address_b(srcA_memory[11:0]), 
      .clock(clk),
      .data_a(srcB_memory[7:0]),
		.data_b(vector_srcB_memory),
      .wren_a(write_memory_enable_a_memory),
		.wren_b(write_memory_enable_b_memory),
      .q_a(data_from_memory),
		.q_b(vector_data_from_memory)
	);
	MemoryWriteback_register MemoryWriteback_register_instance (
		.clk(clk),
      .reset(reset),
      .wre_memory(wre_memory),
		.vector_wre_memory(vector_wre_memory),
      .select_writeback_data_mux_memory(select_writeback_data_mux_memory),
		.select_writeback_vector_data_mux_memory(select_writeback_vector_data_mux_memory),
		.data_from_memory_in(data_from_memory),
		.vector_data_from_memory_in(vector_data_from_memory),
		.calc_data_in(alu_result_memory),
		.calc_vector_in(alu_vector_result_memory),
		.rs1_memory(rs1_memory),
      .rs2_memory(rs2_memory),
      .rd_memory(rd_memory),	
		.wre_writeback(wre_writeback),
		.vector_wre_writeback(vector_wre_writeback),
		.select_writeback_data_mux_writeback(select_writeback_data_mux_writeback),
		.select_writeback_vector_data_mux_writeback(select_writeback_vector_data_mux_writeback),
		.data_from_memory_out(data_from_memory_writeback),
		.vector_data_from_memory_out(vector_writeback_data),
		.calc_data_out(alu_result_writeback),
		.calc_vector_out(alu_vector_result_writeback),
		.rs1_writeback(rs1_writeback),
     	.rs2_writeback(rs2_writeback),
      .rd_writeback(rd_writeback)
	);
	mux_2inputs_16bits mux_2inputs_writeback (
		.data0(data_from_memory_writeback),
      .data1(alu_result_writeback),
      .select(select_writeback_data_mux_writeback),
      .out(writeback_data)
	);
	mux_2inputs_128bits mux_vector_2inputs_writeback (
		.data0(vector_writeback_data),
      .data1(alu_vector_result_writeback),
      .select(select_writeback_vector_data_mux_writeback),
      .out(writeback_vector)
	);
   always #10 clk = ~clk;
   initial begin
		clk = 0;
      reset = 1;
		#20
		reset =  0;
		vector_wre_execute = 0;
		alu_result_execute = 8'b00000001;
		alu_vector_result_execute = 128'b1;
		select_writeback_data_mux_execute = 8'b00000010;
		select_writeback_vector_data_mux_execute = 128'b01;
		write_memory_enable_a_execute = 2'b01;
		write_memory_enable_b_execute = 2'b00;
		rs1_execute = 4'b0001;
		rs2_execute = 4'b0010;
		rd_decode = 4'b0011;
		rd_execute = 4'b0011;
      #20
		vector_wre_execute = 0;
		alu_result_execute = 8'b00000001;
		alu_vector_result_execute = 128'b1;
		select_writeback_data_mux_execute = 8'b00000010;
		select_writeback_vector_data_mux_execute = 128'b01;
		write_memory_enable_a_execute = 2'b00;
		write_memory_enable_b_execute = 2'b01;
		rs1_execute = 4'b0001;
		rs2_execute = 4'b0010;
		rd_decode = 4'b0011;
		rd_execute = 4'b0011;
      #100;
      $finish;
   end
endmodule
