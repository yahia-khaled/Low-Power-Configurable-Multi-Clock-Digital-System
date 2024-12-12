module FIFO_WR #(parameter number_of_bit_address = 3)(
    input               wire                                                            wclk,
    input               wire                                                            winc,
    input               wire                                                            wrst_n,
    input               wire                    [number_of_bit_address:0]               wq2_rptr,
    output              reg                     [number_of_bit_address-1:0]             waddr,
    output              reg                     [number_of_bit_address:0]               wptr,
    output              reg                                         wfull
);

wire                        [number_of_bit_address:0]               wptr_Gray;
always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
        waddr <= 0;
        wptr <= 0;
        wfull <= 0;
    end
    else begin
        if (wq2_rptr[number_of_bit_address] != wptr_Gray[number_of_bit_address]   && wq2_rptr[number_of_bit_address-1:0] == wptr_Gray[number_of_bit_address-1:0]) begin
            wfull <= 1;
        end
        else begin
            wfull <= 0;
            if (winc) begin
                wptr <= wptr + 1;
                waddr <= waddr + 1;
            end
            else begin
                wptr <= wptr;
                waddr <= waddr;
            end
        end
    end
end

assign wptr_Gray = wptr ^ (wptr >> 1) ;


endmodule //FIFO_WR

