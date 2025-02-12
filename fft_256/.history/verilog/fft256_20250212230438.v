module fft_256(
    input clk,
    input rst_n,
    input inv,
    input valid_in,
    input sop_in,
    input [15:0] x_re,
    input [15:0] x_im,
    output valid_out,
    output sop_out,
    output [15:0] y_re,
    output [15:0] y_im
);
   //================================================================
    // 1) 参数定义
    //================================================================
    localparam N = 256 ;   // 256点FFT
    localparam STAGE = 8 ; // 8级蝶形运算
    localparam LOGN = 16 ;    // 16位宽
    localparam TIME_THRESH_IN = N-2;
    localparam TIME_THRESH_OUT = N;

        //================================================================
    // 2) 缓冲区：用于接收输入数据，并延时后在合适的时刻启动 FFT
    //================================================================
wire signed [15:0] xm_re_buf [0:N-1];
wire signed [15:0] xm_im_buf [0:N-1]; //需不需要多一纬度

integer k;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (k = 0; k < N; k = k + 1) begin
            xm_re_buf[k] <= 16'sd0;
            xm_im_buf[k] <= 16'sd0;
        end
    end
    else begin
        for (k = 0; k < N-1; k = k + 1) begin
            xm_re_buf[k+1] <= xm_re_buf[k];
            xm_im_buf[k+1] <= xm_im_buf[k];
        end
        xm_re_buf[0] <= x_re;
        xm_im_buf[0] <= x_im;
    end
end
    //================================================================
    // 3) 计数器，用于在输入推入 N 个数据后，触发 FFT 计算使能
    //================================================================
    wire en_stage0;
    wire not_used;

    counter #(
        .CNT_WIDTH (LOGN),
    ) counter_in(
        .clk(clk),
        .rst_n(rst_n),
        .thresh(TIME_THRESH_IN),
        .start(valid_in),
        .valid(valid_in),
        .not_zero(not_used),
        .full(en_stage0)
    );

     //================================================================
    // 4) 位反转输入：将缓冲区的数据放到 butterfly 第0级的 xm_re[0][*], xm_im[0][*]
    //================================================================
        // 声明中间的多维数组： xm_re[m][p], xm_im[m][p]
    // m 从 0~STAGE，p 从 0~N-1
    reg signed [15:0] xm_re[0:STAGE][0:N-1];
    reg signed [15:0] xm_im[0:STAGE][0:N-1];
        // 4.1 定义一个函数做 8bit 位反转
        function [7:0] bit_reverse_8(input [7:0] in);
            integer i;
            begin
                for (i = 0; i < 8; i = i + 1) begin
                    bit_reverse_8[i] = in[7-i];
                end
            end
        endfunction
    // 4.2 用 generate+for 循环把 buffer 里的数据按照 bit-reverse 排到 xm_re[0][*]
    


    //================================================================
    // 3) FFT 运算
    //================================================================
    wire [15:0] ym_re [0:N-1];
    wire [15:0] ym_im [0:N-1];
    wire valid_out_buf;
    wire sop_out_buf;
    wire [15:0] y_re_buf [0:N-1];
    wire [15:0] y_im_buf [0:N-1];

    // 3.1) 8级蝶形运算
    wire [15:0] xp_re;
    wire [15:0] xp_im;
    wire [15:0] xq_re;
    wire [15:0] xq_im;
    wire [15:0] factor_re;
    wire [15:0] factor_im;
    wire [15:0] yp_re;
    wire [15:0] yp_im;
    wire [15:0] yq_re;
    wire [15:0] yq_im;
    wire vld;
    wire [3:0] en_r;
    wire [31:0] xq_wnr_re0;
    wire [31:0] xq_wnr_re1;
    wire [31:0] xq_wnr_im0;
    wire [31:0] xq_wnr_im1;
    wire [31:0] xp_re_d;
    wire [31:0] xp_im_d;

    butterfly b0(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_r[0



endmodule