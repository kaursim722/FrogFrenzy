`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2022 01:03:38 PM
// Design Name: 
// Module Name: top_mod
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


module top_mod(
    input clkin,
    input btnC,
    input btnU,
    input btnD,
    input btnR,
    input reset,
    input [9:0] x,
    input [9:0] y,
    input [15:0] sw,

    output HS,
    output VS,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led,
    output dp
   
    );
    
    wire clk;
    wire digsel;    
    
    wire idle_wire;
    wire start_wire;
    wire go_wire;
    wire up_wire;
    wire down_wire;
    wire cfu_wire;
    wire cfd_wire;
    wire death_wire;
    
    wire btnd_wire;
    wire btnu_wire;
    wire btnc_wire;
    wire btnr_wire;
    
    assign led[0] = idle_wire;
    assign led[1] = go_wire;
    assign led[2] = start_wire;
    assign led[3] = up_wire;
    assign led[4] = down_wire;
    assign led[5] = cfu_wire;
    assign led[6] = cfd_wire;
    assign led[7] = death_wire;

    
    wire HS_wire;
    wire VS_wire;
    wire frame;
    wire collide;
    wire blink;
    wire two_secs;
    wire [11:0] frame_two;
    
    countUD10L two_time (.clk(clk), .enable(frame & go_wire), .R(btnR | start_wire), .Q(frame_two));
    assign two_secs = frame_two[7];
    
    FDRE #(.INIT(1'b0) ) sync_D (.C(clk), .CE(1'b1), .Q(btnd_wire), .D(btnD));
    FDRE #(.INIT(1'b0) ) sync_U (.C(clk), .CE(1'b1), .Q(btnu_wire), .D(btnU));
    FDRE #(.INIT(1'b0) ) sync_R (.C(clk), .CE(1'b1), .Q(btnr_wire), .D(btnR));
    FDRE #(.INIT(1'b0) ) sync_C (.C(clk), .CE(1'b1), .Q(btnc_wire), .D(btnC));
    
    vga control (.clk(clk), .VS(VS), .HS(HS), .vgaRed(vgaRed), .vgaBlue(vgaBlue), .vgaGreen(vgaGreen),.btnC(btnC), .btnD(btnD), .btnU(btnU), .btnR(btnR), .idle(idle_wire), .start(start_wire), .up(up_wire), .down(down_wire), .center_fromUp(cfu_wire), .center_fromDown(cfd_wire), .frameBound_wire(frame), .collide(collide), .blink(blink), .death(death_wire), .go(go_wire));
        
    frog_machine frog (.clk(clk), .btnC(btnc_wire), .btnD(btnd_wire), .btnU(btnu_wire), .btnR(btnr_wire), .idle(idle_wire), .start(start_wire), .go(go_wire), .up(up_wire), .down(down_wire), .center_fromUp(cfu_wire), .center_fromDown(cfd_wire), .collide(collide), .death(death_wire), .frame(frame), .lily_pad1(lily_pad1), .lily_pad2(lily_pad2), .lily_pad3(lily_pad3), .frog_active(frog_active), .two_secs(two_secs));
    
    lab7_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));

endmodule
