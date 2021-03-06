`timescale 1 ns / 10 ps

module mux_3x1_test#(
        parameter DATA_WIDTH = 16
    );

    logic [DATA_WIDTH - 1:0] alu_in, ext_in, data_memory_in;
    logic [1:0] sel_A;
    logic [DATA_WIDTH - 1:0] mux_A_out;

    mux_3x1 mux0(
        .in_10(alu_in),
        .in_01(ext_in),
        .in_00(data_memory_in),
        .select_3x1(sel_A), 
        .mux_out(mux_A_out)
    );

    initial
    begin
        ext_in = 15'b0000000001110001;
        data_memory_in = 15'b0000000000000000;
        alu_in = 16'b1111111110000010;
        sel_A = 2'b00;
        #1 sel_A = 2'b01;
        #1 sel_A = 2'b10;
        #1 alu_in = 16'b0000001010101010;
        #1 ext_in = 16'b0000000000000001;
        #1 sel_A = 2'b00;
        #1 sel_A = 2'b11;
        #1 sel_A = 2'b00;
        #1 data_memory_in = 16'b1111110001100100;
        #1 alu_in = 16'b0000000100000010;
    end
endmodule
