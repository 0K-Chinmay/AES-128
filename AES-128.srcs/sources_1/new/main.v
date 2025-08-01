`timescale 1ns / 1ps

module main(
    input clkr,
    input rst,
    input start,
    output wire both_loaded,
  //  input en,
  //  input addr,  
    output reg done1,
    output reg [15:0] out16
);

wire done;
(* keep="true" *)reg [1:0]addr;
reg en;
//(* keep="true" *)wire [127:0] data_out;
(* keep="true" *)reg [127:0] temp_out;
(* dont_touch ="true" *)reg [127:0] data_in_reg, key_reg;
(* keep="true" *)reg [127:0] tempval;
reg data_loaded, key_loaded;

assign both_loaded = data_loaded & key_loaded & addr[1];

(* ram_style = "block" *)reg [127:0] bram [1:0];  

initial begin
    $readmemh("memory.mem", bram);
end

reg [3:0]coun;

always@(posedge clkr) begin
if(rst) begin
    en <= 0;
    addr <= 2;
    data_in_reg <= 0;
    key_reg <= 0;
    coun <= 0;
end else begin
    if(start && ~(addr == 3)) begin 
       en <= 1;
       coun <= coun + 1;
       if(addr == 2)begin
        addr <= 0;
       end if(addr == 0 && coun == 3) begin
        addr <= 1;
        key_reg <= tempval;
        coun <= 0;
    end
    end
    if(addr == 1 && coun == 3 ) begin 
       en <= 0;
       addr <= 3;
       data_in_reg <= tempval;
    end
end

end

// BRAM access and loading control
always @(posedge clkr) begin
    if (en) begin
        tempval <= bram[addr];
    end
end


/*always @(posedge clkr) begin
    if (rst) begin
        clk <= 0;
    end else begin
        clk <= clk + 1;
    end
end
*/



always @(posedge clkr) begin 
if(rst) begin
     data_loaded <= 0;
     key_loaded <= 0;
end else if(en) begin
       case (addr)
            1'b0: begin
                key_loaded <= 1;
            end
            1'b1: begin
                data_loaded <= 1;
            end
            default: begin
            end
        endcase
end

end

// AES encryption signals
(* keep="true" *)wire [127:0] key_s, key_s0, key_s1, key_s2, key_s3, key_s4, 
             key_s5, key_s6, key_s7, key_s8, key_s9;
(* keep="true" *)wire [127:0] r0_data_out;

(* keep="true" *) reg [127:0] r_data_out, key_ss;
wire [127:0] sub_out1; 
reg [127:0] sub_out2;
(* keep="true" *)reg [127:0] hamming;
(* keep="true" *)reg [127:0] map_it;

// Only start processing when both inputs are loaded
//assign r_data_out = both_loaded ? (data_in_reg ^ key_s) : 128'b0;

// AES key expansion (enabled only when both inputs are loaded)
aes_key_expand_128 a0(
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
);
reg rstn;
reg [3:0]counter;

always@(posedge clkr) begin 
     if(rst | r_data_out == 0) begin
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
     end
reg [1:0] state;
reg last;
reg start1;

always@(posedge clkr ) begin
 if(rst) begin
    state <= 0;
    r_data_out <= 0;
    rstn <= 1;
    start1 <= 0;
    temp_out <= 0;
    last <= 0;
    counter <= 0;
 end else begin
    state <= state ;
    case(state) 
       0: begin   
       if(both_loaded & ~last) begin 
          //start1 <= 1;
         r_data_out <= data_in_reg ^ key_s;
         rstn <= 1;
         state <= 1;
         end
       end
       1: begin
          rstn <= 0;
          start1 <= 1;
         if(finish) begin
          start1 <= 0;
          rstn <=1;
          counter <= counter + 1;
          state <= last ? 3 : 2;      
       end
       end
       2: begin                 
         r_data_out <= r0_data_out;         
         if(counter > 8) last <= 1;
         state <= 1; 
       end
       3: begin          
          temp_out <= r0_data_out;
          state <= 0;
       end

    endcase
 end
end

reg start2,start3;
always@(posedge clkr) begin
   start2 <= finish ? 0 : start1;
end

always@(posedge clkr) begin
   start3 <= finish ? 0 : start2;
end

// AES rounds (enabled only when both inputs are loaded)
round r0( clkr,rstn | ~both_loaded, r_data_out, key_ss, r0_data_out, sub_out1,last,finish);

always@(posedge clkr ) begin
   if(rst) begin
      sub_out2 <= 0;
   end else begin
      if(finish) sub_out2 <= sub_out1;
      else sub_out2 <= sub_out2;
   end
end


wire [7:0] bitflips;
(* keep="true" *)reg [127:0] switch;
//assign bitflips = hamming ^ map_it;
always@(posedge clkr) begin
    if(rst) map_it <= 0;
    else   
    if(finish)  map_it <= {
    sub_out1[90] ^ sub_out2[90], sub_out1[118] ^ sub_out2[118], sub_out1[127] ^ sub_out2[127], sub_out1[100] ^ sub_out2[100],
    sub_out1[127] ^ sub_out2[127], sub_out1[105] ^ sub_out2[105], sub_out1[117] ^ sub_out2[117], sub_out1[124] ^ sub_out2[124],
    sub_out1[111] ^ sub_out2[111], sub_out1[97] ^ sub_out2[97], sub_out1[117] ^ sub_out2[117], sub_out1[116] ^ sub_out2[116],
    sub_out1[98] ^ sub_out2[98], sub_out1[117] ^ sub_out2[117], sub_out1[127] ^ sub_out2[127], sub_out1[96] ^ sub_out2[96],
    sub_out1[119] ^ sub_out2[119], sub_out1[125] ^ sub_out2[125], sub_out1[124] ^ sub_out2[124], sub_out1[72] ^ sub_out2[72],
    sub_out1[104] ^ sub_out2[104], sub_out1[106] ^ sub_out2[106], sub_out1[120] ^ sub_out2[120], sub_out1[94] ^ sub_out2[94],
    sub_out1[118] ^ sub_out2[118], sub_out1[95] ^ sub_out2[95], sub_out1[63] ^ sub_out2[63], sub_out1[116] ^ sub_out2[116],
    sub_out1[98] ^ sub_out2[98], sub_out1[124] ^ sub_out2[124], sub_out1[63] ^ sub_out2[63], sub_out1[87] ^ sub_out2[87],
    sub_out1[92] ^ sub_out2[92], sub_out1[95] ^ sub_out2[95], sub_out1[76] ^ sub_out2[76], sub_out1[83] ^ sub_out2[83],
    sub_out1[76] ^ sub_out2[76], sub_out1[76] ^ sub_out2[76], sub_out1[104] ^ sub_out2[104], sub_out1[99] ^ sub_out2[99],
    sub_out1[94] ^ sub_out2[94], sub_out1[96] ^ sub_out2[96], sub_out1[86] ^ sub_out2[86], sub_out1[63] ^ sub_out2[63],
    sub_out1[83] ^ sub_out2[83], sub_out1[56] ^ sub_out2[56], sub_out1[74] ^ sub_out2[74], sub_out1[68] ^ sub_out2[68],
    sub_out1[67] ^ sub_out2[67], sub_out1[85] ^ sub_out2[85], sub_out1[64] ^ sub_out2[64], sub_out1[73] ^ sub_out2[73],
    sub_out1[70] ^ sub_out2[70], sub_out1[83] ^ sub_out2[83], sub_out1[69] ^ sub_out2[69], sub_out1[68] ^ sub_out2[68],
    sub_out1[65] ^ sub_out2[65], sub_out1[31] ^ sub_out2[31], sub_out1[65] ^ sub_out2[65], sub_out1[100] ^ sub_out2[100],
    sub_out1[76] ^ sub_out2[76], sub_out1[50] ^ sub_out2[50], sub_out1[106] ^ sub_out2[106], sub_out1[67] ^ sub_out2[67],
    sub_out1[94] ^ sub_out2[94], sub_out1[22] ^ sub_out2[22], sub_out1[54] ^ sub_out2[54], sub_out1[85] ^ sub_out2[85],
    sub_out1[65] ^ sub_out2[65], sub_out1[41] ^ sub_out2[41], sub_out1[57] ^ sub_out2[57], sub_out1[88] ^ sub_out2[88],
    sub_out1[65] ^ sub_out2[65], sub_out1[65] ^ sub_out2[65], sub_out1[53] ^ sub_out2[53], sub_out1[68] ^ sub_out2[68],
    sub_out1[28] ^ sub_out2[28], sub_out1[63] ^ sub_out2[63], sub_out1[26] ^ sub_out2[26], sub_out1[68] ^ sub_out2[68],
    sub_out1[58] ^ sub_out2[58], sub_out1[49] ^ sub_out2[49], sub_out1[70] ^ sub_out2[70], sub_out1[8] ^ sub_out2[8],
    sub_out1[51] ^ sub_out2[51], sub_out1[64] ^ sub_out2[64], sub_out1[36] ^ sub_out2[36], sub_out1[43] ^ sub_out2[43],
    sub_out1[16] ^ sub_out2[16], sub_out1[74] ^ sub_out2[74], sub_out1[3] ^ sub_out2[3], sub_out1[44] ^ sub_out2[44],
    sub_out1[18] ^ sub_out2[18], sub_out1[36] ^ sub_out2[36], sub_out1[30] ^ sub_out2[30], sub_out1[64] ^ sub_out2[64],
    sub_out1[36] ^ sub_out2[36], sub_out1[33] ^ sub_out2[33], sub_out1[13] ^ sub_out2[13], sub_out1[0] ^ sub_out2[0],
    sub_out1[16] ^ sub_out2[16], sub_out1[2] ^ sub_out2[2], sub_out1[15] ^ sub_out2[15], sub_out1[43] ^ sub_out2[43],
    sub_out1[22] ^ sub_out2[22], sub_out1[7] ^ sub_out2[7], sub_out1[22] ^ sub_out2[22], sub_out1[45] ^ sub_out2[45],
    sub_out1[2] ^ sub_out2[2], sub_out1[14] ^ sub_out2[14], sub_out1[5] ^ sub_out2[5], sub_out1[42] ^ sub_out2[42],
    sub_out1[4] ^ sub_out2[4], sub_out1[4] ^ sub_out2[4], sub_out1[11] ^ sub_out2[11], sub_out1[16] ^ sub_out2[16],
    sub_out1[3] ^ sub_out2[3], sub_out1[31] ^ sub_out2[31], sub_out1[29] ^ sub_out2[29], sub_out1[39] ^ sub_out2[39],
    sub_out1[7] ^ sub_out2[7], sub_out1[14] ^ sub_out2[14], sub_out1[6] ^ sub_out2[6], sub_out1[14] ^ sub_out2[14],
    sub_out1[27] ^ sub_out2[27], sub_out1[4] ^ sub_out2[4], sub_out1[19] ^ sub_out2[19], sub_out1[20] ^ sub_out2[20]
};
    else map_it <= map_it;
end

always@(posedge clkr) begin
    if(rst) hamming <= 0;
    else 
       if(finish) hamming <= sub_out1 ^ sub_out2;
       else hamming <= hamming;
end

countflips c1(
    .in(switch ),
    .count(bitflips)
);

compensation_ckt cc1(
    clkr,rst,start2,r_data_out[63:0],bitflips
    );

 //Hamming distance calculation*
 //Hamming distance calculation*
 always @(posedge clkr) begin
        if(rst) begin
           switch <= 0;
        end else begin
           if(finish) switch <= {
        sub_out1[90] ^ sub_out2[90], sub_out1[118] ^ sub_out2[118], sub_out1[127] ^ sub_out2[127], sub_out1[100] ^ sub_out2[100],
        sub_out1[127] ^ sub_out2[127], sub_out1[105] ^ sub_out2[105], sub_out1[117] ^ sub_out2[117], sub_out1[124] ^ sub_out2[124],
        sub_out1[111] ^ sub_out2[111], sub_out1[97] ^ sub_out2[97], sub_out1[117] ^ sub_out2[117], sub_out1[116] ^ sub_out2[116],
        sub_out1[98] ^ sub_out2[98], sub_out1[117] ^ sub_out2[117], sub_out1[127] ^ sub_out2[127], sub_out1[96] ^ sub_out2[96],
        sub_out1[119] ^ sub_out2[119], sub_out1[125] ^ sub_out2[125], sub_out1[124] ^ sub_out2[124], sub_out1[72] ^ sub_out2[72],
        sub_out1[104] ^ sub_out2[104], sub_out1[106] ^ sub_out2[106], sub_out1[120] ^ sub_out2[120], sub_out1[94] ^ sub_out2[94],
        sub_out1[118] ^ sub_out2[118], sub_out1[95] ^ sub_out2[95], sub_out1[63] ^ sub_out2[63], sub_out1[116] ^ sub_out2[116],
        sub_out1[98] ^ sub_out2[98], sub_out1[124] ^ sub_out2[124], sub_out1[63] ^ sub_out2[63], sub_out1[87] ^ sub_out2[87],
        sub_out1[92] ^ sub_out2[92], sub_out1[95] ^ sub_out2[95], sub_out1[76] ^ sub_out2[76], sub_out1[83] ^ sub_out2[83],
        sub_out1[76] ^ sub_out2[76], sub_out1[76] ^ sub_out2[76], sub_out1[104] ^ sub_out2[104], sub_out1[99] ^ sub_out2[99],
        sub_out1[94] ^ sub_out2[94], sub_out1[96] ^ sub_out2[96], sub_out1[86] ^ sub_out2[86], sub_out1[63] ^ sub_out2[63],
        sub_out1[83] ^ sub_out2[83], sub_out1[56] ^ sub_out2[56], sub_out1[74] ^ sub_out2[74], sub_out1[68] ^ sub_out2[68],
        sub_out1[67] ^ sub_out2[67], sub_out1[85] ^ sub_out2[85], sub_out1[64] ^ sub_out2[64], sub_out1[73] ^ sub_out2[73],
        sub_out1[70] ^ sub_out2[70], sub_out1[83] ^ sub_out2[83], sub_out1[69] ^ sub_out2[69], sub_out1[68] ^ sub_out2[68],
        sub_out1[65] ^ sub_out2[65], sub_out1[31] ^ sub_out2[31], sub_out1[65] ^ sub_out2[65], sub_out1[100] ^ sub_out2[100],
        sub_out1[76] ^ sub_out2[76], sub_out1[50] ^ sub_out2[50], sub_out1[106] ^ sub_out2[106], sub_out1[67] ^ sub_out2[67],
        sub_out1[94] ^ sub_out2[94], sub_out1[22] ^ sub_out2[22], sub_out1[54] ^ sub_out2[54], sub_out1[85] ^ sub_out2[85],
        sub_out1[65] ^ sub_out2[65], sub_out1[41] ^ sub_out2[41], sub_out1[57] ^ sub_out2[57], sub_out1[88] ^ sub_out2[88],
        sub_out1[65] ^ sub_out2[65], sub_out1[65] ^ sub_out2[65], sub_out1[53] ^ sub_out2[53], sub_out1[68] ^ sub_out2[68],
        sub_out1[28] ^ sub_out2[28], sub_out1[63] ^ sub_out2[63], sub_out1[26] ^ sub_out2[26], sub_out1[68] ^ sub_out2[68],
        sub_out1[58] ^ sub_out2[58], sub_out1[49] ^ sub_out2[49], sub_out1[70] ^ sub_out2[70], sub_out1[8] ^ sub_out2[8],
        sub_out1[51] ^ sub_out2[51], sub_out1[64] ^ sub_out2[64], sub_out1[36] ^ sub_out2[36], sub_out1[43] ^ sub_out2[43],
        sub_out1[16] ^ sub_out2[16], sub_out1[74] ^ sub_out2[74], sub_out1[3] ^ sub_out2[3], sub_out1[44] ^ sub_out2[44],
        sub_out1[18] ^ sub_out2[18], sub_out1[36] ^ sub_out2[36], sub_out1[30] ^ sub_out2[30], sub_out1[64] ^ sub_out2[64],
        sub_out1[36] ^ sub_out2[36], sub_out1[33] ^ sub_out2[33], sub_out1[13] ^ sub_out2[13], sub_out1[0] ^ sub_out2[0],
        sub_out1[16] ^ sub_out2[16], sub_out1[2] ^ sub_out2[2], sub_out1[15] ^ sub_out2[15], sub_out1[43] ^ sub_out2[43],
        sub_out1[22] ^ sub_out2[22], sub_out1[7] ^ sub_out2[7], sub_out1[22] ^ sub_out2[22], sub_out1[45] ^ sub_out2[45],
        sub_out1[2] ^ sub_out2[2], sub_out1[14] ^ sub_out2[14], sub_out1[5] ^ sub_out2[5], sub_out1[42] ^ sub_out2[42],
        sub_out1[4] ^ sub_out2[4], sub_out1[4] ^ sub_out2[4], sub_out1[11] ^ sub_out2[11], sub_out1[16] ^ sub_out2[16],
        sub_out1[3] ^ sub_out2[3], sub_out1[31] ^ sub_out2[31], sub_out1[29] ^ sub_out2[29], sub_out1[39] ^ sub_out2[39],
        sub_out1[7] ^ sub_out2[7], sub_out1[14] ^ sub_out2[14], sub_out1[6] ^ sub_out2[6], sub_out1[14] ^ sub_out2[14],
        sub_out1[27] ^ sub_out2[27], sub_out1[4] ^ sub_out2[4], sub_out1[19] ^ sub_out2[19], sub_out1[20] ^ sub_out2[20]
        }  ^   (sub_out1 ^ sub_out2);
          else switch <= switch;
    end 
end

initial $monitor("$$==%d",bitflips);
// Output logic

reg [3:0] i;
(* keep="true" *) wire [15:0] t1,t2,t3,t4,t5,t6,t7,t8;

assign t1 = temp_out[15:0];
assign t2 = temp_out[31:16];
assign t3 = temp_out[47:32];
assign t4 = temp_out[63:48];
assign t5 = temp_out[79:64];
assign t6 = temp_out[95:80];
assign t7 = temp_out[111:96];
assign t8 = temp_out[127:112];

always @(posedge clkr) begin
    if (rst) begin
        i <= 0;
        done1 <= 0;
        out16 <= 0;
    end else if (last) begin
        case(i) 
        1:out16 <= t1;
        2:out16 <= t2;
        3:out16 <= t3;
        4:out16 <= t4;
        5:out16 <= t5;
        6:out16 <= t6;
        7:out16 <= t7;
        8:out16 <= t8;
        default: out16 <= 0;
        endcase
        if(i > 9) begin 
        done1 <= 1;
        out16 <= 0;
        end
        i <= i + 1;
    end
end

endmodule
