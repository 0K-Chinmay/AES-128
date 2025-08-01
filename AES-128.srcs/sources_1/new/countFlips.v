`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2025 12:10:35
// Design Name: 
// Module Name: countFlips
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


module countflips (
    input  [127:0] in,
    output reg [7:0] count
);

    // Local temporary to accumulate in always_comb
    reg [7:0] temp_count;
    integer i;

    // Function to count 1s in 4-bit nibble
    generate
    function automatic [2:0] count_ones_4bit(input [3:0] nibble);
        case (nibble)
            4'b0000: count_ones_4bit = 3'd0;
            4'b0001, 4'b0010, 4'b0100, 4'b1000: count_ones_4bit = 3'd1;
            4'b0011, 4'b0101, 4'b1001, 4'b0110, 4'b1010, 4'b1100: count_ones_4bit = 3'd2;
            4'b0111, 4'b1011, 4'b1101, 4'b1110: count_ones_4bit = 3'd3;
            4'b1111: count_ones_4bit = 3'd4;
            default: count_ones_4bit = 3'd0;
        endcase
    endfunction
    endgenerate
    
    always@(*) begin
        temp_count = 0;
        for (i = 0; i < 32; i = i + 1) begin
            temp_count = temp_count + count_ones_4bit(in[i*4 +: 4]);
        end
        count = temp_count;
    end

endmodule
