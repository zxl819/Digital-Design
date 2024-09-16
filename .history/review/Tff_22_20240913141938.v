module Tff_22(
    input wire data,
    input wire clk,
    input wire rst,
    output reg q

);
reg q1;
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        q1 <= 1'b0;
        // q <= 1'b0;
    end
    else begin
        if(data)
        q1 <= ~q1;

    end
end
endmodule