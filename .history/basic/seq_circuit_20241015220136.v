module seq_circuit(
    input A,
    input clk,
    input rst_n,
    output wire Y
);
reg q0,q1;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        q1 <= 0;
        else begin
        q1 = A ^ q1 ^ q0;
        end
    end

end
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        q0 <= 0;
        else begin
        q0 = A ^ q1 ^ q0;
        end
    end


endmodule