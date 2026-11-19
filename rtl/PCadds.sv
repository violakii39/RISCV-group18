module PCadds #(
    DATA_WIDTH=32
)(
    output logic[DATA_WIDTH-1:0] PCTarget,
    output logic[DATA_WIDTH-1:0] PCPlus4,
    input logic[DATA_WIDTH-1:0] PC,
    input logic[DATA_WIDTH-1:0] ImmExt
);

always_comb begin 
    PCTarget = PC + ImmExt;
    PCPlus4 = PC + 4;
end 

endmodule
