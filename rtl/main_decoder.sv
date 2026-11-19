module main_decoder
(
    input logic [6:0] op,

    output logic ResultSrc,
    output logic MemWrite,
    output logic ALUSrc,
    output logic [1:0] ImmSrc,
    output logic RegWrite,
    output logic Branch,
    output logic [1:0] ALUOp
);

always_comb begin
    case (op)
        7'b0000011: begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 1'b1;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end

        7'b0100011: begin
            RegWrite = 1'b0;
            ImmSrc = 2'b01;
            ALUSrc = 1'b1;
            MemWrite = 1'b1;
            ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end

        7'b0110011: begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b10;
        end

        7'b1100011: begin
            RegWrite = 1'b0;
            ImmSrc = 2'b10;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            Branch = 1'b1;
            ALUOp = 2'b01;
        end

        default: begin
            ResultSrc = 1'b0;
            MemWrite  = 1'b0;
            ALUSrc    = 1'b0;
            ImmSrc    = 2'b00;
            RegWrite  = 1'b0;
            Branch    = 1'b0;
            ALUOp     = 2'b00;
        end
    endcase
end
endmodule
