module mux4_1(
    input wire [1:0]d0,
    input wire [1:0]d1,
    input wire [1:0]d2,
    input wire [1:0]d3,
    input wire [1:0]sel,
    output reg [1:0]mux_out;
);
    always @(*) begin
        case(sel)
            2'b00: mux_out = d3;
            2'b01: mux_out = d2;
            2'b10: mux_out = d1;
            2'b11: mux_out = d0;
            default: mux_out = 2'b00;
        endcase
    end

endmodule
