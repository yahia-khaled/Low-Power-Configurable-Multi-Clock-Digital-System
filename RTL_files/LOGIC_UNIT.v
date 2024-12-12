module LOGIC_UNIT#(parameter WIDTH_A = 8 , WIDTH_B = 8 ,WIDTH_Logic_OUT = 16)
(
    input wire         [1:0]                        ALU_FUN,
    input wire         [WIDTH_A-1:0]                A,
    input wire         [WIDTH_B-1:0]                B,
    input wire                                      RST,
    input wire                                      CLK,
    input wire                                      Logic_Enable,
    output reg         [WIDTH_Logic_OUT-1:0]        Logic_OUT,
    output reg                                      Logic_Flag
);
    
    always @(posedge CLK or negedge RST) begin
        if(!RST)
        begin
          Logic_OUT <= 'b0;
        end
        else if(Logic_Enable)
        begin
            case (ALU_FUN)
                2'b00:
                begin
                    Logic_OUT <= A & B;
                end
                2'b01:
                begin
                    Logic_OUT <= A | B;
                end
                2'b10:
                begin
                    Logic_OUT <= ~(A & B);
                end  
                2'b11:
                begin
                    Logic_OUT <= ~(A | B);
                end
            endcase
        end
        else
        begin
            Logic_OUT <= 'b0;
        end
    end

always @(*) begin
    if(Logic_Enable)
    begin
        Logic_Flag = 1'b1;
    end
    else
    begin
        Logic_Flag = 1'b0;
    end
end    
endmodule //LOGIC_UNIT

