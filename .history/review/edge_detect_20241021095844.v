module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);
reg a1;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        a1 <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        a1 <= a;
        if (a & ~a1)
            rise <= 1'b1;
        else
            rise <= 1'b0;
        if (~a & a1)
            down <= 1'b1;
        else
            down <= 1'b0;
    end
end