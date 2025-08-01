`timescale 1ns / 1ps

module tb_main();

// Inputs
reg clk;
reg rst;
reg en;
reg addr;  // Added address input
wire loaded;
// Outputs
wire done;
reg start;
wire [15:0] out16;

// Instantiate the Unit Under Test (UUT)
AES_LLm uut (
    .clkr(clk),      // Changed to match your main module's clk input name
    .rst(rst), 
    .both_loaded(loaded),
    .start(start),     // Added address connection
    .done1(done), 
    .out16(out16)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
end

// Test sequence
initial begin
    // Initialize inputs
    rst = 1;
    en = 0;
    start = 0;
    
    // Wait 100ns for global reset
    #100;
    start = 1;
    // Release reset
    rst = 0;
    
    // Load key (addr=0)
    //addr = 0;
    //en = 1;
    #10;
    $display("Time %0t: Loading key", $time);
    
    // Load data (addr=1)
    //addr = 1;
    #10;
    $display("Time %0t: Loading data", $time);
    
    // Keep enable high for processing
    // Wait for encryption to complete
    wait(done);
    $display("Time %0t: Encryption completed", $time);
    
    // Monitor the output
    $display("Output (16-bit chunks):");
    wait(done);
    #10;

    $finish;
end

// Monitor output changes
always @(posedge clk) begin
    if (done && out16 !== 16'bz) begin
        $display("Time %0t: out16 = %h", $time, out16);
    end
end

endmodule