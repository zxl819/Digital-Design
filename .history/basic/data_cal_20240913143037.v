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
reg [15:0] d_reg;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        d_reg <= 15'b0;
        out <= 5'b0;
        validout <= 1'b0;
    end
    else begin
        case(sel):
        2'b00:begin
            d_reg <= d;
            out <= d_reg;
            validout <= 1'b0;
        end
        2'b01:begin
            out <= d_reg[3:0] + d_reg[7:4];
            validout <= 1'b1;
        end
        2'b10:begin
            out <= d_reg[3:0] + d_reg[11:8];
            validout <= 1'b1;
        end
        2'b11:begin
            out <= d_reg[3:0] + d_reg[15:12];
            validout <= 1'b1;
        end
        default:begin
            validout <= 1'b0;
            out <= 5'b0;
        end
        endcase
    end
end

//*************code***********//
endmodule