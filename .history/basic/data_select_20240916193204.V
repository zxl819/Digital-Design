`timescale 1ns/1ns
module data_select(
	input clk,
	input rst_n,
	input signed[7:0]a,
	input signed[7:0]b,
	input [1:0]select,
	output reg signed [8:0]c
);
reg signed [8:0]c_reg;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        
    end
end

endmodule