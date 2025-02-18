`timescale 1ns/1ns
module fft_256_2 (
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

    // operating data
    reg  signed [15:0] xm_re [8:0] [255:0];
    reg  signed [15:0] xm_im [8:0] [255:0];
    
    reg signed [15:0] xm_re_buf [255:0];
    reg signed [15:0] xm_im_buf [255:0];

    // enable control
    wire [8:0] en_ctrl;

    // input buffer
    integer k;

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0)begin 
              for(k=0; k <= 255; k=k+1 ) begin
                xm_re_buf[k] <= 0;
                xm_im_buf[k] <= 0;
            end
        end
        else begin
            for (k = 0; k <= 254; k=k+1 ) begin
                xm_re_buf[k+1] <= xm_re_buf[k];
                xm_im_buf[k+1] <= xm_im_buf[k];
            end
            xm_re_buf[0] <= x_re;
            xm_im_buf[0] <= x_im;
        end
    end

    // input ctrl
    parameter TIME_THRESH_IN = 254;

    counter counter_u1(
        .clk(clk),
        .rst_n(rst_n),
        .thresh(TIME_THRESH_IN),
        .start(sop_in),
        .valid(valid_in),
        .not_zero(),
        .full(en_ctrl[0]) 
    );

    // output buffer
    reg signed [15:0] ym_re_buf [255:0];
    reg signed [15:0] ym_im_buf [255:0];

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            for (k = 0; k<=255 ; k=k+1 ) begin
                ym_re_buf[k] <= 0;
                ym_im_buf[k] <= 0;
            end
        end
        else if (en_ctrl[8]) begin
            for (k = 0; k<=255 ; k=k+1 ) begin
                ym_re_buf[k] <= xm_re[8][k];
                ym_im_buf[k] <= xm_im[8][k];
            end
        end
        else begin
            for (k = 0; k<=254; k=k+1 ) begin
                ym_re_buf[k] <= ym_re_buf[k+1];
                ym_im_buf[k] <= ym_im_buf[k+1];
            end
        end
    end
    
    // output ctrl
    parameter TIME_THRESH_OUT = 256;

    counter counter_u2(
        .clk(clk),
        .rst_n(rst_n),
        .thresh(TIME_THRESH_OUT),
        .start(sop_out),
        .valid(1'b1),
        .not_zero(valid_out),
        .full() 
    );   

    assign sop_out = en_ctrl[8];

    reg signed [15:0] y_re_out,y_im_out;

    always@(ym_re_buf[0] or ym_im_buf[0]) begin
        if (inv == 1'b0) begin
            y_re_out = ym_re_buf[0];
            y_im_out = ym_im_buf[0];
        end
        else if(inv == 1'b1) begin
            y_re_out = (ym_im_buf[0] >>> 8);
            y_im_out = (ym_re_buf[0] >>> 8);
        end
    end

    assign y_re = y_re_out;
    assign y_im = y_im_out;

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
        for (idx = 0; idx < 256; idx = idx + 1) begin :BITREV_ASSIGN
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
    wire signed [15:0] factor_re [0:256/2-1];
    wire signed [15:0] factor_im [0:256/2-1];

 // 实部赋值
assign factor_re[0] = 16'h2000;
assign factor_re[1] = 16'h1FFD;
assign factor_re[2] = 16'h1FF6;
assign factor_re[3] = 16'h1FE9;
assign factor_re[4] = 16'h1FD8;
assign factor_re[5] = 16'h1FC2;
assign factor_re[6] = 16'h1FA7;
assign factor_re[7] = 16'h1F87;
assign factor_re[8] = 16'h1F62;
assign factor_re[9] = 16'h1F38;
assign factor_re[10] = 16'h1F0A;
assign factor_re[11] = 16'h1ED7;
assign factor_re[12] = 16'h1E9F;
assign factor_re[13] = 16'h1E62;
assign factor_re[14] = 16'h1E21;
assign factor_re[15] = 16'h1DDB;
assign factor_re[16] = 16'h1D90;
assign factor_re[17] = 16'h1D41;
assign factor_re[18] = 16'h1CED;
assign factor_re[19] = 16'h1C95;
assign factor_re[20] = 16'h1C38;
assign factor_re[21] = 16'h1BD7;
assign factor_re[22] = 16'h1B72;
assign factor_re[23] = 16'h1B09;
assign factor_re[24] = 16'h1A9B;
assign factor_re[25] = 16'h1A29;
assign factor_re[26] = 16'h19B3;
assign factor_re[27] = 16'h193A;
assign factor_re[28] = 16'h18BC;
assign factor_re[29] = 16'h183B;
assign factor_re[30] = 16'h17B5;
assign factor_re[31] = 16'h172D;
assign factor_re[32] = 16'h16A0;
assign factor_re[33] = 16'h1610;
assign factor_re[34] = 16'h157D;
assign factor_re[35] = 16'h14E6;
assign factor_re[36] = 16'h144C;
assign factor_re[37] = 16'h13AF;
assign factor_re[38] = 16'h130F;
assign factor_re[39] = 16'h126D;
assign factor_re[40] = 16'h11C7;
assign factor_re[41] = 16'h111E;
assign factor_re[42] = 16'h1073;
assign factor_re[43] = 16'hFC5;
assign factor_re[44] = 16'hF15;
assign factor_re[45] = 16'hE63;
assign factor_re[46] = 16'hDAE;
assign factor_re[47] = 16'hCF7;
assign factor_re[48] = 16'hC3E;
assign factor_re[49] = 16'hB84;
assign factor_re[50] = 16'hAC7;
assign factor_re[51] = 16'hA09;
assign factor_re[52] = 16'h94A;
assign factor_re[53] = 16'h888;
assign factor_re[54] = 16'h7C6;
assign factor_re[55] = 16'h702;
assign factor_re[56] = 16'h63E;
assign factor_re[57] = 16'h578;
assign factor_re[58] = 16'h4B2;
assign factor_re[59] = 16'h3EA;
assign factor_re[60] = 16'h322;
assign factor_re[61] = 16'h25A;
assign factor_re[62] = 16'h191;
assign factor_re[63] = 16'hC9;
assign factor_re[64] = 16'h0;
assign factor_re[65] = 16'hFF36;
assign factor_re[66] = 16'hFE6E;
assign factor_re[67] = 16'hFDA5;
assign factor_re[68] = 16'hFCDD;
assign factor_re[69] = 16'hFC15;
assign factor_re[70] = 16'hFB4D;
assign factor_re[71] = 16'hFA87;
assign factor_re[72] = 16'hF9C1;
assign factor_re[73] = 16'hF8FD;
assign factor_re[74] = 16'hF839;
assign factor_re[75] = 16'hF777;
assign factor_re[76] = 16'hF6B5;
assign factor_re[77] = 16'hF5F6;
assign factor_re[78] = 16'hF538;
assign factor_re[79] = 16'hF47B;
assign factor_re[80] = 16'hF3C1;
assign factor_re[81] = 16'hF308;
assign factor_re[82] = 16'hF251;
assign factor_re[83] = 16'hF19C;
assign factor_re[84] = 16'hF0EA;
assign factor_re[85] = 16'hF03A;
assign factor_re[86] = 16'hEF8C;
assign factor_re[87] = 16'hEEE1;
assign factor_re[88] = 16'hEE38;
assign factor_re[89] = 16'hED92;
assign factor_re[90] = 16'hECF0;
assign factor_re[91] = 16'hEC50;
assign factor_re[92] = 16'hEBB3;
assign factor_re[93] = 16'hEB19;
assign factor_re[94] = 16'hEA82;
assign factor_re[95] = 16'hE9EF;
assign factor_re[96] = 16'hE95F;
assign factor_re[97] = 16'hE8D2;
assign factor_re[98] = 16'hE84A;
assign factor_re[99] = 16'hE7C4;
assign factor_re[100] = 16'hE743;
assign factor_re[101] = 16'hE6C5;
assign factor_re[102] = 16'hE64C;
assign factor_re[103] = 16'hE5D6;
assign factor_re[104] = 16'hE564;
assign factor_re[105] = 16'hE4F6;
assign factor_re[106] = 16'hE48D;
assign factor_re[107] = 16'hE428;
assign factor_re[108] = 16'hE3C7;
assign factor_re[109] = 16'hE36A;
assign factor_re[110] = 16'hE312;
assign factor_re[111] = 16'hE2BE;
assign factor_re[112] = 16'hE26F;
assign factor_re[113] = 16'hE224;
assign factor_re[114] = 16'hE1DE;
assign factor_re[115] = 16'hE19D;
assign factor_re[116] = 16'hE160;
assign factor_re[117] = 16'hE128;
assign factor_re[118] = 16'hE0F5;
assign factor_re[119] = 16'hE0C7;
assign factor_re[120] = 16'hE09D;
assign factor_re[121] = 16'hE078;
assign factor_re[122] = 16'hE058;
assign factor_re[123] = 16'hE03D;
assign factor_re[124] = 16'hE027;
assign factor_re[125] = 16'hE016;
assign factor_re[126] = 16'hE009;
assign factor_re[127] = 16'hE002;

// 虚部赋值
assign factor_im[0] = 16'h0000;
assign factor_im[1] = 16'hFF36;
assign factor_im[2] = 16'hFE6E;
assign factor_im[3] = 16'hFDA5;
assign factor_im[4] = 16'hFCDD;
assign factor_im[5] = 16'hFC15;
assign factor_im[6] = 16'hFB4D;
assign factor_im[7] = 16'hFA87;
assign factor_im[8] = 16'hF9C1;
assign factor_im[9] = 16'hF8FD;
assign factor_im[10] = 16'hF839;
assign factor_im[11] = 16'hF777;
assign factor_im[12] = 16'hF6B5;
assign factor_im[13] = 16'hF5F6;
assign factor_im[14] = 16'hF538;
assign factor_im[15] = 16'hF47B;
assign factor_im[16] = 16'hF3C1;
assign factor_im[17] = 16'hF308;
assign factor_im[18] = 16'hF251;
assign factor_im[19] = 16'hF19C;
assign factor_im[20] = 16'hF0EA;
assign factor_im[21] = 16'hF03A;
assign factor_im[22] = 16'hEF8C;
assign factor_im[23] = 16'hEEE1;
assign factor_im[24] = 16'hEE38;
assign factor_im[25] = 16'hED92;
assign factor_im[26] = 16'hECF0;
assign factor_im[27] = 16'hEC50;
assign factor_im[28] = 16'hEBB3;
assign factor_im[29] = 16'hEB19;
assign factor_im[30] = 16'hEA82;
assign factor_im[31] = 16'hE9EF;
assign factor_im[32] = 16'hE95F;
assign factor_im[33] = 16'hE8D2;
assign factor_im[34] = 16'hE84A;
assign factor_im[35] = 16'hE7C4;
assign factor_im[36] = 16'hE743;
assign factor_im[37] = 16'hE6C5;
assign factor_im[38] = 16'hE64C;
assign factor_im[39] = 16'hE5D6;
assign factor_im[40] = 16'hE564;
assign factor_im[41] = 16'hE4F6;
assign factor_im[42] = 16'hE48D;
assign factor_im[43] = 16'hE428;
assign factor_im[44] = 16'hE3C7;
assign factor_im[45] = 16'hE36A;
assign factor_im[46] = 16'hE312;
assign factor_im[47] = 16'hE2BE;
assign factor_im[48] = 16'hE26F;
assign factor_im[49] = 16'hE224;
assign factor_im[50] = 16'hE1DE;
assign factor_im[51] = 16'hE19D;
assign factor_im[52] = 16'hE160;
assign factor_im[53] = 16'hE128;
assign factor_im[54] = 16'hE0F5;
assign factor_im[55] = 16'hE0C7;
assign factor_im[56] = 16'hE09D;
assign factor_im[57] = 16'hE078;
assign factor_im[58] = 16'hE058;
assign factor_im[59] = 16'hE03D;
assign factor_im[60] = 16'hE027;
assign factor_im[61] = 16'hE016;
assign factor_im[62] = 16'hE009;
assign factor_im[63] = 16'hE002;
assign factor_im[64] = 16'hE000;
assign factor_im[65] = 16'hE002;
assign factor_im[66] = 16'hE009;
assign factor_im[67] = 16'hE016;
assign factor_im[68] = 16'hE027;
assign factor_im[69] = 16'hE03D;
assign factor_im[70] = 16'hE058;
assign factor_im[71] = 16'hE078;
assign factor_im[72] = 16'hE09D;
assign factor_im[73] = 16'hE0C7;
assign factor_im[74] = 16'hE0F5;
assign factor_im[75] = 16'hE128;
assign factor_im[76] = 16'hE160;
assign factor_im[77] = 16'hE19D;
assign factor_im[78] = 16'hE1DE;
assign factor_im[79] = 16'hE224;
assign factor_im[80] = 16'hE26F;
assign factor_im[81] = 16'hE2BE;
assign factor_im[82] = 16'hE312;
assign factor_im[83] = 16'hE36A;
assign factor_im[84] = 16'hE3C7;
assign factor_im[85] = 16'hE428;
assign factor_im[86] = 16'hE48D;
assign factor_im[87] = 16'hE4F6;
assign factor_im[88] = 16'hE564;
assign factor_im[89] = 16'hE5D6;
assign factor_im[90] = 16'hE64C;
assign factor_im[91] = 16'hE6C5;
assign factor_im[92] = 16'hE743;
assign factor_im[93] = 16'hE7C4;
assign factor_im[94] = 16'hE84A;
assign factor_im[95] = 16'hE8D2;
assign factor_im[96] = 16'hE95F;
assign factor_im[97] = 16'hE9EF;
assign factor_im[98] = 16'hEA82;
assign factor_im[99] = 16'hEB19;
assign factor_im[100] = 16'hEBB3;
assign factor_im[101] = 16'hEC50;
assign factor_im[102] = 16'hECF0;
assign factor_im[103] = 16'hED92;
assign factor_im[104] = 16'hEE38;
assign factor_im[105] = 16'hEEE1;
assign factor_im[106] = 16'hEF8C;
assign factor_im[107] = 16'hF03A;
assign factor_im[108] = 16'hF0EA;
assign factor_im[109] = 16'hF19C;
assign factor_im[110] = 16'hF251;
assign factor_im[111] = 16'hF308;
assign factor_im[112] = 16'hF3C1;
assign factor_im[113] = 16'hF47B;
assign factor_im[114] = 16'hF538;
assign factor_im[115] = 16'hF5F6;
assign factor_im[116] = 16'hF6B5;
assign factor_im[117] = 16'hF777;
assign factor_im[118] = 16'hF839;
assign factor_im[119] = 16'hF8FD;
assign factor_im[120] = 16'hF9C1;
assign factor_im[121] = 16'hFA87;
assign factor_im[122] = 16'hFB4D;
assign factor_im[123] = 16'hFC15;
assign factor_im[124] = 16'hFCDD;
assign factor_im[125] = 16'hFDA5;
assign factor_im[126] = 16'hFE6E;
assign factor_im[127] = 16'hFF36;
    // 6.2 生成 8 级蝶形
    genvar m,i,j;

    generate
        
        for (m = 0; m <= 7; m=m+1) begin:stage
            for (i = 0; i <= (1<<(7-m))-1 ; i=i+1) begin:group
                for (j = 0; j <= (1<<m)-1 ; j=j+1) begin:unit
                     butterfly butterfly_u(
                        .clk(clk),
                        .rst_n(rst_n),
                        .en(en_ctrl[m]),
                        .xp_re(xm_re[m][(i<<(m+1))+j]),
                        .xp_im(xm_im[m][(i<<(m+1))+j]),
                        .xq_re(xm_re[m][(i<<(m+1))+j+(1<<m)]),
                        .xq_im(xm_im[m][(i<<(m+1))+j+(1<<m)]),
                        .factor_re(factor_re[(1<<(7-m))*j]),
                        .factor_im(factor_im[(1<<(7-m))*j]),
                        .vld(en_ctrl[m+1]),
                        .yp_re(xm_re[m+1][(i<<(m+1))+j]),
                        .yp_im(xm_im[m+1][(i<<(m+1))+j]),
                        .yq_re(xm_re[m+1][(i<<(m+1))+j+(1<<m)]),
                        .yq_im(xm_im[m+1][(i<<(m+1))+j+(1<<m)])
                    );
                end
            end 
        end

    endgenerate
endmodule
