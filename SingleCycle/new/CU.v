module CU(
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [1:0] npc_op,
    output reg rf_we,
    output reg [1:0] wd_sel,
    output reg [1:0] sext_op,
    output reg [3:0] alu_op,
    output reg alub_sel,
    output reg branch,
    output reg dram_we,
    output reg [1:0] branch_sel
    );
    //npc_op
    always@(*)begin
        if(opcode == 7'b1100111)
            npc_op = 2'b01;
        else if(opcode == 7'b1100011)
            npc_op = 2'b10;
        else if(opcode == 7'b1101111)
            npc_op = 2'b11;
        else
            npc_op = 2'b00;
    end
    //rf_we
    always@(*)begin
        if(opcode == 7'b0100011 || opcode == 7'b1100011)
            rf_we = 1'b0;
        else
            rf_we = 1'b1;
    end
    //wd_sel
    always@(*)begin
        if(opcode == 7'b0000011)
            wd_sel = 2'b01;
        else if(opcode == 7'b1100111 || opcode == 7'b1101111)
            wd_sel = 2'b10;
        else 
            wd_sel = 2'b00;
    end
    //sext_op
    always@(*)begin
        if(opcode == 7'b0100011)
            sext_op = 1;
        else if(opcode ==7'b1100011)
            sext_op = 2;
        else if(opcode ==7'b0110111)
            sext_op = 3;
        else
            sext_op = 0;
    end
    //alu_op
    always@(*)begin
        if((opcode==7'b0110011 && funct3==3'd0 && funct7==7'b0100000) || (opcode == 7'b1100011))
            alu_op = 4'd1; //sub
        else if((opcode==7'b0110011 && funct3==3'b111 && funct7==7'd0) || (opcode==7'b0010011 && funct3==3'b111))
            alu_op = 4'd2; //and
        else if((opcode==7'b0110011 && funct3==3'b110 && funct7==7'd0) || (opcode==7'b0010011 && funct3==3'b110))
            alu_op = 4'd3; //or
        else if((opcode==7'b0110011 && funct3==3'b100 && funct7==7'd0) || (opcode==7'b0010011 && funct3==3'b100))
            alu_op = 4'd4; //xor
        else if((opcode==7'b0110011||opcode==7'b0010011) && funct3==3'b001 && funct7==7'd0)
            alu_op = 4'd5; //sll
        else if((opcode==7'b0110011||opcode==7'b0010011) && funct3==3'b101 && funct7==7'd0)
            alu_op = 4'd6; //srl
        else if((opcode==7'b0110011||opcode==7'b0010011) && funct3==3'b101 && funct7==7'b0100000)
            alu_op = 4'd7; //sra
        else if(opcode == 7'b0110111)
            alu_op = 4'd8;
        else
            alu_op = 4'd0; //add
    end
    //alub_sel
    always@(*)begin
        if(opcode==7'b0110011 || opcode==7'b1100011 || opcode==7'b0110111 || opcode==7'b1101111)
            alub_sel = 0;
        else 
            alub_sel = 1;
    end
    //branch
    always@(*)begin
        if(opcode == 7'b1100011)
            branch = 1;
        else
            branch = 0;
    end
    //dram_we
    always@(*)begin
        if(opcode == 7'b0100011)
            dram_we = 1;
        else
            dram_we = 0;
    end
    //branch_sel
    always@(*)begin
        if(opcode == 7'b1100011)begin
            case(funct3)
                3'b000:branch_sel = 2'b00;
                3'b001:branch_sel = 2'b01;
                3'b100:branch_sel = 2'b10;
                3'b101:branch_sel = 2'b11;
            endcase
        end
    end
endmodule
