module function_mod(
    input [3:0]a,
    input [3:0]b,

    output [3:0]c,
    output [3:0]d
);
assign c = data_rev(a);
assign d = data_rev(b);
function [3:0]data_rev;
input [3:0]data_in;
begin
    data_rev[0] = data_in[3];
    data_rev[1] = data_in[2];
    data_rev[2] = data_in[1];
    data_rev[3] = data_in[0];
end
endfunction
endmodule