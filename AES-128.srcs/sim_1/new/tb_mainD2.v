`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 21:58:21
// Design Name: 
// Module Name: tb_mainD2
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


`timescale 1ns / 1ps

module tb_mainD2;

    // Inputs
    reg clkr;
    reg rst;
    reg [127:0] data_in;
    reg [127:0] key;

    // Outputs
    wire [127:0] out16;

    // Instantiate the Unit Under Test (UUT)
    mainD2 uut (
        .clkr(clkr),
        .rst(rst),
        .data_in(data_in),
        .key(key),
        .dataout(out16)
    );

    // Clock generation
    always #5 clkr = ~clkr;  // 100 MHz clock

    initial begin
        // Initialize Inputs
        clkr = 0;
        rst = 1;
        #300;
        data_in = 128'h68656c6c6f6f6b676f6f640000000000; // Example input
        key     = 128'h38333732393130323337343633373135; // Example key
                    
        // Apply reset
        #20;
        rst = 0;

        // Wait sufficient time for processing
        #200;
        #20;
        // Finish simulation
        $finish;
    end

endmodule

