module multi_sel(
    input [0:7] d,
    input clk,
    input rst,
    output reg input_grant,
    output reg [10:0]out
);
reg [1:0] count;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        count <= 2'b0;
    end
    else begin
        count <= count +1'b1;
    end
end

reg [0:7] d_reg;
//FSM
always @(posedge clk or posedge rst)begin
    if(!rst)begin
        out <= 11'b0;
        input_grant <= 1'b0;
        d_reg <=8'b0;
    end
    else begin
        case(count)
        2'b00:begin
            d_reg <= d;
            out <= d_reg;
            input_grant <= 1'b1;
        end
        2'b01:begin
            out <= d_reg +{d_ref,1'b0};
            input_grant <= 1'b0;
        end
        2'b10:begin
            out <= d_reg +{d_ref,1'b0} +{d_ref,2'b00};
            input_grant <= 1'b0;
        end
        2'b11:begin
            out <= {d_ref,3'b0};
            input_grant <= 1'b0;
        end
        endcase
    end
end
endmodule