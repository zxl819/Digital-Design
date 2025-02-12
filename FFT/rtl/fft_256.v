module fft_256 (
    input  wire         clk,
    input  wire         rst_n,      // 异步复位，低有效
    input  wire         inv,        // 0: FFT, 1: IFFT
    input  wire         stb,        // 输入数据有效, 低电平有效 (示例中未特别使用)
    input  wire         sop_in,     // 每组数据起始标志
    input  wire [15:0]  x_re,
    input  wire [15:0]  x_im,
    output reg          valid_out,  // 输出数据有效, 低电平有效
    output reg          sop_out,    // 每组输出起始标志 (低电平有效, 仅示例)
    output reg [15:0]   y_re,
    output reg [15:0]   y_im
);

    // -----------------------
    // 1) 输入数据/控制信号缓存
    // -----------------------
    // 在真正的 SDF 流水线中，数据按时钟节拍连续进入。
    // 这里简化处理，不对 stb / sop_in 做过多逻辑，仅演示
    // 核心 FFT 流程。可根据需要扩展。
    
    reg [15:0] din_re, din_im;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_re <= 16'd0;
            din_im <= 16'd0;
        end else begin
            // 简单示例：若 stb=低有效，则表示输入有效
            if (!stb) begin
                din_re <= x_re;
                din_im <= x_im;
            end
        end
    end

    // -----------------------
    // 2) 级联 8 个 SDF stage
    // -----------------------
    // 每一stage的输出作为下一stage的输入
    // 为简化，这里将所有中间信号用数组表示
    // 真实硬件里要分别实例化 stage0, stage1, ... stage7
    // 并包含相应的控制线，以保证同步。
    
    wire [15:0] stage_re_in [0:8];
    wire [15:0] stage_im_in [0:8];
    wire [15:0] stage_re_out[0:8];
    wire [15:0] stage_im_out[0:8];

    // 输入 --> stage0
    assign stage_re_in[0] = din_re;
    assign stage_im_in[0] = din_im;

    genvar i;
    generate
        for (i = 0; i < 8; i=i+1) begin : FFT_STAGES
            fft_sdf_stage #(
                .STAGE_ID(i)
            ) u_stage (
                .clk       (clk),
                .rst_n     (rst_n),
                .inv       (inv),
                // 输入
                .xin_re    (stage_re_in[i]),
                .xin_im    (stage_im_in[i]),
                // 输出
                .xout_re   (stage_re_out[i]),
                .xout_im   (stage_im_out[i])
            );
            // 下一级输入
            assign stage_re_in[i+1] = stage_re_out[i];
            assign stage_im_in[i+1] = stage_im_out[i];
        end
    endgenerate

    // stage7 输出 --> 最终输出
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b1;  // 低电平有效，这里复位时拉高
            sop_out   <= 1'b1; 
            y_re      <= 16'd0;
            y_im      <= 16'd0;
        end else begin
            // 简单示例：将最后一级输出直接送出
            valid_out <= 1'b0;  // 表示输出有效
            sop_out   <= 1'b0;  // 表示该帧输出起始 (仅示例)
            y_re      <= stage_re_out[7];
            y_im      <= stage_im_out[7];
        end
    end

endmodule
