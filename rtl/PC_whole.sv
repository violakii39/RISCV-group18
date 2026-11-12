module PC_whole #(
    PC_WIDTH=32
)(
    input logic clk,
    input logic rst,
    input logic[PC_WIDTH-1:0] Immop,
    input logic PCsrc,
    output logic[PC_WIDTH-1:0] PC
);

logic[PC_WIDTH-1:0] inc_PC;
logic[PC_WIDTH-1:0] branch_PC;
logic[PC_WIDTH-1:0] next_PC;

PCadds #(.PC_WIDTH(PC_WIDTH))pc_additions(
    .branch_PC(branch_PC),
    .Immop(Immop),
    .inc_PC(inc_PC),
    .PC(PC)
);

PCmux #(.PC_WIDTH(PC_WIDTH))pc_mux(
    .branch_PC(branch_PC),
    .inc_PC(inc_PC),
    .next_PC(next_PC),
    .PCsrc(PCsrc)
);

PCreg #(.PC_WIDTH(PC_WIDTH))pc_register(
    .clk(clk),
    .next_PC(next_PC),
    .PC(PC),
    .rst(rst)
);

endmodule