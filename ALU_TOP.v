module ALU_TOP #(parameter WIDTH_A = 8 , WIDTH_B = 8 ,ALU_FUN_WIDTH = 4 , ALU_OUT_WIDTH = 16 )
(
    input     wire              [ALU_FUN_WIDTH-1:0]                        ALU_FUN_TOP,
    input     wire              [WIDTH_A-1:0]                              A_TOP,
    input     wire              [WIDTH_B-1:0]                              B_TOP,
    input     wire                                                         Enable,
    input     wire                                                         RST_TOP,
    input     wire                                                         CLK_TOP,
    output    reg               [ALU_OUT_WIDTH-1:0]                        ALU_OUT,
    output    reg                                                          OUT_VALID  

);

//internal signal declaration
wire                                   Airth_Enable_Top;
wire                                   Logic_Enable_Top;
wire                                   Shift_Enable_Top;
wire                                   CMP_Enable_Top;
wire    [ALU_OUT_WIDTH-1:0]            Airth_OUT_TOP;
wire    [ALU_OUT_WIDTH-1:0]            Shift_OUT_TOP;
wire    [ALU_OUT_WIDTH-1:0]            Logic_OUT_TOP;
wire    [ALU_OUT_WIDTH-1:0]            CMP_OUT_TOP;
wire                                   Arith_Flag_TOP;
wire                                   Shift_Flag_TOP;
wire                                   Logic_Flag_TOP;
wire                                   CMP_Flag_TOP;



wire       [3:0]             ALU_falgs;


assign ALU_falgs = {Arith_Flag_TOP , Shift_Flag_TOP , Logic_Flag_TOP , CMP_Flag_TOP};

always @(*) begin
    case (ALU_falgs)
        4'b1000:
        begin
            ALU_OUT = Airth_OUT_TOP;
            OUT_VALID = 1;
        end
        4'b0100:
        begin
            ALU_OUT = Shift_OUT_TOP;
            OUT_VALID = 1;
        end
        4'b0010:
        begin
            ALU_OUT = Logic_OUT_TOP;
            OUT_VALID = 1;
        end
        4'b0001:
        begin
            ALU_OUT = CMP_OUT_TOP;
            OUT_VALID = 1;
        end
        default:
        begin
            ALU_OUT = 0;
            OUT_VALID = 0;
        end 
    endcase
end


    ARITHMETIC_UNIT #( .WIDTH_A(WIDTH_A) , .WIDTH_B(WIDTH_B) , .WIDTH_ALU_OUT(ALU_OUT_WIDTH)) U1 (
        .ALU_FUN(ALU_FUN_TOP[1:0]),
        .A(A_TOP),
        .B(B_TOP),
        .CLK(CLK_TOP),
        .RST(RST_TOP),
        .Airth_Enable(Airth_Enable_Top),
        .Airth_OUT(Airth_OUT_TOP),
        .Arith_Flag(Arith_Flag_TOP)
    );


    LOGIC_UNIT #( .WIDTH_A(WIDTH_A) , .WIDTH_B(WIDTH_B) , .WIDTH_Logic_OUT(ALU_OUT_WIDTH)) U2 (
        .ALU_FUN(ALU_FUN_TOP[1:0]),
        .A(A_TOP),
        .B(B_TOP),
        .RST(RST_TOP),
        .CLK(CLK_TOP),
        .Logic_Enable(Logic_Enable_Top),
        .Logic_OUT(Logic_OUT_TOP),
        .Logic_Flag(Logic_Flag_TOP)
    );

    SHIFT_UNIT  #( .WIDTH_A(WIDTH_A) , .WIDTH_B(WIDTH_B) , .WIDTH_Shift_OUT(ALU_OUT_WIDTH)) U3 (

        .ALU_FUN(ALU_FUN_TOP[1:0]),
        .A(A_TOP),
        .B(B_TOP),
        .RST(RST_TOP),
        .CLK(CLK_TOP),
        .Shift_Enable(Shift_Enable_Top),
        .Shift_OUT(Shift_OUT_TOP),
        .Shift_Flag(Shift_Flag_TOP)
    );

    CMP_UNIT #( .WIDTH_A(WIDTH_A) , .WIDTH_B(WIDTH_B) , .WIDTH_CMP_OUT(ALU_OUT_WIDTH)) U4 (
        .ALU_FUN(ALU_FUN_TOP[1:0]),
        .A(A_TOP),
        .B(B_TOP),
        .RST(RST_TOP),
        .CLK(CLK_TOP),
        .CMP_Enable(CMP_Enable_Top),
        .CMP_OUT(CMP_OUT_TOP),
        .CMP_Flag(CMP_Flag_TOP)
    );

    Decoder_Unit U5 (
        .ALU_FUN(ALU_FUN_TOP[3:2]),
        .Airth_Enable(Airth_Enable_Top),
        .Logic_Enable(Logic_Enable_Top),
        .Shift_Enable(Shift_Enable_Top),
        .CMP_Enable(CMP_Enable_Top),
        .Enable_ALU(Enable)
    );
endmodule //ALU_TOP
