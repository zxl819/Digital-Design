module complex_mul (
    input  wire         clk,
    input  wire [15:0]  a_re,
    input  wire [15:0]  a_im,
    input  wire [15:0]  b_re,
    input  wire [15:0]  b_im,
    output reg  [31:0]  p_re,
    output reg  [31:0]  p_im
);
    // p_re = a_re*b_re - a_im*b_im
    // p_im = a_re*b_im + a_im*b_re

    // 暂时用组合逻辑+寄存器做简单处理，也可以流水化
    wire signed [31:0] mult0 = $signed(a_re) * $signed(b_re); 
    wire signed [31:0] mult1 = $signed(a_im) * $signed(b_im); 
    wire signed [31:0] mult2 = $signed(a_re) * $signed(b_im);
    wire signed [31:0] mult3 = $signed(a_im) * $signed(b_re);

    always @(posedge clk) begin
        p_re <= mult0 - mult1;
        p_im <= mult2 + mult3;
    end
endmodule
