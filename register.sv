module register#(
        parameter DATA_WIDTH = 11
    )
    (
        input logic [DATA_WIDTH - 1:0] reg_in, 
        input logic reg_wr, reg_reset, clock, 
        output logic [DATA_WIDTH - 1:0] reg_out
    );

    always_ff @(posedge clock)
    begin
        if(reg_reset==1'b0)
        begin
            if (reg_wr == 1'b1)
                reg_out <= reg_in;
        end
        else
            reg_out <= 11'b00000000000;
    end

endmodule