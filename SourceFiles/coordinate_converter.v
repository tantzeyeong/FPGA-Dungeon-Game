`timescale 1ns / 1ps
module coordinate_converter(input my_clock, switch_right, switch_left, input [12:0] pixel_index, output reg [6:0] x, y);

    always @ (posedge my_clock) begin
       /* if (switch_left == 0 && switch_right == 1) begin
            x <= (pixel_index % 96) + 4;
            y <= pixel_index / 96;
            end
        else if (switch_left == 1 && switch_right == 0) begin
            x <= (pixel_index % 96) - 4;
            y <= pixel_index / 96;
            end
        else begin*/
            x <= pixel_index % 96;
            y <= pixel_index / 96;
      //      end       
    end

endmodule
