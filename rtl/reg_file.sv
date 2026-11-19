module reg_file#(
    parameter ADDRESS_WIDTH = 5,
              DATA_WIDTH = 32
)(
    input  logic                     CLK,
    input  logic [ADDRESS_WIDTH-1:0] A1,
    input  logic [ADDRESS_WIDTH-1:0] A2,
    input  logic [ADDRESS_WIDTH-1:0] A3,
    input  logic                     WE3,
    input  logic [DATA_WIDTH-1:0]    WD3,
    output logic [DATA_WIDTH-1:0]    RD1,
    output logic [DATA_WIDTH-1:0]    RD2
);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial ram_array = '{default: '0};

always_ff@(posedge CLK)
    if(WE3 && (A3 != 0))
        ram_array[A3] <= WD3;

always_comb begin
    RD1 = ram_array[A1];
    RD2 = ram_array[A2];
end

endmodule
