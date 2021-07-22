`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): WEDNESDAY P.M
//
//  STUDENT A NAME: Tan Wei Li
//  STUDENT A MATRICULATION NUMBER: A0216235M
//
//  STUDENT B NAME: Tan Tze Yeong
//  STUDENT B MATRICULATION NUMBER: A0220778Y
//
//////////////////////////////////////////////////////////////////////////////////
module Top_Student (
    //OLed part
    input basys_clock, btnC, btnU, btnR, btnL, btnD, SW0, SW1, SW2, SW3, SW4, SW5,
    output pmodoledrgb_cs,
    output pmodoledrgb_sdin,
    output pmodoledrgb_sclk,
    output pmodoledrgb_d_cn,
    output pmodoledrgb_resn,
    output pmodoledrgb_vccen,
    output pmodoledrgb_pmoden,
    //Audio part
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4, // Connect to this signal from Audio_Capture.v
    output reg [15:0] led = 0,
    output [3:0] an,
    output reg [7:0] seg = 0,
    input SW15,
    input SW14,
    input SW13,
    //Dungeon part
    input SW10  
    );
    //Oled Part
    ///////////
    wire clk6p25m, clk12p5m, clk512hz, clk1000hz;
    wire btn_reset, btnC_SP, btnR_SP, btnL_SP, btnU_SP, btnD_SP;
    wire my_frame_begin;
    wire [12:0] my_pixel_index;
    wire my_sending_pixels;
    wire my_sample_pixel;
    
    wire [4:0] my_teststate;

    wire [6:0] x, y;
    
    wire [15:0] standard_oled_data;
    wire [15:0] dungeon_oled_data;
    wire [15:0] display_oled_data;
    assign display_oled_data = SW10 ? dungeon_oled_data : standard_oled_data;
    
    my_clock_divider unit_clock_6p25mhz(.basys_clock(basys_clock), .m_value(7), .my_clock(clk6p25m));
    
    my_clock_divider unit_clock_12p5mhz(.basys_clock(basys_clock), .m_value(3), .my_clock(clk12p5m));
    
    my_clock_divider unit_clock_512hz (.basys_clock(basys_clock), .m_value(97000), .my_clock(clk512hz));
    
    my_clock_divider unit_clock_1000hz (.basys_clock(basys_clock), .m_value(49999), .my_clock(clk1000hz));
    
    my_single_pulse unit_SP_reset (.basys_clock(basys_clock), .push_button(btnC), .my_SP_out (btn_reset));
    //6.25MHz to have same frequency as MainDungeonControl
    my_single_pulse unit_SP_btnC (.basys_clock(basys_clock), .push_button(btnC), .my_SP_out (btnC_SP));
    my_single_pulse unit_SP_btnL (.basys_clock(basys_clock), .push_button(btnL), .my_SP_out (btnL_SP));
    my_single_pulse unit_SP_btnR (.basys_clock(basys_clock), .push_button(btnR), .my_SP_out (btnR_SP));
    my_single_pulse unit_SP_btnU (.basys_clock(basys_clock), .push_button(btnU), .my_SP_out (btnU_SP));
    my_single_pulse unit_SP_btnD (.basys_clock(basys_clock), .push_button(btnD), .my_SP_out (btnD_SP));
    
    Oled_Display unit_OLED(
        .clk(clk6p25m), .reset(btn_reset), .frame_begin(my_frame_begin), 
        .sending_pixels(my_sending_pixels), .sample_pixel(my_sample_pixel), 
        .pixel_index(my_pixel_index), .pixel_data(display_oled_data), 
        .cs(pmodoledrgb_cs), .sdin(pmodoledrgb_sdin), 
        .sclk(pmodoledrgb_sclk), .d_cn(pmodoledrgb_d_cn), .resn(pmodoledrgb_resn), .vccen(pmodoledrgb_vccen),
        .pmoden(pmodoledrgb_pmoden), .teststate(my_teststate));

    coordinate_converter coordinate_unit (.my_clock(clk6p25m), .switch_right(SW3), .switch_left(SW4), .pixel_index(my_pixel_index), .x(x), .y(y));
    
    pixel_control control_unit (.LED(led), .my_clock(clk6p25m), .switch_border_size(SW0), .switch_colour_theme(SW1), .switch_volume_bar(SW2), .switch_right(SW3),
                   .switch_left(SW4), .switch_border(SW5), .X(x), .Y(y), .pixel_data(standard_oled_data));
    //Audio Part
    ///////////
    wire Outputof8Hz;
    my_clock_divider EightHzClock (basys_clock,6249999,Outputof8Hz);
    wire Outputof10Hz;
    my_clock_divider TenHzClock (basys_clock,4999999,Outputof10Hz);
    wire Outputof20KHz;
    my_clock_divider TwentyKHzClock (basys_clock,2499,Outputof20KHz);
    
    wire [11:0] mic_in;    
    reg [31:0] counter = 0;
    reg [11:0] peak = 0;
    reg [11:0] peak_output = 0;
    reg [11:0] sample_output = 0;  
    Audio_Capture audio_unit (basys_clock ,Outputof20KHz,J_MIC3_Pin3,J_MIC3_Pin1,J_MIC3_Pin4, mic_in);
    always @ (posedge Outputof20KHz) begin
        counter <= counter + 1;
        if (mic_in > peak)
            peak <= mic_in;
        if (counter == 2000) begin
            peak_output <= peak;
            counter <= 0;
            sample_output <= mic_in;
            peak <= 0;
        end
    end
    
    wire [7:0] seg_an3; //For segments
    wire [7:0] seg_an1; //It is ABCD_EFG.
    wire [7:0] seg_an0;
    wire [15:0] standard_reg_led;
    wire refresh_rate;
    assign refresh_rate = SW13 ? Outputof8Hz: Outputof10Hz;
    always @ (posedge clk6p25m) begin
        led = standard_reg_led;
    end
    SegmentDisplay Display1 (refresh_rate,SW14,peak_output,sample_output,standard_reg_led,seg_an3,seg_an1,seg_an0);
    
    //Dungeon
    wire [7:0] dungeon_seg_an3;
    wire [7:0] dungeon_seg_an2;
    wire [7:0] dungeon_seg_an1;
    wire [7:0] dungeon_seg_an0;
    MainDungeonControl Dungeon (clk6p25m,btnL_SP,btnU_SP,btnD_SP,btnR_SP,btnC_SP,SW10,x,y,dungeon_oled_data,mic_in, led,btnL,btnU,btnD,btnR,btnC,dungeon_seg_an3,dungeon_seg_an2,dungeon_seg_an1,dungeon_seg_an0);
    
    //////////
    wire Outputof50Hz;
    my_clock_divider FiftyHzClock (basys_clock,999999,Outputof50Hz);
    wire DFF_SW15;
    my_DFF DFF1 (Outputof50Hz,SW15,DFF_SW15);
    wire DFF_SW10; //For dungeon**********
    my_DFF DFF2 (Outputof50Hz,SW10,DFF_SW10); //For dungeon*********
    wire Outputof400Hz;
    my_clock_divider FourHundredHzClock (basys_clock,124999,Outputof400Hz);
    reg [3:0] anReg = 0;
    assign an = ~anReg;        
    always @ (posedge Outputof400Hz) begin
        if (anReg == 0)
            anReg = 4'b1000;
        else
            anReg = anReg >> 1;
        case (anReg)
            4'b1000: begin
                seg = DFF_SW10 ? dungeon_seg_an3 : ( DFF_SW15 ? 8'b1111_1111 : seg_an3 );
            end
            4'b0100: begin
                seg = DFF_SW10 ? dungeon_seg_an2 : 8'b1111_1111;
            end
            4'b0010: begin
                seg = DFF_SW10 ? dungeon_seg_an1 : seg_an1;
            end
            4'b0001: begin
                seg = DFF_SW10 ? dungeon_seg_an0 : seg_an0;
            end                                    
        endcase
    end
    //////////

endmodule