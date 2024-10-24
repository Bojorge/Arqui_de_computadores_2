`timescale 1ps/1ps

module Decode_Stage_tb;
   logic clk;
   logic reset;
	logic [1:0] select_nop_mux;
	logic [1:0] flush;
   logic [15:0] pc_decode;
	logic [19:0] instruction_fetch;
   logic [19:0] instruction_decode;
	logic [19:0] control_signals;
   logic [19:0] nop_mux_output;
   logic [15:0] srcA_execute;
   logic [15:0] srcB_execute;
   logic [4:0] rs1_execute;
   logic [4:0] rs2_execute;
   logic [4:0] rd_execute;
	logic [4:0] rd_writeback;
   logic [4:0] aluOp_execute;
   logic [4:0] aluVectorOp_execute;
   logic [1:0] select_writeback_data_mux_execute;
   logic [1:0] select_writeback_vector_data_mux_execute;
   logic [15:0] rd1, rd2, rd3;
   logic [127:0] vector_rd1, vector_rd2, vector_rd3;
	logic [127:0] srcA_vector_execute;
   logic [127:0] srcB_vector_execute;
   logic [15:0] pc_mux_output;
   logic [15:0] extended_label;
   logic [15:0] branch_address;
   logic [1:0] select_pc_mux;
   logic [15:0] writeback_data;
   logic [127:0] writeback_vector;
   logic load_instruction;
	logic write_memory_enable_a_execute;
   logic write_memory_enable_b_execute;
	logic wre_writeback;
   logic vector_wre_writeback;

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

   always #10 clk = ~clk;
   initial begin
      reset = 1;
      clk = 0;
      select_nop_mux = 2'b00;
      flush = 2'b00;
      instruction_fetch = 20'b00010100000000100001;
      #20 reset = 0;
      #100;
      $finish;
   end
endmodule