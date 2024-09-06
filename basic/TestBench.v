`timescale 1ps/1ps

module TB();

reg sys_clk;
reg sys_rst_n;

reg A;
reg B;
wire Y;

initial begin
        sys_clk = 1'b0; //时钟为0
        sys_rst_n = 1'b0; //复位为0

        // initialize inputs
        A = 1'b0;
        B = 1'b0;

        #200 //等待200ns
        sys_rst_n = 1'b1; //复位为1
        A = 1'b1;
        B = 1'b0;

        #200 //等待200ns

        A = 1'b0;
        B = 1'b1;

        A = 1'b1;
        B = 1'b1;
        
end

always #10 sys_clk = ~sys_clk;

and_gate u_and_gate(
    .A(A),
    .B(B),
    .Y(Y)
);


endmodule