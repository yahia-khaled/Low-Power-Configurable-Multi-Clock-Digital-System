module FIFO_RD #(parameter number_of_bit_address = 3) (
    input            wire                                                        rinc,
    input            wire                                                        rclk,
    input            wire                                                        rrst_n,
    input            wire             [number_of_bit_address:0]                  rq2_wptr,
    output           reg                                                         rempty,
    output           reg              [number_of_bit_address:0]                  rptr,
    output           reg              [number_of_bit_address-1:0]                raddr
);

wire            [number_of_bit_address:0]                    rptr_Gray;

always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        rempty <= 1;
        rptr <= 0;
        raddr <= 0;
    end
    else begin
        if (rq2_wptr == rptr_Gray) begin
            rempty <= 1;
            rptr <= rptr;
            raddr <= raddr;
        end
        else begin
            rempty <= 0;
            if (rinc) begin
                rptr <= rptr + 1;
                raddr <= raddr + 1;
            end
            else begin
                rptr <= rptr;
                raddr <= raddr;
            end
        end
    end
end

assign rptr_Gray = rptr ^ (rptr >> 1) ;


endmodule //FIFO_RD

