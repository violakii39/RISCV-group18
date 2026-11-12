module PCreg #(
    PC_WIDTH=32
)(
    input logic[PC_WIDTH-1:0] next_PC,
    input logic clk,
    input logic rst,
    output logic[PC_WIDTH-1:0] PC
);
always_ff @(posedge clk) begin
    if(rst) PC<='0;
    else PC<=next_PC;
end

endmodule