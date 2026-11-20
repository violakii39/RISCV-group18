module de_reg #(
    parameter   DATA_WIDTH=32,
                REG_ADDRESS_WIDTH=5
) (
    input logic clk,
    input logic rst,

    input logic RegWriteD,
    input logic[1:0] ResultSrcD,
    input logic MemWriteD,
    input logic JumpD,
    input logic BranchD,
    input logic[2:0] ALUControlD,
    input logic ALUSrcD,
    input logic[DATA_WIDTH-1:0] RD1D,
    input logic[DATA_WIDTH-1:0] RD2D,
    input logic[DATA_WIDTH-1:0] PCD,
    input logic[REG_ADDRESS_WIDTH-1:0] RdD,
    input logic[DATA_WIDTH-1:0] ImmExtD,
    input logic[DATA_WIDTH-1:0] PCPlus4D,

    output logic RegWriteE,
    output logic[1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic[2:0] ALUControlE,
    output logic ALUSrcE,
    output logic[DATA_WIDTH-1:0] RD1E,
    output logic[DATA_WIDTH-1:0] RD2E,
    output logic[DATA_WIDTH-1:0] PCE,
    output logic[REG_ADDRESS_WIDTH-1:0] RdE,
    output logic[DATA_WIDTH-1:0] ImmExtE,
    output logic[DATA_WIDTH-1:0] PCPlus4E
);

always_ff @(posedge clk) begin
    if (rst) begin
        RegWriteE<='0;
        ResultSrcE<='0;
        MemWriteE<='0;
        JumpE<='0;
        BranchE<='0;
        ALUControlE<='0;
        ALUSrcE<='0;
        RD1E<='0;
        RD2E<='0;
        PCE<='0;
        RdE<='0;
        ImmExtE<='0;
        PCPlus4E<='0;
    end
    else begin
        RegWriteE<=RegWriteD;
        ResultSrcE<=ResultSrcD;
        MemWriteE<=MemWriteD;
        JumpE<=JumpD;
        BranchE<=BranchD;
        ALUControlE<=ALUControlD;
        ALUSrcE<=ALUSrcD;
        RD1E<=RD1D;
        RD2E<=RD2D;
        PCE<=PCD;
        RdE<=RdD;
        ImmExtE<=ImmExtD;
        PCPlus4E<=PCPlus4D;
    end
end

    
endmodule