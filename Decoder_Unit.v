module Decoder_Unit(
    input       wire    [1:0]       ALU_FUN,
    input       wire                Enable_ALU,
    output      reg                 Airth_Enable,
    output      reg                 Logic_Enable,
    output      reg                 Shift_Enable,
    output      reg                 CMP_Enable

);

    always @(*) begin
        Airth_Enable = 1'b0;
        Logic_Enable = 1'b0;
        Shift_Enable = 1'b0;
        CMP_Enable   = 1'b0;
        if (Enable_ALU) begin
        case (ALU_FUN)
        2'b00:
        begin
          Airth_Enable = 1'b1;
        end
        2'b01:
        begin
          Logic_Enable = 1'b1;
        end
        2'b11:
        begin
          Shift_Enable = 1'b1;
        end 
        2'b10:
        begin
          CMP_Enable   = 1'b1;
        end   
            
        endcase    
        end
        else begin
            Airth_Enable = 1'b0;
            Logic_Enable = 1'b0;
            Shift_Enable = 1'b0;
            CMP_Enable   = 1'b0;
        end
        
    end

    
endmodule //Decoder_Unit
