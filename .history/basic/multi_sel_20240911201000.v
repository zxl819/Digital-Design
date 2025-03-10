// 利用input_grant进行寄存，寄存4个周期
//计数信号 2bit----FSM
// 乘法--移位可以实现无符号数的乘除法，有符号数的乘法
// 补0 <<低位补0，无符号数/有符号数乘法；>>高位补0，无符号数除法
// 位拼接--实现有符号数/无符号数的乘除法

module multi_sel(
    input [31:0] bus,
    input sel,
    output check
);