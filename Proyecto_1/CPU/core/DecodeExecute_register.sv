module DecodeExecute_register (
   input logic clk,
   input logic reset,
   input logic [19:0] nop_mux_output_in,	 
   input logic [15:0] srcA_in,
   input logic [15:0] srcB_in,
	input logic [127:0] srcA_vector_in,
   input logic [127:0] srcB_vector_in,
	input logic [4:0] rs1_decode,
	input logic [4:0] rs2_decode,
	input logic [4:0] rd_decode,
	
   output logic wre_execute,
   output logic vector_wre_execute,
   output logic write_memory_enable_a_execute,
	output logic write_memory_enable_b_execute,
	output logic [1:0] select_writeback_data_mux_execute,
	output logic [1:0] select_writeback_vector_data_mux_execute,
	
	output logic [4:0] aluOp_execute,
	output logic [4:0] aluVectorOp_execute,
   output logic [15:0] srcA_out,
   output logic [15:0] srcB_out,
	output logic [127:0] srcA_vector_out,
   output logic [127:0] srcB_vector_out,
	output logic [4:0] rs1_execute,
	output logic [4:0] rs2_execute,
	output logic [4:0] rd_execute,
	output logic load_instruction
);

   logic [15:0] srcA;
   logic [15:0] srcB;
	logic [127:0] srcA_vector;
   logic [127:0] srcB_vector;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [4:0] rd;
	
	logic load;
	//logic load_vector;   //falta implentarla para los riesgos de load para vectores
	logic wre;
	logic vector_wre;
	logic write_memory_enable_a;
	logic write_memory_enable_b;
	logic [1:0] select_writeback_data_mux;
	logic [1:0] select_writeback_vector_data_mux;
	logic [4:0] aluOp;
	logic [4:0] aluVectorOp;
	
   always_ff @(posedge clk) begin
		if (reset) begin
			srcA <= 16'b0;
         srcB <= 16'b0;
			srcA_vector <= 128'b0;
         srcB_vector <= 128'b0;
			rs1 <= 5'b0;
			rs2 <= 5'b0;
			rd <= 5'b0;
			
			load <= 1'b0;
			wre <= 1'b0;
			vector_wre <= 1'b0;
			write_memory_enable_a <= 1'b0;
			write_memory_enable_b <= 1'b0;
         select_writeback_data_mux <= 2'b00;
			select_writeback_vector_data_mux <= 2'b00;
         aluOp <= 5'b0;
			aluVectorOp <= 5'b0;
			
      end else begin
			srcA <= srcA_in;
         srcB <= srcB_in;
			srcA_vector <= srcA_vector_in;
         srcB_vector <= srcB_vector_in;
			rs1 <= rs1_decode;
			rs2 <= rs2_decode;
			rd <= rd_decode;
			
			load <= nop_mux_output_in[18];
			wre <= nop_mux_output_in[17];
			vector_wre <= nop_mux_output_in[16];
			write_memory_enable_a <= nop_mux_output_in[15];
			write_memory_enable_b <= nop_mux_output_in[14];
         select_writeback_data_mux <= nop_mux_output_in[13:12];
			select_writeback_vector_data_mux <= nop_mux_output_in[11:10];
         aluOp <= nop_mux_output_in[9:5];
			aluVectorOp <= nop_mux_output_in[4:0];    
      end
   end
	
	//assign load_vector = nop_mux_output_in[19];  // falta implementarla, se le asigna un valor para quitar warnings
	
   assign srcA_out = srcA;
   assign srcB_out = srcB;
	assign srcA_vector_out = srcA_vector;
   assign srcB_vector_out = srcB_vector;
	assign rs1_execute = rs1;
	assign rs2_execute = rs2;
	assign rd_execute = rd;
	assign load_instruction = load;
	
	assign wre_execute = wre;
	assign vector_wre_execute = vector_wre;
	assign write_memory_enable_a_execute = write_memory_enable_a;
	assign write_memory_enable_b_execute = write_memory_enable_b;
   assign select_writeback_data_mux_execute = select_writeback_data_mux;
	assign select_writeback_vector_data_mux_execute = select_writeback_vector_data_mux;
   assign aluOp_execute = aluOp;
	assign aluVectorOp_execute = aluVectorOp;
endmodule
