module Rom(
    input clk,
    input rst_n,
    input [7:0]addr,
    output [3:0]data
);

reg [3:0]rom[0:255];
endmodule