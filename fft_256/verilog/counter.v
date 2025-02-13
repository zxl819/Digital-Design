module counter #(parameter CNT_WIDTH = 16)(
    input clk,
    input rst_n,
    input [CNT_WIDTH - 1:0] thresh,
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

    // 状态更新同步
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cur_state <= STOP;
            cnt_en <= 0;
        end
        else begin
            cur_state <= next_state;
        end
    end

    // 状态机的组合逻辑
    always @(cur_state or start or full) begin
        case (cur_state)
            STOP: begin
                if(start == 1'b1) begin
                    next_state = START;
                    cnt_en = 1;
                end else begin
                    next_state = STOP;
                    cnt_en = 0;
                end
            end
            START: begin
                if(full == 1'b1) begin
                    next_state = STOP;
                    cnt_en = 0;
                end else begin
                    next_state = START;
                    cnt_en = 1;
                end
            end
            default: next_state = STOP;
        endcase    
    end

    // 计数器和输出信号控制
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 0;
            full <= 0;
            not_zero <= 0;
        end
        else if (cnt == thresh) begin
            cnt <= 0;
            full <= 1'b1;
            not_zero <= 1'b0;
        end
        else if (valid == 1'b1 && cnt_en == 1'b1) begin
            cnt <= cnt + 1;
            full <= 0;
            not_zero <= 1'b1;
        end
        else begin
            cnt <= cnt;
            full <= 0;
            not_zero <= 1'b0;
        end
    end

endmodule
