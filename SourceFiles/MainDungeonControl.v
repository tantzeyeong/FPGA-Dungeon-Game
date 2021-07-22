`timescale 1ns / 1ps
module MainDungeonControl(input clock, btnL_SP,btnU_SP,btnD_SP,btnR_SP,btnC_SP, sw,
    input [6:0] X, Y, //Button inputs are single pulse clocked at 6.25MHz
    output reg [15:0] output_pixel_data = 0,
    input [11:0] mic_in,
    input [15:0] led,
    input btnL,btnU,btnD,btnR,btnC,
    output reg [7:0] dungeon_seg_an3,dungeon_seg_an2,dungeon_seg_an1,dungeon_seg_an0
    );
    ////////
    reg [15:0] center_room [0:6143];
    reg [15:0] top_room [0:6143];
    reg [15:0] left_room [0:6143];
    reg [15:0] right_room [0:6143];
    reg [15:0] bottom_room [0:6143];
    reg [15:0] win_room [0:6143];
    reg [15:0] you_lose [0:6143];
    reg [15:0] you_win [0:6143];
    initial begin
    $readmemb("CenterRoom.txt",center_room);
    $readmemb("TopRoom.txt",top_room);
    $readmemb("LeftRoom.txt",left_room);
    $readmemb("RightRoom.txt",right_room);
    $readmemb("BottomRoom.txt",bottom_room);
    $readmemb("WinRoom.txt",win_room);
    $readmemb("you_lose.txt",you_lose);
    $readmemb("you_win.txt",you_win);
    end
    reg [15:0] room_pixel_data = 0;
    ////////
    
    reg [13:0] counter_for_pulse = 0;
    reg [3:0] register_for_room_state = 4'b0000;// left_top_bottom_right
    
    ////////
    reg toproom_game_start = 0;
    wire toproom_game_end;
    wire [15:0] top_room_game_pixel_data;
    wire [7:0] toproom_seg_an3;
    wire [7:0] toproom_seg_an2;
    wire [7:0] toproom_seg_an1;
    wire [7:0] toproom_seg_an0;    
    wire toproom_lose;
    PlayerVsMonsters TopRoomGame(clock,btnL_SP,btnU_SP,btnD_SP,btnR_SP,btnC_SP, X, Y,
        top_room_game_pixel_data,toproom_game_start,mic_in,
       toproom_game_end, toproom_seg_an3,toproom_seg_an2,toproom_seg_an1,toproom_seg_an0, toproom_lose);
        
    reg bottom_game_start = 0;
    wire bottom_game_end;
    wire [15:0] bottom_game_pixel_data;
    wire [7:0] bottomroom_seg_an3;
    wire [7:0] bottomroom_seg_an2;
    wire [7:0] bottomroom_seg_an1;
    wire [7:0] bottomroom_seg_an0;
    wire bottomroom_lose;
    LaserGame BottomGame (clock,btnL,btnU,btnD,btnR,X,Y,bottom_game_pixel_data,bottom_game_start,mic_in,bottom_game_end,bottomroom_seg_an3,bottomroom_seg_an2,bottomroom_seg_an1,bottomroom_seg_an0,bottomroom_lose);
        
    reg left_game_start = 0;
    wire left_game_end;
    wire [15:0] left_game_pixel_data;
    wire [7:0] leftroom_seg_an3;
    wire [7:0] leftroom_seg_an2;
    wire [7:0] leftroom_seg_an1;
    wire [7:0] leftroom_seg_an0;
    wire leftroom_lose;
    tap_game LeftRoomGame(.my_6p25mhz_clock(clock), .start_game(left_game_start),  .btnU(btnU_SP), .btnD(btnD_SP), .btnL(btnL_SP), 
            .btnR(btnR_SP), .btnC(btnC_SP), .X(X), .Y(Y), .mic_in(mic_in), .pixel_data(left_game_pixel_data), .end_game(left_game_end), .seg_an3(leftroom_seg_an3), .seg_an2(leftroom_seg_an2), .seg_an1(leftroom_seg_an1), .seg_an0(leftroom_seg_an0), .lose(leftroom_lose) );
    
    reg right_game_start = 0;
    wire right_game_end;
    wire [15:0] right_game_pixel_data;
    wire [7:0] rightroom_seg_an3;
    wire [7:0] rightroom_seg_an2;
    wire [7:0] rightroom_seg_an1;
    wire [7:0] rightroom_seg_an0;
    wire rightroom_lose;
    charging_game RightRoomGame(.my_6p25mhz_clock(clock), .start_game(right_game_start),  .btnU(btnU_SP), .btnD(btnD_SP), .btnL(btnL_SP), 
       .btnR(btnR_SP), .btnC(btnC_SP), .X(X), .Y(Y), .LED(led), .mic_in(mic_in), .pixel_data(right_game_pixel_data), .end_game(right_game_end), .seg_an3(rightroom_seg_an3), .seg_an2(rightroom_seg_an2), .seg_an1(rightroom_seg_an1), .seg_an0(rightroom_seg_an0), .lose(rightroom_lose) );
    ////////
    
    reg win = 0;
    always @ (posedge clock) begin
        counter_for_pulse = counter_for_pulse + 1;
        if (sw == 1 && counter_for_pulse == 6250) begin //Ensures that correct switch(es) must be on for game to proceed
            counter_for_pulse <= 0;
            
            if ( (toproom_game_start ^ toproom_game_end) == 0 && 
                 (left_game_start ^ left_game_end) == 0 && 
                 (bottom_game_start ^ bottom_game_end) == 0 && 
                 (right_game_start ^ right_game_end) == 0
                 ) begin    
                //Below 4 is to move from center room to surrounding rooms
                if (register_for_room_state == 4'b0000 && btnL_SP == 1)
                    register_for_room_state <= 4'b1000;
                else if (register_for_room_state == 4'b0000 && btnU_SP == 1)
                    register_for_room_state <= 4'b0100;             
                else if (register_for_room_state == 4'b0000 && btnD_SP == 1)
                    register_for_room_state <= 4'b0010;
                else if (register_for_room_state == 4'b0000 && btnR_SP == 1)
                    register_for_room_state <= 4'b0001;
                    
                //Below 4 is to move from surrounding rooms back to center room        
                else if (register_for_room_state == 4'b1000 && btnR_SP == 1)
                    register_for_room_state <= 4'b0000;
                else if (register_for_room_state == 4'b0100 && btnD_SP == 1)
                    register_for_room_state <= 4'b0000;             
                else if (register_for_room_state == 4'b0010 && btnU_SP == 1)
                    register_for_room_state <= 4'b0000;
                else if (register_for_room_state == 4'b0001 && btnL_SP == 1)
                    register_for_room_state <= 4'b0000;
            //Below 4 is to activate games in each room 
                else if (register_for_room_state == 4'b1000 && btnL_SP == 1) begin       
                    left_game_start = 1;
                end
                else if (register_for_room_state == 4'b0100 && btnU_SP == 1) begin
                    toproom_game_start = 1;
                end             
                else if (register_for_room_state == 4'b0010 && btnD_SP == 1) begin
                    bottom_game_start = 1;            
                end
                else if (register_for_room_state == 4'b0001 && btnR_SP == 1) begin
                    right_game_start = 1;
                end
                else if (btnC_SP == 1) begin
                if ( {toproom_game_end,left_game_end, bottom_game_end, right_game_end} == 4'b1111 && register_for_room_state == 4'b0000) begin
                    win <= 1;
                    left_game_start = 0;
                    toproom_game_start = 0;
                    bottom_game_start = 0;
                    right_game_start = 0;                    
                end
                else begin
                    win <= 0;
                    left_game_start = 0;
                    toproom_game_start = 0;
                    bottom_game_start = 0;
                    right_game_start = 0;
                    register_for_room_state = 4'b0000;
                end
            end                  
        end
    end
        
        case (register_for_room_state)
            4'b0000:
                room_pixel_data <= win ? you_win[X+(Y*96)] : ( {toproom_game_end,left_game_end, bottom_game_end, right_game_end} == 4'b1111 ) ? win_room[X+(Y*96)] : center_room[X+(Y*96)];
            4'b1000:
                room_pixel_data <= left_room[X+(Y*96)];
            4'b0100:
                room_pixel_data <= top_room[X+(Y*96)];
            4'b0010:
                room_pixel_data <= bottom_room[X+(Y*96)];
            4'b0001:
                room_pixel_data <= right_room[X+(Y*96)];
        endcase
        
        output_pixel_data <= (toproom_lose == 1 || bottomroom_lose == 1 || leftroom_lose == 1 || rightroom_lose == 1) ? you_lose[X+(Y*96)] :
                             (toproom_game_start ^ toproom_game_end) ? top_room_game_pixel_data : 
                             (left_game_start ^ left_game_end) ? left_game_pixel_data : 
                             (right_game_start ^ right_game_end) ? right_game_pixel_data : 
                             (bottom_game_start ^ bottom_game_end) ? bottom_game_pixel_data : room_pixel_data;
                             
        dungeon_seg_an3 <= (toproom_game_start ^ toproom_game_end) ? toproom_seg_an3 : 
                            (left_game_start ^ left_game_end) ? leftroom_seg_an3 : 
                            (right_game_start ^ right_game_end) ? rightroom_seg_an3 : 
                            (bottom_game_start ^ bottom_game_end) ? bottomroom_seg_an3 : 8'b1111_1111;
                           
        dungeon_seg_an2 <= (toproom_game_start ^ toproom_game_end) ? toproom_seg_an2 : 
                            (left_game_start ^ left_game_end) ? leftroom_seg_an2 : 
                            (right_game_start ^ right_game_end) ? rightroom_seg_an2 : 
                            (bottom_game_start ^ bottom_game_end) ? bottomroom_seg_an2 : 8'b1111_1111;
                            
        dungeon_seg_an1 <= (toproom_game_start ^ toproom_game_end) ? toproom_seg_an1 : 
                            (left_game_start ^ left_game_end) ? leftroom_seg_an1 : 
                            (right_game_start ^ right_game_end) ? rightroom_seg_an1 : 
                            (bottom_game_start ^ bottom_game_end) ? bottomroom_seg_an1 : 8'b1111_1111;
                            
        dungeon_seg_an0 <= (toproom_game_start ^ toproom_game_end) ? toproom_seg_an0 : 
                            (left_game_start ^ left_game_end) ? leftroom_seg_an0 : 
                            (right_game_start ^ right_game_end) ? rightroom_seg_an0 : 
                            (bottom_game_start ^ bottom_game_end) ? bottomroom_seg_an0 : 8'b1111_1111;                                                           
    end
endmodule
