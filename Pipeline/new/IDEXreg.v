module IDEXreg(
    input clk,
    input rst_n,
    input Lu_pipeline_stop,
    input Cr_pipeline_stop,
    input id_have_inst, 
    input wire [3:0] ID_alu_op,
    input wire ID_alub_sel,
    input wire [1:0] ID_branch_sel,
    input wire [31:0] ID_rD1,
    input wire [31:0] ID_rD2,
    input wire [31:0] ID_imm_ISUB,
    input wire [31:0] ID_imm_J,
    input wire [1:0] ID_npc_op,
    input wire ID_branch,
    input wire [31:0] ID_pc4,  
    input wire [31:0] ID_PC,    
    input wire ID_rf_we,
    input wire [1:0] ID_wd_sel,
    input wire ID_dram_we,
    input wire [4:0] ID_wR,
    
    output reg [3:0] EX_alu_op,
    output reg EX_alub_sel,
    output reg [1:0] EX_branch_sel,
    output reg [31:0] EX_rD1,
    output reg [31:0] EX_rD2,
    output reg [31:0] EX_imm_ISUB,
    output reg [31:0] EX_imm_J,
    output reg [1:0] EX_npc_op,
    output reg EX_branch,
    output reg [31:0] EX_pc4,  
    output reg [31:0] EX_PC,
    output reg EX_rf_we,
    output reg [1:0] EX_wd_sel,
    output reg EX_dram_we,
    output reg [4:0] EX_wR,
    output reg ex_have_inst
);

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  ex_have_inst <= 0;
    else        ex_have_inst <= id_have_inst;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_alu_op <= 0;
    else        EX_alu_op <= ID_alu_op;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_alub_sel <= 0;
    else        EX_alub_sel <= ID_alub_sel;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_branch_sel <= 0;
    else        EX_branch_sel <= ID_branch_sel;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_rD1 <= 32'h0;
    else        EX_rD1 <= ID_rD1;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_rD2 <= 0;
    else        EX_rD2 <= ID_rD2;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_imm_ISUB <= 0;
    else        EX_imm_ISUB <= ID_imm_ISUB;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_imm_J <= 0;
    else        EX_imm_J <= ID_imm_J;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_npc_op <= 0;
    else        EX_npc_op <= ID_npc_op;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_branch <= 0;
    else        EX_branch <= ID_branch;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_pc4 <= 0;
    else        EX_pc4 <= ID_pc4;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_PC <= 0;
    else        EX_PC <= ID_PC;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_rf_we <= 0;
    else        EX_rf_we <= ID_rf_we;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_wd_sel <= 0;
    else        EX_wd_sel <= ID_wd_sel;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_dram_we <= 0;
    else        EX_dram_we <= ID_dram_we;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Lu_pipeline_stop | Cr_pipeline_stop)  EX_wR <= 0;
    else        EX_wR <= ID_wR;
end

endmodule