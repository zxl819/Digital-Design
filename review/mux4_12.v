module mux4_12(
    input wire sel,
    input [1:0] d1,d2,d3,d0,
    output reg[1:0] mux_out
);
always @(*)begin
    case(sel)
    2'b00:begin
         mux_out <= d3;
    end
    2'b01:begin
         mux_out <= d2;
    end
    2'b10:begin
         mux_out <= d1;
    end
    2'b11:begin
         mux_out <= d0;
    end
    default:begin
        mux_out <= 2'b00;
    end
    endcase
end

endmodule