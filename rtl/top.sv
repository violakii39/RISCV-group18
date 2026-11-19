module top #(
    parameter   DATA_WIDTH = 32
                PROGRAM_FILE = "program.mem"

) (
    input   logic clk,
    input   logic rst,
    output  logic [DATA_WIDTH-1:0] a0    
);
    logic Zero = 0;
    logic ROM_ADDRESS_WIDTH = 8;
    logic [31:0] Instr, PC, ImmExt;
    logic PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite//control unit signals
    logic [1:0] ImmSrc//control unit signals
    logic [2:0] ALUControl//control unit signals


async_rom #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .PROGRAM_FILE(PROGRAM_FILE)
) instruction_memory (
    .A(PC[ROM_ADDRESS_WIDTH+1:2]),//pc increments by 4 each time
    .RD(Instr)
)

control_unit control_unit (
    .Instr      (Instr),
    .Zero       (Zero), 
    .PCSrc      (PCsrc),
    .ResultSrc  (ResultSrc),
    .MemWrite   (MemWrite),
    .ALUControl (ALUControl),
    .ALUSrc     (ALUSrc),
    .ImmSrc     (ImmSrc),
    .RegWrite   (RegWrite)
);

sign_extend sign_extend (
    .Instr(Instr)
    .ImmSrc(ImmSrc)
    .ImmExt(ImmExt)
);

endmodule
