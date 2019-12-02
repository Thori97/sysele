`timescale 1ns/1ps
//浮動小数点＊浮動小数点
module multiplier(
    input [31:0]a,
    input [31:0]b,
    output [31:0]c
);
    assign c[31] = a[31]^b[31];
    assign c[30:23] =  $signed(a[30:23]) + $signed(b[30:23]);
    assign c[22:0] = a[22:0]*b[22:0];

endmodule