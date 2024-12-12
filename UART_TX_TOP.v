module UART_TX_TOP #(parameter WIDTH_DATA = 8) (
    input       wire        [WIDTH_DATA-1:0]        P_DATA_TOP,
    input       wire                                CLK_TOP,
    input       wire                                RST_TOP,
    input       wire                                DATA_VALID_TOP,
    input       wire                                PAR_EN_TOP,
    input       wire                                PAR_TYP_TOP,
    output      reg                                 TX_OUT_TOP,
    output      wire                                BUSY_TOP
);
    
wire         ser_data_TOP;
wire         ser_done_TOP;
wire         ser_en_TOP;
wire  [1:0]  mux_sel_TOP;
wire         par_bit_TOP;
reg          TX_OUT_comb;
always @(*) begin
    case (mux_sel_TOP)
        2'b00:
        begin
            TX_OUT_comb <= 1'b0;
        end
        2'b01:
        begin
            TX_OUT_comb <= 1'b1;
        end 
        2'b10:
        begin
            TX_OUT_comb <= ser_data_TOP;
        end
        2'b11:
        begin
            TX_OUT_comb <= par_bit_TOP;
        end 
    endcase
end

always @(posedge CLK_TOP or negedge RST_TOP) begin
    if (!RST_TOP) begin
        TX_OUT_TOP <= 1;
    end
    else begin
        TX_OUT_TOP <= TX_OUT_comb;
    end
end



Serializer #(.WIDTH_DATA(8)) U1 (
    .P_DATA(P_DATA_TOP),
    .DATA_VALID(DATA_VALID_TOP),
    .ser_en(ser_en_TOP),
    .CLK(CLK_TOP),
    .RST(RST_TOP),  
    .ser_done(ser_done_TOP),
    .ser_data(ser_data_TOP),
    .BUSY(BUSY_TOP)
); 

FSM_TX U2 (
    .RST(RST_TOP),
    .DATA_VALID(DATA_VALID_TOP),
    .CLK(CLK_TOP),
    .ser_done(ser_done_TOP),
    .PAR_EN(PAR_EN_TOP),
    .ser_en(ser_en_TOP),
    .mux_sel(mux_sel_TOP),
    .BUSY(BUSY_TOP)
);

PARITY_CALC #(.WIDTH_DATA(8)) U3 (
    .P_DATA(P_DATA_TOP),
    .DATA_VALID(DATA_VALID_TOP),
    .PAR_TYP(PAR_TYP_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP),
    .par_bit(par_bit_TOP)
);
endmodule //UART_TX_TOP
