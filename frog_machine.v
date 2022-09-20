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


module frog_machine(
    input clk,
    input btnC,
    input btnU,
    input btnD,
    input btnR,
    
    input frame,
    input two_secs,
    input collide,
    
    input frog_active,
    input lily_pad1,
    input lily_pad2,
    input lily_pad3,
    
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

    assign idle = Q[0];
    assign go = Q[1];
    assign start = Q[2];
    assign up = Q[3];
    assign down = Q[4];
    assign center_fromUp = Q[5];
    assign center_fromDown = Q[6];
    assign death = Q[7];
    assign blink = (Q[7]) | (Q[1]);
   
    
    assign D[0] = (Q[0] & ~btnC);
    assign D[1] = (Q[0] & btnC) | (Q[7] & btnC) | (Q[1] & ~two_secs);
    assign D[2] = (Q[1] & two_secs) | (Q[2] & (~btnD & ~btnU & ~collide)) | (Q[5] & count_output == 10'd32) | (Q[6] & count_output == 10'd32);
    assign D[3] = (Q[2] & btnU) | (Q[3] & count_output != 10'd32 & ~collide);
    assign D[4] = (Q[2] & btnD) | (Q[4] & count_output != 10'd32 & ~collide);
    assign D[5] = (Q[3] & count_output == 10'd32) | (Q[5] & count_output != 10'd32 & ~collide);
    assign D[6] = (Q[4] & count_output == 10'd32) | (Q[6] & count_output != 10'd32 & ~collide);
    assign D[7] = ((Q[2] & collide) | (Q[3] & collide) | (Q[4] & collide) | (Q[5] & collide) | (Q[6] & collide) | (Q[7] & ~btnC));
    
    FDRE #(.INIT(1'b1) ) state1 (.C(clk), .CE(1'b1), .Q(Q[0]), .D(D[0]));
    FDRE #(.INIT(1'b0) ) state2 (.C(clk), .CE(1'b1), .Q(Q[1]), .D(D[1]));
    FDRE #(.INIT(1'b0) ) state3 (.C(clk), .CE(1'b1), .Q(Q[2]), .D(D[2]));
    FDRE #(.INIT(1'b0) ) state4 (.C(clk), .CE(1'b1), .Q(Q[3]), .D(D[3]));
    FDRE #(.INIT(1'b0) ) state5 (.C(clk), .CE(1'b1), .Q(Q[4]), .D(D[4]));
    FDRE #(.INIT(1'b0) ) state6 (.C(clk), .CE(1'b1), .Q(Q[5]), .D(D[5]));
    FDRE #(.INIT(1'b0) ) state7 (.C(clk), .CE(1'b1), .Q(Q[6]), .D(D[6]));
    FDRE #(.INIT(1'b0) ) state8 (.C(clk), .CE(1'b1), .Q(Q[7]), .D(D[7]));
    
    countUD10L frame_96 (.clk(clk), .enable(frame), .R(count_output == 10'd32 | (Q[2])), .Q(count_output));
        
endmodule







//    input clk,
//    input btnC,
//    input btnU,
//    input btnD,
//    input btnR,
//    input frame,

//    output idle,
//    output start,
//    output up,
//    output down,
//    output center_fromUp,
//    output center_fromDown
    
//    );
    
//    wire [5:0] D, Q;
//    wire [9:0] count_output;

//    assign idle = Q[0];
//    assign start = Q[1];
//    assign up = Q[2];
//    assign down = Q[3];
//    assign center_fromUp = Q[4];
//    assign center_fromDown = Q[5];
    
    
//    assign D[0] = (Q[0] & ~btnC);
//    assign D[1] = (Q[0] & btnC) | (Q[1] & (~btnD & ~btnU)) | (Q[4] & (count_output == 10'd32)) | (Q[5] & (count_output == 10'd32) );
//    assign D[2] = (Q[1] & btnU) | (Q[2] & (count_output != 10'd32));
//    assign D[3] = (Q[1] & btnD) | (Q[3] & (count_output != 10'd32));
//    assign D[4] = (Q[2] & (count_output == 10'd32)) | (Q[4] & (count_output != 10'd32)); 
//    assign D[5] = (Q[3] & (count_output == 10'd32)) | (Q[5] & (count_output != 10'd32));
    
//    FDRE #(.INIT(1'b1) ) state1 (.C(clk), .CE(1'b1), .Q(Q[0]), .D(D[0]));
//    FDRE #(.INIT(1'b0) ) state2 (.C(clk), .CE(1'b1), .Q(Q[1]), .D(D[1]));
//    FDRE #(.INIT(1'b0) ) state3 (.C(clk), .CE(1'b1), .Q(Q[2]), .D(D[2]));
//    FDRE #(.INIT(1'b0) ) state4 (.C(clk), .CE(1'b1), .Q(Q[3]), .D(D[3]));
//    FDRE #(.INIT(1'b0) ) state5 (.C(clk), .CE(1'b1), .Q(Q[4]), .D(D[4]));
//    FDRE #(.INIT(1'b0) ) state6 (.C(clk), .CE(1'b1), .Q(Q[5]), .D(D[5]));
    
//    countUD10L frame_96 (.clk(clk), .enable(frame), .R(count_output == 10'd32 | (Q[1])), .Q(count_output));
        
//endmodule
