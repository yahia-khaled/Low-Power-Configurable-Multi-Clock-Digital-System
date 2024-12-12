module FSM(
    input        wire                RX_IN,
    input        wire                PAR_EN,
    input        wire     [5:0]      edge_cnt,
    input        wire     [3:0]      bit_cnt,
    input        wire                par_err,
    input        wire                strt_glitch,
    input        wire                stp_err,
    input        wire                CLK,
    input        wire                RST,
    input        wire     [5:0]      Prescale,
    output       reg                 par_chk_en,
    output       reg                 strt_chk_en,
    output       reg                 stp_chk_en,
    output       reg                 data_samp_en,
    output       reg                 deser_en,
    output       reg                 data_valid,
    output       reg                 enable
);
    
////////////////////////////////internal signals////////////////////////////////
reg                  detect_start_of_frame;
reg      [5:0]       middle_sample;
reg                  parity_bit_calc;
////////////////////////////////state  Gray encoding////////////////////////////////
localparam IDLE                    = 3'b000;
localparam strt_bit_state          = 3'b001;
localparam data_bits_state         = 3'b011;
localparam stp_bit_state           = 3'b010;
localparam parity_bit_state        = 3'b110;




////////////////////////////////define current and next state////////////////////////////////
reg         [2:0]           current_state;
reg         [2:0]           next_state;
reg         [2:0]           temp_state;



////////////////////////////////integer /////////////////////////////////////////////////////
//integer i ;


////////////////////////////////sequential always/////////////////////////////////

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end




////////////////////////////////combinational always/////////////////////////////////



always @(*) begin
    par_chk_en = 1'b0;
    strt_chk_en = 1'b0;
    stp_chk_en = 1'b0;
    deser_en = 1'b0;
    detect_start_of_frame = 1'b0;
    parity_bit_calc = 1'b0;
    middle_sample = (Prescale/2 - 1);
    case (current_state) 
        IDLE:
        begin
           par_chk_en = 1'b0;
           strt_chk_en = 1'b0;
           stp_chk_en = 1'b0;
           data_samp_en = 1'b0;
           deser_en = 1'b0;
           enable = 1'b0;
           temp_state = IDLE;
           data_valid = 0;
           //data_valid = !stp_err & PAR_EN & !par_err | !stp_err & !PAR_EN;
           if (!RX_IN) begin
               next_state = strt_bit_state;
           end
           else begin
               next_state = IDLE;
           end
        end
        strt_bit_state:
        begin
            data_samp_en = 1'b1;
            enable = 1'b1;
            middle_sample = (Prescale/2 - 1);
            //data_valid = !stp_err & PAR_EN & !par_err | !stp_err & !PAR_EN;
            data_valid = 0;
            if (edge_cnt == (middle_sample + 3)) begin
                strt_chk_en = 1'b1;
            end
            else begin
                strt_chk_en = 1'b0;
            end
            if(strt_glitch) begin
                data_samp_en = 1'b0;
                enable = 1'b0;
                strt_chk_en = 1'b0;
                temp_state = IDLE;
            end
            else begin
                temp_state = data_bits_state;
                strt_chk_en = 1'b0;
            end
            
            if (edge_cnt == (Prescale-1)) begin
                next_state = temp_state;
            end
            else begin
                next_state = strt_bit_state;
            end
        end
        data_bits_state:
        begin
            data_valid = 1'b0;
            data_samp_en = 1'b1;
            deser_en = 1'b1;
            enable = 1'b1;
            if (bit_cnt < 8) begin
                temp_state = data_bits_state;
            end
            else begin
                if (PAR_EN) begin
                    temp_state = parity_bit_state;
                end
                else begin
                    temp_state = stp_bit_state;
                end
            end
            if (edge_cnt == (Prescale-1)) begin
                next_state = temp_state;
            end
            else begin
                next_state = data_bits_state;
            end
        end
        stp_bit_state:
        begin
            deser_en = 1'b0;
            par_chk_en = 1'b0;
            data_samp_en = 1'b1;
            temp_state = IDLE;
            
                if(edge_cnt == (middle_sample+3)) begin
                if(!stp_chk_en) begin
                    stp_chk_en = 1;
                    data_valid = 1'b0;
                end
                else begin
                    stp_chk_en = 1;
                    data_valid = 1'b0;
                end
                end
                else if (edge_cnt == (middle_sample+4)) begin
                    if(PAR_EN) begin
                if(stp_err || par_err) begin
                    data_valid = 1'b0;
                end
                else begin
                    data_valid = 1'b1;
                end
                end
                else begin
                    if (stp_err) begin
                        data_valid = 1'b0;
                    end
                    else begin
                        data_valid = 1'b1;
                    end
                end
                end      
            
                else begin
                    stp_chk_en = 1'b0;
                    data_valid = 0;
                    //data_valid = !stp_err & PAR_EN & !par_err | !stp_err & !PAR_EN;
                    
                end

            if (edge_cnt == (Prescale-1)) begin
                enable = 1'b0;
                next_state = temp_state;
            end
            else begin
                enable = 1'b1;
                next_state = stp_bit_state;
            end
            
        end
        parity_bit_state:
        begin
            enable = 1'b1;
            data_valid = 1'b0;
            temp_state = stp_bit_state;
            deser_en = 1'b0;
            data_samp_en = 1'b1;
            if (edge_cnt > (middle_sample+3) ) begin
                par_chk_en = 1'b1;
            end
            else begin
                par_chk_en = 1'b0;
            end
            if (edge_cnt == (Prescale-1)) begin
                next_state = stp_bit_state;
            end
            else begin
                next_state = parity_bit_state;
            end
        end 
        default:
        begin
            temp_state = current_state;
            next_state = current_state;
            data_samp_en = 1'b1;
            enable = 1'b1;
            data_valid = 1'b0;
        end 
    endcase
end




endmodule //FSM


