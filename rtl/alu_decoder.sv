module alu_decoder
(
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic funct7_5,
    input logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

always_comb begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000;

        2'b01: ALUControl = 3'b001;

        2'b10: 
            case(funct3)
                3'b000: case({op[5],funct7_5})
                    2'b11: ALUControl = 3'b001;

                    default: ALUControl = 3'b000;
                endcase

                3'b010: ALUControl = 3'b101;

                3'b110: ALUControl = 3'b011;

                3'b111: ALUControl = 3'b010;

                default: ALUControl = 3'b000;
            endcase

        default: ALUControl = 3'b000;
    endcase
end
endmodule
