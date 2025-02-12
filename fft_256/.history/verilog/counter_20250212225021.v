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

always @(cur_state or start or full) begin
    case (cur_state)
        STOP:if(start == 1'b1) begin
            next_state = START;
            cnt_en = 1;
        end
        else next_state = STOP;
        START: if(full == 1'b1) begin
            next_state = STOP;
            cnt_en = 1'b0;
        end
        else next_state = START;
        default: next_state = STOP;
    endcase    
end


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        full <= 0;
        not_zero <= 0;
    end
    else if (cnt == thresh) begin
        cnt <= 0;
        full <= 1'b0;
        not_zero <= 1'b0;
    end
    else if(valid == 1'b1 && cnt_en == 1'b1) begin
        cnt <= cnt + 1;
        full <= 0;
        not_zero <= 1'b1;
    end
    else begin
        cnt <= cnt;
        full <= full;
        not_zero <= not_zero;
    end
endmodule