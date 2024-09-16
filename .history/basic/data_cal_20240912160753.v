`timescale 1ns/1ns

module data_cal(
input clk,
input rst,
input [15:0]d,
input [1:0]sel,

output [4:0]out,
output validout
);
//*************code***********//
reg [1:0] d_reg;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        d_reg <= 2'b0;
        out <= 5'b0;
    end
    else begin
        case()
        endcase
    end
end

//*************code***********//
endmodule