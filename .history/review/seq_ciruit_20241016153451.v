module seq_circuit(
    input A,
    input clk,
    input rst_n,
    output wire Y
);

reg r0, r1;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        q1 <= 0;
    end
    else begin
        q1 <= A ^ q1 ^ q0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        q0 <= 0;
    end
    else begin
        q0 <= ~q0;
    end
end
endmodule