module subBytes (
    input logic clk,          // Señal de reloj
    input logic [7:0] byte_in, // Entrada de 8 bits (byte a sustituir)
    output logic [7:0] byte_out // Salida de 8 bits (resultado de la S-Box)
);

    // Instancia del módulo sbox_rom
    sbox_rom rom_inst (
        .address(byte_in),  // Entrada: dirección (el byte a buscar en la ROM)
        .q(byte_out),       // Salida: valor de la ROM (byte sustituido)
        .clock(clk)         // Señal de reloj para sincronización
    );

endmodule