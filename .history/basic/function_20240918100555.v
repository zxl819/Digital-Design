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
    
end
endfunction
endmodule