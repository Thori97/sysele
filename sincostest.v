`timescale 1ns / 1ps
module sincos_tb;

    reg [31:0] a, b;
    wire [31:0] out;
    sincos sincos (a, out);
initial begin

#10 a = 3.14;b = 2;
#10 a = 6.28;b = 2;
#10 a = 0.57;b = 2;
#10 $finish;
end
    
initial $monitor("a = %b, b = %b, out = %b\n", a, b, out);
endmodule