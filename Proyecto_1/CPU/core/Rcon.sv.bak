module Rcon (
    input  logic [3:0] index,    // Índice de la tabla Rcon (de 0 a 10 para AES-128)
    output logic [7:0] rcon_val  // Valor correspondiente de Rcon
);

    always_comb begin
        case (index)
            4'h0: rcon_val = 8'h01;
            4'h1: rcon_val = 8'h02;
            4'h2: rcon_val = 8'h04;
            4'h3: rcon_val = 8'h08;
            4'h4: rcon_val = 8'h10;
            4'h5: rcon_val = 8'h20;
            4'h6: rcon_val = 8'h40;
            4'h7: rcon_val = 8'h80;
            4'h8: rcon_val = 8'h1B;
            4'h9: rcon_val = 8'h36;
            default: rcon_val = 8'h00;  // Valor por defecto para índices fuera de rango
        endcase
    end

endmodule