module multi_sel(
    input [0:7]d,
    input clk,
    input rst,
    output reg input_grant,
    output reg [0:10]out

);

always @(posedge clk or negedge rst)begin
    if(!rst) begin
        
    end
end
endmodule