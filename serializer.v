module Serializer#(parameter WIDTH_DATA = 8)(
    input       wire        [WIDTH_DATA-1:0]        P_DATA,
    input       wire                                DATA_VALID,
    input       wire                                ser_en,
    input       wire                                CLK,
    input       wire                                RST,
    input       wire                                BUSY,  
    output      wire                                ser_done,
    output      wire                                ser_data
);
    
//internal signal
reg         [WIDTH_DATA-1:0]        P_DATA_RECEIVED;
reg         [2:0]        Counter;
integer i;


////////////////////////////////

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        P_DATA_RECEIVED <= 0;
    end
    else if(DATA_VALID)begin
        P_DATA_RECEIVED <= P_DATA;
    end
    else begin
        P_DATA_RECEIVED <= P_DATA_RECEIVED;
    end
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        Counter <= 0;
        //ser_done <= 0;
    end
    else if (Counter == 7 || !ser_en) begin
        Counter <= 0;
        //ser_done <= 1;
    end
    else if (ser_en) begin
        Counter <= Counter + 1;
        //ser_done <= 0;
    end
    else begin
        Counter <= Counter;
        //ser_done <= ser_done;
    end
end


assign ser_data = (ser_en) ? P_DATA[Counter] : 1'b0; 

assign ser_done = (Counter == 7) ? 1'b1 : 1'b0;

endmodule //Serializer

