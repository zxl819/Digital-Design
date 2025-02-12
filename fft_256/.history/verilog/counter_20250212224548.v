module counter(
    input clk,
    input rst_n,
    input [6:0] thresh,
    input start,
    input valid,
    output reg not_zero,
    output reg full
);

reg [6:0] cnt;
reg cur_state, next_state;
reg cnt_en;

parameter START = 0;
parameter STOP = 1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cur_state <= STOP;
        cnt_en <= 0;
    end
    else begin
        cur_state <= next_state;
    end

end

endmodule