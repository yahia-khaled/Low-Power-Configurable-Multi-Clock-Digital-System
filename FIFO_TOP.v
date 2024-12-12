module FIFO #(parameter DATA_WIDTH = 8 , MEM_DEPTH = 8 , number_of_bit_address = 3)(
    input               wire                [DATA_WIDTH-1:0]                WR_DATA,
    input               wire                                                W_CLK,
    input               wire                                                W_RST,
    input               wire                                                W_INC,
    input               wire                                                R_CLK,
    input               wire                                                R_RST,
    input               wire                                                R_INC,
    input               wire                                                RST,
    output              wire                                                FULL,
    output              wire                                                EMPTY,
    output              wire                [DATA_WIDTH-1:0]                RD_DATA
);



/////////////////////////////////// internal signals //////////////////////////////////
wire                                                               wclken_TOP;
wire             [number_of_bit_address-1:0]                       waddr_TOP;
wire             [number_of_bit_address:0]                         wptr_TOP;
wire             [number_of_bit_address:0]                         rq2_wptr_TOP;
wire             [number_of_bit_address:0]                         wq2_rptr_TOP;
wire             [number_of_bit_address-1:0]                       raddr_TOP;
wire             [number_of_bit_address:0]                         rptr_TOP;





///////////////////////////////modules instantiation //////////////////////////////
FIFO_MEM_CNTRL #(.DATA_WIDTH (DATA_WIDTH) , .MEM_DEPTH(MEM_DEPTH) , .number_of_bit_address(number_of_bit_address) ) U0 (
    .wdata(WR_DATA),
    .wclk(W_CLK),
    .wclken(wclken_TOP),
    .waddr(waddr_TOP),
    .raddr(raddr_TOP),
    .RST_MEM(RST),
    .rdata(RD_DATA)
);

FIFO_RD #(.number_of_bit_address(number_of_bit_address)) U1 (
    .rinc(R_INC),
    .rclk(R_CLK),
    .rrst_n(R_RST),
    .rq2_wptr(rq2_wptr_TOP),
    .rempty(EMPTY),
    .rptr(rptr_TOP),
    .raddr(raddr_TOP)
);

FIFO_WR #(.number_of_bit_address(number_of_bit_address)) U2 (
    .wclk(W_CLK),
    .winc(W_INC),
    .wrst_n(W_RST),
    .wq2_rptr(wq2_rptr_TOP),
    .waddr(waddr_TOP),
    .wptr(wptr_TOP),
    .wfull(FULL)
);

DF_SYNC #( .number_bits_synchronized(number_of_bit_address+1)) sync_w2r (
    .CLK(R_CLK),
    .RST(R_RST),
    .async_ptr(wptr_TOP),
    .sync_prt(rq2_wptr_TOP)
);


DF_SYNC #( .number_bits_synchronized(number_of_bit_address+1)) sync_r2w (
    .CLK(W_CLK),
    .RST(W_RST),
    .async_ptr(rptr_TOP),
    .sync_prt(wq2_rptr_TOP)
);



assign wclken_TOP = W_INC & ~ FULL;

endmodule //FIFO

