module reg_alu_top#(
    parameter ADDRESS_WIDTH = 5,
              DATA_WIDTH = 32
)(
    input  logic CLK,
    input  logic RegWrite,
    input  logic ALUSrc,
    input  logic [2:0] ALUControl,
    input  logic [ADDRESS_WIDTH-1:0] A1,
    input  logic [ADDRESS_WIDTH-1:0] A2,
    input  logic [ADDRESS_WIDTH-1:0] A3,
    input  logic [DATA_WIDTH-1:0] ImmExt,
    output logic [DATA_WIDTH-1:0] ALUResult
);

logic [DATA_WIDTH-1:0] RD1;
logic [DATA_WIDTH-1:0] RD2;
logic [DATA_WIDTH-1:0] SrcB;

regFile#(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) regFile_inst (
    .CLK(CLK),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WE3(RegWrite),
    .WD3(ALUResult),
    .RD1(RD1),
    .RD2(RD2)
);

mux#(
    .DATA_WIDTH(DATA_WIDTH)
) mux_inst (
    .in0(RD2),
    .in1(ImmExt),
    .sel(ALUSrc),
    .out(SrcB)
);

ALU#(
    .DATA_WIDTH(DATA_WIDTH)
) ALU_inst (
    .ALUControl(ALUControl),
    .SrcA(RD1),
    .SrcB(SrcB),
    .ALUResult(ALUResult)
);

endmodule