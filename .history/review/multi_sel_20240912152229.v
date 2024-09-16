module multi_sel(
    input [0:7]d,
    input clk,
    input rst,
    output reg input_grant,
    output reg [0:10]out

);
reg [1:0] count;
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        count <= 2'b0;
    end
    else begin 
        count <= count + 1'b1;
    end
end

//FSM
reg [7:0] d_reg;
always @(posedge clk or negedge rst) 
begin
    if(!rst)begin  //在rst信号为0时，将out、input_grant、d_reg清零
        out <= 11'b0;
        input_grant <= 1'b0;
        d_reg <= 8'b0;
    end
    else begin
    case(count)
    2'b00:begin
        out <= d;
        d_reg <= d;
        input_grant <= 1'b1;
    end
    2'b01:begin
        out <= d_reg +{d_reg,1'b0}
        input_grant <= 1'b0;
    end
    endcase
end
end

endmodule