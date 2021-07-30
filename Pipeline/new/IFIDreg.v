module IFIDreg(
    input clk,
    input rst_n,
    input Lu_pipeline_stop,
    input Cr_pipeline_stop,
    input [31:0] IF_pc4,
    input [31:0] IF_Instruction,
    input [31:0] IF_PC,
    input if_have_inst,
    output reg id_have_inst,
    output reg [31:0] ID_pc4,
    output reg [31:0] ID_Instruction,
    output reg [31:0] ID_PC
);
always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Cr_pipeline_stop)  ID_pc4 <= 32'h0;
    else if(Lu_pipeline_stop)   ID_pc4 <= ID_pc4;
    else        ID_pc4 <= IF_pc4;
end
always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Cr_pipeline_stop)  ID_Instruction <= 32'h0;
    else if(Lu_pipeline_stop)   ID_Instruction <= ID_Instruction;
    else        ID_Instruction <= IF_Instruction;
end
always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Cr_pipeline_stop)  ID_PC <= 32'h0;
    else if(Lu_pipeline_stop)   ID_PC <= ID_PC;
    else        ID_PC <= IF_PC;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n | Cr_pipeline_stop)  id_have_inst <= 0;
    else if(Lu_pipeline_stop)   id_have_inst <= id_have_inst;
    else        id_have_inst <= if_have_inst;
end      

endmodule