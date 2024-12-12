module edge_bit_counter(
    input           wire                    enable,
    input           wire        [5:0]       Prescale,
    input           wire                    CLK,
    input           wire                    RST,
    input           wire                    PAR_EN,
    output          reg         [5:0]       edge_cnt,
    output          reg         [3:0]       bit_cnt

);



always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        edge_cnt = 1'b0;
        bit_cnt = 1'b0;
    end
    else if (enable) begin
        if(edge_cnt < (Prescale-1)) begin
            edge_cnt = edge_cnt + 1;
        end
        else begin
            edge_cnt = 0;
            if (PAR_EN) begin
                if(bit_cnt < 12) begin
                    bit_cnt = bit_cnt + 1;
                end
                else begin
                    bit_cnt = 0;
                end  
            end
            else begin
                if(bit_cnt < 11) begin
                    bit_cnt = bit_cnt + 1;
                end
                else begin
                    bit_cnt = 0;
                end  
            end
        end   
        end
        else begin
            edge_cnt = 0;
            bit_cnt = 0;
        end

end


    
endmodule //edge_bit_counter


