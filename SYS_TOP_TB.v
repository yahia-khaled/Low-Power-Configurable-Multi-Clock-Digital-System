`timescale 1ns/1ps
module SYS_TB();

//////////////////////////////// parameters //////////////////////////////////

localparam REF_CLK_Period = 10;
localparam UART_CLK_Period = 271.267;
localparam DATA_WIDTH = 8;

localparam RF_Wr_CMD = 8'b10101010;
localparam RF_Rd_CMD = 8'b10111011;
localparam ALU_OPER_W_OP_CMD = 8'b11001100;
localparam ALU_OPER_W_NOP_CMD = 8'b11011101;




//////////////////////////////// Test bench Signals //////////////////////////////////
reg                                             REF_CLK_tb;
reg                                             UART_CLK_tb;
reg                                             RST_tb;
reg                                             RX_IN_tb;
reg                                             PAR_TYPE;
reg                                             PAR_EN;
reg                     [5:0]                   DIV_RATIO_UART_TX;
reg                     [5:0]                   Prescale_UART_RX;
reg                                             sample;
wire                                            TX_OUT_tb;
wire                                            stop_error_tb;
wire                                            parity_error_tb;
wire                                            BUSY_tb;

reg                     [10:0]                  TEMP;

/*
reg     [7:0]   RF_Wr_CMD;
reg     [7:0]   RF_Rd_CMD;
reg     [7:0]   ALU_OPER_W_OP_CMD ;
reg     [7:0]   ALU_OPER_W_NOP_CMD ;
*/
//////////////////////////////// initial block //////////////////////////////////

initial begin
    $dumpfile("SYS_TOP.vcd");
    $dumpvars;

    inititalization();
    Reset();

//////////////////////////////// Write configuration //////////////////////////////////
    Register_File_Write(8'b10000001 , 2);
    Register_File_Write(32 , 3);

//////////////////////////////// Write Command //////////////////////////////////

    Register_File_Write(8'b11010010 , 5);


//////////////////////////////// Read Command //////////////////////////////////
    Register_File_Read(5);
    Receive_data_UART_TX(TEMP);

    if (TEMP == 'b11110100100) begin
        $display("Test case is success");
    end
    else begin
        $display("Test case is failed");
    end
    

//////////////////////////////// ALU Add operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10101101,8'b10000001 , 4'b0000);

    Check_Output(8'b10101101,8'b10000001 , 4'b0000);
//////////////////////////////// ALU subtract operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10101101,8'b10000001 , 4'b0001);

    Check_Output(8'b10101101,8'b10000001 , 4'b0001);
    

//////////////////////////////// ALU multiplication operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10101101,8'b00000010 , 4'b0010);
    
    Check_Output(8'b10101101,8'b00000010 , 4'b0010);

//////////////////////////////// ALU divide operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10101101,8'b00000100 , 4'b0011);

    Check_Output(8'b10101101,8'b00000100 , 4'b0011);

//////////////////////////////// ALU AND operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b00101111,8'b10001111 , 4'b0100);
    
    Check_Output(8'b00101111,8'b10001111 , 4'b0100);


//////////////////////////////// ALU OR operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b00101101,8'b10000001 , 4'b0101);
    
    Check_Output(8'b00101101,8'b10000001 , 4'b0101);

//////////////////////////////// ALU NAND operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b00101101,8'b10001111 , 4'b0110);
    
    Check_Output(8'b00101101,8'b10001111 , 4'b0110);

//////////////////////////////// ALU NOR operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b00101101,8'b10001111 , 4'b0111);
    
    Check_Output(8'b00101101,8'b10001111 , 4'b0111);


//////////////////////////////// ALU NOP operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b10001111 , 4'b1000);
    
    Check_Output(8'b10001111,8'b10001111 , 4'b1000);

//////////////////////////////// ALU CMP operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b10001111 , 4'b1001);
    
    Check_Output(8'b10001111,8'b10001111 , 4'b1001);
    
//////////////////////////////// ALU Greater than operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111  , 4'b1010);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1010);

//////////////////////////////// ALU Lower than operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111 , 4'b1011);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1011);


//////////////////////////////// ALU shift A right operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111 , 4'b1100);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1100);


//////////////////////////////// ALU shift A left operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111, 4'b1101);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1101);


//////////////////////////////// ALU shift B right operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111 , 4'b1110);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1110);


//////////////////////////////// ALU shift B left operation with operand //////////////////////////////////

    ALU_Operation_command_with_operand(8'b10001111,8'b00001111 , 4'b1111);
    
    Check_Output(8'b10001111,8'b00001111 , 4'b1111);



//////////////////////////////// ALU operation without operand //////////////////////////////////

    ALU_Operation_command_with_No_operand(4'b0000);
    
    Check_Output(8'b10001111,8'b00001111, 4'b0000);



    #(100 * UART_CLK_Period)

    $stop;

end


//////////////////////////////// Reset task //////////////////////////////////
task Reset;
    begin
        RST_tb = 1;
        #(REF_CLK_Period/4)
        RST_tb = 0;
        #(REF_CLK_Period/2)
        RST_tb = 1;
    end
endtask //Reset

//////////////////////////////// inititalization task //////////////////////////////////
task inititalization;
    begin
        REF_CLK_tb = 0;
        UART_CLK_tb = 0;
        RX_IN_tb = 1;
        PAR_TYPE = 0;
        PAR_EN = 1;
        DIV_RATIO_UART_TX = 32;
        Prescale_UART_RX = 32;
        sample = 0;
    end
endtask //inititalization



//////////////////////////////// send data  //////////////////////////////////
task send_data;
input                       [DATA_WIDTH-1:0]        DATA_IN;
reg                         [3:0]                   Frame_Length;
integer i;
    begin

        if (PAR_EN) begin
            Frame_Length = 11;
        end
        else begin
            Frame_Length = 10;
        end

        for (i = 0 ; i < Frame_Length ;i = i + 1 ) begin
            if (i == 0) begin
                RX_IN_tb = 0;
            end
            else if (i == 9) begin
                if (PAR_EN) begin
                    if (PAR_TYPE) begin
                        RX_IN_tb = ^ DATA_IN;
                    end
                    else begin
                        RX_IN_tb = ~^ DATA_IN;
                    end
                end
                else begin
                   RX_IN_tb = 1; 
                end
            end
            else if (i == 10) begin
                RX_IN_tb = 1;
            end
            else begin
                RX_IN_tb = DATA_IN[i-1];
            end
            #(UART_CLK_Period * Prescale_UART_RX);
        end

        RX_IN_tb = 1;
    end
endtask //send_data

////////////////////////////////  Register File Write command //////////////////////////////////
task  Register_File_Write;
input                                [DATA_WIDTH-1:0]            DATA;
input                                [3:0]                       Address_WR;
    begin
        send_data(RF_Wr_CMD);
        send_data(Address_WR);
        send_data(DATA);
    end   
endtask // Register_File_Write

////////////////////////////////  Register File Read command //////////////////////////////////
task Register_File_Read;
input                                [3:0]                       Address_RD;          
    begin
        send_data(RF_Rd_CMD);
        send_data(Address_RD);
    end
endtask //Register_File_Read


//////////////////////////////// Receive ALU OUT //////////////////////////////////

task Receive_ALU_OUT;
output                      [15:0]                      ALU_OUT_DATA;
reg                         [21:0]                      total_frame;
    begin
        Receive_data_UART_TX(total_frame[10:0]);
        Receive_data_UART_TX(total_frame[21:11]);
        //$display("total frame %b" , total_frame);
        //$display("ALU output data is : %b ",{total_frame[19:12] , total_frame[8:1]});
        ALU_OUT_DATA = {total_frame[19:12] , total_frame[8:1]};
    end
endtask //Receive_ALU_OUT


//////////////////////////////// Check Output Received //////////////////////////////////
task Check_Output;
input                   [7:0]               operand_A;
input                   [7:0]               operand_B;
input                   [3:0]               ALU_Function;
reg                     [15:0]              ALU_output;
reg                     [15:0]              result;

    begin
        
        Receive_ALU_OUT(ALU_output);
        
    case (ALU_Function) 
    4'b0000:
    begin
      result = operand_A + operand_B;
      $display("A + B operation");
    end 
    4'b0001:
    begin
      result = operand_A - operand_B;
      $display("A - B operation");
    end
    4'b0010:
    begin
      result = operand_A * operand_B;
      $display("A * B operation");
    end
    4'b0011:
    begin
      result = operand_A / operand_B;
      $display("A / B operation");
    end
    4'b0100:
    begin
        result = operand_A & operand_B;
      $display("A & B operation");

    end
    4'b0101:
    begin
        result = operand_A | operand_B;
      $display("A | B operation");
    end
    4'b0110:
    begin
        result = ~(operand_A & operand_B);
      $display("A ~& B operation");
    end  
    4'b0111:
    begin
        result = ~(operand_A | operand_B);
      $display("A ~| B operation");

    end
    4'b1000:
    begin
        result = 0;
      $display("NOP operation");

    end
    4'b1001:
    begin
      $display("A == B operation");
        if (operand_A == operand_B) begin
            result = 1;
        end
        else begin
            result = 0;
        end
    end
    4'b1010:
    begin
      $display("A > B operation");
        if (operand_A > operand_B) begin
            result = 2;
        end
        else begin
            result = 0;
        end
    end  
    4'b1011:
    begin
        $display("A < B operation");
        if (operand_A < operand_B) begin
            result = 3;
        end
        else begin
            result = 0;
        end
    end
    4'b1100:
    begin
        $display("A >> 1 operation");
        result = operand_A >> 1;
    end
    4'b1101:
    begin
        $display("A << 1 operation");
        result = operand_A << 1;
    end
    4'b1110:
    begin
        $display("B >> 1 operation");
        result =  operand_B >> 1;
    end  
    4'b1111:
    begin
        $display("B << 1 operation");
        result =  operand_B << 1;
    end
    endcase
    $display("operand A : %b",operand_A);
    $display("operand B : %b" , operand_B);
    if (ALU_output == result) begin
        $display("ALU output : %b" , ALU_output);
        $display("Test Case is success");
    end
    else begin
        $display("ALU output : %b" , ALU_output);
        $display("Test Case is failed");
    end

    end

endtask //Check_Output

////////////////////////////////  Receive Data from UART_TX //////////////////////////////////
task Receive_data_UART_TX;
output                          [10:0]                  output_Received_Frame;
reg                             [3:0]                   Frame_Length;
reg                             [10:0]                  Received_Frame;
integer k;
    begin
        if (PAR_EN) begin
            Frame_Length = 11;
        end
        else begin
            Frame_Length = 10;
        end
        @(negedge TX_OUT_tb)
        #(UART_CLK_Period * DIV_RATIO_UART_TX)
        sample = 1;
        Received_Frame[0] = TX_OUT_tb;
        for (k = 1;k < Frame_Length ; k = k + 1) begin
            #(UART_CLK_Period * DIV_RATIO_UART_TX)
            Received_Frame[k] = TX_OUT_tb;
        end
        sample = 0;
        output_Received_Frame = Received_Frame;
        //@(posedge TX_OUT_tb)
        //display_data_frame(Received_Frame);
    end
endtask //automatic


//////////////////////////////// Display data of frame ////////////////////////////////
task display_data_frame;
input                                                [10:0]                  Frame;
    begin
        $display("Frame data is : %b" , Frame);
    end
endtask //display_data_frame




//////////////////////////////// ALU Operation command with operand ////////////////////////////////

task ALU_Operation_command_with_operand;
input                   [DATA_WIDTH-1:0]            OP_A;
input                   [DATA_WIDTH-1:0]            OP_B;
input                   [3:0]                       ALU_function;
    begin
        send_data(ALU_OPER_W_OP_CMD);
        send_data(OP_A);
        send_data(OP_B);
        send_data(ALU_function);
    end

endtask //ALU Operationcommand_with_operand


//////////////////////////////// ALU Operation command with No operand ////////////////////////////////
task ALU_Operation_command_with_No_operand;
input               [3:0]                   ALU_function;    
    begin
        send_data(ALU_OPER_W_NOP_CMD);
        send_data(ALU_function);
    end
endtask //ALU_Operation_command_with_No_operand

//////////////////////////////// DUT instantiation //////////////////////////////////

SYS_TOP #(.DATA_WIDTH(DATA_WIDTH)) DUT (
    .RX_IN(RX_IN_tb),
    .REF_CLK(REF_CLK_tb),
    .RST(RST_tb),
    .UART_CLK(UART_CLK_tb),
    .TX_OUT(TX_OUT_tb),
    .stp_err_UART_RX(stop_error_tb),
    .par_err_UART_RX(parity_error_tb),
    .BUST_TOP(BUSY_tb)
);

//////////////////////////////// Clock generation //////////////////////////////////
always          #(REF_CLK_Period/2.0)               REF_CLK_tb = ~ REF_CLK_tb;

always          #(UART_CLK_Period/2.0)              UART_CLK_tb = ~ UART_CLK_tb;

endmodule //SYS_TOP_TB
