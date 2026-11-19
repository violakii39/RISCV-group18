module PCreg #(
    DATA_WIDTH=32
)(
    input logic[DATA_WIDTH-1:0] PCNext,
    input logic clk,
    input logic rst,
    output logic[DATA_WIDTH-1:0] PC
);
always_ff @(posedge clk) begin
    if(rst) PC<='0;
    else PC<=PCNext;
end

endmodule
