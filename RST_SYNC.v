module RST_SYNC #(parameter NUM_STAGES = 2) (
    input                   wire                        CLK,
    input                   wire                        RST,
    output                  wire                        SYNC_RST
);


reg                 [NUM_STAGES-1:0]                    RST_SYNC_register;  

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        RST_SYNC_register <= 0;
    end
    else begin
        RST_SYNC_register <= {RST_SYNC_register[NUM_STAGES-2:0] , 1'b1 };
    end
end

assign SYNC_RST = RST_SYNC_register[NUM_STAGES-1];

endmodule //RST_SYNC

