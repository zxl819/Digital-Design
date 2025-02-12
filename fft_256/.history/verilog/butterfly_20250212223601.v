module butterfly(
    input clk, 
    input rst_n,
    input en,
    input signed [15:0] xp_re,
    input signed [15:0] xp_im,
    input signed [15:0] xq_re,
    input signed [15:0] xq_im,
    input signed [15:0] factor_re,
    input signed [15:0] factor_im,
    output vld,
    output signed [15:0] yp_re,
    output signed [15:0] yp_im,
    output signed [15:0] yq_re,
    output signed [15:0] yq_im
);
reg [3:0] en_r;
    //----------------------------------------------------------------------------
    // 1) 使能信号的流水寄存
    //----------------------------------------------------------------------------

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        en_r <= 0;
    end
    else begin
        en_r <= {en_r[2:0], en};
    end
end
assign vld = en_r[2];

//----------------------------------------------------------------------------
// 2) 第 1 拍：计算 xq 与旋转因子的乘积，并把 xp 做移位对齐
//----------------------------------------------------------------------------


reg signed [31:0] xq_wnr_re0;
reg signed [31:0] xq_wnr_re1;
reg signed [31:0] xq_wnr_im0;
reg signed [31:0] xq_wnr_im1;
reg signed [31:0] xp_re_d;
reg signed [31:0] xp_im_d;

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        xp_re_d <= 0;
        xp_im_d <= 0;
        xq_wnr_re0 <= 0;
        xq_wnr_re1 <= 0;
        xq_wnr_im0 <= 0;
        xq_wnr_im1 <= 0;

    end
    else if(en) begin  //bufferfly algorithm
        xq_wnr_re0 <= xq_re * factor_re; 
        xq_wnr_re1 <= xq_im * factor_im;
        xq_wnr_im0 <= xq_re * factor_im;
        xq_wnr_im1 <= xq_im * factor_re;

        //xp 左移15位
        xp_re_d <= {{4{xp_re[15]}}, xp_re[14:0],13'b0};
        xp_im_d <= {{4{xp_im[15]}}, xp_im[14:0],13'b0};
    end
end

reg signed [31:0] xq_wnr_re;
reg signed [31:0] xq_wnr_im;
reg signed [31:0] xp_re_d1;
reg signed [31:0] xp_im_d1; 

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        xq_wnr_re <= 0;
        xq_wnr_im <= 0;
        xp_re_d1 <= 0;
        xp_im_d1 <= 0;
    end
    else if(en_r[0]) begin
        xp_re_d1 <= xp_re_d;
        xp_im_d1 <= xp_im_d;
        xq_wnr_re <= xq_wnr_re0 - xq_wnr_re1;
        xq_wnr_im <= xq_wnr_im0 + xq_wnr_im1;
    end
end



endmodule