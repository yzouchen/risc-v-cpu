module EXMEMreg(
    input clk,
    input rst_n,
    
    input wire EX_rf_we,
    input wire [1:0] EX_wd_sel,
    input wire EX_dram_we,
    input wire [31:0] EX_ALUC,
    input wire [31:0] EX_rD2,
    input wire [31:0] EX_pc4,
    input wire [4:0] EX_wR,
    input ex_have_inst,
    input [31:0] EX_PC,
    output reg [31:0] MEM_PC,
    output reg mem_have_inst,
    output reg MEM_rf_we,
    output reg [1:0] MEM_wd_sel,
    output reg MEM_dram_we,
    output reg [31:0] MEM_ALUC,
    output reg [31:0] MEM_rD2,
    output reg [31:0] MEM_pc4,
    output reg [4:0] MEM_wR
);

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_rf_we <= 1'h0;
    else        MEM_rf_we <= EX_rf_we;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_wd_sel <= 2'h0;
    else        MEM_wd_sel <= EX_wd_sel;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_dram_we <= 1'h0;
    else        MEM_dram_we <= EX_dram_we;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_ALUC <= 32'h0;
    else        MEM_ALUC <= EX_ALUC;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_rD2 <= 32'h0;
    else        MEM_rD2 <= EX_rD2;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_pc4 <= 32'h0;
    else        MEM_pc4 <= EX_pc4;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_wR <= 5'h0;
    else        MEM_wR <= EX_wR;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  mem_have_inst <= 0;
    else        mem_have_inst <= ex_have_inst;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  MEM_PC <= 0;
    else        MEM_PC <= EX_PC;
end

endmodule