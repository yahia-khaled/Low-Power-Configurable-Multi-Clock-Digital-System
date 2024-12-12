module PULSE_GEN(
    input               wire                            RST,
    input               wire                            CLK,
    input               wire                            LVL_SIG,
    output              wire                            PULSE_SIG
);


reg                     FF1;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        FF1 <= 0;
    end
    else begin
        FF1 <= LVL_SIG;
    end
end

assign PULSE_SIG = LVL_SIG & !FF1;
    
endmodule //PULSE_GEN
