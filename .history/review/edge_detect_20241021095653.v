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
        
    end
end