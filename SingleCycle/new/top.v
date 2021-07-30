
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/13 09:34:53
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    );
    
    wire [31:0] rD1;
    wire [31:0] rD2;
    wire [31:0] imm_ISUB;
    wire [31:0] imm_J;
    wire [1:0] npc_op;
    wire branch;
    wire ALU_branch;
    wire [31:0] Instruction;
    wire [31:0] pc4;
    wire rf_we;
    wire [1:0] wd_sel;
    wire [1:0] sext_op;
    wire [3:0] alu_op;
    wire alub_sel;
    wire dram_we;
    wire [1:0] branch_sel;
    wire [31:0] ALUC;
    wire [31:0] DRAMrd;
    wire [31:0] PC;
    //
    wire [31:0] npc;
    
    wire [31:0] wD;
    //debug
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc = PC;
    assign debug_wb_ena = rf_we;
    assign debug_wb_reg = Instruction[11:7];
    assign debug_wb_value = wD;
    
    // 64KB IROM
    prgrom U_prgrom(
    //inst_mem imem (
        .a      (PC[15:2]),   // input wire [13:0] a
        .spo    (Instruction)   // output wire [31:0] spo
    );
    
    PC U_PC(
        .clk(clk),
        .rst_n(rst_n),
        .npc(npc),
        .pc4(pc4),
        .PC(PC)
    );
    
    NPC U_NPC(
        .imm_ISUB(imm_ISUB),
        .imm_J(imm_J),
        .RA(rD1),
        .npc_op(npc_op),
        .branch(branch),
        .ALU_branch(ALU_branch),
        .pc4(pc4),
        .PC(PC),
        .npc(npc)
    );
    
    Imme U_Imme(
        .Inst(Instruction),
        .sext_op(sext_op),
        .imm_ISUB(imm_ISUB),
        .imm_J(imm_J)
    );
    
    RegFile U_RegFile(
        .clk(clk),
        .rR1(Instruction[19:15]),
        .rR2(Instruction[24:20]),
        .wR(Instruction[11:7]),
        .wD(wD),
        .WE(rf_we),
        .rD1(rD1),
        .rD2(rD2)
    );
    
    wD_sel_module U_wD_sel_module(
        .wd_sel(wd_sel),
        .pc4(pc4),
        .ALUC(ALUC),
        .DRAMrd(DRAMrd),
        .wD(wD)
    );
    
    ALU U_ALU(
        .alu_op(alu_op),
        .alub_sel(alub_sel),
        .branch_sel(branch_sel),
        .rD1(rD1),
        .rD2(rD2),
        .imm_ISUB(imm_ISUB),
        .ALUC(ALUC),
        .ALU_branch(ALU_branch)
    );
    
    dram U_dram(
    //data_mem dmem(
        .clk    (~clk),            // input wire clka
        .a      (ALUC[15:2]),     // input wire [13:0] addra
        .spo   (DRAMrd),        // output wire [31:0] douta        //qspo   --spo
        .we     (dram_we),          // input wire [0:0] wea
        .d      (rD2)         // input wire [31:0] dina
    );
    
    CU U_CU(
    .opcode(Instruction[6:0]),
    .funct3(Instruction[14:12]),
    .funct7(Instruction[31:25]),
    .npc_op(npc_op),
    .rf_we(rf_we),
    .wd_sel(wd_sel),
    .sext_op(sext_op),
    .alu_op(alu_op),
    .alub_sel(alub_sel),
    .branch(branch),
    .dram_we(dram_we),
    .branch_sel(branch_sel)
    );
    
endmodule
