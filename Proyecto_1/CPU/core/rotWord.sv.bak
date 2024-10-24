module rotWord (
    input  logic [31:0] word_in,   // Entrada de 32 bits
    output logic [31:0] word_out   // Salida de 32 bits con rotación
);

    always_comb begin
        word_out = {word_in[23:0], word_in[31:24]};
    end

endmodule