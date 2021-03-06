module datapath#(
        parameter DATA_WIDTH = 16,
        parameter OPERAND_WIDTH = 11
    )
    (
        
        input logic [OPERAND_WIDTH - 1:0] operand_in,
        input logic [DATA_WIDTH - 1:0] data_memory_in,
        input logic alu_op_in, sel_B_in, acc_wr_in, clock_in,
        input logic status_wr_in, status_reset_in, acc_reset_in,
        input logic [1:0] sel_A_in,
        output logic [OPERAND_WIDTH - 1:0] data_memory_address_out,
        output logic [DATA_WIDTH - 1:0] data_out, ext_out, 
        output logic status_Z_out, status_N_out
    );

    logic [DATA_WIDTH - 1:0] ext_out_mux_A_and_B_in, alu_out_mux_A_in;
    logic [DATA_WIDTH - 1:0] mux_A_out_acc_in, mux_B_out_alu_B_in;
    logic [DATA_WIDTH - 1:0] acc_out_data_out_and_alu_A_in;
    logic zero_indicator, signal_bit;

    register acc0(
        .reg_in(mux_A_out_acc_in),
        .reg_wr(acc_wr_in),
        .reg_reset(acc_reset_in),
        .clock(clock_in),
        .reg_out(acc_out_data_out_and_alu_A_in)
    );

    alu alu0(
        .alu_A_in(acc_out_data_out_and_alu_A_in),
        .alu_B_in(mux_B_out_alu_B_in),
        .alu_op_in(alu_op_in),
        .alu_out(alu_out_mux_A_in),
        .alu_Z_out(zero_indicator),
        .alu_N_out(signal_bit)
    );

    ext ext0(
        .ext_in(operand_in),
        .ext_out(ext_out_mux_A_and_B_in)
	);

    register #(.WIDTH(2)) status0(
        .reg_in({zero_indicator, signal_bit}), 
        .reg_wr(status_wr), 
        .reg_reset(status_reset), 
        .clock(clock), 
        .reg_out({status_Z_out, status_N_out})
    );

    mux_3x1 mux_A0(
        .in_10(alu_out_mux_A_in),
        .in_01(ext_out_mux_A_and_B_in),
        .in_00(data_memory_in),
        .select_3x1(sel_A_in),
        .mux_out(mux_A_out_acc_in)
    );

    mux_2x1 mux_B0(
        .in_1(ext_out_mux_A_and_B_in),
        .in_0(data_memory_in),
        .sel_2x1_in(sel_B_in),
        .mux_out(mux_B_out_alu_B_in)
    );

    assign data_memory_address_out = operand_in;
    assign ext_out = ext_out_mux_A_and_B_in;
    assign data_out = acc_out_data_out_and_alu_A_in;

endmodule