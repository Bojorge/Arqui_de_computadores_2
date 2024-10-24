module inverseMixColumns(
    input  logic [7:0] col_in0,    // Celda 0 de la columna
    input  logic [7:0] col_in1,    // Celda 1 de la columna
    input  logic [7:0] col_in2,    // Celda 2 de la columna
    input  logic [7:0] col_in3,    // Celda 3 de la columna
    input  logic [1:0] row_idx,    // Índice de la fila (0, 1, 2, 3)
    input  logic [1:0] col_idx,    // Índice de la columna (0, 1, 2, 3)
    output logic [7:0] result      // Resultado de la multiplicación
);

    // Definimos la tabla de la matriz inversa MixColumns
    logic [7:0] InvMixMatrix [3:0][3:0];

    initial begin
        // Inicializamos la tabla InvMixColumns
        InvMixMatrix[0][0] = 8'h0e; InvMixMatrix[0][1] = 8'h0b; InvMixMatrix[0][2] = 8'h0d; InvMixMatrix[0][3] = 8'h09;
        InvMixMatrix[1][0] = 8'h09; InvMixMatrix[1][1] = 8'h0e; InvMixMatrix[1][2] = 8'h0b; InvMixMatrix[1][3] = 8'h0d;
        InvMixMatrix[2][0] = 8'h0d; InvMixMatrix[2][1] = 8'h09; InvMixMatrix[2][2] = 8'h0e; InvMixMatrix[2][3] = 8'h0b;
        InvMixMatrix[3][0] = 8'h0b; InvMixMatrix[3][1] = 8'h0d; InvMixMatrix[3][2] = 8'h09; InvMixMatrix[3][3] = 8'h0e;
    end

    // Función para la multiplicación en el campo de Galois
    function logic [7:0] galois_mult;
        input logic [7:0] a;  // Multiplicador
        input logic [7:0] b;  // Multiplicando

        logic [7:0] p;    // Producto parcial
        logic [7:0] hi_bit_set;
        integer i;

        begin
            p = 8'h00;
            for (i = 0; i < 8; i = i + 1) begin
                if (b[0] == 1)
                    p = p ^ a;
                hi_bit_set = a[7];
                a = a << 1;
                if (hi_bit_set == 1)
                    a = a ^ 8'h1b;  // XOR con el polinomio irreducible 0x1b
                b = b >> 1;
            end
            galois_mult = p;
        end
    endfunction

    // Proceso para calcular la multiplicación fila x columna
    always @(*) begin
        case (col_idx)
            2'b00: result = galois_mult(InvMixMatrix[row_idx][0], col_in0);
            2'b01: result = galois_mult(InvMixMatrix[row_idx][1], col_in1);
            2'b10: result = galois_mult(InvMixMatrix[row_idx][2], col_in2);
            2'b11: result = galois_mult(InvMixMatrix[row_idx][3], col_in3);
            default: result = 8'h00;
        endcase
    end
endmodule
