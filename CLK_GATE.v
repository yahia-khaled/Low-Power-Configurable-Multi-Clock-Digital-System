module CLK_GATE(
    input                wire                CLK,
    input                wire                CLK_EN,
    output               wire                GATED_CLK
);

reg             Latch_Out;


always @(CLK or CLK_EN) begin
    if (!CLK) begin
        Latch_Out = CLK_EN;
    end

end

assign GATED_CLK = Latch_Out & CLK;

endmodule //CLK_GATE
