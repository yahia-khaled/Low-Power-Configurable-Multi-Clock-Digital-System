module data_sampling(
    input           wire        [5:0]         Prescale,
    input           wire                      RX_IN,
    input           wire                      RST,
    input           wire                      CLK,
    input           wire                      data_samp_en,
    input           wire        [5:0]         edge_cnt,
    output          reg                       sampled_bit
);



////////////////////////////////internal signal////////////////////////////////
reg         [5:0]               middle_sample;
reg         [2:0]               samples;


////////////////////////////////integers////////////////////////////////
integer i;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        sampled_bit = 0;
        i = 0;
    end
    else if (data_samp_en) begin
        middle_sample = Prescale/2 - 1;
        if(edge_cnt > (middle_sample - 2) && edge_cnt < (middle_sample + 2) ) begin
            samples[i] <= RX_IN;
            i = i  + 1;
        end
        else if (edge_cnt == (middle_sample + 2)) begin
            i = 0;
                case (samples)
                    3'b000:
                    begin
                        sampled_bit = 0;
                    end
                    3'b001:
                    begin
                        sampled_bit = 0;
                    end
                    3'b010:
                    begin
                        sampled_bit = 0;
                    end
                    3'b011:
                    begin
                        sampled_bit = 1;
                    end
                    3'b100:
                    begin
                        sampled_bit = 0;
                    end
                    3'b101:
                    begin
                        sampled_bit = 1;
                    end
                    3'b110:
                    begin
                        sampled_bit = 1;
                    end
                    3'b111:
                    begin
                        sampled_bit = 1;
                    end        
                    default:
                    begin
                        sampled_bit = 0;
                    end 
                endcase
        end
    end
    else begin
        sampled_bit = sampled_bit;
    end
end
    
endmodule //data_sampling


