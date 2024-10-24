module VectorRegfile (
    input logic clk,
    input logic wre,               // señal de habilitación de escritura
    input logic [3:0] a1,          // dirección del primer registro fuente
    input logic [3:0] a2,          // dirección del segundo registro fuente
    input logic [3:0] a3,          // dirección del registro destino
    input logic [127:0] wd3,       // datos de escritura (128 bits)
    output logic [127:0] rd1,      // datos de lectura del primer registro fuente (128 bits)
    output logic [127:0] rd2       // datos de lectura del segundo registro fuente (128 bits)
);
    // 16 registros vectoriales de 128 bits
    logic [127:0] vector_registers [15:0];
    // Operaciones de lectura
    assign rd1 = vector_registers[a1];
    assign rd2 = vector_registers[a2];
    // Operaciones de escritura
    always_ff @(posedge clk) begin
        if (wre) begin
            vector_registers[a3] <= wd3;
        end
    end
endmodule
