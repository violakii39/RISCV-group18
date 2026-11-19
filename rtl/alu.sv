module alu#(
    parameter DATA_WIDTH = 32
)(
    input  logic [2:0]            ALUControl,
    input  logic [DATA_WIDTH-1:0] SrcA,
    input  logic [DATA_WIDTH-1:0] SrcB,
    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic Zero
);

typedef enum logic [2:0]{
    ALU_ADD = 3'b000,
    ALU_SUB = 3'b001,
    ALU_SLT = 3'b101,
    ALU_OR  = 3'b011,
    ALU_AND = 3'b010
} alu_op;

always_comb begin
    ALUResult = '0;
    case (ALUControl)
        ALU_ADD: ALUResult    = SrcA + SrcB;
        ALU_SUB: ALUResult    = SrcA - SrcB;
        ALU_SLT: ALUResult[0] = ($signed(SrcA) < $signed(SrcB));
        ALU_OR:  ALUResult    = SrcA | SrcB;
        ALU_AND: ALUResult    = SrcA & SrcB;
        default: ALUResult    = '0;
    endcase
    Zero = (ALUResult == '0);
end

endmodule
