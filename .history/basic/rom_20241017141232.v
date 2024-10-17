module Rom(
    input clk,
    input rst_n,
    input [7:0]addr,
    output [3:0]data
);
// 二维数组定义，rom前面是位宽，后面是深度
reg [3:0]rom[0:7];

always @(posedge clk or negedge rst_n)begin
    if(~rst_n)begin
        
    end
end
endmodule