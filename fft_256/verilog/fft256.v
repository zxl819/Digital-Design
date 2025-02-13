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
        assign factor_re[0] = 16'h2000;    assign factor_im[0] = 16'h0000;
        assign factor_re[1] = 16'h1FFF;    assign factor_im[1] = 16'hFF37;
        assign factor_re[2] = 16'h1FFE;    assign factor_im[2] = 16'hFE6F;
        assign factor_re[3] = 16'h1FEC;    assign factor_im[3] = 16'hFDA8;
        assign factor_re[4] = 16'h1FEA;    assign factor_im[4] = 16'hFCE1;
        assign factor_re[5] = 16'h1FE0;    assign factor_im[5] = 16'hFC1B;
        assign factor_re[6] = 16'h1FDF;    assign factor_im[6] = 16'hFB54;
        assign factor_re[7] = 16'h1FDD;    assign factor_im[7] = 16'hFA8F;
        assign factor_re[8] = 16'h1FDB;    assign factor_im[8] = 16'hF9CA;
        assign factor_re[9] = 16'h1FD9;    assign factor_im[9] = 16'hF904;
        assign factor_re[10] = 16'h1FD7;   assign factor_im[10] = 16'hF83F;
        assign factor_re[11] = 16'h1FD5;   assign factor_im[11] = 16'hF77A;
        assign factor_re[12] = 16'h1FD3;   assign factor_im[12] = 16'hF6B5;
        assign factor_re[13] = 16'h1FD1;   assign factor_im[13] = 16'hF5F0;
        assign factor_re[14] = 16'h1FCF;   assign factor_im[14] = 16'hF52B;
        assign factor_re[15] = 16'h1FCD;   assign factor_im[15] = 16'hF466;
        assign factor_re[16] = 16'h1FCB;   assign factor_im[16] = 16'hF3A1;
        assign factor_re[17] = 16'h1FC9;   assign factor_im[17] = 16'hF37C;
        assign factor_re[18] = 16'h1FC7;   assign factor_im[18] = 16'hF2B7;
        assign factor_re[19] = 16'h1FC5;   assign factor_im[19] = 16'hF292;
        assign factor_re[20] = 16'h1FC3;   assign factor_im[20] = 16'hF1CD;
        assign factor_re[21] = 16'h1FC1;   assign factor_im[21] = 16'hF108;
        assign factor_re[22] = 16'h1FBF;   assign factor_im[22] = 16'hF043;
        assign factor_re[23] = 16'h1FBD;   assign factor_im[23] = 16'hEF7E;
        assign factor_re[24] = 16'h1FBB;   assign factor_im[24] = 16'hEEB9;
        assign factor_re[25] = 16'h1FB9;   assign factor_im[25] = 16'hEDF4;
        assign factor_re[26] = 16'h1FB7;   assign factor_im[26] = 16'hED2F;
        assign factor_re[27] = 16'h1FB5;   assign factor_im[27] = 16'hEC6A;
        assign factor_re[28] = 16'h1FB3;   assign factor_im[28] = 16'hEBA5;
        assign factor_re[29] = 16'h1FB1;   assign factor_im[29] = 16'hEAE0;
        assign factor_re[30] = 16'h1FAF;   assign factor_im[30] = 16'hEA1B;
        assign factor_re[31] = 16'h1FAD;   assign factor_im[31] = 16'hE956;
        assign factor_re[32] = 16'h1FAB;   assign factor_im[32] = 16'hE88F;
        assign factor_re[33] = 16'h1FA9;   assign factor_im[33] = 16'hE7CA;
        assign factor_re[34] = 16'h1FA7;   assign factor_im[34] = 16'hE705;
        assign factor_re[35] = 16'h1FA5;   assign factor_im[35] = 16'hE63F;
        assign factor_re[36] = 16'h1FA3;   assign factor_im[36] = 16'hE57A;
        assign factor_re[37] = 16'h1FA1;   assign factor_im[37] = 16'hE4B5;
        assign factor_re[38] = 16'h1F9F;   assign factor_im[38] = 16'hE3F0;
        assign factor_re[39] = 16'h1F9D;   assign factor_im[39] = 16'hE32A;
        assign factor_re[40] = 16'h1F9B;   assign factor_im[40] = 16'hE265;
        assign factor_re[41] = 16'h1F99;   assign factor_im[41] = 16'hE1A0;
        assign factor_re[42] = 16'h1F97;   assign factor_im[42] = 16'hE13B;
        assign factor_re[43] = 16'h1F95;   assign factor_im[43] = 16'hE076;
        assign factor_re[44] = 16'h1F93;   assign factor_im[44] = 16'hDFB1;
        assign factor_re[45] = 16'h1F91;   assign factor_im[45] = 16'hDF8C;
        assign factor_re[46] = 16'h1F8F;   assign factor_im[46] = 16'hDECF;
        assign factor_re[47] = 16'h1F8D;   assign factor_im[47] = 16'hDE12;
        assign factor_re[48] = 16'h1F8B;   assign factor_im[48] = 16'hDD55;
        assign factor_re[49] = 16'h1F89;   assign factor_im[49] = 16'hDCA0;
        assign factor_re[50] = 16'h1F87;   assign factor_im[50] = 16'hDBEB;
        assign factor_re[51] = 16'h1F85;   assign factor_im[51] = 16'hDB36;
        assign factor_re[52] = 16'h1F83;   assign factor_im[52] = 16'hDA81;
        assign factor_re[53] = 16'h1F81;   assign factor_im[53] = 16'hD9CC;
        assign factor_re[54] = 16'h1F7F;   assign factor_im[54] = 16'hD918;
        assign factor_re[55] = 16'h1F7D;   assign factor_im[55] = 16'hD86B;
        assign factor_re[56] = 16'h1F7B;   assign factor_im[56] = 16'hD7BE;
        assign factor_re[57] = 16'h1F79;   assign factor_im[57] = 16'hD712;
        assign factor_re[58] = 16'h1F77;   assign factor_im[58] = 16'hD665;
        assign factor_re[59] = 16'h1F75;   assign factor_im[59] = 16'hD5B8;
        assign factor_re[60] = 16'h1F73;   assign factor_im[60] = 16'hD50C;
        assign factor_re[61] = 16'h1F71;   assign factor_im[61] = 16'hD460;
        assign factor_re[62] = 16'h1F6F;   assign factor_im[62] = 16'hD3B3;
        assign factor_re[63] = 16'h1F6D;   assign factor_im[63] = 16'hD307;
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


    // 输出打拍计数器
    wire not_zero;
    counter #(
        .CNT_WIDTH (16)
    ) counter_out (
        .clk   (clk),
        .rst_n (rst_n),
        .thresh(TIME_THRESH_OUT),
        .start (sop_out),
        .valid (1'b1),
        .not_zero(not_zero),
        .full  ( /* unused */ )
    );

    // 当最后一级蝶形完成时，启动输出
    assign sop_out = en_ctrl[STAGE];
    assign valid_out = not_zero;

    // 可根据 inv 信号做相应处理
    reg signed [15:0] y_re_r, y_im_r;
    always @(*) begin
        if(!inv) begin
            y_re_r = ym_re_buf[0];
            y_im_r = ym_im_buf[0];
        end
        else begin
            // 例如：IFFT 等
            y_re_r = ym_im_buf[0] >>> LOGN;  // 除以 256
            y_im_r = ym_re_buf[0] >>> LOGN;
        end
    end

    assign y_re = y_re_r;
    assign y_im = y_im_r;

endmodule