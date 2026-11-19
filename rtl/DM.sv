module name #(
    parameter int DATA_WIDTH=32,
    parameter int ADDRESS_WIDTH=32
) (
    input logic[ADDRESS_WIDTH-1:0] ALUResult,
    input logic[DATA_WIDTH-1:0] WriteData,
    input logic clk,
    input logic ResultSrc,
    input logic MemWrite,
    output logic[DATA_WIDTH-1:0] Result
);

logic[DATA_WIDTH-1:0] ReadData;
logic[DATA_WIDTH-1:0] DataMemory [32'h0001FFFF:32'h00001000];

always_ff @(posedge clk) begin
    if(MemWrite) DataMemory[ALUResult]<=WriteData;
end

assign ReadData<=DataMemory[ALUResult];

always_comb begin
    if(ResultSrc) Result=ReadData;
    else Result=ALUResult;
end
    
endmodule