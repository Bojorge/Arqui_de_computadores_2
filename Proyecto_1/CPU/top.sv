module top (
    input logic clk,
    input logic reset,
	 input logic encrypt_decrypt,
	 input logic enable_counter,
	 
	 output logic [31:0] clk_counter,
	 //////////////////////////// FETCH
	 output logic [15:0] PC,
	 output logic [19:0] instr_fetch,
	 //////////////////////////// DECODE
	 output logic [4:0] reg_address_1,
	 output logic [4:0] reg_address_2,
	 //////////////////////////// EXECUTE
	 output logic [127:0] alu_vector_result,
	 //////////////////////////// MEMORY
	 output logic [15:0] memory_address,
	 //////////////////////////// WRITEBACK
	 output logic [4:0] register_destination
	 
);	


	// registro PC
	logic [15:0] pc_mux_output;
	logic [15:0] pc_address;
	// sumador del PC
	logic [15:0] pc_offset;
	logic [15:0] pc_incremented;
	// mux del PC
	logic [1:0] select_pc_mux;   // esta señal de control viene del comparador entre rs1 y rs2
	logic [15:0] branch_address;
	// registro Fetch-Decode
	logic [19:0] instruction_fetch, instruction_decode;
	logic [1:0] flush;
	// unidad de control
	logic [19:0] control_signals;
	// mux de la unidad de control
	logic [19:0] nop_mux_output;
	logic [1:0] select_nop_mux;
	// banco de registros
	logic [15:0] writeback_data;
	logic wre_writeback;
	logic [15:0] rd1,rd2,rd3;
	// extensor de signo
	logic [15:0] extended_label;
	// sumador branch
	logic [15:0] pc_decode;
	// registro Decode-Execute
	logic write_memory_enable_a_execute, write_memory_enable_b_execute;
	logic write_memory_enable_a_memory, write_memory_enable_b_memory;
	logic [1:0] select_writeback_data_mux_execute, select_writeback_vector_data_mux_execute;
	logic [4:0] aluOp_execute;
	logic [4:0] rs1_execute; // entrada a la unidad de adelantamiento y de deteccion de riesgos
	logic [4:0] rs2_execute; // entrada a la unidad de adelantamiento y de deteccion de riesgos
	logic [4:0] rd_execute; 
	logic load_instruction;
	// alu
	logic [15:0] alu_src_A;
	logic [15:0] alu_src_B;
	logic [7:0] alu_result_execute;
	
	// alu vectorial
	logic [127:0] alu_src_vector_A;
	logic [127:0] alu_src_vector_B;
	
	// mux's de la alu
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	// registro Execute-Memory
	logic wre_memory, wre_execute;
	logic vector_wre_memory, vector_wre_execute;
	logic [1:0] select_writeback_data_mux_memory, select_writeback_vector_data_mux_memory;
	//logic write_memory_enable_memory;
	logic [7:0] alu_result_memory;
	logic [15:0] srcA_memory;
	logic [15:0] srcB_memory;
	logic [4:0] rs1_memory; // entrada a la unidad de adelantamiento
	logic [4:0] rs2_memory; // entrada a la unidad de adelantamiento
	logic [4:0] rd_memory;
	// unidad de adelantamiento
	logic [2:0] select_forward_mux_A;
	logic [2:0] select_forward_mux_B;
	// memoria de datos
	logic [7:0] data_from_memory;
	// registro Memory-Writeback
	logic [15:0] data_from_memory_writeback;
	logic [7:0] alu_result_writeback;
	logic [4:0] rs1_writeback; // entrada a la unidad de adelantamiento
	logic [4:0] rs2_writeback; // entrada a la unidad de adelantamiento
	logic [4:0] rd_writeback;
	logic [1:0] select_writeback_data_mux_writeback, select_writeback_vector_data_mux_writeback;
	// vectorial
	logic vector_wre_writeback;
	logic [127:0] vector_rd1, vector_rd2, vector_rd3;
	logic [127:0] vector_srcA_execute, vector_srcB_execute, vector_srcB_memory;
	logic [127:0] vector_writeback_data, vector_data_from_memory;
	logic [127:0] alu_vector_result_execute;
	logic [127:0] alu_vector_result_memory;
	logic [127:0] alu_vector_result_writeback;
	logic [127:0] writeback_vector;
	logic [4:0] aluVectorOp_execute;
	
	
//////////////////////////////////////////////////////////////////////////////
	assign pc_offset = 16'b0000000000000001;// suma 1 al PC
	
	//////////////////////////// FETCH
	assign PC = pc_mux_output;
	assign instr_fetch = instruction_fetch;
	//////////////////////////// DECODE
	assign reg_address_1 = instruction_decode[4:0];
	assign reg_address_2 = instruction_decode[9:5];
	//////////////////////////// EXECUTE
	assign alu_vector_result = alu_vector_result_execute;
	//////////////////////////// MEMORY
	assign memory_address = srcA_memory;
	//////////////////////////// WRITEBACK
	assign register_destination = rd_writeback;
	
	
//////////////////////////////////////////////////////////////////////////////
	//contador de ciclos de reloj
	cycle_counter my_counter (
        .clk(clk),
        .rst(reset),
        .enable(enable_counter),
        .count(clk_counter)
    );
	
	// Instancia del sumador del PC
	adder_16 pc_add (
		.a(pc_mux_output),
		.b(pc_offset),
		.y(pc_incremented)
	);
	// Instancia del MUX del PC
	mux_2inputs_16bits mux_2inputs_PC (
		.data0(pc_address),
		.data1(branch_address),
		.select(select_pc_mux),
		.out(pc_mux_output)
	);
	// Instancia del registro del PC
	PC_register pc_reg (
		.clk(clk),
      .reset(reset),
      .nop(select_nop_mux),
      .address_in(pc_incremented),
      .address_out(pc_address)
	);
	// Instancia de la memoria ROM
	ROM rom_memory (
		.address(pc_mux_output),
      .clock(clk),
      .q(instruction_fetch)
	);
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del registro FetchDecode
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
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia de la unidad de detección de riesgos
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
	// Instancia de la unidad de control
	controlUnit control_unit_instance (
		.opCode(instruction_decode[19:15]),
      .control_signals(control_signals)
	);
	// Instancia del MUX de NOP
	mux_2inputs_20bits mux_2inputs_nop (
		.data0(control_signals),
      .data1(20'b0),
      .select(select_nop_mux),
      .out(nop_mux_output)
	);
	// Instancia del extensor de ceros
	zeroExtend zero_extend_instance (
		.label(instruction_decode[14:10]),
		.ZeroExtLabel(extended_label) 
	); 
	// Instancia del restador de etiquetas de branch (para nuestro caso es restador pues para los loops debe devolverse a una posicion anterior)
	substractor_branch branch_label_pc (
		.a(pc_decode),
      .b(extended_label),
      .y(branch_address)
	);
	// Instancia del banco de registros
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
	// Instancia del banco de registros vectorial
	Regfile_vector vector_instance (
		.clk(clk),
		.wre(vector_wre_writeback),
		.a1(instruction_decode[4:0]),
      .a2(instruction_decode[9:5]),
      .a3(rd_writeback),
		.wd3(writeback_vector),
		.rd1(vector_rd1),   // Read data 1
		.rd2(vector_rd2),   // Read data 2
		.rd3(vector_rd3)   // Read data 3
	);
	// Instancia del comparador de branch
	comparator_branch comparator_instance (
		.opCode(instruction_decode[19:15]),
      .rs1_value(rd1),
      .rs2_value(rd2),
      .select_pc_mux(select_pc_mux)
	);
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del registro DecodeExecute
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
      .rs1_execute(rs1_execute),  // entrada a la unidad de adelantamiento
      .rs2_execute(rs2_execute), // entrada a la unidad de adelantamiento
      .rd_execute(rd_execute),
		.load_instruction(load_instruction)
	);
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del MUX de forwarding A
	mux_3inputs_16bits mux_alu_forward_A (
		.data0(srcA_execute),
      .data1(writeback_data),
      .data2(alu_result_memory),
      .select(select_forward_mux_A),
      .out(alu_src_A)
	);
	// Instancia del MUX de forwarding B
	mux_3inputs_16bits mux_alu_forward_B (
		.data0(srcB_execute),
      .data1(writeback_data),
      .data2(alu_result_memory),
      .select(select_forward_mux_B),
     	.out(alu_src_B)
	);
	// Instancia de la ALU
	ALU ALU_escalar(
		.aluOp(aluOp_execute),       
      .srcA(alu_src_A[7:0]),
      .srcB(alu_src_B[7:0]),
      .result(alu_result_execute)
	);
	// Instancia del MUX de forwarding A vectorial
	mux_3inputs_128bits mux_alu_forward_A_vector (
		.data0(vector_srcA_execute),
      .data1(writeback_vector),
      .data2(alu_vector_result_memory),
      .select(select_forward_mux_A),
      .out(alu_src_vector_A)
	);
	// Instancia del MUX de forwarding B vectorial
	mux_3inputs_128bits mux_alu_forward_B_vector (
		.data0(vector_srcB_execute),
      .data1(writeback_vector),
      .data2(alu_vector_result_memory),
      .select(select_forward_mux_B),
     	.out(alu_src_vector_B)
	);
	// Instancia de la ALU vectorial
	ALU_vectorial ALU_vectorial_instance(
		.clk(clk),
		.aluVectorOp(aluVectorOp_execute),       
      .srcA_vector(alu_src_vector_A),
      .srcB_vector(alu_src_vector_B),
      .result_vector(alu_vector_result_execute)
	);
	// Instancia del módulo forwarding_unit
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
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del registro ExecuteMemory
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
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia de la RAM
	RAM RAM_instance(
		.address_a(srcA_memory), // la direccion de memoria es la misma pero el dato necesario se maneja con las señales de control
		.address_b(srcA_memory[11:0]), 
      .clock(clk),
      .data_a(srcB_memory[7:0]),
		.data_b(vector_srcB_memory),
      .wren_a(write_memory_enable_a_memory),
		.wren_b(write_memory_enable_b_memory),
      .q_a(data_from_memory),
		.q_b(vector_data_from_memory)
	);
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del registro MemoryWriteback
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
////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instancia del MUX de writeback escalar
	mux_2inputs_16bits mux_2inputs_writeback (
		.data0(data_from_memory_writeback),
      .data1(alu_result_writeback),
      .select(select_writeback_data_mux_writeback),
      .out(writeback_data)
	);
	// Instancia del MUX de writeback vectorial
	mux_2inputs_128bits mux_vector_2inputs_writeback (
		.data0(vector_writeback_data),
      .data1(alu_vector_result_writeback),
      .select(select_writeback_vector_data_mux_writeback),
      .out(writeback_vector)
	);
	
endmodule
