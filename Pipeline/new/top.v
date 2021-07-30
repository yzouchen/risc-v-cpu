module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    );
    
    //wire [31:0] rD1;
    wire [31:0] ID_rD1;
    wire [31:0] EX_rD1;
    
    //wire [31:0] rD2;
    wire [31:0] ID_rD2;
    wire [31:0] EX_rD2;
    wire [31:0] MEM_rD2;
    
    //wire [31:0] imm_ISUB;
    wire [31:0] ID_imm_ISUB;
    wire [31:0] EX_imm_ISUB;
    
    //wire [31:0] imm_J;
    wire [31:0] ID_imm_J;
    wire [31:0] EX_imm_J;
    
    //wire [1:0] npc_op;
    wire [1:0] ID_npc_op;
    wire [1:0] EX_npc_op;
    
    //wire branch;
    wire ID_branch;
    wire EX_branch;
    
    wire ALU_branch;
    //wire [31:0] Instruction;
    wire [31:0] IF_Instruction;
    wire [31:0] ID_Instruction;
    wire [31:0] EX_Instruction;
    wire [31:0] MEM_Instruction;
    
    //wire [31:0] pc4;
    wire [31:0] IF_pc4;
    wire [31:0] ID_pc4;
    wire [31:0] EX_pc4;
    wire [31:0] MEM_pc4;
    wire [31:0] WB_pc4;
    
    //wire rf_we;
    wire ID_rf_we;
    wire EX_rf_we;
    wire MEM_rf_we;
    wire WB_rf_we;
    
    //wire [1:0] wd_sel;
    wire [1:0] ID_wd_sel;
    wire [1:0] EX_wd_sel;
    wire [1:0] MEM_wd_sel;
    wire [1:0] WB_wd_sel;
    
    wire [1:0] sext_op;
    //wire [3:0] alu_op;
    wire [3:0] ID_alu_op;
    wire [3:0] EX_alu_op;
    //wire alub_sel;
    wire ID_alub_sel;
    wire EX_alub_sel;
    
    //wire dram_we;
    wire ID_dram_we;
    wire EX_dram_we;
    wire MEM_dram_we;
    
    //wire [1:0] branch_sel;
    wire [1:0] ID_branch_sel;
    wire [1:0] EX_branch_sel;
    
    //wire [31:0] ALUC;
    wire [31:0] EX_ALUC;
    wire [31:0] MEM_ALUC;
    wire [31:0] WB_ALUC;
    
    //wire [31:0] DRAMrd;
    wire [31:0] MEM_DRAMrd;
    wire [31:0] WB_DRAMrd;
    
    //wire [31:0] PC;
    wire [31:0] IF_PC;
    wire [31:0] ID_PC;
    wire [31:0] EX_PC;
    wire [31:0] MEM_PC;
    wire [31:0] WB_PC;
    
    wire [31:0] npc; 
    wire [31:0] wD;
    wire [4:0] EX_wR;
    wire [4:0] MEM_wR;
    wire [4:0] WB_wR;
    //debug
    assign debug_wb_have_inst = wb_have_inst;
    assign debug_wb_pc = WB_PC;
    assign debug_wb_ena = WB_rf_we;
    assign debug_wb_reg = WB_wR;
    assign debug_wb_value = wD;
    
    wire Lu_pipeline_stop;
    wire Cr_pipeline_stop;
    wire risk_con1;
    wire risk_con2;
    wire [31:0]risk_rd1;
    wire [31:0]risk_rd2;
    wire if_have_inst;
    wire id_have_inst;
    wire ex_have_inst;
    wire mem_have_inst;
    wire wb_have_inst;
    assign if_have_inst = 1'b1;
    
    wire [31:0] MEM_wD;
    wire [31:0] WB_wD;
    // 64KB IROM
    prgrom U_prgrom(
    //inst_mem imem (
        .a      (IF_PC[15:2]),   // input wire [13:0] a
        .spo    (IF_Instruction)   // output wire [31:0] spo
    );
    
    PC U_PC(
        .clk(clk),
        .rst_n(rst_n),
        .npc(npc),
        .npc_op(EX_npc_op),
        .Lu_pipeline_stop(Lu_pipeline_stop),
        .pc4(IF_pc4),
        .PC(IF_PC)
    );
    
    NPC U_NPC(
        .imm_ISUB(EX_imm_ISUB),
        .imm_J(EX_imm_J),
        .RA(EX_rD1),
        .npc_op(EX_npc_op),
        .branch(EX_branch),
        .ALU_branch(ALU_branch),
        .if_pc(IF_PC),
        .ex_pc(EX_PC),
        .npc(npc)
    );
    
    Imme U_Imme(
        .Inst(ID_Instruction),
        .sext_op(sext_op),
        .imm_ISUB(ID_imm_ISUB),
        .imm_J(ID_imm_J)
    );
    
    RegFile U_RegFile(
        .clk(clk),
        .rR1(ID_Instruction[19:15]),
        .rR2(ID_Instruction[24:20]),
        .wR(WB_wR),
        .wD(wD),
        .WE(WB_rf_we),
        .risk_con1(risk_con1),
        .risk_con2(risk_con2),
        .risk_rd1(risk_rd1),
        .risk_rd2(risk_rd2),
        .rD1(ID_rD1),
        .rD2(ID_rD2)
    );
    
    wD_sel_module U_wD_sel_module(
        .wd_sel(WB_wd_sel),
        .pc4(WB_pc4),
        .ALUC(WB_ALUC),
        .DRAMrd(WB_DRAMrd),
        .wD(wD)
    );/*
    wD_sel_module U_wD_sel_module(
        .wd_sel(MEM_wd_sel),
        .pc4(MEM_pc4),
        .ALUC(MEM_ALUC),
        .DRAMrd(MEM_DRAMrd),
        .wD(MEM_wD)
    );*/
    
    ALU U_ALU(
        .alu_op(EX_alu_op),
        .alub_sel(EX_alub_sel),
        .branch_sel(EX_branch_sel),
        .rD1(EX_rD1),
        .rD2(EX_rD2),
        .imm_ISUB(EX_imm_ISUB),
        .ALUC(EX_ALUC),
        .ALU_branch(ALU_branch)
    );
    
    dram U_dram(
    //data_mem dmem(
        .clk    (~clk),            // input wire clka
        .a      (MEM_ALUC[15:2]),     // input wire [13:0] addra
        .spo   (MEM_DRAMrd),        // output wire [31:0] douta        //qspo   --spo
        .we     (MEM_dram_we),          // input wire [0:0] wea
        .d      (MEM_rD2)         // input wire [31:0] dina
    );
    
    CU U_CU(
    .opcode(ID_Instruction[6:0]),
    .funct3(ID_Instruction[14:12]),
    .funct7(ID_Instruction[31:25]),
    .npc_op(ID_npc_op),
    .rf_we(ID_rf_we),
    .wd_sel(ID_wd_sel),
    .sext_op(sext_op),
    .alu_op(ID_alu_op),
    .alub_sel(ID_alub_sel),
    .branch(ID_branch),
    .dram_we(ID_dram_we),
    .branch_sel(ID_branch_sel)
    );
    
    IFIDreg U_IFIDreg(
        .clk(clk),
        .rst_n(rst_n),
        .Lu_pipeline_stop(Lu_pipeline_stop),
        .Cr_pipeline_stop(Cr_pipeline_stop),
        .IF_pc4(IF_pc4),
        .IF_Instruction(IF_Instruction),
        .IF_PC(IF_PC),
        .ID_pc4(ID_pc4),
        .ID_Instruction(ID_Instruction),
        .ID_PC(ID_PC),
        .if_have_inst(if_have_inst),
        .id_have_inst(id_have_inst)
    );
    
    IDEXreg U_IDEXreg(
        .clk(clk),
        .rst_n(rst_n),
        .Lu_pipeline_stop(Lu_pipeline_stop),
        .Cr_pipeline_stop(Cr_pipeline_stop),
        .id_have_inst(id_have_inst),
        .ex_have_inst(ex_have_inst),
        .ID_pc4(ID_pc4),
        .EX_pc4(EX_pc4),
        .ID_PC(ID_PC),
        .EX_PC(EX_PC),
        .ID_alu_op(ID_alu_op),
        .EX_alu_op(EX_alu_op),
        .ID_alub_sel(ID_alub_sel),
        .EX_alub_sel(EX_alub_sel),
        .ID_branch_sel(ID_branch_sel),
        .EX_branch_sel(EX_branch_sel),
        .ID_rD1(ID_rD1),
        .EX_rD1(EX_rD1),
        .ID_rD2(ID_rD2),
        .EX_rD2(EX_rD2),
        .ID_imm_ISUB(ID_imm_ISUB),
        .EX_imm_ISUB(EX_imm_ISUB),
        .ID_imm_J(ID_imm_J),
        .EX_imm_J(EX_imm_J),
        .ID_npc_op(ID_npc_op),
        .EX_npc_op(EX_npc_op),
        .ID_branch(ID_branch),
        .EX_branch(EX_branch),
        .ID_rf_we(ID_rf_we),
        .EX_rf_we(EX_rf_we),
        .ID_wd_sel(ID_wd_sel),
        .EX_wd_sel(EX_wd_sel),
        .ID_dram_we(ID_dram_we),
        .EX_dram_we(EX_dram_we),
        .ID_wR(ID_Instruction[11:7]),
        .EX_wR(EX_wR)
    );
    
    
    EXMEMreg U_EXMEMreg(
        .clk(clk),
        .rst_n(rst_n),
        .EX_rf_we(EX_rf_we),
        .MEM_rf_we(MEM_rf_we),
        .EX_wd_sel(EX_wd_sel),
        .MEM_wd_sel(MEM_wd_sel),
        .EX_dram_we(EX_dram_we),
        .MEM_dram_we(MEM_dram_we),
        .EX_ALUC(EX_ALUC),
        .MEM_ALUC(MEM_ALUC),
        .EX_rD2(EX_rD2),
        .MEM_rD2(MEM_rD2),
        .EX_pc4(EX_pc4),
        .MEM_pc4(MEM_pc4),
        .EX_wR(EX_wR),
        .MEM_wR(MEM_wR),
        .ex_have_inst(ex_have_inst),
        .mem_have_inst(mem_have_inst),
        .EX_PC(EX_PC),
        .MEM_PC(MEM_PC)
    );



    
    MEMWBreg U_MEMWBreg(
        .clk(clk),
        .rst_n(rst_n),
        .MEM_rf_we(MEM_rf_we),
        .WB_rf_we(WB_rf_we),
        .MEM_DRAMrd(MEM_DRAMrd),
        .WB_DRAMrd(WB_DRAMrd),
        .MEM_wd_sel(MEM_wd_sel),
        .WB_wd_sel(WB_wd_sel),
        .MEM_ALUC(MEM_ALUC),
        .WB_ALUC(WB_ALUC),
        .MEM_pc4(MEM_pc4),
        .WB_pc4(WB_pc4),
        .MEM_wR(MEM_wR),
        .WB_wR(WB_wR),
        .mem_have_inst(mem_have_inst),
        .wb_have_inst(wb_have_inst),
        .MEM_wD(MEM_wD),
        .WB_wD(WB_wD),
        .MEM_PC(MEM_PC),
        .WB_PC(WB_PC)
    );

    Data_risk_check U_Data_risk_check(
    .clk(clk),
    .MEM_rf_we(MEM_rf_we), 
    .WB_rf_we(WB_rf_we),
    .EX_rf_we(EX_rf_we),
    .id_rs1(ID_Instruction[19:15]),
    .id_rs2(ID_Instruction[24:20]),
    .EX_wR(EX_wR),//A情况,ex冒险的寄存器号
    .MEM_wR(MEM_wR),//B情况,mem冒险的寄存器号
    .WB_wR(WB_wR),//C情况 wb冒险的寄存器号,以上三种情况使用前递解决问题。
    .EX_ALUC(EX_ALUC),//ex冒险的寄存器值,alu_C，ext
    .EX_imm_ISUB(EX_imm_ISUB),
    .EX_wd_sel(EX_wd_sel),
    .MEM_DRAMrd(MEM_DRAMrd),//mem冒险的寄存器值,dram的mem_wd
    .WB_DRAMrd(WB_DRAMrd),
    .MEM_ALUC(MEM_ALUC),
    .wD(wD),//wb冒险的寄存器值，是wb_wd
    .id_op(ID_Instruction[6:0]),
    .MEM_wd_sel(MEM_wd_sel),
    .risk_con1(risk_con1),
    .risk_con2(risk_con2),
    .risk_rd1(risk_rd1),
    .risk_rd2(risk_rd2),
    .Lu_pipeline_stop(Lu_pipeline_stop)
    );

    Control_risk_check U_Control_risk_check(//Cr_pipeline_stop为1，写回PC，清空IF/ID和ID/EX寄存器，
        .EX_npc_op(EX_npc_op),
        .EX_branch(EX_branch),
        .ALU_branch(ALU_branch),
        .Cr_pipeline_stop(Cr_pipeline_stop)
    );
    
    

endmodule
