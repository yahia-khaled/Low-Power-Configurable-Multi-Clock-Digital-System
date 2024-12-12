module DATA_SYNC #(parameter NUM_STAGES = 2 , BUS_WIDTH = 8)(
    input           wire            [BUS_WIDTH-1:0]             unsync_bus,
    input           wire                                        CLK,
    input           wire                                        RST,
    input           wire                                        bus_enable,
    output          reg             [BUS_WIDTH-1:0]             sync_bus,
    output          reg                                         enable_pulse
);




////////////////////////////////internal registers //////////////////////////////////
reg                 [NUM_STAGES-1:0]                    Multi_Flip_Flop_register;
reg                                                     pulse_gen_register;
wire                                                    output_of_pulse_gen;




assign output_of_pulse_gen = ~ pulse_gen_register & Multi_Flip_Flop_register[NUM_STAGES-1];

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        enable_pulse <= 0;
        sync_bus <= 0;
        Multi_Flip_Flop_register <= 0;
        sync_bus <= 0;
    end
    else begin
        Multi_Flip_Flop_register <= {Multi_Flip_Flop_register[NUM_STAGES-2:0] ,bus_enable};
        pulse_gen_register <= Multi_Flip_Flop_register[NUM_STAGES-1];
        enable_pulse <= output_of_pulse_gen;

        if (output_of_pulse_gen) begin
            sync_bus <= unsync_bus;
        end
        else begin
            sync_bus <= sync_bus;
        end
    end
end


endmodule //DATA_SYNC 

