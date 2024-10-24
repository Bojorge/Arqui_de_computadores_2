`timescale 1ps/1ps
module ROM_tb;

    logic clk = 0;
    logic [7:0] address = 0;
    logic [15:0] q;
    
   
    ROM ROM_instance (
        .address(address), 
        .clock(clk),
        .q(q)
    );
	 
    always #10 clk = ~clk;

    always_ff @(posedge clk) begin
        address <= address + 1;
    end

    initial begin
        // Mostrar los datos en cada ciclo de reloj
        $monitor("Time: %0t | Address: %0d | Data: %0h", $time, address, q);

        #100;
        
        $finish;
    end

endmodule
