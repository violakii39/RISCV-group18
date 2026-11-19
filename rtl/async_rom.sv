module async_rom#(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32,
                PROGRAM_FILE = "program.mem"
)
(
    input logic [ADDRESS_WIDTH-1:0] A,
    output logic [DATA_WIDTH-1:0]  RD
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ROM...");
    $readmemh(PROGRAM_FILE, rom_array);
end

always_comb begin
    RD = rom_array[A];
end
endmodule
