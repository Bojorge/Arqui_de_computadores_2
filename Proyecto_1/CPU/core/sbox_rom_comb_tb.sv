

module sbox_rom_comb_tb;
    logic [7:0] address;  
    logic [7:0] q;        
    
    
    sbox_rom_comb uut (
        .address(address), 
        .q(q)               
    );
    
    
    initial begin
        $display("Iniciando la prueba de la S-Box ROM combinacional...");
        
        // Prueba del valor en la dirección 0x00 (esperado: 0x63)
        address = 8'h00;
        #10; // Espera 1ns para que la salida sea válida
        $display("Dirección: 0x%h, Salida: 0x%h", address, q);
        
        // Prueba del valor en la dirección 0x19 (esperado: 0xD4)
        address = 8'h19;
        #10;
        $display("Dirección: 0x%h, Salida: 0x%h", address, q);
        
        // Prueba del valor en la dirección 0x7C (esperado: 0x10)
        address = 8'h7C;
        #10;
        $display("Dirección: 0x%h, Salida: 0x%h", address, q);
        
        // Prueba del valor en la dirección 0xFF (esperado: 0x16)
        address = 8'hFF;
        #10;
        $display("Dirección: 0x%h, Salida: 0x%h", address, q);
        
        // Prueba del valor en la dirección 0xA3 (esperado: 0x0A)
        address = 8'hA3;
        #10;
        $display("Dirección: 0x%h, Salida: 0x%h", address, q);
        
        // Finaliza la simulación
        $display("Pruebas completadas.");
        $finish;
    end
endmodule
