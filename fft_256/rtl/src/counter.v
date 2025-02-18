`timescale 1ns/1ns

module counter (

    input clk,

    input rst_n,

    input [31:0] thresh,

    input start,

    input valid,

    output reg not_zero,

    output reg full 

);

    

    reg [31:0] cnt;

    reg cur_state, nxt_state;

    reg cnt_en;



    parameter START = 0;

    parameter STOP = 1;



    always @(posedge clk or negedge rst_n) begin

        if (rst_n == 1'b0) begin

            cur_state <= STOP;

            cnt_en <= 0;

        end

        else begin

            cur_state <= nxt_state;

        end

    end



    always @(cur_state or start or full) begin

        case (cur_state)

            STOP : if(start == 1'b1) begin

                nxt_state = START;

                cnt_en = 1'b1; 

            end

            else nxt_state = STOP;

            START : if(full == 1'b1) begin

                nxt_state = STOP;

                cnt_en = 1'b0;

            end

            else nxt_state = START;

            default : nxt_state = STOP;

        endcase

    end



    always @(posedge clk or negedge rst_n) begin

        if (rst_n == 1'b0) begin

            cnt <= 0;

            full <= 1'b0;

            not_zero <= 1'b0;

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

            full <= 1'b0;

            not_zero <= 1'b0;

        end

    end



endmodule