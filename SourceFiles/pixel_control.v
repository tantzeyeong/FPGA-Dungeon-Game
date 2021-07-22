`timescale 1ns / 1ps
module pixel_control(input [15:0] LED, input my_clock, switch_border_size, switch_colour_theme, switch_volume_bar, 
                        switch_right, switch_left, switch_border, input [6:0] X, Y, output reg [15:0] pixel_data);
    
    reg [6:0] x;
    reg [6:0] y;
    reg [4:0] LED_COUNT;
    
    always @ (posedge my_clock) begin
        if (switch_left == 1 && switch_right == 0) begin
            x <= X + 10;
            y <= Y;
            end
        else if (switch_left == 0 && switch_right == 1) begin
            x <= X - 10;
            y <= Y;
            end
        else begin
            x <= X;
            y <= Y;
            end
        
        LED_COUNT = LED[0] + LED[1] + LED[2] + LED[3] + LED[4] + LED[5] + LED[6] + LED[7]
                    + LED[8] + LED[9] + LED[10] + LED[11] + LED[12] + LED[13] + LED[14] + LED[15];
        
        /*if (switch == 0) begin
            if (x == 0 || x == 95) begin
                pixel_data <= 16'b11111_111111_11111;
                end
            else begin
                pixel_data <= 16'b00000_000000_00000;
                end
            end
         
        else if (switch == 1) begin
            if (y >= 0 && y <= 2 || y >= 61 && y <= 63 || x >= 0 && x <= 2 || x >= 93 && x <= 95) begin
                pixel_data <= 16'b11111_111111_11111;
                end
            else begin
                pixel_data <= 16'b00000_000000_00000;
                end
            end*/
        
        /*
        // green bars
        if (((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53) || (y >= 49 && y <= 50) || (y >= 46 && y <= 47) || (y >= 43 && y <= 44)) && (x >= 44 && x <= 49)) begin
            if (switch_volume_bar == 0) begin
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b00000_111111_00000;
                    end
                else begin
                    pixel_data <= 16'b00100_000000_00000;
                    end
                end
            else begin
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b00000_000000_00000;
                    end
                else begin
                    pixel_data <= 16'b00000_000011_00000;
                    end    
                end
            end
        
        // yellow bars
        else if (((y >= 40 && y <= 41) || (y >= 37 && y <= 38) || (y >= 34 && y <= 35) || (y >= 31 && y <= 32) || (y >= 28 && y <= 29)) && (x >= 44 && x <= 49)) begin
            if (switch_volume_bar == 0) begin   
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b11111_111111_00000;
                    end
                else begin
                    pixel_data <= 16'b01100_000000_00000;
                    end
                end
            else begin
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b00000_000000_00000;
                    end
                else begin
                    pixel_data <= 16'b00000_000011_00000;
                    end    
                end
            end
        
        // red bars
        else if (((y >= 25 && y <= 26) || (y >= 22 && y <= 23) || (y >= 19 && y <= 20) || (y >= 16 && y <= 17) || (y >= 13 && y <= 14)) && (x >= 44 && x <= 49)) begin
            if (switch_volume_bar == 0) begin
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b11111_000000_00000;
                    end
                else begin
                    pixel_data <= 16'b11100_000000_00000;
                    end
                end
            else begin
                if (switch_colour_theme == 0) begin
                    pixel_data <= 16'b00000_000000_00000;
                    end
                else begin
                    pixel_data <= 16'b00000_000011_00000;
                    end    
                end
            end
        */
            
        /*
        // green bars
        if (((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53) || (y >= 49 && y <= 50) || (y >= 46 && y <= 47) || (y >= 43 && y <= 44)) && (x >= 45 && x <= 50)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
            
        // yellow bars 
        else if (((y >= 40 && y <= 41) || (y >= 37 && y <= 38) || (y >= 34 && y <= 35) || (y >= 31 && y <= 32) || (y >= 28 && y <= 29)) && (x >= 45 && x <= 50)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        
        // red bars 
        else if (((y >= 25 && y <= 26) || (y >= 22 && y <= 23) || (y >= 19 && y <= 20) || (y >= 16 && y <= 17) || (y >= 13 && y <= 14)) && (x >= 45 && x <= 50)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        */
        
        
        // green bars
        if ((LED_COUNT == 5'd1) && (x >= 45 && x <= 50) && (y >= 58 && y <= 59)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd2) && (x >= 45 && x <= 50) && ((y >= 58 && y <= 59) || (y >= 55 && y <= 56))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd3) && (x >= 45 && x <= 50) && ((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd4) && (x >= 45 && x <= 50) && ((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53) || (y >= 49 && y <= 50))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd5) && (x >= 45 && x <= 50) && ((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53) || (y >= 49 && y <= 50) || (y >= 46 && y <= 47))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT >= 5'd6) && (x >= 45 && x <= 50) && ((y >= 58 && y <= 59) || (y >= 55 && y <= 56) || (y >= 52 && y <= 53) || (y >= 49 && y <= 50) || (y >= 46 && y <= 47) || (y >= 43 && y <= 44))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b00000_111111_00000 : 16'b00100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000; 
            end
        
        
        // yellow bars
        else if ((LED_COUNT == 5'd7) && (x >= 45 && x <= 50) && (y >= 40 && y <= 41)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;            
            end
        else if ((LED_COUNT == 5'd8) && (x >= 45 && x <= 50) && ((y >= 40 && y <= 41) || (y >= 37 && y <= 38))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;            
            end
        else if ((LED_COUNT == 5'd9) && (x >= 45 && x <= 50) && ((y >= 40 && y <= 41) || (y >= 37 && y <= 38) || (y >= 34 && y <= 35))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;                        
            end
        else if ((LED_COUNT == 5'd10) && (x >= 45 && x <= 50) && ((y >= 40 && y <= 41) || (y >= 37 && y <= 38) || (y >= 34 && y <= 35) || (y >= 31 && y <= 32))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;                        
            end
        else if ((LED_COUNT >= 5'd11) && (x >= 45 && x <= 50) && ((y >= 40 && y <= 41) || (y >= 37 && y <= 38) || (y >= 34 && y <= 35) || (y >= 31 && y <= 32) || (y >= 28 && y <= 29))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_111111_00000 : 16'b01100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;                        
            end
            
            
        // red bars
        else if ((LED_COUNT == 5'd12) && (x >= 45 && x <= 50) && (y >= 25 && y <= 26)) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd13) && (x >= 45 && x <= 50) && ((y >= 25 && y <= 26) || (y >= 22 && y <= 23))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd14) && (x >= 45 && x <= 50) && ((y >= 25 && y <= 26) || (y >= 22 && y <= 23) || (y >= 19 && y <= 20))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd15) && (x >= 45 && x <= 50) && ((y >= 25 && y <= 26) || (y >= 22 && y <= 23) || (y >= 19 && y <= 20) || (y >= 16 && y <= 17))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        else if ((LED_COUNT == 5'd16) && (x >= 45 && x <= 50) && ((y >= 25 && y <= 26) || (y >= 22 && y <= 23) || (y >= 19 && y <= 20) || (y >= 16 && y <= 17) || (y >= 13 && y <= 14))) begin
            pixel_data <= switch_volume_bar == 0 ? ((switch_colour_theme == 0) ? 16'b11111_000000_00000 : 16'b11100_000000_00000) : (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
        
        
        // 1-pixel borders
        else if (switch_border_size == 0 && (((y >= 1 && y <= 62) && (X == 0 || X == 93)) || ((y == 1 || y == 62) && (X >= 0 && X <= 93)))) begin
            pixel_data <= (switch_colour_theme == 0) ? ((switch_border == 0) ? 16'b11111_111111_11111 : 16'b00000_000000_00000) : ((switch_border == 0) ? 16'b00000_000111_11111 : 16'b00000_000011_00000);
            end
        
        
        // 3-pixel borders
        else if (switch_border_size == 1 && (((y >= 1 && y <= 62) && (X == 0 || X == 93)) || ((y == 1 || y == 62) && (X >= 0 && X <= 93)) ||
                                       ((y >= 2 && y <= 61) && (X == 1 || X == 92)) || ((y == 2 || y == 61) && (X >= 1 && X <= 92)) ||
                                       ((y >= 3 && y <= 60) && (X == 2 || X == 91)) || ((y == 3 || y == 60) && (X >= 2 && X <= 91)))) begin
            pixel_data <= (switch_colour_theme == 0) ? ((switch_border == 0) ? 16'b11111_111111_11111 : 16'b00000_000000_00000) : ((switch_border == 0) ? 16'b00000_000111_11111 : 16'b00000_000011_00000);
            end
        
        
        // background
        else begin
            pixel_data <= (switch_colour_theme == 0) ? 16'b00000_000000_00000 : 16'b00000_000011_00000;
            end
    end

endmodule
