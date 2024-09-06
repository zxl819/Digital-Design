`timescale 1ns/1ns
module Tff_2 (
input wire data, clk, rst,
output reg q  
);
//*************code***********//
reg q1;
always @(posedge clk or negedge rst)
if(~rst) begin
    q1 <= 1'b0; // 当复位信号为低时，异步复位
    q <= 1'b0; // 当复位信号为低时，异步复位
end
else begin
    if(data) begin
        q1 <= ~q1;
    end
    if(q1) begin
        q <= q1;
    end
end

//*************code***********//
endmodule