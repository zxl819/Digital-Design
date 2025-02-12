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
    genvar idx;
    generate
        for (idx = 0; idx < N; idx = idx + 1) begin :BITREV_ASSIGN
            wire [7:0] rev_bit = bit_reverse_8(idx[7:0]);

            always @(*) begin
                xm_re[0][idx] = xm_re_buf[rev_bit];
                xm_im[0][idx] = xm_im_buf[rev_bit];
            end
        end
    endgenerate


//================================================================
    // 5) 旋转因子 ROM (示例) ：存放 0~127 的 Wn (或 Wn×某个 SCALE)
    //================================================================
    reg signed [15:0] factor_re [0:N/2-1];
    reg signed [15:0] factor_im [0:N/2-1];

    initial begin

    end

//================================================================
// 6) 多级蝶形生成
//================================================================
    wire [STAGE:0] en_ctrl;  // en_ctrl[0] ~ en_ctrl[8]
    assign en_ctrl[0] = en_stage0;  // 第0级 butterfly 的使能 = 输入缓冲计数到阈值后

// 6.2 生成 8 级蝶形
    genvar m_gen, i_gen, j_gen;
    generate
        for(m_gen = 0; m_gen < STAGE; m_gen=m_gen+1) begin: FFT_STAGE
            // group 的个数：2^(STAGE-1-m_gen)
            // 每个 group 的大小：2^(m_gen+1)
            localparam GROUP_NUM  = (1 << (STAGE-1-m_gen));
            localparam GROUP_SIZE = (1 << (m_gen+1));
         for(i_gen = 0; i_gen < GROUP_NUM; i_gen=i_gen+1) begin: GROUP
                for(j_gen = 0; j_gen < (1 << m_gen); j_gen=j_gen+1) begin: UNIT
                    // xp 的索引 = (i_gen << (m_gen+1)) + j_gen
                    // xq 的索引 = xp + (1 << m_gen)
                    localparam IDX_XP = (i_gen << (m_gen+1)) + j_gen;
                    localparam IDX_XQ = IDX_XP + (1 << m_gen);

                    // twiddle factor 的下标
                    // (1 << (STAGE - 1 - m_gen)) * j_gen
                    wire [7:0] w_idx = (1 << (STAGE - 1 - m_gen)) * j_gen;

                    butterfly butterfly_u (
                        .clk      (clk),
                        .rst_n    (rst_n),
                        .en       (en_ctrl[m_gen]), // 第 m_gen 级使能
                        // 输入
                        .xp_re    (xm_re[m_gen][IDX_XP]),
                        .xp_im    (xm_im[m_gen][IDX_XP]),
                        .xq_re    (xm_re[m_gen][IDX_XQ]),
                        .xq_im    (xm_im[m_gen][IDX_XQ]),
                        // twiddle
                        .factor_re(factor_re[w_idx]),
                        .factor_im(factor_im[w_idx]),
                        // 输出
                        .vld      (en_ctrl[m_gen+1]), // 第 m_gen+1 级使能
                        .yp_re    (xm_re[m_gen+1][IDX_XP]),
                        .yp_im    (xm_im[m_gen+1][IDX_XP]),
                        .yq_re    (xm_re[m_gen+1][IDX_XQ]),
                        .yq_im    (xm_im[m_gen+1][IDX_XQ])
                    );
                end
            end
        end
    endgenerate
    //================================================================
    // 7) 输出缓冲+输出控制
    //================================================================
    reg signed [15:0] ym_re_buf [0:N-1];
    reg signed [15:0] ym_im_buf [0:N-1];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(k=0; k<N; k=k+1) begin
                ym_re_buf[k] <= 16'sd0;
                ym_im_buf[k] <= 16'sd0;
            end
        end
        else if(en_ctrl[STAGE]) begin
            // 当最后一级蝶形完成时，把 xm_re[STAGE][*] 存进输出缓冲
            for(k=0; k<N; k=k+1) begin
                ym_re_buf[k] <= xm_re[STAGE][k];
                ym_im_buf[k] <= xm_im[STAGE][k];
            end
        end
        else begin
            // 类似题主对 64点的做法：移位
            // 也可以直接把 [0] 后面接 reg 反复输出
            for(k=0; k<N-1; k=k+1) begin
                ym_re_buf[k] <= ym_re_buf[k+1];
                ym_im_buf[k] <= ym_im_buf[k+1];
            end
        end
    end


endmodule