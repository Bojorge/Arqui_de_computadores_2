module mux_3inputs_16bits (
    input logic [15:0] data0,  // Primera entrada
    input logic [15:0] data1,  // Segunda entrada
    input logic [15:0] data2,  // Tercera entrada
    input logic [2:0] select,  // Señal de selección de 3 bits
    output logic [15:0] out    // Salida de 16 bits
);

    always_comb begin
        case (select)
            3'b000: out = data0;  // Selección de la primera entrada
            3'b001: out = data1;  // Selección de la segunda entrada
            3'b010: out = data2;  // Selección de la tercera entrada
            default: out = 16'b0; // Valor por defecto
        endcase
    end

endmodule