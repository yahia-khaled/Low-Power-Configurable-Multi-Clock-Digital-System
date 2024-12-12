module FIFO_MEM_CNTRL #(parameter  DATA_WIDTH = 8 , MEM_DEPTH = 8 , number_of_bit_address = 3 ) (
    input               wire                [DATA_WIDTH-1:0]                                      wdata,
    input               wire                                                                      wclk,
    input               wire                                                                      wclken,
    input               wire                [number_of_bit_address-1:0]                           waddr,
    input               wire                [number_of_bit_address-1:0]                           raddr,
    input               wire                                                                      RST_MEM,
    output              reg                 [DATA_WIDTH-1:0]                                      rdata
);

//////////////////////////////// integers //////////////////////////////////////////
integer i;

reg                 [DATA_WIDTH-1:0]            REG_FILE                [MEM_DEPTH-1:0];    

always @(posedge wclk or negedge RST_MEM) begin
    if (!RST_MEM) begin
        for (i = 0; i < MEM_DEPTH ;i = i + 1 ) begin
            REG_FILE[i] <= 0;
        end
    end
    else begin
        if (wclken) begin
            REG_FILE[waddr] <= wdata;
        end
        else begin
            REG_FILE[waddr] <= REG_FILE[waddr];
        end
    end
end

always @(posedge wclk or negedge RST_MEM) begin
    if (!RST_MEM) begin
        rdata  <= 0;
    end
    else begin
        rdata <= REG_FILE[raddr];
    end
end

endmodule //FIFO_MEM_CNTRL


