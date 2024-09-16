module multi_sel(
    input [0:7] d,
    input clk,
    input rst,
    output reg input_grant,
    output reg [10:0]out
);
reg [1:0] count;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        count <= 2'b0;
    end
    else begin
        count <= count +1'b1;
    end
end

reg [0:7] d_reg;
//FSM
always @(posedge clk or posedge rst)begin
    if(!rst)begin
        out <= 11'b0;
        input_grant <= 1'b0;
        
    end
end
endmodule