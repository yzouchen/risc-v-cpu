module NPC(
    input wire [31:0] imm_ISUB,
    input wire [31:0] imm_J,
    input wire [31:0] RA,
    input wire [1:0] npc_op,
    input wire branch,
    input wire ALU_branch,
    input wire [31:0] if_pc,  
    input wire [31:0] ex_pc,
    output reg [31:0] npc
    );
    wire branch_Final = branch && ALU_branch;
        
    always @(*)begin
        case(npc_op)
        0:npc = if_pc + 4;
        1:npc = (RA + imm_ISUB)&32'hFFFFFFFE;
        2:begin
            if(branch_Final)
                npc = ex_pc+imm_ISUB;
            else
                npc = if_pc+4;
        end
        3:npc = ex_pc+imm_J;
        default: npc = 0;
        endcase            
    end
endmodule


