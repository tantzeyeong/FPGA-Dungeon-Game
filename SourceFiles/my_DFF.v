`timescale 1ns / 1ps
module my_DFF(input my_clock, input D, output reg Q = 0);

    always @ (posedge my_clock) begin
        Q <= D;
    end

endmodule
