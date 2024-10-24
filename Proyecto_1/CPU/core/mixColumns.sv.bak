module mixColumns(
    input  logic [1:0] row,        
    input  logic [7:0] col_in0,    
    input  logic [7:0] col_in1,    
    input  logic [7:0] col_in2,    
    input  logic [7:0] col_in3,    
    output logic [7:0] col_out     
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

       
        col_out = res0 ^ res1 ^ res2 ^ res3;
    end

    // Función para realizar la multiplicación en el campo de Galois GF(2^8)
    function automatic logic [7:0] galois_mult(input logic [7:0] a, input logic [7:0] b);
        logic [7:0] p;
        logic [7:0] hi_bit_set;
        integer i;
        begin
            p = 8'h00;
            hi_bit_set = 8'h1B;  
            for (i = 0; i < 8; i = i + 1) begin
                if (b[0] == 1'b1) begin
                    p = p ^ a; 
                end
                hi_bit_set = (a & 8'h80) ? hi_bit_set : 8'h00;
                a = (a << 1) ^ hi_bit_set;
                b = b >> 1;
            end
            galois_mult = p;
        end
    endfunction

endmodule