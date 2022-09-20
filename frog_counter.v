`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 01:43:56 PM
// Design Name: 
// Module Name: countUD4L
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


module frog_counter(
    input clk,
    input enable,
    input R,
    input [9:0] offset_frog,
    output [9:0] Q
    //output UTC,
    //output DTC
    );
    
    wire [9:0] U;
    
    //assign UTC = Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5] & Q[6] & Q[7] & Q[8] & Q[8];
    //assign DTC = ~Q[0] & ~Q[1] & ~Q[2] & ~Q[3] & ~Q[4] & ~Q[5] & ~Q[6] & ~Q[7] & ~Q[8] & ~Q[9];
    
    FDRE #(.INIT(1'b0) ) Q0_FF (.C(clk), .R(R), .CE(enable), .Q(Q[0]), .D(U[0]));
    FDRE #(.INIT(1'b0) ) Q1_FF (.C(clk), .R(R), .CE(enable), .Q(Q[1]), .D(U[1]));
    FDRE #(.INIT(1'b0) ) Q2_FF (.C(clk), .R(R), .CE(enable), .Q(Q[2]), .D(U[2]));
    FDRE #(.INIT(1'b0) ) Q3_FF (.C(clk), .R(R), .CE(enable), .Q(Q[3]), .D(U[3]));
    FDRE #(.INIT(1'b0) ) Q4_FF (.C(clk), .R(R), .CE(enable), .Q(Q[4]), .D(U[4]));
    FDRE #(.INIT(1'b0) ) Q5_FF (.C(clk), .R(R), .CE(enable), .Q(Q[5]), .D(U[5]));
    FDRE #(.INIT(1'b0) ) Q6_FF (.C(clk), .R(R), .CE(enable), .Q(Q[6]), .D(U[6]));
    FDRE #(.INIT(1'b0) ) Q7_FF (.C(clk), .R(R), .CE(enable), .Q(Q[7]), .D(U[7]));
    FDRE #(.INIT(1'b0) ) Q8_FF (.C(clk), .R(R), .CE(enable), .Q(Q[8]), .D(U[8]));
    FDRE #(.INIT(1'b0) ) Q9_FF (.C(clk), .R(R), .CE(enable), .Q(Q[9]), .D(U[9]));
   
    // increment
    assign U[0] = Q[0] ^ enable;
    assign U[1] = Q[1] ^ (Q[0] & enable);                  // Q[1] XOR Q[0]
    assign U[2] = Q[2] ^ (Q[1] & Q[0] & enable);           // Q[2] XOR (Q[1] AND Q[0])
    assign U[3] = Q[3] ^ (Q[2] & Q[1] & Q[0] & enable);    // Q[3] XOR (Q[1] AND Q[0] AND Q[3])
    assign U[4] = Q[4] ^ (Q[3] & Q[2] & Q[1] & Q[0] & enable);
    assign U[5] = Q[5] ^ (Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable);
    assign U[6] = Q[6] ^ (Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable);
    assign U[7] = Q[7] ^ (Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable);
    assign U[8] = Q[8] ^ (Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable);
    assign U[9] = Q[9] ^ (Q[8] & Q[7] & Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable);
    
    assign offset_frog = Q + Q + Q;
    
    //decrement
    //assign D[0] = Q[0] ^ enable;
    //assign D[1] = Q[1] ^ (~Q[0] & enable);                              // Q[1] XOR Q[0]
    //assign D[2] = Q[2] ^ (~Q[1] & ~Q[0] & enable);                      // Q[2] XOR (Q[1] AND Q[0])
    //assign D[3] = Q[3] ^ (~Q[2] & ~Q[1] & ~Q[0] & enable);              // Q[3] XOR (Q[1] AND Q[0] AND Q[3])
    //assign D[4] = Q[4] ^ (~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);
    //assign D[5] = Q[5] ^ (~Q[4] & ~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);
    //assign D[6] = Q[6] ^ (~Q[5] & ~Q[4] & ~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);
    //assign D[7] = Q[7] ^ (~Q[6] & ~Q[5] & ~Q[4] & ~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);
    //assign D[8] = Q[8] ^ (~Q[7] & ~Q[6] & ~Q[5] & ~Q[4] & ~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);
    //assign D[9] = Q[9] ^ (~Q[8] & ~Q[7] & ~Q[6] & ~Q[5] & ~Q[4] & ~Q[3] & ~Q[2] & ~Q[1] & ~Q[0] & enable);

endmodule
