module data_minus2(
    input clk,
    input rst_n,
    input [7:0]a,
    input [7:0]b,
    output reg[8:0]c

);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)begin
        c <= 9'b0;
    end
    else begin
        if (a > b)begin
            c <= a - b;
        end
        else begin
            c <= b - a;
        end
    end
end
endmodule