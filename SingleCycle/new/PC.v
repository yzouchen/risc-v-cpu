module PC(
    input wire clk,
    input wire rst_n,
    input wire [31:0] npc,
    output wire [31:0] pc4,
    output reg [31:0] PC
);
    reg flag;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 0 || flag == 1)
            PC <= 32'h0000_0000;
        else
            PC <= npc;
    end
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 0)
            flag <= 1;
        else
            flag <= 0;
    end
    
    assign pc4 = PC + 4;
endmodule