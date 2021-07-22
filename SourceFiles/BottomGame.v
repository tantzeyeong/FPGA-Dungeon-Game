`timescale 1ns / 1ps
module LaserGame(input clock,btnL,btnU,btnD,btnR,
    input [6:0] X, Y,
    output reg [15:0] pixel_data = 0,
    input start_game,
    input [11:0] mic_in,
    output reg end_game = 0,
    output reg [7:0] seg_an3 = 0,seg_an2 = 0,seg_an1 = 0,seg_an0 = 0,
    output reg lose = 0
    );
    reg [15:0] image_background [0:6143];
    initial begin
        $readmemb("BottomGameBackground.txt",image_background);
    end
    
    
    reg [15:0] red_colour = 16'b11111_000000_00000;
    reg [15:0] white_colour = 16'b11111_111111_11111;
    
    reg [6:0] x_player = 48, y_player = 32;
    reg [15:0] border_colour;
    reg [1:0] life_counter = 3;
    reg [31:0] counter_for_movement = 0;
    
    reg [31:0] counter_for_laser1 = 0;
    reg [5:0] laser_option = 0;
    reg [31:0] laser_on_time = 0;
    reg [15:0] laser_colour = 0;
    reg [7:0] laser1_x = 0;
    reg [7:0] laser2_x = 0;
    reg [7:0] laser3_y = 0;
    reg [7:0] laser4_y = 0;
    reg [7:0] laser5_x = 0;
    reg [7:0] laser6_y = 0;
    
    reg [31:0] timer = 0;
    reg [31:0] slow_timer = 0;
    
    reg got_hit = 0;
    reg [31:0] counter_for_got_hit = 0;
    reg [3:0] got_hit_pulse = 0;
    always @ (posedge clock) begin
        if (start_game == 0) begin
            end_game <= 0; //Internal Reset 
            life_counter <= 3;
            x_player <= 48;
            y_player <= 32;
            counter_for_movement <= 0;
            counter_for_laser1 <= 0;
            laser_option <= 0;
            laser_on_time <= 0;
            lose <= 0;
            slow_timer <= 0;
            timer <= 0;
        end
    
        case (life_counter)
            2'b11:
                border_colour <= 16'b00000_111111_00000;
            2'b10:
                border_colour <= 16'b11111_111111_00000;
            2'b01:
                border_colour <= 16'b11111_000000_00000;
            default:
                border_colour <= 16'b11111_111111_11111;
        endcase
    
        if (start_game == 1) begin
            timer = timer + 1;
            if (timer == 6250000) begin
                slow_timer <= slow_timer + 1;
                timer <= 0;
            end
            //////////////////
            if (got_hit == 1) begin //This new got hit block should make the player image blink red when got hit by enemy
                counter_for_got_hit <= counter_for_got_hit + 1;
                if (counter_for_got_hit == 1041666) begin
                    counter_for_got_hit <= 0;
                    got_hit_pulse = got_hit_pulse + 1;
                end
                if (got_hit_pulse == 8) begin
                    got_hit <= 0;
                    counter_for_got_hit <= 0;
                    got_hit_pulse <= 0;
                end
            end
            
            //////////////////
            counter_for_movement = counter_for_movement + 1;
            if (counter_for_movement > 347222) begin // Every 0.053 seconds 
                counter_for_movement = 0;
                if (btnL == 1 && x_player > 1)
                    x_player = x_player - 1;
                else if (btnR == 1 && x_player < 94)
                    x_player = x_player + 1;
                else if (btnU == 1 && y_player > 1)
                    y_player = y_player - 1;
                else if (btnD == 1 && y_player < 62)
                    y_player = y_player + 1;  
            end
            //////////////////
            
            //////////////////
            counter_for_laser1 = counter_for_laser1 + 1;
            if (counter_for_laser1 > 8000000) begin //Every 1.5 second
                counter_for_laser1 <= 0;
                laser_option <= (mic_in % 4) + 1;
                laser1_x <= (mic_in[11:5] % 75) + 20;
                laser2_x <= (mic_in[6:0] % 75) + 20;
                laser3_y <= (mic_in[9:4] % 38) + 16;
                laser4_y <= (mic_in[5:0] % 38) + 16;
                laser5_x <= (mic_in[8:2] % 75) + 20;
                laser6_y <= (mic_in[11:3] % 38) + 16;
            end
            if (laser_option != 0) begin
                laser_on_time = laser_on_time + 1;
                if (laser_on_time > 6250000) begin //Need to be within the timing of counter_for_laser1 activation
                    laser_option <= 0;
                    laser_on_time <= 0;
                end
                else if (laser_on_time <= 2500000)
                    laser_colour <= white_colour;
                else if (laser_on_time > 2500000)
                    laser_colour <= red_colour;            
            end
            //////////////////
            
            //////////////////

            if (X == 94 || X == 95 || Y == 0 || Y == 63)
                pixel_data <= border_colour;
            else if ( (X >= x_player - 1 && X <= x_player + 1 && Y == y_player) || (X == x_player && Y >= y_player - 1 &&  Y <= y_player + 3) )
                if (X == x_player && Y == y_player)
                    pixel_data <= 16'b11111_000000_00000;
                else
                    pixel_data <= (got_hit_pulse % 2) ? 16'b11111_000000_00000 : 16'b11111_111111_00000;
            else if (laser_option != 0) begin
                    case (laser_option)
                    1:begin
                        if ( (X >= laser1_x && X <= (laser1_x + 2)) || (Y >= laser3_y && Y <= (laser3_y + 2)) || (X >= laser2_x && X <= (laser2_x + 2))) begin
                            pixel_data <= laser_colour;
                            if (laser_on_time > 4682500 && ( (x_player >= laser1_x && x_player <= (laser1_x + 2)) || (y_player >= laser3_y && y_player <= (laser3_y + 2))  || (x_player >= laser2_x && x_player <= (laser2_x + 2))) ) begin
                                life_counter <= life_counter - 1;
                                laser_on_time <= 0;
                                laser_option <= 0; 
                            end
                        end
                        else    
                            pixel_data <= image_background[X+(Y*96)];
                    end
                    2:begin
                        if ( (X >= laser1_x && X <= (laser1_x + 2)) || (Y >= laser3_y && Y <= (laser3_y + 2)) || (X >= laser2_x && X <= (laser2_x + 2)) || (Y >= laser4_y && Y <= (laser4_y + 2)) ) begin
                            pixel_data <= laser_colour;
                            if (laser_on_time > 4682500 && ( (x_player >= laser1_x && x_player <= (laser1_x + 2)) || (y_player >= laser3_y && y_player <= (laser3_y + 2))  || (x_player >= laser2_x && x_player <= (laser2_x + 2)) || (y_player >= laser4_y && y_player <= (laser4_y + 2)) ) ) begin
                                life_counter <= life_counter - 1;
                                laser_on_time <= 0;
                                laser_option <= 0; 
                            end
                        end
                        else    
                            pixel_data <= image_background[X+(Y*96)];
                    end  
                    3:begin
                        if ( (X >= laser1_x && X <= (laser1_x + 2)) || (Y >= laser3_y && Y <= (laser3_y + 2)) || (X >= laser2_x && X <= (laser2_x + 2)) || (Y >= laser4_y && Y <= (laser4_y + 2)) || (X >= laser5_x && X <= (laser5_x + 2)) ) begin
                            pixel_data <= laser_colour;
                            if (laser_on_time > 4682500 && ( (x_player >= laser1_x && x_player <= (laser1_x + 2)) || (y_player >= laser3_y && y_player <= (laser3_y + 2))  || (x_player >= laser2_x && x_player <= (laser2_x + 2)) || (y_player >= laser4_y && y_player <= (laser4_y + 2)) || (x_player >= laser5_x && x_player <= (laser5_x + 2)) ) ) begin
                                life_counter <= life_counter - 1;
                                laser_on_time <= 0;
                                laser_option <= 0; 
                            end
                        end
                        else    
                            pixel_data <= image_background[X+(Y*96)];
                    end
                    4:begin
                        if ( (X >= laser1_x && X <= (laser1_x + 2)) || (Y >= laser3_y && Y <= (laser3_y + 2)) || (X >= laser2_x && X <= (laser2_x + 2)) || (Y >= laser4_y && Y <= (laser4_y + 2)) || (X >= laser5_x && X <= (laser5_x + 2)) || (Y >= laser6_y && Y <= (laser6_y + 2)) ) begin
                            pixel_data <= laser_colour;
                            if (laser_on_time > 4682500 && ( (x_player >= laser1_x && x_player <= (laser1_x + 2)) || (y_player >= laser3_y && y_player <= (laser3_y + 2))  || (x_player >= laser2_x && x_player <= (laser2_x + 2)) || (y_player >= laser4_y && y_player <= (laser4_y + 2)) || (x_player >= laser5_x && x_player <= (laser5_x + 2)) || (y_player >= laser6_y && y_player <= (laser6_y + 2)) ) ) begin
                                life_counter <= life_counter - 1;
                                laser_on_time <= 0;
                                laser_option <= 0; 
                            end
                        end
                        else    
                            pixel_data <= image_background[X+(Y*96)];                 
                    end                   
                    endcase
            end
            else
                pixel_data <= image_background[X+(Y*96)];
            //////////////////
            if (slow_timer == 20)
                end_game <= 1;
            else if (life_counter == 0 || slow_timer == 20) begin
                end_game <= 1;
                lose <= 1;
            end
           //////////////////
           //Segment Display coding
           case (life_counter)
           3:begin
               seg_an3 <= 8'b1110_0011; //Letter L
               seg_an2 <= 8'b0000_1101; //Number 3
           end
           2:begin
               seg_an3 <= 8'b1110_0011; //Letter L
               seg_an2 <= 8'b0010_0101; //Number 2             
           end
           1: begin
               seg_an3 <= 8'b1110_0011; //Letter L
               seg_an2 <= 8'b1001_1111; //Number 1             
           end
           default: begin
               seg_an3 <= 8'b0000_0000;
               seg_an2 <= 8'b0000_0000;            
           end                      
           endcase
           
           case (slow_timer)
           0:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0000_0011; //Number 0           
           end
           1:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b1001_1111; //Number 1           
           end
           2:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0010_0101; //Number 2            
           end
           3:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0000_1101; //Number 3            
           end
           4:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b1001_1001; //Number 4         
           end
           5:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0100_1001; //Number 5         
           end
           6:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b1100_0001; //Number 6       
           end
           7:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0001_1111; //Number 7       
           end
           8:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0000_0001; //Number 8       
           end
           9:begin
               seg_an1 <= 8'b0000_0011; //Number 0
               seg_an0 <= 8'b0001_1001; //Number 9       
           end
           10:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0000_0011; //Number 0       
           end
           11:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b1001_1111; //Number 1       
           end
           12:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0010_0101; //Number 2       
           end
           13:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0000_1101; //Number 3       
           end
           14:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b1001_1001; //Number 4       
           end
           15:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0100_1001; //Number 5      
           end
           16:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b1100_0001; //Number 6      
           end
           17:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0001_1111; //Number 7     
           end
           18:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0000_0001; //Number 8    
           end
           19:begin
               seg_an1 <= 8'b1001_1111; //Number 1
               seg_an0 <= 8'b0001_1001; //Number 9    
           end
           default:begin
               seg_an1 <= 8'b0000_0000;
               seg_an0 <= 8'b0000_0000;          
           end
           endcase
        end  
    end 
endmodule