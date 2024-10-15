module seq_circuit(
    input A,
    input clk,
    input rst_n,
    output wire Y
);
reg q0,q1;
always@(posedge clk or negedge rst_n) begin
    if (~rst_n)begin
        q1 <= 0;
    end
    else begin
        
    end

end
endmodule