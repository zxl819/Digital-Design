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
        rom[0] <= 4'd0;
        rom[1] <= 4'd2;
        rom[2] <= 4'd4;
        rom[3] <= 4'd6;
        rom[4] <= 4'd8;
        rom[5] <= 4'd10;
        rom[6] <= 4'd12;
        rom[7] <= 4'd14;
    end
    else begin
        rom[0] <= rom[0];
        rom[1] <= rom[1];
        rom[2] <= rom[2];
        rom[3] <= rom[3];
        rom[4] <= rom[4];
        rom[5] <= rom[5];
        rom[6] <= rom[6];
        rom[7] <= rom[7];
    end
end
assign data = rom[addr];
endmodule