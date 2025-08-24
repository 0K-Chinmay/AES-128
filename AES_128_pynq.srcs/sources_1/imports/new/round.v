`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2024 20:10:28
// Design Name: 
// Module Name: round
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


module round(clk,rst,data_in,key_in,data_out,last,finish);
input clk,rst;
input [127:0]data_in,key_in;
output [127:0] data_out;
input last;
output wire finish;

wire [127:0]sub_data_out,mix_data_out;
wire [127:0]shift_data_out;

subbytes a1(clk ,data_in,sub_data_out);
shiftrows a2(clk ,sub_data_out,shift_data_out);
mixcolumn a3(clk,rst,shift_data_out,mix_data_out,finish);



assign data_out = last ? shift_data_out ^ key_in :  mix_data_out^key_in;

endmodule