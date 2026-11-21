module RV32I #(
    parameter   DATA_WIDTH = 32,
                MEM_ADDRESS_WIDTH = 8,
                REG_ADDRESS_WIDTH = 5,
                PROGRAM_FILE = "program.mem"

) (
    input   logic clk,
    input   logic rst,
    output  logic [DATA_WIDTH-1:0] a0    
);
    
    logic [DATA_WIDTH-1:0] InstrF, InstrD, PCF, PCD, PCE, PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W, ImmExtD, ImmExtE, RD1D, RD1E, RD2D, RD2E, WriteDataM, SrcBE, ALUResultE, ALUResultM, ALUResultW, PCTargetE, PCNext, ReadDataM, ReadDataW, ResultW;
    logic ValidD, BranchD, BranchE, JumpD, JumpE, ZeroE, PCSrcE, MemWriteD, MemWriteE, MemWriteM, ALUSrcD, ALUSrcE, RegWriteD, RegWriteE, RegWriteM, RegWriteW; //control unit signals
    logic [1:0] ImmSrcD, ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW; //control unit signals
    logic [2:0] ALUControlD, ALUControlE, Funct3D, Funct3E, Funct3M; //control unit signals
    logic [4:0] RdD, RdE, RdM, RdW;
    assign Funct3D=InstrD[14:12];
    assign RdD=InstrD[11:7];

always_comb begin
    PCSrcE=JumpE;
    if(BranchE) begin
        case(Funct3E)
            3'b000: PCSrcE=ZeroE; // BEQ
            3'b001: PCSrcE=~ZeroE; // BNE
            3'b100: PCSrcE=($signed(RD1E)<$signed(RD2E)); // BLT
            3'b101: PCSrcE=($signed(RD1E)>=$signed(RD2E)); // BGE
            3'b110: PCSrcE=(RD1E<RD2E); // BLTU
            3'b111: PCSrcE=(RD1E>=RD2E); // BGEU
            default: PCSrcE='0;
        endcase
    end
end

fd_reg #(
    .DATA_WIDTH(DATA_WIDTH)
) fdreg (
    .clk(clk),
    .rst(rst),
    .InstrF(InstrF),
    .InstrD(InstrD),
    .PCF(PCF),
    .PCD(PCD),
    .PCPlus4F(PCPlus4F),
    .PCPlus4D(PCPlus4D),
    .ValidD(ValidD)
);

de_reg #(
    .DATA_WIDTH(DATA_WIDTH)
) dereg (
    .clk(clk),
    .rst(rst),
    .ALUControlD(ALUControlD),
    .ALUControlE(ALUControlE),
    .ALUSrcD(ALUSrcD),
    .ALUSrcE(ALUSrcE),
    .BranchD(BranchD),
    .BranchE(BranchE),
    .ImmExtD(ImmExtD),
    .ImmExtE(ImmExtE),
    .JumpD(JumpD),
    .JumpE(JumpE),
    .MemWriteD(MemWriteD),
    .MemWriteE(MemWriteE),
    .PCD(PCD),
    .PCE(PCE),
    .PCPlus4D(PCPlus4D),
    .PCPlus4E(PCPlus4E),
    .RD1D(RD1D),
    .RD1E(RD1E),
    .RD2D(RD2D),
    .RD2E(RD2E),
    .RdD(RdD),
    .RdE(RdE),
    .RegWriteD(RegWriteD),
    .RegWriteE(RegWriteE),
    .ResultSrcD(ResultSrcD),
    .ResultSrcE(ResultSrcE),
    .Funct3D(Funct3D),
    .Funct3E(Funct3E)
);



em_reg #(
    .DATA_WIDTH(DATA_WIDTH)
) emreg (
    .clk(clk),
    .rst(rst),
    .ALUResultE(ALUResultE),
    .ALUResultM(ALUResultM),
    .MemWriteE(MemWriteE),
    .MemWriteM(MemWriteM),
    .PCPlus4E(PCPlus4E),
    .PCPlus4M(PCPlus4M),
    .RdE(RdE),
    .RdM(RdM),
    .RegWriteE(RegWriteE),
    .RegWriteM(RegWriteM),
    .ResultSrcE(ResultSrcE),
    .ResultSrcM(ResultSrcM),
    .WriteDataE(RD2E),
    .WriteDataM(WriteDataM),
    .Funct3E(Funct3E),
    .Funct3M(Funct3M)
);

mw_reg #(
    .DATA_WIDTH(DATA_WIDTH)
) mwreg (
    .clk(clk),
    .rst(rst),
    .ALUResultM(ALUResultM),
    .ALUResultW(ALUResultW),
    .PCPlus4M(PCPlus4M),
    .PCPlus4W(PCPlus4W),
    .RdM(RdM),
    .RdW(RdW),
    .ReadDataM(ReadDataM),
    .ReadDataW(ReadDataW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ResultSrcM(ResultSrcM),
    .ResultSrcW(ResultSrcW)
);

async_rom #(
    .ADDRESS_WIDTH(MEM_ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .PROGRAM_FILE(PROGRAM_FILE)
) instruction_memory (
    .A(PCF[MEM_ADDRESS_WIDTH+1:2]),//pc increments by 4 each time
    .RD(InstrF)
);

control_unit control_unit (
    .Instr      (InstrD),
    .Branch     (BranchD),
    .Jump       (JumpD),
    .ResultSrc  (ResultSrcD),
    .MemWrite   (MemWriteD),
    .ALUControl (ALUControlD),
    .ALUSrc     (ALUSrcD),
    .ImmSrc     (ImmSrcD),
    .RegWrite   (RegWriteD)
);

sign_extend sign_extend (
    .Instr(InstrD),
    .ImmSrc(ImmSrcD),
    .ImmExt(ImmExtD)
);


assign PCPlus4F=PCF+32'd4;
assign PCTargetE=PCE+ImmExtE;


PCreg #(
    .DATA_WIDTH(DATA_WIDTH)
)pc_register(
    .clk(clk),
    .PCNext(PCNext),
    .PC(PCF),
    .rst(rst)
);

mux #(
    .DATA_WIDTH(DATA_WIDTH)
)pc_mux(
    .in0(PCPlus4F),
    .in1(PCTargetE),
    .out(PCNext),
    .sel(PCSrcE)
);

reg_file #(
    .ADDRESS_WIDTH(REG_ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) register_file (
    .CLK(clk),
    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]),
    .A3(RdW),
    .WE3(RegWriteW),
    .WD3(ResultW),
    .RD1(RD1D),
    .RD2(RD2D),
    .a0(a0)
);

mux #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_mux (
    .in0(RD2E),
    .in1(ImmExtE),
    .sel(ALUSrcE),
    .out(SrcBE)
);

alu #(
    .DATA_WIDTH(DATA_WIDTH)
) alu (
    .ALUControl(ALUControlE),
    .SrcA(RD1E),
    .SrcB(SrcBE),
    .ALUResult(ALUResultE),
    .Zero(ZeroE)
);

data_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(DATA_WIDTH)
) data_memory (
    .clk(clk),
    .A(ALUResultM),
    .WD(WriteDataM),
    .WE(MemWriteM),
    .RD(ReadDataM),
    .func3(Funct3M)
);

//reg_file_mux replaced with this because we now have 3 choices
always_comb begin
    case(ResultSrcW)
        2'b00: ResultW=ALUResultW;
        2'b01: ResultW=ReadDataW;
        2'b10: ResultW=PCPlus4W;
        default: ResultW='0;
    endcase
end
endmodule
