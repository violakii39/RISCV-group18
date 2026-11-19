module PCadds #(
    PC_WIDTH=32
)(
    output logic[PC_WIDTH-1:0] branch_PC,
    output logic[PC_WIDTH-1:0] inc_PC,
    input logic[PC_WIDTH-1:0] PC,
    input logic[PC_WIDTH-1:0] Immop
);

always_comb begin 
    branch_PC=PC+Immop;
    inc_PC=PC+PC_WIDTH'd4;
end 

endmodule