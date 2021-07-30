module RegFile(
    input wire clk,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire [31:0] wD,
    input wire WE,  //Ð´Ê¹ÄÜ
    input   risk_con1, 
    input   risk_con2,
    input   [31:0]risk_rd1,
    input   [31:0]risk_rd2,
    output wire [31:0] rD1,
    output wire [31:0] rD2
    );
    reg [31:0] regfile [0:31];
    //assign rD1 = regfile[rR1];
    //assign rD2 = regfile[rR2];
    initial begin
        regfile[0] = 32'd0;
        regfile[1] = 32'd0;
        regfile[2] = 32'd0;
        regfile[3] = 32'd0;
        regfile[4] = 32'd0;
        regfile[5] = 32'd0;
        regfile[6] = 32'd0;
        regfile[7] = 32'd0;
        regfile[8] = 32'd0;
        regfile[9] = 32'd0;
        regfile[10] = 32'd0;
        regfile[11] = 32'd0;
        regfile[12] = 32'd0;
        regfile[13] = 32'd0;
        regfile[14] = 32'd0;
        regfile[15] = 32'd0;
        regfile[16] = 32'd0;
        regfile[17] = 32'd0;
        regfile[18] = 32'd0;
        regfile[19] = 32'd0;
        regfile[20] = 32'd0;
        regfile[21] = 32'd0;
        regfile[22] = 32'd0;
        regfile[23] = 32'd0;
        regfile[24] = 32'd0;
        regfile[25] = 32'd0;
        regfile[26] = 32'd0;
        regfile[27] = 32'd0;
        regfile[28] = 32'd0;
        regfile[29] = 32'd0;
        regfile[30] = 32'd0;
        regfile[31] = 32'd0;
    end
    assign  rD1 = (risk_con1 == 1)? risk_rd1:regfile[rR1];
    assign  rD2 = (risk_con2 == 1)? risk_rd2:regfile[rR2];
    always@(posedge clk)begin
        if(WE)begin
            if(wR == 0)
                regfile[0] <= 32'd0;
            else
                regfile[wR] <= wD;
        end
        else
            regfile[0] <= 32'd0;
    end
        
endmodule
