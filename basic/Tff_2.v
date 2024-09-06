`timescale 1ns/1ns
module Tff_2 (
input wire data, clk, rst,
output reg q  
);
//*************code***********//
// 低电平复位
reg q1;
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        q1 <= 1'b0;
    end
    else begin
        if (data) 
            q1 <= ~q1;
        else
            q1 <= q1;
    end
end

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        q <= 1'b0;
    end
    else begin
        q <= q1;
    end
end


//*************code***********//
endmodule