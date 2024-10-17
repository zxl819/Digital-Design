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
        
    end
end
endmodule