module UART_RX (
    input           wire                                               CLK_TOP,
    input           wire                                               RX_IN_TOP,
    input           wire                                               RST_TOP,
    input           wire                                               PAR_EN_TOP,
    input           wire                                               PAR_TYP_TOP,
    input           wire            [5:0]                              Prescal_TOP,
    output          wire            [7:0]                              P_DATA_TOP,
    output          wire                                               data_valid_TOP,
    output          wire                                               stp_err_TOP,
    output          wire                                               par_err_TOP
);


////////////////////////////////internal signals////////////////////////////////
wire                    [5:0]           edge_cnt_TOP;
wire                    [3:0]           bit_cnt_TOP;
wire                                    enable_TOP;
wire                                    par_chk_en_TOP;
wire                                    strt_chk_en_TOP;
wire                                    strt_glitch_TOP;
wire                                    stp_chk_en_TOP;
wire                                    deser_en_TOP;
wire                                    sampled_bit_TOP;
wire                                    data_samp_en_TOP;

////////////////////////////////instantiation of modules/////////////////////////////////
FSM U1 (
    .RX_IN(RX_IN_TOP),
    .PAR_EN(PAR_EN_TOP),
    .edge_cnt(edge_cnt_TOP),
    .bit_cnt(bit_cnt_TOP),
    .par_err(par_err_TOP),
    .strt_glitch(strt_glitch_TOP),
    .stp_err(stp_err_TOP),
    .CLK(CLK_TOP),
    .RST(RST_TOP),
    .Prescale(Prescal_TOP),
    .par_chk_en(par_chk_en_TOP),
    .strt_chk_en(strt_chk_en_TOP),
    .stp_chk_en(stp_chk_en_TOP),
    .data_samp_en(data_samp_en_TOP),
    .deser_en(deser_en_TOP),
    .data_valid(data_valid_TOP),
    .enable(enable_TOP)
);



data_sampling U2 (
    .RX_IN(RX_IN_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP),
    .Prescale(Prescal_TOP),
    .data_samp_en(data_samp_en_TOP),
    .edge_cnt(edge_cnt_TOP),
    .sampled_bit(sampled_bit_TOP)
);


deseializer U3 (
    .deser_en(deser_en_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP),
    .edge_cnt(edge_cnt_TOP),
    .sample_bit(sampled_bit_TOP),
    .P_DATA(P_DATA_TOP),
    .Prescale(Prescal_TOP)
);


edge_bit_counter U4 (
    .enable(enable_TOP),
    .bit_cnt(bit_cnt_TOP),
    .edge_cnt(edge_cnt_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP),
    .Prescale(Prescal_TOP),
    .PAR_EN(PAR_EN_TOP)
);

parity_check U5 (
    .PAR_TYP(PAR_TYP_TOP),
    .par_chk_en(par_chk_en_TOP),
    .par_err(par_err_TOP),
    .sampled_bit(sampled_bit_TOP),
    .P_DATA(P_DATA_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP),
    .bit_cnt(bit_cnt_TOP)
);

strt_check U6 (
    .strt_chk_en(strt_chk_en_TOP),
    .strt_glitch(strt_glitch_TOP),
    .sampled_bit(sampled_bit_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP)
);

stop_check U7 (
    .stp_chk_en(stp_chk_en_TOP),
    .stp_err(stp_err_TOP),
    .sampled_bit(sampled_bit_TOP),
    .RST(RST_TOP),
    .CLK(CLK_TOP)
);



endmodule //UART_RX

