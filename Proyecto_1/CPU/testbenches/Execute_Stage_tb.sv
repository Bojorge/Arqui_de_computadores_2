`timescale 1ps/1ps
module Execute_Stage_tb;
   logic clk;
   logic reset;
	logic [19:0] nop_mux_output_in;
	logic [127:0] srcA_vector_in;
	logic [127:0] srcB_vector_in;
	logic [15:0] srcA_in;
	logic [15:0] srcB_in;
	logic [4:0] rs1_decode;
	logic [4:0] rs2_decode;
	logic [4:0] rd_decode;
	logic [15:0] pc_decode;
	logic write_memory_enable_a_execute, write_memory_enable_b_execute;
	logic write_memory_enable_a_memory, write_memory_enable_b_memory;
	logic [1:0] select_writeback_data_mux_execute, select_writeback_vector_data_mux_execute;
	logic [4:0] aluOp_execute;
	logic [4:0] rs1_execute;
	logic [4:0] rs2_execute;
	logic [4:0] rd_execute; 
	logic load_instruction;
	logic [15:0] alu_src_A;
	logic [15:0] alu_src_B;
	logic [7:0] alu_result_execute;
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
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
	logic [127:0] vector_srcA_execute, vector_srcB_execute;
	logic [127:0] vector_writeback_data;
	logic [4:0] aluVectorOp_execute;
	logic [127:0] alu_vector_result_memory;
	DecodeExecute_register DecodeExecute_register_instance (
		.clk(clk),
      .reset(reset),
      .nop_mux_output_in(nop_mux_output_in),
      .srcA_in(srcA_in),
      .srcB_in(srcB_in),
		.srcA_vector_in(srcA_vector_in),
		.srcB_vector_in(srcB_vector_in),
      .rs1_decode(rs1_decode),
      .rs2_decode(rs2_decode),
      .rd_decode(rd_decode),
      .wre_execute(wre_execute),
		.vector_wre_execute(vector_wre_execute),
      .write_memory_enable_a_execute(write_memory_enable_a_execute),
		.write_memory_enable_b_execute(write_memory_enable_b_execute),
      .select_writeback_data_mux_execute(select_writeback_data_mux_execute),
		.select_writeback_vector_data_mux_execute(select_writeback_vector_data_mux_execute),
      .aluOp_execute(aluOp_execute),
		.aluVectorOp_execute(aluVectorOp_execute),
      .srcA_out(srcA_execute),
      .srcB_out(srcB_execute),
		.srcA_vector_out(vector_srcA_execute),
      .srcB_vector_out(vector_srcB_execute),
      .rs1_execute(rs1_execute),
      .rs2_execute(rs2_execute),
      .rd_execute(rd_execute),
		.load_instruction(load_instruction)
	);
	mux_3inputs_16bits mux_alu_forward_A (
		.data0(srcA_execute),
      .data1(writeback_data),
      .data2(alu_result_memory),
      .select(select_forward_mux_A),
      .out(alu_src_A)
	);
	mux_3inputs_16bits mux_alu_forward_B (
		.data0(srcB_execute),
      .data1(writeback_data),
      .data2(alu_result_memory),
      .select(select_forward_mux_B),
     	.out(alu_src_B)
	);
	ALU ALU_escalar(
		.aluOp(aluOp_execute),       
      .srcA(alu_src_A[7:0]),
      .srcB(alu_src_B[7:0]),
      .result(alu_result_execute)
	);
	mux_3inputs_128bits mux_alu_forward_A_vector (
		.data0(vector_srcA_execute),
      .data1(writeback_vector),
      .data2(alu_vector_result_memory),
      .select(select_forward_mux_A),
      .out(alu_src_vector_A)
	);
	mux_3inputs_128bits mux_alu_forward_B_vector (
		.data0(vector_srcB_execute),
      .data1(writeback_vector),
      .data2(alu_vector_result_memory),
      .select(select_forward_mux_B),
     	.out(alu_src_vector_B)
	);
	ALU_vectorial ALU_vectorial_instance(
		.clk(clk),
		.aluVectorOp(aluVectorOp_execute),       
      .srcA_vector(alu_src_vector_A),
      .srcB_vector(alu_src_vector_B),
      .result_vector(alu_vector_result_execute)
	);
   forwarding_unit forwarding_unit_instance (
      .rs1_execute(rs1_execute),
      .rs2_execute(rs2_execute),
      .rs1_memory(rs1_memory),
      .rs2_memory(rs2_memory),
      .rs1_writeback(rs1_writeback),
      .rs2_writeback(rs2_writeback),
      .rd_memory(rd_memory),
      .rd_writeback(rd_writeback),
      .write_memory_enable_a_execute(write_memory_enable_a_execute),
		.write_memory_enable_b_execute(write_memory_enable_b_execute),
      .wre_memory(wre_memory),
      .wre_writeback(wre_writeback),
		.wre_vector_memory(vector_wre_memory),
      .wre_vector_writeback(vector_wre_writeback),
      .select_forward_mux_A(select_forward_mux_A),
      .select_forward_mux_B(select_forward_mux_B)
    );
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
   always #10 clk = ~clk;
   initial begin
      reset = 1;
		clk = 0;
		#20 reset =  0;
		nop_mux_output_in = 20'b00000000000010100000;
		srcA_vector_in = 128'b1;
		srcB_vector_in = 128'b01;
		srcA_in = 16'b00000001;
		srcB_in = 16'b00000010;
		rs1_decode = 5'b00001;
		rs2_decode = 5'b00010;
		rd_decode = 5'b00011;
      #100;
      $finish;
   end
endmodule