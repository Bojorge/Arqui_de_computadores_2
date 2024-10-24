`timescale 1ns/1ps

module roundKey_tb;

    // Entradas de 128 bits y señal de índice de ronda
    logic [127:0] key_in;
    logic [3:0]   round;

    // Salida de 128 bits
    logic [127:0] key_out;

    // Señales individuales de la matriz de entrada (cada casilla de 8 bits)
    logic [7:0] in_00, in_01, in_02, in_03;
    logic [7:0] in_10, in_11, in_12, in_13;
    logic [7:0] in_20, in_21, in_22, in_23;
    logic [7:0] in_30, in_31, in_32, in_33;

    // Señales individuales de la matriz de salida (cada casilla de 8 bits)
    logic [7:0] out_00, out_01, out_02, out_03;
    logic [7:0] out_10, out_11, out_12, out_13;
    logic [7:0] out_20, out_21, out_22, out_23;
    logic [7:0] out_30, out_31, out_32, out_33;

    // Instancia del módulo roundKey
    roundKey uut (
        .key_in(key_in),
        .round(round),
        .key_out(key_out)
    );

    // Conexión de señales individuales de entrada
    assign key_in = {in_00, in_10, in_20, in_30,
                     in_01, in_11, in_21, in_31,
                     in_02, in_12, in_22, in_32,
                     in_03, in_13, in_23, in_33};

    // Separación de la salida en señales individuales
    assign {out_00, out_10, out_20, out_30,
            out_01, out_11, out_21, out_31,
            out_02, out_12, out_22, out_32,
            out_03, out_13, out_23, out_33} = key_out;

    initial begin
        // Asignación de valores iniciales a la matriz de entrada
        in_00 = 8'h2b; in_01 = 8'h28; in_02 = 8'hab; in_03 = 8'h09;
        in_10 = 8'h7e; in_11 = 8'hae; in_12 = 8'hf7; in_13 = 8'hcf;
        in_20 = 8'h15; in_21 = 8'hd2; in_22 = 8'h15; in_23 = 8'h4f;
        in_30 = 8'h16; in_31 = 8'ha6; in_32 = 8'h88; in_33 = 8'h3c;

        // Valor inicial de la ronda
        round = 4'h0;

        // Esperar un tiempo para observar el resultado
        #20;
        
        // Mostrar resultados de entrada
        $display("Matriz de entrada:");
        $display("%h %h %h %h", in_00, in_01, in_02, in_03);
        $display("%h %h %h %h", in_10, in_11, in_12, in_13);
        $display("%h %h %h %h", in_20, in_21, in_22, in_23);
        $display("%h %h %h %h", in_30, in_31, in_32, in_33);

        // Mostrar resultados de salida
        $display("Matriz expandida de salida:");
        $display("%h %h %h %h", out_00, out_01, out_02, out_03);
        $display("%h %h %h %h", out_10, out_11, out_12, out_13);
        $display("%h %h %h %h", out_20, out_21, out_22, out_23);
        $display("%h %h %h %h", out_30, out_31, out_32, out_33);

        // Finalizar simulación
        $finish;
    end
endmodule