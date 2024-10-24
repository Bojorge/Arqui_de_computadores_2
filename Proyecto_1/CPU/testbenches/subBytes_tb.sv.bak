`timescale 1ns/1ps

module subBytes_tb;
    logic clk;
    logic [7:0] byte_in;
    logic [7:0] byte_out;

    // Instancia del módulo subBytes
    subBytes uut (
        .clk(clk),
        .byte_in(byte_in),
        .byte_out(byte_out)
    );

    // Generador de reloj
    always begin
        clk = 0; #5;  // 5 ns en bajo
        clk = 1; #5;  // 5 ns en alto
    end

    initial begin
        // Probar diferentes valores
        byte_in = 8'h19;  // Por ejemplo, el valor 0x19
        #20;
        $display("byte_in: %h -> byte_out: %h", byte_in, byte_out);

        // Probar otro valor
        byte_in = 8'h7C;  // Prueba otro valor
        #20;
        $display("byte_in: %h -> byte_out: %h", byte_in, byte_out);

        // Finaliza la simulación
        $finish;
    end
endmodule