module generted2(
    input [7:0]data_in,
    input [7:0]data_out
);

genvar i;
generate
    begin:bit_reversed
        for(i = 0; i <8; i = i+ 1)begin
            assign data_out[i] = data_in[7-i];
        end

    end
endgenerate
endmodule