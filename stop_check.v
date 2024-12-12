module stop_check(
    input               wire                stp_chk_en,
    input               wire                sampled_bit,
    input               wire                RST,
    input               wire                CLK,
    output              reg                 stp_err
);
    

always @(posedge CLK or negedge RST ) begin
    if (!RST)begin
        stp_err <= 0;
    end
    else if(stp_chk_en) begin
        if (sampled_bit) begin
            stp_err <= 0;
        end
        else begin
            stp_err <= 1;
        end
    end
    else begin
        stp_err <= stp_err;
    end
end

endmodule //stop_check

