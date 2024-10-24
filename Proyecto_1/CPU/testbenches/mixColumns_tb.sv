`timescale 1ns/1ps

module mixColumns_tb;

    // Declaración de señales para la entrada y salida del módulo
    logic [1:0] row;        
    logic [7:0] col_in0;    
    logic [7:0] col_in1;    
    logic [7:0] col_in2;    
    logic [7:0] col_in3;    
    logic [7:0] col_out;   

    // Instanciación del módulo a probar
    mixColumn uut (
        .row(row),
        .col_in0(col_in0),
        .col_in1(col_in1),
        .col_in2(col_in2),
        .col_in3(col_in3),
        .col_out(col_out)
    );

    // Bloque de estímulo para la prueba
    initial begin
        // Valores de entrada para la columna (e0, b4, 52, ae)
        col_in0 = 8'hd4; 
        col_in1 = 8'hbf;
        col_in2 = 8'h5d;
        col_in3 = 8'h30;
        
        // Probando para cada fila de la matriz MixColumns
        // Primera fila de la matriz MixColumns
        row = 2'b00;
        #10; // Esperar 10 unidades de tiempo
        $display("Row: %0d | col_out: %h", row, col_out);
        
        // Segunda fila de la matriz MixColumns
        row = 2'b01;
        #10; // Esperar 10 unidades de tiempo
        $display("Row: %0d | col_out: %h", row, col_out);
        
        // Tercera fila de la matriz MixColumns
        row = 2'b10;
        #10; // Esperar 10 unidades de tiempo
        $display("Row: %0d | col_out: %h", row, col_out);
        
        // Cuarta fila de la matriz MixColumns
        row = 2'b11;
        #10; // Esperar 10 unidades de tiempo
        $display("Row: %0d | col_out: %h", row, col_out);

        // Finalizar la simulación
        $finish;
    end

endmodule