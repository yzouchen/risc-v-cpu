module Imme(
    input wire [31:0] Inst,
    input wire [1:0] sext_op,
    output reg [31:0] imm_ISUB,
    output wire [31:0] imm_J
);
    //imm select
    wire [31:0] imm_I;
    wire [31:0] imm_S;
    wire [31:0] imm_U;
    wire [31:0] imm_B;
    assign imm_I = (Inst[31] == 1)? {20'b11111111111111111111,Inst[31:20]}:{20'd0,Inst[31:20]};
    assign imm_S = (Inst[31] == 1)? {20'b11111111111111111111,Inst[31:25],Inst[11:7]}:{20'd0,Inst[31:25],Inst[11:7]};
    assign imm_B = (Inst[31] == 1)? {19'b1111111111111111111,Inst[31],Inst[7],Inst[30:25],Inst[11:8],1'b0}:{19'd0,Inst[31],Inst[7],Inst[30:25],Inst[11:8],1'b0};
    assign imm_U = {Inst[31:12],12'd0};
    assign imm_J = (Inst[31] == 1)? {11'b11111111111,Inst[31],Inst[19:12],Inst[20],Inst[30:21],1'b0}:{11'd0,Inst[31],Inst[19:12],Inst[20],Inst[30:21],1'b0};
    always@(*)begin
        if(sext_op == 0)begin
            imm_ISUB <= imm_I;
        end else if(sext_op == 1)begin
            imm_ISUB <= imm_S;
        end else if(sext_op == 2)begin
            imm_ISUB <= imm_B;
        end else if(sext_op == 3)begin
            imm_ISUB <= imm_U;
        end
    end
endmodule