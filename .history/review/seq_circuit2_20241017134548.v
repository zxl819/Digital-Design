module seq_circuit2(
    input C,
    input clk,
    input rst_n,
    output wire Y
);

reg[1:0] curr_state;
reg[1:0] next_state;
always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        curr_state <= 2'b00;
        next_state <= 2'b00;
    end
    else begin
        curr_state <= next_state;
    end
end

// step two
always @(*) begin
    case(curr_state)
    2'b00:next_state = (C == 1'b1) ? 2'b01:2'b00;
    2'b01:next_state = (C == 1'b1) ? 2'b01:2'b11;
    endcase
end
endmodule