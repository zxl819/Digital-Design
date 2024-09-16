module multi_sel(
    input [0:7]d,
    input clk,
    input rst,
    output reg input_grant,
    output reg [0:10]out

);
reg [1:0] count;
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        count <= 2'b0;
    end
    else begin 
        count <= count + 1'b1;
    end
end

endmodule