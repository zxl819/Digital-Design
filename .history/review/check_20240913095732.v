module odd_sel(
    input [31:0]bus,
    input sel,
    output check
);

wire odd;
assign odd = ^bus;// ^为异或
assign check = sel? odd : ~odd;//odd为异或=奇校验


endmodule
