/* verilator lint_off COMBDLY */
module Data_risk_check(
    input clk,
    input   MEM_rf_we, 
    input   WB_rf_we,
    input   EX_rf_we,
    input   [4:0]id_rs1,
    input   [4:0]id_rs2,
    input   [4:0] EX_wR,//A情况,ex冒险的寄存器号
    input   [4:0] MEM_wR,//B情况,mem冒险的寄存器号
    input   [4:0] WB_wR,//C情况 wb冒险的寄存器号,以上三种情况使用前递解决问题。
    input   [31:0]EX_ALUC,//ex冒险的寄存器值,alu_C，ext
    input   [31:0]EX_imm_ISUB,
    input   [1:0]EX_wd_sel,
    input   [31:0]MEM_DRAMrd,//mem冒险的寄存器值,dram的mem_wd
    input   [31:0]WB_DRAMrd,
    input   [31:0]MEM_ALUC,
    input   [31:0]wD,//wb冒险的寄存器值，是wb_wd
    input   [6:0]id_op,
    input   [1:0]MEM_wd_sel,
    output  reg risk_con1,
    output  reg risk_con2,
    output  reg [31:0]risk_rd1,
    output  reg [31:0]risk_rd2,
    output   Lu_pipeline_stop
    );
    reg re1;
    reg re2;
    wire [31:0]ex_data;

    assign ex_data = EX_wd_sel == 2'b11 ? EX_imm_ISUB:EX_ALUC; 
    assign Lu_pipeline_stop = ((id_rs1 == EX_wR|id_rs2 == EX_wR) & EX_rf_we & (EX_wR != 0) & re1 & EX_wd_sel ==2'b01 ); //载入使用停顿，停顿一时钟周期后就前递写回
    //always@(*)begin
    //Lu_pipeline_stop <= ((id_rs1 == EX_wR|id_rs2 == EX_wR) & EX_rf_we & (EX_wR != 0) & re1 & EX_wd_sel ==2'b01 );
    //end
    reg pre_Lu_pipeline_stop;
    reg pre_pre_Lu_pipeline_stop;
    always@(posedge clk)
        pre_Lu_pipeline_stop<=Lu_pipeline_stop;
    always@(posedge clk)
        pre_pre_Lu_pipeline_stop<=pre_Lu_pipeline_stop;
    
        always @(*)begin
        if(id_op == 7'b0110111 || id_op == 7'b1101111)begin
            re1 = 0;
            re2 = 0;
        end
        else if(id_op == 7'b0010011 || id_op == 7'b0000011 || id_op == 7'b1100111)begin
            re1 = 1;
            re2 = 0;
        end
        else begin
            re1 = 1;
            re2 = 1;
        end
    end
    
    always @(*)begin
        if(id_rs1 == EX_wR & EX_rf_we & (EX_wR != 0) & re1 & EX_wd_sel !=2'b01)begin//不是lw指令才是EX冒险
            risk_con1 = 1;
            risk_rd1 = /*pre_Lu_pipeline_stop? MEM_DRAMrd:*/ex_data;
        end 
        else if(id_rs1 == MEM_wR & MEM_rf_we & (MEM_wR != 0) & re1)begin//需无EX冒险才有MEM冒险
            risk_con1 = 1;
            risk_rd1 = (/*pre_Lu_pipeline_stop*/MEM_wd_sel==1)? MEM_DRAMrd:MEM_ALUC;
        end
        else if(id_rs1 == WB_wR & WB_rf_we & (WB_wR != 0) & re1)begin//需要没有EX冒险、MEM冒险才会有WB冒险
            risk_con1 = 1;
            risk_rd1 = /*pre_Lu_pipeline_stop? WB_DRAMrd:*/wD;
        end
        else begin
            risk_con1 = 0;
            risk_rd1 = 0;
        end
    end
    
    always @(*)begin
        if(id_rs2 == EX_wR & EX_rf_we & (EX_wR != 0) & re2 & EX_wd_sel !=2'b01)begin
            risk_con2 = 1;
            risk_rd2 = /*pre_Lu_pipeline_stop? MEM_DRAMrd:*/ex_data;
        end 
        else if(id_rs2 == MEM_wR & MEM_rf_we & (MEM_wR != 0) & re2)begin
            risk_con2 = 1;
            risk_rd2 = (/*pre_Lu_pipeline_stop*/MEM_wd_sel==1)? MEM_DRAMrd:MEM_ALUC;
        end
        else if(id_rs2 == WB_wR & WB_rf_we & (WB_wR != 0) & re2)begin
            risk_con2 = 1;
            risk_rd2 = /*pre_Lu_pipeline_stop? WB_DRAMrd:*/wD;
        end
        else begin
            risk_con2 = 0;
            risk_rd2 = 0;
        end

    end    
endmodule
