module rom(
    input clk,
    input rst_n,
    input [7:0]addr,
    output [3:0]data
);

reg [3:0]rom[7:0];
always @(posedge clk or negedge rst_n) begin 
    
end
endmodule