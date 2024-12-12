module PARITY_CALC#(parameter WIDTH_DATA = 8)(
    input       wire        [WIDTH_DATA-1:0]        P_DATA,
    input       wire                                DATA_VALID,
    input       wire                                PAR_TYP,
    input       wire                                RST,
    input       wire                                CLK,
    output      reg                                 par_bit
);

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
    par_bit <= 1'b0;
    end
    else if(PAR_TYP)begin
        par_bit <= ^ P_DATA;
    end
    else if (!PAR_TYP) begin
        par_bit <= ~^ P_DATA;
    end
    else begin
        par_bit <= par_bit;
    end
end
    
endmodule //PARITY_CALC

