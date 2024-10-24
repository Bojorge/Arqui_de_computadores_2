module mixColumns(
    input  logic [1:0] row,
	 input  logic [7:0] col_in0,    
    input  logic [7:0] col_in1,   
    input  logic [7:0] col_in2,    
    input  logic [7:0] col_in3,    
    input  logic [1:0] row_idx,    
    input  logic [1:0] col_idx,    
    output logic [7:0] result     
);

    logic [7:0] coeff0, coeff1, coeff2, coeff3; 
    logic [7:0] res0, res1, res2, res3;         

    
    always_comb begin
        case (row)
            2'b00: begin 
                coeff0 = 8'h02;
                coeff1 = 8'h03;
                coeff2 = 8'h01; 
                coeff3 = 8'h01;
            end
            2'b01: begin 
                coeff0 = 8'h01;
                coeff1 = 8'h02;
                coeff2 = 8'h03;
                coeff3 = 8'h01;
            end
            2'b10: begin 
                coeff0 = 8'h01;
                coeff1 = 8'h01;
                coeff2 = 8'h02;
                coeff3 = 8'h03;
            end
            2'b11: begin 
                coeff0 = 8'h03;
                coeff1 = 8'h01;
                coeff2 = 8'h01;
                coeff3 = 8'h02;
            end
            default: begin
                coeff0 = 8'h00; 
                coeff1 = 8'h00;
                coeff2 = 8'h00;
                coeff3 = 8'h00;
            end
        endcase
    end

    
    always_comb begin
        
        res0 = galois_mult(coeff0, col_in0);  
        res1 = galois_mult(coeff1, col_in1);
        res2 = galois_mult(coeff2, col_in2);
        res3 = galois_mult(coeff3, col_in3);

       
        result = res0 ^ res1 ^ res2 ^ res3;
    end

    // Función para realizar la multiplicación en el campo de Galois GF(2^8)
    function automatic logic [7:0] galois_mult(input logic [7:0] a, input logic [7:0] b);
        logic [7:0] p;
        logic [7:0] hi_bit_set;
    
    begin 
    p = 8'h00;
   case(a)
    8'd1:
     begin
      p = b;
     end
    8'd2:
     begin
      if(b<128)
       begin
        p = (b<<1)& 8'hFF;
        
       end
      else begin
       p = ((b<<1)& 8'hFF) ^ 8'h1B;
      end
      
     end
    8'd3:
     begin
      if(b<128)
       begin
        p = ((b<<1)& 8'hFF) ^ b;
        
       end
      else begin
       p = (((b<<1)& 8'hFF) ^ 8'h1B) ^ b;
      end
     end
    
   
        
    endcase
    galois_mult = p;
    end
    endfunction

endmodule