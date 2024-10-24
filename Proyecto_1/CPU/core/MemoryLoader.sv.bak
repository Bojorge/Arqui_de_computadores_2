module MemoryLoader (
    input logic clk,
    input logic [15:0] memory [0:7], // 8 palabras de 16 bits
    output logic [127:0] data_out // Paquete de 128 bits
);
    always_ff @(posedge clk) begin
        // Concatenar los 8 datos de 16 bits en un paquete de 128 bits en un solo ciclo
        data_out <= {memory[7], memory[6], memory[5], memory[4], memory[3], memory[2], memory[1], memory[0]};
    end
endmodule