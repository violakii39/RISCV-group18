module fd_reg #(
    parameter  DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,

    input logic[DATA_WIDTH-1:0] InstrF,
    input logic[DATA_WIDTH-1:0] PCF,
    input logic[DATA_WIDTH-1:0] PCPlus4F,

    output logic[DATA_WIDTH-1:0] InstrD,
    output logic[DATA_WIDTH-1:0] PCD,
    output logic[DATA_WIDTH-1:0] PCPlus4D,
    output logic ValidD
);

always_ff @(posedge clk) begin
    if(rst) begin
        InstrD<=32'b0;
        PCD<=32'b0;
        PCPlus4D<=32'b0;
        ValidD<=1'b0;
    end
    else begin
        InstrD<=InstrF;
        PCD<=PCF;
        PCPlus4D<=PCPlus4F;
        ValidD<=1'b1;
    end
end

endmodule