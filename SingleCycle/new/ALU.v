module ALU(
    input wire [3:0] alu_op,
    input wire alub_sel,
    input wire [1:0] branch_sel,
    input wire [31:0] rD1,
    input wire [31:0] rD2,
    input wire [31:0] imm_ISUB,
    output reg [31:0] ALUC,
    output reg ALU_branch
    );
    wire [31:0] ALUB;
    wire [31:0] ALUA;
    assign ALUA = rD1;
    assign ALUB = alub_sel? imm_ISUB : rD2;
    wire [31:0] negALUB;
    assign negALUB = ALUB^32'hffffffff + 32'b1;
    reg [31:0] add_result;  //存储加减法结果
    reg [31:0] logic_result;    //存储逻辑运算结果
    reg [31:0] shift_result;    //存储移位运算结果
    
    always@(*)begin
        if(alu_op == 0) //add
            add_result = ALUA + ALUB;
        else            //sub
            add_result = ALUA - ALUB;
            //add_result = ALUA + negALUB;        
    end
    
    always@(*)begin
        if(alu_op == 2) //and
            logic_result = ALUA & ALUB;
        else if(alu_op == 3) //or
            logic_result = ALUA | ALUB;
        else if(alu_op == 4)    //xor
            logic_result = ALUA ^ ALUB;
    end
    
    always@(*)begin
        if(alu_op == 5)begin //sll
            case(ALUB[4:0])
                0:shift_result = ALUA;
                1:shift_result = {ALUA[30:0],1'b0};
                2:shift_result = {ALUA[29:0],2'b0};
                3:shift_result = {ALUA[28:0],3'b0};
                4:shift_result = {ALUA[27:0],4'b0};
                5:shift_result = {ALUA[26:0],5'b0};
                6:shift_result = {ALUA[25:0],6'b0};
                7:shift_result = {ALUA[24:0],7'b0};
                8:shift_result = {ALUA[23:0],8'b0};
                9:shift_result = {ALUA[22:0],9'b0};
                10:shift_result = {ALUA[21:0],10'b0};
                11:shift_result = {ALUA[20:0],11'b0};
                12:shift_result = {ALUA[19:0],12'b0};
                13:shift_result = {ALUA[18:0],13'b0};
                14:shift_result = {ALUA[17:0],14'b0};
                15:shift_result = {ALUA[16:0],15'b0};
                16:shift_result = {ALUA[15:0],16'b0};
                17:shift_result = {ALUA[14:0],17'b0};
                18:shift_result = {ALUA[13:0],18'b0};
                19:shift_result = {ALUA[12:0],19'b0};
                20:shift_result = {ALUA[11:0],20'b0};
                21:shift_result = {ALUA[10:0],21'b0};
                22:shift_result = {ALUA[9:0],22'b0};
                23:shift_result = {ALUA[8:0],23'b0};
                24:shift_result = {ALUA[7:0],24'b0};
                25:shift_result = {ALUA[6:0],25'b0};
                26:shift_result = {ALUA[5:0],26'b0};
                27:shift_result = {ALUA[4:0],27'b0};
                28:shift_result = {ALUA[3:0],28'b0};
                29:shift_result = {ALUA[2:0],29'b0};
                30:shift_result = {ALUA[1:0],30'b0};
                31:shift_result = {ALUA[0],31'b0};
                default:shift_result = ALUA;
            endcase
        end
        else if(alu_op == 6)begin //srl
            case(ALUB[4:0])
                0:shift_result = ALUA;
                1:shift_result = {1'b0,ALUA[31:1]};
                2:shift_result = {2'b0,ALUA[31:2]};
                3:shift_result = {3'b0,ALUA[31:3]};
                4:shift_result = {4'b0,ALUA[31:4]};
                5:shift_result = {5'b0,ALUA[31:5]};
                6:shift_result = {6'b0,ALUA[31:6]};
                7:shift_result = {7'b0,ALUA[31:7]};
                8:shift_result = {8'b0,ALUA[31:8]};
                9:shift_result = {9'b0,ALUA[31:9]};
                10:shift_result = {10'b0,ALUA[31:10]};
                11:shift_result = {11'b0,ALUA[31:11]};
                12:shift_result = {12'b0,ALUA[31:12]};
                13:shift_result = {13'b0,ALUA[31:13]};
                14:shift_result = {14'b0,ALUA[31:14]};
                15:shift_result = {15'b0,ALUA[31:15]};
                16:shift_result = {16'b0,ALUA[31:16]};
                17:shift_result = {17'b0,ALUA[31:17]};
                18:shift_result = {18'b0,ALUA[31:18]};
                19:shift_result = {19'b0,ALUA[31:19]};
                20:shift_result = {20'b0,ALUA[31:20]};
                21:shift_result = {21'b0,ALUA[31:21]};
                22:shift_result = {22'b0,ALUA[31:22]};
                23:shift_result = {23'b0,ALUA[31:23]};
                24:shift_result = {24'b0,ALUA[31:24]};
                25:shift_result = {25'b0,ALUA[31:25]};
                26:shift_result = {26'b0,ALUA[31:26]};
                27:shift_result = {27'b0,ALUA[31:27]};
                28:shift_result = {28'b0,ALUA[31:28]};
                29:shift_result = {29'b0,ALUA[31:29]};
                30:shift_result = {30'b0,ALUA[31:30]};
                31:shift_result = {31'b0,ALUA[31]};
                default:shift_result = ALUA;
            endcase
        end
        else if(alu_op == 7)begin //sra
            case(ALUA[31])
                'b0:
                    case(ALUB[4:0])
                        0:shift_result = ALUA;
                        1:shift_result = {1'b0,ALUA[31:1]};
                        2:shift_result = {2'b0,ALUA[31:2]};
                        3:shift_result = {3'b0,ALUA[31:3]};
                        4:shift_result = {4'b0,ALUA[31:4]};
                        5:shift_result = {5'b0,ALUA[31:5]};
                        6:shift_result = {6'b0,ALUA[31:6]};
                        7:shift_result = {7'b0,ALUA[31:7]};
                        8:shift_result = {8'b0,ALUA[31:8]};
                        9:shift_result = {9'b0,ALUA[31:9]};
                        10:shift_result = {10'b0,ALUA[31:10]};
                        11:shift_result = {11'b0,ALUA[31:11]};
                        12:shift_result = {12'b0,ALUA[31:12]};
                        13:shift_result = {13'b0,ALUA[31:13]};
                        14:shift_result = {14'b0,ALUA[31:14]};
                        15:shift_result = {15'b0,ALUA[31:15]};
                        16:shift_result = {16'b0,ALUA[31:16]};
                        17:shift_result = {17'b0,ALUA[31:17]};
                        18:shift_result = {18'b0,ALUA[31:18]};
                        19:shift_result = {19'b0,ALUA[31:19]};
                        20:shift_result = {20'b0,ALUA[31:20]};
                        21:shift_result = {21'b0,ALUA[31:21]};
                        22:shift_result = {22'b0,ALUA[31:22]};
                        23:shift_result = {23'b0,ALUA[31:23]};
                        24:shift_result = {24'b0,ALUA[31:24]};
                        25:shift_result = {25'b0,ALUA[31:25]};
                        26:shift_result = {26'b0,ALUA[31:26]};
                        27:shift_result = {27'b0,ALUA[31:27]};
                        28:shift_result = {28'b0,ALUA[31:28]};
                        29:shift_result = {29'b0,ALUA[31:29]};
                        30:shift_result = {30'b0,ALUA[31:30]};
                        31:shift_result = {31'b0,ALUA[31]};
                        default:shift_result = ALUA;
                    endcase
                'b1:
                    case(ALUB[4:0])
                        0:shift_result = ALUA;
                        1:shift_result = {1'b1,ALUA[31:1]};
                        2:shift_result = {2'b11,ALUA[31:2]};
                        3:shift_result = {3'b111,ALUA[31:3]};
                        4:shift_result = {4'b1111,ALUA[31:4]};
                        5:shift_result = {5'b11111,ALUA[31:5]};
                        6:shift_result = {6'b111111,ALUA[31:6]};
                        7:shift_result = {7'b1111111,ALUA[31:7]};
                        8:shift_result = {8'b11111111,ALUA[31:8]};
                        9:shift_result = {9'b111111111,ALUA[31:9]};
                        10:shift_result = {10'b1111111111,ALUA[31:10]};
                        11:shift_result = {11'b11111111111,ALUA[31:11]};
                        12:shift_result = {12'b111111111111,ALUA[31:12]};
                        13:shift_result = {13'b1111111111111,ALUA[31:13]};
                        14:shift_result = {14'b11111111111111,ALUA[31:14]};
                        15:shift_result = {15'b111111111111111,ALUA[31:15]};
                        16:shift_result = {16'b1111111111111111,ALUA[31:16]};
                        17:shift_result = {17'b11111111111111111,ALUA[31:17]};
                        18:shift_result = {18'b111111111111111111,ALUA[31:18]};
                        19:shift_result = {19'b1111111111111111111,ALUA[31:19]};
                        20:shift_result = {20'b11111111111111111111,ALUA[31:20]};
                        21:shift_result = {21'b111111111111111111111,ALUA[31:21]};
                        22:shift_result = {22'b1111111111111111111111,ALUA[31:22]};
                        23:shift_result = {23'b11111111111111111111111,ALUA[31:23]};
                        24:shift_result = {24'b111111111111111111111111,ALUA[31:24]};
                        25:shift_result = {25'b1111111111111111111111111,ALUA[31:25]};
                        26:shift_result = {26'b11111111111111111111111111,ALUA[31:26]};
                        27:shift_result = {27'b111111111111111111111111111,ALUA[31:27]};
                        28:shift_result = {28'b1111111111111111111111111111,ALUA[31:28]};
                        29:shift_result = {29'b11111111111111111111111111111,ALUA[31:29]};
                        30:shift_result = {30'b111111111111111111111111111111,ALUA[31:30]};
                        31:shift_result = {31'b1111111111111111111111111111111,ALUA[31]};
                        default:shift_result = ALUA;
                    endcase
            endcase
        end
    end
    
    always@(*)begin
        case(alu_op)
            0:ALUC = add_result;
            1:ALUC = add_result;
            2:ALUC = logic_result;
            3:ALUC = logic_result;
            4:ALUC = logic_result;
            5:ALUC = shift_result;
            6:ALUC = shift_result;
            7:ALUC = shift_result;
            8:ALUC = imm_ISUB;
        endcase
    end
    
    always@(*)begin     //ALU_branch
        if(branch_sel == 0 && add_result == 0)   //beq
            ALU_branch = 1;
        else if(branch_sel == 1 && add_result != 0) //bne
            ALU_branch = 1;
        else if(branch_sel == 2 && add_result[31] == 1)  //blt
            ALU_branch = 1;
        else if(branch_sel == 3 && add_result[31] == 0)  //bge
            ALU_branch = 1;
        else 
            ALU_branch = 0;
    end
    
endmodule
