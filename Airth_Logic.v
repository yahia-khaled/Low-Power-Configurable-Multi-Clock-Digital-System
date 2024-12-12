module ARITHMETIC_UNIT #(parameter WIDTH_A = 8 , WIDTH_B = 8 ,WIDTH_ALU_OUT = 16)
(
    input wire         [1:0]                        ALU_FUN,
    input wire         [WIDTH_A-1:0]                A,
    input wire         [WIDTH_B-1:0]                B,
    input wire                                      RST,
    input wire                                      CLK,
    input wire                                      Airth_Enable,
    output reg         [WIDTH_ALU_OUT-1:0]          Airth_OUT,
    output reg                                      Arith_Flag
);

always @(posedge CLK or negedge RST) begin
    if(!RST)
    begin
      Airth_OUT <= 'b0;
    end
    else if(Airth_Enable)
    begin
    
    case (ALU_FUN) 
    2'b00:
    begin
      Airth_OUT <= A + B;
    end 
    2'b01:
    begin
      Airth_OUT <= A - B;
    end
    2'b10:
    begin
      Airth_OUT <= A * B;
    end
    2'b11:
    begin
      Airth_OUT <= A / B;
    end
    endcase
    end
    else
    begin
      Airth_OUT <= 'b0;
    end

end

always @(*) begin
    if(Airth_Enable)
    begin
      Arith_Flag = 1'b1;
      /*
      if(Airth_OUT[WIDTH_A] == 1)
      begin
        Carry_OUT = 1'b1;
      end
      else
      begin
        Carry_OUT = 1'b0;
      end
      */
    end
    else
    begin
      Arith_Flag = 1'b0;
    end
end
endmodule //moduleName
