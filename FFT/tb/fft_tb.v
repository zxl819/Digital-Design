`timescale 1ns/1ps

module fft_tb;

    // ----------------------------------------
    // 1) 产生时钟与复位
    // ----------------------------------------
    reg clk;
    reg rst_n;

    // 产生时钟，周期10ns (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 复位
    initial begin
        rst_n = 1'b0;      // 先保持低电平有效复位
        #20;               // 等待若干ns
        rst_n = 1'b1;      // 释放复位
    end

    // ----------------------------------------
    // 2) 其他输入信号: inv, stb, sop_in, x_re, x_im
    // ----------------------------------------
    reg        inv;       // 0=FFT, 1=IFFT
    reg        stb;       // 低电平有效
    reg        sop_in;    // 高电平表示该帧起始
    reg [15:0] x_re;
    reg [15:0] x_im;

    // ----------------------------------------
    // 3) 输出信号: valid_out, sop_out, y_re, y_im
    // ----------------------------------------
    wire       valid_out;
    wire       sop_out;
    wire [15:0] y_re;
    wire [15:0] y_im;

    // ----------------------------------------
    // 4) 实例化被测模块
    // ----------------------------------------
    fft_256 u_dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .inv       (inv),
        .stb       (stb),
        .sop_in    (sop_in),
        .x_re      (x_re),
        .x_im      (x_im),
        .valid_out (valid_out),
        .sop_out   (sop_out),
        .y_re      (y_re),
        .y_im      (y_im)
    );

    // ----------------------------------------
    // 5) 仿真控制和激励产生
    // ----------------------------------------
    integer i;
    integer frame_count = 2;  // 例: 发送2帧，每帧256个点

    // 在 testbench 里，你可以将输入数据存储在文件/数组中，
    // 这里仅演示一个简单的正弦/斜波等激励生成方式
    // 并演示多帧发送的流程。
    
    initial begin
        // 初始默认
        inv    = 1'b0;     // 默认先做 FFT
        stb    = 1'b1;     // stb=1表示"无效" (因为是低有效)
        sop_in = 1'b0;
        x_re   = 16'd0;
        x_im   = 16'd0;

        // 等待复位完成
        @(posedge rst_n);
        @(posedge clk);  // 再多等1个时钟

        // 发送多帧数据
        for (integer f = 0; f < frame_count; f=f+1) begin
            send_frame(f);
        end

        // 结束仿真
        #200;
        $display("All frames sent. Simulation ends.");
        $finish;
    end

    // ----------------------------------------
    // 6) 发送一帧数据的任务
    // ----------------------------------------
    task send_frame(input integer frame_idx);
        integer n;
        begin
            // 拉高 sop_in (高电平有效)，表示一帧起始
            @(posedge clk);
            sop_in <= 1'b1;
            stb   <= 1'b0;  // stb=0表示输入有效

            @(posedge clk);
            sop_in <= 1'b0;  // sop_in 只保持1拍即可

            // 连续送256个点
            for (n=0; n<256; n=n+1) begin
                // 你可以使用任何激励方式，如读取文件或计算正弦、随机数等
                // 下面仅作示例，x_re = n, x_im = 256-n
                // 也可考虑: x_re = sin(2*pi*n/256)*32767, x_im=0, 等等
                x_re <= n[15:0];
                x_im <= (256 - n)[15:0];
                @(posedge clk);
            end

            // 发送完256个点后, stb拉高(=1,表示无效)
            stb <= 1'b1;
            x_re <= 16'd0;
            x_im <= 16'd0;

            $display("Frame %0d data transmitted at time %t.", frame_idx, $time);

            // 等待一会儿，让输出也能流完
            // (具体等待多少时钟与内部流水线深度、仿真需求相关)
            repeat (20) @(posedge clk);
        end
    endtask

    // ----------------------------------------
    // 7) 监控和打印输出
    // ----------------------------------------
    // 对输出 y_re, y_im 进行简单监控，可在 console 中观察
    // 这里 valid_out=低有效; sop_out=低有效
    always @(posedge clk) begin
        if (valid_out == 1'b0) begin
            // 当 valid_out=0 (有效) 时, 若 sop_out=0 表示帧开头
            if (sop_out == 1'b0) begin
                $display("=== Output Frame Start at time %t ===", $time);
            end
            $display("Time %t : y_re=%d, y_im=%d", $time, $signed(y_re), $signed(y_im));
        end
    end

    // ----------------------------------------
    // 8) 可选：输出波形转储 (VCD 或 FSDB)
    // ----------------------------------------
    initial begin
        // 例：VCD 波形
        // $dumpfile("wave.vcd");
        // $dumpvars(0, fft_tb);

        // 若使用 Verdi/FSDB:
        $fsdbDumpfile("wave.fsdb");
        $fsdbDumpvars(0, fft_tb);
        // 或者在调用 VCS 时添加 +fsdb+all 等选项
    end

endmodule
