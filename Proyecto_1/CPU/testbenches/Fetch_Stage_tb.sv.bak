`timescale 1ps/1ps
module Fetch_Stage_tb;
   logic clk;
   logic reset;
   logic [15:0] pc_mux_output;
   logic [15:0] pc_address;
   logic [15:0] pc_offset;
   logic [15:0] pc_incremented;
   logic [1:0] select_pc_mux;
   logic [15:0] branch_address;
   logic [19:0] instruction_fetch, instruction_decode;
   logic [1:0] flush;
   logic [1:0] select_nop_mux;
   logic [15:0] pc_decode;
   adder_16 pc_add (
      .a(pc_mux_output),
      .b(pc_offset),
      .y(pc_incremented)
   );
   mux_2inputs_16bits mux_2inputs_PC (
      .data0(pc_address),
      .data1(branch_address),
      .select(select_pc_mux),
      .out(pc_mux_output)
   );
   PC_register pc_reg (
      .clk(clk),
      .reset(reset),
      .nop(select_nop_mux),
      .address_in(pc_incremented),
      .address_out(pc_address)
   );
   ROM rom_memory (
      .address(pc_mux_output),
      .clock(clk),
      .q(instruction_fetch)
   );
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
   always #10 clk = ~clk;
   initial begin
      reset = 1;
      clk = 0;
      pc_offset = 16'h0001;
      select_pc_mux = 2'b00;
      select_nop_mux = 2'b00;
      branch_address = 16'h0000;
      flush = 2'b00;
      #20 reset = 0;
      #100;
      $finish;
   end
endmodule
