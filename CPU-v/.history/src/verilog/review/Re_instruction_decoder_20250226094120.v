module instruction_decoder(
    input en,
    input wire [31:0] instruction_code,
    output invalid_instruction,
    output [47:0] inst_flags,
    output wire [4:0] rd, rs1, rs2,
    output [6:0] imm_2531,//R-type
    output wire[19:0] imm_1231,//U-type
    output [11:0] imm_2032//I-type

);

endmodule