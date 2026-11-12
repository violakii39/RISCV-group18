module PCmux #(
    PC_WIDTH=32
)(
    input logic PCsrc,
    input logic[PC_WIDTH-1:0] branch_PC,
    input logic[PC_WIDTH-1:0] inc_PC,
    output logic[PC_WIDTH-1:0] next_PC
);

always_comb begin
    if(PCsrc) next_PC=branch_PC;
    else next_PC=inc_PC;
end

endmodule