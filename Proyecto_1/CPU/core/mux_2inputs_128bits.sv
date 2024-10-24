module mux_2inputs_128bits (
    input logic [127:0] data0, data1,
    input logic [1:0] select,
    output logic [127:0] out
);

    always_comb begin
        case(select)
            2'b00: out = data0;
            2'b01: out = data1;
            default: out = 128'b0;
        endcase
    end

endmodule
