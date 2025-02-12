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
reg [2:0] en_r;

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        en_r <= 0;
    end
    else begin
        en_r <= {en_r[1:0], en};
    end
end
reg signed
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        en_r <= 0;
    end
    else begin
        en_r <= {en_r[1:0],en};
    end
end

endmodule