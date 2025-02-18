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



    integer i;  



    initial begin

        clk <= 1'b0;

        rst_n <= 1'b0;

        sop_in <= 1'b0;

        valid_in <= 1'b0;

        inv <= 1'b1;

        x_re <= 0;

        x_im <= 0;



        #30

        rst_n <= 1'b1;

        sop_in <= 1'b1;

        valid_in <= 1'b1;

        x_re <= 256;

        x_im <= 256;



        #20

        sop_in <= 1'b0;

            

        // 使用循环生成256个数，并按20ns的间隔更新x_re和x_im

 

        for (i = 1; i < 256; i = i + 1) begin

        #20;

        x_re <= 256 - i;  // 从 256 开始递减

        x_im <= 256 - i;  // 同样递减

        end



        #20;

        valid_in <= 1'b0;  // 停止输入



        #50000;

        $finish;  // 停止仿真，避免无限循环

        

    end



    always #10 clk = ~clk;



    integer w_file;

    initial w_file = $fopen("./ifft_output.txt");



    always @(posedge clk) begin       

        // $finish;  // 停止仿真，避免无限循环

        if (valid_out) begin

            $display("clk: %b, rst_n: %b, valid_in: %b, inv:%b, sop_in: %b, x_re: %d, x_im: %d, valid_out: %b, sop_out: %d, y_re: %d, y_im: %d", 

                     clk, rst_n, valid_in, inv,sop_in, x_re, x_im, valid_out, sop_out, y_re, y_im);

            $fwrite(w_file, "%d %d\n", y_re, y_im);

            // $finish;

            // $finish;  // 当 valid_out 为 1 时结束仿真

        end

    end



    initial begin

        $fsdbDumpfile("ifft_waveform.fsdb");  // 指定生成的波形文件名称

        $fsdbDumpvars("+all");         // 监控整个 testbench 模块

    end





    fft_256_2 fft_256_inst(

        .clk(clk),

        .rst_n(rst_n),

        .inv(inv),

        .valid_in(valid_in),        // #20;

        // valid_in <= 1'b0;  // 停止输入

        .sop_in(sop_in),

        .x_re(x_re),

        .x_im(x_im),

        .valid_out(valid_out),

        .sop_out(sop_out),

        .y_re(y_re),

        .y_im(y_im)

    );



endmodule

