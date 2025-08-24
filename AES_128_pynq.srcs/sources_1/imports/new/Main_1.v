`timescale 1ns / 1ps

module main(
    input clk,
    input rst,
    input [127:0] plaintext,
    input [127:0] key,
  //  input en,
  //  input addr,  
    output reg done1,
    output reg [127:0] ciphertext
);

wire done;
reg en;

// AES encryption signals
wire [127:0] key_s, key_s0, key_s1, key_s2, key_s3, key_s4, 
             key_s5, key_s6, key_s7, key_s8, key_s9;
wire [127:0] r0_data_out;

 reg [127:0] r_data_out;
 wire [127:0] key_ss;

// Only start processing when both inputs are loaded
//assign r_data_out = both_loaded ? (data_in_reg ^ key_s) : 128'b0;

// AES key expansion (enabled only when both inputs are loaded)
/*aes_key_expand_128 a0(
    .key(key_reg),
    .key_s0(key_s),
    .key_s1(key_s0),
    .key_s2(key_s1),
    .key_s3(key_s2),
    .key_s4(key_s3),
    .key_s5(key_s4),
    .key_s6(key_s5),
    .key_s7(key_s6),
    .key_s8(key_s7),
    .key_s9(key_s8),
    .key_s10(key_s9)
);*/
reg rstn;
reg [3:0]counter;
reg [127:0] key_reg;

Aes_key_expand_d2 a0(
    .clk(clk),
    .rst(rst),
    .counter(counter),
    .key(key_reg),
    .key_ss(key_ss)
);

/*always@(posedge clk) begin 
     if(rst != 0) begin
        key_ss <= 0;      
     end else
     case(counter) 
            // 0: key_ss <= key_s;
             0: key_ss <= key_s0;
             1: key_ss <= key_s1;
             2: key_ss <= key_s2;
             3: key_ss <= key_s3;
             4: key_ss <= key_s4;
             5: key_ss <= key_s5;
             6: key_ss <= key_s6;
             7: key_ss <= key_s7;
             8: key_ss <= key_s8;
             9: key_ss <= key_s9;
         endcase 
     end*/
reg [1:0] state;
reg last;
wire finish;

always@(posedge clk ) begin
 if(rst) begin
    state <= 0;
    r_data_out <= 0;
    rstn <= 1;
    last <= 0;
    done1 <= 0;
    counter <= 0;
 end else begin
    state <= state ;
    case(state) 
       0: begin
            key_reg <= key;
            state <= 1;
       end
       1: begin    
         r_data_out <= plaintext ^ key_reg;
         state <= 2;
       end
       2: begin
         rstn <= 0; 
         if(finish) begin
              rstn <=1;
              r_data_out <= r0_data_out;
              counter <= counter + 1;
              if(counter > 7) last <= 1;
              state <= last ? 3 : 2;      
         end
       end
       3: begin          
          ciphertext <= r_data_out;
          done1 <= 1;
       end
    endcase
 end
end


// AES rounds (enabled only when both inputs are loaded)
round r0( clk,rstn, r_data_out, key_ss, r0_data_out,last,finish);



endmodule