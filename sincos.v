`timescale 1ns/1ps

module sincos(
    input [31:0]a,
    output [31:0]c
);
    assign c = $cos(a);
endmodule