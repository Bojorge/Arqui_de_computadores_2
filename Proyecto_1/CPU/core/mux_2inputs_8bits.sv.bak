module mux_2inputs_8bits (
    input logic [7:0] data0, data1,
    input logic [1:0] select,
    output logic [7:0] out
);

    always_comb begin
        case(select)
            2'b00: out = data0;
            2'b01: out = data1;
            default: out = 16'h00000000;
        endcase
    end

endmodule