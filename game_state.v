`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2022 01:40:01 PM
// Design Name: 
// Module Name: frog_machine
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


module game_state(
    input clk,
    input btnC,
    input btnU,
    input btnD,
    input btnR,
    
    input frame,
    input two_secs,
    input collide,
    
    output idle,
    output go,
    output start,
    output up,
    output down,
    output center_fromUp,
    output center_fromDown,
    output death,
    output blink
    
    );
    
    wire [7:0] D, Q;
    wire [9:0] count_output;
    wire [9:0] blink_out;

    assign idle = Q[0];
    assign go = Q[1];
    assign start = Q[2];
    assign up = Q[3];
    assign down = Q[4];
    assign center_fromUp = Q[5];
    assign center_fromDown = Q[6];
    assign death = Q[7];
    //assign blink = (Q & D) | (Q[1]);
    assign collide = frog_active & (lily_pad1 | lily_pad2 | lily_pad3);
    
    assign D[0] = (Q[0] & ~btnC);
    assign D[1] = (Q[0] & btnC) | (Q[1] & ~two_secs) | (Q[7] & btnC);
    assign D[2] = (Q[1] & two_secs) | (Q[2] & (~btnD & ~btnU)) | (Q[5] & count_output == 10'd32) | (Q[5] & count_output == 10'd32);
    assign D[3] = (Q[2] & btnU) | (Q[3] & count_output != 10'd32);
    assign D[4] = (Q[2] & btnD) | (Q[4] & count_output != 10'd32);
    assign D[5] = (Q[3] & count_output == 10'd32) | (Q[5] & count_output != 10'd32);
    assign D[6] = (Q[4] & count_output == 10'd32) | (Q[6] & count_output != 10'd32);
    assign D[7] = ((Q[2] & collide) | (Q[3] & collide) | (Q[4] & collide) | (Q[5] & collide) | (Q[6] & collide) | (Q[7] & ~btnC));
    
    FDRE #(.INIT(1'b1) ) state1 (.C(clk), .CE(1'b1), .Q(Q[0]), .D(D[0]));
    FDRE #(.INIT(1'b0) ) state2 (.C(clk), .CE(1'b1), .Q(Q[1]), .D(D[1]));
    FDRE #(.INIT(1'b0) ) state3 (.C(clk), .CE(1'b1), .Q(Q[2]), .D(D[2]));
    FDRE #(.INIT(1'b0) ) state4 (.C(clk), .CE(1'b1), .Q(Q[3]), .D(D[3]));
    FDRE #(.INIT(1'b0) ) state5 (.C(clk), .CE(1'b1), .Q(Q[4]), .D(D[4]));
    FDRE #(.INIT(1'b0) ) state6 (.C(clk), .CE(1'b1), .Q(Q[5]), .D(D[5]));
    FDRE #(.INIT(1'b0) ) state7 (.C(clk), .CE(1'b1), .Q(Q[6]), .D(D[6]));
    FDRE #(.INIT(1'b0) ) state8 (.C(clk), .CE(1'b1), .Q(Q[7]), .D(D[7]));
    
    countUD10L frame_96 (.clk(clk), .enable(frame), .R(count_output == 10'd32 | (Q[1])), .Q(count_output));
    countUD10L blinker (.clk(clk), .enable(frame), .R(1'b0), .Q(blink_out));
        
endmodule
