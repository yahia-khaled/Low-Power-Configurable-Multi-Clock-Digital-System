module deseializer 
(
    input               wire                                 deser_en,
    input               wire                                 sample_bit,
    input               wire       [5:0]                     edge_cnt,
    input               wire                                 CLK,
    input               wire       [5:0]                     Prescale,
    input               wire                                 RST,
    output              reg        [7:0]                     P_DATA      
);


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        P_DATA <= 0;
    end
    else if (edge_cnt == (Prescale -1)) begin
        if (deser_en) begin
            P_DATA <= {sample_bit,P_DATA[7:1]} ;
        end
        else begin
            P_DATA <= P_DATA;
        end
    end
end
    
endmodule //deseializer

