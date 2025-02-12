module fft_sdf_stage #(
    parameter STAGE_ID = 0  // 用于决定本级所用的 twiddle 因子步进
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        inv,        // FFT / IFFT
    input  wire [15:0] xin_re,
    input  wire [15:0] xin_im,
    output wire [15:0] xout_re,
    output wire [15:0] xout_im
);

    // -----------------------
    // 1) 延迟线（FIFO/寄存器）
    // -----------------------
    // 根据 STAGE_ID 不同，需要在本级缓存 2^(STAGE_ID) 个采样，
    // 使得输入流中的一半数据延迟到和另一半数据对齐，再进入蝶形运算。
    // 这里仅示例一个简化写法，实际要用移位寄存器或 RAM。
    localparam DELAY_LEN = (1 << STAGE_ID);

    reg [15:0] delay_re [0:DELAY_LEN-1];
    reg [15:0] delay_im [0:DELAY_LEN-1];
    reg [8:0]  wr_ptr; // 简单示例，不考虑越界
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_ptr <= 0;
        end else begin
            delay_re[wr_ptr] <= xin_re;
            delay_im[wr_ptr] <= xin_im;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // “延迟后”的输出
    wire [15:0] delayed_re = delay_re[wr_ptr];
    wire [15:0] delayed_im = delay_im[wr_ptr];

    // -----------------------
    // 2) Twiddle 旋转因子产生
    // -----------------------
    // 对于第 STAGE_ID 级，旋转因子每处理 DELAY_LEN 个样本才更新一次。
    // 这里仅示例，实际应使用 ROM + 相应的计数器。
    wire [15:0] w_re, w_im; // twiddle 实部和虚部
    reg  [31:0] phase_acc;  // 简易相位累加器 (仅示例)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            phase_acc <= 32'd0;
        else
            phase_acc <= phase_acc + 32'd1; // 实际应根据 DELAY_LEN 来更新
    end

    // 简易的 twiddle ROM：可以用 CORDIC 或查表，这里仅示例常数
    // 假设 w_re, w_im 在理想情况下正确映射到 cos / sin
    assign w_re = 16'h7FFF; // cos(0) = 1.0 (Q15)
    assign w_im = inv ? 16'h0000 : 16'h0000;
    // 真实工程中：
    //  - 对 FFT:   w_im = -sin(phase)
    //  - 对 IFFT:  w_im = +sin(phase)
    // 并根据 phase_acc 映射查表

    // -----------------------
    // 3) Butterfly 运算
    // -----------------------
    // 低通道 (delayed_xxx) + 高通道 (xin_xxx) 做蝶形
    // y0 = delayed + (xin * W)
    // y1 = delayed - (xin * W)
    wire [31:0] mul_re, mul_im; 
    complex_mul u_cmul (
        .clk(clk),
        .a_re(xin_re),
        .a_im(xin_im),
        .b_re(w_re),
        .b_im(w_im),
        .p_re(mul_re),
        .p_im(mul_im)
    );

    // Butterfly
    wire [31:0] bf_re0 = $signed({delayed_re,16'b0}) + mul_re; 
    wire [31:0] bf_im0 = $signed({delayed_im,16'b0}) + mul_im;
    wire [31:0] bf_re1 = $signed({delayed_re,16'b0}) - mul_re;
    wire [31:0] bf_im1 = $signed({delayed_im,16'b0}) - mul_im;

    // 在 SDF 架构中，输出分为：一个通道输出 y0，另一个输出 y1，
    // 但在单路径实现时，需在不同时刻输出，所以示例中只输出 y0。
    // 实际中需要通过时序调度将 y0, y1 按正确顺序送至下一级。
    // 这里简化地用 y0 作为输出：
    reg [31:0] out_re_reg, out_im_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_re_reg <= 32'd0;
            out_im_reg <= 32'd0;
        end else begin
            out_re_reg <= bf_re0;
            out_im_reg <= bf_im0;
        end
    end

    // 截断/舍入成 16 位输出
    assign xout_re = out_re_reg[31:16]; // 简易截断
    assign xout_im = out_im_reg[31:16];

endmodule
