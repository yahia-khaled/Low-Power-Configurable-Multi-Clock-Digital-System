module CMP_UNIT#(parameter WIDTH_A = 8 , WIDTH_B = 8 ,WIDTH_CMP_OUT = 16)
(
    input wire         [1:0]                        ALU_FUN,
    input wire         [WIDTH_A-1:0]                A,
    input wire         [WIDTH_B-1:0]                B,
    input wire                                      RST,
    input wire                                      CLK,
    input wire                                      CMP_Enable,
    output reg         [WIDTH_CMP_OUT-1:0]          CMP_OUT,
    output reg                                      CMP_Flag
);

    always @(posedge CLK or negedge RST) begin
        if(!RST)
        begin
          CMP_OUT <= 'b0;
        end
        else if(CMP_Enable)
        begin
          case (ALU_FUN)
            2'b00:
            begin
              CMP_OUT <= 0;
            end 
            2'b01:
            begin
              if(A == B)
              begin
                CMP_OUT <= 'b1;
              end 
              else
              begin
                CMP_OUT <= 'b0;
              end  
            end
            2'b10:
            begin
              if(A > B)
              begin
                CMP_OUT <= 'b10;
              end 
              else
              begin
                CMP_OUT <= 'b0;
              end  
            end
            2'b11:
            begin
              if(A < B)
              begin
                CMP_OUT <= 'b11;
              end 
              else
              begin
                CMP_OUT <= 'b0;
              end  
            end
             
          endcase
        end
        else
        begin
          CMP_OUT <= 'b0;
        end
    end

    always @(*) begin
        if(CMP_Enable)
        begin
          CMP_Flag = 1'b1;
        end
        else
        begin
          CMP_Flag = 1'b0;
        end
    end
endmodule //CMP_UNIT
