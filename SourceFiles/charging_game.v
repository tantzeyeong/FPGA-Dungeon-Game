`timescale 1ns / 1ps

module charging_game(input my_6p25mhz_clock, start_game, btnU, btnD, btnL, btnR, btnC, input [6:0] X, Y,
                        input [15:0] LED, input [11:0] mic_in, output reg [15:0] pixel_data, output reg end_game = 0,
                        output reg [7:0] seg_an3 = 0,seg_an2 = 0,seg_an1 = 0,seg_an0 = 0,
                        output reg lose = 0);

reg [15:0] plug [0:575];
reg [15:0] plug_damaged [0:575];
reg [15:0] warning_sign [0:227];
reg [15:0] gun [0:90];
reg [15:0] charging_game_background [0:6015];

initial begin
    $readmemb("plug.txt",plug);
    $readmemb("plug_damaged.txt",plug_damaged);
    $readmemb("warning_sign.txt",warning_sign);
    $readmemb("gun.txt",gun);
    $readmemb("charging_game_background.txt",charging_game_background);
end

reg [6:0] x_player = 60;
reg [6:0] y_player = 32;

reg [6:0] x_gun = 3;
reg [6:0] y_gun = 5;

reg gun_direction = 0;

reg [4:0] bullet_count = 0;
reg [2:0] bullet [0:9];
reg [6:0] x_bullet [0:9];
reg [6:0] y_bullet [0:9];

reg [3:0] charging_meter = 1;

reg [4:0] LED_COUNT;

reg [2:0] lives = 3;
reg take_damage = 0;

reg die = 0;
reg [6:0] timer = 30;
reg [3:0] bullet_pattern = 0;

reg [2:0] blink_seq_success = 0;
reg [2:0] blink_seq_failure = 0;
reg [2:0] blink_seq_damage = 0;

reg [31:0] counter_blinking = 0;
reg [31:0] counter_charging = 0;
reg [31:0] counter_discharging = 0;
reg [31:0] counter_for_spawn = 0;
reg [31:0] counter_for_damage = 0;
reg [31:0] counter_for_gun_movement = 0;
reg [31:0] counter_for_bullet_movement = 0;
reg [31:0] counter_bullet_refresh = 0;
reg [31:0] counter_player_movement = 0;
reg [31:0] counter_timer = 0;
reg [31:0] counter_bullet_pattern = 0;

always @ (posedge my_6p25mhz_clock) begin
    if (start_game == 0) begin
         end_game = 0;
         x_gun = 3;
         y_gun = 5;
         x_player = 60;
         y_player = 32;
         charging_meter = 1;
         lives = 3;
         lose = 0;
         die = 0;
         timer = 30;
         bullet_pattern = 0;
         blink_seq_success = 0;
         blink_seq_failure = 0;
         blink_seq_damage = 0;
         bullet [0] = 0;
         bullet [1] = 0;
         bullet [2] = 0;
         bullet [3] = 0;
         bullet [4] = 0;
         bullet [5] = 0;
         bullet [6] = 0;
         bullet [7] = 0;
         bullet [8] = 0;
         bullet [9] = 0;
         counter_blinking = 0;
         counter_charging = 0;
         counter_discharging = 0;
         counter_for_spawn = 0;
         counter_for_damage = 0;
         counter_for_gun_movement = 0;
         counter_for_bullet_movement = 0;
         counter_bullet_refresh = 0;
         counter_player_movement = 0;
         counter_timer = 0;
         counter_bullet_pattern = 0;
    end
    
    LED_COUNT = LED[0] + LED[1] + LED[2] + LED[3] + LED[4] + LED[5] + LED[6] + LED[7]
                    + LED[8] + LED[9] + LED[10] + LED[11] + LED[12] + LED[13] + LED[14] + LED[15];
    
    if (start_game == 1) begin
        
        // taking damage
        if (lives != 0 && bullet[0] != 0 && ( ((y_bullet[0] >= y_player && y_bullet[0] <= y_player + 11) && (x_bullet[0] >= x_player && x_bullet[0] <= x_player + 8)) || ( ((y_bullet[0] >= y_player + 12 && y_bullet[0] <= y_player + 30) && (x_bullet[0] >= x_player + 3 && x_bullet[0] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[0] = 0;
            end
            
        if (lives != 0 && bullet[1] != 0 && ( ((y_bullet[1] >= y_player && y_bullet[1] <= y_player + 11) && (x_bullet[1] >= x_player && x_bullet[1] <= x_player + 8)) || ( ((y_bullet[1] >= y_player + 12 && y_bullet[1] <= y_player + 30) && (x_bullet[1] >= x_player + 3 && x_bullet[1] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[1] = 0;
            end
            
        if (lives != 0 && bullet[2] != 0 && ( ((y_bullet[2] >= y_player && y_bullet[2] <= y_player + 11) && (x_bullet[2] >= x_player && x_bullet[2] <= x_player + 8)) || ( ((y_bullet[2] >= y_player + 12 && y_bullet[2] <= y_player + 30) && (x_bullet[2] >= x_player + 3 && x_bullet[2] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[2] = 0;
            end
            
        if (lives != 0 && bullet[3] != 0 && ( ((y_bullet[3] >= y_player && y_bullet[3] <= y_player + 11) && (x_bullet[3] >= x_player && x_bullet[3] <= x_player + 8)) || ( ((y_bullet[3] >= y_player + 12 && y_bullet[3] <= y_player + 30) && (x_bullet[3] >= x_player + 3 && x_bullet[3] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[3] = 0;
            end
            
        if (lives != 0 && bullet[4] != 0 && ( ((y_bullet[4] >= y_player && y_bullet[4] <= y_player + 11) && (x_bullet[4] >= x_player && x_bullet[4] <= x_player + 8)) || ( ((y_bullet[4] >= y_player + 12 && y_bullet[4] <= y_player + 30) && (x_bullet[4] >= x_player + 3 && x_bullet[4] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[4] = 0;
            end
            
        if (lives != 0 && bullet[5] != 0 && ( ((y_bullet[5] >= y_player && y_bullet[5] <= y_player + 11) && (x_bullet[5] >= x_player && x_bullet[5] <= x_player + 8)) || ( ((y_bullet[5] >= y_player + 12 && y_bullet[5] <= y_player + 30) && (x_bullet[5] >= x_player + 3 && x_bullet[5] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[5] = 0;
            end
        
        if (lives != 0 && bullet[6] != 0 && ( ((y_bullet[6] >= y_player && y_bullet[6] <= y_player + 11) && (x_bullet[6] >= x_player && x_bullet[6] <= x_player + 8)) || ( ((y_bullet[6] >= y_player + 12 && y_bullet[6] <= y_player + 30) && (x_bullet[6] >= x_player + 3 && x_bullet[6] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[6] = 0;
            end
        
        if (lives != 0 && bullet[7] != 0 && ( ((y_bullet[7] >= y_player && y_bullet[7] <= y_player + 11) && (x_bullet[7] >= x_player && x_bullet[7] <= x_player + 8)) || ( ((y_bullet[7] >= y_player + 12 && y_bullet[7] <= y_player + 30) && (x_bullet[7] >= x_player + 3 && x_bullet[7] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[7] = 0;
            end
            
        if (lives != 0 && bullet[8] != 0 && ( ((y_bullet[8] >= y_player && y_bullet[8] <= y_player + 11) && (x_bullet[8] >= x_player && x_bullet[8] <= x_player + 8)) || ( ((y_bullet[8] >= y_player + 12 && y_bullet[8] <= y_player + 30) && (x_bullet[8] >= x_player + 3 && x_bullet[8] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[8] = 0;
            end
            
        if (lives != 0 && bullet[9] != 0 && ( ((y_bullet[9] >= y_player && y_bullet[9] <= y_player + 11) && (x_bullet[9] >= x_player && x_bullet[9] <= x_player + 8)) || ( ((y_bullet[9] >= y_player + 12 && y_bullet[9] <= y_player + 30) && (x_bullet[9] >= x_player + 3 && x_bullet[9] <= x_player + 5))) )) begin
            lives <= lives - 1;
            take_damage <= 1;
            counter_for_damage <= 0;
            blink_seq_damage <= 0;
            bullet[9] = 0;
            end
        
        if (take_damage == 1) begin
            counter_for_damage = counter_for_damage + 1;
            
            if (counter_for_damage == 1000000) begin
                counter_for_damage <= 0;
                blink_seq_damage <= blink_seq_damage + 1;
                end
                
            if (blink_seq_damage == 7) begin
                take_damage <= 0;
                counter_for_damage <= 0;
                blink_seq_damage <= 0;
                end
            end
        
        
        // gun movement
        if (charging_meter != 10 && die == 0) begin
            counter_for_gun_movement = counter_for_gun_movement + 1;
            
            if (counter_for_gun_movement >= 700000) begin
                counter_for_gun_movement <= 0;
                
                if (y_gun == 30) begin
                    gun_direction = 1;
                    end
                    
                else if (y_gun == 4) begin
                    gun_direction = 0;
                    end
                
                if (gun_direction == 0) begin
                    y_gun <= y_gun + 1;
                    end
                    
                else begin
                    y_gun <= y_gun - 1;
                    end
                end
            end
            
            
        // bullet spawn pattern
        if (charging_meter != 10 && die == 0) begin
            counter_bullet_pattern = counter_bullet_pattern + 1;
            end
            
        if (counter_bullet_pattern == 31250000) begin
            counter_bullet_pattern <= 0;
            bullet_pattern <= mic_in % 10;
            end

        
        // spawning bullets
        if (charging_meter != 10 && die == 0) begin
            counter_for_spawn = counter_for_spawn + 1;
            end
        
        if (counter_for_spawn >= ((bullet_pattern >= 0 && bullet_pattern <= 1) ? 16000000 : (bullet_pattern >= 2 && bullet_pattern <= 3) ? 900000 : (bullet_pattern >= 4 && bullet_pattern <= 5) ? 19000000 : 18000000)) begin
            counter_for_spawn <= 0;
            
            if (bullet[bullet_count] == 0) begin
                    bullet[bullet_count] <= 1;
                    x_bullet[bullet_count] <= x_gun + 12;
                    y_bullet[bullet_count] <= y_gun + 1;
                    bullet_count <= bullet_count + 1;
                    end
            end
            

        // refreshing bullets
        if (bullet[bullet_count] != 0) begin
            bullet_count = bullet_count + 1;
            end
            
        if (bullet_count >= 10) begin
            bullet_count = 0;
            end

            
        // bullet movement
        if (charging_meter != 10 && die == 0) begin
            counter_for_bullet_movement = counter_for_bullet_movement + 1;
            end
        
        if (counter_for_bullet_movement == 250000) begin
            counter_for_bullet_movement <= 0;
            
            if (bullet[0] != 0) begin
                x_bullet[0] = x_bullet[0] + 1;
                end
            if (bullet[1] != 0) begin
                x_bullet[1] = x_bullet[1] + 1;
                end
            if (bullet[2] != 0) begin
                x_bullet[2] = x_bullet[2] + 1;
                end
            if (bullet[3] != 0) begin
                x_bullet[3] = x_bullet[3] + 1;
                end
            if (bullet[4] != 0) begin
                x_bullet[4] = x_bullet[4] + 1;
                end
            if (bullet[5] != 0) begin
                x_bullet[5] = x_bullet[5] + 1;
                end
            if (bullet[6] != 0) begin
                x_bullet[6] = x_bullet[6] + 1;
                end
            if (bullet[7] != 0) begin
                x_bullet[7] = x_bullet[7] + 1;
                end
            if (bullet[8] != 0) begin
                x_bullet[8] = x_bullet[8] + 1;
                end
            if (bullet[9] != 0) begin
                x_bullet[9] = x_bullet[9] + 1;
                end
            end
            
        
        // bullets disappearing
        if (x_bullet[0] == 92) begin
            bullet[0] = 0;
            end
        if (x_bullet[1] == 92) begin
            bullet[1] = 0;
            end
        if (x_bullet[2] == 92) begin
            bullet[2] = 0;
            end
        if (x_bullet[3] == 92) begin
            bullet[3] = 0;
            end
        if (x_bullet[4] == 92) begin
            bullet[4] = 0;
            end
        if (x_bullet[5] == 92) begin
            bullet[5] = 0;
            end
        if (x_bullet[6] == 92) begin
            bullet[6] = 0;
            end
        if (x_bullet[7] == 92) begin
            bullet[7] = 0;
            end
        if (x_bullet[8] == 92) begin
            bullet[8] = 0;
            end
        if (x_bullet[9] == 92) begin
            bullet[9] = 0;
            end
            
        
        // player movement
        if (charging_meter != 10 && die == 0) begin
            counter_player_movement = counter_player_movement + 1;
            end
        
        if (counter_player_movement == 30000) begin
            counter_player_movement <= 0;
            if (LED_COUNT >= 5 && y_player != 2) begin
                y_player <= y_player - 1;
                end
            
            else if (LED_COUNT <= 4 && y_player != 32) begin
                y_player <= y_player + 1;
                end
            end
        /*if (LED_COUNT >= 0 && LED_COUNT <= 2) begin
            y_player <= 32;
            end
        else if (LED_COUNT >= 3 && LED_COUNT <= 5) begin
            y_player <= 24;
            end
        else if (LED_COUNT >= 6 && LED_COUNT <= 8) begin
            y_player <= 16;
            end
        else if (LED_COUNT >= 9 && LED_COUNT <= 12) begin
            y_player <= 9;
            end
        else if (LED_COUNT >= 13 && LED_COUNT <= 16) begin
            y_player <= 2;
            end */
    
        
        // charging mechanism
        if (y_player == 2 && charging_meter != 10 && lives != 0 && die == 0) begin
            counter_charging <= counter_charging + 1;
            
            if (counter_charging == 6250000) begin
                counter_charging <= 0;
                charging_meter <= charging_meter + 1;
                end
            end
            
            
        // success with blinking meter
        if (charging_meter == 10) begin
            counter_blinking <= counter_blinking + 1;
            
            if (counter_blinking == 4000000) begin
                counter_blinking <= 0;
                blink_seq_success <= blink_seq_success + 1;
                end
            
            if (blink_seq_success == 7) begin
                end_game <= 1;
                end
            end
        
        
        // timer to lose
        if (end_game == 0 && die == 0) begin
            counter_timer = counter_timer + 1;
            end
        
        if (counter_timer == 6250000 && end_game == 0 && die == 0) begin
            counter_timer = 0;
            timer = timer - 1;
            end
            
        if (timer == 0) begin
            die = 1;
            end
            
        
        // failure with blinking warning
        if (lives == 0) begin
            die = 1;
            end
            
        if (die == 1 && charging_meter != 0) begin
            counter_discharging <= counter_discharging + 1;
            
            if (counter_discharging == 3000000) begin
                counter_discharging <= 0;
                charging_meter <= charging_meter - 1;
                end
            end
            
        if (die == 1 && charging_meter == 0) begin
            counter_blinking <= counter_blinking + 1;
            
            if (counter_blinking == 4000000) begin
                counter_blinking <= 0;
                blink_seq_failure <= blink_seq_failure + 1;
                end
                
            if (blink_seq_failure == 7) begin
                lose <= 1;
                end_game <= 1;
                end
            end
            
    
        // pixel data
        if (bullet[9] != 0 && (X >= x_bullet[9] - 3 && X <= x_bullet[9]) && (Y == y_bullet[9])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[8] != 0 && (X >= x_bullet[8] - 3 && X <= x_bullet[8]) && (Y == y_bullet[8])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
        
        else if (bullet[7] != 0 && (X >= x_bullet[7] - 3 && X <= x_bullet[7]) && (Y == y_bullet[7])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[6] != 0 && (X >= x_bullet[6] - 3 && X <= x_bullet[6]) && (Y == y_bullet[6])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[5] != 0 && (X >= x_bullet[5] - 3 && X <= x_bullet[5]) && (Y == y_bullet[5])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[4] != 0 && (X >= x_bullet[4] - 3 && X <= x_bullet[4]) && (Y == y_bullet[4])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[3] != 0 && (X >= x_bullet[3] - 3 && X <= x_bullet[3]) && (Y == y_bullet[3])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[2] != 0 && (X >= x_bullet[2] - 3 && X <= x_bullet[2]) && (Y == y_bullet[2])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[1] != 0 && (X >= x_bullet[1] - 3 && X <= x_bullet[1]) && (Y == y_bullet[1])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
            
        else if (bullet[0] != 0 && (X >= x_bullet[0] - 3 && X <= x_bullet[0]) && (Y == y_bullet[0])) begin
            pixel_data <= 16'b11111_000000_00000;
            end
        
        else if ((y_player == 2) && (X >= x_player && X <= x_player + 8) && (Y >= y_player && Y <= 43)) begin
            pixel_data <= ((blink_seq_damage % 2 == 0) ? plug[(X-x_player) + (Y-y_player + 4)*9] : plug_damaged[(X-x_player) + (Y-y_player + 4)*9]);
            end
            
        else if ((y_player >= 3) && (X >= x_player && X <= x_player + 8) && (Y >= y_player && Y <= 43)) begin    
            pixel_data <= ((blink_seq_damage % 2 == 0) ? plug[(X-x_player) + (Y-y_player)*9] : plug_damaged[(X-x_player) + (Y-y_player)*9]);
            end
            
        else if ((X >= x_gun && X <= x_gun + 12) && (Y >= y_gun && Y <= y_gun + 6)) begin
            pixel_data <= gun[(X-x_gun) + (Y-y_gun)*13];
            end
           
        else if (charging_meter == 1 && (X >= 5 && X <= 11) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b11111_000000_00000;
            end
        
        else if (charging_meter == 2 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 3 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 4 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 5 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 6 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43) || (X >= 45 && X <= 51)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 7 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43) || (X >= 45 && X <= 51) || (X >= 53 && X <= 59)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 8 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43) || (X >= 45 && X <= 51) || (X >= 53 && X <= 59) || (X >= 61 && X <= 67)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 9 && ((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43) || (X >= 45 && X <= 51) || (X >= 53 && X <= 59) || (X >= 61 && X <= 67) || (X >= 69 && X <= 75)) && (Y >= 49 && Y <= 58)) begin
            pixel_data <= 16'b00000_111111_00000;
            end
            
        else if (charging_meter == 10 && ((((X >= 5 && X <= 11) || (X >= 13 && X <= 19) || (X >= 21 && X <= 27) || (X >= 29 && X <= 35) || (X >= 37 && X <= 43) || (X >= 45 && X <= 51) || (X >= 53 && X <= 59) || (X >= 61 && X <= 67) || (X >= 69 && X <= 75) || (X >= 77 && X <= 83)) && (Y >= 49 && Y <= 58)) || ((X >= 84 && X <= 88) && (Y >= 51 && Y <= 56)))) begin
            pixel_data <= ((blink_seq_success % 2 == 0) ? 16'b00000_111111_00000 : 16'b00000_000000_00000);
            end
        
        else if (charging_meter == 0 && (X >= 38 && X <= 56) && (Y >= 48 && Y <= 59)) begin
            pixel_data <= ((blink_seq_failure % 2 == 0) ? warning_sign[(X - 38) + (Y - 48)*19] : 16'b00000_000000_00000);
            end
        
        else if (X != 94 || X != 95) begin
            pixel_data <= charging_game_background[X+(Y*94)];
            end
        
        else begin
            pixel_data <= 16'b00000_000000_00000;
            end
        //Segment Display Coding
            case (lives)
                3:begin
                    seg_an2 <= 8'b1110_0011; //Letter L
                    seg_an3 <= 8'b0000_1101; //Number 3
                end
                2:begin
                    seg_an2 <= 8'b1110_0011; //Letter L
                    seg_an3 <= 8'b0010_0101; //Number 2             
                end
                1: begin
                    seg_an2 <= 8'b1110_0011; //Letter L
                    seg_an3 <= 8'b1001_1111; //Number 1             
                end
                0: begin
                    seg_an2 <= 8'b1110_0011; //Letter L
                    seg_an3 <= 8'b0000_0011; //Number 0            
                end
                default: begin
                    seg_an2 <= 8'b0000_0000;
                    seg_an3 <= 8'b0000_0000;            
                end 
            endcase
            
            case (timer)
                0:begin
                    seg_an1 <= 8'b0000_0011; //Number 0
                    seg_an0 <= 8'b0000_0011; //Number 0           
                end
                1:begin
                    seg_an1 <= 8'b0000_0011; //Number 0
                    seg_an0  <= 8'b1001_1111; //Number 1           
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
                
                
                
                20:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0000_0011; //Number 0       
                end
                21:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b1001_1111; //Number 1       
                end
                22:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0010_0101; //Number 2       
                end
                23:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0000_1101; //Number 3       
                end
                24:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b1001_1001; //Number 4       
                end
                25:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0100_1001; //Number 5      
                end
                26:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b1100_0001; //Number 6      
                end
                27:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0001_1111; //Number 7     
                end
                28:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0000_0001; //Number 8    
                end
                29:begin
                    seg_an1 <= 8'b0010_0101; //Number 2 
                    seg_an0 <= 8'b0001_1001; //Number 9    
                end
                30:begin
                    seg_an1 <= 8'b0000_1101; //Number 3 
                    seg_an0 <= 8'b0000_0011; //Number 0  
                end
                
                default:begin
                    seg_an1 <= 8'b0000_0000;
                    seg_an0 <= 8'b0000_0000;         
                end        
            endcase
        end
    end
endmodule

