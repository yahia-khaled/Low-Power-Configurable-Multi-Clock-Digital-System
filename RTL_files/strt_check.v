module strt_check(
    input           wire                strt_chk_en,
    input           wire                sampled_bit,
    input           wire                RST,
    input           wire                CLK,
    output          reg                 strt_glitch
);
    

    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            strt_glitch <= 1'b0;
        end
        else if(strt_chk_en) begin
           if(sampled_bit) begin
            strt_glitch <= 1'b1;
            end
            else begin
                strt_glitch <= 1'b0;
            end 
        end
        else begin
            strt_glitch <= strt_glitch;
        end
        
    end
endmodule //strt_check

