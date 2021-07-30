module NPC(
    input wire [31:0] imm_ISUB,
    input wire [31:0] imm_J,
    input wire [31:0] RA,
    input wire [1:0] npc_op,
    input wire branch,
    input wire ALU_branch,
    input wire [31:0] pc4,  
    input wire [31:0] PC,
    output reg [31:0] npc
    );
    wire branch_Final = branch && ALU_branch;
    
    //npc_op == 00   npc = pc+4
    //npc_op == 01   npc = ((rs1) + sext(offset)ISUB) & ~1
    //npc_op == 10 && branch valid  npc = (pc) + sext(offset)ISUB
    //npc_op == 11   npc = Imm_J
    always@(*)begin
        if(npc_op ==2'b01)begin
            npc = (RA + imm_ISUB) & ~1;
        end else if(npc_op == 2'b10 && branch_Final)begin
            npc = PC + imm_ISUB;
        end else if(npc_op == 2'b11)begin
            npc = PC + imm_J;
        end else begin
            npc = pc4 ;
        end
    end
endmodule
