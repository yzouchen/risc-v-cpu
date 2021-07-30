module RegFile(
    input wire clk,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire [31:0] wD,
    input wire WE,  //Ð´Ê¹ÄÜ
    output wire [31:0] rD1,
    output wire [31:0] rD2
    );
    reg [31:0] regfile [0:31];
    assign rD1 = regfile[rR1];
    assign rD2 = regfile[rR2];
    
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
