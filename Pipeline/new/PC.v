module PC(
    input   clk,
    input   rst_n,
    input   [31:0]npc,
    input   [1:0]npc_op,
    input   Lu_pipeline_stop,
    output  [31:0] pc4,
    output   reg[31:0]PC
    );
    reg flag;
     always @(posedge clk or negedge rst_n)begin//更新PC，在上升沿读取RF
        if(rst_n == 0 || flag == 1)
            PC <= 32'h0;
        else begin
            if(Lu_pipeline_stop)
                PC <= PC;
            else begin
                    PC <= npc;
            end
        end
     end
     always@(posedge clk or negedge rst_n)begin
        if(rst_n == 0)
            flag <= 1;
        else
            flag <= 0;
    end
     assign pc4 = PC + 4;
endmodule