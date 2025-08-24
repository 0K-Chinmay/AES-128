`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 21:12:35
// Design Name: 
// Module Name: aes_rcon
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


module aes_rcon(out,out2,out3,out4,out5,out6,out7,out8,out9,out10);
output [7:0] out,out2,out3,out4,out5,out6,out7,out8,out9,out10;

assign	out  = 8'h01;
assign	out2 = 8'h02; 
assign	out3 = 8'h04;
assign	out4 = 8'h08;
assign	out5 = 8'h10;
assign	out6 = 8'h20;
assign	out7 = 8'h40; 
assign	out8 = 8'h80;
assign	out9 = 8'h1b;
assign	out10 = 8'h36;		 


endmodule




