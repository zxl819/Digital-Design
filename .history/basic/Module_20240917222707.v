module main_mod(
	input clk,
	input rst_n,
	input [7:0]a,
	input [7:0]b,
	input [7:0]c,
	
	output [7:0]d
);
reg [7:0]tmp1;
child_mod U0(
    .a(a),
    .b(b),
    .clk(clk),
    .rst_n(rst_n),
    .c(tmp1);
    
);
reg [7:0]tmp2;
child_mod U1(
    .a(a),
    .b(c),
    .clk(clk),
    .rst_n(rst_n),
    .c(tmp2);
);
// reg [7:0]d_reg;
child_mod U2(
    .a(tmp1),
    .b(tmp2),
    .clk(clk),
    .rst_n(rst_n),
    .c(d);
);
// assign d = d_reg;


endmodule

module child_mod(
    input [7:0]a,
    input [7:0]b,
    input clk,
    input rst_n,
    output [7:0]c;
);
reg [7:0]c_reg
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        c <= 8'b0;
    end
    else begin
        if (a > b) 
        c_reg <= b;
        else
        c_reg <= a;
    end
end
assign c = c_reg;

endmodule