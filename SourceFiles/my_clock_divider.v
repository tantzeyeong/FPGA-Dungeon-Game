`timescale 1ns / 1ps
module my_clock_divider (input basys_clock, input [31:0] m_value, output reg my_clock = 0);

    reg [31:0] count = 0;
    
    always @ (posedge basys_clock) begin
    
        count <= (count == m_value) ? 0 : count + 1;
        
        my_clock <= (count == 0) ? ~my_clock : my_clock;
    
    end

endmodule
