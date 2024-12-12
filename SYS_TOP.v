module SYS_TOP #(parameter DATA_WIDTH = 8 , ALU_OUT_WIDTH = 16)(
    input                   wire                                                    RX_IN,
    input                   wire                                                    REF_CLK,
    input                   wire                                                    RST,
    input                   wire                                                    UART_CLK,
    output                  wire                                                    TX_OUT,
    output                  wire                                                    stp_err_UART_RX,
    output                  wire                                                    par_err_UART_RX,
    output                  wire                                                    BUST_TOP                                                    
);


localparam Address_bits = 4;


//////////////////////////////// internal wires //////////////////////////////////
wire                                                      WrEn_TOP;
wire                                                      RdEn_TOP;
wire            [Address_bits-1:0]                        Addr_TOP;
wire            [DATA_WIDTH-1:0]                          Wr_D_TOP;
wire            [DATA_WIDTH-1:0]                          Rd_D_TOP;
wire                                                      Rd_D_Vld_TOP;
wire                                                      RST_1;
wire                                                      RST_2;
wire            [7:0]                                     UART_config;
wire            [7:0]                                     DIV_RATIO_Config;
wire                                                      Clock_Divider_Enable;
wire                                                      UART_TX_CLK;
wire            [7:0]                                     UART_TX_IN_DATA;
wire                                                      UART_TX_EN;
wire                                                      FIFO_full_SIG;
wire                                                      ALU_CLK;
wire            [7:0]                                     OP_A;
wire            [7:0]                                     OP_B;
wire            [3:0]                                     ALU_FUN_TOP;
wire                                                      CLK_GATE_EN;
wire            [ALU_OUT_WIDTH-1:0]                       ALU_OUT_TOP;
wire                                                      ALU_EN;
wire                                                      OUT_Valid_TOP;
//wire                                                      BUST_TOP;
wire                                                      R_INC_TOP;
wire                                                      UART_RX_CLK;
wire            [7:0]                                     UART_RX_DATA;
wire                                                      data_valid_UART_RX;
wire            [7:0]                                     DATA_SYS_CTRL_IN;
wire                                                      enable_pulse_DATA_SYNC;
wire                                                      W_INC_TOP;
wire            [7:0]                                     FIFO_Write_DATA;
reg             [7:0]                                     DIV_RATIO_Config_UART_RX;

always @(*) begin
    case (UART_config[7:2])
        6'b100000:
        begin
            DIV_RATIO_Config_UART_RX = 1;
        end
        6'b010000:
        begin
            DIV_RATIO_Config_UART_RX = 2;
        end
        6'b001000:
        begin
            DIV_RATIO_Config_UART_RX = 4;
        end
        6'b000100:
        begin
            DIV_RATIO_Config_UART_RX = 8;
        end  
        default:
        begin
            DIV_RATIO_Config_UART_RX = 1;
        end 
    endcase
end


UART_RX UART_RX0 (
    .CLK_TOP(UART_RX_CLK),
    .RX_IN_TOP(RX_IN),
    .RST_TOP(RST_2),
    .PAR_EN_TOP(UART_config[0]),
    .PAR_TYP_TOP(UART_config[1]),
    .Prescal_TOP(UART_config[7:2]),
    .P_DATA_TOP(UART_RX_DATA),
    .data_valid_TOP(data_valid_UART_RX),
    .stp_err_TOP(stp_err_UART_RX),
    .par_err_TOP(par_err_UART_RX)
);


UART_TX_TOP #(.WIDTH_DATA(8)) UART_TX0 (
    .P_DATA_TOP(UART_TX_IN_DATA),
    .CLK_TOP(UART_TX_CLK),
    .RST_TOP(RST_2),
    .DATA_VALID_TOP(!UART_TX_EN),
    .PAR_EN_TOP(UART_config[0]),
    .PAR_TYP_TOP(UART_config[1]),
    .TX_OUT_TOP(TX_OUT),
    .BUSY_TOP(BUST_TOP)
);

SYS_CTRL #( .ALU_OUT_WIDTH(ALU_OUT_WIDTH)  , .RdData_WIDTH(8) , .ALU_FUN_WIDTH(4)  , .Address_bits(4) , .WrData_WIDTH(8) ) SYS_CTRL0 (
    .ALU_OUT(ALU_OUT_TOP),
    .CLK(REF_CLK),
    .RST(RST_1),
    .OUT_Valid(OUT_Valid_TOP),
    .RdData_Valid(Rd_D_Vld_TOP),
    .RdData(Rd_D_TOP),
    .RX_P_DATA(DATA_SYS_CTRL_IN),
    .RX_D_VLD(enable_pulse_DATA_SYNC),
    .FIFO_FULL(FIFO_full_SIG),
    .ALU_FUN(ALU_FUN_TOP),
    .EN(ALU_EN),
    .CLK_EN(CLK_GATE_EN),
    .Address(Addr_TOP),
    .WrEn(WrEn_TOP),
    .RdEn(RdEn_TOP),
    .WrData(Wr_D_TOP),
    .TX_P_DATA(FIFO_Write_DATA),
    .W_INC(W_INC_TOP),
    .clk_div_en(Clock_Divider_Enable)
);

REG_FILE #( .DATA_WIDTH(8) , .address_bits(4)) REG_FILE0 (
    .WrData(Wr_D_TOP),
    .CLK(REF_CLK),
    .RST(RST_1),
    .Address(Addr_TOP),
    .RdEn(RdEn_TOP),
    .WrEn(WrEn_TOP),
    .RdData(Rd_D_TOP),
    .RdData_Valid(Rd_D_Vld_TOP),
    .REG0(OP_A),
    .REG1(OP_B),
    .REG2(UART_config),
    .REG3(DIV_RATIO_Config)
);

ALU_TOP #( .WIDTH_A(8)  , .WIDTH_B(8) , .ALU_FUN_WIDTH(4)  , .ALU_OUT_WIDTH(ALU_OUT_WIDTH) ) ALU_U0 (
    .ALU_FUN_TOP(ALU_FUN_TOP),
    .A_TOP(OP_A),
    .B_TOP(OP_B),
    .RST_TOP(RST_1),
    .CLK_TOP(ALU_CLK),
    .ALU_OUT(ALU_OUT_TOP),
    .OUT_VALID(OUT_Valid_TOP),
    .Enable(ALU_EN)
);


FIFO #( .DATA_WIDTH(8) , .MEM_DEPTH(8) , .number_of_bit_address(3)) FIFO_U0 (
    .WR_DATA(FIFO_Write_DATA),
    .W_CLK(REF_CLK),
    .W_RST(RST_1),
    .W_INC(W_INC_TOP),
    .R_CLK(UART_TX_CLK),
    .R_RST(RST_2),
    .R_INC(R_INC_TOP),
    .RST(RST_1),
    .FULL(FIFO_full_SIG),
    .EMPTY(UART_TX_EN),
    .RD_DATA(UART_TX_IN_DATA)
);

CLK_GATE CLK_GATE_U0 (
    .CLK(REF_CLK),
    .CLK_EN(CLK_GATE_EN),
    .GATED_CLK(ALU_CLK)
);

CLK_DIV CLK_DIV_U0 (
    .i_ref_clk(UART_CLK),
    .i_rst_n(RST_2),
    .i_clk_en(Clock_Divider_Enable),
    .i_div_ratio(DIV_RATIO_Config),
    .o_div_clk(UART_TX_CLK)
);


CLK_DIV CLK_DIV_U1 (
    .i_ref_clk(UART_CLK),
    .i_rst_n(RST_2),
    .i_clk_en(Clock_Divider_Enable),
    .i_div_ratio(DIV_RATIO_Config_UART_RX),
    .o_div_clk(UART_RX_CLK)
);

DATA_SYNC DATA_SYNC_U0 (
    .unsync_bus(UART_RX_DATA),
    .CLK(REF_CLK),
    .RST(RST_1),
    .bus_enable(data_valid_UART_RX),
    .sync_bus(DATA_SYS_CTRL_IN),
    .enable_pulse(enable_pulse_DATA_SYNC)
);

PULSE_GEN PULSE_GEN_TOP (
    .RST(RST_2),
    .CLK(UART_TX_CLK),
    .LVL_SIG(BUST_TOP),
    .PULSE_SIG(R_INC_TOP)
);

RST_SYNC RST_SYNC_U0 (
    .CLK(REF_CLK),
    .RST(RST),
    .SYNC_RST(RST_1)
);

RST_SYNC RST_SYNC_U1 (
    .CLK(UART_CLK),
    .RST(RST),
    .SYNC_RST(RST_2)
);

endmodule //SYS_TOP
