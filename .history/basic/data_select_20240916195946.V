`timescale 1ns/1ns
module data_select(
	input clk,
	input rst_n,
	input signed[7:0]a,
	input signed[7:0]b,
	input [1:0]select,
	output reg signed [8:0]c
);
// 有符号数/无符号数加减；可以将全部变量均定义为有符号数

reg signed [8:0]c_reg;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        c <= 9'b0;
    end
    else begin
    case(select)
    2'b00:begin
        c <= a;
    end
    2'b01:begin
        c <= b; 
    end
    2'b10:begin
        c <= a + b;
    end
    2'b11:begin
        c <= a - b;
    end
    endcase
    end
end

endmodule