module CLK_DIV(
    input           wire                                     i_ref_clk,
    input           wire                                     i_rst_n,
    input           wire                                     i_clk_en,
    input           wire              [7:0]                  i_div_ratio,
    output          reg                                      o_div_clk


);


reg             [4:0]                Counter;
reg                                  state;
reg                                  o_div_clk_internal;
wire                                 is_odd;

always @(negedge i_rst_n or posedge i_ref_clk) begin
    if(!i_rst_n) begin
    o_div_clk_internal <= 0;
    Counter <= 0;
    state <= 0;
    end
    else if (i_clk_en) begin
        if(i_div_ratio == 0 || i_div_ratio == 1)
        begin
            o_div_clk_internal <= 0;
            Counter <= 0;
            state <= 0;
        end
        else begin
            if (!is_odd) begin
            if (Counter == ((i_div_ratio >> 1)-1)) begin
                Counter <= 0;
                o_div_clk_internal <= ~ o_div_clk_internal;
                state <= ~ state;
            end
            else begin
                Counter <= Counter + 1;
            end
        end
        else begin
            if (Counter == ((i_div_ratio >> 1)-1 ) && state) begin
                Counter <= 0;
                o_div_clk_internal <= ~ o_div_clk_internal;
                state <= ~ state;
            end
            else if(Counter == ((i_div_ratio >> 1)) && !state) begin
                Counter <= 0;
                o_div_clk_internal <= ~ o_div_clk_internal;
                state <= ~ state;
            end
            else begin
                Counter <= Counter + 1;
            end
        end
        end
        
    end
    else begin
        o_div_clk_internal <= 0;
        Counter <= 0;
        state <= 0;
    end
end

always @(*) begin
    if(i_div_ratio == 0 || i_div_ratio == 1 || i_clk_en == 0) begin 
        o_div_clk = i_ref_clk;
    end
    else  begin
        o_div_clk = o_div_clk_internal;
    end
end 

assign is_odd = i_div_ratio[0];    


endmodule //CLK_DIV

