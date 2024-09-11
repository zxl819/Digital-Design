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
        q<= b'10;
    end
    else begin
        if(q1)
          q<= ~q;
        else
          q<=q;
    end
    
end
endmodule