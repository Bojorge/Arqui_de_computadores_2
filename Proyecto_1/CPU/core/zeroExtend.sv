module zeroExtend (
    input logic [4:0] label,
    output logic [15:0] ZeroExtLabel
);
    assign ZeroExtLabel = { 11'b0, label };
endmodule
