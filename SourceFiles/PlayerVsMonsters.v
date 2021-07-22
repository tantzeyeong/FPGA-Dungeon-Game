`timescale 1ns / 1ps
module PlayerVsMonsters(input clock,btnL_SP,btnU_SP,btnD_SP,btnR_SP,btnC_SP,
    input [6:0] X, Y,
    output reg [15:0] pixel_data = 0,
    input start_game, //Will need to connect to an input to signal start of game
    input [11:0] mic_in, //To use a single sample of mic_in data for somewhat randomness
    output reg end_game = 0,
    output reg [7:0] seg_an3 = 0,seg_an2 = 0,seg_an1 = 0,seg_an0 = 0,
    output reg lose = 0
    );
    reg [31:0] counter_for_pulse = 0; //For 1khz pulse button signals
    reg [31:0] counter_for_spawn = 3250000;
    reg [31:0] counter_for_enemy_movement = 0;
    reg [31:0] counter_for_attack_duration = 0;
    reg [31:0] counter_for_got_hit = 0;
    reg [31:0] counter_for_enemy_speed = 400000;
    
    reg [1:0] player_lane = 0; //To identify which lane char is in
    reg [1:0] spawn_lane = 0; //To identify which lane enemy spawns
    reg enemy_alive = 0; //Identify if enemy is alive
    reg attack = 0; //Identify when player press btnR to attack
    reg got_hit = 0;
    reg [3:0] got_hit_pulse = 0;
    reg [3:0] health = 3;
    
    reg [3:0] kill_count = 0;
    
    reg [6:0] x_enemy, y_player = 0;
    reg [15:0] image_of_player [0:440];
    reg [15:0] image_of_enemy [0:440];
    reg [15:0] image_of_player_attack [0:1574];
    reg [15:0] image_background [0:6143];
    
    //To give the illusion of image_of_player is moving, can multiplex 2 images periodically
    
    initial begin
    $readmemb("Attack.txt",image_of_player_attack);
    $readmemb("EnemyCharacter.txt",image_of_enemy);
    $readmemb("PlayerCharacter.txt",image_of_player);
    $readmemb("TopGameBackground.txt",image_background);
    end  
    always @ (posedge clock) begin
        if (start_game == 0) begin
            end_game <= 0; //Internal Reset 
            health <= 3;
            kill_count <= 0;
            counter_for_enemy_speed <= 400000;
            lose <= 0;
        end
    
        if (start_game == 1) begin
            counter_for_pulse = counter_for_pulse + 1; //To sync single pulse btn inputs to 1khz working frequency
            counter_for_spawn = counter_for_spawn + 1;
            
            /////////   
            if (counter_for_pulse == 6250) begin
                counter_for_pulse <= 0;
                
                //Below 4 for moving up and down
                if (player_lane == 0 && btnD_SP == 1) begin
                    player_lane <= 1;
                    y_player <= 22;
                end
                else if (player_lane == 1 && btnD_SP == 1) begin
                    player_lane <= 2;
                    y_player <= 42;
                end
                else if (player_lane == 2 && btnU_SP == 1) begin
                    player_lane <= 1;
                    y_player <= 22;
                end    
                else if (player_lane == 1 && btnU_SP == 1) begin
                    player_lane <= 0;
                    y_player <= 0;
                end
                else if (btnR_SP) begin
                    attack = 1;
                end
                    
            end
            /////////   
            
            /////////
            if (counter_for_spawn > 6250000 && enemy_alive == 0) begin
                counter_for_spawn <= 0;
                enemy_alive <= 1;
                spawn_lane <= mic_in % 3;
                x_enemy <= 75;
            end
            /////////        
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
            /////////   
            if (X >= 0 && X <= 20 && Y >= (0+y_player) && Y <= (20+y_player))
                if (image_of_player[X+(Y-y_player)*21] == 16'b00000_111111_00000)
                    pixel_data <= image_background[X+(Y*96)];
                else
                    pixel_data <= (got_hit_pulse % 2) ? 16'b11111_000000_00000 : image_of_player[X+(Y-y_player)*21]; //Included got hit function
                
            else if (enemy_alive == 1) begin
                counter_for_enemy_movement <= counter_for_enemy_movement + 1;
                if (counter_for_enemy_movement == counter_for_enemy_speed) begin //Increased movement speed (31 March)
                    x_enemy <= x_enemy - 1;
                    counter_for_enemy_movement <= 0;
                end
                
                /////////
                if (X >= x_enemy && X <= (x_enemy + 20) && Y >= (spawn_lane*21) && Y <= (spawn_lane*21 + 20) && attack == 0)
                    if (image_of_enemy[(X-x_enemy)+(Y-spawn_lane*21)*21] == 16'b00000_111111_00000)
                        pixel_data <= image_background[X+(Y*96)];
                    else
                        pixel_data <= image_of_enemy[(X-x_enemy)+(Y-spawn_lane*21)*21];
                else if (X >= x_enemy && X <= (x_enemy + 20) && Y >= (spawn_lane*21) && Y <= (spawn_lane*21 + 20) && attack == 1 && spawn_lane != player_lane)   
                    if (image_of_enemy[(X-x_enemy)+(Y-spawn_lane*21)*21] == 16'b00000_111111_00000)
                        pixel_data <= image_background[X+(Y*96)];
                    else                    
                        pixel_data <= image_of_enemy[(X-x_enemy)+(Y-spawn_lane*21)*21];
                else if (attack == 1) begin
                    counter_for_attack_duration = counter_for_attack_duration + 1;                   
                    if (counter_for_attack_duration < 3125000 && X >= 21 && X <= 94 && Y >= (player_lane*21) && Y <= (player_lane*21 + 20) )
                        if (image_of_player_attack[(X-21) + (Y-player_lane*21)*75] == 16'b00000_111111_00000)
                            pixel_data <= image_background[X+(Y*96)];
                        else
                            pixel_data <= image_of_player_attack[(X-21) + (Y-player_lane*21)*75];
                        
                    else if (counter_for_attack_duration >= 3125000 && player_lane == spawn_lane) begin
                        counter_for_enemy_movement <= 0;
                        enemy_alive <= 0;
                        attack <= 0;
                        kill_count <= kill_count + 1;
                        counter_for_attack_duration <= 0;
                        counter_for_enemy_speed <= counter_for_enemy_speed - 50000;
                    end
                    else if (counter_for_attack_duration >= 3125000 && player_lane != spawn_lane) begin
                        attack <= 0;     
                        counter_for_attack_duration <= 0;              
                        end
                        
                    else 
                        pixel_data <= image_background[X+(Y*96)];
                end
                else
                    pixel_data <= image_background[X+(Y*96)];
                /////////
                if (x_enemy <= 21) begin //Included new got hit function
                    enemy_alive <= 0;
                    counter_for_pulse <= 0;
                    counter_for_spawn <= 0;
                    got_hit <= 1;
                    health <= health - 1;
                end
                if (kill_count == 6) begin
                    enemy_alive <= 0;
                    end_game <= 1;
                    counter_for_pulse <= 0;
                    counter_for_spawn <= 0;
                end
                else if (health == 0) begin
                    enemy_alive <= 0;
                    end_game <= 1;
                    counter_for_pulse <= 0;
                    counter_for_spawn <= 0;
                    lose <= 1;
                end
            end
                        
            else
                pixel_data <= image_background[X+(Y*96)];
            /////////   
            //Segment Display coding
            case (health)
            3: begin
                seg_an3 <= 8'b1110_0011; //Letter L
                seg_an2 <= 8'b0000_1101; //Number 3
            end
            2: begin
                seg_an3 <= 8'b1110_0011; //Letter L
                seg_an2 <= 8'b0010_0101; //Number 2           
            end
            1: begin
                seg_an3 <= 8'b1110_0011; //Letter L
                seg_an2 <= 8'b1001_1111; //Number 1             
            end
            0: begin
                seg_an3 <= 8'b1110_0011; //Letter L
                seg_an2 <= 8'b0000_0011; //Number 0            
            end
            default: begin
                seg_an3 <= 8'b0000_0000;
                seg_an2 <= 8'b0000_0000;            
            end 
            endcase
            
            case (kill_count)
            0: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b0000_0011; //Number 0
            end
            1: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b1001_1111; //Number 1        
            end
            2: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b0010_0101; //Number 2      
            end
            3: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b0000_1101; //Number 3 
            end
            4: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b1001_1001; //Number 4     
            end
            5: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b0100_1001; //Number 5  
            end 
            6: begin
                seg_an1 <= 8'b0110_0001; //Letter E
                seg_an0 <= 8'b1100_0001; //Number 6  
            end           
            default: begin
                seg_an1 <= 8'b0000_0000;
                seg_an0 <= 8'b0000_0000;            
            end        
            endcase                           
        end        
    end
endmodule