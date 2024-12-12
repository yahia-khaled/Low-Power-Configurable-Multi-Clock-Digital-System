module SHIFT_UNIT#(parameter WIDTH_A = 8 , WIDTH_B = 8 ,WIDTH_Shift_OUT = 16)
(
    input wire         [1:0]                        ALU_FUN,
    input wire         [WIDTH_A-1:0]                A,
    input wire         [WIDTH_B-1:0]                B,
    input wire                                      RST,
    input wire                                      CLK,
    input wire                                      Shift_Enable,
    output reg         [WIDTH_Shift_OUT-1:0]        Shift_OUT,
    output reg                                      Shift_Flag
);
    always @(posedge CLK or negedge RST) begin
        if(!RST)
        begin
          Shift_OUT <= 'b0;
        end
        else if (Shift_Enable)
        begin
            case (ALU_FUN)
                2'b00:
                begin
                    Shift_OUT <= A >>1;
                end
                2'b01:
                begin
                    Shift_OUT <= A <<1;
                end
                2'b10:
                begin
                    Shift_OUT <= B >>1;
                end
                2'b11:
                begin
                    Shift_OUT <= B <<1;
                end    
                 
            endcase
        end
        else
        begin
            Shift_OUT <= 'b0;
        end
    end

    always @(*) begin
        if(Shift_Enable)
        begin
            Shift_Flag = 1'b1;
        end
        else
        begin
            Shift_Flag = 1'b0;
        end
    end

endmodule //SHIFT _UNIT
