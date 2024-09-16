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
        case(sel):
        2'b00:begin
            d_reg <= d[3:0];
            out <= d_reg;
        end
        2'b01:begin
            d_reg <= d[3:0] + d[7:4];
            out <= d_reg;
        end
        2'b10:begin
            d_reg <= d[3:0] + d[11:8];
            out <= d_reg;
        end
        2'b11:begin
            d_reg <= d[3:0] + d[15:12];
            out <= d_reg;
        end
        endcase
    end
end

//*************code***********//
endmodule