`timescale 1ps/1ps
module Writeback_Stage_tb;
   logic clk;
   logic reset;
	logic wre;
	logic [4:0] a1, a2, a3;
	logic [15:0] wd3_scalar;
	logic [15:0] rd1_scalar, rd2_scalar, rd3_scalar;
	logic [127:0] wd3_vectorial;
	logic [127:0] rd1_vectorial, rd2_vectorial, rd3_vectorial;
	Regfile_scalar regfile_instance (
		.clk(clk),
		.wre(wre),
		.a1(a1),
      .a2(a2),
      .a3(a3),
      .wd3(wd3_scalar),
      .rd1(rd1_scalar),
      .rd2(rd2_scalar),
      .rd3(rd3_scalar)
	);
	Regfile_vector vector_instance (
		.clk(clk),
		.wre(wre),
		.a1(a1),
      .a2(a2),
      .a3(a3),
		.wd3(wd3_vectorial),
		.rd1(rd1_vectorial),   
		.rd2(rd2_vectorial),   
		.rd3(rd3_vectorial)
	);
	always #10 clk = ~clk;
   initial begin
		clk =0;
      reset = 1;
      #20 reset = 0;
		wre = 1'b1;
		a1 = 4'b0001;
		a2 = 4'b0001;
		a3 = 4'b0001;
		wd3_scalar = 16'b1;
		wd3_vectorial = 128'b1;
      #100;
      $finish;
   end
endmodule

