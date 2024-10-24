module mux_2inputs_20bits (
    input logic [19:0] data0, data1,
    input logic [1:0] select,
    output logic [19:0] out
);

    always_comb begin
        case(select)
            2'b00: out = data0;
            2'b01: out = data1;
            default: out = 20'h0;
        endcase
    end

endmodule
