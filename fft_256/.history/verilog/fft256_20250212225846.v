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
wire signed [15:0] xm_im_buf [0:N-1];


endmodule