module data_memory#(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32
)
(
    input logic[ADDRESS_WIDTH-1:0] A,
    input logic[DATA_WIDTH-1:0] WD,
    input logic clk,
    input logic WE,
    output logic[DATA_WIDTH-1:0] RD
);

logic [DATA_WIDTH:0] memory_array [2**ADDRESS_WIDTH-1:0];

always_ff @(posedge clk) 
    if(WE) memory_array [A]<=WD;

assign RD = memory_array[A];
endmodule
