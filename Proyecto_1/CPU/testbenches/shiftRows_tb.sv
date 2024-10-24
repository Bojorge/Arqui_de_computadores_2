`timescale 1ps/1ps
module shiftRows_tb;
// Declaramos señales para el testbench
logic [127:0] matrix_in;
logic [127:0] matrix_out;
// Instanciamos el módulo a probar
shiftRows uut (
	.matrix_in(matrix_in),
	.matrix_out(matrix_out)
);
// Procedimiento inicial
initial begin
	// Matriz de entrada : [d4 e0 b8 1e  27 bf b4 41  11 98 5d 52  ae f1 e5 30]
	matrix_in = 128'hd4e0b81e27bfb44111985d52aef1e530;
	// Aplicamos un delay para ver los resultados
	#10;
	// Mostramos la matriz de entrada y salida en la consola
   $display("Matriz de entrada:");
   $display("%h", matrix_in);
   $display("Matriz de salida después de shiftRows:");
   $display("%h", matrix_out);
   // Finalizamos la simulación
   $finish;
end
endmodule
