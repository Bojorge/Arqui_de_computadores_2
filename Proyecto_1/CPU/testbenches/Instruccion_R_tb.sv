`timescale 1ps/1ps
module Instruccion_R_tb;
	logic clk;
	logic [19:0] instruction_fetch, instruction_decode;
	logic [1:0] flush;
	logic [1:0] reset;
	logic [15:0] pc_mux_output;
	logic [19:0] control_signals;
	logic [19:0] nop_mux_output;
	logic [1:0] select_nop_mux;
	logic [15:0] writeback_data;
	logic wre_writeback;
	logic [15:0] rd1,rd2,rd3;
	logic [15:0] extended_label;
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
	logic [127:0] alu_src_vector_A;
	logic [127:0] alu_src_vector_B;
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
	FetchDecode_register FetchDecode_register_instance (
		.clk(clk),
      .reset(reset),
      .flush(flush),
		.nop(select_nop_mux),
      .pc(pc_mux_output),
      .instruction_in(instruction_fetch),
      .pc_decode(pc_decode),
      .instruction_out(instruction_decode)
	);
	hazard_detection_unit u_hazard_detection (
		.opcode(instruction_decode[19:15]),
		.rd_load_execute(rd_execute),
      .load_instruction(load_instruction),
		.regfile_data_1(rd1),
		.regfile_data_2(rd2),
      .rs1_decode(instruction_decode[4:0]),
      .rs2_decode(instruction_decode[9:5]),
      .rs1_execute(rs1_execute),
      .rs2_execute(rs2_execute),
      .nop(select_nop_mux),
		.flush(flush)
	); 
	controlUnit control_unit_instance (
		.opCode(instruction_decode[19:15]),
      .control_signals(control_signals)
	);
	mux_2inputs_20bits mux_2inputs_nop (
		.data0(control_signals),
      .data1(20'b0),
      .select(select_nop_mux),
      .out(nop_mux_output)
	);
	zeroExtend zero_extend_instance (
		.label(instruction_decode[14:10]),
		.ZeroExtLabel(extended_label) 
	); 
	substractor_branch branch_label_pc (
		.a(pc_decode),
      .b(extended_label),
      .y(branch_address)
	);
	Regfile_scalar regfile_instance (
		.clk(clk),
		.wre(wre_writeback),
		.a1(instruction_decode[4:0]),
      .a2(instruction_decode[9:5]),
      .a3(rd_writeback),
      .wd3(writeback_data),
      .rd1(rd1),
      .rd2(rd2),
      .rd3(rd3)
	);
	Regfile_vector vector_instance (
		.clk(clk),
		.wre(vector_wre_writeback),
		.a1(instruction_decode[4:0]),
      .a2(instruction_decode[9:5]),
      .a3(rd_writeback),
		.wd3(writeback_vector),
		.rd1(vector_rd1),  
		.rd2(vector_rd2),  
		.rd3(vector_rd3)
	);
	comparator_branch comparator_instance (
		.opCode(instruction_decode[19:15]),
      .rs1_value(rd1),
      .rs2_value(rd2),
      .select_pc_mux(select_pc_mux)
	);
	DecodeExecute_register DecodeExecute_register_instance (
		.clk(clk),
      .reset(reset),
      .nop_mux_output_in(nop_mux_output),
      .srcA_in(rd1),
      .srcB_in(rd2),
		.srcA_vector_in(vector_rd1),
		.srcB_vector_in(vector_rd2),
      .rs1_decode(instruction_decode[4:0]),
      .rs2_decode(instruction_decode[9:5]),
      .rd_decode(instruction_decode[14:10]),
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
		clk =0;
      reset = 1;
      #20 reset = 0;
		select_nop_mux = 2'b0;
		flush = 2'b0;
		pc_mux_output = 16'b0;
		instruction_fetch = 20'b00101000010001000001;
      #100;
      $finish;
   end	
endmodule
