`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2025 10:53:23
// Design Name: 
// Module Name: compensation_ckt
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


module compensation_ckt(
input clk,rst,start,
input [63:0] in,
input [7:0] bitflips
    );
    
    (* keep = "true" *)reg [7:0] reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8;
    
    always@(posedge clk) begin
       if(rst) begin
           reg1 <= 0; 
       end else begin
           if(start)reg1 <= bitflips[0] ? ~in[63:56] : in[63:56] ;
           else reg1 <= reg1;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg2 <= 0; 
       end else begin
           if(start)reg2 <= bitflips[1] ? ~in[55:48] : in[55:48];
           else reg2 <= reg2;
       end
    end 
    
    always@(posedge clk) begin
       if(rst) begin
           reg3 <= 0; 
       end else begin
           if(start)reg3 <=  bitflips[2] ? ~in[47:40] : in[47:40];
           else reg3 <= reg3;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg4 <= 0; 
       end else begin
           if(start)reg4 <= bitflips[3] ? ~in[39:32] : in[39:32];
           else reg4 <= reg4;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg5 <= 0; 
       end else begin
           if(start)reg5 <= bitflips[4] ? ~in[31:24] : in[31:24];
           else reg5 <= reg5;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg6 <= 0; 
       end else begin
           if(start)reg6 <= bitflips[5] ? ~in[23:16] : in[23:16];
           else reg6 <= reg6;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg7 <= 0; 
       end else begin
           if(start)reg7 <= bitflips[6] ? ~in[15:8] : in[15:8];
           else reg7 <= reg7;
       end
    end 
    
        always@(posedge clk) begin
       if(rst) begin
           reg8 <= 0; 
       end else begin
           if(start)reg8 <= bitflips[7] ? ~in[7:0] : in[7:0];
           else reg8 <= reg8;
       end
    end 
    
    wire [127:0] tmp_out;
    wire [127:0] tmp_out1;
    
     sbox t0(reg1,tmp_out[127:120] );
     sbox t1(reg1,tmp_out[119:112] );
     sbox t2(reg1,tmp_out[111:104] );
     sbox t3(reg1,tmp_out[103:96] );   
     sbox t4(reg1,tmp_out[95:88] );
     sbox t5(reg1,tmp_out[87:80] );
     sbox t6(reg1,tmp_out[79:72] );
     sbox t7(reg1,tmp_out[71:64] );    
     sbox t8(reg1,tmp_out[63:56] );
     sbox t9(reg1,tmp_out[55:48] );
     sbox t10(reg1,tmp_out[47:40] );
     sbox t11(reg1,tmp_out[39:32] );     
     sbox t12(reg1,tmp_out[31:24] );
     sbox t13(reg1,tmp_out[23:16] );
     sbox t14(reg1,tmp_out[15:8] );
     sbox t15(reg1,tmp_out[7:0] );
     
     sbox t16(reg2,tmp_out1[127:120] );
     sbox t17(reg2,tmp_out1[119:112] );
     sbox t18(reg2,tmp_out1[111:104] );
     sbox t19(reg2,tmp_out1[103:96] );   
     sbox t20(reg2,tmp_out1[95:88] );
     sbox t21(reg2,tmp_out1[87:80] );
     sbox t22(reg2,tmp_out1[79:72] );
     sbox t23(reg2,tmp_out1[71:64] );    
     sbox t24(reg3,tmp_out1[63:56] );
     sbox t25(reg3,tmp_out1[55:48] );
     sbox t26(reg3,tmp_out1[47:40] );
     sbox t27(reg3,tmp_out1[39:32] );     
     sbox t28(reg4,tmp_out1[31:24] );
     sbox t29(reg4,tmp_out1[23:16] );
     sbox t30(reg5,tmp_out1[15:8] );
     sbox t31({reg6[7:4],reg7[7:5],reg8[7]},tmp_out1[7:0] );
    
    
endmodule
