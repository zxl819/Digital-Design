`timescale 1ns/1ns
module tb();
    reg clk;
    reg rst_n;
    reg inv;
    reg valid_in;
    reg sop_in;
    reg [15:0] x_re;
    reg [15:0] x_im;
    wire valid_out;
    wire sop_out;
    wire signed [15:0] y_re;
    wire signed [15:0] y_im;

    initial begin
        clk <= 1'b0;
        rst_n <= 1'b0;
        sop_in <= 1'b0;
        valid_in <= 1'b0;
        inv <= 1'b1;
        x_re <= 16'h0000;
        x_im <= 16'h0000;

        #30
        rst_n <= 1'b1;
        sop_in <= 1'b1;
        valid_in <= 1'b1;
        x_re <= 256;
        x_im <= 256;

        #20
        sop_in <= 1'b0;
        x_re <= 255;
        x_im <= 255;

        #20
        sop_in <= 1'b0;
        x_re <= 254;
        x_im <= 254;

        #20
        x_re <= 253;
        x_im <= 253;

        #20
        x_re <= 252;
        x_im <= 252;

        #20
        x_re <= 251;
        x_im <= 251;



        #20
        valid_in <= 1'b0;

        // 假设仿真在处理完一些数据后结束
        // #500;
        // $stop;  // 停止仿真，避免无限循环
    end

    always #10 clk = ~clk;

    integer w_file;
    initial w_file = $fopen("./fft_output.txt");

    always @(posedge clk) begin
        if (valid_out) begin
            $fwrite(w_file, "%d %d\n", y_re, y_im);
        end
    end
    fft_256 fft_256_inst(
        .clk(clk),
        .rst_n(rst_n),
        .inv(inv),
        .valid_in(valid_in),
        .sop_in(sop_in),
        .x_re(x_re),
        .x_im(x_im),
        .valid_out(valid_out),
        .sop_out(sop_out),
        .y_re(y_re),
        .y_im(y_im)
    );


endmodule