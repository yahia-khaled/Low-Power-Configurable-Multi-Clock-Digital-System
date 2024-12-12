module FSM_TX(
    input       wire            RST,
    input       wire            CLK,
    input       wire            ser_done,
    input       wire            PAR_EN,
    input       wire            DATA_VALID,
    output      reg             ser_en,
    output      reg     [1:0]   mux_sel,
    output      reg             BUSY
);

////////////////////////////////

//FSM DECODING
localparam   [2:0]    IDLE= 3'b000;
localparam   [2:0]    start_bit_state= 3'b001;
localparam   [2:0]    data_bits_state= 3'b010;
localparam   [2:0]    stop_bit_state= 3'b011;
localparam   [2:0]    parity_bit_state= 3'b111;



reg    [2:0]         CURRENT_STATE,NEXT_STATE;


////////////////////////////////

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        CURRENT_STATE <= IDLE;
    end
    else begin
        CURRENT_STATE <= NEXT_STATE;
    end
end


/////////////////////////////////

always @(*) begin
    case (CURRENT_STATE)
        IDLE:
        begin
            if (DATA_VALID) begin
                NEXT_STATE = start_bit_state;
            end
            else begin
                NEXT_STATE = IDLE;
            end
        end
        start_bit_state:
        begin
            NEXT_STATE = data_bits_state;
        end
        data_bits_state:
        begin
            if(ser_done && PAR_EN) begin
                NEXT_STATE = parity_bit_state;
            end
            else if(ser_done && !PAR_EN) begin
                NEXT_STATE = stop_bit_state;
            end 
            else begin
                NEXT_STATE = data_bits_state;
            end
        end 
        parity_bit_state:
        begin
            NEXT_STATE = stop_bit_state;
        end
        stop_bit_state:
        begin
            NEXT_STATE = IDLE;
        end
        default:
        begin
            NEXT_STATE = IDLE;
        end 
    endcase
end
    
////////////////////////////////
always @(*) begin
    case (CURRENT_STATE)
        IDLE:
        begin
            ser_en = 1'b0;
            mux_sel = 2'b01;
            BUSY = 1'b0; 
        end
        start_bit_state:
        begin
            mux_sel = 2'b00;
            ser_en = 1'b0;
            BUSY = 1'b0;
        end 
        data_bits_state:
        begin
            ser_en = 1'b1;
            mux_sel = 2'b10;
            BUSY = 1'b0; 
        end
        parity_bit_state:
        begin
            mux_sel = 2'b11;
            BUSY = 1'b0;
            ser_en = 1'b0;
        end
        stop_bit_state:
        begin
            mux_sel = 2'b01;
            BUSY = 1'b1;
            ser_en = 1'b0;
        end
        default:
        begin
            ser_en = 1'b0;
            mux_sel = 2'b01;
            BUSY = 1'b0;
        end

    endcase
end


endmodule //moduleName
