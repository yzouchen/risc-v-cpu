module wD_sel_module(
    input wire [1:0] wd_sel,
    input wire [31:0] pc4,
    input wire [31:0] ALUC,
    input wire [31:0] DRAMrd,
    output reg [31:0] wD
);
    //wD select
    //reg [31:0] wD;
    always@(*)begin
        if(wd_sel == 0)begin
            wD <= ALUC;
        end else if(wd_sel == 1)begin
            wD <= DRAMrd;
        end else if(wd_sel == 2)begin
            wD <= pc4;
        end 
    end

endmodule