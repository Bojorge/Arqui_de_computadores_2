module cycle_counter (
    input logic clk,         // Señal de reloj
    input logic rst,         // Señal de reset
    input logic enable,      // Habilitar el contador
    output logic [31:0] count // Contador de ciclos (32 bits)
);

    // Bloque siempre que cuenta los ciclos
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'd0;   // Reiniciar el contador si rst está activo
        end else if (enable) begin
            count <= count + 1; // Incrementar el contador en cada ciclo de reloj
        end
    end

endmodule
