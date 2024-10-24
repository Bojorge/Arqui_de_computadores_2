module signExtend (
    input logic [3:0] label,
    output logic [15:0] SignExtLabel
);
    assign SignExtLabel = { {12{label[3]}}, label };
endmodule
