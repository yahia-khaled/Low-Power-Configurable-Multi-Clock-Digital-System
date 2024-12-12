module DF_SYNC #(parameter number_bits_synchronized = 4) (
    input               wire                                                     CLK,
    input               wire                                                     RST,
    input               wire        [number_bits_synchronized-1:0]               async_ptr,
    output              wire        [number_bits_synchronized-1:0]               sync_prt       
);

////////////////////////////////integers////////////////////////////////
integer i;
integer j;

////////////////////////////////internal signals////////////////////////////////

reg             [1:0]               SYNC_register           [number_bits_synchronized:0];
wire            [number_bits_synchronized:0]               ptr_Gray;


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        for (i = 0; i < number_bits_synchronized ; i = i + 1 ) begin
            SYNC_register[i] <= 0;
        end

    end
    else begin
        for (i = 0; i < number_bits_synchronized ; i = i + 1 ) begin
            SYNC_register[i] <= {SYNC_register[i][0] , ptr_Gray[i]};
        end
        
    end
end

//////////////////////////////// Gray encoding conversion //////////////////////////////////
assign ptr_Gray = async_ptr ^ (async_ptr >> 1) ;

//////////////////////////////// assign most sigificant bit to output of synchronizer////////////////////////////////////////

assign sync_prt[0] = SYNC_register[0][1];
assign sync_prt[1] = SYNC_register[1][1];
assign sync_prt[2] = SYNC_register[2][1];
assign sync_prt[3] = SYNC_register[3][1];
//assign sync_prt[4] = SYNC_register[4][1];

endmodule //DF_SYNC

