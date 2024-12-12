module SYS_CTRL #(parameter ALU_OUT_WIDTH = 16 , RdData_WIDTH = 8 , ALU_FUN_WIDTH = 4 , Address_bits = 4 , WrData_WIDTH = 8) (
    input           wire                [ALU_OUT_WIDTH-1:0]                 ALU_OUT,
    input           wire                                                    CLK,
    input           wire                                                    RST,
    input           wire                                                    OUT_Valid,
    input           wire                                                    RdData_Valid,
    input           wire                [RdData_WIDTH-1:0]                  RdData,
    input           wire                [7:0]                               RX_P_DATA,
    input           wire                                                    RX_D_VLD,
    input           wire                                                    FIFO_FULL,
    output          reg                 [ALU_FUN_WIDTH-1:0]                 ALU_FUN,
    output          reg                                                     EN,
    output          reg                                                     CLK_EN,
    output          reg                 [Address_bits-1:0]                  Address,
    output          reg                                                     WrEn,
    output          reg                                                     RdEn,
    output          reg                 [WrData_WIDTH-1:0]                  WrData,
    output          reg                 [7:0]                               TX_P_DATA,
    output          reg                                                     W_INC,
    output          reg                                                     clk_div_en

);



reg                         TX_D_VLD;


//////////////////////////////// FSM Gray Encoding //////////////////////////////////

localparam IDLE                                  = 4'b0000;
localparam OPERAND_A_state                       = 4'b0001;
localparam OPERAND_B_state                       = 4'b0011;
localparam RF_Wr_Addr_state                      = 4'b0010;
localparam RF_Wr_Data_state                      = 4'b0110;
localparam RF_Rd_Addr_state                      = 4'b0111;
localparam ALU_FUN_state                         = 4'b0101;
localparam send_ALU_output_least_state           = 4'b0100;
localparam send_ALU_output_most_state            = 4'b1100;
localparam receive_data_reg_file_state           = 4'b1110;


//////////////////////////////// commands encoding ////////////////////////////////

localparam RF_Wr_CMD            = 8'b10101010;
localparam RF_Rd_CMD            = 8'b10111011;
localparam ALU_OPER_W_OP_CMD    = 8'b11001100;
localparam ALU_OPER_W_NOP_CMD   = 8'b11011101;



//////////////////////////////// define current and next state varaible //////////////////////////////////
reg                 [3:0]                   current_state;
reg                 [3:0]                   next_state;
reg                 [3:0]                   Address_V;
reg                                         Address_Enable;

//////////////////////////// FSM sequential  //////////////////////////////


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
       current_state <= IDLE; 
    end
    else begin
        current_state <= next_state;
    end
end

//////////////////////////// FSM combinational  //////////////////////////////

always @(*) begin
    ALU_FUN = 0;
    EN = 0;
    CLK_EN = 0;
    Address = 0;
    Address_Enable = 0;
    WrEn = 0;
    RdEn = 0;
    WrData = 0;
    W_INC = 0;
    TX_P_DATA = 0;
    clk_div_en = 1;
    case (current_state)
        IDLE:
        begin
            Address = 0;
            if (RX_D_VLD) begin
                
                case (RX_P_DATA)
                    RF_Wr_CMD:
                    begin
                        next_state = RF_Wr_Addr_state;
                        CLK_EN = 0;
                    end
                    RF_Rd_CMD:
                    begin
                        next_state = RF_Rd_Addr_state;
                        CLK_EN = 0;
                    end
                    ALU_OPER_W_OP_CMD:
                    begin
                        next_state = OPERAND_A_state;
                        CLK_EN = 0;
                    end
                    ALU_OPER_W_NOP_CMD:
                    begin
                        CLK_EN = 1;
                        next_state = ALU_FUN_state;
                    end 
                    default:
                    begin
                        next_state = IDLE;
                        CLK_EN = 0;
                    end 
                endcase
            end
            else begin
                next_state = IDLE;
                CLK_EN = 0;
            end     
        end
        OPERAND_A_state:
        begin
            if (RX_D_VLD) begin
                Address = 0;
                WrData = RX_P_DATA;
                WrEn = 1;
                next_state = OPERAND_B_state;
            end
            else begin
                Address = 0;
                WrData = 0;
                WrEn = 0;
                next_state = OPERAND_A_state;
            end
        end 
        OPERAND_B_state:
        begin
            CLK_EN = 1;
            if (RX_D_VLD) begin
                Address = 1;
                WrData = RX_P_DATA;
                WrEn = 1;
                next_state = ALU_FUN_state;
            end
            else begin
                Address = 0;
                WrData = 0;
                WrEn = 0;
                next_state = OPERAND_B_state;
            end
        end 
        RF_Wr_Addr_state:
        begin
            if (RX_D_VLD) begin
                Address_Enable = 1;
                Address = RX_P_DATA[Address_bits-1:0];
                next_state = RF_Wr_Data_state;
            end
            else begin
                Address = 0;
                next_state = RF_Wr_Addr_state;
            end
        end
        RF_Wr_Data_state:
        begin
            Address = Address_V;
            if (RX_D_VLD) begin
                WrData = RX_P_DATA;
                WrEn = 1;
                next_state = IDLE;
            end
            else begin
                WrData = 0;
                WrEn = 0;
                next_state = RF_Wr_Data_state;
            end
        end
        RF_Rd_Addr_state:
        begin
            if (RX_D_VLD) begin
                Address_Enable = 1;
                Address = RX_P_DATA[Address_bits-1:0];
                RdEn = 1;
                next_state = receive_data_reg_file_state;
            end
            else begin
               Address = 0;
               RdEn = 0;
               next_state =  RF_Rd_Addr_state;
            end
        end
        ALU_FUN_state:
        begin
            CLK_EN = 1;
            EN = 1;
            if (RX_D_VLD) begin
                ALU_FUN = RX_P_DATA[ALU_FUN_WIDTH-1:0];
                next_state = send_ALU_output_least_state;
            end
            else begin
                ALU_FUN = RX_P_DATA[ALU_FUN_WIDTH-1:0];
                next_state = ALU_FUN_state;
            end
        end
        send_ALU_output_least_state:
        begin
            ALU_FUN = RX_P_DATA[ALU_FUN_WIDTH-1:0];
            CLK_EN = 1;
            EN = 1;
            if (OUT_Valid && !FIFO_FULL) begin
                TX_P_DATA = ALU_OUT[7:0];
                W_INC = 1;
                next_state = send_ALU_output_most_state;
            end
            else begin
                TX_P_DATA = ALU_OUT[7:0];
                W_INC = 1;
                next_state = send_ALU_output_least_state;
            end
        end
        send_ALU_output_most_state:
        begin
            ALU_FUN = RX_P_DATA[ALU_FUN_WIDTH-1:0];
            CLK_EN = 1;
            EN = 1;
            TX_P_DATA = ALU_OUT[15:8];
            W_INC = 1;
            next_state = IDLE;
        end
        receive_data_reg_file_state:
        begin
                Address = Address_V;
                TX_P_DATA = RdData;
                W_INC = 1;
                next_state = IDLE;
        end      
        default:
        begin
            next_state = IDLE;
        end 
    endcase
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        Address_V <= 0;
    end
    else if (Address_Enable) begin
        Address_V <= Address;
    end
    else begin
        Address_V <= Address_V;
    end
end

endmodule // SYS_CTRL   
