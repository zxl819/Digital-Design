module main_mod(
    input clk,
    input rst_n,
    input [7:0]a,
    input [7:0]b,
    input [7:0]c,
    
    output [7:0]d
);
reg [7:0]tmp1;
sub_mod U0(
    .a(a),
    .b(b),
    .clk(clk),
    .rst_n(rst_n),
    .d(tmp1)
);
reg [7:0]tmp2;
sub_mod U1(
    .a(a),
    .b(c),
    .clk(clk),
    .rst_n(rst_n),
    .d(tmp2)
);
sub_mod U2(
    .a(tmp1),
    .b(tmp2),
    .clk(clk),
    .rst_n(rst_n),
    .d(d)
);




endmodule

module sub_mod(
    input clk,
    input rst_n,
    input [7:0]a,
    input [7:0]b,    
    output [7:0]d

);
reg [7:0]d_out;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        d_out <= 8'b0;
    end
    else begin
        if(a > b)
        d_out <= b;
        else
        d_out <= a;
    end
    assign d = d_out;
end
endmodule