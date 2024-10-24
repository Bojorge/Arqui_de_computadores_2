`timescale 1ns / 1ps

module addRoundKey_tb;
    logic [7:0] in1;    
    logic [7:0] in2;    
    logic [7:0] out;    

    
    addRoundKey #(8) addRoundKey_inst (
        .in1(in1),
        .in2(in2),
        .out(out)
    );

    initial begin
        // Valores de prueba
        in1 = 8'hCB;
        in2 = 8'h9B;

        #10;  
        $display("in1: %h", in1);
        $display("in2: %h", in2);
        $display("out: %h", out);  // Muestra la salida del XOR deberia ser 50
    end
endmodule