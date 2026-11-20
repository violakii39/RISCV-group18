module data_memory #(
    parameter   DATA_WIDTH=32,
                MEMORY_WIDTH=8,
                ADDRESS_WIDTH=32
) (
    input logic[ADDRESS_WIDTH-1:0] A,
    input logic[DATA_WIDTH-1:0] WD,
    input logic clk,
    input logic WE,
    input logic[2:0] func3,
    output logic[DATA_WIDTH-1:0] RD
);

logic[MEMORY_WIDTH-1:0] DataMemory [32'h0001FFFF:32'h00001000];

always_ff @(posedge clk) begin
    if(WE)
    case (func3)
        3'b000: DataMemory[A]<=WD[MEMORY_WIDTH-1:0];
        3'b001: begin
            DataMemory[A+32'd1]<=WD[2*MEMORY_WIDTH-1:MEMORY_WIDTH];
            DataMemory[A]<=WD[MEMORY_WIDTH-1:0];
        end
        3'b010: begin
            DataMemory[A+32'd3]<=WD[4*MEMORY_WIDTH-1:3*MEMORY_WIDTH];
            DataMemory[A+32'd2]<=WD[3*MEMORY_WIDTH-1:2*MEMORY_WIDTH];
            DataMemory[A+32'd1]<=WD[2*MEMORY_WIDTH-1:MEMORY_WIDTH];
            DataMemory[A]<=WD[MEMORY_WIDTH-1:0];  
        end
    endcase 
end

always_comb begin
    case (func3)
        3'b000: RD={{24{DataMemory[A][MEMORY_WIDTH-1]}}, DataMemory[A]};
        3'b001: RD={{16{DataMemory[A+32'd1][MEMORY_WIDTH-1]}}, DataMemory[A+32'd1], DataMemory[A]};
        3'b010: RD={DataMemory[A+32'd3], DataMemory[A+32'd2], DataMemory[A+32'd1], DataMemory[A]};
        3'b100: RD={24'b0, DataMemory[A]};
        3'b101: RD={16'b0, DataMemory[A+32'd1], DataMemory[A]};
        default: RD={{24{DataMemory[A][MEMORY_WIDTH-1]}}, DataMemory[A]};
    endcase
end
    
endmodule
