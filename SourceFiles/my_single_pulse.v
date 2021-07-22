`timescale 1ns / 1ps
module my_single_pulse(input basys_clock, input push_button, output my_SP_out);

    wire my_DFF_one_out, my_DFF_two_out, clk1000hz;
    
    my_clock_divider unit_1000hz_clock (.basys_clock(basys_clock), .m_value(49999), 
                                            .my_clock(clk1000hz));

    my_DFF unit_0 (.my_clock(clk1000hz), .D(push_button), .Q(my_DFF_one_out));
    my_DFF unit_1 (.my_clock(clk1000hz), .D(my_DFF_one_out), .Q(my_DFF_two_out));
    
    assign my_SP_out = my_DFF_one_out & ~my_DFF_two_out;

endmodule
