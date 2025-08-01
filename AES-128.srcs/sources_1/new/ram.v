`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 08:35:38
// Design Name: 
// Module Name: ram
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


module ram(
    input clk,
    input en,
    input wire addr,
    output reg [127:0] data_out
    );
    
reg [127:0] bram [0:1];

initial begin
    $readmemh("memory.mem", bram);
end

always @(posedge clk) begin
   if (en) begin
      data_out <= bram[addr];
   $display("%x----",bram[addr]);
   end
end

endmodule
