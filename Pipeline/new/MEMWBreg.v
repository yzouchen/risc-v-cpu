module MEMWBreg(
    input clk,
    input rst_n,
    input wire  MEM_rf_we,
    input wire [31:0] MEM_DRAMrd,
    input wire [1:0] MEM_wd_sel,
    input wire [31:0] MEM_ALUC,
    input wire [31:0] MEM_pc4,
    input wire [4:0] MEM_wR,
    input mem_have_inst,
    input [31:0] MEM_PC,
    input [31:0] MEM_wD,
    output reg [31:0] WB_wD,
    output reg [31:0] WB_PC,
    output reg wb_have_inst,
    output reg  WB_rf_we,
    output reg [31:0] WB_DRAMrd,
    output reg [1:0] WB_wd_sel,
    output reg [31:0] WB_ALUC,
    output reg [31:0] WB_pc4,
    output reg [4:0] WB_wR
);

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_rf_we <= 1'h0;
    else        WB_rf_we <= MEM_rf_we;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_DRAMrd <= 32'h0;
    else        WB_DRAMrd <= MEM_DRAMrd;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_wd_sel <= 2'h0;
    else        WB_wd_sel <= MEM_wd_sel;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_ALUC <= 32'h0;
    else        WB_ALUC <= MEM_ALUC;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_pc4 <= 32'h0;
    else        WB_pc4 <= MEM_pc4;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_wR <= 5'h0;
    else        WB_wR <= MEM_wR;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  wb_have_inst <= 0;
    else        wb_have_inst <= mem_have_inst;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_PC <= 0;
    else        WB_PC <= MEM_PC;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)  WB_wD <= 0;
    else        WB_wD <= MEM_wD;
end

endmodule