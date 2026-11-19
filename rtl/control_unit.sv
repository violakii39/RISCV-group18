module control_unit
(
    input logic [31:0] Instr,
    input logic Zero,
    output logic PCSrc,
    output logic ResultSrc,
    output logic MemWrite,
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic [1:0] ImmSrc,
    output logic RegWrite
);

logic [1:0] ALUOp;
logic Branch;


main_decoder main_dec (
    .op (Instr[6:0]),
    .ResultSrc (ResultSrc),
    .MemWrite (MemWrite),
    .ALUSrc (ALUSrc),
    .ImmSrc (ImmSrc),
    .RegWrite (RegWrite),
    .Branch (Branch),
    .ALUOp (ALUOp)
)

alu_decoder alu_dec (
    .op (Instr[6:0]),
    .funct3 (Instr[14:12]),
    .funct7_5 (Instr[30]),
    .ALUOp (ALUOp),
    .ALUControl (ALUControl)
)

assign PCSrc = Zero & Branch;
endmodule