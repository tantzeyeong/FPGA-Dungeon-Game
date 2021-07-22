`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2021 22:28:14
// Design Name: 
// Module Name: SegmentDisplay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module SegmentDisplay(
    input refresh_rate, sw, input [11:0] peak_output, sample_output,
    output reg [15:0] reg_led = 0, output reg [7:0] seg_an3 = 0,seg_an1 = 0,seg_an0 = 0
    );
    wire [11:0] choice_of_output;
    assign choice_of_output = sw ? peak_output : sample_output;
    always @ (posedge refresh_rate) begin    
        if (choice_of_output >= 2048 && choice_of_output < 2176) begin
            reg_led <= 16'b0000_0000_0000_0001;
            seg_an3 <= 8'b1110_0011; //Letter L
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0000_0011; //Number 0
        end
        else if (choice_of_output >= 2176 && choice_of_output < 2304) begin
            reg_led <= 16'b0000_0000_0000_0011;
            seg_an3 <= 8'b1110_0011; //Letter L
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b1001_1111; //Number 1                      
        end
        else if (choice_of_output >= 2304 && choice_of_output < 2432) begin
            reg_led <= 16'b0000_0000_0000_0111;
            seg_an3 <= 8'b1110_0011; //Letter L
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0010_0101; //Number 2                         
        end
        else if (choice_of_output >= 2432 && choice_of_output < 2560) begin
            reg_led <= 16'b0000_0000_0000_1111;
            seg_an3 <= 8'b1110_0011; //Letter L
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0000_1101; //Number 3              
        end
        else if (choice_of_output >= 2560 && choice_of_output < 2688) begin
            reg_led <= 16'b0000_0000_0001_1111;
            seg_an3 <= 8'b1110_0011; //Letter L
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b1001_1001; //Number 4          
        end
        
            
        else if (choice_of_output >= 2688 && choice_of_output < 2816) begin
            reg_led <= 16'b0000_0000_0011_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0100_1001; //Number 5                       
        end
        else if (choice_of_output >= 2816 && choice_of_output < 2944) begin
            reg_led <= 16'b0000_0000_0111_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b1100_0001; //Number 6           
        end
        else if (choice_of_output >= 2944 && choice_of_output < 3072) begin
            reg_led <= 16'b0000_0000_1111_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0001_1111; //Number 7           
        end                           
        else if (choice_of_output >= 3072 && choice_of_output < 3200) begin
            reg_led <= 16'b0000_0001_1111_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0000_0001; //Number 8                         
        end                           
        else if (choice_of_output >= 3200 && choice_of_output < 3328) begin
            reg_led <= 16'b0000_0011_1111_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b0000_0011; //Number 0
            seg_an0 <= 8'b0001_1001; //Number 9            
        end                                                   
        else if (choice_of_output >= 3328 && choice_of_output < 3456) begin
            reg_led <= 16'b0000_0111_1111_1111;
            seg_an3 <= 8'b0101_0111; //Letter M
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b0000_0011; //Number 0            
        end   
        
                   
        else if (choice_of_output >= 3456 && choice_of_output < 3584) begin
            reg_led <= 16'b0000_1111_1111_1111;
            seg_an3 <= 8'b1001_0001; //Letter H
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b1001_1111; //Number 1            
        end                           
        else if (choice_of_output >= 3584 && choice_of_output < 3712) begin
            reg_led <= 16'b0001_1111_1111_1111;
            seg_an3 <= 8'b1001_0001; //Letter H
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b0010_0101; //Number 2            
        end                           
        else if (choice_of_output >= 3712 && choice_of_output < 3840) begin
            reg_led <= 16'b0011_1111_1111_1111;
            seg_an3 <= 8'b1001_0001; //Letter H
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b0000_1101; //Number 3             
        end                           
        else if (choice_of_output >= 3840 && choice_of_output < 3968) begin
            reg_led <= 16'b0111_1111_1111_1111;
            seg_an3 <= 8'b1001_0001; //Letter H
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b1001_1001; //Number 4             
        end                         
        else if (choice_of_output >= 3968 && choice_of_output < 4096) begin
            reg_led <= 16'b1111_1111_1111_1111;
            seg_an3 <= 8'b1001_0001; //Letter H
            seg_an1 <= 8'b1001_1111; //Number 1
            seg_an0 <= 8'b0100_1001; //Number 5            
        end
    end 
endmodule
