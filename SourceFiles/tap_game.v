`timescale 1ns / 1ps


module tap_game(input my_6p25mhz_clock, start_game, btnU, btnD, btnL, btnR, btnC, input [6:0] X, Y, 
                    input [11:0] mic_in, output reg [15:0] pixel_data, output reg end_game = 0,
                    output reg [7:0] seg_an3 = 0,seg_an2 = 0,seg_an1 = 0,seg_an0 = 0,
                    output reg lose = 0);
    
        
reg [15:0] top_arrow [0:71];
reg [15:0] down_arrow [0:71];
reg [15:0] left_arrow [0:71];
reg [15:0] right_arrow [0:71];
reg [15:0] tap_game_background [0:6015];

reg [4:0] arrow_count = 0;
reg [4:0] arrow_index = 0;
reg [4:0] num_of_arrows = 0;
reg [4:0] arrow [0:9];
reg [6:0] x_arrow [0:9];
reg [6:0] y_arrow [0:9];
reg [2:0] arrow_pattern = 0;

reg [4:0] score = 0;
reg [4:0] fail = 0;

reg die = 0;

reg left_button_pressed;
reg top_button_pressed;
reg right_button_pressed;
reg down_button_pressed;

initial begin
    $readmemb("tap_game_background.txt",tap_game_background);
    $readmemb("top_arrow.txt",top_arrow);
    $readmemb("down_arrow.txt",down_arrow);
    $readmemb("left_arrow.txt",left_arrow);
    $readmemb("right_arrow.txt",right_arrow);
end

initial begin
    arrow [0] = 0;
    arrow [1] = 0;
    arrow [2] = 0;
    arrow [3] = 0;
    arrow [4] = 0;
    arrow [5] = 0;
    arrow [6] = 0;
    arrow [7] = 0;
    arrow [8] = 0;
    arrow [9] = 0;
end

reg [31:0] counter_for_pulse = 0; //For 1khz pulse button signals
reg [31:0] counter_for_spawn = 0;
reg [31:0] counter_for_arrow_movement = 0;
reg [31:0] counter_left_blink = 0;
reg [31:0] counter_top_blink = 0;
reg [31:0] counter_right_blink = 0;
reg [31:0] counter_down_blink = 0;
reg [31:0] counter_arrow_pattern = 0;
reg [31:0] counter_for_end = 0;

reg [3:0] blink_seq_end = 0;

always @ (posedge my_6p25mhz_clock) begin
    if (start_game == 0) begin
        end_game = 0;
        arrow_count = 0;
        arrow_index = 0;
        num_of_arrows = 0;
        arrow[0] = 0;
        arrow[1] = 0;
        arrow[2] = 0;
        arrow[3] = 0;
        arrow[4] = 0;
        arrow[5] = 0;
        arrow[6] = 0;
        arrow[7] = 0;
        arrow[8] = 0;
        arrow[9] = 0;
        
        y_arrow[0] = 55;
        y_arrow[1] = 55;
        y_arrow[2] = 55;
        y_arrow[3] = 55;
        y_arrow[4] = 55;
        y_arrow[5] = 55;
        y_arrow[6] = 55;
        y_arrow[7] = 55;
        y_arrow[8] = 55;
        y_arrow[9] = 55;
        
        x_arrow[0] = 6;
        x_arrow[1] = 6;
        x_arrow[2] = 6;
        x_arrow[3] = 6;
        x_arrow[4] = 6;
        x_arrow[5] = 6;
        x_arrow[6] = 6;
        x_arrow[7] = 6;
        x_arrow[8] = 6;
        x_arrow[9] = 6;
        
        arrow_pattern = 0;
        score = 0;
        fail = 0;
        left_button_pressed = 0;
        top_button_pressed = 0;
        right_button_pressed = 0;
        down_button_pressed = 0;
        lose = 0;
        die = 0;
        counter_for_pulse = 0; //For 1khz pulse button signals
        counter_for_spawn = 0;
        counter_for_arrow_movement = 0;
        counter_left_blink = 0;
        counter_top_blink = 0;
        counter_right_blink = 0;
        counter_down_blink = 0;
        counter_arrow_pattern = 0;
        counter_for_end = 0;
        blink_seq_end = 0;
        end
        
        
    if (start_game == 1) begin
        counter_for_pulse = counter_for_pulse + 1; //To sync single pulse btn inputs to 1khz working frequency
        counter_for_spawn = counter_for_spawn + 1;
        counter_for_arrow_movement <= counter_for_arrow_movement + 1;
               
        // border glowing
        if (btnL == 1) begin
            left_button_pressed <= 1;
            end
        if (btnU == 1) begin
            top_button_pressed <= 1;
            end
        if (btnR == 1) begin
            right_button_pressed <= 1;
            end
        if (btnD == 1) begin
            down_button_pressed <= 1;
            end
        
        if (left_button_pressed == 1) begin
            counter_left_blink = counter_left_blink + 1;
            if (counter_left_blink == 3125000) begin
                counter_left_blink <= 0;
                left_button_pressed <= 0;
                end
            end
        
        if (top_button_pressed == 1) begin
            counter_top_blink = counter_top_blink + 1;
            if (counter_top_blink == 3125000) begin
                counter_top_blink <= 0;
                top_button_pressed <= 0;
                end
            end
            
        if (right_button_pressed == 1) begin
            counter_right_blink = counter_right_blink + 1;
            if (counter_right_blink == 3125000) begin
                counter_right_blink <= 0;
                right_button_pressed <= 0;
                end
            end
            
        if (down_button_pressed == 1) begin
            counter_down_blink = counter_down_blink + 1;
            if (counter_down_blink == 3125000) begin
                counter_down_blink <= 0;
                down_button_pressed <= 0;
                end
            end
            
            
        // arrow refresh
        if (arrow_count == 10) begin
            arrow_count = 0;
            end
        
        if (arrow_index == 10) begin
            arrow_index = 0;
            end
        
        
        // button functions
        if (counter_for_pulse == 6250) begin
            counter_for_pulse <= 0;
            
            if (y_arrow[arrow_index] >= 3 && y_arrow[arrow_index] <= 7 && y_arrow[arrow_index] != 0) begin
                if (btnL == 1) begin
                    if (arrow[arrow_index] == 1) begin
                        arrow[arrow_index] <= 0;
                        score <= score + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    else begin
                        arrow[arrow_index] <= 0;
                        fail <= fail + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    end
                else if (btnU == 1) begin
                    if (arrow[arrow_index] == 2) begin
                        arrow[arrow_index] <= 0;
                        score <= score + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    else begin
                        arrow[arrow_index] <= 0;
                        fail <= fail + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    end
                else if (btnR == 1) begin
                    if (arrow[arrow_index] == 3) begin
                        arrow[arrow_index] <= 0;
                        score <= score + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    else begin
                        arrow[arrow_index] <= 0;
                        fail <= fail + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    end
                else if (btnD == 1) begin
                    if (arrow[arrow_index] == 4) begin
                        arrow[arrow_index] <= 0;
                        score <= score + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    else begin
                        arrow[arrow_index] <= 0;
                        fail <= fail + 1;
                        arrow_index <= arrow_index + 1;
                        end
                    end
                end       
            else if (y_arrow[arrow_index] >= 8 && y_arrow[arrow_index] <= 12 && y_arrow[arrow_index] != 0) begin
                if (btnL == 1 || btnU == 1 || btnR == 1 || btnD == 1) begin
                    arrow[arrow_index] <= 0;
                    fail <= fail + 1;
                    arrow_index <= arrow_index + 1;
                    end
                end
            end
            
        
        // auto-killing arrows
        if (y_arrow[arrow_index] == 2) begin
            arrow[arrow_index] <= 0;
            fail <= fail + 1;
            arrow_index <= arrow_index + 1;
            end
            
            
        // arrow movement    
        if (counter_for_arrow_movement == 300000) begin
            counter_for_arrow_movement <= 0;
            
            if (arrow[0] != 0) begin
                y_arrow[0] <= y_arrow[0] - 1;
                end
            if (arrow[1] != 0) begin
                y_arrow[1] <= y_arrow[1] - 1;
                end
            if (arrow[2] != 0) begin
                y_arrow[2] <= y_arrow[2] - 1;
                end
            if (arrow[3] != 0) begin
                y_arrow[3] <= y_arrow[3] - 1;
                end
            if (arrow[4] != 0) begin
                y_arrow[4] <= y_arrow[4] - 1;
                end
            if (arrow[5] != 0) begin
                y_arrow[5] <= y_arrow[5] - 1;
                end
            if (arrow[6] != 0) begin
                y_arrow[6] <= y_arrow[6] - 1;
                end
            if (arrow[7] != 0) begin
                y_arrow[7] <= y_arrow[7] - 1;
                end
            if (arrow[8] != 0) begin
                y_arrow[8] <= y_arrow[8] - 1;
                end
            if (arrow[9] != 0) begin
                y_arrow[9] <= y_arrow[9] - 1;
                end
            end
        
        
        // arrow spawn pattern
        counter_arrow_pattern = counter_arrow_pattern + 1;
            
        if (counter_arrow_pattern >= 6250000) begin
            counter_arrow_pattern <= 0;
            
            arrow_pattern <= mic_in % 12;
            end
        
        
        // spawning arrows
        if (num_of_arrows != 20 && counter_for_spawn >= ((arrow_pattern >= 0 && arrow_pattern <= 3) ? 10000000 : (arrow_pattern >= 4 && arrow_pattern <= 7) ? 8000000 : 6000000)) begin
            counter_for_spawn <= 0;
            
            if (mic_in % 4 == 0) begin
                arrow[arrow_count] <= 1;
                x_arrow[arrow_count] <= 6;
                y_arrow[arrow_count] <= 55;
                arrow_count <= arrow_count + 1;
                num_of_arrows <= num_of_arrows + 1;
                end
            else if (mic_in % 4 == 1) begin
                arrow[arrow_count] <= 2;
                x_arrow[arrow_count] <= 21;
                y_arrow[arrow_count] <= 55;
                arrow_count <= arrow_count + 1;
                num_of_arrows <= num_of_arrows + 1;
                end
            else if (mic_in % 4 == 2) begin
                arrow[arrow_count] <= 3;
                x_arrow[arrow_count] <= 36;
                y_arrow[arrow_count] <= 55;
                arrow_count <= arrow_count + 1;
                num_of_arrows <= num_of_arrows + 1;
                end
            else begin
                arrow[arrow_count] <= 4;
                x_arrow[arrow_count] <= 51;
                y_arrow[arrow_count] <= 55;
                arrow_count <= arrow_count + 1;
                num_of_arrows <= num_of_arrows + 1;
                end
            end
            
            
        // win-lose condition         
        if ( (score + fail) >= 20 && score <= 14) begin
            die = 1;
            end
        
        if ((score + fail) >= 20 && die == 1) begin
            counter_for_end = counter_for_end + 1;
            
            if (counter_for_end == 3125000) begin
                counter_for_end <= 0;
                blink_seq_end <= blink_seq_end + 1;
                end
                
            if (blink_seq_end == 7) begin
                blink_seq_end = 0;
                end_game <= 1;
                lose <= 1;
                end
            end
            
        if ((score + fail) >= 20 && die == 0) begin
            counter_for_end = counter_for_end + 1;
            
            if (counter_for_end == 3125000) begin
                counter_for_end <= 0;
                blink_seq_end <= blink_seq_end + 1;
                end
                
            if (blink_seq_end == 7) begin
                blink_seq_end = 0;
                end_game <= 1;
                end
            end
            
            
        // pixel_data
        if ((X >= x_arrow[9] && X <= x_arrow[9] + 8) && (Y >= y_arrow[9] && Y <= y_arrow[9] + 7) && (arrow[9] != 0 && arrow[9] != 5)) begin
            if (arrow[9] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[9]) + (Y-y_arrow[9])*9];
                end
            else if (arrow[9] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[9]) + (Y-y_arrow[9])*9];
                end
            else if (arrow[9] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[9]) + (Y-y_arrow[9])*9];
                end
            else if (arrow[9] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[9]) + (Y-y_arrow[9])*9];
                end
            end
        
        else if ((X >= x_arrow[8] && X <= x_arrow[8] + 8) && (Y >= y_arrow[8] && Y <= y_arrow[8] + 7) && (arrow[8] != 0 && arrow[8] != 5)) begin
            if (arrow[8] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[8]) + (Y-y_arrow[8])*9];
                end
            else if (arrow[8] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[8]) + (Y-y_arrow[8])*9];
                end
            else if (arrow[8] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[8]) + (Y-y_arrow[8])*9];
                end
            else if (arrow[8] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[8]) + (Y-y_arrow[8])*9];
                end
            end
        
        else if ((X >= x_arrow[7] && X <= x_arrow[7] + 8) && (Y >= y_arrow[7] && Y <= y_arrow[7] + 7) && (arrow[7] != 0 && arrow[7] != 5)) begin
            if (arrow[7] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[7]) + (Y-y_arrow[7])*9];
                end
            else if (arrow[7] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[7]) + (Y-y_arrow[7])*9];
                end
            else if (arrow[7] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[7]) + (Y-y_arrow[7])*9];
                end
            else if (arrow[7] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[7]) + (Y-y_arrow[7])*9];
                end
            end
        
        else if ((X >= x_arrow[6] && X <= x_arrow[6] + 8) && (Y >= y_arrow[6] && Y <= y_arrow[6] + 7) && (arrow[6] != 0 && arrow[6] != 5)) begin
            if (arrow[6] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[6]) + (Y-y_arrow[6])*9];
                end
            else if (arrow[6] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[6]) + (Y-y_arrow[6])*9];
                end
            else if (arrow[6] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[6]) + (Y-y_arrow[6])*9];
                end
            else if (arrow[6] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[6]) + (Y-y_arrow[6])*9];
                end
            end
        
        else if ((X >= x_arrow[5] && X <= x_arrow[5] + 8) && (Y >= y_arrow[5] && Y <= y_arrow[5] + 7) && (arrow[5] != 0 && arrow[5] != 5)) begin
            if (arrow[5] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[5]) + (Y-y_arrow[5])*9];
                end
            else if (arrow[5] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[5]) + (Y-y_arrow[5])*9];
                end
            else if (arrow[5] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[5]) + (Y-y_arrow[5])*9];
                end
            else if (arrow[5] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[5]) + (Y-y_arrow[5])*9];
                end
            end
        
        else if ((X >= x_arrow[4] && X <= x_arrow[4] + 8) && (Y >= y_arrow[4] && Y <= y_arrow[4] + 7) && (arrow[4] != 0 && arrow[4] != 5)) begin
            if (arrow[4] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[4]) + (Y-y_arrow[4])*9];
                end
            else if (arrow[4] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[4]) + (Y-y_arrow[4])*9];
                end
            else if (arrow[4] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[4]) + (Y-y_arrow[4])*9];
                end
            else if (arrow[4] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[4]) + (Y-y_arrow[4])*9];
                end
            end
        
        else if ((X >= x_arrow[3] && X <= x_arrow[3] + 8) && (Y >= y_arrow[3] && Y <= y_arrow[3] + 7) && (arrow[3] != 0 && arrow[3] != 5)) begin
            if (arrow[3] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[3]) + (Y-y_arrow[3])*9];
                end
            else if (arrow[3] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[3]) + (Y-y_arrow[3])*9];
                end
            else if (arrow[3] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[3]) + (Y-y_arrow[3])*9];
                end
            else if (arrow[3] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[3]) + (Y-y_arrow[3])*9];
                end
            end
        
        else if ((X >= x_arrow[2] && X <= x_arrow[2] + 8) && (Y >= y_arrow[2] && Y <= y_arrow[2] + 7) && (arrow[2] != 0 && arrow[2] != 5)) begin
            if (arrow[2] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[2]) + (Y-y_arrow[2])*9];
                end
            else if (arrow[2] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[2]) + (Y-y_arrow[2])*9];
                end
            else if (arrow[2] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[2]) + (Y-y_arrow[2])*9];
                end
            else if (arrow[2] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[2]) + (Y-y_arrow[2])*9];
                end
            end
            
        else if ((X >= x_arrow[1] && X <= x_arrow[1] + 8) && (Y >= y_arrow[1] && Y <= y_arrow[1] + 7) && (arrow[1] != 0 && arrow[1] != 5)) begin
            if (arrow[1] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[1]) + (Y-y_arrow[1])*9];
                end
            else if (arrow[1] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[1]) + (Y-y_arrow[1])*9];
                end
            else if (arrow[1] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[1]) + (Y-y_arrow[1])*9];
                end
            else if (arrow[1] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[1]) + (Y-y_arrow[1])*9];
                end
            end
            
        else if ((X >= x_arrow[0] && X <= x_arrow[0] + 8) && (Y >= y_arrow[0] && Y <= y_arrow[0] + 7) && (arrow[0] != 0 && arrow[0] != 5)) begin
            if (arrow[0] == 1) begin
                pixel_data <= left_arrow[(X-x_arrow[0]) + (Y-y_arrow[0])*9];
                end
            else if (arrow[0] == 2) begin
                pixel_data <= top_arrow[(X-x_arrow[0]) + (Y-y_arrow[0])*9];
                end
            else if (arrow[0] == 3) begin
                pixel_data <= right_arrow[(X-x_arrow[0]) + (Y-y_arrow[0])*9];
                end
            else if (arrow[0] == 4) begin
                pixel_data <= down_arrow[(X-x_arrow[0]) + (Y-y_arrow[0])*9];
                end
            end
            
        else if (left_button_pressed == 1 && ((((X >= 4 && X <= 5) || (X >= 15 && X <= 16)) && (Y >= 2 && Y <= 13)) || ((X >= 4 && X <= 16) && ((Y >= 2 && Y <= 3) || (Y >= 12 && Y <= 13))))) begin
            pixel_data <= 16'b11111_111111_00000;
            end
            
        else if (top_button_pressed == 1 && ((((X >= 19 && X <= 20) || (X >= 30 && X <= 31)) && (Y >= 2 && Y <= 13)) || ((X >= 19 && X <= 31) && ((Y >= 2 && Y <= 3) || (Y >= 12 && Y <= 13))))) begin
            pixel_data <= 16'b11111_111111_00000;
            end
            
        else if (right_button_pressed == 1 && ((((X >= 34 && X <= 35) || (X >= 45 && X <= 46)) && (Y >= 2 && Y <= 13)) || ((X >= 34 && X <= 46) && ((Y >= 2 && Y <= 3) || (Y >= 12 && Y <= 13))))) begin
            pixel_data <= 16'b11111_111111_00000;
            end
            
        else if (down_button_pressed == 1 && ((((X >= 49 && X <= 50) || (X >= 60 && X <= 61)) && (Y >= 2 && Y <= 13)) || ((X >= 49 && X <= 61) && ((Y >= 2 && Y <= 3) || (Y >= 12 && Y <= 13))))) begin
            pixel_data <= 16'b11111_111111_00000;
            end
        
        else if (X != 94 || X != 95) begin
            pixel_data <= tap_game_background[X+(Y*94)];
            end
        
        else begin
            pixel_data <= 16'b00000_000000_00000;
            end
            
        //Segment Display coding
           case (score)
                0:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0           
                end
                1:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1           
                end
                2:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0010_0101; //Number 2            
                end
                3:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_1101; //Number 3            
                end
                4:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1001; //Number 4         
                end
                5:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0100_1001; //Number 5         
                end
                6:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1100_0001; //Number 6       
                end
                7:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0001_1111; //Number 7       
                end
                8:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0001; //Number 8       
                end
                9:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0001_1001; //Number 9       
                end
                10:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0       
                end
                11:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1       
                end
                12:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0010_0101; //Number 2       
                end
                13:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_1101; //Number 3       
                end
                14:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1001; //Number 4       
                end
                15:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0100_1001; //Number 5      
                end
                16:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1100_0001; //Number 6      
                end
                17:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0001_1111; //Number 7     
                end
                18:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0001; //Number 8    
                end
                19:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b1001_1111; //Number 1
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0001_1001; //Number 9    
                end
                20:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0010_0101; //Number 2
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0   
                end                
                default:begin
                    seg_an3 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0000;
                    seg_an2 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0000;          
                end        
            endcase 
            seg_an1 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0010_0101; //Number 2
            seg_an0 <= (blink_seq_end % 2 == 1) ? 8'b1111_1111 : 8'b0000_0011; //Number 0    
        end
    end
endmodule
