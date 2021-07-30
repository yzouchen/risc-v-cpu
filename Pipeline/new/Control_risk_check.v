module Control_risk_check(//Cr_pipeline_stop为1，写回PC，清空IF/ID和ID/EX寄存器，
        input [1:0]EX_npc_op,//
        input   EX_branch,//
        input   ALU_branch,//
        output  reg Cr_pipeline_stop
    );
    always @(*)begin
        case(EX_npc_op)
        0:Cr_pipeline_stop = 0;
        1:Cr_pipeline_stop = 1;
        2:
        begin
            if(EX_branch & ALU_branch)
                Cr_pipeline_stop = 1;
            else
                Cr_pipeline_stop = 0;
        end
        3:Cr_pipeline_stop = 1;
        default:Cr_pipeline_stop = 0;
        endcase
    end
    
endmodule
