`define CLEAR_ALL_OUTPINS \
    invalid_instruction = 1'b0; \
    inst_beq = 1'b0; \
    inst_bge = 1'b0; \
    inst_bgeu = 1'b0; \
    inst_blt = 1'b0; \
    inst_bltu = 1'b0; \
    inst_bne = 1'b0; \
    inst_addi = 1'b0; \
    inst_andi = 1'b0; \
    inst_csrrc = 1'b0; \
    inst_csrrci = 1'b0; \
    inst_csrrs = 1'b0; \
    inst_csrrsi = 1'b0; \
    inst_csrrw = 1'b0; \
    inst_csrrwi = 1'b0; \
    inst_ebreak = 1'b0; \
    inst_ecall = 1'b0; \
    inst_jalr = 1'b0; \
    inst_lb = 1'b0; \
    inst_lbu = 1'b0; \
    inst_lh = 1'b0; \
    inst_lhu = 1'b0; \
    inst_lw = 1'b0; \
    inst_ori = 1'b0; \
    inst_slli = 1'b0; \
    inst_slti = 1'b0; \
    inst_sltiu = 1'b0; \
    inst_srai = 1'b0; \
    inst_srli = 1'b0; \
    inst_xori = 1'b0; \
    inst_jal = 1'b0; \
    inst_add = 1'b0; \
    inst_and = 1'b0; \
    inst_mret = 1'b0; \
    inst_or = 1'b0; \
    inst_sll = 1'b0; \
    inst_slt = 1'b0; \
    inst_sltu = 1'b0; \
    inst_sra = 1'b0; \
    inst_sret = 1'b0; \
    inst_srl = 1'b0; \
    inst_sub = 1'b0; \
    inst_wfi = 1'b0; \
    inst_xor = 1'b0; \
    inst_sb = 1'b0; \
    inst_sh = 1'b0; \
    inst_sw = 1'b0; \
    inst_auipc = 1'b0; \
    inst_lui = 1'b0; 

module instruction_decoder(
    input en,
    input wire [31:0] instruction_code,
    output wire [4:0] rd, rs1, rs2,
    output reg invalid_instruction,
    output [47:0] inst_flags

    // output [6:0] imm_2531,//R-type
    // output wire[19:0] imm_1231,//U-type
    // output [11:0] imm_2032//I-type
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
    // assign imm25_31 = en? instruction_code[31:25]:7'b0;
    // assign imm20_31 = en? instruction_code[31:20]:12'b0;
    assign imm12_31 = en? instruction_code[31:12]:19'b0;
    assign rd = en? instruction_code[11:7]:5'b0;
    assign rs1 = en? instruction_code[19:15]:5'b0;
    assign rs2 = en? instruction_code[24:20]:5'b0;

   assign inst_flags = {inst_wfi,inst_sret,inst_mret,inst_ecall,inst_ebreak,inst_csrrwi,inst_csrrw,inst_csrrsi,inst_csrrs,inst_csrrci,inst_csrrc,inst_sw,inst_sh,inst_sb,inst_lw,inst_lhu,inst_lh,inst_lbu,inst_lb,inst_lui,inst_xor,inst_sub,inst_srl,inst_sra,inst_sltu,inst_slt,inst_sll,inst_or,inst_and,inst_add,inst_xori,inst_srli,inst_srai,inst_sltiu,inst_slti,inst_slli,inst_ori,inst_andi,inst_addi,inst_auipc,inst_jal,inst_jalr,inst_bne,inst_bltu,inst_blt,inst_bgeu,inst_bge,inst_beq};

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
                invalid_instruction = 1;
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
                invalid_instruction = (instruction_code == 32'd0)? 1'd0:1'd1;
            end
        endcase
    endtask

    task get_mem_store_op;
        case(funct3)
            3'b000: inst_sb = 1;
            3'b001: inst_sh = 1;
            3'b010: inst_sw = 1;
            default: begin
                invalid_instruction = 1;
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
                invalid_instruction = 1;
            end
        endcase
    endtask

    task get_mechine_op;
        case(instruction_code)
          32'h10200073: inst_sret = 1'b1;
          32'h10500073: inst_wfi = 1'b1;
            32'h30200073: inst_mret = 1'b1;
            32'h100073: inst_ecall = 1'b1;
            32'h73: inst_ecall = 1'b1;
            default: begin
                invalid_instruction = 1;
            end
        endcase
    endtask

    always @(*) begin
        if (en) begin
            `CLEAR_ALL_OUTPINS;
            if(instruction_code[1:0] != 2'b11) begin
                invalid_instruction = (instruction_code == 32'd0)? 1'd0:1'd1;
            end
        else begin
        case(opcode)
        5'b11000: begin
            get_jmp_op();
        end
        5'b11011: begin
            inst_jal = 1;
        end
        5'b11001:begin
            if (funct3 == 3'b000) begin
                inst_jalr = 1;
            end
        end
        5'b00101:begin
            inst_auipc = 1'b1;
        end
        5'b01101:begin
            inst_lui = 1'b1;
        end
        5'b01100:begin
            get_alu_op();
        end
        5'b00100:begin
            get_alu1_op();
        end
        5'b00000:begin
            get_mem_load_op();
        end
        5'b01000:begin
            get_mem_store_op();
        end
        5'b11100:begin
            if (funct3 == 3'b000) begin
                get_mechine_op();
            end
            else begin
            get_csr_op();
            end
        end
        default: begin
            invalid_instruction = (instruction_code == 32'd0)? 1'd0:1'd1;
        end
        endcase
    end
end
else begin
    invalid_instruction = 1;
end
end

endmodule