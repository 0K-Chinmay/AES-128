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


module round(clk,rst,data_in,key_in,data_out,sub_out,last,finish);
input clk,rst;
input [127:0]data_in,key_in;
output reg [127:0] data_out;
output wire [127:0] sub_out;
input last;
output wire finish;

(* keep="true" *) wire [127:0]sub_data_out,mix_data_out;
(* keep="true" *) wire [127:0]shift_data_out; 
reg [127:0] data_in1;

assign sub_out=sub_data_out;

subbytes a1(clk & ~rst,data_in1,sub_data_out);
shiftrows a2(clk ,sub_data_out,shift_data_out);
mixcolumn a3(clk,rst,shift_data_out,mix_data_out,finish);

always@(posedge clk) begin
    if(rst != 0) begin
       data_in1 <= 0;
    end else begin
       data_in1 <= data_in;
    end

end

always@(posedge clk ) begin
    if(rst != 0) data_out <= 0;
    else 
        data_out <= last ? shift_data ^ key_in :  mix_data^key_in;
end
endmodule
