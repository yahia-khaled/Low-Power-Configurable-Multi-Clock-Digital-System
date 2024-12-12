module parity_check(
    input               wire                    par_chk_en,
    input               wire                    CLK,
    input               wire                    PAR_TYP,
    input               wire                    sampled_bit,
    input               wire                    RST,
    input               wire        [3:0]       bit_cnt,
    input               wire        [7:0]       P_DATA,
    output              reg                     par_err
    );
    


////////////////////////////////internal signals////////////////////////////////
reg             parity_calc;
reg             par_err_comb;
reg             parity_calc_comb;


always @(posedge CLK or negedge RST ) begin
    if (!RST) begin
        parity_calc <= 0;
        par_err <= 0;
    end
    else begin
        parity_calc <= parity_calc_comb;
        par_err <= par_err_comb;
    end
end



always @(*) begin
        
        if(par_chk_en && bit_cnt == 9) begin
            if(PAR_TYP) begin
                parity_calc_comb = ^ P_DATA;
            end
            else begin
                parity_calc_comb = ~^ P_DATA;
            end

            if (sampled_bit == parity_calc_comb) begin
                par_err_comb = 0;
            end
            else begin
                par_err_comb = 1;
            end
        end
        else begin
            par_err_comb = 0;
            parity_calc_comb = 0;
        end
end
endmodule //parity_check

