//异步复位串联T触发器
module Tff_2(
    input wire data,clk,rst,
    output reg q
);
reg q1;
always @(posedge clk or negedge rst) begin
  if(!rst) begin
    q1 <= 1'b0;
  end
  else begin
    if(data)
      q1 <= ~q1;
    else
      q1 <= q1;
end
end

always @(posedge clk or negedge rst) begin
  if(!rst) begin
    q <= 1'b0;
  end
  else begin
    if (q1)
      q <= ~q;
    else
      q <= q;
end

endmodule