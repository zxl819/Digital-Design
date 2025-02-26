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
    reg inst_addi;
    reg inst_slti;
    reg inst_sltiu;
    reg inst_xori;
    reg inst_ori;
    reg inst_andi;
    reg inst_slli;
    reg inst_srli;
    reg inst_srai;
    reg inst_add;
    reg inst_sub;
    reg inst_sll;
    reg inst_slt;
    reg inst_sltu;
    reg inst_xor;
    reg inst_or;
    reg inst_and;
    reg inst_lb;
    reg inst_lh;
    reg inst_lw;
    reg inst_lbu;
    reg inst_lhu;
    reg inst_sb;
    reg inst_sh;
    reg inst_sw;
    reg inst_csrrw;
    reg inst_csrrs;
    reg inst_csrrc;
    reg inst_csrrwi;
    reg inst_csrrsi;
    reg inst_csrrci;
    reg inst_sret;
    reg inst_wfi;
    reg inst_mret;
    reg inst_ecall;
    reg inst_ebreak;
    reg inst_jalr;
    reg inst_jal;
    reg inst_auipc;
    reg inst_lui;
    reg inst_sra;
    reg inst_srl;

    wire [4:0] opcode;
    wire [2:0] funct3;  





    assign opcode = instruction_code[6:2];//最低两位都是11不需要管
    assign funct3 = instruction_code[14:12];
    assign imm25_31 = en? instruction_code[31:25]:7'b0;
    assign imm20_31 = en? instruction_code[31:20]:12'b0;
    assign imm12_31 = en? instruction_code[31:12]:19'b0;
    assign rd = en? instruction_code[11:7]:5'b0;
    assign rs1 = en? instruction_code[19:15]:5'b0;
    assign rs2 = en? instruction_code[24:20]:5'b0;

    assign inst_flags = {inst_bne,inst_bltu,inst_blt,inst_bgeu,inst_bge,inst_beq\
                        ,inst_addi,inst_slti,inst_sltiu,inst_xori,inst_ori,inst_andi,inst_slli,inst_srli,inst_srai\
                        ,inst_add,inst_sub,inst_sll,inst_slt,inst_sltu,inst_xor,inst_or,inst_and,inst_lb,inst_lh,inst_lw\
                        ,inst_lbu,inst_lhu,inst_sb,inst_sh,inst_sw,inst_csrrw,inst_csrrs,inst_csrrc,inst_csrrwi,inst_csrrsi\
                        ,inst_csrrci,inst_sret,inst_wfi,inst_mret,inst_ecall,inst_ebreak,inst_jalr,inst_jal,inst_auipc,inst_lui\
                        ,inst_sra,inst_srl};

    task  get_jmp_op;
        case(funct3)
            3'b000: inst_beq = 1;
            3'b001: inst_bne = 1;
            3'b100: inst_blt = 1;
            3'b101: inst_bge = 1;
            3'b110: inst_bltu = 1;
            3'b111: inst_bgeu = 1;
            default: begin
                invalid_instruction = 1;
            end
        endcase
    endtask
    
    task get_alu_op;
        case(funct3)
            3'b000: begin
                inst_add = instruction_code[30]? 1'b0:1'b1;
                inst_sub = instruction_code[30]? 1'b1:1'b0;
            end
            3'b001: inst_sll = 1'b1;
            3'b010: inst_slt = 1'b1;
            3'b011: inst_sltu = 1'b1;
            3'b100: inst_xor = 1'b1;
            3'b101: begin 
                inst_srl = instruction_code[30]? 1'b0:1'b1;
                inst_sra = instruction_code[30]? 1'b1:1'b0;
            end
            3'b110: inst_or = 1'b1;
            3'b111: inst_and = 1'b1;
            default: begin
                invalid_instruction = 1;
            end
        endcase
    endtask

    task get_alu1_op;
        case(funct3)
            3'b000: inst_addi = 1;
            3'b001: inst_slli = 1;
            3'b010: inst_slti = 1;
            3'b011: inst_sltiu = 1;
            3'b100: inst_xori = 1;
            3'b101: begin
                inst_srli = instruction_code[30]? 1'b0:1'b1;
                inst_srai = instruction_code[30]? 1'b1:1'b0;
            end
            3'b110: inst_ori = 1;
            3'b111: inst_andi = 1;
            default: begin
                inst_addi = 0;
                inst_slli = 0;
                inst_slti = 0;
                inst_sltiu = 0;
                inst_xori = 0;
                inst_srli = 0;
                inst_srai = 0;
                inst_ori = 0;
                inst_andi = 0;
            end
        endcase
    endtask

    task get_mem_load_op;
        case(funct3)
            3'b000: inst_lb = 1;
            3'b001: inst_lh = 1;
            3'b010: inst_lw = 1;
            3'b100: inst_lbu = 1;
            3'b101: inst_lhu = 1;
            default: begin
                inst_lb = 0;
                inst_lh = 0;
                inst_lw = 0;
                inst_lbu = 0;
                inst_lhu = 0;
            end
        endcase
    endtask

    task get_mem_store_op;
        case(funct3)
            3'b000: inst_sb = 1;
            3'b001: inst_sh = 1;
            3'b010: inst_sw = 1;
            default: begin
                inst_sb = 0;
                inst_sh = 0;
                inst_sw = 0;
            end
        endcase
    endtask

    task get_csr_op;
        case(funct3)
            3'b001: inst_csrrw = 1;
            3'b010: inst_csrrs = 1;
            3'b011: inst_csrrc = 1;
            3'b101: inst_csrrwi = 1;
            3'b110: inst_csrrsi = 1;
            3'b111: inst_csrrci = 1;
            default: begin
                inst_csrrw = 0;
                inst_csrrs = 0;
                inst_csrrc = 0;
                inst_csrrwi = 0;
                inst_csrrsi = 0;
                inst_csrrci = 0;
            end
        endcase
    endtask



    
    


endmodule