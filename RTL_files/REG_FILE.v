module REG_FILE #(parameter DATA_WIDTH = 8 , address_bits = 4) (
    input           wire            [DATA_WIDTH-1:0]                 WrData,
    input           wire                                             CLK,
    input           wire                                             RST,
    input           wire            [address_bits-1:0]               Address,
    input           wire                                             RdEn,
    input           wire                                             WrEn,
    output          reg             [DATA_WIDTH-1:0]                 RdData,
    output          reg                                              RdData_Valid,
    output          wire            [DATA_WIDTH-1:0]                 REG0,
    output          wire            [DATA_WIDTH-1:0]                 REG1,
    output          wire            [DATA_WIDTH-1:0]                 REG2,
    output          wire            [DATA_WIDTH-1:0]                 REG3
);

integer i;


reg             [DATA_WIDTH-1:0]            REG_file                [16:0];

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        for (i = 0 ;i < 16 ; i = i + 1) begin
            if (i == 2) begin
                REG_file[i] <= 'b10000001;
            end
            else if (i == 3) begin
                REG_file[i] <= 'b00100000;
            end
            else begin
                REG_file[i] <= 'b0;
            end
        end
        RdData_Valid <= 0;
        RdData <= 0;
    end
    else if (WrEn) begin
        REG_file[Address] <= WrData;
        RdData_Valid <= 0;
    end
    else if (RdEn) begin
        RdData <= REG_file[Address];
        RdData_Valid <= 1;
    end
    else begin
        RdData_Valid <= 0;
        RdData <= RdData;
    end
end

assign REG0 = REG_file[0];
assign REG1 = REG_file[1];
assign REG2 = REG_file[2];
assign REG3 = REG_file[3];

    

endmodule //REG_FILE
