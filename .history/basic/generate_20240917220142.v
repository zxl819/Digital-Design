/* verilog的for和C语言的for的不同点；
C语言的for里面的语句是串行顺序执行，
而verilog的for内的语句实际是并行的，
只是为了写代码方便才用for对多个同样的结构赋值。
当相同结构的赋值语句较多时，使用for语句能够简化代码，并不会影响实际综合后的电路结构。
*/

// （1）generate for的循环变量必须用genvar声明，for的变量可以用reg、integer整数等多种类型声明；
// （2）for只能用在always块里面，generate for可以做assign赋值，用always块话always写在generate for里；
// （3）generate for后面必须给这个循环起一个名字，for不需要；
// （4）generate for还可以用于例化模块；
module generated(
    input [7:0] data_in,
    input [7:0] data_out
);
genvar  i;
generate
    for(i = 0; i<8; i = i+ 1)begin:reverse
        assign data_out[i] = data_in[7-i];
    end
endgenerate
endmodule