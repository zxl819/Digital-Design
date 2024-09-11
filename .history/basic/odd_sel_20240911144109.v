//现在需要对输入的32位数据进行奇偶校验,
//根据sel输出校验结果（1输出奇校验，0输出偶校验）
module odd_sel(
    input [31:0] bus,
    input sel,
    output check
);
wire odd;
// 按位异或
assign odd = ^bus;
assign check = sel ? odd : ~odd;
endmodule