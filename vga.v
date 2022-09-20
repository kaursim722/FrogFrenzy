`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2022 12:38:28 PM
// Design Name: 
// Module Name: vga
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


module vga(
    input clk,
    input btnL,
    input btnC,
    input btnU,
    input btnD,
    input btnR,

    input idle,
    input start,
    input up,
    input down,
    input center_fromUp,
    input center_fromDown,
    input death,
    input go,
    
    output HS,
    output VS,
    output [3:0] vgaRed, // 4 bit colors (12 in total)
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output frameBound_wire,
    output lily_pad1,
    output lily_pad2,
    output lily_pad3,
    output frog_active,
    output collide,
    output blink
    );

    wire [9:0] out_h;
    wire [9:0] out_v;
    
    wire active;
    assign frameBound_wire = out_h == 10'd642 & out_v == 10'd482;
    
    wire water;
    wire [3:0] deep_blue;
    wire [9:0] compute_diff;
    
    wire [9:0] plant_out;
    wire [9:0] blink_out;
    wire split;

    wire [9:0] movefrog_wire;
    wire [9:0] offset_frog;
    
    
    assign VS = out_v < 10'd489 | out_v > 10'd490;
    assign HS = out_h < 10'd655 | out_h > 10'd750;
    assign active = out_h <= 10'd639 & out_v <= 10'd479;
    assign compute_diff = (out_v - 10'd240);
    assign deep_blue = (4'hf - compute_diff[7:4]);
    assign water = out_v >= 10'd240 & out_h <= 10'd639;
    
    wire [9:0] upper_bound;
    wire [9:0] lower_bound;
    wire [9:0] frog_left;
    wire [9:0] frog_right;
    wire [9:0] wire_up_u;
    wire [9:0] wire_up_d;
    wire [9:0] wire_down_u;
    wire [9:0] wire_down_d;
    wire [9:0] cfu_wire_u;
    wire [9:0] cfu_wire_d;
    wire [9:0] cfd_wire_u;
    wire [9:0] cfd_wire_d;
    
    assign upper_bound = 10'd232;
    assign lower_bound = 10'd248;
    assign frog_left = 10'd120;
    assign frog_right = 10'd136;
    
    
    //up and center from up states
    assign wire_up_u = (up) ? upper_bound - offset_frog : center_fromUp ? ((upper_bound + offset_frog) - 10'd96): upper_bound;
    assign wire_up_d = (up) ? lower_bound - offset_frog : center_fromUp ? ((lower_bound + offset_frog) - 10'd96): lower_bound;
    //down and center from down state
    assign wire_down_u = (down) ? upper_bound + offset_frog : center_fromDown ? ((upper_bound - offset_frog) + 10'd96): upper_bound;
    assign wire_down_d = (down) ? lower_bound + offset_frog : center_fromDown ? ((lower_bound - offset_frog) + 10'd96): lower_bound;
    
    assign frog_active = 
    (up | center_fromUp | death) ? (out_h <= 10'd136 & out_h > 10'd120 & out_v >= wire_up_u & out_v < wire_up_d) 
    : (down | center_fromDown | death) ? (out_h < 10'd136 & out_h > 10'd120 & out_v >= wire_down_u & out_v < wire_down_d) 
    : (out_h < 10'd136 & out_h > 10'd120 & out_v >= upper_bound & out_v < lower_bound); 
    
    assign lily_pad1 = (out_h >= (10'd200 - plant_out - plant_out - plant_out)) & (out_h <= (10'd240 - plant_out - plant_out - plant_out)) & (out_v > 10'd190) & (out_v < 10'd286);
    assign lily_pad2 = (out_h >= (10'd440 - plant_out - plant_out - plant_out)) & (out_h <= (10'd480 - plant_out - plant_out - plant_out)) & (out_v > 10'd190) & (out_v < 10'd286);
    assign lily_pad3 = (out_h >= (10'd680 - plant_out - plant_out - plant_out)) & (out_h <= (10'd720 - plant_out - plant_out - plant_out)) & (out_v > 10'd190) & (out_v < 10'd286);
    
    assign split = ~blink_out[5];
    
    assign vgaRed = {4{active}} & ((frog_active) ? 10'hf & {4{split}} : 10'h0);
    assign vgaBlue = {4{active}} & ((frog_active)? 10'hf & {4{split}}: (water & ~lily_pad1 & ~lily_pad2 & ~lily_pad3) ? deep_blue : 10'h0);
    assign vgaGreen = {4{active}} & ((frog_active)? 10'hf & {4{split}}: lily_pad1 ? 10'hf : lily_pad2 ? 4'hf : lily_pad3 ? 10'hf : 10'h0);
    assign collide = frog_active & (lily_pad1 | lily_pad2 | lily_pad3);
    
    
   countUD10L vertical (.clk(clk), .enable(out_h == 10'd799), .R(out_v == 10'd524), .Q(out_v));
   countUD10L horizontal (.clk(clk), .enable(1'b1), .R(out_h > 10'd799), .Q(out_h));
   
   countUD10L plant_count (.clk(clk), .enable(frameBound_wire), .R(plant_out > 10'd79), .Q(plant_out));
   frog_counter frog (.clk(clk), .enable(frameBound_wire), .R(movefrog_wire == 10'd32 | start), .Q(movefrog_wire), .offset_frog(offset_frog));
   
   countUD10L blinker (.clk(clk), .enable(frameBound_wire & blink), .R(btnR | blink_out[7]), .Q(blink_out));
   
endmodule