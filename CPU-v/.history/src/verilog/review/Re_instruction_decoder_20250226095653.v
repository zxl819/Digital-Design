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

 	reg inst_beq;
    reg inst_bge;
    reg inst_bgeu;
    reg inst_blt;
    reg inst_bltu;
    reg inst_bne;


    assign opcode = instruction_code[6:2];//最低两位都是11不需要管
    assign funct3 = instruction_code[14:12];
    assign imm25_31 = en? instruction_code[31:25]:7'b0;
    assign imm20_31 = en? instruction_code[31:20]:12'b0;
    assign imm12_31 = en? instruction_code[31:12]:19'b0;
    assign rd = en? instruction_code[11:7]:5'b0;
    assign rs1 = en? instruction_code[19:15]:5'b0;
    assign rs2 = en? instruction_code[24:20]:5'b0;

    assign inst_flags = {inst_bne,inst_bltu,inst_blt,inst_bgeu,inst_bge,inst_beq};

    task  get_jmp_op;
        case(funct3)
            3'b000: inst_beq = 1;
            3'b001: inst_bne = 1;
            3'b100: inst_blt = 1;
            3'b101: inst_bge = 1;
            3'b110: inst_bltu = 1;
            3'b111: inst_bgeu = 1;
            default: begin
                inst_beq = 0;
                inst_bne = 0;
                inst_blt = 0;
                inst_bge = 0;
                inst_bltu = 0;
                inst_bgeu = 0;
            end
        endcase
    endtask


endmodule