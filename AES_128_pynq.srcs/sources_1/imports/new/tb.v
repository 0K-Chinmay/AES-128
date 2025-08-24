`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 21:23:03
// Design Name: 
// Module Name: tb
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


module tb_mainD2;

    // Inputs
    reg clkr;
    reg rst;
    reg [127:0] data_in;
    reg [127:0] key;

    // Outputs
    wire [127:0] out16;
    wire done;
    // Instantiate the Unit Under Test (UUT)
    main uut (
        .clk(clkr),
        .rst(rst),
        .plaintext(data_in),
        .key(key),
        .ciphertext(out16),
        .done1(done)
    );

    // Clock generation
    always #5 clkr = ~clkr;  // 100 MHz clock
    reg [15:0] clk_counter;
    
    always@(posedge clkr) begin 
        if(!rst) clk_counter <= clk_counter + 1;
        else clk_counter <= 0;
    end

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
        wait(done);
        $display("total Clk cycles = %d", clk_counter);
        $display("Ciphertext = %x", out16);
        #20;
        // Finish simulation
        $finish;
    end
endmodule