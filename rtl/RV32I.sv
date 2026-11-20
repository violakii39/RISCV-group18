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
    
    logic [DATA_WIDTH-1:0] Instr, PC, ImmExt, SrcA, SrcB, RegRD2, ALUResult, PCTarget, PCPlus4, PCNext, ReadData, Result;
    logic Zero, PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite; //control unit signals
    logic [1:0] ImmSrc; //control unit signals
    logic [2:0] ALUControl; //control unit signals


async_rom #(
    .ADDRESS_WIDTH(MEM_ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .PROGRAM_FILE(PROGRAM_FILE)
) instruction_memory (
    .A(PC[MEM_ADDRESS_WIDTH+1:2]),//pc increments by 4 each time
    .RD(Instr)
);

control_unit control_unit (
    .Instr      (Instr),
    .Zero       (Zero), 
    .PCSrc      (PCSrc),
    .ResultSrc  (ResultSrc),
    .MemWrite   (MemWrite),
    .ALUControl (ALUControl),
    .ALUSrc     (ALUSrc),
    .ImmSrc     (ImmSrc),
    .RegWrite   (RegWrite)
);

sign_extend sign_extend (
    .Instr(Instr),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
);

PCadds #(
    .DATA_WIDTH(DATA_WIDTH)
)pc_additions(
    .PCTarget(PCTarget),
    .ImmExt(ImmExt),
    .PCPlus4(PCPlus4),
    .PC(PC)
);

PCreg #(
    .DATA_WIDTH(DATA_WIDTH)
)pc_register(
    .clk(clk),
    .PCNext(PCNext),
    .PC(PC),
    .rst(rst)
);

mux #(
    .DATA_WIDTH(DATA_WIDTH)
)pc_mux(
    .in0(PCPlus4),
    .in1(PCTarget),
    .out(PCNext),
    .sel(PCSrc)
);

reg_file #(
    .ADDRESS_WIDTH(REG_ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) register_file (
    .CLK(clk),
    .A1(Instr[19:15]),
    .A2(Instr[24:20]),
    .A3(Instr[11:7]),
    .WE3(RegWrite),
    .WD3(Result),
    .RD1(SrcA),
    .RD2(RegRD2),
    .a0(a0)
);

mux #(
    .DATA_WIDTH(DATA_WIDTH)
) alu_mux(
    .in0(RegRD2),
    .in1(ImmExt),
    .sel(ALUSrc),
    .out(SrcB)
);

alu #(
    .DATA_WIDTH(DATA_WIDTH)
) alu (
    .ALUControl(ALUControl),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

data_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(DATA_WIDTH)
) data_memory (
    .clk(clk),
    .A(ALUResult),
    .WD(RegRD2),
    .WE(MemWrite),
    .RD(ReadData),
    .func3(Instr[14:12])
);

mux #(
    .DATA_WIDTH(DATA_WIDTH)
) reg_file_mux (
    .in0(ALUResult),
    .in1(ReadData),
    .sel(ResultSrc),
    .out(Result)
);
endmodule
