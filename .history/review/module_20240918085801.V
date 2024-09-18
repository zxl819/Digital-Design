module main_mod(
    input clk,
    input rst_n,
    input [7:0]a,
    input [7:0]b,
    input [7:0]c,
    
    output [7:0]d
);

endmodule

module sub_mod(
    input clk,
    input rst_n,
    input [7:0]a,
    input [7:0]b,    
    output [7:0]d

);
reg [7:0]d_out;
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        
    end
end
endmodule